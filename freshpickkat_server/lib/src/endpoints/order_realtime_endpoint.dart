import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';
import '../services/realtime_service.dart';

class OrderRealtimeEndpoint extends Endpoint {
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();

  Stream<OrderRealtimeEvent> watchAdminOrders(
    Session session,
    String firebaseUid,
    String idToken,
  ) async* {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    yield* _watchChannel(session, RealtimeService.adminOrdersChannel);
  }

  Stream<OrderRealtimeEvent> watchDashboardUpdates(
    Session session,
    String firebaseUid,
    String idToken,
  ) async* {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    yield* _watchChannel(session, RealtimeService.dashboardUpdatesChannel);
  }

  Stream<OrderRealtimeEvent> watchUserOrders(
    Session session,
    String firebaseUid,
    String idToken,
  ) async* {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final channelName = RealtimeService.userOrdersChannel(
      user.firebaseUid ?? firebaseUid,
    );
    yield* _watchChannel(session, channelName);
  }

  Stream<OrderRealtimeEvent> _watchChannel(
    Session session,
    String channelName,
  ) async* {
    late final void Function(dynamic) listener;
    final controller = StreamController<OrderRealtimeEvent>();
    listener = (event) {
      if (!controller.isClosed && event is OrderRealtimeEvent) {
        controller.add(event);
      }
    };
    session.messages.addListener(channelName, listener);
    try {
      yield* controller.stream;
    } finally {
      session.messages.removeListener(channelName, listener);
      if (!controller.isClosed) {
        await controller.close();
      }
    }
  }
}
