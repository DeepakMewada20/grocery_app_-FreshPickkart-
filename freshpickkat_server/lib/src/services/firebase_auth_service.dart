import 'package:firebase_admin/firebase_admin.dart';

import 'firebase_service.dart';

class VerifiedFirebaseToken {
  const VerifiedFirebaseToken({
    required this.uid,
    this.email,
    required this.emailVerified,
    this.phoneNumber,
    required this.phoneVerified,
  });

  final String uid;
  final String? email;
  final bool emailVerified;
  final String? phoneNumber;
  final bool phoneVerified;
}

class FirebaseAuthService {
  static const String _appName = 'freshpickkat-server-auth';
  static App? _app;
  static String? _lastVerifyError;

  static Future<Auth> getAuth() async {
    final existing = _app;
    if (existing != null) return existing.auth();

    try {
      _app = FirebaseAdmin.instance.app(_appName);
      return _app!.auth();
    } catch (_) {
      final app = FirebaseAdmin.instance.initializeApp(
        AppOptions(
          credential: FirebaseAdmin.instance.certFromPath(
            FirebaseService.serviceAccountPath,
          ),
          projectId: FirebaseService.projectId,
        ),
        _appName,
      );
      _app = app;
      return app.auth();
    }
  }

  static Future<VerifiedFirebaseToken?> verifyIdToken(String idToken) async {
    _lastVerifyError = null;
    var raw = idToken.trim();
    if (raw.toLowerCase().startsWith('bearer ')) {
      raw = raw.substring(7).trim();
    }
    if (raw.isEmpty) return null;

    try {
      final auth = await getAuth();
      final decoded = await auth.verifyIdToken(raw, false);
      final claims = decoded.claims;
      return VerifiedFirebaseToken(
        uid: claims.subject,
        email: claims.email,
        emailVerified: claims.emailVerified ?? false,
        phoneNumber: claims.phoneNumber,
        phoneVerified: claims.phoneNumberVerified ?? false,
      );
    } catch (e) {
      _lastVerifyError = e.toString();
      return null;
    }
  }

  static String? getLastVerifyError() => _lastVerifyError;
}
