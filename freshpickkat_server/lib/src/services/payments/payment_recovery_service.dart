import 'package:googleapis/firestore/v1.dart' as firestore_api;

import '../../generated/protocol.dart' as protocol;
import '../notification_service.dart';
import '../orders/order_document_mapper.dart';
import '../refunds/refund_service.dart';
import 'payment_firestore_service.dart';
import 'payment_gateway_service.dart';

class PaymentRecoveryService {
  PaymentRecoveryService({
    PaymentGatewayService? gateway,
    PaymentFirestoreService? store,
    OrderDocumentMapper? mapper,
  }) : gateway = gateway ?? PaymentGatewayService(),
       mapper = mapper ?? OrderDocumentMapper(),
       store = store ?? PaymentFirestoreService(mapper: mapper);

  final PaymentGatewayService gateway;
  final OrderDocumentMapper mapper;
  final PaymentFirestoreService store;
  final RefundService _refundService = RefundService();

  Future<protocol.PaymentVerifyResult> verifyAndFinalizePayment({
    required String orderId,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    bool signatureAlreadyTrusted = false,
    String source = 'client',
  }) async {
    try {
      final orderDoc = await store.getOrderDocument(orderId);
      if (orderDoc?.fields == null) {
        return protocol.PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Order not found',
        );
      }

      final order = mapper.fromFirestore(orderDoc!.fields!, orderId);
      await store.ensurePendingPaymentFromOrder(
        order: order,
        paymentId: razorpayPaymentId,
        amount: order.finalAmount,
        status: 'pending',
        razorpayOrderId: razorpayOrderId,
        signature: razorpaySignature,
        gatewayStatus: source,
      );

      if (order.razorpayOrderId != null &&
          order.razorpayOrderId!.isNotEmpty &&
          order.razorpayOrderId != razorpayOrderId) {
        await store.markPendingPaymentStatus(
          razorpayPaymentId,
          'failed',
          orderId: orderId,
          error: 'Razorpay order mismatch',
        );
        return protocol.PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Razorpay order mismatch',
        );
      }

      if (order.paymentStatus == 'paid') {
        await store.markPendingPaymentStatus(
          razorpayPaymentId,
          'recovered',
          orderId: orderId,
        );
        return protocol.PaymentVerifyResult(
          success: true,
          verified: true,
          message: 'Payment already verified',
        );
      }

