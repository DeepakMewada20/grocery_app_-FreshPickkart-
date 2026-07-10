import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/services/order_recovery_service.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  static OrderController get instance =>
      Get.put(OrderController(), permanent: true);

  final Client _client = ServerpodClient().client;
  final OrderRecoveryService _orderRecoveryService =
      OrderRecoveryService.instance;

  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Mutex lock to prevent duplicate API calls
  bool _isFetching = false;

  Future<void> fetchOrders() async {
    if (_isFetching) return;

    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) {
      orders.clear();
      errorMessage.value = ErrorMessages.loginRequired;
      return;
    }

    _isFetching = true;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _orderRecoveryService.recoverPendingPayments(
        trigger: 'orders_page',
      );
      await _loadOrders();
    } catch (e) {
      errorMessage.value = ErrorMessages.loadFailed('orders');
      AppLogger.error('Orders', e);
    } finally {
      isLoading.value = false;
      _isFetching = false;
    }
  }

  Future<void> refreshFromRealtime() async {
    if (_isFetching) return;
    _isFetching = true;
    try {
      await _loadOrders();
    } catch (e) {
      AppLogger.warning('Orders', 'Realtime refresh: $e');
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _loadOrders() async {
    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) {
      orders.clear();
      return;
    }

    final idToken = await auth.requireIdToken();
    final result = await _client.order.getUserOrders(user.uid, idToken);
    orders.assignAll(result);
  }

  Future<Order?> fetchOrderById(String orderId) async {
    try {
      final auth = AuthController.instance;
      final user = auth.currentUser;
      if (user == null) return null;
      final idToken = await auth.requireIdToken();
      return await _client.order.getOrderById(orderId, user.uid, idToken);
    } catch (e) {
      AppLogger.warning('Orders', 'fetchOrderById: $e');
      return null;
    }
  }

  /// Get delivery address for order (always from saved user address)
  Address? getDeliveryAddress(Address? userSavedAddress) {
    return userSavedAddress;
  }
}
