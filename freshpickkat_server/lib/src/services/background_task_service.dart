import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'firebase_notification_service.dart';
import 'notification_outbox_service.dart';
import 'realtime_service.dart';

class BackgroundTaskService {
  static const int _drainLock = 4200201;

  static BackgroundTaskService? _instance;

  static bool get isConfigured => _instance != null;

  static BackgroundTaskService get instance {
    final configured = _instance;
    if (configured == null) {
      throw StateError('BackgroundTaskService has not been configured.');
    }
    return configured;
  }

  static void configure(Serverpod pod) {
    _instance ??= BackgroundTaskService._(pod);
  }

  BackgroundTaskService._(this._pod);

  final Serverpod _pod;
  final RealtimeService _realtime = RealtimeService();
  final FirebaseNotificationService _notifications =
      FirebaseNotificationService();
  final NotificationOutboxService _campaignNotifications =
      NotificationOutboxService.instance;
  bool _running = false;

  Future<void> run() async {
    if (_running) return;
    _running = true;
    try {
      await _runLocked((session) async {
        await _drain(session);
      });
    } finally {
      _running = false;
    }
  }

  Future<void> sendRealtimeUpdatesAsync(
    Session session,
    OrderNotificationOutboxRow row,
  ) async {
    final event = _decodeEvent(row);
    await _realtime.broadcastOrderEvent(
      session,
      event,
      includeAdminOrders: true,
      includeDashboardUpdates: true,
      includeUserOrders: true,
    );
  }

  Future<void> sendNotificationsAsync(
    Session session,
    OrderNotificationOutboxRow row,
  ) async {
    final event = _decodeEvent(row);
    final payload = _payload(row);
    final amount = (payload['amount'] as num?)?.toDouble() ?? 0.0;
    final itemCount = payload['itemCount'] is int
        ? payload['itemCount'] as int
        : payload['itemCount'] is num
        ? (payload['itemCount'] as num).toInt()
        : null;
    final isDeliveryStarted =
        event.eventType == 'order_status_changed' &&
        (event.status?.trim() == 'out_for_delivery');
    final isRefundProcessed = event.eventType == 'refund_processed';

    await _notifications.sendForEvent(
      session,
      event,
      amount: amount,
      itemCount: itemCount,
      isDeliveryStarted: isDeliveryStarted,
      isRefundProcessed: isRefundProcessed,
    );
  }

  Future<void> _drain(Session session) async {
    await _drainOrderNotifications(session);
    await _drainCampaignNotifications(session);
  }

  Future<void> _drainOrderNotifications(Session session) async {
    while (true) {
      final rows = await OrderNotificationOutboxRow.db.find(
        session,
        where: (t) => t.processedAt.equals(null),
        orderBy: (t) => t.createdAt,
        limit: 50,
      );

      if (rows.isEmpty) break;

      for (final row in rows) {
        try {
          await sendRealtimeUpdatesAsync(session, row);
          await sendNotificationsAsync(session, row);
          await OrderNotificationOutboxRow.db.updateById(
            session,
            row.id!,
            columnValues: (t) => [
              t.processedAt(DateTime.now().toUtc()),
              t.lastError(null),
              t.updatedAt(DateTime.now().toUtc()),
            ],
          );
        } catch (error, stackTrace) {
          await OrderNotificationOutboxRow.db.updateById(
            session,
            row.id!,
            columnValues: (t) => [
              t.attemptCount(row.attemptCount + 1),
              t.lastError(error.toString()),
              t.updatedAt(DateTime.now().toUtc()),
            ],
          );
          session.log(
            'Background task failed for order ${row.orderId}: $error',
            level: LogLevel.warning,
            exception: error,
            stackTrace: stackTrace,
          );
        }
      }
    }
  }

  Future<void> _drainCampaignNotifications(Session session) async {
    while (true) {
      final now = DateTime.now().toUtc();
      final rows = await NotificationOutboxRow.db.find(
        session,
        where: (t) =>
            t.processedAt.equals(null) &
            (t.nextAttemptAt.equals(null) | (t.nextAttemptAt <= now)),
        orderBy: (t) => t.createdAt,
        limit: 50,
      );

      if (rows.isEmpty) break;

      for (final row in rows) {
        try {
          await _campaignNotifications.sendOutboxRow(session, row);
          await NotificationOutboxRow.db.updateById(
            session,
            row.id!,
            columnValues: (t) => [
              t.status('processed'),
              t.processedAt(DateTime.now().toUtc()),
              t.lastError(null),
              t.updatedAt(DateTime.now().toUtc()),
            ],
          );
        } catch (error, stackTrace) {
          final attempts = row.attemptCount + 1;
          final failed = attempts >= row.maxAttempts;
          final retryAt = failed
              ? null
              : DateTime.now().toUtc().add(
                  Duration(minutes: 1 << attempts.clamp(0, 6)),
                );
          await NotificationOutboxRow.db.updateById(
            session,
            row.id!,
            columnValues: (t) => [
              t.status(failed ? 'failed' : 'retrying'),
              t.attemptCount(attempts),
              t.lastError(error.toString()),
              t.nextAttemptAt(retryAt),
              t.updatedAt(DateTime.now().toUtc()),
            ],
          );
          await NotificationCampaignRow.db.updateById(
            session,
            row.campaignId,
            columnValues: (t) => [
              t.status(failed ? 'failed' : 'retrying'),
              t.lastError(error.toString()),
            ],
          );
          session.log(
            'Background task failed for notification campaign ${row.campaignId}: $error',
            level: LogLevel.warning,
            exception: error,
            stackTrace: stackTrace,
          );
        }
      }
    }
  }

  Future<void> _runLocked(
    Future<void> Function(Session session) task,
  ) async {
    final session = await _pod.createSession(enableLogging: true);
    var lockAcquired = false;
    try {
      lockAcquired = await _tryAdvisoryLock(session, _drainLock);
      if (!lockAcquired) return;
      await task(session);
    } catch (error, stackTrace) {
      session.log(
        'Background task service failed: $error',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    } finally {
      if (lockAcquired) {
        await _releaseAdvisoryLock(session, _drainLock);
      }
      await session.close();
    }
  }

  Future<bool> _tryAdvisoryLock(Session session, int lockKey) async {
    final result = await session.db.unsafeQuery(
      'SELECT pg_try_advisory_lock(@lockKey::bigint) AS locked',
      parameters: QueryParameters.named({'lockKey': lockKey}),
    );
    if (result.isEmpty) return false;
    return result.first.toColumnMap()['locked'] == true;
  }

  Future<void> _releaseAdvisoryLock(Session session, int lockKey) async {
    await session.db.unsafeQuery(
      'SELECT pg_advisory_unlock(@lockKey::bigint)',
      parameters: QueryParameters.named({'lockKey': lockKey}),
    );
  }

  OrderRealtimeEvent _decodeEvent(OrderNotificationOutboxRow row) {
    final payload = _payload(row);
    return OrderRealtimeEvent.fromJson(payload);
  }

  Map<String, dynamic> _payload(OrderNotificationOutboxRow row) {
    try {
      final decoded = jsonDecode(row.payloadJson);
      if (decoded is Map<String, dynamic>) return decoded;
      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{
        'eventType': row.eventType,
        'orderId': row.orderId,
        'status': row.status,
        'userId': row.userId,
        'createdAt': row.createdAt.toIso8601String(),
      };
    }
  }
}
