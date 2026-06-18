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
  }) async {
    return _client.paymentLink.createShareablePaymentLink(
      draftOrder,
      idempotencyKey,
      amount,
      customerPhone,
      firebaseUid,
      idToken,
    );
  }
}
