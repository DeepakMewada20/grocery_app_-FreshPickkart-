// ignore_for_file: unused_field

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_payment_service.dart';
import '../services/postgres/postgres_refund_service.dart';
import '../services/payments/payment_gateway_service.dart';

class PaymentEndpoint extends Endpoint {
  final PaymentGatewayService _gateway = PaymentGatewayService();
  final PostgresPaymentService _pgPayments = PostgresPaymentService();
  final PostgresRefundService _pgRefunds = PostgresRefundService();

  Future<protocol.PaymentOrderResult> createPaymentOrder(
    Session session,
    String orderId,
    double amount,
    String customerPhone,
  ) async {
    return _pgPayments.createPaymentOrder(
      session,
      orderId,
      amount,
      customerPhone,
    );
  }

  Future<protocol.PaymentVerifyResult> verifyPayment(
    Session session,
    String orderId,
    String razorpayOrderId,
    String razorpayPaymentId,
    String razorpaySignature,
  ) async {
    return _pgPayments.verifyPayment(
      session,
      orderNumber: orderId,
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
      razorpaySignature: razorpaySignature,
    );
  }

  Future<protocol.PaymentActionResult> markPaymentFailed(
    Session session,
    String orderId,
  ) async {
    return _pgPayments.markPaymentFailed(session, orderId);
  }

  Future<protocol.PaymentActionResult> initiateRefund(
    Session session,
    String razorpayPaymentId,
    double amount,
  ) async {
    return _pgRefunds.initiateRefundByPaymentId(
      session,
      gatewayPaymentId: razorpayPaymentId,
      amount: amount,
    );
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
  }) async {
    return _pgPayments.recoverPendingPayments(
      session,
      userId,
      limit: limit,
    );
  }
}
