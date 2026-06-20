import 'dart:async';

import 'package:get/get.dart';

import 'package:freshpickkat_admin/model/lat_lng.dart';
import '../models/delivery_location.dart';
import '../models/order_tracking_snapshot.dart';
import '../repositories/server_order_tracking_repository.dart';

class LiveDeliveryMapController extends GetxController {
  LiveDeliveryMapController({ServerOrderTrackingRepository? repository})
    : _repository = repository ?? ServerOrderTrackingRepository();

  final ServerOrderTrackingRepository _repository;

  final Rxn<OrderTrackingSnapshot> tracking = Rxn<OrderTrackingSnapshot>();
  final Rxn<AppLatLng> riderPosition = Rxn<AppLatLng>();
  final Rxn<AppLatLng> userPosition = Rxn<AppLatLng>();
  final RxList<AppLatLng> routePolyline = <AppLatLng>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isListening = false.obs;
  final RxString error = ''.obs;
  final RxDouble distanceMeters = 0.0.obs;
  final RxDouble etaMinutes = 0.0.obs;
  final RxBool arrivingSoon = false.obs;

  StreamSubscription<OrderTrackingSnapshot?>? _subscription;
  String? _activeOrderId;
  DateTime? _lastRiderUpdateAt;
  int _websocketRetryCount = 0;
  static const int _maxWebsocketRetries = 4;
  final List<double> _speedSamples = <double>[];
  Timer? _routeRetryTimer;
  bool _routeRequestInFlight = false;
  bool _routeIsFallback = false;
  int _routeRetryAttempts = 0;
  DeliveryLocation? _latestRouteUser;
  AppLatLng? _latestRouteRider;
  AppLatLng? _routeOrigin;
  Timer? _routeRefreshTimer;
  static const double _routeRefreshDistance = 200.0;
  static const Duration _routeRefreshInterval = Duration(seconds: 20);
  static const List<Duration> _routeRetryDelays = [
    Duration(seconds: 3),
    Duration(seconds: 8),
    Duration(seconds: 15),
    Duration(seconds: 30),
  ];

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

  Future<void> startListening({required String orderId}) async {
    if (_activeOrderId == orderId && isListening.value) return;
    await stopListening();

    _activeOrderId = orderId;
    _websocketRetryCount = 0;
    routePolyline.clear();
    _resetRouteRetryState();
    isLoading.value = true;
    error.value = '';

    _subscription = _repository
        .streamTracking(orderId)
        .listen(
          _handleSnapshot,
          onError: (Object e, StackTrace st) {
            unawaited(_retryWebsocketOrFallback(orderId, e));
          },
          onDone: () {
            if (_activeOrderId != orderId ||
                tracking.value?.isDelivered == true) {
              return;
            }
            unawaited(
              _retryWebsocketOrFallback(orderId, 'WebSocket stream closed.'),
            );
          },
        );
    isListening.value = true;
  }

  Future<void> _retryWebsocketOrFallback(String orderId, Object reason) async {
    if (_activeOrderId != orderId) return;
    _websocketRetryCount++;
    if (_websocketRetryCount <= _maxWebsocketRetries) {
      await Future<void>.delayed(const Duration(seconds: 3));
      if (_activeOrderId != orderId) return;
      await _subscription?.cancel();
      startListening(orderId: orderId);
      return;
    }
    _startPollingFallback(orderId, reason);
  }

  Future<void> _startPollingFallback(String orderId, Object reason) async {
    if (_activeOrderId != orderId) return;

    await _subscription?.cancel();
    if (_activeOrderId != orderId) return;

    _subscription = _repository
        .watchOrder(orderId)
        .listen(
          _handleSnapshot,
          onError: (Object pollErr, StackTrace pollSt) {
            if (_activeOrderId != orderId) return;
            error.value = pollErr.toString();
            isLoading.value = false;
          },
          onDone: () {
            if (_activeOrderId != orderId) return;
            isListening.value = false;
          },
        );
  }

