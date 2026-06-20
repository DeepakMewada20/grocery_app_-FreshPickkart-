import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env_service.dart';

class CachedRoute {
  final List<double> latitudes;
  final List<double> longitudes;
  final DateTime expiresAt;

  CachedRoute({
    required this.latitudes,
    required this.longitudes,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class DirectionsService {
  final String _apiKey;
  final Map<String, CachedRoute> _routeCache = {};

  static const Duration _cacheDuration = Duration(hours: 1);
  static const int _maxCacheSize = 500;
  static const String _directionsUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  DirectionsService() : _apiKey = _getApiKey();

  static String _getApiKey() {
    final apiKey = EnvService.get('GOOGLE_MAPS_API_KEY');
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GOOGLE_MAPS_API_KEY not found in environment');
    }
    return apiKey;
  }

  String _getCacheKey(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return '${(startLat * 10000).toStringAsFixed(0)},${(startLng * 10000).toStringAsFixed(0)},${(endLat * 10000).toStringAsFixed(0)},${(endLng * 10000).toStringAsFixed(0)}';
  }

  void _cleanExpiredCache() {
    _routeCache.removeWhere((_, cached) => cached.isExpired);
  }

  void _enforceMaxCacheSize() {
    if (_routeCache.length > _maxCacheSize) {
      final keysToRemove = _routeCache.keys
          .take(_routeCache.length - _maxCacheSize)
          .toList();
      for (final key in keysToRemove) {
        _routeCache.remove(key);
      }
    }
  }

  Future<List<List<double>>> getDeliveryRoute(
    double riderLatitude,
    double riderLongitude,
    double userLatitude,
    double userLongitude,
  ) async {
    _cleanExpiredCache();
    final cacheKey = _getCacheKey(
      riderLatitude,
      riderLongitude,
      userLatitude,
      userLongitude,
    );

    if (_routeCache.containsKey(cacheKey)) {
      final cached = _routeCache[cacheKey];
      if (cached != null && !cached.isExpired) {
        return _combineLatLng(cached.latitudes, cached.longitudes);
      }
    }

    final origin = '$riderLatitude,$riderLongitude';
    final destination = '$userLatitude,$userLongitude';

    final response = await http
        .get(
          Uri.parse(_directionsUrl).replace(
            queryParameters: {
              'origin': origin,
              'destination': destination,
              'mode': 'driving',
              'region': 'in',
              'key': _apiKey,
            },
          ),
        )
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw Exception('Directions API timeout'),
        );

    if (response.statusCode != 200) {
      throw Exception('Directions API HTTP ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final status = data['status'] as String?;

    if (status != 'OK') {
      final message = data['error_message'] as String?;
      throw Exception(
        message == null || message.trim().isEmpty
            ? 'Directions API status: $status'
            : 'Directions API status: $status. $message',
      );
    }

    if (data['routes'] is! List || (data['routes'] as List).isEmpty) {
      throw Exception('Directions API returned no routes.');
    }

    final route = (data['routes'] as List).first as Map<String, dynamic>;
    final overviewPolyline =
        route['overview_polyline'] as Map<String, dynamic>?;
    final encodedPoints = overviewPolyline?['points'] as String?;

    if (encodedPoints == null || encodedPoints.isEmpty) {
      throw Exception('Directions API returned no route polyline.');
    }

    final polylinePoints = _decodePolyline(encodedPoints);
    if (polylinePoints.isEmpty) {
      throw Exception('Directions route polyline was empty.');
    }

    final routePoints = polylinePoints
        .map((point) => [point['lat']!, point['lng']!])
        .toList();
    final lats = polylinePoints.map((p) => p['lat']!).toList();
    final lngs = polylinePoints.map((p) => p['lng']!).toList();

    _routeCache[cacheKey] = CachedRoute(
      latitudes: lats,
      longitudes: lngs,
      expiresAt: DateTime.now().add(_cacheDuration),
    );
    _enforceMaxCacheSize();

    return routePoints;
  }

  List<Map<String, double>> _decodePolyline(String encoded) {
    final points = <Map<String, double>>[];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int result = 0, shift = 0, b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      result = 0;
      shift = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add({'lat': lat / 1e5, 'lng': lng / 1e5});
    }
    return points;
  }

  List<List<double>> _combineLatLng(List<double> lats, List<double> lngs) {
    return List.generate(lats.length, (i) => [lats[i], lngs[i]]);
  }

  void clearCache() {
    _routeCache.clear();
  }

  Map<String, dynamic> getCacheStats() {
    _cleanExpiredCache();
    return {'cachedRoutes': _routeCache.length, 'maxSize': _maxCacheSize};
  }
}
