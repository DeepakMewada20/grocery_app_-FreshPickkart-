import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'firebase_service.dart';

class NotificationService {
  static const String _fcmScope =
      'https://www.googleapis.com/auth/firebase.messaging';

  static Future<void> sendToToken({
    required String token,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    await _sendMessage({
      'message': {
        'token': token,
        'notification': {'title': title, 'body': body},
        'data': ?data,
      },
    });
  }

  static Future<void> sendToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    await _sendMessage({
      'message': {
        'topic': topic,
        'notification': {'title': title, 'body': body},
        'data': ?data,
      },
    });
  }

  static Future<void> notifyUserPaymentSuccess({
    required String userId,
    required String orderId,
    required double amount,
    int? itemCount,
  }) async {
    final token = await _getUserFcmToken(userId);
    if (token == null || token.isEmpty) return;

    final title = 'Payment successful';
    final body = itemCount == null
        ? 'Order $orderId confirmed. Amount paid INR ${amount.toStringAsFixed(0)}.'
        : 'Order $orderId confirmed ($itemCount items). Paid INR ${amount.toStringAsFixed(0)}.';

    await sendToToken(
      token: token,
      title: title,
      body: body,
      data: {'orderId': orderId, 'type': 'order_paid'},
    );
  }

  static Future<void> notifyUserStatusUpdate({
    required String userId,
    required String orderId,
    required String status,
  }) async {
    final token = await _getUserFcmToken(userId);
    if (token == null || token.isEmpty) return;

    final title = 'Order update';
    final body = 'Order $orderId status updated to $status.';

    await sendToToken(
      token: token,
      title: title,
      body: body,
      data: {'orderId': orderId, 'type': 'order_status'},
    );
  }

  static Future<void> notifyAdminNewOrder({
    required String orderId,
    required double amount,
    int? itemCount,
  }) async {
    final title = 'New paid order';
    final body = itemCount == null
        ? 'Order $orderId paid. Amount INR ${amount.toStringAsFixed(0)}.'
        : 'Order $orderId paid ($itemCount items). INR ${amount.toStringAsFixed(0)}.';

    await sendToTopic(
      topic: 'admin',
      title: title,
      body: body,
      data: {'orderId': orderId, 'type': 'admin_new_order'},
    );
  }

  static Future<String?> _getUserFcmToken(String userId) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final docPath =
        'projects/${FirebaseService.projectId}/databases/(default)/documents/users/$userId';
    try {
      final doc = await firestore.projects.databases.documents.get(docPath);
      return doc.fields?['fcmToken']?.stringValue;
    } catch (_) {
      return null;
    }
  }

  static Future<void> _sendMessage(Map<String, dynamic> payload) async {
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
        // Swallow errors for now; can be logged if needed.
      }
    } finally {
      client.close();
    }
  }
}
