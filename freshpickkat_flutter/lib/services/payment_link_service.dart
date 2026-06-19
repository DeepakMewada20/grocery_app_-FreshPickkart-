import 'dart:convert';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class PaymentLinkService {
  PaymentLinkService._();

  static PaymentLinkService get instance =>
      Get.isRegistered<PaymentLinkService>()
      ? Get.find<PaymentLinkService>()
      : Get.put(PaymentLinkService._(), permanent: true);

  final _client = ServerpodClient().client;

  /// Create an order with a shareable payment link.
  /// Returns [PaymentLinkData] with payment link details.
  Future<PaymentLinkData> createShareablePaymentLink({
    required Order draftOrder,
    required String idempotencyKey,
    required double amount,
    required String customerPhone,
    required String firebaseUid,
    required String idToken,
    String? pendingOrderAction,
  }) async {
    return _client.paymentLink.createShareablePaymentLink(
      draftOrder,
      idempotencyKey,
      amount,
      customerPhone,
      firebaseUid,
      idToken,
      pendingOrderAction: pendingOrderAction,
    );
  }

  /// Get the current payment session status for a pending order.
  Future<Map<String, dynamic>> getPaymentSessionStatus(
    String orderNumber,
  ) async {
    return _client.paymentLink.getPaymentSessionStatus(orderNumber);
  }

  /// Get or create a payment link for a pending order (lazy creation).
  /// Returns a map decoded from the JSON response.
  Future<Map<String, dynamic>> getOrCreatePaymentLink(
    String orderNumber, {
    required String firebaseUid,
    required String idToken,
  }) async {
    final jsonStr = await _client.paymentLink.getOrCreatePaymentLink(
      orderNumber,
      firebaseUid,
      idToken,
    );
    return jsonDecode(jsonStr) as Map<String, dynamic>;
  }
}
