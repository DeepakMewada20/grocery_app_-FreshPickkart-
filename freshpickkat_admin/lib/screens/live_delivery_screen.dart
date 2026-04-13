import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/live_delivery_controller.dart';
import 'package:freshpickkat_admin/tracking/controllers/delivery_tracking_controller.dart';
import 'package:freshpickkat_admin/tracking/screens/live_delivery_map_preview_screen.dart';
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
        style: AdminAppBarStyle.surface,
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
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeader(theme),
                const SizedBox(height: 16),
                _buildEmptyState(theme),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.loadActiveDeliveries,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              _buildHeader(theme),
              const SizedBox(height: 16),
              _buildTrackingStatusCard(theme),
              const SizedBox(height: 16),
              _buildOrderCard(order, theme),
              const SizedBox(height: 16),
              _buildAddressCard(order, theme),
              const SizedBox(height: 16),
              _buildHintCard(theme),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.delivery_dining, color: Colors.white, size: 34),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active rider order',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This tab only shows orders that are currently out for delivery.',
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
        child: Row(
          children: [
            _ChipLabel(
              label: active ? 'Tracking active' : 'Tracking stopped',
              color: active ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 10),
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
          const SizedBox(height: 14),
          _InfoRow(label: 'Items', value: '${order.itemCount}'),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Delivery person',
            value: order.deliveryPersonName?.isNotEmpty == true
                ? order.deliveryPersonName!
                : 'Not assigned',
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  Get.to(() => LiveDeliveryMapPreviewScreen(order: order)),
              icon: const Icon(Icons.map_outlined),
              label: const Text('Open Live Map'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
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
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (address.latitude != null && address.longitude != null) ...[
            const SizedBox(height: 8),
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
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            Icons.delivery_dining_outlined,
            size: 72,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No active deliveries',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
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
      padding: const EdgeInsets.all(18),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
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
