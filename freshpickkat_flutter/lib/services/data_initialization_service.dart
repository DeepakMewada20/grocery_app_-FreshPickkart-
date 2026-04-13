import 'package:flutter/foundation.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/combo_offer_controller.dart';
import 'package:freshpickkat_flutter/controller/notification_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
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

    debugPrint('🚀 Starting Global Data Initialization...');
    isLoading.value = true;

    try {
      // Run critical fetches in parallel
      await Future.wait([
        _initAuth(),
        _initBanners(),
        _initCategories(),
        _initBogoOffers(),
        _initComboOffers(),
        _initInitialProducts(),
        _initNotifications(),
      ]);

      isInitialized.value = true;
      debugPrint('✅ Global Data Initialization Complete.');
    } catch (e) {
      debugPrint('❌ Error during data initialization: $e');
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
      debugPrint('Error init auth: $e');
    }
  }

  Future<void> _initBanners() async {
    try {
      await BannerController.instance.loadHomeBannersIfEmpty();
    } catch (e) {
      debugPrint('Error init banners: $e');
    }
  }

  Future<void> _initCategories() async {
    try {
      await CategoryProviderController.instance.fetchCategoriesIfEmpty();
    } catch (e) {
      debugPrint('Error init categories: $e');
    }
  }

  Future<void> _initBogoOffers() async {
    try {
      await BogoController.instance.fetchActiveOffersIfEmpty();
    } catch (e) {
      debugPrint('Error init bogo offers: $e');
    }
  }

  Future<void> _initComboOffers() async {
    try {
      await ComboOfferController.instance.fetchActiveComboOffersIfEmpty();
    } catch (e) {
      debugPrint('Error init combo offers: $e');
    }
  }

  Future<void> _initInitialProducts() async {
    try {
      await ProductProviderController.instance.fetchProductsIfEmpty();
    } catch (e) {
      debugPrint('Error init products: $e');
    }
  }

  Future<void> _initNotifications() async {
    try {
      await NotificationController.instance.init();
      await NotificationController.instance.openPendingTrackingLaunchIfAny();
    } catch (e) {
      debugPrint('Error init notifications: $e');
    }
  }

  /// Force refresh all core data
  Future<void> refreshAllData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        BannerController.instance.forceLoadAllBanners(),
        CategoryProviderController.instance.forceFetchCategories(),
        BogoController.instance.forceFetchActiveOffers(),
        ComboOfferController.instance.forceFetchActiveComboOffers(),
        ProductProviderController.instance.forceFetchProducts(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }
}
