import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../models/delivery_location.dart';
import '../models/order_tracking_snapshot.dart';
import '../repositories/server_order_tracking_repository.dart';

class OrderTrackingController extends GetxController {
  OrderTrackingController({
    ServerOrderTrackingRepository? repository,
  }) : _repository = repository ?? ServerOrderTrackingRepository();

  final ServerOrderTrackingRepository _repository;

  final Rxn<OrderTrackingSnapshot> tracking = Rxn<OrderTrackingSnapshot>();
  final Rxn<LatLng> riderPosition = Rxn<LatLng>();
  final Rxn<LatLng> userPosition = Rxn<LatLng>();
  final RxList<LatLng> routePolyline = <LatLng>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isListening = false.obs;
  final RxString error = ''.obs;
  final RxDouble distanceMeters = 0.0.obs;
  final RxDouble etaMinutes = 0.0.obs;
  final RxBool arrivingSoon = false.obs;

  StreamSubscription<OrderTrackingSnapshot?>? _subscription;
  String? _activeOrderId;
  DateTime? _lastRiderUpdateAt;
  final List<double> _speedSamples = <double>[];

  Duration get markerTransitionDuration => const Duration(seconds: 7);

  String get etaDisplayText {
    final minutes = etaMinutes.value;
    if (minutes <= 0) {
      return 'Calculating...';
    }

    final totalSeconds = (minutes * 60).round();
    if (totalSeconds < 60) {
      return '$totalSeconds sec';
    }

    final totalMinutes = totalSeconds ~/ 60;
    final secondsRemainder = totalSeconds % 60;
    if (totalMinutes < 60) {
      return secondsRemainder == 0
          ? '$totalMinutes min'
          : '$totalMinutes min $secondsRemainder sec';
    }

    final hours = totalMinutes ~/ 60;
    final minutesRemainder = totalMinutes % 60;
    return minutesRemainder == 0
        ? '$hours hr'
        : '$hours hr $minutesRemainder min';
  }

  Future<void> startListening({
    required String orderId,
  }) async {
    if (_activeOrderId == orderId && isListening.value) return;
    await stopListening();

    _activeOrderId = orderId;
    isLoading.value = true;
    error.value = '';

    _subscription = _repository
        .streamTracking(orderId)
        .listen(
          _handleSnapshot,
          onError: (Object e, StackTrace st) {
            error.value = e.toString();
            isLoading.value = false;
          },
        );
    isListening.value = true;
  }

  void _handleSnapshot(OrderTrackingSnapshot? snapshot) {
    if (snapshot == null) {
      error.value = 'Tracking data not found.';
      isLoading.value = false;
      return;
    }

    tracking.value = snapshot;
    isLoading.value = false;

    final user = snapshot.userLocation;
    if (user != null) {
      userPosition.value = user.toLatLng();
    }

    final rider = snapshot.riderLocation;
    if (rider != null) {
      final next = rider.toLatLng();
      final previous = riderPosition.value;
      riderPosition.value = next;
      _updateDistanceAndEta(previous, next, user);
      unawaited(_maybeBuildRoute(user, next));
    } else if (snapshot.canTrack == false) {
      distanceMeters.value = 0;
      etaMinutes.value = 0;
      arrivingSoon.value = false;
    }

    if (snapshot.isDelivered) {
      stopListening();
    }
  }

  void _updateDistanceAndEta(
    LatLng? previous,
    LatLng next,
    DeliveryLocation? user,
  ) {
    if (user == null) return;

    final currentDistanceMeters = Geolocator.distanceBetween(
      next.latitude,
      next.longitude,
      user.lat,
      user.lng,
    );
    distanceMeters.value = currentDistanceMeters;
    arrivingSoon.value = currentDistanceMeters <= 200;

    if (previous != null && _lastRiderUpdateAt != null) {
      final elapsedSeconds = DateTime.now()
          .difference(_lastRiderUpdateAt!)
          .inSeconds;
      if (elapsedSeconds > 0) {
        final moved = Geolocator.distanceBetween(
          previous.latitude,
          previous.longitude,
          next.latitude,
          next.longitude,
        );
        _speedSamples.add(moved / elapsedSeconds);
        if (_speedSamples.length > 5) {
          _speedSamples.removeAt(0);
        }
        final speedMps = _estimateSpeedMps();
        final rawEtaMinutes = currentDistanceMeters / speedMps / 60.0;
        etaMinutes.value = etaMinutes.value == 0
            ? rawEtaMinutes
            : (etaMinutes.value * 0.6) + (rawEtaMinutes * 0.4);
      }
    } else if (currentDistanceMeters > 0) {
      etaMinutes.value = currentDistanceMeters / 6.0 / 60.0;
    }

    _lastRiderUpdateAt = DateTime.now();
  }

  double _estimateSpeedMps() {
    if (_speedSamples.isEmpty) {
      return 6.0;
    }

    final sorted = List<double>.from(_speedSamples)..sort();
    final median = sorted[sorted.length ~/ 2];
    return median.clamp(2.5, 12.0).toDouble();
  }

  Future<void> _maybeBuildRoute(DeliveryLocation? user, LatLng rider) async {
    if (user == null || routePolyline.isNotEmpty || _activeOrderId == null) {
      return;
    }

    try {
      // Get actual route from backend with aggressive caching
      final routePoints = await _repository.getDeliveryRoute(
        orderId: _activeOrderId!,
        riderLatitude: rider.latitude,
        riderLongitude: rider.longitude,
        userLatitude: user.lat,
        userLongitude: user.lng,
      );

      // Convert List<List<double>> to List<LatLng>
      final polylinePoints = routePoints
          .map((point) => LatLng(point[0], point[1]))
          .toList();

      routePolyline.assignAll(polylinePoints);
    } catch (e) {
      // Fallback to straight line if route fetch fails
      const segments = 24;
      final points = <LatLng>[];
      for (var i = 0; i <= segments; i++) {
        final t = i / segments;
        points.add(
          LatLng(
            rider.latitude + ((user.lat - rider.latitude) * t),
            rider.longitude + ((user.lng - rider.longitude) * t),
          ),
        );
      }
      routePolyline.assignAll(points);
    }
  }

  Future<void> seedUserLocation({
    required String orderId,
    required DeliveryLocation userLocation,
  }) {
    return _repository.seedOrderTrackingMetadata(
      orderId: orderId,
      status: tracking.value?.status ?? 'placed',
      trackingEnabled: tracking.value?.trackingEnabled ?? false,
      userLocation: userLocation,
    );
  }

  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
    isListening.value = false;
    _activeOrderId = null;
    _lastRiderUpdateAt = null;
    _speedSamples.clear();
  }

  @override
  void onClose() {
    stopListening();
    super.onClose();
  }

  OrderTrackingSnapshot? get currentTracking => tracking.value;

  LatLng? get currentUserMarker => userPosition.value;

  LatLng? get currentRiderMarker => riderPosition.value;

  bool get canTrack => tracking.value?.canTrack ?? false;

  bool get hasArrivingSoonFlag => arrivingSoon.value;

  double get etaMinutesValue => etaMinutes.value;
}
