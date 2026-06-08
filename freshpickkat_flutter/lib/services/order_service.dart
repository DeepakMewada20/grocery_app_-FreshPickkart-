import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class OrderService {
  OrderService._();

  static OrderService get instance => Get.isRegistered<OrderService>()
      ? Get.find<OrderService>()
      : Get.put(OrderService._(), permanent: true);

  final _client = ServerpodClient().client;

  Future<CheckoutResult> createOrderAndPayment({
    required Order order,
    required String idempotencyKey,
    required double amount,
    required String customerPhone,
  }) {
    return _client.checkout.createOrderAndPayment(
      order,
      idempotencyKey,
      amount,
      customerPhone,
    );
  }

  Future<PaymentActionResult> cancelOrder({
    required String orderId,
    required String userId,
    String reason = 'user_cancelled',
  }) async {
    final idToken = await AuthController.instance.requireIdToken();
    return _client.order.cancelOrder(
      orderId,
      userId,
      idToken: idToken,
      reason: reason,
    );
  }

  Future<PaymentActionResult> requestCancellation({
    required String orderId,
    required String userId,
    String reason = 'User requested cancellation',
  }) async {
    final idToken = await AuthController.instance.requireIdToken();
    return _client.order.requestCancellation(
      orderId,
      userId,
      idToken: idToken,
      reason: reason,
    );
  }

  Future<Order?> updateDeliveryAddress({
    required String orderId,
    required Address deliveryAddress,
    String? deliveryNote,
  }) async {
    final auth = AuthController.instance;
    final user = auth.currentUser;
    if (user == null) throw Exception(ErrorMessages.loginRequired);
    final idToken = await auth.requireIdToken();
    return _client.order.updateDeliveryAddress(
      orderId,
      deliveryAddress,
      user.uid,
      idToken,
      deliveryNote: deliveryNote,
    );
  }

}
