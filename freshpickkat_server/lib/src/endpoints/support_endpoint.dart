import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_support_issue_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';

class SupportEndpoint extends Endpoint {
  final PostgresSupportIssueService _issues = PostgresSupportIssueService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();

  Future<SupportIssue> submitIssue(
    Session session, {
    required String firebaseUid,
    required String idToken,
    required String issueType,
    required String title,
    required String description,
    String? screenshotUrl,
    required String appVersion,
    required String buildNumber,
    required String deviceInfo,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    return _issues.submitIssue(
      session,
      user: user,
      issueType: issueType,
      title: title,
      description: description,
      screenshotUrl: screenshotUrl,
      appVersion: appVersion,
      buildNumber: buildNumber,
      deviceInfo: deviceInfo,
    );
  }

  Future<List<SupportIssue>> listSupportIssues(
    Session session,
    String firebaseUid,
    String idToken, {
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _issues.listIssues(
      session,
      status: status,
      limit: limit,
      offset: offset,
    );
  }

  Future<SupportIssue?> getSupportIssueDetail(
    Session session,
    String firebaseUid,
    String idToken,
    String issueId,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _issues.getIssueById(session, issueId);
  }

  Future<SupportIssue> updateSupportIssueStatus(
    Session session,
    String firebaseUid,
    String idToken,
    String issueId,
    String status,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _issues.updateIssueStatus(
      session,
      issueId: issueId,
      status: status,
    );
  }
}
