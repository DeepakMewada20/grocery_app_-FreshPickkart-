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

  LatLng toLatLng() => LatLng(lat, lng);
}

class TrackingCoordinate {
  const TrackingCoordinate({required this.lat, required this.lng});

  final double lat;
  final double lng;

  LatLng toLatLng() => LatLng(lat, lng);
}
