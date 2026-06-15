import 'dart:math';

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
    final order = await _getOrder(session, orderNumber);
    return refund(
      session,
      orderNumber: order.orderNumber,
      amount: order.finalAmount,
      source: 'order',
      reason: 'Admin order refund',
    );
  }

  Future<RefundRecord> refund(
    Session session, {
    required String orderNumber,
    required double amount,
    required String source,
    required String reason,
    UuidValue? complaintId,
  }) async {
    final order = await _getOrder(session, orderNumber);
    final payment = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(order.id!),
    );
    if (payment?.id == null) {
      throw Exception('Payment transaction not found.');
    }

    return _initiateRefundForOrder(
      session,
      order: order,
      payment: payment!,
      amount: amount,
      source: source,
      reason: reason,
      complaintId: complaintId,
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
        return PaymentActionResult(success: false, error: 'Order not found');
      }

      final refund = await _initiateRefundForOrder(
        session,
        order: order,
        payment: payment,
        amount: amount,
        source: 'payment',
        reason: 'Payment refund',
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
      return PaymentActionResult(success: false, error: error.toString());
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
            source: 'webhook',
            reason: 'Gateway refund webhook',
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

      final totalRefunded = await _sumRefundsForOrder(
        session,
        order.id!,
        transaction: transaction,
      );
      final isFullyRefunded = totalRefunded >= order.finalAmount;
      await PaymentTransactionRow.db.updateRow(
        session,
        payment.copyWith(
          paymentStatus: normalizedStatus == 'processed' && isFullyRefunded
              ? 'refunded'
              : payment.paymentStatus,
          gatewayStatus: normalizedStatus,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await CustomerOrderRow.db.updateRow(
        session,
        order.copyWith(
          paymentStatus: normalizedStatus == 'processed' && isFullyRefunded
              ? 'refunded'
              : order.paymentStatus,
          refundStatus: normalizedStatus,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    });

    if (normalizedStatus == 'processed') {
      final refund = await _findLatestRefundForOrder(session, order.id!);
      await OrderOutboxService.instance.enqueueRefundProcessed(
        session: session,
        orderId: order.orderNumber,
        userId: order.userId.toString(),
        amount: refund?.amount ?? 0.0,
      );
    }
  }

  Future<CustomerOrderRow> _getOrder(
    Session session,
    String orderNumber,
  ) async {
    final order = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
    );
    if (order?.id == null) throw Exception('Order not found.');
    return order!;
  }

  Future<RefundRecord> _initiateRefundForOrder(
    Session session, {
    required CustomerOrderRow order,
    required PaymentTransactionRow payment,
    required double amount,
    required String source,
    required String reason,
    UuidValue? complaintId,
  }) async {
    if (amount <= 0) {
      throw Exception('Refund amount must be greater than zero.');
    }
    if (amount > order.finalAmount) {
      throw Exception(
        'Refund amount (${amount.toStringAsFixed(2)}) exceeds order amount (${order.finalAmount.toStringAsFixed(2)}).',
      );
    }
    final gatewayPaymentId = cleanNullableString(payment.gatewayPaymentId);
    if (gatewayPaymentId == null) {
      throw Exception('Gateway payment id not found.');
    }

    if (complaintId != null) {
      final existingForComplaint = await RefundRecordRow.db.findFirstRow(
        session,
        where: (t) =>
            t.complaintId.equals(complaintId) &
            (t.refundStatus.equals('pending') |
                t.refundStatus.equals('processed')),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );
      if (existingForComplaint != null) {
        return _mapRefundRecord(existingForComplaint, order.orderNumber);
      }
    }

    final alreadyRefunded = await _sumRefundsForOrder(session, order.id!);
    final remainingRefundable = max(0, order.finalAmount - alreadyRefunded);
    final cappedAmount = min(amount, remainingRefundable).toDouble();
    if (cappedAmount <= 0) {
      throw Exception('No refundable amount remains for this order.');
    }

    final amountInPaise = (cappedAmount * 100).round();
    final response = await _gateway.createRefund(
      paymentId: gatewayPaymentId,
      amountInPaise: amountInPaise,
      receipt: order.orderNumber,
      notes: {
        'order_id': order.orderNumber,
        'payment_id': gatewayPaymentId,
        'source': source,
        'reason': reason,
        if (complaintId != null) 'complaint_id': complaintId.toString(),
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
          amount: cappedAmount,
          refundStatus: refundStatus,
          source: source.trim().isEmpty ? 'order' : source.trim(),
          reason: reason.trim(),
          complaintId: complaintId,
          failureReason: failureReason,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      final totalRefunded =
          alreadyRefunded +
          (refundStatus == 'processed' || refundStatus == 'pending'
              ? cappedAmount
              : 0);
      final isFullyRefunded = totalRefunded >= order.finalAmount;
      await PaymentTransactionRow.db.updateRow(
        session,
        payment.copyWith(
          paymentStatus: refundStatus == 'processed' && isFullyRefunded
              ? 'refunded'
              : payment.paymentStatus,
          gatewayStatus: refundStatus,
          updatedAt: now,
        ),
        transaction: transaction,
      );
      await CustomerOrderRow.db.updateRow(
        session,
        order.copyWith(
          paymentStatus: refundStatus == 'processed' && isFullyRefunded
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
      amount: cappedAmount,
    );

    if (refund.refundStatus == 'failed') {
      final errorMsg = refund.failureReason ?? 'Refund failed at payment gateway';
      session.log(
        'Refund failed for order ${order.orderNumber}: $errorMsg',
        level: LogLevel.error,
      );
    }

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

  Future<double> _sumRefundsForOrder(
    Session session,
    UuidValue orderId, {
    Transaction? transaction,
  }) async {
    final rows = await RefundRecordRow.db.find(
      session,
      where: (t) =>
          t.orderId.equals(orderId) &
          (t.refundStatus.equals('pending') |
              t.refundStatus.equals('processed')),
      transaction: transaction,
    );
    return rows.fold<double>(0, (sum, row) => sum + row.amount);
  }

  RefundRecord _mapRefundRecord(RefundRecordRow row, String orderNumber) {
    return RefundRecord(
      refundId: row.id!.toString(),
      orderId: orderNumber,
      paymentId: row.paymentTransactionId.toString(),
      userId: row.userId.toString(),
      amount: row.amount,
      status: row.refundStatus,
      gatewayRefundId: row.gatewayRefundId,
      source: row.source,
      reason: row.reason,
      complaintId: row.complaintId?.toString(),
      failureReason: row.failureReason,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  String _normalizeRefundStatus(String rawStatus) {
    final normalized = rawStatus.trim().toLowerCase();
    if (normalized == 'processed' || normalized == 'refunded') {
      return 'processed';
    }
    if (normalized == 'failed') return 'failed';
    return 'pending';
  }

  Future<RefundRecord?> getRefundByComplaintId(
    Session session,
    String complaintId,
  ) async {
    final id = tryParseUuid(complaintId);
    if (id == null) return null;
    final row = await RefundRecordRow.db.findFirstRow(
      session,
      where: (t) => t.complaintId.equals(id),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    if (row == null) return null;
    final order = await CustomerOrderRow.db.findById(session, row.orderId);
    return _mapRefundRecord(row, order?.orderNumber ?? '');
  }
}
