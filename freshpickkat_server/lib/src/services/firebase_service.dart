import 'dart:io';
import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebaseService {
  static const String projectId = 'freshpickkart-a6824';
  static const String serviceAccountPath =
      'config/firebase_service_account_key.json';

  static FirestoreApi? _cachedFirestore;

  // Service account credentials for admin SDK
  static Future<ServiceAccountCredentials>
  getServiceAccountCredentials() async {
    final jsonCredentials = await File(serviceAccountPath).readAsString();
    return ServiceAccountCredentials.fromJson(jsonCredentials);
  }

  // Firestore API ka client lene ke liye ye function use karein
  static Future<FirestoreApi> getFirestoreClient() async {
    final cached = _cachedFirestore;
    if (cached != null) return cached;

    final jsonCredentials = await File(serviceAccountPath).readAsString();
    final credentials = ServiceAccountCredentials.fromJson(jsonCredentials);

    // Firestore ke liye permission scope
    final scopes = [FirestoreApi.datastoreScope];

    // Auth client create karein
    final client = await clientViaServiceAccount(credentials, scopes);
    final firestore = FirestoreApi(client);
    _cachedFirestore = firestore;
    return firestore;
  }
}
