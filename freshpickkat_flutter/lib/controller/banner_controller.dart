import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  static BannerController get instance => Get.put(BannerController());

  client.Client get _client => ServerpodClient().client;

  final homeTopBanners = <client.Banner>[].obs;
  final categoryPageBanners = <client.Banner>[].obs;
  final isLoading = false.obs;
  final error = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadAllBanners();
  }

  Future<void> loadAllBanners() async {
    try {
      isLoading.value = true;
      error.value = null;

      final results = await Future.wait([
        _client.banner.getBanners(screen: 'home_top', activeOnly: true),
        _client.banner.getBanners(screen: 'category_page', activeOnly: true),
      ]);

      homeTopBanners.assignAll(results[0]);
      categoryPageBanners.assignAll(results[1]);
    } catch (e) {
      error.value = e.toString();
      // ignore: avoid_print
      print('Error loading banners: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadHomeTopBanners() async {
    try {
      final banners = await _client.banner.getBanners(
        screen: 'home_top',
        activeOnly: true,
      );
      homeTopBanners.assignAll(banners);
    } catch (e) {
      // ignore: avoid_print
      print('Error loading home top banners: $e');
    }
  }

  Future<void> loadCategoryPageBanners() async {
    try {
      final banners = await _client.banner.getBanners(
        screen: 'category_page',
        activeOnly: true,
      );
      categoryPageBanners.assignAll(banners);
    } catch (e) {
      // ignore: avoid_print
      print('Error loading category page banners: $e');
    }
  }

  List<client.Banner> getBannersForCategory(String categoryId) {
    return categoryPageBanners.where((b) {
      if (b.categoryId == null) return false;
      return b.categoryId!.trim().toLowerCase() ==
          categoryId.trim().toLowerCase();
    }).toList();
  }
}
