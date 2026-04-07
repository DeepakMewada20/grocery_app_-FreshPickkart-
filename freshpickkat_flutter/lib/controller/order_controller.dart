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

  Future<void> fetchOrders() async {
    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) {
      orders.clear();
      errorMessage.value = 'Login required to view orders.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _orderRecoveryService.recoverPendingPayments(trigger: 'orders_page');
      final result = await _client.order.getUserOrders(user.uid);
      orders.assignAll(result);
    } catch (e) {
      // ignore: avoid_print
      print('Failed to load orders: $e');
      errorMessage.value = 'Failed to load orders: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<Order?> fetchOrderById(String orderId) async {
    try {
      return await _client.order.getOrderById(orderId);
    } catch (_) {
      return null;
    }
  }
}
