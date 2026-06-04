import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
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
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
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
      return await AdminSessionService.withRetry(apiCall: () async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken();
        final message = await client.categoryOffer.deleteCategoryOffer(
          offerId,
          uid,
          idToken,
        );
        if (message.isEmpty) {
          categoryOffers.removeWhere((offer) => offer.offerId == offerId);
          if (totalCount.value > 0) totalCount.value--;
          return true;
        }
        await _showDeactivationDialog(message);
        return null;
      });
    } catch (e) {
      return false;
    }
  }

  Future<void> _showDeactivationDialog(String message) async {
    await Get.defaultDialog(
      title: 'Offer Deactivated',
      middleText: message,
      textConfirm: 'OK',
      onConfirm: () => Get.back(),
    );
  }

  Future<bool> toggleCategoryOffer(String offerId, bool isActive) async {
    try {
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
    } catch (e) {
      return false;
    }
  }
}
