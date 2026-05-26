import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/notification_outbox_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_support.dart';

class NotificationEndpoint extends Endpoint {
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final NotificationOutboxService _outbox = NotificationOutboxService.instance;

  Future<bool> registerFcmToken(
    Session session,
    String firebaseUid,
    String token,
    String deviceId,
    String platform,
  ) async {
    final user = await _requireUser(session, firebaseUid);
    final normalizedToken = token.trim();
    final normalizedDevice = deviceId.trim();
    if (normalizedToken.isEmpty) throw Exception('token is required.');
    if (normalizedDevice.isEmpty) throw Exception('deviceId is required.');
    final now = DateTime.now().toUtc();
    final existing = await UserFcmTokenRow.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(user.id!) & t.deviceId.equals(normalizedDevice),
    );

    if (existing == null) {
      await UserFcmTokenRow.db.insertRow(
        session,
        UserFcmTokenRow(
          userId: user.id!,
          firebaseUid: user.firebaseUid ?? firebaseUid.trim(),
          fcmToken: normalizedToken,
          deviceId: normalizedDevice,
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
          t.fcmToken(normalizedToken),
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
        t.fcmToken(normalizedToken),
        t.updatedAt(now),
      ],
    );
    return true;
  }

  Future<bool> unregisterFcmToken(
    Session session,
    String firebaseUid,
    String deviceId, {
    String? token,
  }) async {
    final user = await _requireUser(session, firebaseUid);
    await _deactivateDeviceToken(
      session,
      user: user,
      deviceId: deviceId,
      token: token,
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

    final cursor = decodeCursor(pageToken);
    final before = cursor?['createdAt'] is String
        ? DateTime.tryParse(cursor!['createdAt'] as String)
        : null;
    final safeLimit = clampPageLimit(limit, defaultLimit: 30, maxLimit: 100);

    final topicCampaigns = topics.isEmpty
        ? <NotificationCampaignRow>[]
        : await NotificationCampaignRow.db.find(
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

    final targetedStates = await NotificationUserStateRow.db.find(
      session,
      where: (t) => t.userId.equals(user.id!) & t.isDeleted.equals(false),
      orderBy: (t) => t.updatedAt,
      orderDescending: true,
      limit: safeLimit + 1,
    );
    final targetedIds = {
      for (final state in targetedStates) state.campaignId,
    };
    final targetedCampaigns = targetedIds.isEmpty
        ? <NotificationCampaignRow>[]
        : await NotificationCampaignRow.db.find(
            session,
            where: (t) {
              var expression = t.id.inSet(targetedIds);
              if (before != null) {
                expression = expression & (t.createdAt < before);
              }
              return expression;
            },
          );

    final campaignById = <String, NotificationCampaignRow>{
      for (final campaign in topicCampaigns) campaign.id.toString(): campaign,
      for (final campaign in targetedCampaigns)
        campaign.id.toString(): campaign,
    };
    final combined = campaignById.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final pageRows = combined.take(safeLimit).toList();
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
    final nextPageToken = combined.length > safeLimit
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
    await createBroadcast(
      session,
      BroadcastRequest(
        title: draft.title,
        body: draft.body,
        imageUrl: draft.imageUrl,
        announcementType: draft.type.trim().isEmpty ? 'general' : draft.type,
        targetAudience: draft.targetAudience,
        priority: 'normal',
        entityType: draft.entityType,
        entityId: draft.entityId,
        data: draft.data,
      ),
      firebaseUid,
      idToken,
    );
    return true;
  }

  Future<List<AdminNotificationPreference>> getAdminNotificationPreferences(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    final admin = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final rows = await _ensureAdminPreferenceRows(session, admin);
    final byKey = {for (final row in rows) row.preferenceKey: row};
    return [
      for (final definition in _adminPreferenceDefinitions)
        _toAdminPreference(definition, byKey[definition.key]),
    ];
  }

  Future<AdminNotificationPreference> updateAdminNotificationPreference(
    Session session,
    String firebaseUid,
    String idToken,
    String key,
    bool pushEnabled,
    bool soundEnabled,
  ) async {
    final admin = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final definition = _adminPreferenceDefinition(key);
    if (definition.critical && (!pushEnabled || !soundEnabled)) {
      throw Exception('${definition.title} cannot be disabled.');
    }
    await _ensureAdminPreferenceRows(session, admin);
    final row = await AdminNotificationPreferenceRow.db.findFirstRow(
      session,
      where: (t) =>
          t.adminUserId.equals(admin.id!) &
          t.preferenceKey.equals(definition.key),
    );
    if (row == null) {
      throw StateError('Admin notification preference was not created.');
    }
    final now = DateTime.now().toUtc();
    final updated = await AdminNotificationPreferenceRow.db.updateById(
      session,
      row.id!,
      columnValues: (t) => [
        t.pushEnabled(definition.critical ? true : pushEnabled),
        t.soundEnabled(definition.critical ? true : soundEnabled),
        t.critical(definition.critical),
        t.updatedAt(now),
      ],
    );
    return _toAdminPreference(
      definition,
      updated ??
          row.copyWith(
            pushEnabled: definition.critical ? true : pushEnabled,
            soundEnabled: definition.critical ? true : soundEnabled,
            updatedAt: now,
          ),
    );
  }

  Future<bool> registerAdminFcmToken(
    Session session,
    String firebaseUid,
    String idToken,
    String token,
    String deviceId,
    String platform,
  ) async {
    final admin = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final normalizedToken = token.trim();
    final normalizedDevice = deviceId.trim();
    if (normalizedToken.isEmpty) throw Exception('token is required.');
    if (normalizedDevice.isEmpty) throw Exception('deviceId is required.');
    final now = DateTime.now().toUtc();
    final existing = await UserFcmTokenRow.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(admin.id!) & t.deviceId.equals(normalizedDevice),
    );
    if (existing == null) {
      await UserFcmTokenRow.db.insertRow(
        session,
        UserFcmTokenRow(
          userId: admin.id!,
          firebaseUid: admin.firebaseUid ?? firebaseUid.trim(),
          fcmToken: normalizedToken,
          deviceId: normalizedDevice,
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
          t.firebaseUid(admin.firebaseUid ?? firebaseUid.trim()),
          t.fcmToken(normalizedToken),
          t.platform(platform.trim().isEmpty ? 'unknown' : platform.trim()),
          t.isActive(true),
          t.updatedAt(now),
        ],
      );
    }
    return true;
  }

  Future<bool> unregisterAdminFcmToken(
    Session session,
    String firebaseUid,
    String idToken,
    String deviceId, {
    String? token,
  }) async {
    final admin = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    await _deactivateDeviceToken(
      session,
      user: admin,
      deviceId: deviceId,
      token: token,
    );
    return true;
  }

  Future<BroadcastSummary> createBroadcast(
    Session session,
    BroadcastRequest request,
    String firebaseUid,
    String idToken,
  ) async {
    final admin = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final campaign = await _outbox.saveBroadcast(
      session: session,
      request: request,
      creatorAdminFirebaseUid: admin.firebaseUid ?? firebaseUid.trim(),
      asDraft: false,
    );
    return _toBroadcastSummary(campaign);
  }

  Future<BroadcastSummary> saveBroadcastDraft(
    Session session,
    BroadcastRequest request,
    String firebaseUid,
    String idToken,
  ) async {
    final admin = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final campaign = await _outbox.saveBroadcast(
      session: session,
      request: request,
      creatorAdminFirebaseUid: admin.firebaseUid ?? firebaseUid.trim(),
      asDraft: true,
    );
    return _toBroadcastSummary(campaign);
  }

  Future<BroadcastSummary> sendBroadcastDraft(
    Session session,
    String firebaseUid,
    String idToken,
    String broadcastId,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final campaign = await _findBroadcast(session, broadcastId);
    final updated = await _outbox.queueDraft(session, campaign);
    return _toBroadcastSummary(updated);
  }

  Future<BroadcastPage> listBroadcasts(
    Session session,
    String firebaseUid,
    String idToken, {
    String? status,
    String? query,
    int limit = 30,
    String? pageToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final cursor = decodeCursor(pageToken);
    final before = cursor?['createdAt'] is String
        ? DateTime.tryParse(cursor!['createdAt'] as String)
        : null;
    final safeLimit = clampPageLimit(limit, defaultLimit: 30, maxLimit: 100);
    final normalizedStatus = cleanNullableString(status)?.toLowerCase();
    final rows = await NotificationCampaignRow.db.find(
      session,
      where: (t) {
        var expression = t.topic.inSet({'announcements', 'important-alerts'});
        if (normalizedStatus != null && normalizedStatus != 'all') {
          expression = expression & t.status.equals(normalizedStatus);
        }
        if (before != null) {
          expression = expression & (t.createdAt < before);
        }
        return expression;
      },
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: safeLimit + 1,
    );
    final normalizedQuery = cleanNullableString(query)?.toLowerCase();
    final filtered = normalizedQuery == null
        ? rows
        : rows
              .where(
                (row) =>
                    row.title.toLowerCase().contains(normalizedQuery) ||
                    row.body.toLowerCase().contains(normalizedQuery) ||
                    row.type.toLowerCase().contains(normalizedQuery),
              )
              .toList();
    final pageRows = filtered.take(safeLimit).toList();
    return BroadcastPage(
      items: pageRows.map(_toBroadcastSummary).toList(),
      nextPageToken: filtered.length > safeLimit
          ? encodeCursor({
              'createdAt': pageRows.last.createdAt.toIso8601String(),
            })
          : null,
      totalCount: filtered.length,
    );
  }

  Future<bool> deleteBroadcastDraft(
    Session session,
    String firebaseUid,
    String idToken,
    String broadcastId,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final campaign = await _findBroadcast(session, broadcastId);
    if (campaign.status != 'draft') {
      throw Exception('Only draft broadcasts can be deleted.');
    }
    await NotificationCampaignRow.db.deleteRow(session, campaign);
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

  Future<void> _deactivateDeviceToken(
    Session session, {
    required AppUserRow user,
    required String deviceId,
    String? token,
  }) async {
    final normalizedDevice = deviceId.trim();
    if (normalizedDevice.isEmpty) throw Exception('deviceId is required.');
    final normalizedToken = token?.trim();
    final now = DateTime.now().toUtc();

    final row = await UserFcmTokenRow.db.findFirstRow(
      session,
      where: (t) {
        var expression =
            t.userId.equals(user.id!) & t.deviceId.equals(normalizedDevice);
        if (normalizedToken != null && normalizedToken.isNotEmpty) {
          expression = expression & t.fcmToken.equals(normalizedToken);
        }
        return expression;
      },
    );

    if (row == null) {
      await _clearLegacyTokenIfUnused(session, user, normalizedToken, now);
      return;
    }

    await UserFcmTokenRow.db.updateById(
      session,
      row.id!,
      columnValues: (t) => [
        t.isActive(false),
        t.updatedAt(now),
      ],
    );
    await _clearLegacyTokenIfUnused(session, user, row.fcmToken.trim(), now);
  }

  Future<void> _clearLegacyTokenIfUnused(
    Session session,
    AppUserRow user,
    String? token,
    DateTime now,
  ) async {
    final normalizedToken = token?.trim();
    if (normalizedToken == null || normalizedToken.isEmpty) return;
    if (user.fcmToken?.trim() != normalizedToken) return;

    final activeRows = await UserFcmTokenRow.db.find(
      session,
      where: (t) => t.userId.equals(user.id!) & t.isActive.equals(true),
      limit: 1,
    );
    if (activeRows.isNotEmpty) return;

    await AppUserRow.db.updateById(
      session,
      user.id!,
      columnValues: (t) => [
        t.fcmToken(null),
        t.updatedAt(now),
      ],
    );
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

  Future<List<AdminNotificationPreferenceRow>> _ensureAdminPreferenceRows(
    Session session,
    AppUserRow admin,
  ) async {
    final existing = await AdminNotificationPreferenceRow.db.find(
      session,
      where: (t) => t.adminUserId.equals(admin.id!),
    );
    final existingKeys = {for (final row in existing) row.preferenceKey};
    final now = DateTime.now().toUtc();
    for (final definition in _adminPreferenceDefinitions) {
      if (existingKeys.contains(definition.key)) continue;
      try {
        await AdminNotificationPreferenceRow.db.insertRow(
          session,
          AdminNotificationPreferenceRow(
            adminUserId: admin.id!,
            adminFirebaseUid: admin.firebaseUid ?? '',
            preferenceKey: definition.key,
            pushEnabled: true,
            soundEnabled: true,
            critical: definition.critical,
            createdAt: now,
            updatedAt: now,
          ),
        );
      } catch (_) {
        // Another request inserted the default row.
      }
    }
    return AdminNotificationPreferenceRow.db.find(
      session,
      where: (t) => t.adminUserId.equals(admin.id!),
    );
  }

  _AdminPreferenceDefinition _adminPreferenceDefinition(String key) {
    final normalized = key.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '_',
    );
    for (final definition in _adminPreferenceDefinitions) {
      if (definition.key == normalized) return definition;
    }
    throw Exception('Unknown notification preference.');
  }

  AdminNotificationPreference _toAdminPreference(
    _AdminPreferenceDefinition definition,
    AdminNotificationPreferenceRow? row,
  ) {
    return AdminNotificationPreference(
      key: definition.key,
      title: definition.title,
      group: definition.group,
      pushEnabled: definition.critical ? true : row?.pushEnabled ?? true,
      soundEnabled: definition.critical ? true : row?.soundEnabled ?? true,
      critical: definition.critical,
      updatedAt: row?.updatedAt,
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
    final campaigns = topics.isEmpty
        ? <NotificationCampaignRow>[]
        : await NotificationCampaignRow.db.find(
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
    final targetedStates = await NotificationUserStateRow.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isDeleted.equals(false),
      limit: 100,
    );
    count += targetedStates.where((state) => !state.isRead).length;
    return count;
  }

  Future<NotificationCampaignRow> _findBroadcast(
    Session session,
    String broadcastId,
  ) async {
    final id = parseUuid(broadcastId, fieldName: 'broadcastId');
    final campaign = await NotificationCampaignRow.db.findById(session, id);
    if (campaign == null) throw Exception('Broadcast not found.');
    return campaign;
  }

  BroadcastSummary _toBroadcastSummary(NotificationCampaignRow row) {
    return BroadcastSummary(
      id: row.id.toString(),
      title: row.title,
      body: row.body,
      imageUrl: row.imageUrl,
      announcementType: row.type,
      targetAudience: row.targetAudience,
      priority: row.priority,
      status: row.status,
      scheduledAt: row.scheduledAt,
      createdAt: row.createdAt,
      sentAt: row.sentAt,
      recipientCount: row.recipientCount,
      successCount: row.successCount,
      failureCount: row.failureCount,
      lastError: row.lastError,
    );
  }
}

const List<_AdminPreferenceDefinition> _adminPreferenceDefinitions = [
  _AdminPreferenceDefinition('new_orders', 'New Orders', 'Operational'),
  _AdminPreferenceDefinition('complaints', 'Complaints', 'Operational'),
  _AdminPreferenceDefinition('payment_alerts', 'Payment Alerts', 'Operational'),
  _AdminPreferenceDefinition('delivery_alerts', 'Delivery Alerts', 'Delivery'),
  _AdminPreferenceDefinition(
    'low_stock_alerts',
    'Low Stock Alerts',
    'Inventory',
  ),
  _AdminPreferenceDefinition(
    'out_of_stock_alerts',
    'Out Of Stock Alerts',
    'Inventory',
  ),
  _AdminPreferenceDefinition(
    'new_user_registration',
    'New User Registration',
    'Users',
  ),
  _AdminPreferenceDefinition(
    'new_device_login',
    'New Device Login',
    'Security',
  ),
  _AdminPreferenceDefinition('login_alerts', 'Login Alerts', 'Security'),
  _AdminPreferenceDefinition(
    'suspicious_login',
    'Suspicious Login',
    'Security',
    critical: true,
  ),
  _AdminPreferenceDefinition(
    'security_alerts',
    'Security Alerts',
    'Security',
    critical: true,
  ),
  _AdminPreferenceDefinition(
    'fraud_alerts',
    'Fraud Alerts',
    'Security',
    critical: true,
  ),
  _AdminPreferenceDefinition(
    'maintenance_alerts',
    'Maintenance Alerts',
    'System',
  ),
  _AdminPreferenceDefinition('server_alerts', 'Server Alerts', 'System'),
];

class _AdminPreferenceDefinition {
  const _AdminPreferenceDefinition(
    this.key,
    this.title,
    this.group, {
    this.critical = false,
  });

  final String key;
  final String title;
  final String group;
  final bool critical;
}
