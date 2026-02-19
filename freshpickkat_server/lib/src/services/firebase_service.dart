import 'dart:io';
import 'package:googleapis/firestore/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebaseService {
  // Service account credentials for admin SDK
  static Future<ServiceAccountCredentials>
  getServiceAccountCredentials() async {
    final jsonCredentials = await File(_serviceAccountPath).readAsString();
    return ServiceAccountCredentials.fromJson(jsonCredentials);
  }

  static const _serviceAccountPath = 'config/firebase_service_account_key.json';

  // Firestore API ka client lene ke liye ye function use karein
  static Future<FirestoreApi> getFirestoreClient() async {
    final jsonCredentials = await File(_serviceAccountPath).readAsString();
    final credentials = ServiceAccountCredentials.fromJson(jsonCredentials);

    // Firestore ke liye permission scope
    final scopes = [FirestoreApi.datastoreScope];

    // Auth client create karein
    final client = await clientViaServiceAccount(credentials, scopes);
    return FirestoreApi(client);
  }
}
