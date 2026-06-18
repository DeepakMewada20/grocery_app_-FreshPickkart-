import 'dart:math' as math;

class AppLatLng {
  final double latitude;
  final double longitude;
  const AppLatLng(this.latitude, this.longitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppLatLng &&
          latitude == other.latitude &&
          longitude == other.longitude);

  @override
  int get hashCode => Object.hash(latitude, longitude);

  static double distanceBetween(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371000;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  static double bearingBetween(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLon = _toRadians(lon2 - lon1);
    final y = math.sin(dLon) * math.cos(_toRadians(lat2));
    final x =
        math.cos(_toRadians(lat1)) * math.sin(_toRadians(lat2)) -
        math.sin(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.cos(dLon);
    return (_toDegrees(math.atan2(y, x)) + 360) % 360;
  }

  static double _toRadians(double deg) => deg * (math.pi / 180);
  static double _toDegrees(double rad) => rad * (180 / math.pi);
}
