import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/order_detail_screen.dart'
    deferred as order_detail_screen;
import 'package:freshpickkat_flutter/services/order_recovery_service.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final orderController = OrderController.instance;
  final orderRecoveryService = OrderRecoveryService.instance;
  final networkController = NetworkController.instance;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await orderRecoveryService.recoverPendingPayments(
        trigger: 'orders_screen_open',
      );
      await orderController.fetchOrders();
    });

    ever(networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('orders')) {
          orderController.fetchOrders();
        }
      }
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
            padding: AppResponsive.pagePadding(context).copyWith(
              bottom: ScreenScale.h(24) + MediaQuery.paddingOf(context).bottom,
            ),
            itemCount: orderController.orders.length,
            separatorBuilder: (_, _) => SizedBox(height: ScreenScale.h(12)),
            itemBuilder: (context, index) {
              final order = orderController.orders[index];
              return AppResponsive.constrainContent(
                context: context,
                child: InkWell(
                  onTap: () async {
                    await navigateDeferred(
                      loadLibrary: () => order_detail_screen.loadLibrary(),
                      pageBuilder: () => order_detail_screen.OrderDetailScreen(
                        orderId: order.orderId,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(ScreenScale.r(16)),
                  child: Container(
                    padding: EdgeInsets.all(ScreenScale.w(16)),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(ScreenScale.r(16)),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                'Order ${order.orderId}',
                                style: TextStyle(
                                  color: cs.onSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenScale.sp(14),
                                ),
                                minFontSize: 10,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: ScreenScale.w(8)),
                            AutoSizeText(
                              'INR ${order.finalAmount.formatPrice}',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenScale.sp(14),
                              ),
                              minFontSize: 10,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenScale.h(8)),
                        Text(
                          'Placed on ${_formatDate(order.orderedAt)}',
                          style: AppText.caption(context),
                        ),
                        SizedBox(height: ScreenScale.h(12)),
                        Wrap(
                          spacing: ScreenScale.w(8),
                          runSpacing: ScreenScale.h(8),
                          children: [
                            _buildStatusChip(
                              'Order: ${order.status}',
                              _statusColor(order.status),
                            ),
                            _buildStatusChip(
                              'Payment: ${order.paymentStatus}',
                              _statusColor(order.paymentStatus),
                            ),
                            if (order.paymentMode == 'cod')
                              _buildStatusChip(
                                'COD',
                                Colors.orange,
                              ),
                          ],
                        ),
                      ],
                    ),
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
    return SingleChildScrollView(
      padding: AppResponsive.pagePadding(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.sizeOf(context).height -
              kToolbarHeight -
              MediaQuery.paddingOf(context).vertical -
              ScreenScale.h(48),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(ScreenScale.w(24)),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppTheme.primaryGreen,
                  size: ScreenScale.r(64),
                ),
              ),
              SizedBox(height: ScreenScale.h(24)),
              Text(
                'No Orders Yet',
                style: TextStyle(
                  fontSize: ScreenScale.sp(20),
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: ScreenScale.h(12)),
              Text(
                'Your order history will appear here\nonce you make a purchase.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ScreenScale.sp(15),
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenScale.w(10), vertical: ScreenScale.h(6)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(ScreenScale.r(20)),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: AutoSizeText(
        label,
        style: TextStyle(
          color: color,
          fontSize: ScreenScale.sp(12),
          fontWeight: FontWeight.w600,
        ),
        minFontSize: 9,
        maxLines: 1,
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final utc = DateTime.utc(
      dt.year,
      dt.month,
      dt.day,
      dt.hour,
      dt.minute,
      dt.second,
      dt.millisecond,
      dt.microsecond,
    );
    final local = utc.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day-$month-${local.year}';
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'placed':
        return Colors.orange;
      case 'packed':
        return Colors.deepPurple;
      case 'paid':
      case 'delivered':
        return Colors.green;
      case 'failed':
      case 'cancelled':
        return Colors.redAccent;
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'out_for_delivery':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }
}
