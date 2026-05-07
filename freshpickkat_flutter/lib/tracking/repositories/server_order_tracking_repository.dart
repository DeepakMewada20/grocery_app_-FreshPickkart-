import 'dart:async';

import 'package:freshpickkat_client/freshpickkat_client.dart' as server;
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';

import '../models/delivery_location.dart';
import '../models/order_tracking_snapshot.dart';

class ServerOrderTrackingRepository {
  ServerOrderTrackingRepository({
    server.Client? client,
    this.pollingInterval = const Duration(seconds: 5),
  }) : _client = client ?? ServerpodClient().client;

  final server.Client _client;
  final Duration pollingInterval;

  Stream<OrderTrackingSnapshot?> watchOrder(String orderId) async* {
    while (true) {
      final snapshot = await fetchOrder(orderId);
      yield snapshot;

      if (snapshot == null || snapshot.isDelivered) return;
      await Future<void>.delayed(pollingInterval);
    }
  }

  Future<OrderTrackingSnapshot?> fetchOrder(String orderId) async {
    final user = AuthController.instance.currentUser;
    if (user == null) {
      throw Exception('Login required.');
    }

    final idToken = await AuthController.instance.requireIdToken();
    final data = await _client.orderTracking.getTrackingForUser(
      orderId,
      user.uid,
      idToken,
    );
    return data == null ? null : OrderTrackingSnapshot.fromServer(data);
  }

  Future<void> seedOrderTrackingMetadata({
    required String orderId,
    required String status,
    required bool trackingEnabled,
    DeliveryLocation? userLocation,
    TrackingCoordinate? riderLocation,
  }) async {
    final user = AuthController.instance.currentUser;
    if (user == null) {
      throw Exception('Login required.');
    }

    final idToken = await AuthController.instance.requireIdToken();
    await _client.orderTracking.seedUserLocation(
      orderId,
      user.uid,
      idToken,
      userLocation?.lat,
      userLocation?.lng,
      userLocation?.address,
      userLocation?.type,
    );
  }
}
