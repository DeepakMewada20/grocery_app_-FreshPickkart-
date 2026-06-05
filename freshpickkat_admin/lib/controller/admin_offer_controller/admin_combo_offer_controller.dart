import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
import '../../widgets/shared_dialogs.dart';
import '../../controller/network_controller.dart';

class AdminComboOfferController extends GetxController {
  static AdminComboOfferController get instance =>
      Get.put(AdminComboOfferController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminComboOfferController',
  );
  final int pageSize = 20;

  final comboOffers = <ComboOffer>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final nextPageToken = RxnString();
  final totalCount = 0.obs;

  String _ensureComboId(ComboOffer offer) {
    if (offer.comboId != null && offer.comboId!.isNotEmpty) {
      return offer.comboId!;
    }
    final productIds = offer.comboProducts.map((cp) => cp.productId).join('_');
    return '${productIds}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _upsertLocal(ComboOffer offer) {
    final normalized = offer.copyWith(comboId: _ensureComboId(offer));
    final index = comboOffers.indexWhere(
      (item) => item.comboId == normalized.comboId,
    );
    if (index == -1) {
      comboOffers.add(normalized);
      totalCount.value++;
    } else {
      comboOffers[index] = normalized;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadComboOffers();
  }

  Future<void> loadComboOffers({
    bool force = false,
    bool loadAll = false,
  }) async {
    if (force) {
      comboOffers.clear();
      nextPageToken.value = null;
      hasMore.value = true;
      totalCount.value = 0;
    }
    if (!force && comboOffers.isNotEmpty) {
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
      if (isInitial || comboOffers.isEmpty) {
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
        return await client.comboOffer.getComboOffersPage(
          uid,
          idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
        );
      });
      if (isInitial) {
        comboOffers.assignAll(page.offers);
      } else {
        comboOffers.addAll(page.offers);
      }
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.offers.isNotEmpty;
    } on NoInternetException {
      networkController.showError(onRetry: loadComboOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadComboOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadComboOffers);
    } catch (e) {
      debugPrint('Error loading combo offers: $e');
      networkController.showError(onRetry: loadComboOffers);
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

  Future<bool> createComboOffer(
    ComboOffer offer, {
    NotificationDraft? notificationDraft,
  }) async {
    try {
      final normalizedOffer = offer.copyWith(comboId: _ensureComboId(offer));
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final result = await client.comboOffer.upsertComboOffer(
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

  Future<bool> updateComboOffer(ComboOffer offer) async {
    return createComboOffer(offer);
  }

  Future<bool?> deleteComboOffer(String comboId) async {
    try {
      return await AdminSessionService.withRetry(apiCall: () async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken();
        final message = await client.comboOffer.deleteComboOffer(
          comboId,
          uid,
          idToken,
        );
        if (message.isEmpty) {
          comboOffers.removeWhere((offer) => offer.comboId == comboId);
          if (totalCount.value > 0) totalCount.value--;
          return true;
        }
        final shouldDeactivate = await _showDeactivationDialog(message);
        if (shouldDeactivate) {
          await toggleComboOffer(comboId, false);
        }
        return null;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> _showDeactivationDialog(String message) async {
    return showDeactivationDialog(
      title: 'Offer In Use',
      message: message,
    );
  }

  Future<bool> toggleComboOffer(String comboId, bool isActive) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final result = await client.comboOffer.setComboOfferActive(
        comboId,
        isActive,
        uid,
        idToken,
      );
      if (result) {
        final index = comboOffers.indexWhere(
          (offer) => offer.comboId == comboId,
        );
        if (index != -1) {
          comboOffers[index] = comboOffers[index].copyWith(isActive: isActive);
        }
      }
      return result;
    } catch (e) {
      return false;
    }
  }
}
