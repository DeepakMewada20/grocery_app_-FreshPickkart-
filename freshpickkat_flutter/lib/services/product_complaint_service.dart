import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';

class ProductComplaintService {
  ProductComplaintService._();

  static final ProductComplaintService instance = ProductComplaintService._();

  final _client = ServerpodClient().client;

  Future<Complaint> createComplaint({
    required String orderNumber,
    required String orderItemId,
    required String issueType,
    required String description,
    required List<String> imageUrls,
  }) async {
    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) throw Exception('Please login to report an issue.');
    final idToken = await auth.requireIdToken();
    return _client.complaint.createComplaint(
      firebaseUid: user.uid,
      idToken: idToken,
      orderNumber: orderNumber,
      orderItemId: orderItemId,
      issueType: issueType,
      description: description,
      imageUrls: imageUrls,
    );
  }

  Future<ComplaintPage> listMyComplaints({
    int limit = 20,
    String? pageToken,
  }) async {
    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) throw Exception('Please login to view complaints.');
    final idToken = await auth.requireIdToken();
    return _client.complaint.listMyComplaints(
      firebaseUid: user.uid,
      idToken: idToken,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<Complaint?> getMyComplaint(String complaintId) async {
    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) return null;
    final idToken = await auth.requireIdToken();
    return _client.complaint.getMyComplaint(
      firebaseUid: user.uid,
      idToken: idToken,
      complaintId: complaintId,
    );
  }

  Future<Complaint?> getComplaintForOrderItem(String orderItemId) async {
    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) return null;
    final idToken = await auth.requireIdToken();
    return _client.complaint.getComplaintForOrderItem(
      firebaseUid: user.uid,
      idToken: idToken,
      orderItemId: orderItemId,
    );
  }
}
