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
        entityType: entityType,
        entityId: entityId,
        dataJson: data.isEmpty ? null : jsonEncode(data),
        createdAt: now,
      ),
    );

    final dedupeKey = 'campaign:${campaign.id}';
    final payload = <String, dynamic>{
      'campaignId': campaign.id.toString(),
      'title': campaign.title,
      'body': campaign.body,
      'type': campaign.type,
      'topic': campaign.topic,
      if (campaign.imageUrl != null) 'imageUrl': campaign.imageUrl,
      'data': data,
    };

    try {
      await NotificationOutboxRow.db.insertRow(
        session,
        NotificationOutboxRow(
          dedupeKey: dedupeKey,
          campaignId: campaign.id!,
          payloadJson: jsonEncode(payload),
          createdAt: now,
          updatedAt: now,
        ),
      );
    } catch (_) {
      final existing = await NotificationOutboxRow.db.findFirstRow(
        session,
        where: (t) => t.dedupeKey.equals(dedupeKey),
      );
      if (existing == null) rethrow;
    }

    _kickBackgroundProcessing();
    return campaign;
  }

  Future<void> sendOutboxRow(
    Session session,
    NotificationOutboxRow row,
  ) async {
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

    await NotificationService.sendToTopic(
      topic: topic,
      title: title,
      body: body,
      data: data,
      imageUrl: payload['imageUrl']?.toString(),
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

  void _kickBackgroundProcessing() {
    if (!BackgroundTaskService.isConfigured) return;
    unawaited(BackgroundTaskService.instance.run());
  }
}
