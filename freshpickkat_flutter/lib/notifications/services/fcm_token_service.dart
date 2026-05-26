import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get_storage/get_storage.dart';

class FcmTokenService {
  FcmTokenService({
    FirebaseMessaging? messaging,
    GetStorage? storage,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _storage = storage ?? GetStorage();

  static const String _savedFcmTokenKey = 'saved_fcm_token';
  static const String _deviceIdKey = 'notification_device_id';

  final FirebaseMessaging _messaging;
  final GetStorage _storage;

  Future<String?> requestAndGetToken() async {
    await _messaging.requestPermission();
    return _messaging.getToken();
  }

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  Future<void> syncCurrentToken({String? token}) async {
    final user = AuthController.instance.currentUser;
    if (user == null) return;

    final fcmToken = token ?? await _messaging.getToken();
    if (fcmToken == null || fcmToken.trim().isEmpty) return;

    final savedToken = _storage.read<String>(_savedFcmTokenKey);
    final deviceId = _deviceId();
    if (savedToken == fcmToken) return;

    await ServerpodClient().client.notification.registerFcmToken(
      user.uid,
      fcmToken,
      deviceId,
      _platformName(),
    );
    await _storage.write(_savedFcmTokenKey, fcmToken);
  }

  Future<void> unregisterCurrentDevice({String? firebaseUid}) async {
    final uid = firebaseUid ?? AuthController.instance.currentUser?.uid;
    if (uid == null || uid.trim().isEmpty) {
      await _storage.remove(_savedFcmTokenKey);
      return;
    }

    final fcmToken = await _messaging.getToken();
    await ServerpodClient().client.notification.unregisterFcmToken(
      uid,
      _deviceId(),
      token: fcmToken,
    );
    await _storage.remove(_savedFcmTokenKey);
  }

  String _deviceId() {
    final existing = _storage.read<String>(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final created =
        'device-${DateTime.now().microsecondsSinceEpoch}-${_platformName()}';
    _storage.write(_deviceIdKey, created);
    return created;
  }

  String _platformName() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform.name.toLowerCase();
  }
}
