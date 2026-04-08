import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

enum ConnectionType { wifi, mobile, ethernet, none }

enum ConnectionQuality { excellent, good, poor, unknown }

class NetworkController extends GetxController {
  static NetworkController get instance =>
      Get.put(NetworkController(), permanent: true);

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final isConnected = true.obs;
  final isChecking = true.obs;
  final connectionType = ConnectionType.none.obs;
  final connectionQuality = ConnectionQuality.unknown.obs;
  final connectionRestoredTrigger = 0.obs;

  DateTime? _lastDisconnectedTime;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      isChecking.value = true;
      final result = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(result);
    } catch (e) {
      isConnected.value = false;
      connectionType.value = ConnectionType.none;
    } finally {
      isChecking.value = false;
    }
  }

  ConnectionType _getConnectionType(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectionType.none;
    }
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectionType.wifi;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectionType.mobile;
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectionType.ethernet;
    }
    return ConnectionType.none;
  }

  String get connectionTypeIcon {
    switch (connectionType.value) {
      case ConnectionType.wifi:
        return '📶';
      case ConnectionType.mobile:
        return '📱';
      case ConnectionType.ethernet:
        return '🔌';
      case ConnectionType.none:
        return '🚫';
    }
  }

  String get connectionTypeLabel {
    switch (connectionType.value) {
      case ConnectionType.wifi:
        return 'WiFi';
      case ConnectionType.mobile:
        return 'Mobile Data';
      case ConnectionType.ethernet:
        return 'Ethernet';
      case ConnectionType.none:
        return 'No Connection';
    }
  }

  String get connectionQualityLabel {
    switch (connectionQuality.value) {
      case ConnectionQuality.excellent:
        return 'Excellent';
      case ConnectionQuality.good:
        return 'Good';
      case ConnectionQuality.poor:
        return 'Poor';
      case ConnectionQuality.unknown:
        return '';
    }
  }

  bool get wasJustDisconnected {
    if (_lastDisconnectedTime == null) return false;
    return DateTime.now().difference(_lastDisconnectedTime!).inSeconds < 5;
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final previousConnection = isConnected.value;
    connectionType.value = _getConnectionType(results);

    if (connectionType.value == ConnectionType.none) {
      _lastDisconnectedTime = DateTime.now();
      isConnected.value = false;
      connectionQuality.value = ConnectionQuality.unknown;
    } else {
      try {
        final stopwatch = Stopwatch()..start();
        final result = await InternetAddress.lookup('google.com').timeout(
          const Duration(seconds: 5),
        );
        stopwatch.stop();

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          isConnected.value = true;
          connectionQuality.value = _measureQuality(
            stopwatch.elapsedMilliseconds,
          );
        } else {
          isConnected.value = false;
          connectionQuality.value = ConnectionQuality.unknown;
        }
      } catch (_) {
        isConnected.value = false;
        connectionQuality.value = ConnectionQuality.unknown;
      }
    }

    if (!previousConnection && isConnected.value) {
      _onConnectionRestored();
    } else if (previousConnection && !isConnected.value) {
      _onConnectionLost();
    }
  }

  ConnectionQuality _measureQuality(int latencyMs) {
    if (latencyMs < 100) return ConnectionQuality.excellent;
    if (latencyMs < 300) return ConnectionQuality.good;
    return ConnectionQuality.poor;
  }

  void _onConnectionRestored() {
    connectionRestoredTrigger.value++;
  }

  void _onConnectionLost() {}

  Future<bool> checkConnection() async {
    try {
      isChecking.value = true;
      final result = await _connectivity.checkConnectivity();
      connectionType.value = _getConnectionType(result);

      if (connectionType.value == ConnectionType.none) {
        isConnected.value = false;
        connectionQuality.value = ConnectionQuality.unknown;
        return false;
      }

      final stopwatch = Stopwatch()..start();
      final lookup = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 5),
      );
      stopwatch.stop();

      final connected = lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
      isConnected.value = connected;
      if (connected) {
        connectionQuality.value = _measureQuality(
          stopwatch.elapsedMilliseconds,
        );
      }
      return connected;
    } catch (_) {
      isConnected.value = false;
      connectionQuality.value = ConnectionQuality.unknown;
      return false;
    } finally {
      isChecking.value = false;
    }
  }
}
