import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'background_task_service.dart';
import 'notification_service.dart';
import 'postgres/postgres_support.dart';

class NotificationOutboxService {
  static final NotificationOutboxService instance =
      NotificationOutboxService._();

  NotificationOutboxService._();

  Future<NotificationCampaignRow?> enqueueTopicNotification({
    required Session session,
    required String topic,
    required String title,
    required String body,
    required String type,
    String? entityType,
    String? entityId,
    String? imageUrl,
    String targetAudience = 'all',
    Map<String, String>? data,
  }) {
    return enqueueCampaign(
      session: session,
      draft: NotificationDraft(
        enabled: true,
        title: title,
        body: body,
        type: type,
        topic: topic,
        imageUrl: imageUrl,
        targetAudience: targetAudience,
        entityType: entityType,
        entityId: entityId,
        data: data,
      ),
      fallbackEntityType: entityType ?? type,
      fallbackEntityId: entityId,
    );
  }

  Future<NotificationCampaignRow?> enqueueCampaign({
    required Session session,
    required NotificationDraft? draft,
    required String fallbackEntityType,
    required String? fallbackEntityId,
    Map<String, String>? extraData,
  }) async {
    if (draft == null || !draft.enabled) return null;

    final title = draft.title.trim();
    final body = draft.body.trim();
    final topic = _normalizeTopic(draft.topic);
    final type = draft.type.trim().isEmpty
        ? fallbackEntityType
        : draft.type.trim();
    if (title.isEmpty || body.isEmpty || topic.isEmpty) return null;

    final data = <String, String>{
      if (draft.data != null) ...draft.data!,
      if (extraData != null) ...extraData,
      'type': type,
      'topic': topic,
    };
    final entityType =
        cleanNullableString(draft.entityType) ?? fallbackEntityType;
    final entityId =
        cleanNullableString(draft.entityId) ??
        cleanNullableString(fallbackEntityId);
    data['entityType'] = entityType;
    if (entityId != null) data['entityId'] = entityId;

    final now = DateTime.now().toUtc();
    final campaign = await NotificationCampaignRow.db.insertRow(
      session,
      NotificationCampaignRow(
        title: title,
        body: body,
        type: type,
        topic: topic,
        imageUrl: cleanNullableString(draft.imageUrl),
        targetAudience: draft.targetAudience.trim().isEmpty
            ? 'all'
            : draft.targetAudience.trim(),
        status: 'queued',
        priority: 'normal',
        scheduledAt: null,
        entityType: entityType,
        entityId: entityId,
        dataJson: data.isEmpty ? null : jsonEncode(data),
        createdAt: now,
      ),
    );

    await queueCampaign(session, campaign, data: data);

    _kickBackgroundProcessing();
    return campaign;
  }

  Future<NotificationCampaignRow> saveBroadcast({
    required Session session,
    required BroadcastRequest request,
    required String creatorAdminFirebaseUid,
    required bool asDraft,
  }) async {
    final validated = _validateBroadcastRequest(request);
    final now = DateTime.now().toUtc();
    final scheduledAt = validated.scheduledAt?.toUtc();
    final status = asDraft ? 'draft' : _initialStatus(scheduledAt, now);
    final topic = _topicForAnnouncementType(validated.announcementType);
    final data = _broadcastData(validated, topic);
    final targetMetadata = _targetMetadata(validated);

    final campaign = await NotificationCampaignRow.db.insertRow(
      session,
      NotificationCampaignRow(
        title: validated.title.trim(),
        body: validated.body.trim(),
        type: validated.announcementType.trim(),
        topic: topic,
        imageUrl: cleanNullableString(validated.imageUrl),
        targetAudience: _normalizeTargetAudience(validated.targetAudience),
        status: status,
        priority: _normalizePriority(validated.priority),
        scheduledAt: scheduledAt,
        creatorAdminFirebaseUid: creatorAdminFirebaseUid.trim(),
        targetMetadataJson: targetMetadata.isEmpty
            ? null
            : jsonEncode(targetMetadata),
        entityType: cleanNullableString(validated.entityType),
        entityId: cleanNullableString(validated.entityId),
        dataJson: data.isEmpty ? null : jsonEncode(data),
        createdAt: now,
      ),
    );

    if (!asDraft) {
      await queueCampaign(session, campaign, data: data);
      _kickBackgroundProcessing();
    }

    return campaign;
  }

