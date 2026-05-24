import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:freshpickkat_admin/tracking/controllers/delivery_tracking_controller.dart';
import 'package:freshpickkat_admin/tracking/controllers/live_delivery_map_controller.dart';
import 'package:freshpickkat_admin/tracking/models/order_tracking_snapshot.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_state_view.dart';

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
  _LatLngTween? _riderTween;
  double _animatedBearing = 0.0;
  Tween<double>? _bearingTween;
  static const double _bearingOffset = 0.0;
  bool _followRider = true;
  bool _customerViewOnly = false;
  BitmapDescriptor? _scooterIcon;

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

    Get.find<DeliveryTrackingController>().resumeSender();

    _loadScooterIcon();

    Future.microtask(() async {
      await _controller.startListening(orderId: widget.order.orderId);
      if (_controller.currentRiderMarker != null) {
        _animatedRiderPosition = _controller.currentRiderMarker;
      }
    });

    _riderSubscription = _controller.riderPosition.listen((next) {
      if (!mounted || next == null) return;
      final begin = _animatedRiderPosition ?? next;
      _riderTween = _LatLngTween(begin: begin, end: next);

      final newBearing = Geolocator.bearingBetween(
        begin.latitude,
        begin.longitude,
        next.latitude,
        next.longitude,
      );
      _bearingTween = Tween<double>(begin: _animatedBearing, end: newBearing);

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

  Future<void> _loadScooterIcon() async {
    final data = await rootBundle.load(
      'lib/assets/images/delivery_scooter_traking.png',
    );
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 95,
      targetHeight: 95,
    );
    final frame = await codec.getNextFrame();
    final byteData = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
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

  @override
  void dispose() {
    Get.find<DeliveryTrackingController>().pauseSender();
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
    final horizontalInset = AdminResponsive.pageHorizontalPadding(context);

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
          return AdminStateView.error(
            message: _controller.error.value,
            onRetry: () =>
                _controller.startListening(orderId: widget.order.orderId),
          );
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
              top: 12.h,
              left: horizontalInset,
              right: horizontalInset,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AdminResponsive.maxContentWidth,
                  ),
                  child: _buildMapControls(cs),
                ),
              ),
            ),
            Positioned(
              left: horizontalInset,
              right: horizontalInset,
              bottom: AdminResponsive.bottomInset(context),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AdminResponsive.maxDialogWidth,
                    maxHeight: AdminResponsive.mapBottomCardMaxHeight(context),
                  ),
                  child: _buildStatusCard(snapshot, destination, cs),
                ),
              ),
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
        polylineId: const PolylineId('admin_live_route'),
        points: _controller.routePolyline.toList(),
        color: AdminAppTheme.getSuccessColor(context),
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
        padding: EdgeInsets.all(12.r),
        child: Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
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
        ? AdminAppTheme.getSuccessColor(context)
        : snapshot?.isDelivered == true
        ? AdminAppTheme.getBlueGreyColor(context)
        : cs.onSurface;

    return Material(
      elevation: 10,
      color: cs.surface,
      borderRadius: BorderRadius.circular(24),
      shadowColor: AdminAppTheme.getScrimShadowColor(context, alpha: 0.18),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: 42.r,
                  height: 42.r,
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width * 0.58,
                  ),
                  child: Text(
                    liveStatus,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AdminTextStyles.cardTitle(context),
                  ),
                ),
                if (_controller.hasArrivingSoonFlag)
                  _BadgeChip(
                    label: 'Arriving soon',
                    color: AdminAppTheme.getSuccessColor(context),
                  ),
                _BadgeChip(label: sla.label, color: sla.color),
              ],
            ),
            SizedBox(height: 14.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order: ${widget.order.orderId}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    destination == null
                        ? 'Destination: Coordinates not found for this address'
                        : 'Destination: ${widget.order.deliveryAddress.street}${widget.order.deliveryAddress.city.isNotEmpty ? ", ${widget.order.deliveryAddress.city}" : ""}',
                    style: TextStyle(
                      color: AdminAppTheme.getTextSecondaryColor(context),
                      fontSize: 13.sp.clamp(11.0, 15.0),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Distance',
                    value: distance <= 999
                        ? '${distance.toStringAsFixed(0)} m'
                        : '${(distance / 1000).toStringAsFixed(1)} km',
                    icon: Icons.straighten_rounded,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _MetricTile(
                    label: 'ETA',
                    value: etaLabel,
                    icon: Icons.schedule_rounded,
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
      return _BadgeData('Delivered', AdminAppTheme.getSuccessColor(context));
    }
    if (snapshot?.canTrack != true) {
      return _BadgeData('Waiting', AdminAppTheme.getBlueGreyColor(context));
    }
    if (_controller.hasArrivingSoonFlag) {
      return _BadgeData(
        'Arriving soon',
        AdminAppTheme.getSuccessColor(context),
      );
    }
    if (startedAt != null) {
      final elapsedMinutes = DateTime.now().difference(startedAt).inMinutes;
      if (elapsedMinutes >= 25 || eta >= 15 || distance >= 1500) {
        return _BadgeData('Delayed', AdminAppTheme.getErrorColor(context));
      }
      if (elapsedMinutes >= 15 || eta >= 8) {
        return _BadgeData(
          'Watch closely',
          AdminAppTheme.getDeepOrangeColor(context),
        );
      }
    }
    return _BadgeData('On time', AdminAppTheme.getSuccessColor(context));
  }
}

class _LatLngTween extends Tween<LatLng> {
  _LatLngTween({required super.begin, required super.end});

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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12.sp.clamp(10.0, 13.0),
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
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.sp.clamp(16.0, 22.0), color: cs.onSurfaceVariant),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: 12.sp.clamp(10.0, 13.0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: cs.onSurface,
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
