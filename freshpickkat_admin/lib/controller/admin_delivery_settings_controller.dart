import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../services/api_client.dart';

class AdminDeliverySettingsController extends GetxController {
  static AdminDeliverySettingsController get instance =>
      Get.put(AdminDeliverySettingsController());

  final _client = ServerpodAdminClient().client;
  final settings = Rxn<DeliverySettings>();
  final isLoading = false.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings({bool force = false}) async {
    if (!force && settings.value != null && !isLoading.value) return;
    isLoading.value = true;
    try {
      final result = await ApiClient().request(() async {
        return await _client.deliverySettings.getSettings();
      });
      settings.value = result;
    } catch (_) {
      // Settings will have default values on server
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveSettings(DeliverySettings updated) async {
    isSaving.value = true;
    try {
      final result = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await _client.deliverySettings.updateSettings(
          updated,
          uid,
          idToken,
        );
      });
      settings.value = result;
      return true;
    } catch (_) {
      rethrow;
    } finally {
      isSaving.value = false;
    }
  }
}