  Future<NotificationCampaignRow> queueDraft(
    Session session,
    NotificationCampaignRow draft,
  ) async {
    if (draft.status != 'draft') {
      throw Exception('Only draft broadcasts can be sent.');
    }
    final now = DateTime.now().toUtc();
    final status = _initialStatus(draft.scheduledAt, now);
    final updated = await NotificationCampaignRow.db.updateById(
      session,
      draft.id!,
      columnValues: (t) => [
        t.status(status),
        t.lastError(null),
      ],
    );
    final campaign = updated ?? draft.copyWith(status: status, lastError: null);
    await queueCampaign(session, campaign);
    _kickBackgroundProcessing();
    return campaign;
  }

  Future<void> queueCampaign(
    Session session,
    NotificationCampaignRow campaign, {
    Map<String, String>? data,
  }) async {
    final now = DateTime.now().toUtc();
    final payload = <String, dynamic>{
      'campaignId': campaign.id.toString(),
      'title': campaign.title,
      'body': campaign.body,
      'type': campaign.type,
      'topic': campaign.topic,
      'targetAudience': campaign.targetAudience,
      if (campaign.imageUrl != null) 'imageUrl': campaign.imageUrl,
      'data': data ?? _decodeStringMap(campaign.dataJson),
    };
    final nextAttemptAt =
        campaign.scheduledAt != null &&
            campaign.scheduledAt!.toUtc().isAfter(now)
        ? campaign.scheduledAt!.toUtc()
        : now;

    try {
      await NotificationOutboxRow.db.insertRow(
        session,
        NotificationOutboxRow(
          dedupeKey: 'campaign:${campaign.id}',
          campaignId: campaign.id!,
          payloadJson: jsonEncode(payload),
          status: campaign.status == 'scheduled' ? 'scheduled' : 'queued',
          nextAttemptAt: nextAttemptAt,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } catch (_) {
      final existing = await NotificationOutboxRow.db.findFirstRow(
        session,
        where: (t) => t.dedupeKey.equals('campaign:${campaign.id}'),
      );
      if (existing == null) rethrow;
    }
  }

  Future<void> sendOutboxRow(
    Session session,
    NotificationOutboxRow row,
  ) async {
    final campaign = await NotificationCampaignRow.db.findById(
      session,
      row.campaignId,
    );
    if (campaign == null) {
      throw StateError('Notification campaign ${row.campaignId} not found.');
    }
    if (campaign.scheduledAt != null &&
        campaign.scheduledAt!.toUtc().isAfter(DateTime.now().toUtc())) {
      return;
    }
    final payload = _payload(row);
    final title = payload['title']?.toString() ?? '';
    final body = payload['body']?.toString() ?? '';
    final topic = _normalizeTopic(payload['topic']?.toString() ?? '');
    if (title.isEmpty || body.isEmpty || topic.isEmpty) {
      throw StateError(
        'Notification outbox row ${row.id} has invalid payload.',
      );
    }

    final data = <String, String>{};
    final rawData = payload['data'];
    if (rawData is Map) {
      for (final entry in rawData.entries) {
        if (entry.key == null || entry.value == null) continue;
        data[entry.key.toString()] = entry.value.toString();
      }
    }
    data['campaignId'] = row.campaignId.toString();

    final targetAudience = _normalizeTargetAudience(campaign.targetAudience);
    if (_isAllUsersAudience(targetAudience)) {
      await NotificationService.sendToTopic(
        topic: topic,
        title: title,
        body: body,
        data: data,
        imageUrl: payload['imageUrl']?.toString(),
      );
      await _markCampaignSent(session, campaign, recipientCount: 0);
      return;
    }

    final users = await _resolveTargetUsers(session, campaign);
    var success = 0;
    var failure = 0;
    for (final user in users) {
      await _ensureUserState(session, campaign.id!, user.id!);
      final tokens = await UserFcmTokenRow.db.find(
        session,
        where: (t) => t.userId.equals(user.id!) & t.isActive.equals(true),
        limit: 20,
      );
      final tokenSet = {
        for (final token in tokens)
          if (token.fcmToken.trim().isNotEmpty) token.fcmToken.trim(),
        if (user.fcmToken != null && user.fcmToken!.trim().isNotEmpty)
          user.fcmToken!.trim(),
      };
      for (final token in tokenSet) {
        try {
          await NotificationService.sendToToken(
            token: token,
            title: title,
            body: body,
            data: data,
          );
          success++;
        } catch (error) {
          failure++;
          session.log(
            'FCM token send failed for campaign ${campaign.id}: $error',
            level: LogLevel.warning,
          );
        }
      }
    }
    await _markCampaignSent(
      session,
      campaign,
      recipientCount: users.length,
      successCount: success,
      failureCount: failure,
    );
  }

  Map<String, dynamic> _payload(NotificationOutboxRow row) {
    final decoded = jsonDecode(row.payloadJson);
    if (decoded is Map<String, dynamic>) return decoded;
    throw StateError(
      'Notification outbox row ${row.id} payload is not an object.',
    );
  }

  String _normalizeTopic(String topic) {
    return topic.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_-]+'), '-');
  }

  BroadcastRequest _validateBroadcastRequest(BroadcastRequest request) {
    if (request.title.trim().isEmpty) {
      throw Exception('Title is required.');
    }
    if (request.body.trim().isEmpty) {
      throw Exception('Description is required.');
    }
    final type = _normalizeAnnouncementType(request.announcementType);
    final targetAudience = _normalizeTargetAudience(request.targetAudience);
    if (targetAudience == 'specific_users' &&
        (request.data?['userIds']?.trim().isEmpty ?? true) &&
        (request.data?['firebaseUids']?.trim().isEmpty ?? true)) {
      throw Exception('Specific users require userIds or firebaseUids.');
    }
    if (type == 'offer_coupon' &&
        cleanNullableString(request.couponCode) == null) {
      throw Exception('Offer/Coupon broadcasts require a coupon.');
    }
    if (type == 'delivery_update' &&
        cleanNullableString(request.city) == null &&
        cleanNullableString(request.affectedArea) == null) {
      throw Exception('Delivery updates require a city or affected area.');
    }
    if (type == 'system_alert' &&
        cleanNullableString(request.urgency) == null) {
      throw Exception('System alerts require urgency.');
    }
    return request.copyWith(
      announcementType: type,
      targetAudience: targetAudience,
      priority: _normalizePriority(request.priority),
    );
  }

  String _initialStatus(DateTime? scheduledAt, DateTime now) {
    if (scheduledAt != null && scheduledAt.toUtc().isAfter(now)) {
      return 'scheduled';
    }
    return 'queued';
  }

  String _topicForAnnouncementType(String type) {
    return type == 'system_alert' ? 'important-alerts' : 'announcements';
  }

  String _normalizeAnnouncementType(String type) {
    final normalized = type.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '_',
    );
    return switch (normalized) {
      'promotion' => 'promotion',
      'delivery' || 'delivery_update' => 'delivery_update',
      'service' || 'service_update' => 'service_update',
      'system' || 'system_alert' => 'system_alert',
      'offer' || 'coupon' || 'offer_coupon' => 'offer_coupon',
      'festival' || 'festival_greeting' => 'festival_greeting',
      'order' || 'order_related' => 'order_related',
      _ => 'general',
    };
  }

