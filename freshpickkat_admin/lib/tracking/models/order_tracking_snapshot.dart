import 'package:freshpickkat_client/freshpickkat_client.dart' as server;

import 'delivery_location.dart';

class OrderTrackingSnapshot {
  const OrderTrackingSnapshot({
    required this.orderId,
    required this.status,
    required this.trackingEnabled,
    this.userLocation,
    this.riderLocation,
    this.updatedAt,
  });

  final String orderId;
  final String status;
  final bool trackingEnabled;
  final DeliveryLocation? userLocation;
  final TrackingCoordinate? riderLocation;
  final DateTime? updatedAt;

  bool get canTrack => status == 'out_for_delivery' && trackingEnabled;
  bool get isDelivered => status == 'delivered';

  factory OrderTrackingSnapshot.fromServer(server.OrderTrackingData data) {
    return OrderTrackingSnapshot(
      orderId: data.orderId,
      status: data.status,
      trackingEnabled: data.trackingEnabled,
      userLocation: _readDeliveryLocation(data),
      riderLocation: _readTrackingCoordinate(data),
      updatedAt: data.updatedAt,
    );
  }

  static DeliveryLocation? _readDeliveryLocation(
    server.OrderTrackingData data,
  ) {
    final lat = data.userLatitude;
    final lng = data.userLongitude;
    if (lat == null || lng == null) return null;
    return DeliveryLocation(
      lat: lat,
      lng: lng,
      address: data.userAddress ?? '',
      type: data.userLocationType ?? 'saved',
    );
  }

  static TrackingCoordinate? _readTrackingCoordinate(
    server.OrderTrackingData data,
  ) {
    final lat = data.riderLatitude;
    final lng = data.riderLongitude;
    if (lat == null || lng == null) return null;
    return TrackingCoordinate(lat: lat, lng: lng);
  }
}
