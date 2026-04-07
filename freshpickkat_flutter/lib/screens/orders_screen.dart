import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/services/order_recovery_service.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/order_detail_screen.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final orderController = OrderController.instance;
  final orderRecoveryService = OrderRecoveryService.instance;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await orderRecoveryService.recoverPendingPayments(
        trigger: 'orders_screen_open',
      );
      await orderController.fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderController.errorMessage.isNotEmpty) {
          return Center(child: Text(orderController.errorMessage.value));
        }

        if (orderController.orders.isEmpty) {
          return _buildEmptyState(cs);
        }

        return RefreshIndicator(
          onRefresh: orderController.fetchOrders,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orderController.orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orderController.orders[index];
              return InkWell(
                onTap: () {
                  Get.to(() => OrderDetailScreen(orderId: order.orderId));
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Order ${order.orderId}',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'INR ${order.finalAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: cs.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Placed on ${_formatDate(order.orderedAt)}',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildStatusChip(
                            'Order: ${order.status}',
                            _statusColor(order.status),
                          ),
                          _buildStatusChip(
                            'Payment: ${order.paymentStatus}',
                            _statusColor(order.paymentStatus),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: AppTheme.primaryGreen,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your order history will appear here\nonce you make a purchase.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day-$month-${local.year}';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
      case 'delivered':
        return Colors.green;
      case 'failed':
      case 'cancelled':
        return Colors.redAccent;
      case 'pending':
      case 'confirmed':
      case 'out_for_delivery':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }
}
