import 'package:firebase_auth/firebase_auth.dart';

class AdminSessionService {
  static String requireUid() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.trim().isEmpty) {
      throw Exception('Login expired. Please login again.');
    }
    return uid;
  }

  static Future<String> requireIdToken({bool forceRefresh = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Login expired. Please login again.');
    }
    final token = await user.getIdToken(forceRefresh);
    if (token == null || token.trim().isEmpty) {
      throw Exception('Invalid login session. Please login again.');
    }
    return token;
  }
}
