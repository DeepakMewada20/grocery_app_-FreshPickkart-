import 'dart:io';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class ServerpodAdminClient {
  ServerpodAdminClient._internal();

  static final ServerpodAdminClient _instance =
      ServerpodAdminClient._internal();

  factory ServerpodAdminClient() => _instance;

  static const String _localIp = '10.95.88.170';

  static String get baseUrl {
    if (Platform.isAndroid) {
      if (_isAndroidEmulator()) {
        return 'http://10.0.2.2:8080/';
      }
      return 'http://$_localIp:8080/';
    }

    if (Platform.isIOS) {
      return 'http://localhost:8080/';
    }

    return 'http://$_localIp:8080/';
  }

  static bool _isAndroidEmulator() {
    return !Platform.environment.containsKey('ANDROID_ROOT');
  }

  final Client client = Client(baseUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();
}
