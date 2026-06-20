import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class AdminSupportIssueController extends GetxController {
  final _client = ServerpodAdminClient().client;

  final issues = <SupportIssue>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final error = RxnString();
  final hasMore = false.obs;

  String? statusFilter;
  int _offset = 0;
  static const int _pageSize = 20;

  Future<void> load({String? status}) async {
    statusFilter = status;
    _offset = 0;
    hasMore.value = false;
    isLoading.value = true;
    error.value = null;
    try {
      final page = await _fetchPage();
      issues.assignAll(page);
      hasMore.value = page.length >= _pageSize;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;
    error.value = null;
    try {
      final page = await _fetchPage();
      issues.addAll(page);
      hasMore.value = page.length >= _pageSize;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<List<SupportIssue>> _fetchPage() async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      final result = await _client.support.listSupportIssues(
        uid,
        token,
        status: statusFilter,
        limit: _pageSize,
        offset: _offset,
      );
      _offset += result.length;
      return result;
    });
  }

  Future<SupportIssue> updateStatus(SupportIssue issue, String status) async {
    final updated = await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.support.updateSupportIssueStatus(
        uid,
        token,
        issue.issueId,
        status,
      );
    });
    _replace(updated);
    return updated;
  }

  void _replace(SupportIssue updated) {
    final index = issues.indexWhere((i) => i.issueId == updated.issueId);
    if (index != -1) {
      issues[index] = updated;
    }
  }
}
