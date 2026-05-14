import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

import '../services/delivery_location_sender_service.dart';

class DeliveryTrackingController extends GetxController {
  DeliveryTrackingController({DeliveryLocationSenderService? service})
    : _service = service ?? DeliveryLocationSenderService();

  final DeliveryLocationSenderService _service;

  final RxBool isActive = false.obs;
  final RxnString activeOrderId = RxnString();
  final RxString statusMessage = ''.obs;

  Future<void> syncOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final normalized = status.toLowerCase().trim();

    if (normalized == 'out_for_delivery') {
      activeOrderId.value = orderId;
      statusMessage.value = 'Sending rider updates';
      isActive.value = true;
      await _service.attachToOrder(
        orderId,
        status: normalized,
        trackingEnabled: true,
      );
      return;
    }

    if (normalized == 'delivered' ||
        normalized == 'cancelled' ||
        normalized == 'packed' ||
        normalized == 'confirmed' ||
        normalized == 'placed') {
      if (activeOrderId.value == orderId) {
        activeOrderId.value = null;
      }
      isActive.value = false;
      statusMessage.value = 'Tracking stopped';
      await _service.stop();
    }
  }

  Future<void> beginActualDelivery({
    required Order order,
    required Future<void> Function() onPromoteToOutForDelivery,
  }) async {
    activeOrderId.value = order.orderId;
    statusMessage.value = 'Waiting for first live location';
    isActive.value = true;
    await _service.attachToOrder(
      order.orderId,
      forceTracking: true,
      status: 'out_for_delivery',
      onFirstPublish: (_) async {
        statusMessage.value = 'Promoting delivery start';
        await onPromoteToOutForDelivery();
      },
    );
  }

  void pauseSender() => _service.pause();

  void resumeSender() => _service.resume();

  Future<void> stop() async {
    isActive.value = false;
    activeOrderId.value = null;
    statusMessage.value = 'Tracking stopped';
    await _service.stop();
  }

  @override
  void onClose() {
    _service.stop();
    super.onClose();
  }
}
