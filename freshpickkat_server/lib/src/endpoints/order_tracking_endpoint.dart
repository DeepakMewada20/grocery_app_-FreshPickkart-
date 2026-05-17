import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/directions_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_order_service.dart';
import '../services/postgres/postgres_order_tracking_service.dart';
import '../services/postgres/postgres_user_guard_service.dart';

class OrderTrackingEndpoint extends Endpoint {
  final PostgresOrderTrackingService _tracking = PostgresOrderTrackingService();
  final PostgresOrderService _orders = PostgresOrderService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresUserGuardService _userGuard = PostgresUserGuardService();
  final DirectionsService _directions = DirectionsService();

  static String _trackingChannel(String orderId) => 'tracking_$orderId';

  Future<void> _postTrackingUpdate(Session session, String orderId) async {
    final data = await _tracking.getTracking(session, orderId);
    if (data != null) {
      await session.messages.postMessage(_trackingChannel(orderId), data);
    }
  }

  Future<OrderTrackingData?> getTrackingForUser(
    Session session,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    await _ensureOrderOwner(
      session,
      orderId: orderId,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _tracking.getTracking(session, orderId);
  }

  Future<OrderTrackingData?> getTrackingForAdmin(
    Session session,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _tracking.getTracking(session, orderId);
  }

  Stream<OrderTrackingData> streamTrackingForUser(
    Session session,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async* {
    await _ensureOrderOwner(
      session,
      orderId: orderId,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    yield* _watchTracking(session, orderId);
  }

  Stream<OrderTrackingData> streamTrackingForAdmin(
    Session session,
    String orderId,
    String firebaseUid,
    String idToken,
  ) async* {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    yield* _watchTracking(session, orderId);
  }

  Stream<OrderTrackingData> _watchTracking(
    Session session,
    String orderId,
  ) async* {
    final channelName = _trackingChannel(orderId);

    // Yield current state first
    final current = await _tracking.getTracking(session, orderId);
    if (current != null) yield current;

    // Then listen for real-time updates
    late final void Function(dynamic) listener;
    final controller = StreamController<OrderTrackingData>();
    listener = (event) {
      if (!controller.isClosed && event is OrderTrackingData) {
        controller.add(event);
      }
    };
    session.messages.addListener(channelName, listener);
    try {
      yield* controller.stream;
    } finally {
      session.messages.removeListener(channelName, listener);
      if (!controller.isClosed) await controller.close();
    }
  }

  Future<OrderTrackingData> seedUserLocation(
    Session session,
    String orderId,
    String firebaseUid,
    String idToken,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
  ) async {
    await _ensureOrderOwner(
      session,
      orderId: orderId,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final result = await _tracking.seedUserLocation(
      session,
      orderNumber: orderId,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      userAddress: userAddress,
      userLocationType: userLocationType,
    );
    await _postTrackingUpdate(session, orderId);
    return result;
  }

  Future<OrderTrackingData> updateTrackingEnabled(
    Session session,
    String orderId,
    bool enabled,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final result = await _tracking.updateTrackingEnabled(
      session,
      orderNumber: orderId,
      enabled: enabled,
    );
    await _postTrackingUpdate(session, orderId);
    return result;
  }

  Future<OrderTrackingData> updateRiderLocation(
    Session session,
    String orderId,
    double riderLatitude,
    double riderLongitude,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final result = await _tracking.updateRiderLocation(
      session,
      orderNumber: orderId,
      riderLatitude: riderLatitude,
      riderLongitude: riderLongitude,
    );
    await _postTrackingUpdate(session, orderId);
    return result;
  }

  Future<List<List<double>>> getDeliveryRoute(
    Session session,
    String orderId,
    double riderLatitude,
    double riderLongitude,
    double userLatitude,
    double userLongitude,
    String firebaseUid,
    String idToken,
  ) async {
    await _ensureRouteAccess(
      session,
      orderId: orderId,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _directions.getDeliveryRoute(
      riderLatitude,
      riderLongitude,
      userLatitude,
      userLongitude,
    );
  }

  Future<void> _ensureRouteAccess(
    Session session, {
    required String orderId,
    required String firebaseUid,
    required String idToken,
  }) async {
    try {
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      return;
    } catch (_) {
      await _ensureOrderOwner(
        session,
        orderId: orderId,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
    }
  }

  Future<void> _ensureOrderOwner(
    Session session, {
    required String orderId,
    required String firebaseUid,
    required String idToken,
  }) async {
    final user = await _userGuard.ensureUser(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final order = await _orders.getOrderById(session, orderId);
    if (order == null) {
      throw Exception('Order not found.');
    }
    final dbUserId = user.id?.toString();
    if (order.userId != firebaseUid && order.userId != dbUserId) {
      throw Exception('Order does not belong to user.');
    }
  }
}
