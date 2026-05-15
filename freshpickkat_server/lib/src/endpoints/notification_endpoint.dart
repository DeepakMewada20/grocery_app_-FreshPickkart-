import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/notification_outbox_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_support.dart';

class NotificationEndpoint extends Endpoint {
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();

  Future<bool> registerFcmToken(
    Session session,
    String firebaseUid,
    String token,
    String deviceId,
    String platform,
  ) async {
    final user = await _requireUser(session, firebaseUid);
    final now = DateTime.now().toUtc();
    final existing = await UserFcmTokenRow.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id!) & t.deviceId.equals(deviceId),
    );

    if (existing == null) {
      await UserFcmTokenRow.db.insertRow(
        session,
        UserFcmTokenRow(
          userId: user.id!,
          firebaseUid: user.firebaseUid ?? firebaseUid.trim(),
          fcmToken: token.trim(),
          deviceId: deviceId.trim(),
          platform: platform.trim().isEmpty ? 'unknown' : platform.trim(),
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      await UserFcmTokenRow.db.updateById(
        session,
        existing.id!,
        columnValues: (t) => [
          t.firebaseUid(user.firebaseUid ?? firebaseUid.trim()),
          t.fcmToken(token.trim()),
          t.platform(platform.trim().isEmpty ? 'unknown' : platform.trim()),
          t.isActive(true),
          t.updatedAt(now),
        ],
      );
    }

    await AppUserRow.db.updateById(
      session,
      user.id!,
      columnValues: (t) => [
        t.fcmToken(token.trim()),
        t.updatedAt(now),
      ],
    );
    return true;
  }

  Future<NotificationPreference> getPreferences(
    Session session,
    String firebaseUid,
  ) async {
    final row = await _ensurePreferenceRow(session, firebaseUid);
    return _toPreference(row);
  }

  Future<NotificationPreference> updatePreferences(
    Session session,
    String firebaseUid,
    NotificationPreference preferences,
  ) async {
    final row = await _ensurePreferenceRow(session, firebaseUid);
    final now = DateTime.now().toUtc();
    final updated = await NotificationPreferenceRow.db.updateById(
      session,
      row.id!,
      columnValues: (t) => [
        t.trackOrderNotifications(preferences.trackOrderNotifications),
        t.couponNotifications(preferences.couponNotifications),
        t.offerNotifications(preferences.offerNotifications),
        t.announcementNotifications(preferences.announcementNotifications),
        t.importantAlerts(preferences.importantAlerts),
        t.updatedAt(now),
      ],
    );
    return _toPreference(updated ?? row.copyWith(updatedAt: now));
  }

  Future<NotificationHistoryPage> listNotifications(
    Session session,
    String firebaseUid, {
    int limit = 30,
    String? pageToken,
  }) async {
    final user = await _requireUser(session, firebaseUid);
    final prefs = await _ensurePreferenceRow(session, firebaseUid);
    final topics = _enabledTopics(prefs);
    if (topics.isEmpty) {
      return NotificationHistoryPage(
        items: const [],
        nextPageToken: null,
        unreadCount: 0,
      );
    }

    final cursor = decodeCursor(pageToken);
    final before = cursor?['createdAt'] is String
        ? DateTime.tryParse(cursor!['createdAt'] as String)
        : null;
    final safeLimit = clampPageLimit(limit, defaultLimit: 30, maxLimit: 100);

    final campaigns = await NotificationCampaignRow.db.find(
      session,
      where: (t) {
        var expression = t.topic.inSet(topics.toSet());
        if (before != null) {
          expression = expression & (t.createdAt < before);
        }
        return expression;
      },
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: safeLimit + 1,
    );

    final pageRows = campaigns.take(safeLimit).toList();
    final campaignIds = [
      for (final row in pageRows)
        if (row.id != null) row.id!,
    ];
    final states = campaignIds.isEmpty
        ? <NotificationUserStateRow>[]
        : await NotificationUserStateRow.db.find(
            session,
            where: (t) =>
                t.userId.equals(user.id!) &
                t.campaignId.inSet(campaignIds.toSet()),
          );
    final stateByCampaign = {
      for (final state in states) state.campaignId.toString(): state,
    };

    final visibleItems = <NotificationHistoryItem>[];
    for (final campaign in pageRows) {
      final state = stateByCampaign[campaign.id.toString()];
      if (state?.isDeleted == true) continue;
      visibleItems.add(_toHistoryItem(campaign, state));
    }

    final unreadCount = await _countUnread(session, user.id!, topics);
    final nextPageToken = campaigns.length > safeLimit
        ? encodeCursor({'createdAt': pageRows.last.createdAt.toIso8601String()})
        : null;
    return NotificationHistoryPage(
      items: visibleItems,
      nextPageToken: nextPageToken,
      unreadCount: unreadCount,
    );
  }

  Future<bool> markNotificationRead(
    Session session,
    String firebaseUid,
    String campaignId,
  ) async {
    final user = await _requireUser(session, firebaseUid);
    final campaignUuid = parseUuid(campaignId, fieldName: 'campaignId');
    await _upsertUserState(
      session,
      userId: user.id!,
      campaignId: campaignUuid,
      isRead: true,
      isDeleted: false,
    );
    return true;
  }

  Future<bool> deleteNotification(
    Session session,
    String firebaseUid,
    String campaignId,
  ) async {
    final user = await _requireUser(session, firebaseUid);
    final campaignUuid = parseUuid(campaignId, fieldName: 'campaignId');
    await _upsertUserState(
      session,
      userId: user.id!,
      campaignId: campaignUuid,
      isRead: true,
      isDeleted: true,
    );
    return true;
  }

  Future<bool> createAnnouncement(
    Session session,
    NotificationDraft draft,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    await NotificationOutboxService.instance.enqueueCampaign(
      session: session,
      draft: draft,
      fallbackEntityType: draft.type.trim().isEmpty ? 'system' : draft.type,
      fallbackEntityId: draft.entityId,
    );
    return true;
  }

  Future<AppUserRow> _requireUser(Session session, String firebaseUid) async {
    final normalized = firebaseUid.trim();
    if (normalized.isEmpty) throw Exception('firebaseUid is required.');
    final user = await AppUserRow.db.findFirstRow(
      session,
      where: (t) =>
          t.firebaseUid.equals(normalized) & t.status.equals('active'),
    );
    if (user == null) throw Exception('Active user not found.');
    return user;
  }

  Future<NotificationPreferenceRow> _ensurePreferenceRow(
    Session session,
    String firebaseUid,
  ) async {
    final user = await _requireUser(session, firebaseUid);
    final existing = await NotificationPreferenceRow.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id!),
    );
    if (existing != null) return existing;

    final now = DateTime.now().toUtc();
    try {
      return await NotificationPreferenceRow.db.insertRow(
        session,
        NotificationPreferenceRow(
          userId: user.id!,
          firebaseUid: user.firebaseUid ?? firebaseUid.trim(),
          trackOrderNotifications: true,
          couponNotifications: true,
          offerNotifications: true,
          announcementNotifications: true,
          importantAlerts: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } catch (_) {
      final retry = await NotificationPreferenceRow.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(user.id!),
      );
      if (retry != null) return retry;
      rethrow;
    }
  }

  NotificationPreference _toPreference(NotificationPreferenceRow row) {
    return NotificationPreference(
      trackOrderNotifications: row.trackOrderNotifications,
      couponNotifications: row.couponNotifications,
      offerNotifications: row.offerNotifications,
      announcementNotifications: row.announcementNotifications,
      importantAlerts: row.importantAlerts,
      updatedAt: row.updatedAt,
    );
  }

  List<String> _enabledTopics(NotificationPreferenceRow prefs) {
    return [
      _userTopic(prefs.firebaseUid),
      if (prefs.couponNotifications) 'coupons',
      if (prefs.offerNotifications) 'offers',
      if (prefs.announcementNotifications) 'announcements',
      if (prefs.importantAlerts) 'important-alerts',
      if (prefs.trackOrderNotifications) 'track-order',
    ];
  }

  String _userTopic(String firebaseUid) {
    return 'user-${firebaseUid.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_-]+'), '-')}';
  }

  NotificationHistoryItem _toHistoryItem(
    NotificationCampaignRow campaign,
    NotificationUserStateRow? state,
  ) {
    return NotificationHistoryItem(
      campaignId: campaign.id.toString(),
      title: campaign.title,
      body: campaign.body,
      type: campaign.type,
      topic: campaign.topic,
      imageUrl: campaign.imageUrl,
      targetAudience: campaign.targetAudience,
      entityType: campaign.entityType,
      entityId: campaign.entityId,
      data: _decodeStringMap(campaign.dataJson),
      isRead: state?.isRead ?? false,
      createdAt: campaign.createdAt,
    );
  }

  Map<String, String>? _decodeStringMap(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;
    return {
      for (final entry in decoded.entries)
        if (entry.key != null && entry.value != null)
          entry.key.toString(): entry.value.toString(),
    };
  }

  Future<void> _upsertUserState(
    Session session, {
    required UuidValue userId,
    required UuidValue campaignId,
    required bool isRead,
    required bool isDeleted,
  }) async {
    final now = DateTime.now().toUtc();
    final existing = await NotificationUserStateRow.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.campaignId.equals(campaignId),
    );
    if (existing == null) {
      try {
        await NotificationUserStateRow.db.insertRow(
          session,
          NotificationUserStateRow(
            userId: userId,
            campaignId: campaignId,
            isRead: isRead,
            isDeleted: isDeleted,
            readAt: isRead ? now : null,
            deletedAt: isDeleted ? now : null,
            createdAt: now,
            updatedAt: now,
          ),
        );
        return;
      } catch (_) {
        // Fall through to update in case another request inserted it first.
      }
    }

    final latest =
        existing ??
        await NotificationUserStateRow.db.findFirstRow(
          session,
          where: (t) =>
              t.userId.equals(userId) & t.campaignId.equals(campaignId),
        );
    if (latest == null) {
      throw StateError('Notification user state could not be saved.');
    }
    await NotificationUserStateRow.db.updateById(
      session,
      latest.id!,
      columnValues: (t) => [
        t.isRead(isRead || latest.isRead),
        t.isDeleted(isDeleted || latest.isDeleted),
        if (isRead && latest.readAt == null) t.readAt(now),
        if (isDeleted && latest.deletedAt == null) t.deletedAt(now),
        t.updatedAt(now),
      ],
    );
  }

  Future<int> _countUnread(
    Session session,
    UuidValue userId,
    List<String> topics,
  ) async {
    final campaigns = await NotificationCampaignRow.db.find(
      session,
      where: (t) => t.topic.inSet(topics.toSet()),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: 100,
    );
    if (campaigns.isEmpty) return 0;
    final campaignIds = [
      for (final campaign in campaigns)
        if (campaign.id != null) campaign.id!,
    ];
    final states = await NotificationUserStateRow.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) & t.campaignId.inSet(campaignIds.toSet()),
    );
    final byCampaign = {
      for (final state in states) state.campaignId.toString(): state,
    };
    var count = 0;
    for (final campaign in campaigns) {
      final state = byCampaign[campaign.id.toString()];
      if (state?.isDeleted == true) continue;
      if (state?.isRead != true) count++;
    }
    return count;
  }
}
