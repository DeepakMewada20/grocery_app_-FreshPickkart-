import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class OrderService {
  OrderService._();

  static OrderService get instance =>
      Get.isRegistered<OrderService>()
          ? Get.find<OrderService>()
          : Get.put(OrderService._(), permanent: true);

  final _client = ServerpodClient().client;

  Future<String> createPendingOrder(Order order, String idempotencyKey) {
    return _client.order.createPendingOrder(order, idempotencyKey);
  }

  Future<bool> cancelOrder({
    required String orderId,
    required String userId,
    String reason = 'user_cancelled',
  }) {
    return _client.order.cancelOrder(orderId, userId, reason: reason);
  }

  Future<bool> confirmOrder(String orderId) {
    return _client.order.confirmOrder(orderId);
  }
}
