import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart' show OrderRealtimeEvent;
import '../firebase/firebase_notification_service.dart';

class NotificationService {
  static final FirebaseNotificationService _service =
      FirebaseNotificationService();

  static Future<void> sendToToken({
    required String token,
    required String title,
    required String body,
    Map<String, String>? data,
  }) =>
      _service.sendToToken(token: token, title: title, body: body, data: data);

  static Future<void> sendToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
    String? imageUrl,
  }) => _service.sendToTopic(
    topic: topic,
    title: title,
    body: body,
    data: data,
    imageUrl: imageUrl,
  );

  static Future<void> notifyUserPaymentSuccess({
    Session? session,
    required String userId,
    required String orderId,
    required double amount,
    int? itemCount,
  }) => _service.sendUserPaymentSuccess(
    session: session,
    userId: userId,
    orderId: orderId,
    amount: amount,
    itemCount: itemCount,
  );

  static Future<void> notifyUserStatusUpdate({
    Session? session,
    required String userId,
    required String orderId,
    required String status,
  }) => _service.sendUserStatusUpdate(
    session: session,
    userId: userId,
    orderId: orderId,
    status: status,
  );

  static Future<void> notifyDeliveryStarted({
    Session? session,
    required String userId,
    required String orderId,
  }) => _service.sendDeliveryStarted(
    session: session,
    userId: userId,
    orderId: orderId,
  );

  static Future<void> notifyAdminNewOrder({
    Session? session,
    required String orderId,
    required double amount,
    int? itemCount,
  }) => _service.sendAdminNewOrder(
    session: session,
    orderId: orderId,
    amount: amount,
    itemCount: itemCount,
  );

  static Future<int> notifyAdminDevices({
    required Session session,
    required String title,
    required String body,
    Map<String, String>? data,
  }) => _service.sendAdminDevices(
    session: session,
    title: title,
    body: body,
    data: data,
  );

  static Future<void> notifyPaymentLinkPaid({
    required Session session,
    required String userId,
    required String orderId,
    required double amount,
    required int? itemCount,
    required String userName,
    required String orderStatus,
    required String paymentStatus,
  }) => _service.sendPaymentLinkPaidNotification(
    session: session,
    userId: userId,
    orderId: orderId,
    amount: amount,
    itemCount: itemCount,
    userName: userName,
    orderStatus: orderStatus,
    paymentStatus: paymentStatus,
  );

  static Future<void> notifyForEvent(
    Session session,
    OrderRealtimeEvent event, {
    required double amount,
    int? itemCount,
    bool isDeliveryStarted = false,
    bool isRefundProcessed = false,
  }) => _service.sendForEvent(
    session,
    event,
    amount: amount,
    itemCount: itemCount,
    isDeliveryStarted: isDeliveryStarted,
    isRefundProcessed: isRefundProcessed,
  );
}
