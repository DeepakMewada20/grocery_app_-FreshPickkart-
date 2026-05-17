import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class AdminNotificationPreferenceController extends GetxController {
  final _client = ServerpodAdminClient().client;

  final preferences = <AdminNotificationPreference>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      final result = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final token = await AdminSessionService.requireIdToken();
        return _client.notification.getAdminNotificationPreferences(uid, token);
      });
      preferences.assignAll(result);
    } catch (e) {
      error.value = cleanError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePreference({
    required AdminNotificationPreference preference,
    bool? pushEnabled,
    bool? soundEnabled,
  }) async {
    if (preference.critical) return;
    final updated = await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.notification.updateAdminNotificationPreference(
        uid,
        token,
        preference.key,
        pushEnabled ?? preference.pushEnabled,
        soundEnabled ?? preference.soundEnabled,
      );
    });
    final index = preferences.indexWhere((item) => item.key == updated.key);
    if (index == -1) {
      preferences.add(updated);
    } else {
      preferences[index] = updated;
    }
  }

  Map<String, List<AdminNotificationPreference>> grouped() {
    final result = <String, List<AdminNotificationPreference>>{};
    for (final preference in preferences) {
      result.putIfAbsent(preference.group, () => []).add(preference);
    }
    return result;
  }

  String cleanError(Object error) {
    final raw = error.toString();
    return raw
        .replaceFirst('Exception: ', '')
        .replaceFirst('UnknownException: ', '');
  }
}
