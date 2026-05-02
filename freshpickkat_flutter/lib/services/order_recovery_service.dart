import 'dart:async';
import 'dart:io';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/services/appcache/payment_recovery_repository.dart';
import 'package:freshpickkat_flutter/services/payment_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OrderRecoveryService extends GetxService with WidgetsBindingObserver {
  static OrderRecoveryService get instance =>
      Get.isRegistered<OrderRecoveryService>()
      ? Get.find<OrderRecoveryService>()
      : Get.put(OrderRecoveryService(), permanent: true);

  final _repository = PaymentRecoveryRepository.instance;
  final _paymentService = PaymentService.instance;
  final _networkController = NetworkController.instance;

  final RxBool isRecovering = false.obs;
  final RxBool hasPendingPayments = false.obs;
  final Rx<DateTime?> lastRecoveryAttempt = Rx<DateTime?>(null);
  final RxString lastRecoveryStatus = ''.obs;

  Timer? _periodicRecoveryTimer;
  bool _initialized = false;
  AppLifecycleState? _lastLifecycleState;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  void _init() {
    if (_initialized) return;
    _initialized = true;

    ever<AppUser?>(AuthController.instance.appUserRx, (appUser) {
      if (appUser != null) {
        _checkAndRecoverIfNeeded(trigger: 'auth_sync');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_lastLifecycleState == AppLifecycleState.paused &&
        state == AppLifecycleState.resumed) {
      _checkAndRecoverIfNeeded(trigger: 'app_resume');
    }
    _lastLifecycleState = state;
  }

  Future<void> _checkAndRecoverIfNeeded({String trigger = 'manual'}) async {
    final user = AuthController.instance.currentUser;
    if (user == null) return;

    final pendingPayments = await _repository.readLocalPendingPaymentsForUser(
      user.uid,
    );

    hasPendingPayments.value = pendingPayments.isNotEmpty;

    if (pendingPayments.isEmpty) {
      return;
    }

    await recoverPendingPayments(trigger: trigger);
  }

  Future<void> recoverPendingPayments({String trigger = 'manual'}) async {
    if (isRecovering.value) return;
    if (!_networkController.isConnected.value) {
      lastRecoveryStatus.value = 'No network connection';
      return;
    }

    final user = AuthController.instance.currentUser;
    if (user == null) {
      lastRecoveryStatus.value = 'User not logged in';
      return;
    }

    lastRecoveryAttempt.value = DateTime.now();
    isRecovering.value = true;
    lastRecoveryStatus.value = 'Recovering...';

    try {
      final pendingPayments = await _repository.readLocalPendingPaymentsForUser(
        user.uid,
      );

      if (pendingPayments.isEmpty) {
        hasPendingPayments.value = false;
        lastRecoveryStatus.value = 'No pending payments';
        return;
      }

      int successCount = 0;
      int failCount = 0;

      for (final payment in pendingPayments) {
        final result = await _replayLocalPendingPayment(
          payment,
          trigger: trigger,
        );
        if (result == RecoveryResult.success) {
          successCount++;
        } else if (result == RecoveryResult.failed) {
          failCount++;
        }
      }

      if (failCount == 0 && successCount > 0) {
        lastRecoveryStatus.value = 'All payments recovered!';
        hasPendingPayments.value = false;
      } else if (failCount > 0 && successCount > 0) {
        lastRecoveryStatus.value = '$successCount recovered, $failCount failed';
      } else {
        lastRecoveryStatus.value = 'Recovery in progress';
      }
    } on SocketException {
      lastRecoveryStatus.value = 'Network error';
    } on TimeoutException {
      lastRecoveryStatus.value = 'Request timed out';
    } catch (e) {
      lastRecoveryStatus.value = 'Error: ${e.toString().substring(0, 30)}';
    } finally {
      isRecovering.value = false;
    }
  }

  Future<RecoveryResult> _replayLocalPendingPayment(
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
        return RecoveryResult.success;
      }

      final gatewayStatus = await _paymentService.fetchGatewayPaymentStatus(
        payment.paymentId,
        payment.orderId,
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
          return RecoveryResult.success;
        }
      }

      if (normalizedGatewayStatus == 'failed' ||
          normalizedGatewayStatus == 'error' ||
          normalizedGatewayStatus == 'refunded') {
        await _repository.removeLocalPendingPayment(payment.paymentId);
        return RecoveryResult.failed;
      }

      final nextRetry = payment.retryCount + 1;
      if (nextRetry >= 3) {
        await _repository.removeLocalPendingPayment(payment.paymentId);
        return RecoveryResult.failed;
      }

      await _repository.updateLocalRetry(
        payment.paymentId,
        retryCount: nextRetry,
        lastError:
            '[${DateTime.now().toUtc().toIso8601String()}][$trigger] '
            '${verifyResult.message ?? verifyResult.error ?? 'verification pending'}',
      );
      return RecoveryResult.pending;
    } catch (e) {
      final nextRetry = payment.retryCount + 1;
      if (nextRetry >= 3) {
        await _repository.removeLocalPendingPayment(payment.paymentId);
        return RecoveryResult.failed;
      } else {
        await _repository.updateLocalRetry(
          payment.paymentId,
          retryCount: nextRetry,
          lastError: '[$trigger] $e',
        );
      }
      return RecoveryResult.pending;
    }
  }

  Future<void> retrySinglePayment(PendingPaymentRecord payment) async {
    if (!_networkController.isConnected.value) {
      lastRecoveryStatus.value = 'No network connection';
      return;
    }

    isRecovering.value = true;
    lastRecoveryStatus.value = 'Retrying payment...';

    try {
      final result = await _replayLocalPendingPayment(
        payment,
        trigger: 'manual_retry',
      );

      if (result == RecoveryResult.success) {
        lastRecoveryStatus.value = 'Payment verified!';
      } else if (result == RecoveryResult.failed) {
        lastRecoveryStatus.value = 'Payment failed';
      } else {
        lastRecoveryStatus.value = 'Will retry automatically';
      }
    } catch (e) {
      lastRecoveryStatus.value = 'Retry failed';
    } finally {
      isRecovering.value = false;
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _periodicRecoveryTimer?.cancel();
    super.onClose();
  }
}

enum RecoveryResult {
  success,
  failed,
  pending,
}
