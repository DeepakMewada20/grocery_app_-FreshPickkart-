import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/widgets/login_bottom_sheet.dart';
import 'package:get/get.dart';

/// Central helper class to manage protected navigation and actions
/// Use this whenever an action or navigation requires user to be logged in
class ProtectedNavigationHelper {
  static final AuthController _authController = AuthController.instance;

  /// Execute an action only if user is logged in
  /// Otherwise show login bottom sheet
  static void executeProtectedAction({
    required VoidCallback onLoggedIn,
    Product? productToAdd,
  }) {
    if (_authController.isLoggedIn) {
      // User is logged in, execute action
      onLoggedIn();
    } else {
      // User not logged in, show login sheet
      _showLoginSheet(
        routeName: null,
        productToAdd: productToAdd,
        onLoginComplete: onLoggedIn,
      );
    }
  }

  /// Navigate to a protected route if user is logged in
  /// Otherwise show login bottom sheet and navigate after login
  static void navigateTo({
    required String routeName,
    Object? arguments,
    Product? productToAdd,
  }) {
    if (_authController.isLoggedIn) {
      // User is logged in, navigate directly
      Get.toNamed(routeName, arguments: arguments);
    } else {
      // User not logged in, show login sheet
      _showLoginSheet(
        routeName: routeName,
        arguments: arguments,
        productToAdd: productToAdd,
      );
    }
  }

  /// Navigate to a protected screen with index (for navigation bars)
  static void navigateToIndex({
    required int index,
    required VoidCallback onNavigate,
  }) {
    if (_authController.isLoggedIn) {
      // User is logged in, navigate directly
      onNavigate();
    } else {
      // User not logged in, show login sheet
      _showLoginSheetForNavigation(
        index: index,
        onNavigate: onNavigate,
      );
    }
  }

  /// Show login bottom sheet for named route navigation
  static void _showLoginSheet({
    String? routeName,
    Object? arguments,
    Product? productToAdd,
    VoidCallback? onLoginComplete,
  }) {
    Get.bottomSheet(
      LoginBottomSheet(
        onLoginPressed: () {
          // Save pending product if provided
          if (productToAdd != null) {
            _authController.setPendingProductToAdd(productToAdd);
          }
          // Save route to return to
          if (routeName != null) {
            _authController.returnRoute.value = routeName;
          } else if (onLoginComplete != null) {
            // Store callback to execute after login
            _AuthNavigation.pendingCallback = onLoginComplete;
          }
          Get.back(); // Close bottom sheet
          Get.toNamed('/phone-auth');
        },
      ),
    );
  }

  /// Show login bottom sheet for index-based navigation
  static void _showLoginSheetForNavigation({
    required int index,
    required VoidCallback onNavigate,
  }) {
    Get.bottomSheet(
      LoginBottomSheet(
        onLoginPressed: () {
          // Store the callback to execute after login
          _AuthNavigation.pendingCallback = onNavigate;
          Get.back(); // Close bottom sheet
          Get.toNamed('/phone-auth');
        },
      ),
    );
  }
}

/// Internal class to handle pending navigation callbacks
class _AuthNavigation {
  static VoidCallback? pendingCallback;

  static void executePendingCallback() {
    if (pendingCallback != null) {
      pendingCallback!();
      pendingCallback = null;
    }
  }
}

/// Extension to execute pending navigation after login
extension AuthNavigationExtension on AuthController {
  void executePendingNavigation() {
    _AuthNavigation.executePendingCallback();
  }
}
