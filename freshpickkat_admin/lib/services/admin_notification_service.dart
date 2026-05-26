import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:freshpickkat_admin/services/admin_notification_navigation_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AdminNotificationService {
  static const String _savedFcmTokenKey = 'admin_saved_fcm_token';
  static const String _deviceIdKey = 'admin_notification_device_id';

  static bool _initialized = false;
  static String? _registeredUid;
  static StreamSubscription<String>? _tokenRefreshSubscription;
  static StreamSubscription<RemoteMessage>? _openedAppSubscription;
  static final GetStorage _storage = GetStorage();

  static Future<void> init() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (_initialized && _registeredUid == user.uid) return;
    await _tokenRefreshSubscription?.cancel();
    await _openedAppSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _openedAppSubscription = null;
    _initialized = true;
    _registeredUid = user.uid;

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    final token = await messaging.getToken();
    await _registerToken(user, token: token);
    await messaging.subscribeToTopic('admin');

    _tokenRefreshSubscription = messaging.onTokenRefresh.listen((token) async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;
      await _registerToken(currentUser, token: token);
      await messaging.subscribeToTopic('admin');
    });

    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleOpenedMessage,
    );

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleOpenedMessage(initialMessage);
    }
  }

  static Future<void> cleanupForLogout() async {
    final user = FirebaseAuth.instance.currentUser;
    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();

    if (user != null) {
      try {
        final idToken = await user.getIdToken();
        if (idToken != null && idToken.trim().isNotEmpty) {
          await ServerpodAdminClient().client.notification
              .unregisterAdminFcmToken(
                user.uid,
                idToken,
                _deviceId(),
                token: token,
              );
        }
      } catch (_) {
        // Logout should continue even if the server cannot be reached.
      }
    }

    try {
      await messaging.unsubscribeFromTopic('admin');
    } catch (_) {}

    await _storage.remove(_savedFcmTokenKey);
    await _tokenRefreshSubscription?.cancel();
    await _openedAppSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _openedAppSubscription = null;
    _initialized = false;
    _registeredUid = null;
  }

  static Future<void> _registerToken(User user, {String? token}) async {
    final fcmToken = token ?? await FirebaseMessaging.instance.getToken();
    if (fcmToken == null || fcmToken.trim().isEmpty) return;

    final savedToken = _storage.read<String>(_savedFcmTokenKey);
    if (savedToken == fcmToken) return;

    final idToken = await user.getIdToken();
    if (idToken == null || idToken.trim().isEmpty) return;

    await ServerpodAdminClient().client.notification.registerAdminFcmToken(
      user.uid,
      idToken,
      fcmToken,
      _deviceId(),
      _platformName(),
    );
    await _storage.write(_savedFcmTokenKey, fcmToken);
  }

  static String _deviceId() {
    final existing = _storage.read<String>(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final created =
        'admin-device-${DateTime.now().microsecondsSinceEpoch}-${_platformName()}';
    _storage.write(_deviceIdKey, created);
    return created;
  }

  static String _platformName() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform.name.toLowerCase();
  }

  static void _handleOpenedMessage(RemoteMessage message) {
    final type = message.data['type']?.toString();
    final orderId = message.data['orderId']?.toString().trim();
    if (type != 'admin_new_order' || orderId == null || orderId.isEmpty) {
      return;
    }

    if (!Get.isRegistered<AdminNotificationNavigationService>()) return;
    AdminNotificationNavigationService.instance.focusOrder(orderId);
  }
}
