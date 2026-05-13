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
    return _tracking.seedUserLocation(
      session,
      orderNumber: orderId,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      userAddress: userAddress,
      userLocationType: userLocationType,
    );
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
    return _tracking.updateTrackingEnabled(
      session,
      orderNumber: orderId,
      enabled: enabled,
    );
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
    return _tracking.updateRiderLocation(
      session,
      orderNumber: orderId,
      riderLatitude: riderLatitude,
      riderLongitude: riderLongitude,
    );
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
    await _adminGuard.ensureAdminSeller(
      session,
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
