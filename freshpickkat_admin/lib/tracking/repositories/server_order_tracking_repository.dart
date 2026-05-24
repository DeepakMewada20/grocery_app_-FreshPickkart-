import 'dart:async';

import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as server;

import '../models/delivery_location.dart';
import '../models/order_tracking_snapshot.dart';

class ServerOrderTrackingRepository {
  ServerOrderTrackingRepository({
    server.Client? client,
  }) : _client = client ?? ServerpodAdminClient().client;

  final server.Client _client;

  Stream<OrderTrackingSnapshot?> watchOrder(String orderId) async* {
    while (true) {
      final snapshot = await _fetchOrder(orderId);
      yield snapshot;

      if (snapshot == null ||
          snapshot.isDelivered ||
          snapshot.status == 'cancelled') {
        return;
      }
      await Future<void>.delayed(const Duration(seconds: 5));
    }
  }

  Stream<OrderTrackingSnapshot?> streamTracking(String orderId) async* {
    final uid = AdminSessionService.requireUid();
    final idToken = await AdminSessionService.requireIdToken(
      forceRefresh: false,
    );
    await for (final data in _client.orderTracking.streamTrackingForAdmin(
      orderId,
      uid,
      idToken,
    )) {
      yield OrderTrackingSnapshot.fromServer(data);
    }
  }

  Future<OrderTrackingSnapshot?> _fetchOrder(String orderId) async {
    final uid = AdminSessionService.requireUid();
    final idToken = await AdminSessionService.requireIdToken(
      forceRefresh: false,
    );
    final data = await _client.orderTracking.getTrackingForAdmin(
      orderId,
      uid,
      idToken,
    );
    return data == null ? null : OrderTrackingSnapshot.fromServer(data);
  }

  Future<void> updateRiderLocation({
    required String orderId,
    required TrackingCoordinate riderLocation,
  }) async {
    final uid = AdminSessionService.requireUid();
    final idToken = await AdminSessionService.requireIdToken(
      forceRefresh: false,
    );
    await _client.orderTracking.updateRiderLocation(
      orderId,
      riderLocation.lat,
      riderLocation.lng,
      uid,
      idToken,
    );
  }

  Future<List<List<double>>> getDeliveryRoute({
    required String orderId,
    required double riderLatitude,
    required double riderLongitude,
    required double userLatitude,
    required double userLongitude,
  }) async {
    final uid = AdminSessionService.requireUid();
    final idToken = await AdminSessionService.requireIdToken(
      forceRefresh: false,
    );
    return _client.orderTracking.getDeliveryRoute(
      orderId,
      riderLatitude,
      riderLongitude,
      userLatitude,
      userLongitude,
      uid,
      idToken,
    );
  }
}
