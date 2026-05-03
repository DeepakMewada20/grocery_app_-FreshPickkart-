import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../notification_service.dart';
import '../payments/payment_gateway_service.dart';
import 'postgres_support.dart';

class PostgresPaymentService {
  PostgresPaymentService({PaymentGatewayService? gateway})
    : _gateway = gateway ?? PaymentGatewayService();

  final PaymentGatewayService _gateway;

  Future<PaymentOrderResult> createPaymentOrder(
    Session session,
    String orderNumber,
    double amount,
    String customerPhone,
  ) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentOrderResult(success: false, error: 'Order not found');
      }

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow!.id!),
      );
      if (paymentRow == null) {
        return PaymentOrderResult(
          success: false,
          error: 'Payment transaction not found',
        );
      }
      final resolvedOrderRow = orderRow!;

      final amountInPaise = (amount * 100).round();
      final response = await _gateway.createOrder(
        receipt: orderNumber,
        amountInPaise: amountInPaise,
        customerPhone: customerPhone,
      );

      if (response['statusCode'] != 200) {
        return PaymentOrderResult(
          success: false,
          error: 'Failed to create payment order',
          details: response['body']?.toString(),
        );
      }

      final data = response['data'] as Map<String, dynamic>;
      final razorpayOrderId = data['id']?.toString();
      final now = DateTime.now().toUtc();

      await PaymentTransactionRow.db.updateRow(
        session,
        paymentRow.copyWith(
          gatewayOrderId: razorpayOrderId,
          paymentStatus: 'pending',
          gatewayStatus: data['status']?.toString() ?? 'created',
          updatedAt: now,
        ),
      );
      await CustomerOrderRow.db.updateRow(
        session,
        resolvedOrderRow.copyWith(
          paymentStatus: 'pending',
          updatedAt: now,
        ),
      );

      return PaymentOrderResult(
        success: true,
        razorpayOrderId: razorpayOrderId,
        amount: data['amount'] is int ? data['amount'] as int : null,
        currency: data['currency']?.toString(),
      );
    } catch (error) {
      return PaymentOrderResult(
        success: false,
        error: error.toString(),
      );
    }
  }

  Future<PaymentVerifyResult> verifyPayment(
    Session session, {
    required String orderNumber,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Order not found',
        );
      }

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(orderRow!.id!),
      );
      if (paymentRow == null) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Payment transaction not found',
        );
      }
      final resolvedOrderRow = orderRow!;

      if (paymentRow.gatewayOrderId != null &&
          paymentRow.gatewayOrderId!.isNotEmpty &&
          paymentRow.gatewayOrderId != razorpayOrderId) {
        return PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Razorpay order mismatch',
        );
      }

      if (paymentRow.paymentStatus == 'paid' &&
          resolvedOrderRow.paymentStatus == 'paid') {
        return PaymentVerifyResult(
          success: true,
          verified: true,
          message: 'Payment already verified',
        );
      }

      final shouldValidate =
          !_gateway.isTestMode && razorpaySignature.trim().isNotEmpty;
      if (shouldValidate) {
        final expected = _gateway.generateSignature(
          razorpayOrderId,
          razorpayPaymentId,
          _gateway.razorpayKeySecret,
        );
        if (expected != razorpaySignature) {
          await markPaymentFailed(session, orderNumber);
          return PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Invalid payment signature',
          );
        }
      }

      final now = DateTime.now().toUtc();
      await PaymentTransactionRow.db.updateRow(
        session,
        paymentRow.copyWith(
          gatewayOrderId: razorpayOrderId,
          gatewayPaymentId: razorpayPaymentId,
          paymentStatus: 'paid',
          gatewayStatus: 'captured',
          paidAt: now,
          updatedAt: now,
        ),
      );
      await CustomerOrderRow.db.updateRow(
        session,
        resolvedOrderRow.copyWith(
          paymentStatus: 'paid',
          orderStatus: resolvedOrderRow.orderStatus == 'placed'
              ? 'confirmed'
              : resolvedOrderRow.orderStatus,
          confirmedAt: resolvedOrderRow.orderStatus == 'placed'
              ? now
              : resolvedOrderRow.confirmedAt,
          updatedAt: now,
        ),
      );

      await _finalizeSuccessfulPaymentSideEffects(
        session,
        order: resolvedOrderRow,
      );

      return PaymentVerifyResult(
        success: true,
        verified: true,
        message: 'Payment verified successfully',
      );
    } catch (error) {
      return PaymentVerifyResult(
        success: false,
        verified: false,
        error: error.toString(),
      );
    }
  }

  Future<PaymentActionResult> markPaymentFailed(
    Session session,
    String orderNumber,
  ) async {
    try {
      final orderRow = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(orderNumber),
      );
      if (orderRow?.id == null) {
        return PaymentActionResult(success: false, error: 'Order not found');
      }
      final resolvedOrderRow = orderRow!;

      final paymentRow = await PaymentTransactionRow.db.findFirstRow(
        session,
        where: (t) => t.orderId.equals(resolvedOrderRow.id!),
      );
      final now = DateTime.now().toUtc();

      await CustomerOrderRow.db.updateRow(
        session,
        resolvedOrderRow.copyWith(
          paymentStatus: 'failed',
          updatedAt: now,
        ),
      );
      if (paymentRow != null) {
        await PaymentTransactionRow.db.updateRow(
          session,
          paymentRow.copyWith(
            paymentStatus: 'failed',
            gatewayStatus: 'failed',
            updatedAt: now,
          ),
        );
      }

      return PaymentActionResult(success: true);
    } catch (error) {
      return PaymentActionResult(success: false, error: error.toString());
    }
  }

  Future<PaymentActionResult> recoverPendingPayments(
    Session session,
    String userReference, {
    int limit = 20,
  }) async {
    try {
      final appUser = await _resolveUser(session, userReference);
      if (appUser?.id == null) {
        return PaymentActionResult(
          success: true,
          status: 'checked',
          message: 'No pending payments',
        );
      }

      final rows = await PaymentTransactionRow.db.find(
        session,
        where: (t) =>
            t.userId.equals(appUser!.id!) & t.paymentStatus.equals('pending'),
        limit: clampPageLimit(limit, defaultLimit: 20, maxLimit: 50),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );

      var recovered = 0;
      var failed = 0;

      for (final row in rows) {
        final paymentId = cleanNullableString(row.gatewayPaymentId);
        if (paymentId == null) continue;

        final statusResult = await _gateway.fetchPaymentStatus(paymentId);
        final data = statusResult['data'];
        final status = data is Map<String, dynamic>
            ? data['status']?.toString().toLowerCase().trim()
            : null;

        final orderRow = await CustomerOrderRow.db.findById(
          session,
          row.orderId,
        );
        if (orderRow == null) continue;

        if (status == 'captured' || status == 'authorized') {
          final verifyResult = await verifyPayment(
            session,
            orderNumber: orderRow.orderNumber,
            razorpayOrderId: row.gatewayOrderId ?? '',
            razorpayPaymentId: paymentId,
            razorpaySignature: '',
          );
          if (verifyResult.success && verifyResult.verified) {
            recovered++;
          }
        } else if (status == 'failed' || status == 'refunded') {
          await markPaymentFailed(session, orderRow.orderNumber);
          failed++;
        }
      }

      return PaymentActionResult(
        success: true,
        status: recovered > 0 ? 'recovered' : 'checked',
        message: 'Recovered $recovered payment(s), failed $failed payment(s).',
      );
    } catch (error) {
      return PaymentActionResult(success: false, error: error.toString());
    }
  }

  Future<AppUserRow?> _resolveUser(
    Session session,
    String userReference,
  ) async {
    final parsedId = tryParseUuid(userReference);
    if (parsedId != null) {
      final byId = await AppUserRow.db.findById(session, parsedId);
      if (byId != null) return byId;
    }

    final trimmed = userReference.trim();
    if (trimmed.isEmpty) return null;
    return AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(trimmed),
    );
  }

  Future<void> _finalizeSuccessfulPaymentSideEffects(
    Session session, {
    required CustomerOrderRow order,
  }) async {
    await UserCartItemRow.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(order.userId),
    );

    final amount = order.finalAmount;
    final itemCount = order.itemCount == 0 ? null : order.itemCount;
    final userId = order.userId.toString();

    if (userId.isNotEmpty) {
      try {
        await NotificationService.notifyUserPaymentSuccess(
          session: session,
          userId: userId,
          orderId: order.orderNumber,
          amount: amount,
          itemCount: itemCount,
        );
      } catch (_) {}

      if (order.orderStatus == 'placed' || order.orderStatus == 'pending') {
        try {
          await NotificationService.notifyUserStatusUpdate(
            session: session,
            userId: userId,
            orderId: order.orderNumber,
            status: 'confirmed',
          );
        } catch (_) {}
      }
    }

    try {
      await NotificationService.notifyAdminNewOrder(
        orderId: order.orderNumber,
        amount: amount,
        itemCount: itemCount,
      );
    } catch (_) {}

    await _deductStockForOrderItems(session, order.id!);
  }

  Future<void> _deductStockForOrderItems(Session session, UuidValue orderId) async {
    try {
      final orderItems = await OrderItemRow.db.find(
        session,
        where: (t) => t.orderId.equals(orderId),
      );

      const unitConversions = <String, double>{
        'gm': 1.0, 'kg': 1000.0, 'litre': 1000.0, 'ml': 1.0, 'pc': 1.0, 'pack': 1.0,
      };

      for (final item in orderItems) {
        final product = await ProductRow.db.findById(session, item.productId);
        if (product == null || product.stock == null) continue;

        double deduction = 0;
        if (item.productVariantId != null) {
          final variant = await ProductVariantRow.db.findById(session, item.productVariantId!);
          if (variant != null) {
            final vUnit = variant.quantityUnit.toLowerCase();
            final pUnit = (product.stockUnit ?? product.baseUnit ?? 'unit').toLowerCase();
            final inGrams = variant.quantityValue * (unitConversions[vUnit] ?? 1.0);
            final inBase = inGrams / (unitConversions[pUnit] ?? 1.0);
            deduction = inBase * item.quantity;
          } else {
            deduction = item.quantity.toDouble();
          }
        } else {
          deduction = item.quantity.toDouble();
        }

        final newStock = product.stock! - deduction;
        bool shouldDisable = false;
        
        final bUnit = (product.baseUnit ?? 'unit').toLowerCase();
        final sUnit = (product.stockUnit ?? product.baseUnit ?? 'unit').toLowerCase();
        final minGrams = (product.baseQuantity ?? 0.0) * (unitConversions[bUnit] ?? 1.0);
        final minRequiredInStockUnit = minGrams / (unitConversions[sUnit] ?? 1.0);

        if (newStock <= 0 || newStock < minRequiredInStockUnit) {
          shouldDisable = true;
        }

        await ProductRow.db.updateRow(
          session,
          product.copyWith(
            stock: newStock < 0 ? 0 : newStock,
            status: shouldDisable ? 'inactive' : product.status,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }
    } catch (e) {
      session.log('Background stock deduction failed: $e', level: LogLevel.error);
    }
  }
}
