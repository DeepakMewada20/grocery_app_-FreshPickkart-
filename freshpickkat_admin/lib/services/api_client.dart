import 'dart:async';
import 'dart:io';
import '../core/exceptions.dart';
import 'network_service.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  final NetworkService _networkService = NetworkService();

  Future<T> request<T>(Future<T> Function() apiCall) async {
    final bool hasAccess = await _networkService.hasInternet();
    if (!hasAccess) {
      throw NoInternetException();
    }

    try {
      // 30 seconds timeout for better slow network tolerance
      return await apiCall().timeout(const Duration(seconds: 20));
    } on TimeoutException {
      throw RequestTimeoutException();
    } on SocketException {
      throw NetworkException();
    } on NoInternetException {
      rethrow;
    } catch (e) {
      final errorString = e.toString();
      if (errorString.contains('ServerpodClientException')) {
        rethrow;
      }
      throw UnknownException(errorString);
    }
  }
}
