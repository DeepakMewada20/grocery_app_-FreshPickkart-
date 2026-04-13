import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/tracking/screens/order_tracking_map_screen.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppNotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final Product? product;

  const AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.product,
  });
}

class NotificationController extends GetxController {
  static NotificationController get instance =>
      Get.find<NotificationController>();

  static const String _savedFcmTokenKey = 'saved_fcm_token';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GetStorage _storage = GetStorage();
  final RxList<AppNotificationItem> notifications = <AppNotificationItem>[].obs;
  final RxnString pendingTrackingOrderId = RxnString();
  String? _currentToken;
  bool _initialized = false;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await _messaging.requestPermission();

    _currentToken = await _messaging.getToken();

    _messaging.onTokenRefresh.listen(_onTokenRefresh);
    _openedAppSubscription ??= FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _handleOpenedMessage(message),
    );

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      await _handleOpenedMessage(initialMessage, queueOnly: true);
    }
  }

  Future<void> _onTokenRefresh(String token) async {
    _currentToken = token;

    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) return;

    final savedToken = _storage.read<String>(_savedFcmTokenKey);
    if (savedToken == token) return;

    try {
      await ServerpodClient().client.user.updateFcmToken(user.uid, token);
      await _storage.write(_savedFcmTokenKey, token);
    } catch (_) {
      // Ignore token sync errors
    }
  }

  Future<void> syncTokenWithServer() async {
    final token = _currentToken;
    if (token == null || token.isEmpty) return;

    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) return;

    final savedToken = _storage.read<String>(_savedFcmTokenKey);
    if (savedToken == token) return;

    try {
      await ServerpodClient().client.user.updateFcmToken(user.uid, token);
      await _storage.write(_savedFcmTokenKey, token);
    } catch (_) {
      // Ignore token sync errors
    }
  }

  void saveNotification(AppNotificationItem notification) {
    notifications.removeWhere((item) => item.id == notification.id);
    notifications.insert(0, notification);
  }

  Future<void> _handleOpenedMessage(
    RemoteMessage message, {
    bool queueOnly = false,
  }) async {
    final data = message.data;
    final type = data['type']?.toString();
    final orderId = data['orderId']?.toString();

    if (type != 'delivery_started' || orderId == null || orderId.isEmpty) {
      return;
    }

    final title =
        message.notification?.title ??
        'Track your order | Apna order track karein';
    final body =
        message.notification?.body ??
        'Your order is on the way. Track your order in the app.';

    saveNotification(
      AppNotificationItem(
        id: 'delivery_started:$orderId',
        title: title,
        message: body,
        createdAt: DateTime.now(),
      ),
    );

    pendingTrackingOrderId.value = orderId;

    if (!queueOnly) {
      await openTrackingOrder(orderId);
    }
  }

  Future<void> openTrackingOrder(String orderId) async {
    if (orderId.isEmpty) return;
    if (pendingTrackingOrderId.value == orderId) {
      pendingTrackingOrderId.value = null;
    }
    await Get.to(() => OrderTrackingMapScreen(orderId: orderId));
  }

  Future<void> openPendingTrackingLaunchIfAny() async {
    final orderId = pendingTrackingOrderId.value;
    if (orderId == null || orderId.isEmpty) return;
    pendingTrackingOrderId.value = null;
    await openTrackingOrder(orderId);
  }

  String? consumePendingTrackingOrderId() {
    final orderId = pendingTrackingOrderId.value;
    pendingTrackingOrderId.value = null;
    return orderId;
  }

  @override
  void onClose() {
    _openedAppSubscription?.cancel();
    _openedAppSubscription = null;
    super.onClose();
  }
}
