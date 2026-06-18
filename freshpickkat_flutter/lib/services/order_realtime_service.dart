import 'dart:async';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class OrderRealtimeService extends GetxService {
  static OrderRealtimeService get instance => Get.find<OrderRealtimeService>();

  final Client _client = ServerpodClient().client;

  StreamSubscription<OrderRealtimeEvent>? _subscription;
  String? _activeUserId;
  bool _starting = false;

  Future<void> startForCurrentUser() async {
    if (_starting) return;
    _starting = true;
    try {
      final auth = AuthController.instance;
      final user = auth.currentUser;
      if (user == null) {
        await stop();
        return;
      }

      if (_activeUserId == user.uid && _subscription != null) {
        return;
      }

      await stop();
      final idToken = await auth.requireIdToken(forceRefresh: false);
      _activeUserId = user.uid;
      _subscription = _client.orderRealtime
          .watchUserOrders(user.uid, idToken)
          .listen(
            _handleEvent,
            onError: (Object error, StackTrace stackTrace) =>
                _subscription = null,
            onDone: () => _subscription = null,
          );
    } finally {
      _starting = false;
    }
  }

  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
    _activeUserId = null;
  }

  void _handleEvent(OrderRealtimeEvent event) {
    unawaited(Get.find<OrderController>().refreshFromRealtime());
    unawaited(Get.find<CartController>().fetchCartPricing());
  }
}
