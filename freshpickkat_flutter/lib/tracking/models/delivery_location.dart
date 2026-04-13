import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryLocation {
  const DeliveryLocation({
    required this.lat,
    required this.lng,
    required this.address,
    required this.type,
  });

  final double lat;
  final double lng;
  final String address;
  final String type;

  factory DeliveryLocation.fromMap(Map<String, dynamic> map) {
    return DeliveryLocation(
      lat: (map['lat'] as num?)?.toDouble() ?? 0,
      lng: (map['lng'] as num?)?.toDouble() ?? 0,
      address: map['address']?.toString() ?? '',
      type: map['type']?.toString() ?? 'saved',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
      'type': type,
    };
  }

  LatLng toLatLng() => LatLng(lat, lng);
}

class TrackingCoordinate {
  const TrackingCoordinate({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  factory TrackingCoordinate.fromMap(Map<String, dynamic> map) {
    return TrackingCoordinate(
      lat: (map['lat'] as num?)?.toDouble() ?? 0,
      lng: (map['lng'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  LatLng toLatLng() => LatLng(lat, lng);
}
