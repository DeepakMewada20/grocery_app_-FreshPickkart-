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

  @override
  void onInit() {
    super.onInit();
    loadAllBanners();
  }

  Future<void> loadAllBanners({bool forceRefresh = false}) async {
    if (isLoading.value && !forceRefresh) return;
    if (!forceRefresh &&
        homeTopBanners.isNotEmpty &&
        homeMiddleBanners.isNotEmpty) {
      return;
    }
    try {
      isLoading.value = true;
      error.value = null;

      final results = await Future.wait([
        _client.banner.getBanners(screen: 'home_top', activeOnly: true),
        _client.banner.getBanners(screen: 'home_middle', activeOnly: true),
        _client.banner.getBanners(screen: 'category_page', activeOnly: true),
        _client.banner.getBanners(screen: 'cart_page', activeOnly: true),
        _client.banner.getBanners(screen: 'checkout_page', activeOnly: true),
        _client.banner.getBanners(screen: 'product_page', activeOnly: true),
      ]);

      homeTopBanners.assignAll(results[0]);
      homeMiddleBanners.assignAll(results[1]);
      categoryPageBanners.assignAll(results[2]);
      cartPageBanners.assignAll(results[3]);
      checkoutPageBanners.assignAll(results[4]);
      productPageBanners.assignAll(results[5]);
    } catch (e) {
      error.value = e.toString();
      // ignore: avoid_print
      print('Error loading banners: $e');
    } finally {
      isLoading.value = false;
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
