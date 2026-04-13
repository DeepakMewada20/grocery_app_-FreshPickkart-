import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/order_tracking_controller.dart';
import '../models/order_tracking_snapshot.dart';

class OrderTrackingMapScreen extends StatefulWidget {
  const OrderTrackingMapScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<OrderTrackingMapScreen> createState() => _OrderTrackingMapScreenState();
}

class _OrderTrackingMapScreenState extends State<OrderTrackingMapScreen>
    with TickerProviderStateMixin {
  late final OrderTrackingController _controller;
  late final AnimationController _markerController;
  StreamSubscription<LatLng?>? _riderSubscription;
  GoogleMapController? _mapController;
  LatLng? _animatedRiderPosition;
  LatLngTween? _riderTween;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(OrderTrackingController(), tag: widget.orderId);
    _markerController = AnimationController(
      vsync: this,
      duration: _controller.markerTransitionDuration,
    )..addListener(_tickMarkerAnimation);

    Future.microtask(() async {
      await _controller.startListening(orderId: widget.orderId);
      if (_controller.currentRiderMarker != null) {
        _animatedRiderPosition = _controller.currentRiderMarker;
      }
    });

    _riderSubscription = _controller.riderPosition.listen((next) {
      if (!mounted || next == null) return;
      final begin = _animatedRiderPosition ?? next;
      _riderTween = LatLngTween(begin: begin, end: next);
      _markerController
        ..duration = _controller.markerTransitionDuration
        ..forward(from: 0);
      unawaited(_focusCamera());
    });
  }

  void _tickMarkerAnimation() {
    final tween = _riderTween;
    if (tween == null) return;
    setState(() {
      _animatedRiderPosition = tween.lerp(_markerController.value);
    });
  }

  Future<void> _focusCamera() async {
    if (_mapController == null) return;
    final rider = _animatedRiderPosition ?? _controller.currentRiderMarker;
    final user = _controller.currentUserMarker;
    if (rider == null && user == null) return;

    if (rider != null && user != null) {
      final southwest = LatLng(
        rider.latitude < user.latitude ? rider.latitude : user.latitude,
        rider.longitude < user.longitude ? rider.longitude : user.longitude,
      );
      final northeast = LatLng(
        rider.latitude > user.latitude ? rider.latitude : user.latitude,
        rider.longitude > user.longitude ? rider.longitude : user.longitude,
      );

      if (southwest.latitude != northeast.latitude ||
          southwest.longitude != northeast.longitude) {
        final bounds = LatLngBounds(
          southwest: southwest,
          northeast: northeast,
        );
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 80),
        );
        return;
      }
    }

    await _mapController!.animateCamera(
      CameraUpdate.newLatLng(rider ?? user!),
    );
  }

  @override
  void dispose() {
    _riderSubscription?.cancel();
    _markerController.dispose();
    _controller.stopListening();
    Get.delete<OrderTrackingController>(tag: widget.orderId, force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
      ),
      body: Obx(() {
        final snapshot = _controller.currentTracking;
        if (_controller.isLoading.value && snapshot == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.error.isNotEmpty && snapshot == null) {
          return Center(child: Text(_controller.error.value));
        }

        if (snapshot == null) {
          return const Center(child: Text('Tracking unavailable.'));
        }

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    _controller.currentUserMarker ??
                    _controller.currentRiderMarker ??
                    const LatLng(20.5937, 78.9629),
                zoom: 15,
              ),
              markers: _buildMarkers(),
              polylines: _buildPolylines(),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (mapController) {
                _mapController = mapController;
                unawaited(_focusCamera());
              },
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildStatusCard(snapshot, cs),
            ),
          ],
        );
      }),
    );
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};
    final rider = _animatedRiderPosition ?? _controller.currentRiderMarker;
    final user = _controller.currentUserMarker;

    if (user != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: user,
          infoWindow: const InfoWindow(title: 'Delivery Address'),
        ),
      );
    }

    if (rider != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('rider'),
          position: rider,
          infoWindow: const InfoWindow(title: 'Delivery Boy'),
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (_controller.routePolyline.isEmpty) return {};
    return {
      Polyline(
        polylineId: const PolylineId('order_route'),
        points: _controller.routePolyline.toList(),
        color: Colors.green.shade600,
        width: 5,
      ),
    };
  }

  Widget _buildStatusCard(
    OrderTrackingSnapshot snapshot,
    ColorScheme cs,
  ) {
    final distance = _controller.distanceMeters.value;
    final etaLabel = _controller.etaDisplayText;
    final statusColor = snapshot.canTrack
        ? Colors.green
        : snapshot.isDelivered
        ? Colors.blueGrey
        : cs.onSurfaceVariant;
    final statusText = snapshot.canTrack
        ? 'Live tracking active'
        : snapshot.isDelivered
        ? 'Delivered'
        : 'Tracking unavailable';

    return Material(
      elevation: 10,
      color: cs.surface,
      borderRadius: BorderRadius.circular(24),
      shadowColor: Colors.black.withValues(alpha: 0.18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    snapshot.canTrack
                        ? Icons.local_shipping_rounded
                        : Icons.info_outline_rounded,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                if (_controller.hasArrivingSoonFlag)
                  const SizedBox(width: 8),
                if (_controller.hasArrivingSoonFlag)
                  _BadgeChip(
                    label: 'Arriving soon',
                    color: Colors.green,
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Distance',
                    value:
                        distance <= 999
                            ? '${distance.toStringAsFixed(0)} m'
                            : '${(distance / 1000).toStringAsFixed(1)} km',
                    icon: Icons.straighten_rounded,
                    accent: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    label: 'ETA',
                    value: etaLabel,
                    icon: Icons.schedule_rounded,
                    accent: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LatLngTween extends Tween<LatLng> {
  LatLngTween({required super.begin, required super.end});

  @override
  LatLng lerp(double t) {
    final start = begin!;
    final finish = end!;
    return LatLng(
      start.latitude + ((finish.latitude - start.latitude) * t),
      start.longitude + ((finish.longitude - start.longitude) * t),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
