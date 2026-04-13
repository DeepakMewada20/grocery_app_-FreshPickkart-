import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

import 'admin_order_controller.dart';
import '../core/exceptions.dart';
import '../services/api_client.dart';
import '../services/admin_session_service.dart';
import '../services/serverpod_client.dart';
import '../tracking/controllers/delivery_tracking_controller.dart';
import 'network_controller.dart';

class LiveDeliveryController extends GetxController {
  static LiveDeliveryController get instance =>
      Get.find<LiveDeliveryController>();

  LiveDeliveryController() {
    loadActiveDeliveries();
  }

  final _client = ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'LiveDeliveryController',
  );

  final RxList<Order> activeOrders = <Order>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString(null);

  Order? get activeOrder => activeOrders.isEmpty ? null : activeOrders.first;

  Order? get armedOrder {
    final trackingOrderId = Get.isRegistered<DeliveryTrackingController>()
        ? Get.find<DeliveryTrackingController>().activeOrderId.value
        : null;
    if (trackingOrderId == null || trackingOrderId.isEmpty) return null;

    final adminOrders = Get.isRegistered<AdminOrderController>()
        ? Get.find<AdminOrderController>().orders
        : <Order>[].obs;
    try {
      return adminOrders.firstWhere(
        (order) => order.orderId == trackingOrderId,
      );
    } catch (_) {
      return null;
    }
  }

  Order? get displayOrder => activeOrder ?? armedOrder;

  Future<void> loadActiveDeliveries() async {
    if (isLoading.value) return;

    isLoading.value = true;
    networkController.hideError();
    error.value = null;

    try {
      final page = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: true,
        );
        return await _client.order.getOrdersPage(
          firebaseUid: uid,
          idToken: idToken,
          limit: 20,
          status: 'out_for_delivery',
        );
      });

      activeOrders.assignAll(page.orders);
    } on NoInternetException {
      networkController.showError(onRetry: loadActiveDeliveries);
    } on NetworkException {
      networkController.showError(onRetry: loadActiveDeliveries);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadActiveDeliveries);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
