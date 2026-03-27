import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
import '../../controller/network_controller.dart';

class AdminFreeDeliveryController extends GetxController {
  static AdminFreeDeliveryController get instance => Get.put(AdminFreeDeliveryController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController =
      Get.put(NetworkController(), tag: 'AdminFreeDeliveryController');

  final freeDeliveryRules = <FreeDeliveryRule>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFreeDeliveryRules();
  }

  Future<void> loadFreeDeliveryRules({bool force = false}) async {
    if (!force && freeDeliveryRules.isNotEmpty) return;
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      networkController.hideError();
      final rules = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: true,
        );
        return await client.freeDelivery.getAllFreeDeliveryRules(uid, idToken);
      });
      freeDeliveryRules.assignAll(rules);
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
        await loadFreeDeliveryRules();
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
        await loadFreeDeliveryRules();
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
        await loadFreeDeliveryRules();
      }
      return result;
    } catch (e) {
      print('Error toggling free delivery rule: $e');
      return false;
    }
  }
}