  String _normalizePriority(String priority) {
    final normalized = priority.trim().toLowerCase();
    return switch (normalized) {
      'low' => 'low',
      'high' => 'high',
      'urgent' => 'urgent',
      _ => 'normal',
    };
  }

  String _normalizeTargetAudience(String value) {
    final normalized = value.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '_',
    );
    return switch (normalized) {
      '' || 'all' || 'all_users' => 'all_users',
      'specific' || 'specific_users' => 'specific_users',
      'city' || 'users_by_city' => 'users_by_city',
      'premium' || 'premium_users' => 'premium_users',
      'active' || 'active_users' => 'active_users',
      'inactive' || 'inactive_users' => 'inactive_users',
      'order_history' || 'users_by_order_history' => 'users_by_order_history',
      _ => normalized,
    };
  }

  bool _isAllUsersAudience(String targetAudience) {
    return targetAudience == 'all_users' || targetAudience == 'all';
  }

  Map<String, String> _broadcastData(BroadcastRequest request, String topic) {
    return {
      if (request.data != null) ...request.data!,
      'type': request.announcementType,
      'topic': topic,
      'targetAudience': request.targetAudience,
      'priority': request.priority,
      if (cleanNullableString(request.couponCode) != null)
        'couponCode': request.couponCode!.trim(),
      if (cleanNullableString(request.city) != null)
        'city': request.city!.trim(),
      if (cleanNullableString(request.affectedArea) != null)
        'affectedArea': request.affectedArea!.trim(),
      if (cleanNullableString(request.urgency) != null)
        'urgency': request.urgency!.trim(),
    };
  }

  Map<String, String> _targetMetadata(BroadcastRequest request) {
    return {
      if (cleanNullableString(request.city) != null)
        'city': request.city!.trim(),
      if (cleanNullableString(request.affectedArea) != null)
        'affectedArea': request.affectedArea!.trim(),
      if (cleanNullableString(request.couponCode) != null)
        'couponCode': request.couponCode!.trim(),
      if (cleanNullableString(request.urgency) != null)
        'urgency': request.urgency!.trim(),
      if (request.data?['orderBucket'] != null)
        'orderBucket': request.data!['orderBucket']!,
      if (request.data?['userIds'] != null)
        'userIds': request.data!['userIds']!,
      if (request.data?['firebaseUids'] != null)
        'firebaseUids': request.data!['firebaseUids']!,
    };
  }

  Map<String, String> _decodeStringMap(String? raw) {
    if (raw == null || raw.isEmpty) return const {};
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return const {};
    return {
      for (final entry in decoded.entries)
        if (entry.key != null && entry.value != null)
          entry.key.toString(): entry.value.toString(),
    };
  }

  Future<List<AppUserRow>> _resolveTargetUsers(
    Session session,
    NotificationCampaignRow campaign,
  ) async {
    final targetAudience = _normalizeTargetAudience(campaign.targetAudience);
    final metadata = _decodeStringMap(campaign.targetMetadataJson);
    switch (targetAudience) {
      case 'active_users':
        return AppUserRow.db.find(
          session,
          where: (t) => t.role.equals('customer') & t.status.equals('active'),
          limit: 500,
        );
      case 'inactive_users':
        return AppUserRow.db.find(
          session,
          where: (t) => t.role.equals('customer') & t.status.equals('inactive'),
          limit: 500,
        );
      case 'specific_users':
        return _resolveSpecificUsers(session, metadata);
      case 'users_by_city':
        return _resolveUsersByCity(session, metadata);
      case 'premium_users':
        return _resolveUsersByDeliveredOrderBucket(session, min: 10);
      case 'users_by_order_history':
        return _resolveOrderHistoryBucket(session, metadata['orderBucket']);
      default:
        return AppUserRow.db.find(
          session,
          where: (t) => t.role.equals('customer') & t.status.equals('active'),
          limit: 500,
        );
    }
  }

  Future<List<AppUserRow>> _resolveSpecificUsers(
    Session session,
    Map<String, String> metadata,
  ) async {
    final ids = _splitCsv(
      metadata['userIds'],
    ).map((id) => tryParseUuid(id)).whereType<UuidValue>().toSet();
    final firebaseUids = _splitCsv(metadata['firebaseUids']).toSet();
    if (ids.isEmpty && firebaseUids.isEmpty) return const [];
    return AppUserRow.db.find(
      session,
      where: (t) {
        var expression = t.status.equals('active') & t.role.equals('customer');
        if (ids.isNotEmpty && firebaseUids.isNotEmpty) {
          expression =
              expression &
              (t.id.inSet(ids) | t.firebaseUid.inSet(firebaseUids));
        } else if (ids.isNotEmpty) {
          expression = expression & t.id.inSet(ids);
        } else {
          expression = expression & t.firebaseUid.inSet(firebaseUids);
        }
        return expression;
      },
      limit: 500,
    );
  }

  Future<List<AppUserRow>> _resolveUsersByCity(
    Session session,
    Map<String, String> metadata,
  ) async {
    final city = cleanNullableString(metadata['city']);
    if (city == null) return const [];
    final addresses = await UserAddressRow.db.find(
      session,
      where: (t) => t.city.equals(city),
      limit: 1000,
    );
    final ids = {for (final address in addresses) address.userId};
    if (ids.isEmpty) return const [];
    return AppUserRow.db.find(
      session,
      where: (t) =>
          t.id.inSet(ids) &
          t.status.equals('active') &
          t.role.equals('customer'),
      limit: 500,
    );
  }

  Future<List<AppUserRow>> _resolveOrderHistoryBucket(
    Session session,
    String? bucket,
  ) {
    final normalized = bucket?.trim().toLowerCase();
    return switch (normalized) {
      'no_orders' ||
      '0' => _resolveUsersByDeliveredOrderBucket(session, max: 0),
      '1_3' ||
      '1-3' => _resolveUsersByDeliveredOrderBucket(session, min: 1, max: 3),
      '4_9' ||
      '4-9' => _resolveUsersByDeliveredOrderBucket(session, min: 4, max: 9),
      '10_plus' ||
      '10+' => _resolveUsersByDeliveredOrderBucket(session, min: 10),
      _ => _resolveUsersByDeliveredOrderBucket(session, min: 1),
    };
  }

  Future<List<AppUserRow>> _resolveUsersByDeliveredOrderBucket(
    Session session, {
    int? min,
    int? max,
  }) async {
    final having = [
      if (min != null) 'COUNT(o.id) >= @min',
      if (max != null) 'COUNT(o.id) <= @max',
    ].join(' AND ');
    final parameters = <String, dynamic>{};
    if (min != null) parameters['min'] = min;
    if (max != null) parameters['max'] = max;
    final result = await session.db.unsafeQuery(
      '''
      SELECT u.id::text AS "userId"
      FROM app_user u
      LEFT JOIN customer_order o
        ON o."userId" = u.id
       AND lower(o."orderStatus") = 'delivered'
      WHERE u.role = 'customer'
        AND u.status = 'active'
      GROUP BY u.id
      ${having.isEmpty ? '' : 'HAVING $having'}
      LIMIT 500
      ''',
      parameters: QueryParameters.named(parameters),
    );
    final ids = <UuidValue>{};
    for (final row in result) {
      final id = tryParseUuid(row.toColumnMap()['userId']?.toString());
      if (id != null) ids.add(id);
    }
    if (ids.isEmpty) return const [];
    return AppUserRow.db.find(
      session,
      where: (t) => t.id.inSet(ids),
      limit: 500,
    );
  }

  List<String> _splitCsv(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    return raw
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }

  Future<void> _ensureUserState(
    Session session,
    UuidValue campaignId,
    UuidValue userId,
  ) async {
    final existing = await NotificationUserStateRow.db.findFirstRow(
      session,
      where: (t) => t.campaignId.equals(campaignId) & t.userId.equals(userId),
    );
    if (existing != null) return;
    final now = DateTime.now().toUtc();
    try {
      await NotificationUserStateRow.db.insertRow(
        session,
        NotificationUserStateRow(
          campaignId: campaignId,
          userId: userId,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } catch (_) {
      // Another worker/request inserted the same state row.
    }
  }

  Future<void> _markCampaignSent(
    Session session,
    NotificationCampaignRow campaign, {
    required int recipientCount,
    int successCount = 0,
    int failureCount = 0,
  }) async {
    final now = DateTime.now().toUtc();
    await NotificationCampaignRow.db.updateById(
      session,
      campaign.id!,
      columnValues: (t) => [
        t.status(failureCount > 0 && successCount == 0 ? 'failed' : 'sent'),
        t.recipientCount(recipientCount),
        t.successCount(successCount),
        t.failureCount(failureCount),
        t.lastError(null),
        t.sentAt(now),
      ],
    );
  }

  void _kickBackgroundProcessing() {
    if (!BackgroundTaskService.isConfigured) return;
    unawaited(BackgroundTaskService.instance.run());
  }
}
