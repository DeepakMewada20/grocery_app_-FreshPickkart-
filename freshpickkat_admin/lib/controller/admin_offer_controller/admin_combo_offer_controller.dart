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
  final inactiveComboOffers = <ComboOffer>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLoadingInactive = false.obs;
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
      return;
    }

    if (loadAll) {
      await _loadAllComboOffers();
    } else {
      await loadMore(isInitial: true);
    }
  }

  Future<void> _loadAllComboOffers() async {
    isLoading.value = true;
    networkController.hideError();
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final all = await ApiClient().request(() async {
        return client.comboOffer.getAllComboOffers(uid, idToken);
      });
      comboOffers.assignAll(all);
      totalCount.value = all.length;
      hasMore.value = false;
    } on NoInternetException {
      networkController.showError(onRetry: loadComboOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadComboOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadComboOffers);
    } catch (e) {
      debugPrint('Error loading all combo offers: $e');
      networkController.showError(onRetry: loadComboOffers);
    } finally {
      isLoading.value = false;
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

  Future<void> loadInactiveComboOffers() async {
    if (isLoadingInactive.value) return;
    isLoadingInactive.value = true;
    try {
      final result = await ApiClient().request(() async {
        return await client.comboOffer.getInactiveComboOffers();
      });
      inactiveComboOffers.assignAll(result);
    } catch (_) {
    } finally {
      isLoadingInactive.value = false;
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

  Future<OfferMutationResult> upsertComboOfferWithConflicts(
    ComboOffer offer, {
    NotificationDraft? notificationDraft,
  }) async {
    try {
      final normalizedOffer = offer.copyWith(comboId: _ensureComboId(offer));
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final result = await client.comboOffer.upsertComboOfferWithConflicts(
        normalizedOffer,
        uid,
        idToken,
        notificationDraft: notificationDraft,
        force: false,
      );
      if (result.success) {
        _upsertLocal(normalizedOffer);
      }
      return result;
    } on Exception catch (e) {
      return OfferMutationResult(success: false, message: e.toString());
    }
  }

  Future<bool?> deleteComboOffer(String comboId) async {
    try {
      return await AdminSessionService.withRetry(
        apiCall: () async {
          final uid = AdminSessionService.requireUid();
          final idToken = await AdminSessionService.requireIdToken();

          final impact = await client.comboOffer.checkComboDeleteImpact(
            comboId,
            uid,
            idToken,
          );

          final choice = await showDeleteImpactDialog(
            context: Get.context!,
            impact: impact,
            entityName: 'Combo Offer',
          );

          switch (choice) {
            case DeleteChoice.hardDelete:
              final result = await client.comboOffer.hardDeleteComboOffer(
                comboId,
                uid,
                idToken,
              );
              if (result.success) {
                comboOffers.removeWhere((offer) => offer.comboId == comboId);
                if (totalCount.value > 0) totalCount.value--;
                return null;
              }
              return false;
            case DeleteChoice.softDelete:
              await toggleComboOffer(comboId, false);
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

  Future<bool> toggleComboOffer(String comboId, bool isActive) async {
    try {
      if (isActive) {
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
      } else {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        final ctx = Get.context;
        if (ctx == null) return false;
        final impact = await client.cascade.analyzeCascadeDeactivation(
          'combo_offer', comboId, uid, idToken,
        );
        if (!ctx.mounted) return false;
        final proceed = await showCascadeDeactivationDialog(context: ctx, impact: impact);
        if (!proceed) return false;
        await client.cascade.executeCascadeDeactivation(
          'combo_offer', comboId, uid, idToken,
        );
        final index = comboOffers.indexWhere(
          (offer) => offer.comboId == comboId,
        );
        if (index != -1) {
          comboOffers[index] = comboOffers[index].copyWith(isActive: false);
        }
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
