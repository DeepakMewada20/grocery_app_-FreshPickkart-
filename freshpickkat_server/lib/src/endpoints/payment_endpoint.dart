// ignore_for_file: unused_field

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_payment_service.dart';
import '../services/postgres/postgres_refund_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';
import '../services/payments/payment_gateway_service.dart';

class PaymentEndpoint extends Endpoint {
  final PaymentGatewayService _gateway = PaymentGatewayService();
  final PostgresPaymentService _pgPayments = PostgresPaymentService();
  final PostgresRefundService _pgRefunds = PostgresRefundService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();

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
    String firebaseUid,
    String idToken,
  ) async {
    await _ensureOrderOwner(
      session,
      orderId: orderId,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgPayments.markPaymentFailed(session, orderId);
  }

  Future<protocol.PaymentActionResult> initiateRefund(
    Session session,
    String razorpayPaymentId,
    double amount,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgRefunds.initiateRefundByPaymentId(
      session,
      gatewayPaymentId: razorpayPaymentId,
      amount: amount,
    );
  }

  Future<protocol.PaymentActionResult> getPaymentStatus(
    Session session,
    String razorpayPaymentId,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      await _ensureOrderOwner(
        session,
        orderId: orderId,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
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
    required String idToken,
    int limit = 20,
  }) async {
    await _userGuard.ensureUser(
      session,
      firebaseUid: userId,
      idToken: idToken,
    );
    return _pgPayments.recoverPendingPayments(
      session,
      userId,
      limit: limit,
    );
  }

  Future<void> _ensureOrderOwner(
    Session session, {
    required String orderId,
    required String firebaseUid,
    required String idToken,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await protocol.CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderId.trim()),
    );
    if (order == null || order.userId != user.id) {
      throw Exception('Order does not belong to user.');
    }
  }
}
