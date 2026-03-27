import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService {
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  final InternetConnection _internetConnection = InternetConnection();

  Future<bool> hasInternet() async {
    return await _internetConnection.hasInternetAccess;
  }

  Stream<InternetStatus> get onStatusChange => _internetConnection.onStatusChange;
}
