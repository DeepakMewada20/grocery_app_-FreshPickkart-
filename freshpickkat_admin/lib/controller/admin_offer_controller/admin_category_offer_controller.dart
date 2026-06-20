import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
import '../../widgets/cascade_deactivation_dialog.dart';
import '../../widgets/delete_impact_dialog.dart';
import '../../controller/network_controller.dart';

class AdminCategoryOfferController extends GetxController {
  static AdminCategoryOfferController get instance =>
      Get.put(AdminCategoryOfferController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminCategoryOfferController',
  );
  final int pageSize = 20;

  final categoryOffers = <CategoryOffer>[].obs;
  final inactiveCategoryOffers = <CategoryOffer>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLoadingInactive = false.obs;
  final hasMore = true.obs;
  final nextPageToken = RxnString();
  final totalCount = 0.obs;

  String _ensureOfferId(CategoryOffer offer) {
    if (offer.offerId != null && offer.offerId!.isNotEmpty) {
      return offer.offerId!;
    }
    return '${offer.categoryId}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _upsertLocal(CategoryOffer offer) {
    final normalized = offer.copyWith(offerId: _ensureOfferId(offer));
    final index = categoryOffers.indexWhere(
      (item) => item.offerId == normalized.offerId,
    );
    if (index == -1) {
      categoryOffers.add(normalized);
      totalCount.value++;
    } else {
      categoryOffers[index] = normalized;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadCategoryOffers();
  }

  Future<void> loadCategoryOffers({
    bool force = false,
    bool loadAll = false,
  }) async {
    if (force) {
      categoryOffers.clear();
      nextPageToken.value = null;
      hasMore.value = true;
      totalCount.value = 0;
    }
    if (!force && categoryOffers.isNotEmpty) {
      return;
    }

    if (loadAll) {
      await _loadAllCategoryOffers();
    } else {
      await loadMore(isInitial: true);
    }
  }

  Future<void> _loadAllCategoryOffers() async {
    isLoading.value = true;
    networkController.hideError();
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final all = await ApiClient().request(() async {
        return client.categoryOffer.getAllCategoryOffers(uid, idToken);
      });
      categoryOffers.assignAll(all);
      totalCount.value = all.length;
      hasMore.value = false;
    } on NoInternetException {
      networkController.showError(onRetry: loadCategoryOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadCategoryOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadCategoryOffers);
    } catch (e) {
      debugPrint('Error loading all category offers: $e');
      networkController.showError(onRetry: loadCategoryOffers);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore({bool isInitial = false}) async {
    if (isLoadingMore.value) return;
    if (!hasMore.value && !isInitial) return;
    try {
      if (isInitial || categoryOffers.isEmpty) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      networkController.hideError();
      final page = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await client.categoryOffer.getCategoryOffersPage(
          uid,
          idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
        );
      });
      if (isInitial) {
        categoryOffers.assignAll(page.offers);
      } else {
        categoryOffers.addAll(page.offers);
      }
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.offers.isNotEmpty;
    } on NoInternetException {
      networkController.showError(onRetry: loadCategoryOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadCategoryOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadCategoryOffers);
    } catch (e) {
      debugPrint('Error loading category offers: $e');
      networkController.showError(onRetry: loadCategoryOffers);
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

  Future<void> loadInactiveCategoryOffers() async {
    if (isLoadingInactive.value) return;
    isLoadingInactive.value = true;
    try {
      final result = await ApiClient().request(() async {
        return await client.categoryOffer.getInactiveCategoryOffers();
      });
      inactiveCategoryOffers.assignAll(result);
    } catch (_) {
    } finally {
      isLoadingInactive.value = false;
    }
  }

  Future<bool> createCategoryOffer(
    CategoryOffer offer, {
    NotificationDraft? notificationDraft,
  }) async {
    try {
      final normalizedOffer = offer.copyWith(offerId: _ensureOfferId(offer));
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final result = await client.categoryOffer.upsertCategoryOffer(
        normalizedOffer,
        uid,
        idToken,
        notificationDraft: notificationDraft,
      );
      if (result) {
        _upsertLocal(normalizedOffer);
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCategoryOffer(CategoryOffer offer) async {
    return createCategoryOffer(offer);
  }

  Future<bool?> deleteCategoryOffer(String offerId) async {
    try {
      return await AdminSessionService.withRetry(
        apiCall: () async {
          final uid = AdminSessionService.requireUid();
          final idToken = await AdminSessionService.requireIdToken();

          final impact = await client.categoryOffer
              .checkCategoryOfferDeleteImpact(offerId, uid, idToken);

          final choice = await showDeleteImpactDialog(
            context: Get.context!,
            impact: impact,
            entityName: 'Category Offer',
          );

          switch (choice) {
            case DeleteChoice.hardDelete:
              final result = await client.categoryOffer.hardDeleteCategoryOffer(
                offerId,
                uid,
                idToken,
              );
              if (result.success) {
                categoryOffers.removeWhere((offer) => offer.offerId == offerId);
                if (totalCount.value > 0) totalCount.value--;
                return null;
              }
              return false;
            case DeleteChoice.softDelete:
              await toggleCategoryOffer(offerId, false);
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

  Future<bool> toggleCategoryOffer(String offerId, bool isActive) async {
    try {
      if (isActive) {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        final result = await client.categoryOffer.setCategoryOfferActive(
          offerId,
          isActive,
          uid,
          idToken,
        );
        if (result) {
          final index = categoryOffers.indexWhere(
            (offer) => offer.offerId == offerId,
          );
          if (index != -1) {
            categoryOffers[index] = categoryOffers[index].copyWith(
              isActive: isActive,
            );
          }
        }
        return result;
      } else {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        final ctx = Get.context;
        if (ctx == null) return false;
        final impact = await client.cascade.analyzeCascadeDeactivation(
          'category_offer', offerId, uid, idToken,
        );
        if (!ctx.mounted) return false;
        final proceed = await showCascadeDeactivationDialog(context: ctx, impact: impact);
        if (!proceed) return false;
        await client.cascade.executeCascadeDeactivation(
          'category_offer', offerId, uid, idToken,
        );
        final index = categoryOffers.indexWhere(
          (offer) => offer.offerId == offerId,
        );
        if (index != -1) {
          categoryOffers[index] = categoryOffers[index].copyWith(
            isActive: false,
          );
        }
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
