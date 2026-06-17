import 'package:freshpickkat_admin/model/lat_lng.dart';

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

  AppLatLng toLatLng() => AppLatLng(lat, lng);
}

class TrackingCoordinate {
  const TrackingCoordinate({required this.lat, required this.lng});

  final double lat;
  final double lng;

  AppLatLng toLatLng() => AppLatLng(lat, lng);
}
