import 'dart:io';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class ServerpodClient {
  ServerpodClient._internal();

  static final ServerpodClient _instance = ServerpodClient._internal();

  factory ServerpodClient() => _instance;

  // 👇 CHANGE ONLY THIS (your PC local IP)
  static const String _localIp = '10.98.105.170';

  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android Emulator
      if (_isAndroidEmulator()) {
        return 'http://10.0.2.2:8080/';
      } else {
        // Real Android Phone
        return 'http://$_localIp:8080/';
      }
    } else if (Platform.isIOS) {
      return 'http://localhost:8080/';
    } else {
      return 'http://$_localIp:8080/';
    }
  }

  static bool _isAndroidEmulator() {
    return !Platform.environment.containsKey('ANDROID_ROOT');
  }

  final Client client = Client(
    baseUrl,
  )..connectivityMonitor = FlutterConnectivityMonitor();
}
