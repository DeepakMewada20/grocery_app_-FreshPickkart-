import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_fresh_points_service.dart';
import '../services/postgres/postgres_support.dart';

class FreshPointsEndpoint extends Endpoint {
  final PostgresFreshPointsService _fp = PostgresFreshPointsService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();

  // ── Public ─────────────────────────────────────────────────────────────────

  Future<protocol.FreshPointsSettings> getSettings(Session session) async {
    return _fp.getOrCreateSettings(session);
  }

  // ── User ───────────────────────────────────────────────────────────────────

  Future<protocol.FreshPointsBalance> getMyBalance(
    Session session,
    String userId,
  ) async {
    final parsedId = tryParseUuid(userId);
    if (parsedId == null) {
      throw Exception('Invalid user ID');
    }
    return _fp.getFullBalance(session, parsedId);
  }

  Future<Map<String, dynamic>> getMyTransactions(
    Session session,
    String userId, {
    int limit = 20,
    String? pageToken,
  }) async {
    final parsedId = tryParseUuid(userId);
    if (parsedId == null) {
      throw Exception('Invalid user ID');
    }
    return _fp.getTransactions(session, parsedId, limit: limit, pageToken: pageToken);
  }

  Future<int> getMaxRedeemable(
    Session session,
    String userId,
    double payableAmountAfterCoupon,
  ) async {
    final parsedId = tryParseUuid(userId);
    if (parsedId == null) return 0;
    return _fp.getMaxRedeemable(session, parsedId, payableAmountAfterCoupon);
  }

  // ── Admin ──────────────────────────────────────────────────────────────────

  Future<protocol.FreshPointsSettings> updateSettings(
    Session session,
    protocol.FreshPointsSettings settings,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _fp.updateSettings(session, settings, adminFirebaseUid: firebaseUid);
  }

  Future<protocol.FreshPointsBalance> getUserBalance(
    Session session,
    String userId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final parsedId = tryParseUuid(userId);
    if (parsedId == null) {
      throw Exception('Invalid user ID');
    }
    return _fp.getFullBalance(session, parsedId);
  }

  Future<Map<String, dynamic>> getUserTransactions(
    Session session,
    String userId,
    String firebaseUid,
    String idToken, {
    int limit = 20,
    String? pageToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final parsedId = tryParseUuid(userId);
    if (parsedId == null) {
      throw Exception('Invalid user ID');
    }
    return _fp.getTransactions(session, parsedId, limit: limit, pageToken: pageToken);
  }

  Future<void> adjustPoints(
    Session session,
    protocol.FreshPointsAdjustRequest request,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final parsedId = tryParseUuid(request.userId);
    if (parsedId == null) {
      throw Exception('Invalid user ID');
    }
    await _fp.adminAdjust(
      session,
      parsedId,
      request.points,
      request.transactionType,
      request.description,
      adminFirebaseUid: firebaseUid,
    );
  }
}
