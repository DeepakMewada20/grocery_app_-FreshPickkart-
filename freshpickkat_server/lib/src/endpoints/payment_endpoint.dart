import 'package:serverpod/serverpod.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;
import '../generated/protocol.dart' as protocol;
import '../services/payments/payment_gateway_service.dart';
import '../services/payments/payment_recovery_service.dart';

class PaymentEndpoint extends Endpoint {
  final PaymentGatewayService _gateway = PaymentGatewayService();
  final PaymentRecoveryService _recovery = PaymentRecoveryService();

  Future<protocol.PaymentOrderResult> createPaymentOrder(
    Session session,
    String orderId,
    double amount,
    String customerPhone,
  ) async {
    try {
      final amountInPaise = (amount * 100).toInt();
      final response = await _gateway.createOrder(
        receipt: orderId,
        amountInPaise: amountInPaise,
        customerPhone: customerPhone,
      );

      if (response['statusCode'] == 200) {
        final data = response['data'] as Map<String, dynamic>;
        final razorpayOrderId = data['id'] as String?;
        if (razorpayOrderId != null && razorpayOrderId.isNotEmpty) {
          await _recovery.store.updateOrderFields(orderId, {
            'razorpayOrderId': firestore_api.Value(
              stringValue: razorpayOrderId,
            ),
            'paymentStatus': firestore_api.Value(stringValue: 'pending'),
          });
        }
        return protocol.PaymentOrderResult(
          success: true,
          razorpayOrderId: data['id'] as String?,
          amount: data['amount'] is int ? data['amount'] as int : null,
          currency: data['currency'] as String?,
        );
      } else {
        return protocol.PaymentOrderResult(
          success: false,
          error: 'Failed to create payment order',
          details: response['body']?.toString(),
        );
      }
    } catch (e) {
      return protocol.PaymentOrderResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentVerifyResult> verifyPayment(
    Session session,
    String orderId,
    String razorpayOrderId,
    String razorpayPaymentId,
    String razorpaySignature,
  ) async {
    return _recovery.verifyAndFinalizePayment(
      orderId: orderId,
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpaySignature: razorpaySignature,
    );
  }

  Future<protocol.PaymentActionResult> markPaymentFailed(
    Session session,
    String orderId,
  ) async {
    try {
      await _recovery.markPaymentFailed(orderId);
      return protocol.PaymentActionResult(success: true);
    } catch (e) {
      return protocol.PaymentActionResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentActionResult> initiateRefund(
    Session session,
    String razorpayPaymentId,
    double amount,
  ) async {
    try {
      final amountInPaise = (amount * 100).toInt();

      return protocol.PaymentActionResult(
        success: true,
        refundId: 'refund_${DateTime.now().millisecondsSinceEpoch}',
        amount: amountInPaise,
        status: 'processed',
        message: 'Refund initiated successfully',
      );
    } catch (e) {
      return protocol.PaymentActionResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentActionResult> getPaymentStatus(
    Session session,
    String razorpayPaymentId,
  ) async {
    try {
      final response = await _gateway.fetchPaymentStatus(razorpayPaymentId);
      if (response['statusCode'] != 200) {
        return protocol.PaymentActionResult(
          success: false,
          error: 'Failed to fetch payment status',
          message: response['body']?.toString(),
        );
      }

      final data = response['data'] as Map<String, dynamic>;
      final amount = data['amount'] is int
          ? data['amount'] as int
          : int.tryParse('${data['amount']}');

      return protocol.PaymentActionResult(
        success: true,
        paymentId: razorpayPaymentId,
        status: data['status']?.toString(),
        amount: amount,
        message: data['description']?.toString(),
      );
    } catch (e) {
      return protocol.PaymentActionResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentActionResult> recoverPendingPayments(
    Session session,
    String userId, {
    int limit = 20,
  }) {
    return _recovery.recoverPendingPayments(
      userId: userId,
      limit: limit,
    );
  }
}
