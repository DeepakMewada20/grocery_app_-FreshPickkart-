import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as sc;
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import '../services/api_client.dart';
import '../core/exceptions.dart';
import 'network_controller.dart';

class AdminBannerController extends GetxController {
  static AdminBannerController get instance => Get.put(AdminBannerController());

  sc.Client get _client => ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(NetworkController());

  final banners = <sc.Banner>[].obs;
  final isLoading = false.obs;
  final error = Rx<String?>(null);

  static const List<String> bannerTypes = [
    'offer',
    'category',
    'product',
    'combo',
    'coupon',
    'external_link',
  ];

  static const List<String> screenPlacements = [
    'home_top',
    'home_middle',
    'category_page',
    'product_page',
    'cart_page',
    'checkout_page',
  ];

  static const Map<String, String> bannerTypeLabels = {
    'offer': 'Offer',
    'category': 'Category',
    'product': 'Product',
    'combo': 'Combo',
    'coupon': 'Coupon',
    'external_link': 'External Link',
  };

  static const Map<String, String> screenPlacementLabels = {
    'home_top': 'Home Top',
    'home_middle': 'Home Middle',
    'category_page': 'Category Page',
    'product_page': 'Product Page',
    'cart_page': 'Cart Page',
    'checkout_page': 'Checkout Page',
  };

  @override
  void onInit() {
    super.onInit();
    loadBanners();
  }

  Future<void> loadBanners() async {
    try {
      isLoading.value = true;
      error.value = null;
      networkController.hideError();
      final bannerList = await ApiClient().request(() async {
        return await _client.banner.getBanners(activeOnly: false);
      });
      banners.assignAll(bannerList);
    } on NoInternetException {
      networkController.showError(onRetry: loadBanners);
    } on NetworkException {
      networkController.showError(onRetry: loadBanners);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadBanners);
    } catch (e) {
      error.value = e.toString();
      print('Error loading banners: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createBanner(sc.Banner banner) async {
    try {
      isLoading.value = true;
      error.value = null;
      final created = await ApiClient().request(() async {
        return await _client.banner.createBanner(banner);
      });
      banners.add(created);
      _sortBanners();
      return true;
    } catch (e) {
      error.value = e.toString();
      print('Error creating banner: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateBanner(sc.Banner banner) async {
    try {
      isLoading.value = true;
      error.value = null;
      final updated = await ApiClient().request(() async {
        return await _client.banner.updateBanner(banner);
      });
      final index = banners.indexWhere((b) => b.bannerId == banner.bannerId);
      if (index != -1) {
        banners[index] = updated;
      }
      _sortBanners();
      return true;
    } catch (e) {
      error.value = e.toString();
      print('Error updating banner: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteBanner(String bannerId) async {
    try {
      isLoading.value = true;
      error.value = null;
      await ApiClient().request(() async {
        await _client.banner.deleteBanner(bannerId);
      });
      banners.removeWhere((b) => b.bannerId == bannerId);
      return true;
    } catch (e) {
      error.value = e.toString();
      print('Error deleting banner: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> toggleBannerActive(String bannerId, bool active) async {
    try {
      await ApiClient().request(() async {
        await _client.banner.toggleBannerActive(bannerId, active);
      });
      final index = banners.indexWhere((b) => b.bannerId == bannerId);
      if (index != -1) {
        final banner = banners[index];
        banners[index] = sc.Banner(
          bannerId: banner.bannerId,
          title: banner.title,
          imageUrl: banner.imageUrl,
          type: banner.type,
          offerId: banner.offerId,
          categoryId: banner.categoryId,
          productId: banner.productId,
          comboId: banner.comboId,
          couponCode: banner.couponCode,
          externalUrl: banner.externalUrl,
          screenPlacements: banner.screenPlacements,
          priority: banner.priority,
          startDate: banner.startDate,
          endDate: banner.endDate,
          active: active,
          createdAt: banner.createdAt,
          updatedAt: banner.updatedAt,
        );
      }
      return true;
    } catch (e) {
      error.value = e.toString();
      print('Error toggling banner: $e');
      return false;
    }
  }

  Future<bool> updateBannerPriority(String bannerId, int priority) async {
    try {
      await ApiClient().request(() async {
        await _client.banner.updateBannerPriority(bannerId, priority);
      });
      final index = banners.indexWhere((b) => b.bannerId == bannerId);
      if (index != -1) {
        final banner = banners[index];
        banners[index] = sc.Banner(
          bannerId: banner.bannerId,
          title: banner.title,
          imageUrl: banner.imageUrl,
          type: banner.type,
          offerId: banner.offerId,
          categoryId: banner.categoryId,
          productId: banner.productId,
          comboId: banner.comboId,
          couponCode: banner.couponCode,
          externalUrl: banner.externalUrl,
          screenPlacements: banner.screenPlacements,
          priority: priority,
          startDate: banner.startDate,
          endDate: banner.endDate,
          active: banner.active,
          createdAt: banner.createdAt,
          updatedAt: DateTime.now(),
        );
      }
      _sortBanners();
      return true;
    } catch (e) {
      error.value = e.toString();
      print('Error updating priority: $e');
      return false;
    }
  }

  void _sortBanners() {
    banners.sort((a, b) => a.priority.compareTo(b.priority));
  }

  List<sc.Banner> getBannersForScreen(String screen) {
    return banners.where((b) {
      final placements = b.screenPlacements
          .split(',')
          .map((s) => s.trim())
          .toList();
      return placements.contains(screen) && b.active;
    }).toList();
  }

  String getBannerTypeLabel(String type) {
    return bannerTypeLabels[type] ?? type;
  }

  String getScreenPlacementLabel(String placement) {
    return screenPlacementLabels[placement] ?? placement;
  }
}
