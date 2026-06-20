import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'background_task_service.dart';
import '../postgres/postgres_support.dart';

class OrderOutboxService {
  static final OrderOutboxService instance = OrderOutboxService._();

  OrderOutboxService._();

  Future<OrderNotificationOutboxRow> enqueueOrderPaid({
    required Session session,
    required String orderId,
    required String? userId,
    required String status,
    required double amount,
    int? itemCount,
  }) {
    final event = OrderRealtimeEvent(
      eventType: 'order_paid',
      orderId: orderId,
      status: status,
      userId: userId,
    );
    return _enqueue(
      session: session,
      dedupeKey: 'order_paid:$orderId',
      event: event,
      amount: amount,
      itemCount: itemCount,
    );
  }

  Future<OrderNotificationOutboxRow> enqueueOrderStatusChanged({
    required Session session,
    required String orderId,
    required String? userId,
    required String status,
  }) {
    final event = OrderRealtimeEvent(
      eventType: 'order_status_changed',
      orderId: orderId,
      status: status,
      userId: userId,
    );
    return _enqueue(
      session: session,
      dedupeKey: 'order_status_changed:$orderId:$status',
      event: event,
    );
  }

  Future<OrderNotificationOutboxRow> enqueueOrderAddressUpdated({
    required Session session,
    required String orderId,
    required String? userId,
    required String status,
  }) {
    final event = OrderRealtimeEvent(
      eventType: 'order_address_updated',
      orderId: orderId,
      status: status,
      userId: userId,
    );
    return _enqueue(
      session: session,
      dedupeKey: 'order_address_updated:$orderId:$status',
      event: event,
    );
  }

  Future<OrderNotificationOutboxRow> enqueueRefundProcessed({
    required Session session,
    required String orderId,
    required String? userId,
    required double amount,
  }) {
    final event = OrderRealtimeEvent(
      eventType: 'refund_processed',
      orderId: orderId,
      status: 'refunded',
      userId: userId,
    );
    return _enqueue(
      session: session,
      dedupeKey: 'refund_processed:$orderId',
      event: event,
      amount: amount,
    );
  }

  Future<OrderNotificationOutboxRow> _enqueue({
    required Session session,
    required String dedupeKey,
    required OrderRealtimeEvent event,
    double? amount,
    int? itemCount,
  }) async {
    final existing = await OrderNotificationOutboxRow.db.findFirstRow(
      session,
      where: (t) => t.dedupeKey.equals(dedupeKey),
    );
    if (existing != null) {
      _kickBackgroundProcessing();
      return existing;
    }

    final now = DateTime.now().toUtc();
    final rowData = OrderNotificationOutboxRow(
      dedupeKey: dedupeKey,
      eventType: event.eventType,
      orderId: event.orderId,
      userId: cleanNullableString(event.userId),
      status: cleanNullableString(event.status),
      payloadJson: jsonEncode(() {
        final payload = <String, dynamic>{...event.toJson()};
        if (amount != null) payload['amount'] = amount;
        if (itemCount != null) payload['itemCount'] = itemCount;
        return payload;
      }()),
      createdAt: now,
      updatedAt: now,
    );

    OrderNotificationOutboxRow row;
    try {
      row = await OrderNotificationOutboxRow.db.insertRow(session, rowData);
    } catch (_) {
      final retryExisting = await OrderNotificationOutboxRow.db.findFirstRow(
        session,
        where: (t) => t.dedupeKey.equals(dedupeKey),
      );
      if (retryExisting != null) {
        _kickBackgroundProcessing();
        return retryExisting;
      }
      rethrow;
    }
    _kickBackgroundProcessing();
    return row;
  }

  void _kickBackgroundProcessing() {
    if (!BackgroundTaskService.isConfigured) return;
    unawaited(BackgroundTaskService.instance.run());
  }
}
