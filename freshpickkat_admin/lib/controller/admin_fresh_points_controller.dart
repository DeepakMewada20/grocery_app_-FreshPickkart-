import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/core/exceptions.dart';
import 'package:freshpickkat_admin/controller/network_controller.dart';

class AdminFreshPointsController extends GetxController {
  static AdminFreshPointsController get instance =>
      Get.put(AdminFreshPointsController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminFreshPointsController',
  );

  final settings = Rxn<FreshPointsSettings>();
  final isLoading = false.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings({bool force = false}) async {
    if (!force && settings.value != null) return;
    isLoading.value = true;
    try {
      final result = await ApiClient().request(() async {
        return client.freshPoints.getSettings();
      });
      settings.value = result;
      networkController.hideError();
    } on NoInternetException {
      networkController.showError(onRetry: loadSettings);
    } on NetworkException {
      networkController.showError(onRetry: loadSettings);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadSettings);
    } catch (e) {
      debugPrint('Error loading FreshPoints settings: $e');
      networkController.showError(onRetry: loadSettings);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveSettings(FreshPointsSettings updated) async {
    isSaving.value = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      final result = await client.freshPoints.updateSettings(
        updated,
        uid,
        idToken,
      );
      settings.value = result;
      return true;
    } catch (e) {
      debugPrint('Error saving FreshPoints settings: $e');
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
