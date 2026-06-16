import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class PaymentLinkService {
  PaymentLinkService._();

  static PaymentLinkService get instance => Get.isRegistered<PaymentLinkService>()
      ? Get.find<PaymentLinkService>()
      : Get.put(PaymentLinkService._(), permanent: true);

  final _client = ServerpodClient().client;

  /// Create an order with a shareable payment link.
  /// Returns a map with payment link details.
  Future<Map<String, dynamic>> createShareablePaymentLink({
    required Order draftOrder,
    required String idempotencyKey,
    required double amount,
    required String customerPhone,
  }) async {
    try {
      return await _client.paymentLink.createShareablePaymentLink(
        draftOrder,
        idempotencyKey,
        amount,
        customerPhone,
      );
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
