import 'dart:async';
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
      _updateConnectionStatus(result);
    } catch (e) {
      isConnected.value = false;
    } finally {
      isChecking.value = false;
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    isConnected.value =
        results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    final connected =
        result.isNotEmpty && !result.contains(ConnectivityResult.none);
    isConnected.value = connected;
    return connected;
  }
}
