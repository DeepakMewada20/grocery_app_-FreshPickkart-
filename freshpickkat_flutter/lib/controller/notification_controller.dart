import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController get instance =>
      Get.put(NotificationController(), permanent: true);

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _currentToken;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await _messaging.requestPermission();

    _currentToken = await _messaging.getToken();
    await syncTokenWithServer();

    _messaging.onTokenRefresh.listen((token) async {
      _currentToken = token;
      await syncTokenWithServer();
    });
  }

  Future<void> syncTokenWithServer() async {
    final token = _currentToken;
    if (token == null || token.isEmpty) return;

    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) return;

    try {
      await ServerpodClient().client.user.updateFcmToken(user.uid, token);
    } catch (_) {
      // Ignore token sync errors for now.
    }
  }
}
