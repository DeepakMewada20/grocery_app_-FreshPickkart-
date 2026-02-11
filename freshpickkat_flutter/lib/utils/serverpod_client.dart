import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class ServerpodClient {
  ServerpodClient._internal();

  static final ServerpodClient _instance = ServerpodClient._internal();

  factory ServerpodClient() => _instance;

  static const String baseUrl =
      'http://10.0.2.2:8080/'; // Change only here

  final Client client = Client(
    baseUrl,
  )..connectivityMonitor=FlutterConnectivityMonitor();
}
