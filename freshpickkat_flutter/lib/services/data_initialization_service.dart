import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/services/home_data_service.dart';
import 'package:freshpickkat_flutter/services/notification_service.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:get/get.dart';

class DataInitializationService extends GetxService {
  static DataInitializationService get instance =>
      Get.find<DataInitializationService>();

  final RxBool isInitialized = false.obs;
  final RxBool isLoading = false.obs;

  /// Orchestrates the initial data fetch for the application.
  /// This should be called once when the app is ready (e.g., after login or on main screen init).
  Future<void> initializeAppData() async {
    if (isInitialized.value || isLoading.value) return;

    AppLogger.info('Init', 'Starting Global Data Initialization...');
    isLoading.value = true;

    try {
      _initAuth();
      _initNotifications();

      await HomeDataService().fetchHomePageData();

      isInitialized.value = true;
      AppLogger.info('Init', 'Global Data Initialization Complete.');
    } catch (e) {
      AppLogger.error('Init', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initAuth() async {
    try {
      if (AuthController.instance.isLoggedIn) {
        await AuthController.instance.refreshAppUser();
      }
    } catch (e) {
      AppLogger.error('Init', 'Auth: $e');
    }
  }

  Future<void> _initNotifications() async {
    try {
      await NotificationService.init();
      await NotificationService.openPendingTrackingLaunchIfAny();
    } catch (e) {
      AppLogger.error('Init', 'Notifications: $e');
    }
  }

  /// Force refresh all core data
  Future<void> refreshAllData() async {
    isLoading.value = true;
    try {
      await HomeDataService().fetchHomePageData();
    } finally {
      isLoading.value = false;
    }
  }
}
