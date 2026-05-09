import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshpickkat_admin/controller/admin_dashboard_controller.dart';
import 'package:freshpickkat_admin/controller/admin_order_controller.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class AdminRealtimeService extends GetxService {
  static AdminRealtimeService get instance => Get.find<AdminRealtimeService>();

  final Client _client = ServerpodAdminClient().client;

  StreamSubscription<OrderRealtimeEvent>? _adminOrdersSubscription;
  StreamSubscription<OrderRealtimeEvent>? _dashboardSubscription;
  String? _activeUid;
  bool _starting = false;
  Timer? _refreshDebounce;

  Future<void> start() async {
    if (_starting) return;
    _starting = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await stop();
        return;
      }

      if (_activeUid == user.uid &&
          _adminOrdersSubscription != null &&
          _dashboardSubscription != null) {
        return;
      }

      await stop();
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      _activeUid = user.uid;
      _adminOrdersSubscription = _client.orderRealtime
          .watchAdminOrders(uid, idToken)
          .listen(_handleEvent, onError: (_) {});
      _dashboardSubscription = _client.orderRealtime
          .watchDashboardUpdates(uid, idToken)
          .listen(_handleEvent, onError: (_) {});
    } finally {
      _starting = false;
    }
  }

  Future<void> stop() async {
    _refreshDebounce?.cancel();
    _refreshDebounce = null;
    await _adminOrdersSubscription?.cancel();
    await _dashboardSubscription?.cancel();
    _adminOrdersSubscription = null;
    _dashboardSubscription = null;
    _activeUid = null;
  }

  void _handleEvent(OrderRealtimeEvent event) {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(const Duration(milliseconds: 250), () {
      unawaited(Get.find<AdminOrderController>().loadInitial(force: true));
      unawaited(Get.find<AdminDashboardController>().loadDashboard());
    });
  }
}
