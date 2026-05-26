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
    // Android notification tag: same tag → replaces existing notification
    // instead of stacking. Use for deduplication (e.g. same order).
    String? tag,
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
    if (tag != null && tag.isNotEmpty) {
      message['android'] = {
        'notification': {'tag': tag},
      };
    }
    await _sendMessage({'message': message});
  }

  Future<void> sendAdminNewOrder({
    Session? session,
    required String orderId,
    required double amount,
    int? itemCount,
  }) async {
    final title = 'New Order';
    final body = itemCount == null
        ? 'Order $orderId is ready for review. INR ${amount.toStringAsFixed(0)}.'
        : 'Order $orderId ($itemCount items) is ready for review. INR ${amount.toStringAsFixed(0)}.';

    // tag = 'new_order:$orderId' ensures Android collapses duplicates:
    // if the server accidentally sends the same notification twice, the
    // device replaces the existing one instead of showing a duplicate.
    final data = {'orderId': orderId, 'type': 'admin_new_order'};
    if (session != null) {
      await sendAdminDevices(
        session: session,
        title: title,
        body: body,
        data: data,
      );
      return;
    }

    await sendToTopic(
      topic: 'admin',
      title: title,
      body: body,
      data: data,
      tag: 'new_order:$orderId',
    );
  }

  Future<int> sendAdminDevices({
    required Session session,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final tokens = await _getAdminFcmTokens(session);
    var sent = 0;
    for (final token in tokens) {
      await sendToToken(token: token, title: title, body: body, data: data);
      sent++;
    }
    return sent;
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
        try {
          await sendAdminNewOrder(
            session: session,
            orderId: orderId,
            amount: amount,
            itemCount: itemCount,
          );
        } catch (e, st) {
          session.log(
            'Failed to send admin new order notification: $e',
            level: LogLevel.warning,
            exception: e,
            stackTrace: st,
          );
        }
        if (userId != null && userId.isNotEmpty) {
          try {
            await sendUserPaymentSuccess(
              session: session,
              userId: userId,
              orderId: orderId,
              amount: amount,
              itemCount: itemCount,
            );
          } catch (e, st) {
            session.log(
              'Failed to send user payment success notification: $e',
              level: LogLevel.warning,
              exception: e,
              stackTrace: st,
            );
          }
          if (status.isNotEmpty) {
            try {
              await sendUserStatusUpdate(
                session: session,
                userId: userId,
                orderId: orderId,
                status: status,
              );
            } catch (e, st) {
              session.log(
                'Failed to send user status update notification: $e',
                level: LogLevel.warning,
                exception: e,
                stackTrace: st,
              );
            }
          }
        }
        return;
      case 'order_status_changed':
        if (userId == null || userId.isEmpty) return;
        if (isDeliveryStarted || status == 'out_for_delivery') {
          try {
            await sendDeliveryStarted(
              session: session,
              userId: userId,
              orderId: orderId,
            );
          } catch (e, st) {
            session.log(
              'Failed to send delivery started notification: $e',
              level: LogLevel.warning,
              exception: e,
              stackTrace: st,
            );
          }
        } else {
          try {
            await sendUserStatusUpdate(
              session: session,
              userId: userId,
              orderId: orderId,
              status: status.isEmpty ? 'updated' : status,
            );
          } catch (e, st) {
            session.log(
              'Failed to send user status update notification: $e',
              level: LogLevel.warning,
              exception: e,
              stackTrace: st,
            );
          }
        }
        return;
      case 'order_address_updated':
        if (userId == null || userId.isEmpty) return;
        try {
          await _sendToTokens(
            tokens: await _getUserFcmTokens(userId, session: session),
            title: 'Address updated',
            body: 'Your delivery address for order $orderId has been updated.',
            data: {
              'orderId': orderId,
              'type': 'order_address_updated',
              if (status.isNotEmpty) 'status': status,
            },
          );
        } catch (e, st) {
          session.log(
            'Failed to send order address updated notification: $e',
            level: LogLevel.warning,
            exception: e,
            stackTrace: st,
          );
        }
        return;
      case 'refund_processed':
        if (isRefundProcessed && userId != null && userId.isNotEmpty) {
          try {
            await sendUserStatusUpdate(
              session: session,
              userId: userId,
              orderId: orderId,
              status: 'cancelled',
            );
          } catch (e, st) {
            session.log(
              'Failed to send refund processed notification: $e',
              level: LogLevel.warning,
              exception: e,
              stackTrace: st,
            );
          }
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

  Future<List<String>> _getAdminFcmTokens(Session session) async {
    final admins = await AppUserRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      limit: 100,
    );
    final adminIds = admins
        .where((user) => _isAdminSellerRole(user.role))
        .map((user) => user.id)
        .whereType<UuidValue>()
        .toSet();
    if (adminIds.isEmpty) return const [];

    final rows = await UserFcmTokenRow.db.find(
      session,
      where: (t) => t.userId.inSet(adminIds) & t.isActive.equals(true),
      orderBy: (t) => t.updatedAt,
      orderDescending: true,
      limit: 100,
    );
    return {
      for (final row in rows)
        if (row.fcmToken.trim().isNotEmpty) row.fcmToken.trim(),
    }.toList(growable: false);
  }

  bool _isAdminSellerRole(String? role) {
    final normalized = role?.trim();
    if (normalized == null || normalized.isEmpty) return false;

    final lowered = normalized.toLowerCase();
    return lowered == 'admin' ||
        lowered == 'seller' ||
        lowered == 'admin_seller' ||
        lowered == 'admin-seller' ||
        lowered == 'admin seller' ||
        normalized.toUpperCase() == 'ADMIN_SELLER';
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
