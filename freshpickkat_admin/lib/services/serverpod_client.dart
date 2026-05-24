import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/config/admin_env.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class ServerpodAdminClient {
  ServerpodAdminClient._internal();

  static final ServerpodAdminClient _instance =
      ServerpodAdminClient._internal();

  factory ServerpodAdminClient() => _instance;

  final Client client = Client(AdminEnv.adminApiBaseUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor();
}
