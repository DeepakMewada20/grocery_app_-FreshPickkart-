import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    routeName ??= '/${pageBuilder().runtimeType.toString()}';
    return Get.to<T>(pageBuilder, routeName: routeName);
  } catch (e) {
    Get.back();

    Get.snackbar(
      'Error',
      'Unable to load this feature. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    return null;
  }
}
