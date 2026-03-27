import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkController extends GetxController {
  final RxBool hasError = false.obs;
  
  VoidCallback? lastFailedRequestRetry;
  StreamSubscription? _connectionSubscription;

  @override
  void onInit() {
    super.onInit();
    _connectionSubscription = InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        if (hasError.value && lastFailedRequestRetry != null) {
          retryLastRequest();
        }
      }
    });
  }

  @override
  void onClose() {
    _connectionSubscription?.cancel();
    super.onClose();
  }

  void showError({VoidCallback? onRetry}) {
    hasError.value = true;
    if (onRetry != null) {
      lastFailedRequestRetry = onRetry;
    }
  }

  void hideError() {
    hasError.value = false;
    lastFailedRequestRetry = null;
  }

  void retryLastRequest() {
    if (lastFailedRequestRetry != null) {
      final retryCall = lastFailedRequestRetry!;
      hideError();
      retryCall();
    }
  }
}
