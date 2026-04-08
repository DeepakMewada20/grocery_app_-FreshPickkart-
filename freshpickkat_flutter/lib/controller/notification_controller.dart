import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
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
      Get.put(NotificationController(), permanent: true);

  static const String _savedFcmTokenKey = 'saved_fcm_token';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GetStorage _storage = GetStorage();
  final RxList<AppNotificationItem> notifications = <AppNotificationItem>[].obs;
  String? _currentToken;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await _messaging.requestPermission();

    _currentToken = await _messaging.getToken();

    _messaging.onTokenRefresh.listen(_onTokenRefresh);
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
}
