import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_support_issue_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';

class SupportEndpoint extends Endpoint {
  final PostgresSupportIssueService _issues = PostgresSupportIssueService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();

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
}
