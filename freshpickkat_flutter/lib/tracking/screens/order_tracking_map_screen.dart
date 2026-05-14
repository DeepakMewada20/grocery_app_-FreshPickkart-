import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:geolocator/geolocator.dart';

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
  double _animatedBearing = 0.0;
  Tween<double>? _bearingTween;
  static const double _bearingOffset = 0.0;
  BitmapDescriptor? _scooterIcon;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(OrderTrackingController(), tag: widget.orderId);
    _markerController = AnimationController(
      vsync: this,
      duration: _controller.markerTransitionDuration,
    )..addListener(_tickMarkerAnimation);

    _loadScooterIcon();

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

      final newBearing = Geolocator.bearingBetween(
        begin.latitude, begin.longitude,
        next.latitude, next.longitude,
      );
      _bearingTween = Tween<double>(begin: _animatedBearing, end: newBearing);

      _markerController
        ..duration = _controller.markerTransitionDuration
        ..forward(from: 0);
      unawaited(_focusCamera());
    });
  }

  Future<void> _loadScooterIcon() async {
    final data = await rootBundle.load('lib/assets/images/delivery_scooter_traking.png');
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 95,
      targetHeight: 95,
    );
    final frame = await codec.getNextFrame();
    final byteData = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    _scooterIcon = BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void _tickMarkerAnimation() {
    final posTween = _riderTween;
    final bearTween = _bearingTween;
    if (posTween == null || bearTween == null) return;
    final t = _markerController.value;
    setState(() {
      _animatedRiderPosition = posTween.lerp(t);
      _animatedBearing = _lerpBearing(bearTween.begin!, bearTween.end!, t);
    });
  }

  static double _shortestAngleDelta(double from, double to) {
    double delta = (to - from) % 360;
    if (delta > 180) delta -= 360;
    return delta;
  }

  double _lerpBearing(double from, double to, double t) {
    final delta = _shortestAngleDelta(from, to);
    return (from + delta * t) % 360;
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
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                minimum: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AppResponsive.isLandscape(context) ? 560 : 640,
                  ),
                  child: _buildStatusCard(snapshot, cs),
                ),
              ),
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
          flat: true,
          rotation: _animatedBearing + _bearingOffset,
          icon: _scooterIcon ?? BitmapDescriptor.defaultMarker,
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
      borderRadius: BorderRadius.circular(24.r),
      shadowColor: Colors.black.withValues(alpha: 0.18),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    snapshot.canTrack
                        ? Icons.local_shipping_rounded
                        : Icons.info_outline_rounded,
                    color: statusColor,
                    size: 22.r,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: AutoSizeText(
                    statusText,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                      fontSize: 15.sp,
                    ),
                    minFontSize: 11,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_controller.hasArrivingSoonFlag) SizedBox(width: 8.w),
                if (_controller.hasArrivingSoonFlag)
                  _BadgeChip(
                    label: 'Arriving soon',
                    color: Colors.green,
                  ),
              ],
            ),
            SizedBox(height: 14.h),
            LayoutBuilder(
              builder: (context, constraints) {
                final distanceTile = _MetricTile(
                  label: 'Distance',
                  value: distance <= 999
                      ? '${distance.toStringAsFixed(0)} m'
                      : '${(distance / 1000).toStringAsFixed(1)} km',
                  icon: Icons.straighten_rounded,
                  accent: Colors.indigo,
                );
                final etaTile = _MetricTile(
                  label: 'ETA',
                  value: etaLabel,
                  icon: Icons.schedule_rounded,
                  accent: Colors.deepOrange,
                );
                if (constraints.maxWidth < 330) {
                  return Column(
                    children: [
                      distanceTile,
                      SizedBox(height: 10.h),
                      etaTile,
                    ],
                  );
                }
                return Row(
                  children: [
                    Expanded(child: distanceTile),
                    SizedBox(width: 12.w),
                    Expanded(child: etaTile),
                  ],
                );
              },
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: AutoSizeText(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
        ),
        minFontSize: 9,
        maxLines: 1,
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
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 18.r, color: accent),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                AutoSizeText(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                  minFontSize: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
