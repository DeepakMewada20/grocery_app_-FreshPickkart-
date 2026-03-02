import 'package:googleapis/firestore/v1.dart' as firestore_api;

import '../../generated/protocol.dart' as protocol;
import '../firebase_service.dart';

class SellerAccessService {
  static const String projectId = FirebaseService.projectId;
  static const String sellerCollection = 'sellers';
  static const String adminSellerRole = 'ADMIN_SELLER';
  static const int usernameMinLength = 4;
  static const int usernameMaxLength = 24;
  static final RegExp usernameRegex = RegExp(r'^[a-z][a-z0-9_]{3,23}$');

  static String get _databaseRoot =>
      'projects/$projectId/databases/(default)/documents';

  static String _docPath(String firebaseUid) =>
      '$_databaseRoot/$sellerCollection/$firebaseUid';

  static bool isAdminSellerRole(String? role) {
    return role?.trim().toUpperCase() == adminSellerRole;
  }

  static String normalizeUsername(String username) {
    return username.trim().toLowerCase();
  }

  static bool isValidUsername(String username) {
    return usernameRegex.hasMatch(normalizeUsername(username));
  }

  static String usernameFromEmail(String email) {
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty) return 'admin000';
    final atIndex = normalized.indexOf('@');
    final localPart = atIndex <= 0 ? normalized : normalized.substring(0, atIndex);

    var username = localPart.replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    username = username.replaceAll(RegExp(r'_+'), '_');
    username = username.replaceAll(RegExp(r'^_+|_+$'), '');

    if (username.isEmpty) {
      username = 'admin';
    }
    if (!RegExp(r'^[a-z]').hasMatch(username)) {
      username = 'a$username';
    }
    if (username.length > usernameMaxLength) {
      username = username.substring(0, usernameMaxLength);
    }
    while (username.length < usernameMinLength) {
      username = '${username}0';
    }

    if (!isValidUsername(username)) {
      return 'admin000';
    }
    return username;
  }

  static Future<Map<String, dynamic>?> getSellerDocByUid({
    required firestore_api.FirestoreApi firestore,
    required String firebaseUid,
  }) async {
    final uid = firebaseUid.trim();
    if (uid.isEmpty) return null;

    try {
      final doc = await firestore.projects.databases.documents.get(
        _docPath(uid),
      );
      return _sellerDocToMap(uid, doc.fields);
    } catch (_) {
      return null;
    }
  }

  static Future<protocol.AppUser?> getSellerByUid({
    required firestore_api.FirestoreApi firestore,
    required String firebaseUid,
  }) async {
    final seller = await getSellerDocByUid(
      firestore: firestore,
      firebaseUid: firebaseUid,
    );
    if (seller == null) return null;

    return protocol.AppUser(
      firebaseUid: seller['firebaseUid'] as String,
      phoneNumber: '',
      name: seller['email'] as String?,
      role: seller['role'] as String? ?? adminSellerRole,
    );
  }

  static Future<bool> hasCompletedAdminSetup({
    required firestore_api.FirestoreApi firestore,
  }) async {
    final sellers = await listSellerDocs(firestore: firestore, limit: 1);
    if (sellers.isEmpty) return false;

    final seller = sellers.first;
    final email = (seller['email'] as String? ?? '').trim().toLowerCase();
    return email.isNotEmpty && isAdminSellerRole(seller['role'] as String?);
  }

  static Future<bool> verifyAccess({
    required firestore_api.FirestoreApi firestore,
    required String firebaseUid,
  }) async {
    final seller = await getSellerDocByUid(
      firestore: firestore,
      firebaseUid: firebaseUid,
    );
    if (seller == null) return false;
    return isAdminSellerRole(seller['role'] as String?);
  }

  static Map<String, dynamic>? _sellerDocToMap(
    String firebaseUid,
    Map<String, firestore_api.Value>? fields,
  ) {
    if (fields == null) return null;

    return {
      'firebaseUid': firebaseUid,
      'email': fields['email']?.stringValue ?? '',
      'username': isValidUsername(fields['username']?.stringValue ?? '')
          ? normalizeUsername(fields['username']?.stringValue ?? '')
          : usernameFromEmail(fields['email']?.stringValue ?? ''),
      'role': fields['role']?.stringValue ?? adminSellerRole,
      'createdAt': fields['createdAt']?.timestampValue,
    };
  }

  static Future<List<Map<String, dynamic>>> listSellerDocs({
    required firestore_api.FirestoreApi firestore,
    int limit = 20,
  }) async {
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: sellerCollection)],
      limit: limit,
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      _databaseRoot,
    );

    final sellers = <Map<String, dynamic>>[];
    for (final row in response) {
      final doc = row.document;
      if (doc?.fields == null || doc?.name == null) continue;
      final uid = doc!.name!.split('/').last;
      final parsed = _sellerDocToMap(uid, doc.fields);
      if (parsed != null) sellers.add(parsed);
    }
    return sellers;
  }
}
