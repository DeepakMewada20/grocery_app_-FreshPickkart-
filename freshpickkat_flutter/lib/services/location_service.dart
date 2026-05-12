import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:freshpickkat_client/freshpickkat_client.dart';

class LocationService {
  /// Get current device location (GPS)
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied. Please allow location access.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied. Please enable from Settings.');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  /// Reverse geocode coordinates to get address details
  static Future<Address?> reverseGeocodeLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return null;
      }

      final placemark = placemarks.first;

      // Extract address components
      final street =
          _buildStreet(placemark.street, placemark.thoroughfare) ?? 'Unknown';
      final locality = placemark.subLocality ?? placemark.locality ?? '';
      final city = placemark.locality ?? '';
      final state = placemark.administrativeArea ?? '';
      final zipCode = placemark.postalCode ?? '';
      final country = placemark.country ?? '';

      // Build complete street with locality info
      final fullStreet = [
        street.trim(),
        locality.trim(),
      ].where((p) => p.isNotEmpty).join(', ');

      return Address(
        street: fullStreet,
        city: city.trim(),
        state: state.trim(),
        zipCode: zipCode.trim(),
        country: country.trim(),
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      print('Error reverse geocoding: $e');
      return null;
    }
  }

  /// Build street address from placemark components
  static String? _buildStreet(String? street, String? thoroughfare) {
    final parts = <String>[];
    if (thoroughfare != null && thoroughfare.isNotEmpty) {
      parts.add(thoroughfare);
    }
    if (street != null && street.isNotEmpty && street != thoroughfare) {
      parts.add(street);
    }
    return parts.isNotEmpty ? parts.join(', ') : null;
  }

  /// Format address for display
  static String formatAddress(Address address) {
    final parts = <String>[];

    if (address.street.isNotEmpty) parts.add(address.street);
    if (address.city.isNotEmpty) parts.add(address.city);
    if (address.state.isNotEmpty) parts.add(address.state);
    if (address.zipCode.isNotEmpty) parts.add(address.zipCode);

    return parts.join(', ');
  }

  /// Get distance between two coordinates (in meters)
  static Future<double> getDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) async {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
