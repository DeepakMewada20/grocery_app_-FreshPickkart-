import 'dart:io';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class ServerpodClient {
  ServerpodClient._internal();

  static final ServerpodClient _instance = ServerpodClient._internal();

  factory ServerpodClient() => _instance;

  static String get baseUrl {
    String url;
    if (Platform.isAndroid) {
      url = 'http://localhost:8080/';
    } else if (Platform.isIOS) {
      url = 'http://localhost:8080/';
    } else {
      url = 'http://localhost:8080/';
    }
    print('Serverpod Base URL: $url');
    return url;
  }

  final Client client = Client(
    baseUrl,
  )..connectivityMonitor = FlutterConnectivityMonitor();
}
