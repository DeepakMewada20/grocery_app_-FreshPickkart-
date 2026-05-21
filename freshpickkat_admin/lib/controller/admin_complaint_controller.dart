import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class AdminComplaintController extends GetxController {
  final _client = ServerpodAdminClient().client;

  final complaints = <Complaint>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final totalCount = 0.obs;
  String statusFilter = 'Pending';

  Future<void> load({String? status}) async {
    statusFilter = status ?? statusFilter;
    isLoading.value = true;
    error.value = null;
    try {
      final page = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final token = await AdminSessionService.requireIdToken();
        return _client.complaint.listComplaints(
          firebaseUid: uid,
          idToken: token,
          status: statusFilter,
          limit: 50,
        );
      });
      complaints.assignAll(page.complaints);
      totalCount.value = page.totalCount;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<Complaint> updateStatus(Complaint complaint, String status) async {
    final updated = await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.complaint.updateComplaintStatus(
        firebaseUid: uid,
        idToken: token,
        complaintId: complaint.complaintId,
        status: status,
      );
    });
    _replace(updated);
    return updated;
  }

  Future<Complaint> reply(Complaint complaint, String adminReply) async {
    final updated = await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.complaint.replyToComplaint(
        firebaseUid: uid,
        idToken: token,
        complaintId: complaint.complaintId,
        adminReply: adminReply,
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
