import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory OrderTrackingSnapshot.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return OrderTrackingSnapshot(
      orderId: doc.id,
      status: data['status']?.toString() ?? 'placed',
      trackingEnabled: data['trackingEnabled'] == true,
      userLocation: _readDeliveryLocation(data['userLocation']),
      riderLocation: _readTrackingCoordinate(data['riderLocation']),
      updatedAt: _readTimestamp(data['updatedAt']),
    );
  }

  static DeliveryLocation? _readDeliveryLocation(dynamic value) {
    if (value is Map<String, dynamic>) {
      return DeliveryLocation.fromMap(value);
    }
    if (value is Map) {
      return DeliveryLocation.fromMap(Map<String, dynamic>.from(value));
    }
    return null;
  }

  static TrackingCoordinate? _readTrackingCoordinate(dynamic value) {
    if (value is Map<String, dynamic>) {
      return TrackingCoordinate.fromMap(value);
    }
    if (value is Map) {
      return TrackingCoordinate.fromMap(Map<String, dynamic>.from(value));
    }
    return null;
  }

  static DateTime? _readTimestamp(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
