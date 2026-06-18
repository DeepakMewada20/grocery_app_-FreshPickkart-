import 'dart:async';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/services/appcache/payment_recovery_repository.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class PaymentService {
  PaymentService._();

  static PaymentService get instance => Get.isRegistered<PaymentService>()
      ? Get.find<PaymentService>()
      : Get.put(PaymentService._(), permanent: true);

  final _client = ServerpodClient().client;
  final _repository = PaymentRecoveryRepository.instance;

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

  Future<bool> completeOrder({
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
        return true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> markPaymentFailed(String orderId) async {
    final user = AuthController.instance.currentUser;
    if (user == null) throw Exception(ErrorMessages.loginRequired);
    final idToken = await AuthController.instance.requireIdToken();
    await _client.payment.markPaymentFailed(orderId, user.uid, idToken);
  }

  Future<PaymentActionResult> fetchGatewayPaymentStatus(
    String paymentId,
    String orderId,
  ) async {
    final user = AuthController.instance.currentUser;
    if (user == null) throw Exception(ErrorMessages.loginRequired);
    final idToken = await AuthController.instance.requireIdToken();
    return _client.payment.getPaymentStatus(
      paymentId,
      orderId,
      user.uid,
      idToken,
    );
  }

  Future<PaymentActionResult> getPaymentStatusWithMessage(
    String paymentId,
    String orderId,
  ) async {
    final user = AuthController.instance.currentUser;
    if (user == null) throw Exception(ErrorMessages.loginRequired);
    final idToken = await AuthController.instance.requireIdToken();
    return _client.payment.getPaymentStatus(
      paymentId,
      orderId,
      user.uid,
      idToken,
    );
  }

  Future<PaymentActionResult> recoverPendingPayments() async {
    final user = AuthController.instance.currentUser;
    if (user == null) throw Exception(ErrorMessages.loginRequired);
    final idToken = await AuthController.instance.requireIdToken();
    return _client.payment.recoverPendingPayments(
      user.uid,
      idToken: idToken,
      limit: 20,
    );
  }

  Future<PaymentActionResult> pollPaymentStatus({
    required String orderId,
    required String paymentId,
    Duration interval = const Duration(seconds: 5),
    int maxAttempts = 30,
  }) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final result = await getPaymentStatusWithMessage(
          paymentId,
          orderId,
        );
        if (result.status == 'paid' ||
            result.status == 'failed' ||
            result.status == 'cancelled') {
          return result;
        }
      } catch (_) {}
      await Future.delayed(interval);
    }
    return PaymentActionResult(
      success: true,
      status: 'timeout',
      message: 'Payment confirmation timed out. Please check later.',
    );
  }
}
