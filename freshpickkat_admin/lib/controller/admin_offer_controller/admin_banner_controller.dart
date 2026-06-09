import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/controller/network_controller.dart';
import 'package:freshpickkat_admin/core/exceptions.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/widgets/shared_dialogs.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as sc;
import 'package:freshpickkat_admin/services/serverpod_client.dart';

class AdminBannerController extends GetxController {
  static AdminBannerController get instance => Get.put(AdminBannerController());

  sc.Client get _client => ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminBannerController',
  );
  final int pageSize = 20;

  final banners = <sc.Banner>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final nextPageToken = Rx<String?>(null);
  final totalCount = 0.obs;
  final error = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadBanners();
  }

  Future<void> loadBanners({bool force = false, bool loadAll = false}) async {
    if (force) {
      banners.clear();
      nextPageToken.value = null;
      hasMore.value = true;
      totalCount.value = 0;
    }
    if (!force && banners.isNotEmpty) {
      if (loadAll) {
        await ensureAllLoaded();
      }
      return;
    }
    await loadMore(isInitial: true);
    if (loadAll) {
      await ensureAllLoaded();
    }
  }

  Future<void> loadMore({bool isInitial = false}) async {
    if (isLoadingMore.value) return;
    if (!hasMore.value && !isInitial) return;
    try {
      if (isInitial || banners.isEmpty) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      error.value = null;
      networkController.hideError();
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final page = await ApiClient().request(() async {
        return await _client.banner.getBannersPage(
          activeOnly: false,
          limit: pageSize,
          pageToken: nextPageToken.value,
          firebaseUid: uid,
          idToken: idToken,
        );
      });
      if (isInitial) {
        banners.assignAll(page.banners);
      } else {
        banners.addAll(page.banners);
      }
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.banners.isNotEmpty;
    } on NoInternetException {
      networkController.showError(onRetry: loadBanners);
    } on NetworkException {
      networkController.showError(onRetry: loadBanners);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadBanners);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> ensureAllLoaded() async {
    while (hasMore.value && !isLoadingMore.value) {
      await loadMore();
    }
  }

  Future<bool> createBanner(sc.Banner banner) async {
    try {
      isLoading.value = true;
      error.value = null;
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final created = await ApiClient().request(() async {
        return await _client.banner.createBanner(banner, uid, idToken);
      });
      if (banner.isBaseImage) {
        await loadBanners(force: true);
      } else {
        banners.add(created);
        totalCount.value++;
        _sortBanners();
      }
      Get.snackbar(
        'Success',
        'Banner created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AdminThemeTokens.success,
        colorText: AdminThemeTokens.white,
      );
      return true;
    } on NoInternetException {
      Get.snackbar(
        'Banner Creation Failed',
        'No internet connection. Please check your network.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AdminThemeTokens.error,
        colorText: AdminThemeTokens.white,
      );
      return false;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Banner Creation Failed',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AdminThemeTokens.error,
        colorText: AdminThemeTokens.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateBanner(sc.Banner banner) async {
    try {
      isLoading.value = true;
      error.value = null;
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final updated = await ApiClient().request(() async {
        return await _client.banner.updateBanner(banner, uid, idToken);
      });
      if (banner.isBaseImage) {
        await loadBanners(force: true);
      } else {
        final index = banners.indexWhere((b) => b.bannerId == banner.bannerId);
        if (index != -1) {
          banners[index] = updated;
        }
        _sortBanners();
      }
      Get.snackbar(
        'Success',
        'Banner updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AdminThemeTokens.success,
        colorText: AdminThemeTokens.white,
      );
      return true;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Banner Update Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AdminThemeTokens.error,
        colorText: AdminThemeTokens.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteBanner(String bannerId) async {
    try {
      isLoading.value = true;
      error.value = null;
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final message = await ApiClient().request(() async {
        return await _client.banner.deleteBanner(bannerId, uid, idToken);
      });
      if (message.isEmpty) {
        banners.removeWhere((b) => b.bannerId == bannerId);
        if (totalCount.value > 0) totalCount.value--;
        showUndoSnackbar(
          title: 'Deactivated',
          message: 'Banner has been deactivated',
          onUndo: () async {
            await toggleBannerActive(bannerId, true);
          },
        );
        return true;
      }
      final shouldDeactivate = await showDeactivationDialog(
        title: 'Banner In Use',
        message: message,
      );
      if (shouldDeactivate) {
        final ok = await toggleBannerActive(bannerId, false);
        showUndoSnackbar(
          title: 'Deactivated',
          message: 'Banner has been deactivated',
          onUndo: () async {
            await toggleBannerActive(bannerId, true);
          },
        );
        return ok;
      }
      return false;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Delete Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AdminThemeTokens.error,
        colorText: AdminThemeTokens.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> toggleBannerActive(String bannerId, bool active) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      await ApiClient().request(() async {
        await _client.banner.toggleBannerActive(bannerId, active, uid, idToken);
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
          isBaseImage: banner.isBaseImage,
          linkedProductIds: banner.linkedProductIds,
          createdAt: banner.createdAt,
          updatedAt: banner.updatedAt,
        );
      }
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

  Future<bool> updateBannerPriority(String bannerId, int priority) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      await ApiClient().request(() async {
        await _client.banner.updateBannerPriority(
          bannerId,
          priority,
          uid,
          idToken,
        );
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
          isBaseImage: banner.isBaseImage,
          linkedProductIds: banner.linkedProductIds,
          createdAt: banner.createdAt,
          updatedAt: DateTime.now(),
        );
      }
      _sortBanners();
      return true;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

  void _sortBanners() {
    banners.sort((a, b) => a.priority.compareTo(b.priority));
  }
}
