import 'package:googleapis/firestore/v1.dart' as firestore_api;

import '../firebase_service.dart';

class OrderIdempotencyService {
  static const String collection = 'idempotency_keys';

  String _docPath(String key) {
    final database =
        'projects/${FirebaseService.projectId}/databases/(default)/documents';
    return '$database/$collection/$key';
  }

  Future<String?> getOrderIdForKey(String key) async {
    final firestore = await FirebaseService.getFirestoreClient();
    try {
      final doc = await firestore.projects.databases.documents.get(
        _docPath(key),
      );
      final orderId = doc.fields?['orderId']?.stringValue;
      if (orderId != null && orderId.isNotEmpty) {
        return orderId;
      }
    } catch (_) {}
    return null;
  }

  Future<void> saveKey({
    required String key,
    required String userId,
    required String orderId,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final fields = <String, firestore_api.Value>{
      'key': firestore_api.Value(stringValue: key),
      'userId': firestore_api.Value(stringValue: userId),
      'orderId': firestore_api.Value(stringValue: orderId),
      'createdAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
    };
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      _docPath(key),
      updateMask_fieldPaths: fields.keys.toList(),
    );
  }
}
