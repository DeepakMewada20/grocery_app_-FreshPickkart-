import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class NotificationTopicService {
  NotificationTopicService({FirebaseMessaging? messaging})
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  Future<void> syncTopics(NotificationPreference preferences) async {
    await _setTopic('coupons', preferences.couponNotifications);
    await _setTopic('offers', preferences.offerNotifications);
    await _setTopic('announcements', preferences.announcementNotifications);
    await _setTopic('important-alerts', preferences.importantAlerts);
    await _setTopic('track-order', preferences.trackOrderNotifications);
  }

  Future<void> _setTopic(String topic, bool enabled) {
    return enabled
        ? _messaging.subscribeToTopic(topic)
        : _messaging.unsubscribeFromTopic(topic);
  }
}
