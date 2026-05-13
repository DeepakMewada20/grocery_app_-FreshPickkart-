import 'dart:async';

import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as server;

import '../models/delivery_location.dart';
import '../models/order_tracking_snapshot.dart';

class ServerOrderTrackingRepository {
  ServerOrderTrackingRepository({
    server.Client? client,
    this.pollingInterval = const Duration(seconds: 5),
  }) : _client = client ?? ServerpodAdminClient().client;

  final server.Client _client;
  final Duration pollingInterval;

  Stream<OrderTrackingSnapshot?> watchOrder(String orderId) async* {
    while (true) {
      final snapshot = await fetchOrder(orderId);
      yield snapshot;

      if (snapshot == null ||
          snapshot.isDelivered ||
          snapshot.status == 'cancelled') {
        return;
      }
      await Future<void>.delayed(pollingInterval);
    }
  }

  Future<OrderTrackingSnapshot?> fetchOrder(String orderId) async {
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

  Future<void> updateTrackingEnabled({
    required String orderId,
    required bool enabled,
  }) async {
    final uid = AdminSessionService.requireUid();
    final idToken = await AdminSessionService.requireIdToken(
      forceRefresh: false,
    );
    await _client.orderTracking.updateTrackingEnabled(
      orderId,
      enabled,
      uid,
      idToken,
    );
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
