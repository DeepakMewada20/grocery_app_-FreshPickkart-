import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class AdminComplaintController extends GetxController {
  final _client = ServerpodAdminClient().client;

  final complaints = <Complaint>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final error = RxnString();
  final totalCount = 0.obs;
  final hasMore = false.obs;

  String? statusFilter;
  String? issueTypeFilter;
  String? selectedFieldFilter;
  String? complaintTypeFilter;
  String? _nextPageToken;

  Future<void> load({
    String? status,
    String? issueType,
    String? selectedField,
    String? complaintType,
  }) async {
    statusFilter = status;
    issueTypeFilter = issueType;
    selectedFieldFilter = selectedField;
    complaintTypeFilter = complaintType;
    _nextPageToken = null;
    hasMore.value = false;
    isLoading.value = true;
    error.value = null;
    try {
      final page = await _fetchPage();
      complaints.assignAll(page.complaints);
      totalCount.value = page.totalCount;
      _nextPageToken = page.nextPageToken;
      hasMore.value = page.nextPageToken != null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    final token = _nextPageToken;
    if (token == null || isLoadingMore.value) return;
    isLoadingMore.value = true;
    error.value = null;
    try {
      final page = await _fetchPage(pageToken: token);
      complaints.addAll(page.complaints);
      totalCount.value = page.totalCount;
      _nextPageToken = page.nextPageToken;
      hasMore.value = page.nextPageToken != null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<ComplaintPage> _fetchPage({String? pageToken}) async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.complaint.listComplaints(
        firebaseUid: uid,
        idToken: token,
        status: statusFilter,
        issueType: issueTypeFilter,
        selectedField: selectedFieldFilter,
        complaintType: complaintTypeFilter,
        limit: 20,
        pageToken: pageToken,
      );
    });
  }

  Future<Complaint> updateStatus(
    Complaint complaint,
    String status, {
    String? adminNote,
  }) async {
    final updated = await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.complaint.updateComplaintStatus(
        firebaseUid: uid,
        idToken: token,
        complaintId: complaint.complaintId,
        status: status,
        adminNote: adminNote,
      );
    });
    _replace(updated);
    return updated;
  }

  Future<double> calculateRefundCap(Complaint complaint) async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.complaint.calculateRefundCap(
        firebaseUid: uid,
        idToken: token,
        complaintId: complaint.complaintId,
      );
    });
  }

  Future<Complaint> refundComplaint(
    Complaint complaint, {
    required double amount,
    String? adminNote,
  }) async {
    final updated = await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.complaint.refundComplaint(
        firebaseUid: uid,
        idToken: token,
        complaintId: complaint.complaintId,
        amount: amount,
        adminNote: adminNote,
      );
    });
    _replace(updated);
    return updated;
  }

  Future<Complaint> createReplacementOrder(
    Complaint complaint, {
    String? adminNote,
  }) async {
    final updated = await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.complaint.createReplacementOrder(
        firebaseUid: uid,
        idToken: token,
        complaintId: complaint.complaintId,
        adminNote: adminNote,
      );
    });
    _replace(updated);
    return updated;
  }

  Future<Complaint> retryDelivery(
    Complaint complaint, {
    String? adminNote,
  }) async {
    final updated = await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.complaint.retryDelivery(
        firebaseUid: uid,
        idToken: token,
        complaintId: complaint.complaintId,
        adminNote: adminNote,
      );
    });
    _replace(updated);
    return updated;
  }

  Future<Complaint> reassignRider(
    Complaint complaint, {
    required String riderName,
    required String riderPhone,
    String? adminNote,
  }) async {
    final updated = await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.complaint.reassignRider(
        firebaseUid: uid,
        idToken: token,
        complaintId: complaint.complaintId,
        riderName: riderName,
        riderPhone: riderPhone,
        adminNote: adminNote,
      );
    });
    _replace(updated);
    return updated;
  }

  Future<Complaint> rejectComplaint(
    Complaint complaint, {
    String? adminNote,
  }) async {
    final updated = await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.complaint.rejectComplaint(
        firebaseUid: uid,
        idToken: token,
        complaintId: complaint.complaintId,
        adminNote: adminNote,
      );
    });
    _replace(updated);
    return updated;
  }

  void _replace(Complaint updated) {
    final index = complaints.indexWhere(
      (item) => item.complaintId == updated.complaintId,
    );
    if (index == -1) {
      complaints.add(updated);
    } else {
      complaints[index] = updated;
    }
  }
}
