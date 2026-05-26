import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';

class NotificationTopicService {
  NotificationTopicService({FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  Future<void> syncTopics(NotificationPreference preferences) async {
    final user = AuthController.instance.currentUser;
    if (user != null) {
      await _messaging.subscribeToTopic(_userTopic(user.uid));
    }
    await _setTopic('coupons', preferences.couponNotifications);
    await _setTopic('offers', preferences.offerNotifications);
    await _setTopic('announcements', preferences.announcementNotifications);
    await _setTopic('important-alerts', preferences.importantAlerts);
    await _setTopic('track-order', preferences.trackOrderNotifications);
  }

  Future<void> unsubscribeForLogout(String firebaseUid) async {
    final normalizedUid = firebaseUid.trim();
    if (normalizedUid.isNotEmpty) {
      await _messaging.unsubscribeFromTopic(_userTopic(normalizedUid));
    }
    await _messaging.unsubscribeFromTopic('coupons');
    await _messaging.unsubscribeFromTopic('offers');
    await _messaging.unsubscribeFromTopic('announcements');
    await _messaging.unsubscribeFromTopic('important-alerts');
    await _messaging.unsubscribeFromTopic('track-order');
  }

  Future<void> _setTopic(String topic, bool enabled) {
    return enabled
        ? _messaging.subscribeToTopic(topic)
        : _messaging.unsubscribeFromTopic(topic);
  }

  String _userTopic(String firebaseUid) {
    return 'user-${firebaseUid.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_-]+'), '-')}';
  }
}
