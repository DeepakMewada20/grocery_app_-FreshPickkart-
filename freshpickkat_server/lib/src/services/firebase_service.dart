import 'dart:io';
import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebaseService {
  static const String projectId = 'freshpickkart-a6824';
  static const String serviceAccountPath =
      'config/firebase_service_account_key.json';

  static FirestoreApi? _cachedFirestore;
  static ServiceAccountCredentials? _cachedCredentials;
  static bool _isInitializing = false;

  static Future<ServiceAccountCredentials>
  getServiceAccountCredentials() async {
    if (_cachedCredentials != null) return _cachedCredentials!;

    final jsonCredentials = await File(serviceAccountPath).readAsString();
    _cachedCredentials = ServiceAccountCredentials.fromJson(jsonCredentials);
    return _cachedCredentials!;
  }

  static Future<FirestoreApi> getFirestoreClient() async {
    final cached = _cachedFirestore;
    if (cached != null) return cached;

    while (_isInitializing) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    final existingCached = _cachedFirestore;
    if (existingCached != null) return existingCached;

    _isInitializing = true;
    try {
      final credentials = await getServiceAccountCredentials();
      final scopes = [FirestoreApi.datastoreScope];
      final client = await clientViaServiceAccount(credentials, scopes);
      final firestore = FirestoreApi(client);
      _cachedFirestore = firestore;
      return firestore;
    } finally {
      _isInitializing = false;
    }
  }

  static void clearCache() {
    _cachedFirestore = null;
  }
}
