import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class RefundService {
  RefundService._();

  static RefundService get instance =>
      Get.isRegistered<RefundService>()
          ? Get.find<RefundService>()
          : Get.put(RefundService._(), permanent: true);

  final _client = ServerpodClient().client;

  Future<RefundRecord> initiateRefund(String orderId) {
    return _client.refund.initiateRefund(orderId);
  }

  Future<RefundRecord?> getRefundStatus(String orderId) {
    return _client.refund.getRefundStatus(orderId);
  }
}
