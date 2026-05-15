import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_complaint_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';

class ComplaintEndpoint extends Endpoint {
  final PostgresComplaintService _complaints = PostgresComplaintService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();

  Future<Complaint> createComplaint(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required String orderItemId,
    required String issueType,
    required String description,
    required List<String> imageUrls,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.createComplaint(
      session,
      user: user,
      orderNumber: orderNumber,
      orderItemId: orderItemId,
      issueType: issueType,
      description: description,
      imageUrls: imageUrls,
    );
  }

  Future<ComplaintPage> listMyComplaints(
    Session session, {
    required String firebaseUid,
    required String idToken,
    int limit = 20,
    String? pageToken,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.listMyComplaints(
      session,
      user: user,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<Complaint?> getMyComplaint(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.getMyComplaint(
      session,
      user: user,
      complaintId: complaintId,
    );
  }

  Future<Complaint?> getComplaintForOrderItem(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String orderItemId,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.getComplaintForOrderItem(
      session,
      user: user,
      orderItemId: orderItemId,
    );
  }

  Future<ComplaintPage> listComplaints(
    Session session, {
    required String firebaseUid,
    required String idToken,
    String? status,
    int limit = 20,
    String? pageToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.listComplaints(
      session,
      status: status,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<Complaint?> getComplaintAdmin(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.getComplaintAdmin(
      session,
      complaintId: complaintId,
    );
  }

  Future<Complaint> updateComplaintStatus(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required String status,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.updateComplaintStatus(
      session,
      complaintId: complaintId,
      status: status,
    );
  }

  Future<Complaint> replyToComplaint(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required String adminReply,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.replyToComplaint(
      session,
      complaintId: complaintId,
      adminReply: adminReply,
    );
  }
}
