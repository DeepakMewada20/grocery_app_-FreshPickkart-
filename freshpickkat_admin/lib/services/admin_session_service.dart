import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshpickkat_admin/core/exceptions.dart';
import 'package:freshpickkat_admin/services/admin_auth_failure_handler.dart';

class AdminSessionService {
  static String requireUid() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.trim().isEmpty) {
      unawaited(
        AdminAuthFailureHandler.handle(
          AuthFailureException('Login expired. Please login again.'),
        ),
      );
      throw AuthFailureException('Login expired. Please login again.');
    }
    return uid;
  }

  static Future<String> requireIdToken({bool forceRefresh = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      await AdminAuthFailureHandler.handle(
        AuthFailureException('Login expired. Please login again.'),
      );
      throw AuthFailureException('Login expired. Please login again.');
    }
    final token = await user.getIdToken(forceRefresh);
    if (token == null || token.trim().isEmpty) {
      await AdminAuthFailureHandler.handle(
        AuthFailureException('Invalid login session. Please login again.'),
      );
      throw AuthFailureException('Invalid login session. Please login again.');
    }
    return token;
  }
}
