import 'package:freshpickkat_flutter/services/process_recovery/process_recovery_constants.dart';

class SavedRouteState {
  final String route;
  final String? argumentsJson;
  final DateTime timestamp;

  const SavedRouteState({
    required this.route,
    this.argumentsJson,
    required this.timestamp,
  });

  bool get isExpired =>
      DateTime.now().difference(timestamp) > ProcessRecoveryConstants.expiryDuration;

  bool get isValid =>
      route.isNotEmpty && !ProcessRecoveryConstants.isBlocked(route);

  bool canRestoreExact() => ProcessRecoveryConstants.isRegisteredRoute(route);

  Map<String, dynamic> toJson() => {
    'route': route,
    'argumentsJson': argumentsJson,
    'timestamp': timestamp.toIso8601String(),
  };

  factory SavedRouteState.fromJson(Map<String, dynamic> json) => SavedRouteState(
    route: json['route'] as String,
    argumentsJson: json['argumentsJson'] as String?,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}
