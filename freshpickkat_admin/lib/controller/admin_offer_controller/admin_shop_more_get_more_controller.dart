import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import '../../services/admin_session_service.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
import '../../widgets/cascade_deactivation_dialog.dart';
import '../../widgets/delete_impact_dialog.dart';
import '../network_controller.dart';

class AdminShopMoreGetMoreController extends GetxController {
  static AdminShopMoreGetMoreController get instance =>
      Get.put(AdminShopMoreGetMoreController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminShopMoreGetMoreController',
  );
  final int pageSize = 20;

  final offers = <ShopMoreGetMoreOffer>[].obs;
  final inactiveOffers = <ShopMoreGetMoreOffer>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLoadingInactive = false.obs;
  final hasMore = true.obs;
  final nextPageToken = RxnString();
  final totalCount = 0.obs;

  void _upsertLocal(ShopMoreGetMoreOffer offer) {
    final index = offers.indexWhere(
      (item) => item.offerId == offer.offerId,
    );
    if (index == -1) {
      offers.add(offer);
      totalCount.value++;
    } else {
      offers[index] = offer;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadOffers();
  }

  Future<void> loadOffers({
    bool force = false,
    bool loadAll = false,
  }) async {
    if (force) {
      offers.clear();
      nextPageToken.value = null;
      hasMore.value = true;
      totalCount.value = 0;
    }
    if (!force && offers.isNotEmpty) {
      return;
    }

    if (loadAll) {
      await _loadAllOffers();
    } else {
      await loadMore(isInitial: true);
    }
  }

  Future<void> _loadAllOffers() async {
    isLoading.value = true;
    networkController.hideError();
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final all = await ApiClient().request(() async {
        return client.shopMoreGetMore.getAllOffers(uid, idToken);
      });
      offers.assignAll(all);
      totalCount.value = all.length;
      hasMore.value = false;
    } on NoInternetException {
      networkController.showError(onRetry: loadOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadOffers);
    } catch (e) {
      debugPrint('Error loading all SMGM offers: $e');
      networkController.showError(onRetry: loadOffers);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore({bool isInitial = false}) async {
    if (isLoadingMore.value) return;
    if (!hasMore.value && !isInitial) return;
    try {
      if (isInitial || offers.isEmpty) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      networkController.hideError();
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final page = await ApiClient().request(() async {
        return await client.shopMoreGetMore.getOffersPage(
          firebaseUid: uid,
          idToken: idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
        );
      });
      if (isInitial) {
        offers.assignAll(page.offers);
      } else {
        offers.addAll(page.offers);
      }
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.offers.isNotEmpty;
    } on NoInternetException {
      networkController.showError(onRetry: loadOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadOffers);
    } catch (e) {
      debugPrint('Error loading SMGM offers: $e');
      networkController.showError(onRetry: loadOffers);
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

  Future<void> loadInactiveOffers() async {
    if (isLoadingInactive.value) return;
    isLoadingInactive.value = true;
    try {
      final result = await ApiClient().request(() async {
        return await client.shopMoreGetMore.getInactiveOffers();
      });
      inactiveOffers.assignAll(result);
    } catch (_) {
    } finally {
      isLoadingInactive.value = false;
    }
  }

  Future<bool?> deleteOffer(String offerId) async {
    try {
      return await AdminSessionService.withRetry(
        apiCall: () async {
          final uid = AdminSessionService.requireUid();
          final idToken = await AdminSessionService.requireIdToken();

          final impact = await client.shopMoreGetMore.checkDeleteImpact(
            offerId,
            uid,
            idToken,
          );

          final choice = await showDeleteImpactDialog(
            context: Get.context!,
            impact: impact,
            entityName: 'Shop More, Get More Offer',
          );

          switch (choice) {
            case DeleteChoice.hardDelete:
              final result = await client.shopMoreGetMore.hardDeleteOffer(
                offerId,
                uid,
                idToken,
              );
              if (result.success) {
                offers.removeWhere(
                  (offer) => offer.offerId == offerId,
                );
                if (totalCount.value > 0) totalCount.value--;
                return null;
              }
              return false;
            case DeleteChoice.softDelete:
              await setOfferActive(offerId, false);
              return true;
            case DeleteChoice.cancel:
              return false;
          }
        },
      );
    } catch (e) {
      return false;
    }
  }

  Future<bool> setOfferActive(
    String offerId,
    bool isActive,
  ) async {
    try {
      if (isActive) {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken();
        final success = await client.shopMoreGetMore.setOfferActive(
          offerId,
          isActive,
          uid,
          idToken,
        );
        if (success) {
          final index = offers.indexWhere(
            (offer) => offer.offerId == offerId,
          );
          if (index != -1) {
            offers[index] = offers[index].copyWith(isActive: isActive);
          }
        }
        return success;
      } else {
        final index = offers.indexWhere(
          (offer) => offer.offerId == offerId,
        );
        if (index == -1) return false;
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken();
        final ctx = Get.context;
        if (ctx == null) return false;
        final impact = await client.cascade.analyzeCascadeDeactivation(
          'shop_more_get_more_offer', offerId, uid, idToken,
        );
        if (!ctx.mounted) return false;
        final proceed = await showCascadeDeactivationDialog(
          context: ctx,
          impact: impact,
        );
        if (!proceed) return false;
        await client.cascade.executeCascadeDeactivation(
          'shop_more_get_more_offer', offerId, uid, idToken,
        );
        offers[index] = offers[index].copyWith(isActive: false);
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> upsertOffer(
    ShopMoreGetMoreOffer offer, {
    NotificationDraft? notificationDraft,
  }) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      await client.shopMoreGetMore.upsertOffer(
        offer,
        uid,
        idToken,
        notificationDraft: notificationDraft,
      );
      _upsertLocal(offer);
      return true;
    } catch (e) {
      return false;
    }
  }
}
