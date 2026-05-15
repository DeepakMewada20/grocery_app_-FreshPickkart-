import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
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
  final deliveryConfig = Rxn<DeliveryConfig>();
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
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
    await _loadConfig();
    await loadMore(isInitial: true);
    if (loadAll) {
      await ensureAllLoaded();
    }
  }

  Future<void> _loadConfig() async {
    try {
      final config = await ApiClient().request(() async {
        return client.freeDelivery.getDeliveryConfig();
      });
      deliveryConfig.value = config;
    } catch (e) {
      print('Error loading delivery config: $e');
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
      print('Error loading delivery rules: $e');
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
      print('Error saving delivery config: $e');
      return false;
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
      print('Error creating delivery rule: $e');
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
      final result = await client.freeDelivery.deleteDeliveryRule(
        ruleId,
        uid,
        idToken,
      );
      if (result) {
        deliveryRules.removeWhere((rule) => rule.ruleId == ruleId);
        if (totalCount.value > 0) totalCount.value--;
      }
      return result;
    } catch (e) {
      print('Error deleting delivery rule: $e');
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
      print('Error toggling delivery rule: $e');
      return false;
    }
  }
}
