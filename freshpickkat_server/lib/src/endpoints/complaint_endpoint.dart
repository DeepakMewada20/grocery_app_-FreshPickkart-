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
    String? paymentMode,
    String? paymentStatus,
    String? paymentCollectionMode,
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
      paymentMode: paymentMode,
      paymentStatus: paymentStatus,
      paymentCollectionMode: paymentCollectionMode,
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
    try {
      return await _complaints.refundComplaint(
        session,
        complaintId: complaintId,
        amount: amount,
        adminReply: adminReply,
        adminNote: adminNote,
      );
    } catch (e) {
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      session.log(
        'refundComplaint failed for $complaintId: $errorMsg',
        level: LogLevel.error,
      );
      throw Exception(errorMsg);
    }
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

  /// Admin: Resolve a pending complaint if conditions are met.
  Future<Complaint> resolvePendingComplaint(
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
    return _complaints.resolvePendingComplaint(
      session,
      complaintId: complaintId,
    );
  }

  /// Admin: Get complaint detail hydrated with refund.
  /// Auto-resolves pending complaints if conditions are met.
  Future<ComplaintDetailHydrated> getComplaintDetailHydrated(
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

    // Auto-resolve pending complaints if conditions met
    await _tryAutoResolve(session, complaintId);

    final complaint = await _complaints.getComplaintAdmin(
      session,
      complaintId: complaintId,
    );
    if (complaint == null) {
      throw ArgumentError('Complaint not found: $complaintId');
    }
    RefundRecord? refund;
    if (complaint.status == 'Resolved' &&
        (complaint.resolutionType?.contains('refund') ?? false)) {
      refund = await _pgRefunds.getRefundByComplaintId(session, complaintId);
    }
    return ComplaintDetailHydrated(
      complaint: complaint,
      refund: refund,
    );
  }

  /// User: Get complaint detail hydrated with refund.
  Future<ComplaintDetailHydrated> getUserComplaintDetailHydrated(
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

    // Auto-resolve pending complaints if conditions met
    await _tryAutoResolve(session, complaintId);

    final complaint = await _complaints.getMyComplaint(
      session,
      user: user,
      complaintId: complaintId,
    );
    if (complaint == null) {
      throw ArgumentError('Complaint not found: $complaintId');
    }
    RefundRecord? refund;
    if (complaint.status == 'Resolved' &&
        (complaint.resolutionType?.contains('refund') ?? false)) {
      refund = await _pgRefunds.getRefundByComplaintId(session, complaintId);
    }
    return ComplaintDetailHydrated(
      complaint: complaint,
      refund: refund,
    );
  }

  /// Internal: Try to auto-resolve a pending complaint if conditions are met.
  Future<void> _tryAutoResolve(Session session, String complaintId) async {
    try {
      await _complaints.resolvePendingComplaint(
        session,
        complaintId: complaintId,
      );
    } catch (_) {
      // Not ready to resolve yet — silently ignore
    }
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
