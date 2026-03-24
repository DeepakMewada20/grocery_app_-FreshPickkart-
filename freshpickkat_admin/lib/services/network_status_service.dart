import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkStatusService {
  NetworkStatusService._internal();

  static final NetworkStatusService instance = NetworkStatusService._internal();

  final InternetConnection _connectionChecker =
      InternetConnection.createInstance();

  Stream<bool> get onStatusChange => _connectionChecker.onStatusChange
      .map((status) => status == InternetStatus.connected)
      .distinct();

  Future<bool> hasConnection() {
    return _connectionChecker.hasInternetAccess;
  }

  static bool looksLikeNetworkError(Object error) {
    final text = error.toString().toLowerCase();
    return text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('clientexception') ||
        text.contains('network-request-failed') ||
        text.contains('timed out') ||
        text.contains('timeout') ||
        text.contains('connection closed') ||
        text.contains('connection error') ||
        text.contains('handshake') ||
        text.contains('dns') ||
        text.contains('no address associated with hostname') ||
        text.contains('serverpodclientexception');
  }
}
