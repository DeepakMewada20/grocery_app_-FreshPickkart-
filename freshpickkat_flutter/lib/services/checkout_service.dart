import 'dart:math';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/services/order_service.dart';
import 'package:get/get.dart';

class CheckoutService {
  CheckoutService._();

  static CheckoutService get instance => Get.isRegistered<CheckoutService>()
      ? Get.find<CheckoutService>()
      : Get.put(CheckoutService._(), permanent: true);

  final _orderService = OrderService.instance;
  final Random _random = Random.secure();

  String generateIdempotencyKey(String userId) {
    final randomPart = List.generate(
      8,
      (_) => _random.nextInt(36).toRadixString(36),
    ).join();
    return '${userId}_${DateTime.now().microsecondsSinceEpoch}_$randomPart';
  }

  Future<CheckoutResult> createOrderAndPayment({
    required Order draftOrder,
    required double amount,
    required String customerPhone,
    String? idempotencyKey,
    String? pendingOrderAction,
  }) async {
    final key = idempotencyKey ?? generateIdempotencyKey(draftOrder.userId);
    return _orderService.createOrderAndPayment(
      order: draftOrder,
      idempotencyKey: key,
      amount: amount,
      customerPhone: customerPhone,
      pendingOrderAction: pendingOrderAction,
    );
  }
}
