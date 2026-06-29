import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/admin_snackbar_service.dart';

Future<T?> navigateDeferred<T>({
  required Future<void> Function() loadLibrary,
  required Widget Function() pageBuilder,
  String? routeName,
}) async {
  try {
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    await loadLibrary();

    Get.back();

    return Get.to<T>(pageBuilder, routeName: routeName);
  } catch (e) {
    Get.back();

    AdminSnackbarService.show(
      Get.context!,
      'Unable to load this feature. Please try again.',
    );

    return null;
  }
}
