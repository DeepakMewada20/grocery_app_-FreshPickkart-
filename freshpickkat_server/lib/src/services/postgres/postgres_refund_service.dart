import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../order_outbox_service.dart';
import '../payments/payment_gateway_service.dart';
import 'postgres_support.dart';

class PostgresRefundService {
  PostgresRefundService({PaymentGatewayService? gateway})
    : _gateway = gateway ?? PaymentGatewayService();

  final PaymentGatewayService _gateway;

  Future<RefundRecord> initiateRefund(
    Session session, {
    required String orderNumber,
  }) async {
    final order = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (order?.id == null) {
      throw Exception('Order not found.');
    }

    final payment = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(order!.id!),
    );
    if (payment?.id == null) {
      throw Exception('Payment transaction not found.');
    }

    return _initiateRefundForOrder(
      session,
      order: order!,
      payment: payment!,
      amount: order.finalAmount,
    );
  }

  Future<RefundRecord?> getRefundStatus(
    Session session,
    String orderNumber,
  ) async {
    final order = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (order?.id == null) return null;

    final refund = await _findLatestRefundForOrder(session, order!.id!);
    return refund == null ? null : _mapRefundRecord(refund, order.orderNumber);
  }

  Future<PaymentActionResult> initiateRefundByPaymentId(
    Session session, {
    required String gatewayPaymentId,
    required double amount,
  }) async {
    try {
      final payment = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.gatewayPaymentId.equals(gatewayPaymentId.trim()),
      );
      if (payment?.id == null) {
        return PaymentActionResult(
          success: false,
          error: 'Payment transaction not found',
        );
      }

      final order = await CustomerOrderRow.db.findById(
        session,
        payment!.orderId,
      );
      if (order == null) {
        return PaymentActionResult(
          success: false,
          error: 'Order not found',
        );
      }

      final refund = await _initiateRefundForOrder(
        session,
        order: order,
        payment: payment,
        amount: amount,
      );

      return PaymentActionResult(
        success: true,
        refundId: refund.gatewayRefundId ?? refund.refundId,
        amount: (refund.amount * 100).round(),
        status: refund.status,
        paymentId: gatewayPaymentId.trim(),
        message: 'Refund initiated successfully',
      );
    } catch (error) {
      return PaymentActionResult(
        success: false,
        error: error.toString(),
      );
    }
  }

  Future<void> handleRefundWebhook(
    Session session, {
    required String paymentId,
    required String status,
    String? gatewayRefundId,
  }) async {
    final payment = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.gatewayPaymentId.equals(paymentId.trim()),
    );
    if (payment?.id == null) return;

    final order = await CustomerOrderRow.db.findById(session, payment!.orderId);
    if (order == null) return;

    final normalizedStatus = _normalizeRefundStatus(status);
    final now = DateTime.now().toUtc();

    await session.db.transaction<void>((transaction) async {
      RefundRecordRow? refund;
      final normalizedRefundId = cleanNullableString(gatewayRefundId);
      if (normalizedRefundId != null) {
        refund = await RefundRecordRow.db.findFirstRow(
          session,
          where: (t) => t.gatewayRefundId.equals(normalizedRefundId),
          transaction: transaction,
        );
      }
      refund ??= await _findLatestRefundForOrder(
        session,
        order.id!,
        transaction: transaction,
      );

      if (refund == null) {
        refund = await RefundRecordRow.db.insertRow(
          session,
          RefundRecordRow(
            orderId: order.id!,
            paymentTransactionId: payment.id!,
            userId: payment.userId,
            gatewayRefundId: normalizedRefundId,
            amount: payment.amount,
            refundStatus: normalizedStatus,
            failureReason: normalizedStatus == 'failed'
                ? 'Gateway refund failed'
                : null,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      } else {
        refund = await RefundRecordRow.db.updateRow(
          session,
          refund.copyWith(
            gatewayRefundId: normalizedRefundId ?? refund.gatewayRefundId,
            refundStatus: normalizedStatus,
            failureReason: normalizedStatus == 'failed'
                ? 'Gateway refund failed'
                : null,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      }

      final paymentStatus = normalizedStatus == 'processed'
          ? 'refunded'
          : payment.paymentStatus;
      await PaymentTransactionRow.db.updateRow(
        session,
        payment.copyWith(
          paymentStatus: paymentStatus,
          gatewayStatus: normalizedStatus,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await CustomerOrderRow.db.updateRow(
        session,
        order.copyWith(
          paymentStatus: normalizedStatus == 'processed'
              ? 'refunded'
              : order.paymentStatus,
          refundStatus: normalizedStatus,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    });

    if (normalizedStatus == 'processed') {
      await OrderOutboxService.instance.enqueueRefundProcessed(
        session: session,
        orderId: order.orderNumber,
        userId: order.userId.toString(),
      );
    }
  }

  Future<RefundRecord> _initiateRefundForOrder(
    Session session, {
    required CustomerOrderRow order,
    required PaymentTransactionRow payment,
    required double amount,
  }) async {
    final gatewayPaymentId = cleanNullableString(payment.gatewayPaymentId);
    if (gatewayPaymentId == null) {
      throw Exception('Gateway payment id not found.');
    }

    final latest = await _findLatestRefundForOrder(session, order.id!);
    if (latest != null &&
        (latest.refundStatus == 'pending' ||
            latest.refundStatus == 'processed')) {
      return _mapRefundRecord(latest, order.orderNumber);
    }

    final amountInPaise = (amount * 100).round();
    final response = await _gateway.createRefund(
      paymentId: gatewayPaymentId,
      amountInPaise: amountInPaise,
      receipt: order.orderNumber,
      notes: {
        'order_id': order.orderNumber,
        'payment_id': gatewayPaymentId,
      },
    );

    final success =
        response['statusCode'] == 200 || response['statusCode'] == 201;
    final data = response['data'] is Map<String, dynamic>
        ? response['data'] as Map<String, dynamic>
        : null;
    final gatewayRefundId = data?['id']?.toString();
    final refundStatus = _normalizeRefundStatus(
      data?['status']?.toString() ?? (success ? 'processed' : 'failed'),
    );
    final failureReason = success ? null : response['body']?.toString();
    final now = DateTime.now().toUtc();

    final refund = await session.db.transaction<RefundRecordRow>((
      transaction,
    ) async {
      final row = await RefundRecordRow.db.insertRow(
        session,
        RefundRecordRow(
          orderId: order.id!,
          paymentTransactionId: payment.id!,
          userId: payment.userId,
          gatewayRefundId: gatewayRefundId,
          amount: amount,
          refundStatus: refundStatus,
          failureReason: failureReason,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      final nextPaymentStatus = refundStatus == 'processed'
          ? 'refunded'
          : payment.paymentStatus;
      await PaymentTransactionRow.db.updateRow(
        session,
        payment.copyWith(
          paymentStatus: nextPaymentStatus,
          gatewayStatus: refundStatus,
          updatedAt: now,
        ),
        transaction: transaction,
      );
      await CustomerOrderRow.db.updateRow(
        session,
        order.copyWith(
          paymentStatus: refundStatus == 'processed'
              ? 'refunded'
              : order.paymentStatus,
          refundStatus: refundStatus,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      return row;
    });

    final mapped = _mapRefundRecord(refund, order.orderNumber);
    await OrderOutboxService.instance.enqueueRefundProcessed(
      session: session,
      orderId: order.orderNumber,
      userId: order.userId.toString(),
    );
    return mapped;
  }

  Future<RefundRecordRow?> _findLatestRefundForOrder(
    Session session,
    UuidValue orderId, {
    Transaction? transaction,
  }) async {
    final rows = await RefundRecordRow.db.find(
      session,
      where: (t) => t.orderId.equals(orderId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 1,
      transaction: transaction,
    );
    return rows.isEmpty ? null : rows.first;
  }

  RefundRecord _mapRefundRecord(
    RefundRecordRow row,
    String orderNumber,
  ) {
    return RefundRecord(
      refundId: row.id!.toString(),
      orderId: orderNumber,
      paymentId: row.paymentTransactionId.toString(),
      userId: row.userId.toString(),
      amount: row.amount,
      status: row.refundStatus,
      gatewayRefundId: row.gatewayRefundId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  String _normalizeRefundStatus(String rawStatus) {
    final normalized = rawStatus.trim().toLowerCase();
    if (normalized == 'processed' || normalized == 'refunded') {
      return 'processed';
    }
    if (normalized == 'failed') {
      return 'failed';
    }
    return 'pending';
  }
}
