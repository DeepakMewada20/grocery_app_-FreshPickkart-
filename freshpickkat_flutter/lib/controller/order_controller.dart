import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/services/order_recovery_service.dart';
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

  /// Temporary delivery address for checkout (not saved to DB)
  /// Used only for current order placement
  final Rx<Address?> tempDeliveryAddress = Rx<Address?>(null);
  final RxBool saveAddressForFuture = false.obs;

  // Mutex lock to prevent duplicate API calls
  bool _isFetching = false;

  Future<void> fetchOrders() async {
    if (_isFetching) return;

    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) {
      orders.clear();
      errorMessage.value = 'Login required to view orders.';
      return;
    }

    _isFetching = true;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _orderRecoveryService.recoverPendingPayments(
        trigger: 'orders_page',
      );
      final idToken = await auth.requireIdToken();
      final result = await _client.order.getUserOrders(user.uid, idToken);
      orders.assignAll(result);
    } catch (e) {
      // ignore: avoid_print
      print('Failed to load orders: $e');
      errorMessage.value = 'Failed to load orders: $e';
    } finally {
      isLoading.value = false;
      _isFetching = false;
    }
  }

  Future<Order?> fetchOrderById(String orderId) async {
    try {
      final auth = AuthController.instance;
      final user = auth.currentUser;
      if (user == null) return null;
      final idToken = await auth.requireIdToken();
      return await _client.order.getOrderById(orderId, user.uid, idToken);
    } catch (_) {
      return null;
    }
  }

  /// Set temporary delivery address for checkout flow
  /// This address is NOT saved to database
  void setTempDeliveryAddress(Address address, {bool saveForFuture = false}) {
    tempDeliveryAddress.value = address;
    saveAddressForFuture.value = saveForFuture;
  }

  /// Clear temporary delivery address after order is placed
  void clearTempDeliveryAddress() {
    tempDeliveryAddress.value = null;
    saveAddressForFuture.value = false;
  }

  /// Get delivery address for order
  /// Returns temp address if set (checkout), else saved user address
  Address? getDeliveryAddress(Address? userSavedAddress) {
    return tempDeliveryAddress.value ?? userSavedAddress;
  }
}
