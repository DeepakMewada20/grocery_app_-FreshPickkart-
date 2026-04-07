import 'dart:async';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/services/payment_recovery_repository.dart';
import 'package:freshpickkat_flutter/services/payment_service.dart';
import 'package:get/get.dart';

class OrderRecoveryService extends GetxService {
  static OrderRecoveryService get instance =>
      Get.isRegistered<OrderRecoveryService>()
          ? Get.find<OrderRecoveryService>()
          : Get.put(OrderRecoveryService(), permanent: true);

  final _repository = PaymentRecoveryRepository.instance;
  final _paymentService = PaymentService.instance;

  final RxBool isRecovering = false.obs;
  Timer? _periodicRecoveryTimer;
  bool _initialized = false;

  void init() {
    if (_initialized) return;
    _initialized = true;

    ever<AppUser?>(AuthController.instance.appUserRx, (appUser) {
      if (appUser != null) {
        unawaited(recoverPendingPayments(trigger: 'auth_sync'));
      }
    });

    _periodicRecoveryTimer?.cancel();
    _periodicRecoveryTimer = Timer.periodic(
      const Duration(minutes: 3),
      (_) => unawaited(recoverPendingPayments(trigger: 'periodic')),
    );

    unawaited(recoverPendingPayments(trigger: 'app_start'));
  }

  Future<void> recoverPendingPayments({String trigger = 'manual'}) async {
    if (isRecovering.value) return;

    final user = AuthController.instance.currentUser;
    if (user == null) return;

    isRecovering.value = true;
    try {
      final pendingPayments = await _repository.readLocalPendingPaymentsForUser(
        user.uid,
      );

      for (final payment in pendingPayments) {
        await _replayLocalPendingPayment(payment, trigger: trigger);
      }

      await _paymentService.recoverPendingPayments(userId: user.uid);
    } finally {
      isRecovering.value = false;
    }
  }

  Future<void> _replayLocalPendingPayment(
    PendingPaymentRecord payment, {
    required String trigger,
  }) async {
    try {
      final verifyResult = await _paymentService.verifyPayment(
        orderId: payment.orderId,
        razorpayOrderId: payment.razorpayOrderId,
        paymentId: payment.paymentId,
        signature: payment.signature ?? '',
      );
      if (verifyResult.success == true && verifyResult.verified == true) {
        await _repository.removeLocalPendingPayment(payment.paymentId);
        return;
      }

      final gatewayStatus = await _paymentService.fetchGatewayPaymentStatus(
        payment.paymentId,
      );
      final normalizedGatewayStatus =
          gatewayStatus.status?.toLowerCase().trim() ?? '';
      if (normalizedGatewayStatus == 'captured' ||
          normalizedGatewayStatus == 'authorized') {
        final recoveredResult = await _paymentService.verifyPayment(
          orderId: payment.orderId,
          razorpayOrderId: payment.razorpayOrderId,
          paymentId: payment.paymentId,
          signature: '',
        );
        if (recoveredResult.success == true &&
            recoveredResult.verified == true) {
          await _repository.removeLocalPendingPayment(payment.paymentId);
          return;
        }
      }

      final nextRetry = payment.retryCount + 1;
      if (nextRetry >= 3) {
        await _repository.removeLocalPendingPayment(payment.paymentId);
        return;
      }

      await _repository.updateLocalRetry(
        payment.paymentId,
        retryCount: nextRetry,
        lastError:
            '[${DateTime.now().toUtc().toIso8601String()}][$trigger] '
            '${verifyResult.message ?? verifyResult.error ?? 'verification pending'}',
      );
    } catch (e) {
      final nextRetry = payment.retryCount + 1;
      if (nextRetry >= 3) {
        await _repository.removeLocalPendingPayment(payment.paymentId);
      } else {
        await _repository.updateLocalRetry(
          payment.paymentId,
          retryCount: nextRetry,
          lastError: '[$trigger] $e',
        );
      }
    }
  }

  @override
  void onClose() {
    _periodicRecoveryTimer?.cancel();
    super.onClose();
  }
}
