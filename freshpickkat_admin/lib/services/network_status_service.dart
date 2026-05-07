import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'network_service.dart';

class NetworkStatusService {
  NetworkStatusService._internal();

  static final NetworkStatusService instance = NetworkStatusService._internal();

  final NetworkService _networkService = NetworkService();

  Stream<bool> get onStatusChange => _networkService.onStatusChange
      .map((status) => status == InternetStatus.connected)
      .distinct();

  Future<bool> hasConnection() {
    return _networkService.hasInternet();
  }

  static bool isTrueNetworkError(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('network-request-failed') ||
        text.contains('no address associated with hostname') ||
        text.contains('connection refused') ||
        text.contains('network is unreachable') ||
        text.contains('nodename nor servname provided');
  }
}
