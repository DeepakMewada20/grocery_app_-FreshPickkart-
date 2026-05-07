import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/live_delivery_controller.dart';
import 'package:freshpickkat_admin/tracking/controllers/delivery_tracking_controller.dart';
import 'package:freshpickkat_admin/tracking/screens/live_delivery_map_preview_screen.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/network_error_widget.dart';

class LiveDeliveryScreen extends StatefulWidget {
  const LiveDeliveryScreen({super.key});

  @override
  State<LiveDeliveryScreen> createState() => _LiveDeliveryScreenState();
}

class _LiveDeliveryScreenState extends State<LiveDeliveryScreen> {
  final LiveDeliveryController _controller = LiveDeliveryController.instance;
  final DeliveryTrackingController _trackingController =
      Get.find<DeliveryTrackingController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AdminAppBar(
        title: const Text('Live Delivery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.loadActiveDeliveries(),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.networkController.hasError.value) {
          return NetworkErrorWidget(
            onRetry: () => _controller.networkController.retryLastRequest(),
          );
        }

        if (_controller.isLoading.value && _controller.activeOrders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = _controller.displayOrder;
        if (order == null) {
          return RefreshIndicator(
            onRefresh: _controller.loadActiveDeliveries,
            child: AdminResponsive.constrainContent(
              context: context,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AdminResponsive.pagePadding(context),
                children: [
                  _buildHeader(theme),
                  SizedBox(height: 16.h),
                  _buildEmptyState(theme),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.loadActiveDeliveries,
          child: AdminResponsive.constrainContent(
            context: context,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AdminResponsive.pagePadding(
                context,
              ).copyWith(bottom: AdminResponsive.bottomInset(context)),
              children: [
                _buildHeader(theme),
                SizedBox(height: 16.h),
                _buildTrackingStatusCard(theme),
                SizedBox(height: 16.h),
                _buildOrderCard(order, theme),
                SizedBox(height: 16.h),
                _buildAddressCard(order, theme),
                SizedBox(height: 16.h),
                _buildHintCard(theme),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: AdminResponsive.cardPadding(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.delivery_dining,
            color: Colors.white,
            size: 34.sp.clamp(28.0, 38.0),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active rider order',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AdminTextStyles.sectionTitle(
                    context,
                  ).copyWith(color: Colors.white),
                ),
                SizedBox(height: 4.h),
                Text(
                  'This tab only shows orders that are currently out for delivery.',
                  maxLines: AdminResponsive.isLandscape(context) ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStatusCard(ThemeData theme) {
    return Obx(() {
      final active = _trackingController.isActive.value;
      final message = _trackingController.statusMessage.value.isEmpty
          ? (active ? 'Sending rider updates' : 'Tracking idle')
          : _trackingController.statusMessage.value;

      return _SectionCard(
        title: 'Sender status',
        subtitle: message,
        icon: active ? Icons.sensors : Icons.sensors_off,
        iconColor: active ? Colors.green : Colors.grey,
        child: Wrap(
          spacing: 10.w,
          runSpacing: 8.h,
          children: [
            _ChipLabel(
              label: active ? 'Tracking active' : 'Tracking stopped',
              color: active ? Colors.green : Colors.grey,
            ),
            if (_trackingController.activeOrderId.value != null)
              _ChipLabel(
                label: 'Order ${_trackingController.activeOrderId.value}',
                color: Colors.blueGrey,
              ),
          ],
        ),
      );
    });
  }

  Widget _buildOrderCard(Order order, ThemeData theme) {
    final trackingOrderId = _trackingController.activeOrderId.value;
    final isArmedButNotLive =
        trackingOrderId == order.orderId && order.status != 'out_for_delivery';
    final sla = _buildSlaBadge(order, isArmedButNotLive);

    return _SectionCard(
      title: 'Order ${order.orderId}',
      subtitle: order.userName?.isNotEmpty == true
          ? order.userName!
          : order.userPhone,
      icon: Icons.receipt_long,
      iconColor: Colors.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ChipLabel(
                label: order.status.replaceAll('_', ' ').toUpperCase(),
                color: Colors.deepOrange,
              ),
              _ChipLabel(
                label: order.paymentStatus.replaceAll('_', ' ').toUpperCase(),
                color: Colors.indigo,
              ),
              _ChipLabel(
                label: '₹${order.finalAmount.toStringAsFixed(0)}',
                color: Colors.green,
              ),
              _ChipLabel(label: sla.label, color: sla.color),
              if (isArmedButNotLive)
                _ChipLabel(
                  label: 'Awaiting first live location',
                  color: Colors.orange,
                ),
            ],
          ),
          SizedBox(height: 14.h),
          _InfoRow(label: 'Items', value: '${order.itemCount}'),
          SizedBox(height: 8.h),
          _InfoRow(
            label: 'Delivery person',
            value: order.deliveryPersonName?.isNotEmpty == true
                ? order.deliveryPersonName!
                : 'Not assigned',
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  Get.to(() => LiveDeliveryMapPreviewScreen(order: order)),
              icon: const Icon(Icons.map_outlined),
              label: const Text(
                'Open Live Map',
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _SlaBadgeData _buildSlaBadge(Order order, bool armedButNotLive) {
    if (armedButNotLive) {
      return const _SlaBadgeData('Awaiting start', Colors.orange);
    }

    final startedAt = order.outForDeliveryAt?.toLocal();
    if (startedAt == null) {
      return const _SlaBadgeData('SLA pending', Colors.blueGrey);
    }

    final elapsedMinutes = DateTime.now().difference(startedAt).inMinutes;
    if (elapsedMinutes >= 25) {
      return const _SlaBadgeData('Delayed', Colors.red);
    }
    if (elapsedMinutes >= 15) {
      return const _SlaBadgeData('Watch closely', Colors.deepOrange);
    }
    return const _SlaBadgeData('On time', Colors.green);
  }

  Widget _buildAddressCard(Order order, ThemeData theme) {
    final address = order.deliveryAddress;
    final addressText =
        '${address.street}, ${address.city}, ${address.state} ${address.zipCode}, ${address.country}';

    return _SectionCard(
      title: 'Drop location',
      subtitle: 'Customer delivery address',
      icon: Icons.location_on,
      iconColor: Colors.redAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            addressText,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (address.latitude != null && address.longitude != null) ...[
            SizedBox(height: 8.h),
            Text(
              'Lat: ${address.latitude!.toStringAsFixed(6)}, Lng: ${address.longitude!.toStringAsFixed(6)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHintCard(ThemeData theme) {
    return _SectionCard(
      title: 'How it works',
      subtitle: 'Live tracking is optimized for low API usage',
      icon: Icons.info_outline,
      iconColor: Colors.blueGrey,
      child: Text(
        'Open the customer map only when needed. Tracking starts automatically once the order is marked out for delivery and stops as soon as it is delivered.',
        maxLines: AdminResponsive.isLandscape(context) ? 3 : null,
        overflow: AdminResponsive.isLandscape(context)
            ? TextOverflow.ellipsis
            : null,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: AdminResponsive.cardPadding(context),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            Icons.delivery_dining_outlined,
            size: 66.sp.clamp(48.0, 72.0),
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No active deliveries',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Move an order to out_for_delivery from the Orders tab to start rider tracking.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlaBadgeData {
  const _SlaBadgeData(this.label, this.color);

  final String label;
  final Color color;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AdminResponsive.cardPadding(context),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AdminTextStyles.sectionTitle(
                        context,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 360;
        final labelText = Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
        final valueText = Text(
          value,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelText,
              SizedBox(height: 2.h),
              valueText,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 116.w.clamp(92.0, 128.0), child: labelText),
            Expanded(child: valueText),
          ],
        );
      },
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
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
