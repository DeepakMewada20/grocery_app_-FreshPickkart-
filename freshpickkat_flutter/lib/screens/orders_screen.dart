import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/screens/order_detail_screen.dart'
    deferred as order_detail_screen;
import 'package:freshpickkat_flutter/services/order_recovery_service.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:get/get.dart';

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
              bottom: 24.h + MediaQuery.paddingOf(context).bottom,
            ),
            itemCount: orderController.orders.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
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
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16.r),
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
                                  fontSize: 14.sp,
                                ),
                                minFontSize: 10,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            AutoSizeText(
                              'INR ${order.finalAmount.formatPrice}',
                              style: TextStyle(
                                color: cs.onSurface,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                              minFontSize: 10,
                              maxLines: 1,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Placed on ${_formatDate(order.orderedAt)}',
                          style: AppTextStyles.caption(context),
                        ),
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
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
              48.h,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppTheme.primaryGreen,
                  size: 64.r,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'No Orders Yet',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Your order history will appear here\nonce you make a purchase.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: AutoSizeText(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        minFontSize: 9,
        maxLines: 1,
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
