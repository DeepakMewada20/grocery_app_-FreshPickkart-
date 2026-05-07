class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'No Internet Connection']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error occurred']);

  @override
  String toString() => message;
}

class RequestTimeoutException implements Exception {
  final String message;
  RequestTimeoutException([this.message = 'Request timed out']);

  @override
  String toString() => message;
}

class UnknownException implements Exception {
  final String message;
  UnknownException([this.message = 'An unknown error occurred']);

  @override
  String toString() => message;
}

class AuthFailureException implements Exception {
  final String message;
  AuthFailureException([this.message = 'Login expired. Please login again.']);

  @override
  String toString() => message;
}
