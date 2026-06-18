import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import '../../services/admin_session_service.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
import '../../widgets/delete_impact_dialog.dart';
import '../network_controller.dart';

class AdminBogoController extends GetxController {
  static AdminBogoController get instance => Get.put(AdminBogoController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminBogoController',
  );
  final int pageSize = 20;

  final bogoOffers = <BogoOffer>[].obs;
  final inactiveBogoOffers = <BogoOffer>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLoadingInactive = false.obs;
  final hasMore = true.obs;
  final nextPageToken = RxnString();
  final totalCount = 0.obs;

  void _upsertLocal(BogoOffer offer) {
    final index = bogoOffers.indexWhere(
      (item) => item.triggerProductId == offer.triggerProductId,
    );
    if (index == -1) {
      bogoOffers.add(offer);
      totalCount.value++;
    } else {
      bogoOffers[index] = offer;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadBogoOffers();
  }

  Future<void> loadBogoOffers({
    bool force = false,
    bool loadAll = false,
  }) async {
    if (force) {
      bogoOffers.clear();
      nextPageToken.value = null;
      hasMore.value = true;
      totalCount.value = 0;
    }
    if (!force && bogoOffers.isNotEmpty) {
      return;
    }

    if (loadAll) {
      await _loadAllBogoOffers();
    } else {
      await loadMore(isInitial: true);
    }
  }

  Future<void> _loadAllBogoOffers() async {
    isLoading.value = true;
    networkController.hideError();
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final all = await ApiClient().request(() async {
        return client.bogo.getAllOffers(uid, idToken);
      });
      bogoOffers.assignAll(all);
      totalCount.value = all.length;
      hasMore.value = false;
    } on NoInternetException {
      networkController.showError(onRetry: loadBogoOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadBogoOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadBogoOffers);
    } catch (e) {
      debugPrint('Error loading all BOGO offers: $e');
      networkController.showError(onRetry: loadBogoOffers);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore({bool isInitial = false}) async {
    if (isLoadingMore.value) return;
    if (!hasMore.value && !isInitial) return;
    try {
      if (isInitial || bogoOffers.isEmpty) {
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
        return await client.bogo.getOffersPage(
          firebaseUid: uid,
          idToken: idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
        );
      });
      if (isInitial) {
        bogoOffers.assignAll(page.offers);
      } else {
        bogoOffers.addAll(page.offers);
      }
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.offers.isNotEmpty;
    } on NoInternetException {
      networkController.showError(onRetry: loadBogoOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadBogoOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadBogoOffers);
    } catch (e) {
      debugPrint('Error loading BOGO offers: $e');
      networkController.showError(onRetry: loadBogoOffers);
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

  Future<void> loadInactiveBogoOffers() async {
    if (isLoadingInactive.value) return;
    isLoadingInactive.value = true;
    try {
      final result = await ApiClient().request(() async {
        return await client.bogo.getInactiveBogoOffers();
      });
      inactiveBogoOffers.assignAll(result);
    } catch (_) {
    } finally {
      isLoadingInactive.value = false;
    }
  }

  Future<bool?> deleteOffer(String triggerProductId) async {
    try {
      return await AdminSessionService.withRetry(apiCall: () async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken();

        final impact = await client.bogo.checkBogoDeleteImpact(
          triggerProductId,
          uid,
          idToken,
        );

        final choice = await showDeleteImpactDialog(
          context: Get.context!,
          impact: impact,
          entityName: 'BOGO Offer',
        );

        switch (choice) {
          case DeleteChoice.hardDelete:
            final result = await client.bogo.hardDeleteBogoOffer(
              triggerProductId,
              uid,
              idToken,
            );
            if (result.success) {
              bogoOffers.removeWhere(
                (offer) => offer.triggerProductId == triggerProductId,
              );
              if (totalCount.value > 0) totalCount.value--;
              return null;
            }
            return false;
          case DeleteChoice.softDelete:
            await setBogoOfferActive(triggerProductId, false);
            return true;
          case DeleteChoice.cancel:
            return false;
        }
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> setBogoOfferActive(
    String triggerProductId,
    bool isActive,
  ) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken();
      final success = await client.bogo.setBogoOfferActive(
        triggerProductId,
        isActive,
        uid,
        idToken,
      );
      if (success) {
        final index = bogoOffers.indexWhere(
          (offer) => offer.triggerProductId == triggerProductId,
        );
        if (index != -1) {
          bogoOffers[index] = bogoOffers[index].copyWith(isActive: isActive);
        }
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> upsertOffer(
    BogoOffer offer, {
    NotificationDraft? notificationDraft,
  }) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      await client.bogo.upsertOffer(
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
