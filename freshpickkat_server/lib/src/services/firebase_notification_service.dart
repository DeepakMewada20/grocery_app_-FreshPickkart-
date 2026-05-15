import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'firebase_service.dart';
import 'postgres/postgres_support.dart';

class FirebaseNotificationService {
  static const String _fcmScope =
      'https://www.googleapis.com/auth/firebase.messaging';

  Future<void> sendToToken({
    required String token,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final message = <String, dynamic>{
      'token': token,
      'notification': {'title': title, 'body': body},
    };
    if (data != null) {
      message['data'] = data;
    }
    await _sendMessage({'message': message});
  }

  Future<void> sendToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
    String? imageUrl,
  }) async {
    final notification = <String, dynamic>{'title': title, 'body': body};
    if (imageUrl != null && imageUrl.trim().isNotEmpty) {
      notification['image'] = imageUrl.trim();
    }
    final message = <String, dynamic>{
      'topic': topic,
      'notification': notification,
    };
    if (data != null) {
      message['data'] = data;
    }
    await _sendMessage({'message': message});
  }

  Future<void> sendAdminNewOrder({
    required String orderId,
    required double amount,
    int? itemCount,
  }) async {
    final title = 'New Order';
    final body = itemCount == null
        ? 'Order $orderId is ready for review. INR ${amount.toStringAsFixed(0)}.'
        : 'Order $orderId ($itemCount items) is ready for review. INR ${amount.toStringAsFixed(0)}.';

    await sendToTopic(
      topic: 'admin',
      title: title,
      body: body,
      data: {'orderId': orderId, 'type': 'admin_new_order'},
    );
  }

  Future<void> sendUserPaymentSuccess({
    Session? session,
    required String userId,
    required String orderId,
    required double amount,
    int? itemCount,
  }) async {
    if (!await _allowsOrderTracking(userId, session: session)) return;
    final tokens = await _getUserFcmTokens(userId, session: session);
    if (tokens.isEmpty) return;

    final title = 'Payment successful';
    final body = itemCount == null
        ? 'Order $orderId confirmed. Amount paid INR ${amount.toStringAsFixed(0)}.'
        : 'Order $orderId confirmed ($itemCount items). Paid INR ${amount.toStringAsFixed(0)}.';

    await _sendToTokens(
      tokens: tokens,
      title: title,
      body: body,
      data: {'orderId': orderId, 'type': 'order_paid'},
    );
  }

  Future<void> sendUserStatusUpdate({
    Session? session,
    required String userId,
    required String orderId,
    required String status,
  }) async {
    if (!await _allowsOrderTracking(userId, session: session)) return;
    final tokens = await _getUserFcmTokens(userId, session: session);
    if (tokens.isEmpty) return;

    final title = 'Order update';
    final body = 'Order $orderId status updated to $status.';

    await _sendToTokens(
      tokens: tokens,
      title: title,
      body: body,
      data: {'orderId': orderId, 'type': 'order_status', 'status': status},
    );
  }

  Future<void> sendDeliveryStarted({
    Session? session,
    required String userId,
    required String orderId,
  }) async {
    if (!await _allowsOrderTracking(userId, session: session)) return;
    final tokens = await _getUserFcmTokens(userId, session: session);
    if (tokens.isEmpty) return;

    await _sendToTokens(
      tokens: tokens,
      title: 'Track your order | Apna order track karein',
      body:
          'Your order is on the way. Track your order in the app.\n'
          'Aapka order raste me hai. App me live location dekhein.',
      data: {
        'orderId': orderId,
        'type': 'delivery_started',
        'screen': 'track_order',
      },
    );
  }

  Future<void> sendForEvent(
    Session session,
    OrderRealtimeEvent event, {
    required double amount,
    int? itemCount,
    bool isDeliveryStarted = false,
    bool isRefundProcessed = false,
  }) async {
    final orderId = event.orderId;
    final userId = event.userId?.trim();
    final status = event.status?.trim() ?? '';

    switch (event.eventType) {
      case 'order_paid':
        await sendAdminNewOrder(
          orderId: orderId,
          amount: amount,
          itemCount: itemCount,
        );
        if (userId != null && userId.isNotEmpty) {
          await sendUserPaymentSuccess(
            session: session,
            userId: userId,
            orderId: orderId,
            amount: amount,
            itemCount: itemCount,
          );
          if (status.isNotEmpty) {
            await sendUserStatusUpdate(
              session: session,
              userId: userId,
              orderId: orderId,
              status: status,
            );
          }
        }
        return;
      case 'order_status_changed':
        if (userId == null || userId.isEmpty) return;
        if (isDeliveryStarted || status == 'out_for_delivery') {
          await sendDeliveryStarted(
            session: session,
            userId: userId,
            orderId: orderId,
          );
        } else {
          await sendUserStatusUpdate(
            session: session,
            userId: userId,
            orderId: orderId,
            status: status.isEmpty ? 'updated' : status,
          );
        }
        return;
      case 'refund_processed':
        if (isRefundProcessed && userId != null && userId.isNotEmpty) {
          await sendUserStatusUpdate(
            session: session,
            userId: userId,
            orderId: orderId,
            status: 'cancelled',
          );
        }
        return;
    }
  }

  Future<void> _sendToTokens({
    required List<String> tokens,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    for (final token in tokens.toSet()) {
      await sendToToken(token: token, title: title, body: body, data: data);
    }
  }

  Future<List<String>> _getUserFcmTokens(
    String userId, {
    Session? session,
  }) async {
    final activeSession = session;
    if (activeSession == null) return const [];

    final normalized = userId.trim();
    if (normalized.isEmpty) return const [];

    final parsedId = tryParseUuid(normalized);
    final user = await AppUserRow.db.findFirstRow(
      activeSession,
      where: (t) => parsedId == null
          ? t.firebaseUid.equals(normalized) & t.status.equals('active')
          : (t.firebaseUid.equals(normalized) & t.status.equals('active')) |
                (t.id.equals(parsedId) & t.status.equals('active')),
    );
    if (user == null) return const [];

    final rows = await UserFcmTokenRow.db.find(
      activeSession,
      where: (t) => t.userId.equals(user.id!) & t.isActive.equals(true),
      orderBy: (t) => t.updatedAt,
      orderDescending: true,
      limit: 20,
    );
    final tokens = [
      for (final row in rows)
        if (row.fcmToken.trim().isNotEmpty) row.fcmToken.trim(),
    ];
    final legacy = user.fcmToken?.trim();
    if (tokens.isEmpty && legacy != null && legacy.isNotEmpty) {
      tokens.add(legacy);
    }
    return tokens;
  }

  Future<bool> _allowsOrderTracking(
    String userId, {
    Session? session,
  }) async {
    final activeSession = session;
    if (activeSession == null) return true;
    final normalized = userId.trim();
    if (normalized.isEmpty) return true;
    final parsedId = tryParseUuid(normalized);
    final user = await AppUserRow.db.findFirstRow(
      activeSession,
      where: (t) => parsedId == null
          ? t.firebaseUid.equals(normalized) & t.status.equals('active')
          : (t.firebaseUid.equals(normalized) & t.status.equals('active')) |
                (t.id.equals(parsedId) & t.status.equals('active')),
    );
    if (user == null) return true;
    final prefs = await NotificationPreferenceRow.db.findFirstRow(
      activeSession,
      where: (t) => t.userId.equals(user.id!),
    );
    return prefs?.trackOrderNotifications ?? true;
  }

  Future<void> _sendMessage(Map<String, dynamic> payload) async {
    final credentials = await FirebaseService.getServiceAccountCredentials();
    final client = await clientViaServiceAccount(credentials, [_fcmScope]);
    try {
      final uri = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/${FirebaseService.projectId}/messages:send',
      );
      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw StateError(
          'FCM request failed with status ${response.statusCode}: ${response.body}',
        );
      }
    } finally {
      client.close();
    }
  }
}
