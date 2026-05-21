import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freshpickkat_admin/services/admin_notification_navigation_service.dart';
import 'package:get/get.dart';

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

    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage);

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleOpenedMessage(initialMessage);
    }
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
