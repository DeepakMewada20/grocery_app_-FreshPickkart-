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

  Future<CheckoutResult> createCodOrder({
    required Order order,
    required String idempotencyKey,
    int freshPointsToRedeem = 0,
  }) {
    return _client.checkout.createCodOrder(
      order,
      idempotencyKey,
      freshPointsToRedeem: freshPointsToRedeem,
    );
  }

  Future<CheckoutResult> createOrderAndPayment({
    required Order order,
    required String idempotencyKey,
    required double amount,
    required String customerPhone,
    String? pendingOrderAction,
    int freshPointsToRedeem = 0,
  }) {
    return _client.checkout.createOrderAndPayment(
      order,
      idempotencyKey,
      amount,
      customerPhone,
      pendingOrderAction: pendingOrderAction,
      freshPointsToRedeem: freshPointsToRedeem,
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

  Future<CodPaymentReceipt?> getCodPaymentReceipt(String orderId) async {
    try {
      final auth = AuthController.instance;
      final user = auth.currentUser;
      if (user == null) return null;
      final idToken = await auth.requireIdToken();
      return await _client.order.getUserCodPaymentReceipt(
        orderId: orderId,
        firebaseUid: user.uid,
        idToken: idToken,
      );
    } catch (_) {
      return null;
    }
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
