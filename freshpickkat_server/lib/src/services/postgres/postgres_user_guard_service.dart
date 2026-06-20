import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../firebase/firebase_auth_service.dart';

class PostgresUserGuardService {
  Future<AppUserRow> ensureUser(
    Session session, {
    required String firebaseUid,
    required String idToken,
  }) async {
    final expectedUid = firebaseUid.trim();
    if (expectedUid.isEmpty) {
      throw Exception('firebaseUid is required.');
    }

    final verifiedToken = await FirebaseAuthService.verifyIdToken(idToken);
    if (verifiedToken == null) {
      final verifyError = FirebaseAuthService.getLastVerifyError() ?? '';
      final isNetworkError =
          verifyError.contains('HandshakeException') ||
          verifyError.contains('SocketException') ||
          verifyError.contains('ClientException') ||
          verifyError.contains('Connection closed') ||
          verifyError.contains('Connection terminated');
      throw Exception(
        isNetworkError
            ? 'Firebase token verification failed (network error). $verifyError'
            : 'Invalid or expired Firebase token.',
      );
    }
    if (verifiedToken.uid != expectedUid) {
      throw Exception('Token UID mismatch.');
    }

    final user = await AppUserRow.db.findFirstRow(
      session,
      where: (t) =>
          t.firebaseUid.equals(expectedUid) & t.status.equals('active'),
    );
    if (user?.id == null) {
      throw Exception('Active user account required.');
    }

    return user!;
  }
}
