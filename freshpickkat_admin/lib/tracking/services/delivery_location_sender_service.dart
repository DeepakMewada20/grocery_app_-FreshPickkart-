import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../models/delivery_location.dart';
import '../repositories/firestore_order_tracking_repository.dart';

class DeliveryLocationSenderService {
  DeliveryLocationSenderService({FirestoreOrderTrackingRepository? repository})
    : _repository = repository ?? FirestoreOrderTrackingRepository();

  final FirestoreOrderTrackingRepository _repository;
  final Random _random = Random();

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _orderSubscription;
  Timer? _updateTimer;
  String? _activeOrderId;
  TrackingCoordinate? _lastRawPosition;
  DateTime? _lastPublishedAt;
  bool _forceTracking = false;
  bool _firstPublishTriggered = false;
  Future<void> Function(String orderId)? _onFirstPublish;

  bool get isActive => _activeOrderId != null;
  String? get activeOrderId => _activeOrderId;

  Future<void> attachToOrder(
    String orderId, {
    bool forceTracking = false,
    Future<void> Function(String orderId)? onFirstPublish,
  }) async {
    if (_activeOrderId == orderId && _orderSubscription != null) {
      _forceTracking = _forceTracking || forceTracking;
      if (onFirstPublish != null) {
        _onFirstPublish = onFirstPublish;
      }
      return;
    }
    await stop();
    _activeOrderId = orderId;
    _forceTracking = forceTracking;
    _onFirstPublish = onFirstPublish;
    _orderSubscription = _repository
        .orderDoc(orderId)
        .snapshots()
        .listen(_handleOrderSnapshot);
  }

  void _handleOrderSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      stop();
      return;
    }

    final status = data['status']?.toString() ?? 'placed';
    final trackingEnabled = data['trackingEnabled'] == true;

    if (status == 'delivered' || status == 'cancelled') {
      stop();
      return;
    }

    if (_forceTracking || (status == 'out_for_delivery' && trackingEnabled)) {
      _ensureLoop();
    } else {
      _updateTimer?.cancel();
      _updateTimer = null;
    }
  }

  void _ensureLoop() {
    if (_updateTimer?.isActive == true) return;
    _scheduleNextTick();
  }

  void _scheduleNextTick() {
    _updateTimer?.cancel();
    _updateTimer = Timer(Duration(seconds: 5 + _random.nextInt(6)), () {
      _sendCurrentLocation();
    });
  }

  Future<void> _sendCurrentLocation() async {
    if (_activeOrderId == null) return;
    final hasPermission = await _ensurePermission();
    if (!hasPermission) {
      _scheduleNextTick();
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      final candidate = _applyPrivacyOffset(
        position.latitude,
        position.longitude,
      );
      final rawCandidate = TrackingCoordinate(
        lat: position.latitude,
        lng: position.longitude,
      );

      final shouldSend =
          _lastRawPosition == null ||
          _distanceBetween(_lastRawPosition!, rawCandidate) > 20 ||
          _lastPublishedAt == null ||
          DateTime.now().difference(_lastPublishedAt!).inSeconds >= 5;

      if (shouldSend) {
        await _repository.updateRiderLocation(
          orderId: _activeOrderId!,
          riderLocation: candidate,
        );
        _lastRawPosition = rawCandidate;
        _lastPublishedAt = DateTime.now();

        if (!_firstPublishTriggered && _onFirstPublish != null) {
          _firstPublishTriggered = true;
          try {
            await _onFirstPublish!.call(_activeOrderId!);
          } catch (_) {
            _firstPublishTriggered = false;
          }
        }
      }
    } catch (_) {
      // Ignore transient GPS failures and retry on the next tick.
    } finally {
      _scheduleNextTick();
    }
  }

  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  TrackingCoordinate _applyPrivacyOffset(double lat, double lng) {
    final meters = 20 + _random.nextInt(31);
    final angle = _random.nextDouble() * 2 * pi;
    final deltaLat = (meters * cos(angle)) / 111111.0;
    final deltaLng =
        (meters * sin(angle)) /
        (111111.0 * cos(lat * pi / 180).abs().clamp(0.2, 1.0));
    return TrackingCoordinate(lat: lat + deltaLat, lng: lng + deltaLng);
  }

  double _distanceBetween(TrackingCoordinate start, TrackingCoordinate end) {
    return Geolocator.distanceBetween(start.lat, start.lng, end.lat, end.lng);
  }

  Future<void> stop() async {
    _updateTimer?.cancel();
    _updateTimer = null;
    await _orderSubscription?.cancel();
    _orderSubscription = null;
    _activeOrderId = null;
    _lastRawPosition = null;
    _lastPublishedAt = null;
    _forceTracking = false;
    _firstPublishTriggered = false;
    _onFirstPublish = null;
  }
}
