import 'package:flutter/foundation.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/utils/banner_navigation_helper.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find<BannerController>();

  client.Client get _client => ServerpodClient().client;

  // All placement groups
  final homeTopBanners = <client.Banner>[].obs;
  final homeMiddleBanners = <client.Banner>[].obs;
  final categoryPageBanners = <client.Banner>[].obs;
  final cartPageBanners = <client.Banner>[].obs;
  final checkoutPageBanners = <client.Banner>[].obs;
  final productPageBanners = <client.Banner>[].obs;

  final isLoading = false.obs;
  final error = Rx<String?>(null);

  // Mutex lock to prevent duplicate API calls
  bool _isFetching = false;


  Future<void> loadHomeBannersIfEmpty() async {
    if (_isFetching) return;
    if (homeTopBanners.isNotEmpty && homeMiddleBanners.isNotEmpty) return;
    if (isLoading.value) return;

    _isFetching = true;
    try {
      await loadHomeBanners();
    } catch (e) {
      // error handled in loadHomeBanners
    } finally {
      _isFetching = false;
    }
  }

  Future<void> loadHomeBanners() async {
    try {
      isLoading.value = true;
      error.value = null;

      final results = await Future.wait([
        _client.banner.getBanners(screen: 'home_top', activeOnly: true),
        _client.banner.getBanners(screen: 'home_middle', activeOnly: true),
      ]);

      homeTopBanners.assignAll(results[0]);
      homeMiddleBanners.assignAll(results[1]);
    } catch (e) {
      error.value = e.toString();
      debugPrint('Error loading home banners: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBannersForScreen(String screen) async {
    // Determine which list to update and if it already has data
    RxList<client.Banner>? targetList;
    switch (screen) {
      case 'category_page':
        targetList = categoryPageBanners;
        break;
      case 'cart_page':
        targetList = cartPageBanners;
        break;
      case 'checkout_page':
        targetList = checkoutPageBanners;
        break;
      case 'product_page':
        targetList = productPageBanners;
        break;
    }

    if (targetList == null || targetList.isNotEmpty) return;

    try {
      isLoading.value = true;
      final banners = await _client.banner.getBanners(screen: screen, activeOnly: true);
      targetList.assignAll(banners);
    } catch (e) {
      debugPrint('Error loading banners for $screen: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forceLoadAllBanners() async {
    if (_isFetching) return;
    clearCache();

    _isFetching = true;
    try {
      await loadAllBanners();
    } catch (e) {
      // error handled in loadAllBanners
    } finally {
      _isFetching = false;
    }
  }

  void clearCache() {
    homeTopBanners.clear();
    homeMiddleBanners.clear();
    categoryPageBanners.clear();
    cartPageBanners.clear();
    checkoutPageBanners.clear();
    productPageBanners.clear();
    error.value = null;
    _isFetching = false;
  }

  Future<void> loadAllBanners({bool forceRefresh = false}) async {
    if (isLoading.value && !forceRefresh) return;
    await loadHomeBanners();
    // Other screens will load on demand, but if forceRefresh is true, we might want to refresh what's already loaded
    if (forceRefresh) {
      if (categoryPageBanners.isNotEmpty) await loadBannersForScreen('category_page');
      if (cartPageBanners.isNotEmpty) await loadBannersForScreen('cart_page');
      if (checkoutPageBanners.isNotEmpty) await loadBannersForScreen('checkout_page');
      if (productPageBanners.isNotEmpty) await loadBannersForScreen('product_page');
    }
  }

  /// Returns banners for a specific category page
  List<client.Banner> getBannersForCategory(String categoryId) {
    return categoryPageBanners.where((b) {
      final bCatId = b.categoryId;
      if (bCatId == null) return false;
      return bCatId.trim().toLowerCase() == categoryId.trim().toLowerCase();
    }).toList();
  }

  /// Central tap handler — delegates to BannerNavigationHelper
  Future<void> onBannerTap(client.Banner banner) async {
    await BannerNavigationHelper.navigate(banner);
  }
}
