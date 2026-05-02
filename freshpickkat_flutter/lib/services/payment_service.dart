import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/services/appcache/payment_recovery_repository.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class PaymentCompletionResult {
  const PaymentCompletionResult({
    required this.isConfirmed,
    required this.isQueuedForRecovery,
    this.message,
  });

  final bool isConfirmed;
  final bool isQueuedForRecovery;
  final String? message;
}

class PaymentService {
  PaymentService._();

  static PaymentService get instance => Get.isRegistered<PaymentService>()
      ? Get.find<PaymentService>()
      : Get.put(PaymentService._(), permanent: true);

  final _client = ServerpodClient().client;
  final _repository = PaymentRecoveryRepository.instance;

  Future<PaymentOrderResult> startPayment({
    required String orderId,
    required double amount,
    required String customerPhone,
  }) {
    return _client.payment.createPaymentOrder(orderId, amount, customerPhone);
  }

  Future<PaymentVerifyResult> verifyPayment({
    required String orderId,
    required String razorpayOrderId,
    required String paymentId,
    required String signature,
  }) {
    return _client.payment.verifyPayment(
      orderId,
      razorpayOrderId,
      paymentId,
      signature,
    );
  }

  Future<PaymentCompletionResult> completeOrder({
    required String userId,
    required String orderId,
    required String paymentId,
    required String razorpayOrderId,
    required String signature,
    required double amount,
  }) async {
    final pendingRecord = PendingPaymentRecord(
      paymentId: paymentId,
      userId: userId,
      orderId: orderId,
      amount: amount,
      createdAt: DateTime.now().toUtc(),
      razorpayOrderId: razorpayOrderId,
      signature: signature,
    );

    await _repository.cachePendingPaymentLocally(pendingRecord);

    try {
      final verifyResult = await verifyPayment(
        orderId: orderId,
        razorpayOrderId: razorpayOrderId,
        paymentId: paymentId,
        signature: signature,
      );

      if (verifyResult.success == true && verifyResult.verified == true) {
        await _repository.removeLocalPendingPayment(paymentId);
        return const PaymentCompletionResult(
          isConfirmed: true,
          isQueuedForRecovery: false,
        );
      }

      return PaymentCompletionResult(
        isConfirmed: false,
        isQueuedForRecovery: true,
        message:
            verifyResult.message ??
            'Payment received. Recovery will finalize your order automatically.',
      );
    } catch (_) {
      return const PaymentCompletionResult(
        isConfirmed: false,
        isQueuedForRecovery: true,
        message:
            'Payment received. Recovery will finalize your order automatically.',
      );
    }
  }

  Future<void> markPaymentFailed(String orderId) async {
    final user = AuthController.instance.currentUser;
    if (user == null) throw Exception('Login required.');
    final idToken = await AuthController.instance.requireIdToken();
    await _client.payment.markPaymentFailed(orderId, user.uid, idToken);
  }

  Future<PaymentActionResult> fetchGatewayPaymentStatus(
    String paymentId,
    String orderId,
  ) async {
    final user = AuthController.instance.currentUser;
    if (user == null) throw Exception('Login required.');
    final idToken = await AuthController.instance.requireIdToken();
    return _client.payment.getPaymentStatus(
      paymentId,
      orderId,
      user.uid,
      idToken,
    );
  }

  Future<PaymentActionResult> initiateRefund({
    required String paymentId,
    required double amount,
  }) {
    throw UnsupportedError('Refund initiation is restricted to admin users.');
  }

  Future<PaymentActionResult> recoverPendingPayments({
    required String userId,
    int limit = 20,
  }) async {
    final idToken = await AuthController.instance.requireIdToken();
    return _client.payment.recoverPendingPayments(
      userId,
      idToken: idToken,
      limit: limit,
    );
  }
}
