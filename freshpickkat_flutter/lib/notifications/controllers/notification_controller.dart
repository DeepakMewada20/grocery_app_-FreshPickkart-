import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/notifications/models/app_notification_item.dart';
import 'package:freshpickkat_flutter/notifications/services/fcm_token_service.dart';
import 'package:freshpickkat_flutter/notifications/services/notification_history_service.dart';
import 'package:freshpickkat_flutter/notifications/services/notification_preference_service.dart';
import 'package:freshpickkat_flutter/notifications/services/notification_topic_service.dart';
import 'package:freshpickkat_flutter/screens/complaint_detail_screen.dart';
import 'package:freshpickkat_flutter/screens/coupons_screen.dart';
import 'package:freshpickkat_flutter/screens/offers_screen/combo_offers_screen.dart';
import 'package:freshpickkat_flutter/screens/order_detail_screen.dart';
import 'package:freshpickkat_flutter/screens/offers_screen/offers_screen.dart';
import 'package:freshpickkat_flutter/tracking/screens/order_tracking_map_screen.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> freshpickkatFirebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {}

@pragma('vm:entry-point')
void freshpickkatNotificationTapBackground(NotificationResponse response) {}

class NotificationController extends GetxController {
  static NotificationController get instance =>
      Get.find<NotificationController>();

  final FcmTokenService _tokenService = FcmTokenService();
  final NotificationPreferenceService _preferenceService =
      NotificationPreferenceService();
  final NotificationTopicService _topicService = NotificationTopicService();
  final NotificationHistoryService _historyService =
      NotificationHistoryService();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final Rx<NotificationPreference> preferences =
      NotificationPreferenceService.defaultPreference().obs;
  final RxList<NotificationHistoryItem> history =
      <NotificationHistoryItem>[].obs;
  final RxList<AppNotificationItem> notifications = <AppNotificationItem>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoadingHistory = false.obs;
  final RxnString pendingTrackingOrderId = RxnString();

  String? _nextPageToken;
  bool _initialized = false;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await _initLocalNotifications();
    preferences.value = _preferenceService.cachedOrDefault;
    await _topicService.syncTopics(preferences.value);

    try {
      await _tokenService.requestAndGetToken();
      await syncTokenWithServer();
    } catch (_) {}