      final shouldValidateSignature =
          !signatureAlreadyTrusted &&
          !gateway.isTestMode &&
          razorpaySignature.isNotEmpty;
      if (shouldValidateSignature) {
        final expectedSignature = gateway.generateSignature(
          razorpayOrderId,
          razorpayPaymentId,
          gateway.razorpayKeySecret,
        );
        if (expectedSignature != razorpaySignature) {
          await store.updateOrderFields(orderId, {
            'paymentStatus': firestore_api.Value(stringValue: 'failed'),
          });
          await store.markPendingPaymentStatus(
            razorpayPaymentId,
            'failed',
            orderId: orderId,
            error: 'Invalid payment signature',
          );
          return protocol.PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Invalid payment signature',
          );
        }
      }

      final updateFields = <String, firestore_api.Value>{
        'paymentStatus': firestore_api.Value(stringValue: 'paid'),
        'razorpayPaymentId': firestore_api.Value(
          stringValue: razorpayPaymentId,
        ),
        'razorpayOrderId': firestore_api.Value(stringValue: razorpayOrderId),
      };
      if (order.status == 'placed' || order.status == 'pending') {
        updateFields['status'] = firestore_api.Value(stringValue: 'confirmed');
        updateFields['confirmedAt'] = firestore_api.Value(
          timestampValue: DateTime.now().toUtc().toIso8601String(),
        );
      }
      await store.updateOrderFields(orderId, updateFields);
      await store.markPendingPaymentStatus(
        razorpayPaymentId,
        'recovered',
        orderId: orderId,
      );
      await _clearUserCart(order.userId);

      _notify(order: order, orderId: orderId);

      return protocol.PaymentVerifyResult(
        success: true,
        verified: true,
        message: 'Payment verified successfully',
      );
    } catch (e) {
      return protocol.PaymentVerifyResult(
        success: false,
        verified: false,
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentActionResult> recoverPendingPayments({
    String? userId,
    int limit = 20,
  }) async {
    try {
      final pendingPayments = await store.getPendingPayments(
        userId: userId,
        limit: limit,
      );

      var recoveredCount = 0;
      var failedCount = 0;

      for (final pending in pendingPayments) {
        final recovered = await _recoverSinglePendingPayment(pending);
        if (recovered == true) {
          recoveredCount++;
        } else if (recovered == false) {
          failedCount++;
        }
      }

      return protocol.PaymentActionResult(
        success: true,
        status: recoveredCount > 0 ? 'recovered' : 'checked',
        message:
            'Recovered $recoveredCount payment(s), failed $failedCount payment(s).',
      );
    } catch (e) {
      return protocol.PaymentActionResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentVerifyResult> handleWebhookPaidEvent({
    required String orderId,
    required String paymentId,
    required String razorpayOrderId,
  }) async {
    return verifyAndFinalizePayment(
      orderId: orderId,
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: paymentId,
      razorpaySignature: '',
      signatureAlreadyTrusted: true,
      source: 'webhook',
    );
  }

  Future<void> handleRefundWebhook({
    required String paymentId,
    required String status,
    String? gatewayRefundId,
  }) {
    return _refundService.updateRefundFromWebhook(
      paymentId: paymentId,
      status: status,
      gatewayRefundId: gatewayRefundId,
    );
  }

  Future<void> markPaymentFailed(
    String orderId, {
    String? paymentId,
    String? reason,
  }) async {
    await store.updateOrderFields(orderId, {
      'paymentStatus': firestore_api.Value(stringValue: 'failed'),
    });
    if (paymentId != null && paymentId.isNotEmpty) {
      await store.markPendingPaymentStatus(
        paymentId,
        'failed',
        orderId: orderId,
        error: reason,
      );
    }
  }

  Future<bool?> _recoverSinglePendingPayment(
    PendingPaymentRecord pending,
  ) async {
    try {
      var order = await store.getOrder(pending.orderId);
      if (order == null) {
        order = mapper.fromJsonString(pending.orderSnapshotJson);
        if (order != null) {
          await store.upsertOrder(order);
        }
      }

      if (order == null) {
        await _markFailedAndRefund(
          pending,
          'Order snapshot missing; unable to recreate order.',
        );
        return false;
      }

      if (order.paymentStatus == 'paid') {
        await store.markPendingPaymentStatus(
          pending.paymentId,
          'recovered',
          orderId: order.orderId,
        );
        return true;
      }

      final statusResponse = await gateway.fetchPaymentStatus(
        pending.paymentId,
      );
      final data = statusResponse['data'];
      final gatewayStatus = data is Map ? data['status']?.toString() ?? '' : '';
      final normalizedStatus = gatewayStatus.toLowerCase().trim();

      await store.updatePendingPaymentFields(
        pending.paymentId,
        {
          'gatewayStatus': firestore_api.Value(stringValue: gatewayStatus),
        },
      );

      if (normalizedStatus == 'captured' || normalizedStatus == 'authorized') {
        final result = await verifyAndFinalizePayment(
          orderId: order.orderId,
          razorpayOrderId:
              pending.razorpayOrderId ?? order.razorpayOrderId ?? '',
          razorpayPaymentId: pending.paymentId,
          razorpaySignature: pending.signature ?? '',
          signatureAlreadyTrusted:
              pending.signature == null ||
              pending.signature!.isEmpty ||
              normalizedStatus == 'captured' ||
              normalizedStatus == 'authorized',
          source: 'recovery',
        );
        return result.success == true && result.verified == true;
      }

      final nextRetry = pending.retryCount + 1;
      if (nextRetry >= 3) {
        await _markFailedAndRefund(
          pending,
          'Recovery failed after gateway status "$gatewayStatus".',
        );
        return false;
      }

      await store.markPendingPaymentStatus(
        pending.paymentId,
        'pending',
        orderId: pending.orderId,
        retryCount: nextRetry,
        error: 'Recovery retry $nextRetry for status "$gatewayStatus".',
      );
      return null;
    } catch (e) {
      final nextRetry = pending.retryCount + 1;
      if (nextRetry >= 3) {
        await _markFailedAndRefund(
          pending,
          'Recovery exception: $e',
        );
        return false;
      }
      await store.markPendingPaymentStatus(
        pending.paymentId,
        'pending',
        orderId: pending.orderId,
        retryCount: nextRetry,
        error: 'Recovery retry $nextRetry after exception: $e',
      );
      return null;
    }
  }

  Future<void> _markFailedAndRefund(
    PendingPaymentRecord pending,
    String reason,
  ) async {
    await store.markPendingPaymentStatus(
      pending.paymentId,
      'failed',
      orderId: pending.orderId,
      error: reason,
      retryCount: pending.retryCount + 1,
    );
    try {
      await _refundService.initiateRefund(
        orderId: pending.orderId,
        reason: 'recovery_failed',
      );
      await store.markPendingPaymentStatus(
        pending.paymentId,
        'refunded',
        orderId: pending.orderId,
      );
    } catch (_) {}
  }

  void _notify({
    required protocol.Order order,
    required String orderId,
  }) {
    final amount = order.finalAmount;
    final itemCount = order.itemCount == 0 ? null : order.itemCount;
    if (order.userId.isNotEmpty) {
      NotificationService.notifyUserPaymentSuccess(
        userId: order.userId,
        orderId: orderId,
        amount: amount,
        itemCount: itemCount,
      ).catchError((_) {});

      if (order.status == 'placed' || order.status == 'pending') {
        NotificationService.notifyUserStatusUpdate(
          userId: order.userId,
          orderId: orderId,
          status: 'confirmed',
        ).catchError((_) {});
      }
    }
    NotificationService.notifyAdminNewOrder(
      orderId: orderId,
      amount: amount,
      itemCount: itemCount,
    ).catchError((_) {});
  }

  Future<void> _clearUserCart(String userId) async {
    if (userId.isEmpty) return;
    await store.updateUserFields(userId, {
      'cart': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(values: []),
      ),
    });
  }
}
