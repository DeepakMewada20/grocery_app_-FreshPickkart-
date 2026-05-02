import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../firebase_auth_service.dart';

class PostgresAdminGuardService {
  static const Duration _authorizationCacheTtl = Duration(minutes: 5);
  static final Map<String, _CachedAdminAuthorization> _authorizationCache = {};

  Future<AppUserRow> ensureAdminSeller(
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

    final cached = _authorizationCache[expectedUid];
    final now = DateTime.now().toUtc();
    if (cached != null && cached.expiresAt.isAfter(now)) {
      return cached.user;
    }
    if (cached != null) {
      _authorizationCache.remove(expectedUid);
    }

    final user = await AppUserRow.db.findFirstRow(
      session,
      where: (t) =>
          t.firebaseUid.equals(expectedUid) & t.status.equals('active'),
    );
    if (user == null || !_isAdminSellerRole(user.role)) {
      throw Exception('Access denied: ADMIN_SELLER role required.');
    }

    _authorizationCache[expectedUid] = _CachedAdminAuthorization(
      user: user,
      expiresAt: now.add(_authorizationCacheTtl),
    );
    return user;
  }

  bool _isAdminSellerRole(String? role) {
    final normalized = role?.trim();
    if (normalized == null || normalized.isEmpty) return false;

    final lowered = normalized.toLowerCase();
    return lowered == 'admin' ||
        lowered == 'seller' ||
        lowered == 'admin_seller' ||
        lowered == 'admin-seller' ||
        lowered == 'admin seller' ||
        normalized.toUpperCase() == 'ADMIN_SELLER';
  }
}

class _CachedAdminAuthorization {
  const _CachedAdminAuthorization({
    required this.user,
    required this.expiresAt,
  });

  final AppUserRow user;
  final DateTime expiresAt;
}
