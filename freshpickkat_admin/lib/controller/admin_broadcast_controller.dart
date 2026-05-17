import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class AdminBroadcastController extends GetxController {
  final _client = ServerpodAdminClient().client;

  final history = <BroadcastSummary>[].obs;
  final scheduled = <BroadcastSummary>[].obs;
  final drafts = <BroadcastSummary>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final error = RxnString();
  String searchQuery = '';

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  Future<void> refreshAll() async {
    await Future.wait([loadHistory(), loadScheduled(), loadDrafts()]);
  }

  Future<void> loadHistory() async {
    final items = await _load(status: 'sent');
    history.assignAll(items);
  }

  Future<void> loadScheduled() async {
    final items = await _load(status: 'scheduled');
    scheduled.assignAll(items);
  }

  Future<void> loadDrafts() async {
    final items = await _load(status: 'draft');
    drafts.assignAll(items);
  }

  Future<List<BroadcastSummary>> _load({required String status}) async {
    isLoading.value = true;
    error.value = null;
    try {
      final page = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final token = await AdminSessionService.requireIdToken();
        return _client.notification.listBroadcasts(
          uid,
          token,
          status: status,
          query: searchQuery.trim().isEmpty ? null : searchQuery.trim(),
          limit: 50,
        );
      });
      return page.items;
    } catch (e) {
      error.value = cleanError(e);
      return const [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<BroadcastSummary> create(BroadcastRequest request) async {
    isSaving.value = true;
    try {
      return await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final token = await AdminSessionService.requireIdToken();
        return _client.notification.createBroadcast(request, uid, token);
      });
    } finally {
      isSaving.value = false;
    }
  }

  Future<BroadcastSummary> saveDraft(BroadcastRequest request) async {
    isSaving.value = true;
    try {
      return await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final token = await AdminSessionService.requireIdToken();
        return _client.notification.saveBroadcastDraft(request, uid, token);
      });
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> sendDraft(String id) async {
    await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      await _client.notification.sendBroadcastDraft(uid, token, id);
    });
    await refreshAll();
  }

  Future<void> deleteDraft(String id) async {
    await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      await _client.notification.deleteBroadcastDraft(uid, token, id);
    });
    drafts.removeWhere((item) => item.id == id);
  }

  String cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '')
        .replaceFirst('UnknownException: ', '');
  }
}
