import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/banner_navigation_helper.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.find<BannerController>();

  client.Client get _client => ServerpodClient().client;

  // All placement groups
  final homeTopBanners = <client.Banner>[].obs;
  final homeTopImageBanners = <client.Banner>[].obs;
  final homeMiddleBanners = <client.Banner>[].obs;
  final categoryPageBanners = <client.Banner>[].obs;
  final cartPageBanners = <client.Banner>[].obs;
  final checkoutPageBanners = <client.Banner>[].obs;
  final productPageBanners = <client.Banner>[].obs;

  // Cache for image providers to ensure reuse across the session
  final Map<String, ImageProvider> _imageProviderCache = {};

  final isLoading = false.obs;
  final isLazyLoadingMiddle = false.obs;
  final error = Rx<String?>(null);

  // Mutex lock to prevent duplicate API calls
  bool _isFetching = false;

  Future<void> loadHomeTopImageBannersIfEmpty() async {
    if (_isFetching) return;
    if (homeTopImageBanners.isNotEmpty) return;
    if (isLoading.value) return;

    _isFetching = true;
    try {
      final banners = await _client.banner.getBanners(
        screen: 'home_top_image',
        activeOnly: true,
      );
      homeTopImageBanners.assignAll(banners);
    } catch (e) {
      AppLogger.error('Banner', 'TopImage: $e');
    } finally {
      _isFetching = false;
    }
  }

  Future<void> loadHomeBannersIfEmpty() async {
    if (_isFetching) return;
    if (homeTopBanners.isNotEmpty) return;
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

  Future<void> loadHomeMiddleBannersIfEmpty({bool force = false}) async {
    if (!force && homeMiddleBanners.isNotEmpty) return;
    if (isLoading.value) return;

    isLazyLoadingMiddle.value = true;
    try {
      final banners = await _client.banner.getBanners(
        screen: 'home_middle',
        activeOnly: true,
      );
      homeMiddleBanners.assignAll(banners);
    } catch (e) {
      AppLogger.error('Banner', 'HomeMiddle: $e');
    } finally {
      isLazyLoadingMiddle.value = false;
    }
  }

  Future<void> loadHomeBanners() async {
    try {
      isLoading.value = true;
      error.value = null;

      final results = await Future.wait([
        _client.banner.getBanners(screen: 'home_top', activeOnly: true),
        _client.banner.getBanners(screen: 'home_top_image', activeOnly: true),
      ]);

      homeTopBanners.assignAll(
        results[0].where((b) => !b.screenPlacements.contains('home_top_image')),
      );
      homeTopImageBanners.assignAll(results[1]);

      // Precache images for immediate reuse
      if (results[1].isNotEmpty && Get.context != null) {
        for (var b in results[1]) {
          precacheImage(getImageProvider(b.imageUrl), Get.context!);
        }
      }
    } catch (e) {
      error.value = 'Unable to load banners.';
      AppLogger.error('Banner', 'Home: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBannersForScreen(String screen) async {
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
      final banners = await _client.banner.getBanners(
        screen: screen,
        activeOnly: true,
      );
      targetList.assignAll(banners);
    } catch (e) {
      AppLogger.error('Banner', '$screen: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBannersForScreen(String screen) async {
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
      default:
        return;
    }

    targetList.clear();
    try {
      isLoading.value = true;
      final banners = await _client.banner.getBanners(
        screen: screen,
        activeOnly: true,
      );
      targetList.assignAll(banners);
    } catch (e) {
      AppLogger.error('Banner', '$screen: $e');
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
    homeTopImageBanners.clear();
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
      homeMiddleBanners.clear();
      await loadHomeMiddleBannersIfEmpty(force: true);
      if (categoryPageBanners.isNotEmpty) {
        await loadBannersForScreen('category_page');
      }
      if (cartPageBanners.isNotEmpty) await loadBannersForScreen('cart_page');
      if (checkoutPageBanners.isNotEmpty) {
        await loadBannersForScreen('checkout_page');
      }
      if (productPageBanners.isNotEmpty) {
        await loadBannersForScreen('product_page');
      }
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

  void populateFromHydrated(client.HomePageHydratedData data) {
    homeTopImageBanners.assignAll(data.topImageBanners);
    homeTopBanners.assignAll(data.topBanners);
    homeMiddleBanners.assignAll(data.middleBanners);
  }

  /// Fallback: loads home banners individually if hydration didn't populate them.
  /// Safe to call anytime — each internal method checks isNotEmpty before fetching.
  /// Runs sequentially because all three share the same _isFetching mutex.
  Future<void> ensureHomeBannersLoaded() async {
    await loadHomeTopImageBannersIfEmpty();
    await loadHomeBannersIfEmpty();
    await loadHomeMiddleBannersIfEmpty();
  }

  /// Central tap handler — delegates to BannerNavigationHelper
  Future<void> onBannerTap(client.Banner banner) async {
    await BannerNavigationHelper.navigate(banner);
  }

  /// Gets or creates an ImageProvider for a banner image URL
  ImageProvider getImageProvider(String imageUrl) {
    if (!_imageProviderCache.containsKey(imageUrl)) {
      _imageProviderCache[imageUrl] = NetworkImage(imageUrl);
    }
    return _imageProviderCache[imageUrl]!;
  }
}
