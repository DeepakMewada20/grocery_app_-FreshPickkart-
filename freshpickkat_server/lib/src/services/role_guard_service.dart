import 'package:googleapis/firestore/v1.dart' as firestore_api;
import 'business/seller_access_service.dart';
import 'firebase_auth_service.dart';

class RoleGuardService {
  static Future<void> ensureAdminSeller({
    required firestore_api.FirestoreApi firestore,
    required String firebaseUid,
    required String idToken,
  }) async {
    final expectedUid = firebaseUid.trim();
    if (expectedUid.isEmpty) {
      throw Exception('firebaseUid is required.');
    }

    final verifiedToken = await FirebaseAuthService.verifyIdToken(idToken);
    if (verifiedToken == null) {
      final verifyError = FirebaseAuthService.getLastVerifyError();
      throw Exception(
        verifyError == null || verifyError.trim().isEmpty
            ? 'Invalid or expired Firebase token.'
            : 'Invalid or expired Firebase token. $verifyError',
      );
    }
    if (verifiedToken.uid != expectedUid) {
      throw Exception('Token UID mismatch.');
    }
    if (!verifiedToken.emailVerified) {
      throw Exception('Email verification required.');
    }

    final hasAccess = await SellerAccessService.verifyAccess(
      firestore: firestore,
      firebaseUid: expectedUid,
    );
    if (!hasAccess) {
      throw Exception('Access denied: ADMIN_SELLER role required.');
    }
  }

  static Future<String?> getUserRole({
    required firestore_api.FirestoreApi firestore,
    required String firebaseUid,
  }) async {
    final seller = await SellerAccessService.getSellerByUid(
      firestore: firestore,
      firebaseUid: firebaseUid,
    );
    return seller?.role;
  }
}
