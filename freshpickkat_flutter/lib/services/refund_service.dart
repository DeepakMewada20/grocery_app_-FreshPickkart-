import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class RefundService {
  RefundService._();

  static RefundService get instance => Get.isRegistered<RefundService>()
      ? Get.find<RefundService>()
      : Get.put(RefundService._(), permanent: true);

  final _client = ServerpodClient().client;

  Future<RefundRecord?> getRefundStatus(String orderId) async {
    final user = AuthController.instance.currentUser;
    if (user == null) throw Exception('Login required.');
    final idToken = await AuthController.instance.requireIdToken();
    return _client.refund.getRefundStatus(orderId, user.uid, idToken);
  }
}