    _tokenRefreshSubscription ??= _tokenService.onTokenRefresh.listen(
      (token) => syncTokenWithServer(token: token),
    );
    _messageSubscription ??= FirebaseMessaging.onMessage.listen(_handleMessage);
    _openedAppSubscription ??= FirebaseMessaging.onMessageOpenedApp.listen(
      _handleOpenedMessage,
    );

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await _handleOpenedMessage(initialMessage, queueOnly: true);
    }

    await refreshPreferences();
    await refreshHistory();
  }

  Future<void> syncTokenWithServer({String? token}) async {
    try {
      await _tokenService.syncCurrentToken(token: token);
    } catch (_) {}
  }

  Future<void> refreshPreferences() async {
    try {
      final fetched = await _preferenceService.fetch();
      preferences.value = fetched;
      await _topicService.syncTopics(fetched);
    } catch (_) {}
  }

  Future<void> updatePreferences(NotificationPreference next) async {
    preferences.value = next;
    await _topicService.syncTopics(next);
    try {
      final saved = await _preferenceService.update(next);
      preferences.value = saved;
      await _topicService.syncTopics(saved);
      await refreshHistory();
    } catch (_) {}
  }

  Future<void> updatePreference({
    bool? trackOrderNotifications,
    bool? couponNotifications,
    bool? offerNotifications,
    bool? announcementNotifications,
    bool? importantAlerts,
  }) {
    final current = preferences.value;
    return updatePreferences(
      current.copyWith(
        trackOrderNotifications:
            trackOrderNotifications ?? current.trackOrderNotifications,
        couponNotifications: couponNotifications ?? current.couponNotifications,
        offerNotifications: offerNotifications ?? current.offerNotifications,
        announcementNotifications:
            announcementNotifications ?? current.announcementNotifications,
        importantAlerts: importantAlerts ?? current.importantAlerts,
      ),
    );
  }

  Future<void> refreshHistory() async {
    if (AuthController.instance.currentUser == null) return;
    isLoadingHistory.value = true;
    try {
      final page = await _historyService.fetch(limit: 40);
      if (page == null) return;
      history.assignAll(page.items);
      unreadCount.value = page.unreadCount;
      _nextPageToken = page.nextPageToken;
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> loadMoreHistory() async {
    final token = _nextPageToken;
    if (token == null || isLoadingHistory.value) return;
    isLoadingHistory.value = true;
    try {
      final page = await _historyService.fetch(limit: 40, pageToken: token);
      if (page == null) return;
      history.addAll(page.items);
      unreadCount.value = page.unreadCount;
      _nextPageToken = page.nextPageToken;
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> markRead(NotificationHistoryItem item) async {
    await _historyService.markRead(item.campaignId);
    final index = history.indexWhere(
      (entry) => entry.campaignId == item.campaignId,
    );
    if (index != -1) {
      history[index] = item.copyWith(isRead: true);
    }
    if (unreadCount.value > 0) unreadCount.value--;
  }

  Future<void> delete(NotificationHistoryItem item) async {
    await _historyService.delete(item.campaignId);
    history.removeWhere((entry) => entry.campaignId == item.campaignId);
    if (!item.isRead && unreadCount.value > 0) unreadCount.value--;
  }

  Future<void> openNotification(NotificationHistoryItem item) async {
    if (!item.isRead) await markRead(item);
    await _routeData({
      ...?item.data,
      'type': item.type,
      if (item.entityType != null) 'entityType': item.entityType!,
      if (item.entityId != null) 'entityId': item.entityId!,
      'campaignId': item.campaignId,
    });
  }

  void saveNotification(AppNotificationItem notification) {
    notifications.removeWhere((item) => item.id == notification.id);
    notifications.insert(0, notification);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    _saveRemoteMessage(message);
    await _showForegroundNotification(message);
    await refreshHistory();
  }

  Future<void> _handleOpenedMessage(
    RemoteMessage message, {
    bool queueOnly = false,
  }) async {
    _saveRemoteMessage(message);
    final type = message.data['type']?.toString();
    final orderId = message.data['orderId']?.toString();
    if (type == 'delivery_started' && orderId != null && orderId.isNotEmpty) {
      pendingTrackingOrderId.value = orderId;
      if (queueOnly) return;
    }
    await _routeData(message.data.map((key, value) => MapEntry(key, '$value')));
  }

  void _saveRemoteMessage(RemoteMessage message) {
    final title =
        message.notification?.title ?? message.data['title'] ?? 'Notification';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    final id =
        message.data['campaignId'] ??
        message.data['orderId'] ??
        DateTime.now().microsecondsSinceEpoch.toString();
    saveNotification(
      AppNotificationItem(
        id: id.toString(),
        title: title.toString(),
        message: body.toString(),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _routeData(Map<String, String> data) async {
    final type = data['type'] ?? data['entityType'] ?? '';
    final entityId = data['entityId'];
    switch (type) {
      case 'coupon':
        await Get.to(
          () => CouponsScreen(
            autoApplyCouponCode: data['couponCode'] ?? entityId,
          ),
        );
        return;
      case 'combo':
        await Get.to(() => ComboOffersScreen(highlightComboId: entityId));
        return;
      case 'offer':
      case 'bogo':
        await Get.to(() => OffersScreen(highlightOfferId: entityId));
        return;
      case 'order_paid':
      case 'order_status':
        final orderId = data['orderId'];
        if (orderId != null && orderId.isNotEmpty) {
          await Get.to(() => OrderDetailScreen(orderId: orderId));
        }
        return;
      case 'delivery_started':
        final orderId = data['orderId'];
        if (orderId != null && orderId.isNotEmpty) {
          await openTrackingOrder(orderId);
        }
        return;
      case 'complaint':
      case 'complaint_status':
      case 'complaint_created':
        final complaintId = data['complaintId'] ?? entityId;
        if (complaintId != null && complaintId.isNotEmpty) {
          await Get.to(() => ComplaintDetailScreen(complaintId: complaintId));
        }
        return;
      case 'delivery':
        await Get.to(() => const CouponsScreen());
        return;
      default:
        return;
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

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: darwin);
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        final decoded = jsonDecode(payload);
        if (decoded is Map) {
          _routeData(decoded.map((key, value) => MapEntry('$key', '$value')));
        }
      },
      onDidReceiveBackgroundNotificationResponse:
          freshpickkatNotificationTapBackground,
    );
    const channel = AndroidNotificationChannel(
      'freshpickkat_foreground',
      'FreshPickKat notifications',
      description: 'Foreground notifications shown while the app is open.',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final title = message.notification?.title ?? message.data['title'];
    final body = message.notification?.body ?? message.data['body'];
    if (title == null || body == null) return;

    // Use a stable ID derived from orderId + type so that rapid duplicate FCM
    // messages for the same event replace each other instead of stacking up.
    final orderId = message.data['orderId']?.toString() ?? '';
    final type = message.data['type']?.toString() ?? '';
    final notificationId = (orderId.isNotEmpty || type.isNotEmpty)
        ? '${orderId}_$type'.hashCode.abs() & 0x7FFFFFFF
        : DateTime.now().millisecondsSinceEpoch ~/ 1000;

    const android = AndroidNotificationDetails(
      'freshpickkat_foreground',
      'FreshPickKat notifications',
      channelDescription:
          'Foreground notifications shown while the app is open.',
      importance: Importance.high,
      priority: Priority.high,
    );
    const darwin = DarwinNotificationDetails();
    await _localNotifications.show(
      notificationId,
      title.toString(),
      body.toString(),
      const NotificationDetails(android: android, iOS: darwin),
      payload: jsonEncode(message.data),
    );
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    _openedAppSubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    super.onClose();
  }
}
