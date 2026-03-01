import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  static NetworkController get instance =>
      Get.put(NetworkController(), permanent: true);

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final isConnected = true.obs;
  final isChecking = true.obs;

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
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      isConnected.value = false;
    } else {
      // Even if connectivity says we are connected, check if we can actually reach the internet
      try {
        final result = await InternetAddress.lookup('google.com').timeout(
          const Duration(seconds: 3),
        );
        isConnected.value =
            result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {
        isConnected.value = false;
      }
    }
  }

  Future<bool> checkConnection() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.isEmpty || result.contains(ConnectivityResult.none)) {
        isConnected.value = false;
        return false;
      }

      final lookup = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 3),
      );
      final connected = lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
      isConnected.value = connected;
      return connected;
    } catch (_) {
      isConnected.value = false;
      return false;
    }
  }
}