  void _handleSnapshot(OrderTrackingSnapshot? snapshot) {
    if (snapshot == null) {
      error.value = 'Tracking data not found.';
      isLoading.value = false;
      return;
    }

    _websocketRetryCount = 0;
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
      if (previous == null ||
          AppLatLng.distanceBetween(
                previous.latitude,
                previous.longitude,
                next.latitude,
                next.longitude,
              ) >=
              20) {
        riderPosition.value = next;
        _updateDistanceAndEta(previous, next, user);
        unawaited(_maybeBuildRoute(user, next));
      }
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
    AppLatLng? previous,
    AppLatLng next,
    DeliveryLocation? user,
  ) {
    if (user == null) return;

    final currentDistanceMeters = AppLatLng.distanceBetween(
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
        final moved = AppLatLng.distanceBetween(
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

  Future<void> _maybeBuildRoute(
    DeliveryLocation? user,
    AppLatLng rider, {
    bool force = false,
  }) async {
    if (user == null || _activeOrderId == null) {
      return;
    }
    _latestRouteUser = user;
    _latestRouteRider = rider;
    if (_routeRequestInFlight) {
      return;
    }
    if (routePolyline.isNotEmpty && !_routeIsFallback) {
      return;
    }
    if (!force && _routeIsFallback && _routeRetryTimer?.isActive == true) {
      return;
    }

    _routeRetryTimer?.cancel();
    _routeRetryTimer = null;
    _routeRequestInFlight = true;
    final orderId = _activeOrderId!;

    try {
      final routePoints = await _repository.getDeliveryRoute(
        orderId: orderId,
        riderLatitude: rider.latitude,
        riderLongitude: rider.longitude,
        userLatitude: user.lat,
        userLongitude: user.lng,
      );
      if (_activeOrderId != orderId) {
        return;
      }
      if (routePoints.length < 2) {
        throw Exception('Route has too few points.');
      }

      final polylinePoints = routePoints
          .map((point) => AppLatLng(point[0], point[1]))
          .toList();

      routePolyline.assignAll(polylinePoints);
      _routeIsFallback = false;
      _routeRetryAttempts = 0;
      _routeOrigin = rider;
      _startRouteRefreshTimer();
    } catch (e) {
      if (_activeOrderId != orderId) {
        return;
      }
      if (routePolyline.isEmpty || !_routeIsFallback) {
        routePolyline.assignAll(_buildStraightLineRoute(user, rider));
      }
      _routeIsFallback = true;
      _scheduleRouteRetry();
    } finally {
      _routeRequestInFlight = false;
    }
  }

  List<AppLatLng> _buildStraightLineRoute(
    DeliveryLocation user,
    AppLatLng rider,
  ) {
    const segments = 24;
    final points = <AppLatLng>[];
    for (var i = 0; i <= segments; i++) {
      final t = i / segments;
      points.add(
        AppLatLng(
          rider.latitude + ((user.lat - rider.latitude) * t),
          rider.longitude + ((user.lng - rider.longitude) * t),
        ),
      );
    }
    return points;
  }

  void _scheduleRouteRetry() {
    if (_activeOrderId == null) return;
    final index = _routeRetryAttempts >= _routeRetryDelays.length
        ? _routeRetryDelays.length - 1
        : _routeRetryAttempts;
    _routeRetryAttempts += 1;
    _routeRetryTimer?.cancel();
    _routeRetryTimer = Timer(_routeRetryDelays[index], () {
      final user = _latestRouteUser;
      final rider = _latestRouteRider;
      if (user == null || rider == null || _activeOrderId == null) return;
      unawaited(_maybeBuildRoute(user, rider, force: true));
    });
  }

  void _startRouteRefreshTimer() {
    _routeRefreshTimer?.cancel();
    _routeRefreshTimer = Timer(_routeRefreshInterval, () {
      final origin = _routeOrigin;
      final rider = _latestRouteRider;
      if (origin == null || rider == null) return;
      final moved = AppLatLng.distanceBetween(
        origin.latitude,
        origin.longitude,
        rider.latitude,
        rider.longitude,
      );
      if (moved > _routeRefreshDistance) {
        unawaited(_maybeBuildRoute(_latestRouteUser, rider, force: true));
      }
      _startRouteRefreshTimer();
    });
  }

  void _resetRouteRetryState() {
    _routeRetryTimer?.cancel();
    _routeRetryTimer = null;
    _routeRequestInFlight = false;
    _routeIsFallback = false;
    _routeRetryAttempts = 0;
    _latestRouteUser = null;
    _latestRouteRider = null;
    _routeOrigin = null;
    _routeRefreshTimer?.cancel();
    _routeRefreshTimer = null;
  }

  Future<void> stopListening() async {
    await _subscription?.cancel();
    _subscription = null;
    isListening.value = false;
    _activeOrderId = null;
    _lastRiderUpdateAt = null;
    _speedSamples.clear();
    _resetRouteRetryState();
  }

  @override
  void onClose() {
    stopListening();
    super.onClose();
  }

  OrderTrackingSnapshot? get currentTracking => tracking.value;

  AppLatLng? get currentUserMarker => userPosition.value;

  AppLatLng? get currentRiderMarker => riderPosition.value;

  bool get canTrack => tracking.value?.canTrack ?? false;

  bool get hasArrivingSoonFlag => arrivingSoon.value;

  double get etaMinutesValue => etaMinutes.value;
}
