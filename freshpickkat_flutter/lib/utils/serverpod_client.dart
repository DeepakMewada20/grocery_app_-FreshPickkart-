import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import '../config/env_config.dart';

class ServerpodClient {
  ServerpodClient._internal();

  static final ServerpodClient _instance = ServerpodClient._internal();

  factory ServerpodClient() => _instance;

  static String get baseUrl => EnvConfig.apiBaseUrl;

  final Client client = Client(
    baseUrl,
  )..connectivityMonitor = FlutterConnectivityMonitor();
}
