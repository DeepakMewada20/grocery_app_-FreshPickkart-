import 'package:flutter/foundation.dart';

class AppLogger {
  static void error(String tag, dynamic error, [StackTrace? stack]) {
    debugPrint('❌ [$tag] $error');
    if (stack != null) debugPrint(stack.toString());
  }

  static void info(String tag, String message) {
    debugPrint('ℹ️ [$tag] $message');
  }

  static void warning(String tag, String message) {
    debugPrint('⚠️ [$tag] $message');
  }
}
