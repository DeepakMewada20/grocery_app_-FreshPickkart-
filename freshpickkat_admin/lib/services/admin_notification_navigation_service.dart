import 'package:get/get.dart';

class AdminNotificationNavigationService extends GetxService {
  static AdminNotificationNavigationService get instance =>
      Get.find<AdminNotificationNavigationService>();

  final RxnString focusedOrderId = RxnString();

  void focusOrder(String orderId) {
    final normalized = orderId.trim();
    if (normalized.isEmpty) return;
    focusedOrderId.value = normalized;
  }

  void markOrderHandled(String orderId) {
    if (focusedOrderId.value == orderId) {
      focusedOrderId.value = null;
    }
  }
}
