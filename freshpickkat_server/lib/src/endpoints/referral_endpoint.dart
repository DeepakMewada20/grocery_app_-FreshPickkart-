import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_referral_service.dart';
import '../services/postgres/postgres_support.dart';

class ReferralEndpoint extends Endpoint {
  final PostgresReferralService _referral = PostgresReferralService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();

  // ── Public ─────────────────────────────────────────────────────────────────

  Future<protocol.ReferralSettings> getSettings(Session session) async {
    return _referral.getOrCreateSettings(session);
  }

  // ── User ───────────────────────────────────────────────────────────────────

  Future<protocol.ReferralCodeInfo> getMyReferralCodeInfo(
    Session session,
    String userId,
  ) async {
    final parsedId = await _resolveUserId(session, userId);
    return _referral.getMyReferralCodeInfo(session, parsedId);
  }

  Future<List<protocol.ReferralActivity>> getMyReferralActivity(
    Session session,
    String userId,
  ) async {
    final parsedId = await _resolveUserId(session, userId);
    return _referral.getMyReferralActivity(session, parsedId);
  }

  Future<Map<String, dynamic>?> validateReferralCode(
    Session session,
    String code,
    String currentUserId,
  ) async {
    final parsedId = await _resolveUserId(session, currentUserId);
    return _referral.validateReferralCode(session, code, parsedId);
  }

  Future<void> applyReferralCode(
    Session session,
    String inviteeUserId,
    String inviteePhone,
    String referralCode,
  ) async {
    final parsedId = await _resolveUserId(session, inviteeUserId);
    await _referral.applyReferral(session, parsedId, inviteePhone, referralCode);
  }

  Future<bool> hasAcceptedTerms(
    Session session,
    String userId,
  ) async {
    final parsedId = await _resolveUserId(session, userId);
    return _referral.hasAcceptedTerms(session, parsedId);
  }

  Future<void> acceptTerms(
    Session session,
    String userId,
  ) async {
    final parsedId = await _resolveUserId(session, userId);
    await _referral.acceptTerms(session, parsedId);
  }

  Future<UuidValue> _resolveUserId(Session session, String userId) async {
    final parsed = tryParseUuid(userId);
    if (parsed != null) return parsed;
    final user = await protocol.AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.firebaseUid.equals(userId),
    );
    if (user == null) throw Exception('Invalid user ID');
    return user.id!;
  }

  // ── Admin ──────────────────────────────────────────────────────────────────

  Future<protocol.ReferralSettings> updateSettings(
    Session session,
    protocol.ReferralSettings settings,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _referral.updateSettings(session, settings, adminFirebaseUid: firebaseUid);
  }

  Future<protocol.ReferralAdminStats> getReferralAnalytics(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _referral.getReferralAnalytics(session);
  }

  Future<Map<String, dynamic>> listReferrals(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 20,
    String? pageToken,
    String? statusFilter,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _referral.listReferrals(
      session,
      limit: limit,
      pageToken: pageToken,
      statusFilter: statusFilter,
    );
  }

  Future<void> approveReward(
    Session session,
    String referralId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    await _referral.approveReward(session, referralId, firebaseUid);
  }

  Future<void> rejectReward(
    Session session,
    String referralId,
    String reason,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    await _referral.rejectReward(session, referralId, reason, firebaseUid);
  }

  Future<Map<String, dynamic>> getFraudAnalytics(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _referral.getFraudAnalytics(session);
  }

  Future<Map<String, dynamic>?> getFraudBreakdown(
    Session session,
    String referralId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _referral.getFraudBreakdown(session, referralId);
  }

  Future<void> reverseReward(
    Session session,
    String referralId,
    String reason,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    await _referral.reverseReward(
      session,
      referralId,
      reason: reason,
      actorFirebaseUid: firebaseUid,
    );
  }
}
