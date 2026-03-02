import 'package:googleapis/firestore/v1.dart' as firestore_api;

class AuditLogService {
  static const String _projectId = 'freshpickkart-a6824';
  static const String _database =
      'projects/$_projectId/databases/(default)/documents';

  static Future<void> write({
    required firestore_api.FirestoreApi firestore,
    required String actorUid,
    required String action,
    required String entityType,
    required String entityId,
    Map<String, String>? metadata,
  }) async {
    final fields = <String, firestore_api.Value>{
      'actorUid': firestore_api.Value(stringValue: actorUid),
      'action': firestore_api.Value(stringValue: action),
      'entityType': firestore_api.Value(stringValue: entityType),
      'entityId': firestore_api.Value(stringValue: entityId),
      'createdAt': firestore_api.Value(
        timestampValue: DateTime.now().toUtc().toIso8601String(),
      ),
    };

    if (metadata != null && metadata.isNotEmpty) {
      fields['metadata'] = firestore_api.Value(
        mapValue: firestore_api.MapValue(
          fields: metadata.map(
            (k, v) => MapEntry(k, firestore_api.Value(stringValue: v)),
          ),
        ),
      );
    }

    await firestore.projects.databases.documents.createDocument(
      firestore_api.Document(fields: fields),
      _database,
      'auditLogs',
    );
  }
}
