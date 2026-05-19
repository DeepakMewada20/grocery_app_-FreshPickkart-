import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_admin_service.dart';

class AdminEndpoint extends Endpoint {
  final PostgresAdminService _adminService = PostgresAdminService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();

  Future<bool> isAdminSetupCompleted(Session session) {
    return _adminService.isAdminSetupCompleted(session);
  }

  Future<String> resolveAdminLoginEmail(
    Session session,
    String usernameOrEmail,
  ) {
    return _adminService.resolveAdminLoginEmail(session, usernameOrEmail);
  }

  Future<protocol.AdminAuthResult> firebaseLogin(
    Session session,
    String idToken,
  ) {
    return _adminService.firebaseLogin(session, idToken);
  }

  Future<protocol.AdminAuthResult> completeFirebaseSetup(
    Session session,
    String idToken,
    String username,
  ) {
    return _adminService.completeFirebaseSetup(session, idToken, username);
  }

  Future<List<protocol.AppUser>> getAllUsers(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.getAllUsers(session);
  }

  Future<protocol.AdminDashboardStats> getDashboardStats(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.getDashboardStats(session);
  }

  Future<protocol.AdminAnalytics> getAnalytics(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.getAnalytics(session);
  }

  Future<List<protocol.AdminAuditLogEntry>> getAuditLogs(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 50,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.getAuditLogs(session, limit: limit);
  }

  Future<List<protocol.ActiveUserStatistics>> getActiveUsersWithStats(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 100,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _adminService.getActiveUsersWithStats(session, limit: limit);
  }
}
