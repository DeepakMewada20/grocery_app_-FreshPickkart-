import 'package:freshpickkat_admin/screens/login_screen.dart';
import 'package:freshpickkat_admin/services/admin_auth_service.dart';
import 'package:get/get.dart';

class AdminAuthFailureHandler {
  static bool _isHandling = false;

  static bool isAuthFailure(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('login expired') ||
        text.contains('invalid login session') ||
        text.contains('invalid or expired firebase token') ||
        text.contains('token uid mismatch') ||
        text.contains('email verification required') ||
        text.contains('access denied: admin_seller role required') ||
        text.contains('seller profile not found') ||
        text.contains('login required');
  }

  static Future<void> handle(Object error, {String? fallbackMessage}) async {
    if (_isHandling) return;
    _isHandling = true;

    final raw = error.toString().replaceFirst('Exception: ', '').trim();
    final message = raw.isEmpty
        ? (fallbackMessage ?? 'Login expired. Please login again.')
        : raw;

    try {
      await AdminAuthService().signOut();
    } catch (_) {
      // Ignore signout cleanup failures; redirect is still required.
    }

    if (Get.context != null) {
      Get.offAll(() => LoginScreen(initialMessage: message));
    }

    _isHandling = false;
  }
}
