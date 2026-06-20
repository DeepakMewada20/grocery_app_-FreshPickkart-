import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'postgres_support.dart';

class PostgresSupportIssueService {
  static const pendingStatus = 'Pending';
  static const inReviewStatus = 'In Review';
  static const resolvedStatus = 'Resolved';
  static const closedStatus = 'Closed';

  static const issueTypes = {
    'Login Problem',
    'Payment Issue',
    'App Crash',
    'Notifications Problem',
    'UI Bug',
    'Performance Problem',
    'Other',
  };

  static const statuses = {
    pendingStatus,
    inReviewStatus,
    resolvedStatus,
    closedStatus,
  };

  Future<SupportIssue> submitIssue(
    Session session, {
    required AppUserRow user,
    required String issueType,
    required String title,
    required String description,
    String? screenshotUrl,
    required String appVersion,
    required String buildNumber,
    required String deviceInfo,
  }) async {
    final userId = user.id;
    if (userId == null) {
      throw Exception('Active user account required.');
    }

    final cleanIssueType = issueType.trim();
    if (!issueTypes.contains(cleanIssueType)) {
      throw Exception('Unsupported issue type.');
    }

    final cleanTitle = title.trim();
    if (cleanTitle.length < 3) {
      throw Exception('Title must be at least 3 characters.');
    }
    if (cleanTitle.length > 120) {
      throw Exception('Title must be 120 characters or less.');
    }

    final cleanDescription = description.trim();
    if (cleanDescription.length < 10) {
      throw Exception('Description must be at least 10 characters.');
    }
    if (cleanDescription.length > 2000) {
      throw Exception('Description must be 2000 characters or less.');
    }

    final now = DateTime.now().toUtc();
    final row = await SupportIssueRow.db.insertRow(
      session,
      SupportIssueRow(
        userId: userId,
        issueType: cleanIssueType,
        title: cleanTitle,
        description: cleanDescription,
        screenshotUrl: cleanNullableString(screenshotUrl),
        appVersion: _limit(appVersion.trim(), 40),
        buildNumber: _limit(buildNumber.trim(), 40),
        deviceInfo: _limit(deviceInfo.trim(), 500),
        status: pendingStatus,
        createdAt: now,
        updatedAt: now,
      ),
    );

    return _mapIssue(row);
  }

  Future<List<SupportIssue>> listIssues(
    Session session, {
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    final rows = await SupportIssueRow.db.find(
      session,
      where: status != null && statuses.contains(status)
          ? (t) => t.status.equals(status)
          : null,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );
    return rows.map(_mapIssue).toList();
  }

  Future<SupportIssue?> getIssueById(Session session, String issueId) async {
    UuidValue? id;
    try {
      id = parseUuid(issueId);
    } catch (_) {
      return null;
    }
    final row = await SupportIssueRow.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id),
    );
    return row == null ? null : _mapIssue(row);
  }

  Future<SupportIssue> updateIssueStatus(
    Session session, {
    required String issueId,
    required String status,
  }) async {
    if (!statuses.contains(status)) {
      throw Exception('Invalid status: $status');
    }
    UuidValue id;
    try {
      id = parseUuid(issueId);
    } catch (_) {
      throw Exception('Invalid issue ID.');
    }
    final existing = await SupportIssueRow.db.findFirstRow(
      session,
      where: (t) => t.id.equals(id),
    );
    if (existing == null) {
      throw Exception('Support issue not found.');
    }
    final updated = await SupportIssueRow.db.updateRow(
      session,
      existing.copyWith(
        status: status,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    return _mapIssue(updated);
  }

  SupportIssue _mapIssue(SupportIssueRow row) {
    return SupportIssue(
      issueId: row.id?.toString() ?? '',
      userId: row.userId.toString(),
      issueType: row.issueType,
      title: row.title,
      description: row.description,
      screenshotUrl: row.screenshotUrl,
      appVersion: row.appVersion,
      buildNumber: row.buildNumber,
      deviceInfo: row.deviceInfo,
      status: row.status,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  String _limit(String value, int maxLength) {
    if (value.isEmpty) return 'Unknown';
    if (value.length <= maxLength) return value;
    return value.substring(0, maxLength);
  }
}
