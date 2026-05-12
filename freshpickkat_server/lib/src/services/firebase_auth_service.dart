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
  static final Map<String, _CachedVerifiedToken> _tokenCache = {};

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

    final now = DateTime.now();

    // 1. Check local cache first
    if (_tokenCache.containsKey(raw)) {
      final cached = _tokenCache[raw]!;
      if (cached.expiresAt.isAfter(now)) {
        return cached.token;
      }
      _tokenCache.remove(raw);
    }

    int attempts = 0;
    const maxAttempts = 3;

    while (attempts < maxAttempts) {
      attempts++;
      try {
        final auth = await getAuth();
        final decoded = await auth.verifyIdToken(raw, false);
        final claims = decoded.claims;
        final verified = VerifiedFirebaseToken(
          uid: claims.subject,
          email: claims.email,
          emailVerified: claims.emailVerified ?? false,
          phoneNumber: claims.phoneNumber,
          phoneVerified: claims.phoneNumberVerified ?? false,
        );

        // 2. Cache the result for 5 minutes
        _tokenCache[raw] = _CachedVerifiedToken(
          token: verified,
          expiresAt: now.add(const Duration(minutes: 5)),
        );

        return verified;
      } catch (e) {
        final errorStr = e.toString();
        _lastVerifyError = errorStr;

        // 3. Retry on network/handshake errors
        if (errorStr.contains('HandshakeException') ||
            errorStr.contains('Connection terminated') ||
            errorStr.contains('SocketException') ||
            errorStr.contains('HttpException')) {
          if (attempts < maxAttempts) {
            // Wait before retrying (exponential backoff)
            await Future.delayed(Duration(milliseconds: attempts * 200));
            continue;
          }
        }
        break;
      }
    }
    return null;
  }

  static String? getLastVerifyError() => _lastVerifyError;
}

class _CachedVerifiedToken {
  final VerifiedFirebaseToken token;
  final DateTime expiresAt;

  const _CachedVerifiedToken({
    required this.token,
    required this.expiresAt,
  });
}
