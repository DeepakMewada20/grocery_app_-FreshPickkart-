import 'dart:io';
import 'package:flutter/foundation.dart';

class AdminEnv {
  static String get adminApiBaseUrl {
    const raw = String.fromEnvironment('ADMIN_API_BASE_URL');
    final trimmed = raw.trim();

    if (trimmed.isNotEmpty) {
      return _ensureTrailingSlash(trimmed);
    }

    // Smart Defaults for local development
    String defaultUrl;
    if (kIsWeb) {
      defaultUrl = 'http://localhost:8080/';
    } else if (Platform.isAndroid) {
      // 10.0.2.2 is the special alias for the host machine in Android Emulator
      defaultUrl = 'http://10.0.2.2:8080/';
    } else {
      defaultUrl = 'http://localhost:8080/';
    }

    // ignore: avoid_print
    print('⚠️ ADMIN_API_BASE_URL not set. Using smart default: $defaultUrl');
    // ignore: avoid_print
    print(
      '💡 For physical devices, run with: --dart-define=ADMIN_API_BASE_URL=http://<YOUR_IP>:8080/',
    );

    return defaultUrl;
  }

  static String _ensureTrailingSlash(String url) {
    if (url.endsWith('/')) {
      return url;
    }
    return '$url/';
  }
}
