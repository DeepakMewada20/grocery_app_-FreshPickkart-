import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';

class FirebaseService {
  static const String projectId = 'freshpickkart-a6824';
  static const String serviceAccountPath =
      'config/firebase_service_account_key.json';

  static ServiceAccountCredentials? _cachedCredentials;

  static Future<ServiceAccountCredentials>
  getServiceAccountCredentials() async {
    if (_cachedCredentials != null) return _cachedCredentials!;

    final jsonCredentials = await File(serviceAccountPath).readAsString();
    _cachedCredentials = ServiceAccountCredentials.fromJson(jsonCredentials);
    return _cachedCredentials!;
  }

  static void clearCache() {
    _cachedCredentials = null;
  }
}
