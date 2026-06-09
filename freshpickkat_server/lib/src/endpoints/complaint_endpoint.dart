import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_complaint_service.dart';
import '../services/postgres/postgres_refund_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';

class ComplaintEndpoint extends Endpoint {
  final PostgresComplaintService _complaints = PostgresComplaintService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresRefundService _pgRefunds = PostgresRefundService();

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

  Future<Complaint> createProductComplaint(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required List<String> selectedOrderItemIds,
    required String issueType,
    String? title,
    required String description,
    required List<String> imageUrls,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.createProductComplaint(
      session,
      user: user,
      orderNumber: orderNumber,
      selectedOrderItemIds: selectedOrderItemIds,
      issueType: issueType,
      title: title,
      description: description,
      imageUrls: imageUrls,
    );
  }

  Future<Complaint> createDeliveryComplaint(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required String issueType,
    String? title,
    required String description,
    List<String> imageUrls = const [],
    String? selectedField,
    Address? requestedAddress,
    String? requestedNote,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.createDeliveryComplaint(
      session,
      user: user,
      orderNumber: orderNumber,
      issueType: issueType,
      title: title,
      description: description,
      imageUrls: imageUrls,
      selectedField: selectedField,
      requestedAddress: requestedAddress,
      requestedNote: requestedNote,
    );
  }

  Future<Complaint?> getActiveComplaintForOrder(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String orderNumber,
    required String complaintType,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.getActiveComplaintForOrder(
      session,
      user: user,
      orderNumber: orderNumber,
      complaintType: complaintType,
    );
  }

  Future<ComplaintPage> listMyComplaints(
    Session session, {
    required String firebaseUid,
    required String idToken,
    String? status,
    String? issueType,
    String? selectedField,
    String? complaintType,
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
      status: status,
      issueType: issueType,
      selectedField: selectedField,
      complaintType: complaintType,
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
    String? issueType,
    String? selectedField,
    String? complaintType,
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
      issueType: issueType,
      selectedField: selectedField,
      complaintType: complaintType,
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
    String? adminReply,
    String? adminNote,
    String? resolutionType,
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
      adminReply: adminReply,
      adminNote: adminNote,
      resolutionType: resolutionType,
      actorFirebaseUid: firebaseUid,
    );
  }

  Future<double> calculateRefundCap(
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
    return _complaints.calculateRefundCap(session, complaintId: complaintId);
  }

  Future<Complaint> refundComplaint(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required double amount,
    String? adminReply,
    String? adminNote,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.refundComplaint(
      session,
      complaintId: complaintId,
      amount: amount,
      adminReply: adminReply,
      adminNote: adminNote,
    );
  }

  Future<Complaint> createReplacementOrder(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    String? adminReply,
    String? adminNote,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.createReplacementOrder(
      session,
      complaintId: complaintId,
      adminReply: adminReply,
      adminNote: adminNote,
    );
  }

  Future<Complaint> retryDelivery(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    String? adminReply,
    String? adminNote,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.retryDelivery(
      session,
      complaintId: complaintId,
      adminReply: adminReply,
      adminNote: adminNote,
    );
  }

  Future<Complaint> reassignRider(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    required String riderName,
    required String riderPhone,
    String? adminReply,
    String? adminNote,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.reassignRider(
      session,
      complaintId: complaintId,
      riderName: riderName,
      riderPhone: riderPhone,
      adminReply: adminReply,
      adminNote: adminNote,
    );
  }

  Future<Complaint> rejectComplaint(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
    String? adminReply,
    String? adminNote,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _complaints.rejectComplaint(
      session,
      complaintId: complaintId,
      adminReply: adminReply,
      adminNote: adminNote,
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

  /// Admin: Get refund details for a complaint.
  Future<RefundRecord?> getRefundForComplaint(
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
    return _pgRefunds.getRefundByComplaintId(session, complaintId);
  }

  /// User: Get refund details for their complaint.
  Future<RefundRecord?> getUserRefundForComplaint(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String complaintId,
  }) async {
    await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgRefunds.getRefundByComplaintId(session, complaintId);
  }
}
