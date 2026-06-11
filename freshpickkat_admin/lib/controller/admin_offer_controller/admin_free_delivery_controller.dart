import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/widgets/shared_dialogs.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
import '../../controller/network_controller.dart';

class AdminFreeDeliveryController extends GetxController {
  static AdminFreeDeliveryController get instance =>
      Get.put(AdminFreeDeliveryController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminFreeDeliveryController',
  );
  final int pageSize = 20;

  final deliveryRules = <DeliveryRule>[].obs;
  final inactiveDeliveryRules = <DeliveryRule>[].obs;
  final deliveryConfig = Rxn<DeliveryConfig>();
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLoadingInactive = false.obs;
  final hasMore = true.obs;
  final nextPageToken = RxnString();
  final totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDeliveryData();
  }

  Future<void> loadDeliveryData({
    bool force = false,
    bool loadAll = false,
  }) async {
    if (force) {
      deliveryRules.clear();
      nextPageToken.value = null;
      hasMore.value = true;
      totalCount.value = 0;
    }
    if (!force && deliveryRules.isNotEmpty && deliveryConfig.value != null) {
      if (loadAll) {
        await ensureAllLoaded();
      }
      return;
    }
    await _loadHydrated();
    if (loadAll) {
      await ensureAllLoaded();
    }
  }

  Future<void> _loadHydrated() async {
    isLoading.value = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final hydrated = await ApiClient().request(() async {
        return client.freeDelivery.getFreeDeliveryHydrated(uid, idToken);
      });
      deliveryConfig.value = hydrated.deliveryConfig;
      deliveryRules.assignAll(hydrated.deliveryRules);
      totalCount.value = hydrated.totalCount;
      hasMore.value = false;
    } on NoInternetException {
      networkController.showError(onRetry: loadDeliveryData);
    } on NetworkException {
      networkController.showError(onRetry: loadDeliveryData);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadDeliveryData);
    } catch (e) {
      debugPrint('Error loading free delivery data: $e');
      networkController.showError(onRetry: loadDeliveryData);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore({bool isInitial = false}) async {
    if (isLoadingMore.value) return;
    if (!hasMore.value && !isInitial) return;
    try {
      if (isInitial || deliveryRules.isEmpty) {
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
        return await client.freeDelivery.getDeliveryRulesPage(
          uid,
          idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
        );
      });
      if (isInitial) {
        deliveryRules.assignAll(page.rules);
      } else {
        deliveryRules.addAll(page.rules);
      }
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.rules.isNotEmpty;
    } on NoInternetException {
      networkController.showError(onRetry: loadDeliveryData);
    } on NetworkException {
      networkController.showError(onRetry: loadDeliveryData);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadDeliveryData);
    } catch (e) {
      debugPrint('Error loading free delivery rules: $e');
      networkController.showError(onRetry: loadDeliveryData);
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

  Future<bool> saveDeliveryConfig(DeliveryConfig config) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final result = await client.freeDelivery.upsertDeliveryConfig(
        config,
        uid,
        idToken,
      );
      if (result) {
        deliveryConfig.value = config;
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<void> loadInactiveDeliveryRules() async {
    if (isLoadingInactive.value) return;
    isLoadingInactive.value = true;
    try {
      final result = await ApiClient().request(() async {
        return await client.freeDelivery.getInactiveDeliveryRules();
      });
      inactiveDeliveryRules.assignAll(result);
    } catch (_) {
    } finally {
      isLoadingInactive.value = false;
    }
  }

  Future<bool> createDeliveryRule(
    DeliveryRule rule, {
    NotificationDraft? notificationDraft,
  }) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final result = await client.freeDelivery.upsertDeliveryRule(
        rule,
        uid,
        idToken,
        notificationDraft: notificationDraft,
      );
      if (result) {
        await loadDeliveryData(force: true);
      }
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDeliveryRule(DeliveryRule rule) async {
    return createDeliveryRule(rule);
  }

  Future<bool> deleteDeliveryRule(String ruleId) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final message = await client.freeDelivery.deleteDeliveryRule(
        ruleId,
        uid,
        idToken,
      );
      if (message.isEmpty) {
        deliveryRules.removeWhere((rule) => rule.ruleId == ruleId);
        if (totalCount.value > 0) totalCount.value--;
        return true;
      }
      final shouldDeactivate = await showDeactivationDialog(
        title: 'Delivery Rule In Use',
        message: message,
      );
      if (shouldDeactivate) {
        return toggleDeliveryRule(ruleId, false);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleDeliveryRule(String ruleId, bool isActive) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final result = await client.freeDelivery.setDeliveryRuleActive(
        ruleId,
        isActive,
        uid,
        idToken,
      );
      if (result) {
        final index = deliveryRules.indexWhere((rule) => rule.ruleId == ruleId);
        if (index != -1) {
          deliveryRules[index] = deliveryRules[index].copyWith(
            isActive: isActive,
          );
        }
      }
      return result;
    } catch (e) {
      return false;
    }
  }
  Future<OfferMutationResult> setProductFreeDelivery(
    String productId,
    bool isFreeDelivery, {
    bool confirmDisableConflictingCombo = false,
    bool forceDisableBogo = false,
  }) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      return await client.freeDelivery.setProductFreeDelivery(
        productId,
        isFreeDelivery,
        uid,
        idToken,
        confirmDisableConflictingCombo: confirmDisableConflictingCombo,
        forceDisableBogo: forceDisableBogo,
      );
    } catch (e) {
      return OfferMutationResult(
        success: false,
        message: 'Unable to update product Free Delivery.',
      );
    }
  }

}
