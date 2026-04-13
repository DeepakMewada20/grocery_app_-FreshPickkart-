import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/tracking/controllers/live_delivery_map_controller.dart';
import 'package:freshpickkat_admin/tracking/models/order_tracking_snapshot.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/admin_app_bar.dart';

class LiveDeliveryMapPreviewScreen extends StatefulWidget {
  const LiveDeliveryMapPreviewScreen({super.key, required this.order});

  final Order order;

  @override
  State<LiveDeliveryMapPreviewScreen> createState() =>
      _LiveDeliveryMapPreviewScreenState();
}

class _LiveDeliveryMapPreviewScreenState
    extends State<LiveDeliveryMapPreviewScreen>
    with TickerProviderStateMixin {
  late final LiveDeliveryMapController _controller;
  late final AnimationController _markerController;
  StreamSubscription<LatLng?>? _riderSubscription;
  GoogleMapController? _mapController;
  LatLng? _animatedRiderPosition;
  LatLngTween? _riderTween;
  bool _followRider = true;
  bool _customerViewOnly = false;

  LatLng? get _destinationMarker {
    final address = widget.order.deliveryAddress;
    if (address.latitude == null || address.longitude == null) return null;
    return LatLng(address.latitude!, address.longitude!);
  }

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      LiveDeliveryMapController(),
      tag: widget.order.orderId,
    );
    _markerController = AnimationController(
      vsync: this,
      duration: _controller.markerTransitionDuration,
    )..addListener(_tickMarkerAnimation);

    Future.microtask(() async {
      await _controller.startListening(orderId: widget.order.orderId);
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
      if (_customerViewOnly) {
        unawaited(_focusCustomerView());
      } else if (_followRider) {
        unawaited(_focusLiveView());
      }
    });
  }

  void _tickMarkerAnimation() {
    final tween = _riderTween;
    if (tween == null) return;
    setState(() {
      _animatedRiderPosition = tween.lerp(_markerController.value);
    });
  }

  Future<void> _focusLiveView() async {
    if (_mapController == null) return;
    final rider = _animatedRiderPosition ?? _controller.currentRiderMarker;
    final user = _controller.currentUserMarker ?? _destinationMarker;
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
        final bounds = LatLngBounds(southwest: southwest, northeast: northeast);
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 80),
        );
        return;
      }
    }

    await _mapController!.animateCamera(CameraUpdate.newLatLng(rider ?? user!));
  }

  Future<void> _focusCustomerView() async {
    if (_mapController == null) return;
    final destination = _destinationMarker ?? _controller.currentUserMarker;
    if (destination == null) return;
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(destination, 16.5),
    );
  }

  Future<void> _recenterMap() async {
    setState(() {
      _customerViewOnly = false;
      _followRider = true;
    });
    await _focusLiveView();
  }

  @override
  void dispose() {
    _riderSubscription?.cancel();
    _markerController.dispose();
    _controller.stopListening();
    Get.delete<LiveDeliveryMapController>(
      tag: widget.order.orderId,
      force: true,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AdminAppBar(
        title: Text('Live Map ${widget.order.orderId}'),
        style: AdminAppBarStyle.surface,
      ),
      body: Obx(() {
        final snapshot = _controller.currentTracking;
        final destination = _destinationMarker;

        if (_controller.isLoading.value && snapshot == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.error.isNotEmpty && snapshot == null) {
          return Center(child: Text(_controller.error.value));
        }

        final initialTarget =
            _controller.currentRiderMarker ??
            destination ??
            const LatLng(20.5937, 78.9629);

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialTarget,
                zoom: 15,
              ),
              markers: _buildMarkers(destination),
              polylines: _buildPolylines(),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (mapController) {
                _mapController = mapController;
                unawaited(_focusLiveView());
              },
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildMapControls(cs),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildStatusCard(snapshot, destination, cs),
            ),
          ],
        );
      }),
    );
  }

  Set<Marker> _buildMarkers(LatLng? destination) {
    final markers = <Marker>{};
    final rider = _animatedRiderPosition ?? _controller.currentRiderMarker;

    if (destination != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          infoWindow: const InfoWindow(title: 'Customer Address'),
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
        polylineId: const PolylineId('admin_live_route'),
        points: _controller.routePolyline.toList(),
        color: Colors.green.shade600,
        width: 5,
      ),
    };
  }

  Widget _buildMapControls(ColorScheme cs) {
    return Material(
      color: cs.surface.withValues(alpha: 0.92),
      elevation: 8,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _recenterMap,
              icon: const Icon(Icons.center_focus_strong),
              label: const Text('Recenter'),
            ),
            FilterChip(
              selected: _followRider,
              label: const Text('Follow rider'),
              onSelected: (selected) {
                setState(() {
                  _customerViewOnly = false;
                  _followRider = selected;
                });
                if (selected) {
                  unawaited(_focusLiveView());
                }
              },
            ),
            FilterChip(
              selected: _customerViewOnly,
              label: const Text('Customer view'),
              onSelected: (selected) {
                setState(() {
                  _customerViewOnly = selected;
                  _followRider = !selected;
                });
                if (selected) {
                  unawaited(_focusCustomerView());
                } else {
                  unawaited(_focusLiveView());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    OrderTrackingSnapshot? snapshot,
    LatLng? destination,
    ColorScheme cs,
  ) {
    final eta = _controller.etaMinutesValue;
    final distance = _controller.distanceMeters.value;
    final startedAt = widget.order.outForDeliveryAt?.toLocal();
    final sla = _buildSlaBadge(snapshot, eta, distance, startedAt);
    final etaLabel = _controller.etaDisplayText;
    final liveStatus = snapshot?.canTrack == true
        ? 'Live tracking active'
        : snapshot?.isDelivered == true
        ? 'Delivered'
        : 'Waiting for live tracking';
    final statusColor = snapshot?.canTrack == true
        ? Colors.green
        : snapshot?.isDelivered == true
        ? Colors.blueGrey
        : cs.onSurface;

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
                    snapshot?.canTrack == true
                        ? Icons.local_shipping_rounded
                        : Icons.info_outline_rounded,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    liveStatus,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                if (_controller.hasArrivingSoonFlag)
                  const SizedBox(width: 8),
                if (_controller.hasArrivingSoonFlag)
                  _BadgeChip(label: 'Arriving soon', color: Colors.green),
                const SizedBox(width: 8),
                _BadgeChip(label: sla.label, color: sla.color),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order: ${widget.order.orderId}',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    destination == null
                        ? 'Destination: not available'
                        : 'Destination: ${widget.order.deliveryAddress.street}, ${widget.order.deliveryAddress.city}',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
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

  _BadgeData _buildSlaBadge(
    OrderTrackingSnapshot? snapshot,
    double eta,
    double distance,
    DateTime? startedAt,
  ) {
    if (snapshot?.isDelivered == true) {
      return const _BadgeData('Delivered', Colors.green);
    }
    if (snapshot?.canTrack != true) {
      return const _BadgeData('Waiting', Colors.blueGrey);
    }
    if (_controller.hasArrivingSoonFlag) {
      return const _BadgeData('Arriving soon', Colors.green);
    }
    if (startedAt != null) {
      final elapsedMinutes = DateTime.now().difference(startedAt).inMinutes;
      if (elapsedMinutes >= 25 || eta >= 15 || distance >= 1500) {
        return const _BadgeData('Delayed', Colors.red);
      }
      if (elapsedMinutes >= 15 || eta >= 8) {
        return const _BadgeData('Watch closely', Colors.deepOrange);
      }
    }
    return const _BadgeData('On time', Colors.green);
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

class _BadgeData {
  const _BadgeData(this.label, this.color);

  final String label;
  final Color color;
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
