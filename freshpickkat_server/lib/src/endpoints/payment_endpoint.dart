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
    return _pgPayments.markPaymentFailed(
      session,
      orderId,
      failureType: 'user_cancelled',
      failureReason: 'User cancelled payment',
    );
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

  Future<protocol.PaymentVerifyResult> completePaymentVerification(
    Session session,
    String orderId,
    String razorpayOrderId,
    String razorpayPaymentId,
  ) async {
    return _pgPayments.completePaymentVerification(
      session,
      orderNumber: orderId,
      razorpayOrderId: razorpayOrderId,
      razorpayPaymentId: razorpayPaymentId,
    );
  }

  Future<protocol.PaymentActionResult> getPaymentStatusWithMessage(
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
    return _pgPayments.getPaymentStatusWithMessage(session, orderId);
  }

  Future<protocol.PaymentActionResult> adminReconcileAllPendingPayments(
    Session session, {
    required String firebaseUid,
    required String idToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final result = await _pgPayments.reconcileAllPendingPayments(session);
    final recovered = result['recovered'] ?? 0;
    final failed = result['failed'] ?? 0;
    final skipped = result['skipped'] ?? 0;
    return protocol.PaymentActionResult(
      success: true,
      status: recovered > 0 ? 'recovered' : 'checked',
      message:
          'Checked all pending payments: $recovered recovered, '
          '$failed failed, $skipped skipped.',
    );
  }

  Future<Map<String, dynamic>> adminGetPaymentDetail(
    Session session,
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgPayments.getPaymentDetail(session, orderId);
  }

  Future<protocol.OrderPage> adminSearchOrders(
    Session session, {
    String? query,
    String? status,
    String? paymentStatus,
    required String firebaseUid,
    required String idToken,
    int limit = 20,
    String? pageToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgPayments.searchOrders(
      session,
      query: query,
      status: status,
      paymentStatus: paymentStatus,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<protocol.RazorpayPaymentStatus> adminGetLivePaymentStatus(
    Session session,
    String razorpayPaymentId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    try {
      final response = await _gateway.fetchPaymentStatus(razorpayPaymentId);
      if (response['statusCode'] != 200) {
        session.log(
          'Live payment status fetch failed for $razorpayPaymentId: '
          'statusCode=${response['statusCode']}, body=${response['body']}',
          level: LogLevel.error,
        );
        return protocol.RazorpayPaymentStatus(
          error: 'Failed to fetch payment status',
          body: response['body']?.toString(),
          statusCode: response['statusCode'],
        );
      }
      final data = response['data'] as Map<String, dynamic>;
      return protocol.RazorpayPaymentStatus(
        id: data['id'] as String?,
        status: data['status'] as String?,
        amount: data['amount'] as int?,
        currency: data['currency'] as String?,
        orderId: data['order_id'] as String?,
        method: data['method'] as String?,
        captured: data['captured'] as bool?,
        refundStatus: data['refund_status'] as String?,
        amountRefunded: data['amount_refunded'] as int?,
        fee: data['fee'] as int?,
        tax: data['tax'] as int?,
        bank: data['bank'] as String?,
        wallet: data['wallet'] as String?,
        vpa: data['vpa'] as String?,
        email: data['email'] as String?,
        contact: data['contact'] as String?,
        cardId: data['card_id'] as String?,
        acquirerData: data['acquirer_data']?.toString(),
        description: data['description'] as String?,
        notes: data['notes']?.toString(),
        errorCode: data['error_code'] as String?,
        errorDescription: data['error_description'] as String?,
        createdAt: data['created_at'] as int?,
      );
    } catch (e) {
      session.log(
        'Live payment status exception for $razorpayPaymentId: $e',
        level: LogLevel.error,
      );
      return protocol.RazorpayPaymentStatus(
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentOrderDetailHydrated>
  adminGetPaymentOrderDetailHydrated(
    Session session,
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgPayments.getPaymentOrderDetailHydrated(session, orderId);
  }

  Future<Map<String, dynamic>> adminGetRefundDetail(
    Session session,
    String orderId, {
    required String firebaseUid,
    required String idToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgPayments.getRefundDetail(session, orderId);
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
