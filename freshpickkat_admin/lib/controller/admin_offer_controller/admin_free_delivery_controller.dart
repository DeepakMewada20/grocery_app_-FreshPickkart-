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

  final freeDeliveryRules = <FreeDeliveryRule>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final nextPageToken = RxnString();
  final totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadFreeDeliveryRules();
  }

  Future<void> loadFreeDeliveryRules({
    bool force = false,
    bool loadAll = false,
  }) async {
    if (force) {
      freeDeliveryRules.clear();
      nextPageToken.value = null;
      hasMore.value = true;
      totalCount.value = 0;
    }
    if (!force && freeDeliveryRules.isNotEmpty) {
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
      if (isInitial || freeDeliveryRules.isEmpty) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      networkController.hideError();
      final page = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: true,
        );
        return await client.freeDelivery.getFreeDeliveryRulesPage(
          uid,
          idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
        );
      });
      if (isInitial) {
        freeDeliveryRules.assignAll(page.rules);
      } else {
        freeDeliveryRules.addAll(page.rules);
      }
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.rules.isNotEmpty;
    } on NoInternetException {
      networkController.showError(onRetry: loadFreeDeliveryRules);
    } on NetworkException {
      networkController.showError(onRetry: loadFreeDeliveryRules);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadFreeDeliveryRules);
    } catch (e) {
      print('Error loading free delivery rules: $e');
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

  Future<bool> createFreeDeliveryRule(FreeDeliveryRule rule) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.freeDelivery.upsertFreeDeliveryRule(
        rule,
        uid,
        idToken,
      );
      if (result) {
        final index = freeDeliveryRules.indexWhere(
          (item) => item.ruleId == rule.ruleId,
        );
        if (index == -1) {
          freeDeliveryRules.add(rule);
          totalCount.value++;
        } else {
          freeDeliveryRules[index] = rule;
        }
        freeDeliveryRules.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      }
      return result;
    } catch (e) {
      print('Error creating free delivery rule: $e');
      return false;
    }
  }

  Future<bool> updateFreeDeliveryRule(FreeDeliveryRule rule) async {
    return createFreeDeliveryRule(rule);
  }

  Future<bool> deleteFreeDeliveryRule(String ruleId) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.freeDelivery.deleteFreeDeliveryRule(
        ruleId,
        uid,
        idToken,
      );
      if (result) {
        freeDeliveryRules.removeWhere((rule) => rule.ruleId == ruleId);
        if (totalCount.value > 0) totalCount.value--;
      }
      return result;
    } catch (e) {
      print('Error deleting free delivery rule: $e');
      return false;
    }
  }

  Future<bool> toggleFreeDeliveryRule(String ruleId, bool isActive) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.freeDelivery.setFreeDeliveryRuleActive(
        ruleId,
        isActive,
        uid,
        idToken,
      );
      if (result) {
        final index = freeDeliveryRules.indexWhere(
          (rule) => rule.ruleId == ruleId,
        );
        if (index != -1) {
          freeDeliveryRules[index] = freeDeliveryRules[index].copyWith(
            isActive: isActive,
          );
        }
      }
      return result;
    } catch (e) {
      print('Error toggling free delivery rule: $e');
      return false;
    }
  }
}
