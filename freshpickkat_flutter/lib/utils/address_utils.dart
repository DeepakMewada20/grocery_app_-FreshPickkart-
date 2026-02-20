import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:flutter/material.dart';

class AddressUtils {
  static final Location _location = Location();

  /// Get current user location and return latitude, longitude
  static Future<({double latitude, double longitude})>
  getCurrentLocation() async {
    // Check if location service is enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }
    }

    // Check permissions
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission denied');
      }
    }

    // Get current location
    LocationData locationData = await _location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      throw Exception('Could not get coordinates');
    }

    return (
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );
  }

  /// Get nearby addresses using reverse geocoding
  static Future<List<geo.Placemark>> getNearbyAddresses(
    double latitude,
    double longitude,
  ) async {
    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        latitude,
        longitude,
      );
      return placemarks.take(6).toList();
    } catch (e) {
      debugPrint('Geocoding error: $e');
      throw Exception('Failed to get nearby addresses');
    }
  }

  /// Format Placemark to readable address string
  static String formatAddress(geo.Placemark placemark) {
    List<String> parts = [];

    if (placemark.street != null && placemark.street!.isNotEmpty) {
      parts.add(placemark.street!);
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      parts.add(placemark.subLocality!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      parts.add(placemark.administrativeArea!);
    }
    if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) {
      parts.add(placemark.postalCode!);
    }

    return parts.join(', ');
  }

  /// Extract street and locality/colony name from Placemark
  static String extractStreetAndColony(geo.Placemark placemark) {
    List<String> parts = [];

    // Add street if present
    if (placemark.street != null &&
        placemark.street!.isNotEmpty &&
        placemark.street != '41') {
      parts.add(placemark.street!);
    }

    // Add subLocality (colony/area name) - this is important!
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      parts.add(placemark.subLocality!);
    }

    // If nothing yet, try locality
    if (parts.isEmpty &&
        placemark.locality != null &&
        placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }

    return parts.isNotEmpty ? parts.join(', ') : 'Address';
  }

  /// Extract address fields from Placemark
  static Map<String, String> extractAddressFields(geo.Placemark placemark) {
    return {
      'street': extractStreetAndColony(placemark),
      'city': placemark.locality ?? '',
      'state': placemark.administrativeArea ?? '',
      'zipCode': placemark.postalCode ?? '',
      'country': placemark.country ?? '',
    };
  }
}
