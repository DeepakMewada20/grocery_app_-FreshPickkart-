import 'package:firebase_messaging/firebase_messaging.dart';

class AdminNotificationService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    await messaging.getToken();
    await messaging.subscribeToTopic('admin');

    messaging.onTokenRefresh.listen((_) async {
      await messaging.subscribeToTopic('admin');
    });
  }
}
