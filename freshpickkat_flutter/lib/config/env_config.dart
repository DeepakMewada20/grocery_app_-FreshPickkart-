import 'dart:io';
import 'package:flutter/foundation.dart';

class EnvConfig {
  /// The base URL for the Serverpod API.
  ///
  /// Priority:
  /// 1. --dart-define=API_BASE_URL=...
  /// 2. Smart defaults based on platform (localhost for web, 10.0.2.2 for Android emulator)
  static String get apiBaseUrl {
    const raw = String.fromEnvironment('API_BASE_URL');
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

    return defaultUrl;
  }

  static String _ensureTrailingSlash(String url) {
    if (url.endsWith('/')) {
      return url;
    }
    return '$url/';
  }
}
