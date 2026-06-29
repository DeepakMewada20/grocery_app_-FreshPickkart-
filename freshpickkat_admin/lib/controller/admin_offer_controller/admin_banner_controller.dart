import 'package:freshpickkat_admin/services/admin_snackbar_service.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/controller/network_controller.dart';
import 'package:freshpickkat_admin/core/exceptions.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/widgets/cascade_deactivation_dialog.dart';
import 'package:freshpickkat_admin/widgets/delete_impact_dialog.dart';
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
  final inactiveBanners = <sc.Banner>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLoadingInactive = false.obs;
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
      return;
    }
    if (loadAll) {
      await _loadAllBanners();
    } else {
      await loadMore(isInitial: true);
    }
  }

  Future<void> _loadAllBanners() async {
    isLoading.value = true;
    error.value = null;
    networkController.hideError();
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final all = await ApiClient().request(() async {
        return _client.banner.getAllAdminBanners(uid, idToken);
      });
      banners.assignAll(all);
      totalCount.value = all.length;
      hasMore.value = false;
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

  Future<void> loadInactiveBanners() async {
    if (isLoadingInactive.value) return;
    isLoadingInactive.value = true;
    try {
      final result = await ApiClient().request(() async {
        return await _client.banner.getInactiveBanners();
      });
      inactiveBanners.assignAll(result);
    } catch (_) {
    } finally {
      isLoadingInactive.value = false;
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
      AdminSnackbarService.show(Get.context!, 'Banner created successfully');
      return true;
    } on NoInternetException {
      AdminSnackbarService.show(Get.context!, 'No internet connection. Please check your network.');
      return false;
    } catch (e) {
      error.value = e.toString();
      AdminSnackbarService.show(Get.context!, 'An error occurred: $e');
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
      AdminSnackbarService.show(Get.context!, 'Banner updated successfully');
      return true;
    } catch (e) {
      error.value = e.toString();
      AdminSnackbarService.show(Get.context!, e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool?> deleteBanner(String bannerId) async {
    try {
      isLoading.value = true;
      error.value = null;
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );

      final impact = await _client.banner.checkBannerDeleteImpact(
        bannerId,
        uid,
        idToken,
      );

      final choice = await showDeleteImpactDialog(
        context: Get.context!,
        impact: impact,
        entityName: 'Banner',
      );

      switch (choice) {
        case DeleteChoice.hardDelete:
          final result = await _client.banner.hardDeleteBanner(
            bannerId,
            uid,
            idToken,
          );
          if (result.success) {
            banners.removeWhere((b) => b.bannerId == bannerId);
            if (totalCount.value > 0) totalCount.value--;
            return null;
          }
          return false;
        case DeleteChoice.softDelete:
          await toggleBannerActive(bannerId, false);
          return true;
        case DeleteChoice.cancel:
          return false;
      }
    } catch (e) {
      error.value = e.toString();
      AdminSnackbarService.show(Get.context!, e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> toggleBannerActive(String bannerId, bool active) async {
    try {
      if (active) {
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
      } else {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        final ctx = Get.context;
        if (ctx == null) return false;
        final impact = await _client.cascade.analyzeCascadeDeactivation(
          'banner', bannerId, uid, idToken,
        );
        if (!ctx.mounted) return false;
        final proceed = await showCascadeDeactivationDialog(context: ctx, impact: impact);
        if (!proceed) return false;
        await _client.cascade.executeCascadeDeactivation(
          'banner', bannerId, uid, idToken,
        );
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
            active: false,
            isBaseImage: banner.isBaseImage,
            linkedProductIds: banner.linkedProductIds,
            createdAt: banner.createdAt,
            updatedAt: banner.updatedAt,
          );
        }
        return true;
      }
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
