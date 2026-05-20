import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:freshpickkat_admin/controller/admin_order_controller.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/tracking/screens/live_delivery_map_preview_screen.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_state_view.dart';
import '../widgets/network_error_widget.dart';
import '../tracking/services/delivery_location_sender_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final AdminOrderController _orderController = AdminOrderController.instance;
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  String _searchQuery = '';

  Color _getStatusColor(String status) {
    switch (status) {
      case 'placed':
        return const Color(0xFFFFA726);
      case 'packed':
        return const Color(0xFF7E57C2);
      case 'confirmed':
        return const Color(0xFF42A5F5);
      case 'out_for_delivery':
        return const Color(0xFFFF7043);
      case 'delivered':
        return const Color(0xFF66BB6A);
      case 'cancelled':
        return const Color(0xFFEF5350);
      default:
        return const Color(0xFF999999);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial({bool force = false}) async {
    await _orderController.loadInitial(
      status: _orderController.statusFilter,
      force: force,
    );
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _orderController.loadMore();
    }
  }

  Future<void> _updateStatus(Order order, String status) async {
    String? reason;
    if (status == 'cancelled') {
      reason = await _askReason();
      if (reason == null) return;
    }

    try {
      await _orderController.updateOrderStatus(
        order,
        status,
        cancellationReason: reason,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Order ${order.orderId} updated to ${status.replaceAll('_', ' ')}',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update: $e'),
          backgroundColor: AdminAppTheme.getErrorColor(context),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _startDelivery(Order order) async {
    try {
      await _orderController.startDelivery(order);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Order moved to out for delivery and customer notified.',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      await Get.to(
        () => LiveDeliveryMapPreviewScreen(
          order: order.copyWith(status: 'out_for_delivery'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      if (e is DeliveryLocationUnavailableException) {
        final retry = await _showLocationDialog();
        if (retry && mounted) {
          for (int i = 0; i < 30; i++) {
            await Future.delayed(const Duration(seconds: 1));
            if (!mounted) return;
            if (await Geolocator.isLocationServiceEnabled()) break;
          }
          if (mounted && await Geolocator.isLocationServiceEnabled()) {
            _startDelivery(order);
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start delivery: $e'),
            backgroundColor: AdminAppTheme.getErrorColor(context),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<bool> _showLocationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.location_off, color: Colors.orange),
            SizedBox(width: 10),
            const Text('Location Required'),
          ],
        ),
        content: const Text(
          'Location service is off. Please enable location to start delivery tracking.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(ctx, true);
              await Geolocator.openLocationSettings();
            },
            icon: const Icon(Icons.settings, size: 18),
            label: const Text('Open Settings'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<String?> _askReason() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Cancellation Reason'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter reason',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AdminAppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search order id / customer / phone',
                  hintStyle: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withValues(alpha: 0.7),
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Obx(
                () => Text(
                  _orderController.totalCount.value > 0
                      ? 'Orders (${_orderController.totalCount.value})'
                      : 'Orders',
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_orderController.networkController.hasError.value) {
          return NetworkErrorWidget(
            onRetry: () =>
                _orderController.networkController.retryLastRequest(),
          );
        }

        final orders = _orderController.orders;
        final isLoading = _orderController.isLoading.value;
        final error = _orderController.error.value;
        final hasMore = _orderController.hasMore.value;
        final isLoadingMore = _orderController.isLoadingMore.value;

        if (error != null && orders.isEmpty) {
          return AdminStateView.error(
            message: error,
            onRetry: () => _orderController.loadInitial(force: true),
          );
        }

        final filtered = orders.where((o) {
          final statusFilter = _orderController.statusFilter;
          if (statusFilter != 'all' && o.status != statusFilter) {
            return false;
          }
          final q = _searchQuery.toLowerCase().trim();
          if (q.isEmpty) return true;
          return o.orderId.toLowerCase().contains(q) ||
              (o.userName ?? '').toLowerCase().contains(q) ||
              o.userPhone.toLowerCase().contains(q);
        }).toList();

        return AdminResponsive.constrainContent(
          context: context,
          child: Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: EdgeInsets.fromLTRB(
                  AdminResponsive.pageHorizontalPadding(context),
                  12.h,
                  AdminResponsive.pageHorizontalPadding(context),
                  8.h,
                ),
                child: _StatusFilterDropdown(
                  currentFilter: _orderController.statusFilter,
                  onChanged: (value) {
                    if (value == null) return;
                    _orderController.loadInitial(status: value);
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _loadInitial(force: true),
                  color: Colors.green,
                  child:
                      (isLoading && orders.isEmpty) ||
                          (filtered.isEmpty && (isLoading || isLoadingMore))
                      ? const Center(child: CircularProgressIndicator())
                      : filtered.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: AdminResponsive.pagePadding(context),
                          children: [
                            SizedBox(height: 96.h),
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    _orderController.statusFilter == 'all' &&
                                            _searchQuery.isEmpty
                                        ? Icons.shopping_bag_outlined
                                        : Icons.search_off,
                                    size: 58.sp.clamp(42.0, 64.0),
                                    color: AdminAppTheme.getBorderColor(
                                      context,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    _orderController.statusFilter == 'all' &&
                                            _searchQuery.isEmpty
                                        ? 'No orders yet'
                                        : 'No matching orders',
                                    textAlign: TextAlign.center,
                                    style: AdminTextStyles.body(context).copyWith(
                                      color:
                                          AdminAppTheme.getTextSecondaryColor(
                                            context,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: AdminResponsive.pagePadding(context)
                              .copyWith(
                                bottom: AdminResponsive.bottomInset(context),
                              ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount:
                              filtered.length +
                              (hasMore || isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= filtered.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final order = filtered[index];
                            return _OrderCard(
                              order: order,
                              onTap: () => _showOrderDetails(order),
                              onStatusChanged: (status) =>
                                  _updateStatus(order, status),
                              onStartDelivery: _startDelivery,
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }

  String _calculateTotalQuantity(OrderItem item) {
    if (item.variantLabel == null || item.variantLabel!.isEmpty) {
      return '${item.quantity}x';
    }
    // Extract number from variant label (e.g., "500 gm" -> "500")
    final variantRegex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = variantRegex.firstMatch(item.variantLabel!);

    if (match != null) {
      final variantQuantity = double.parse(match.group(1)!);
      final totalQty = variantQuantity * item.quantity;

      // Extract unit from variant label (e.g., "500 gm" -> "gm")
      final unitMatch = RegExp(r'(\w+)$').firstMatch(item.variantLabel!);
      final unit = unitMatch?.group(1) ?? '';

      // Format the output
      if (totalQty >= 1000 && unit.toLowerCase() == 'gm') {
        return '${(totalQty / 1000).toStringAsFixed(totalQty % 1000 == 0 ? 0 : 1)} kg';
      }

      return '${totalQty.toStringAsFixed(totalQty % 1 == 0 ? 0 : 1)} $unit';
    }

    return '${item.quantity}x';
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: AdminResponsive.bottomSheetConstraints(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final landscape = AdminResponsive.isLandscape(context);
        return DraggableScrollableSheet(
          initialChildSize: landscape ? 0.92 : 0.85,
          minChildSize: landscape ? 0.72 : 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AdminResponsive.isTablet(context) ? 24.w : 16.w,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.only(
                  bottom: AdminResponsive.bottomInset(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 5.h,
                        margin: EdgeInsets.only(bottom: 18.h),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 8.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.sizeOf(context).width - 132.w,
                          ),
                          child: AutoSizeText(
                            'Order #${order.orderId}',
                            maxLines: 2,
                            minFontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            style: AdminTextStyles.screenTitle(context),
                          ),
                        ),
                        _statusChip(order.status),
                      ],
                    ),
                    SizedBox(height: 22.h),
                    _DetailSection(
                      title: 'Customer Info',
                      icon: Icons.person_outline,
                      children: [
                        _DetailRow(
                          icon: Icons.person,
                          label: order.userName ?? 'N/A',
                        ),
                        _DetailRow(
                          icon: Icons.phone,
                          label: order.userPhone,
                          onCopy: () =>
                              _copyToClipboard(order.userPhone, 'Phone'),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    _DetailSection(
                      title: 'Delivery Address',
                      icon: Icons.location_on_outlined,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: AdminResponsive.cardPadding(context),
                          decoration: BoxDecoration(
                            color: AdminAppTheme.getTextSecondaryColor(
                              context,
                            ).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AdminAppTheme.getTextSecondaryColor(
                                context,
                              ).withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.deliveryAddress.street,
                                style: AdminTextStyles.body(context),
                              ),
                              if (order.deliveryAddress.city.isNotEmpty ||
                                  order.deliveryAddress.state.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: Text(
                                    '${order.deliveryAddress.city}${order.deliveryAddress.city.isNotEmpty && order.deliveryAddress.state.isNotEmpty ? ", " : ""}${order.deliveryAddress.state}',
                                    style: AdminTextStyles.caption(context),
                                  ),
                                ),
                              if (order.deliveryAddress.zipCode.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 2.h),
                                  child: Text(
                                    'PIN: ${order.deliveryAddress.zipCode}',
                                    style: AdminTextStyles.caption(context),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    _DetailSection(
                      title: 'Payment & Timeline',
                      icon: Icons.payment_outlined,
                      trailing: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: order.paymentStatus == 'paid'
                              ? Colors.green.shade50
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.paymentStatus.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: order.paymentStatus == 'paid'
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                          ),
                        ),
                      ),
                      children: [
                        _DetailRow(
                          icon: Icons.access_time,
                          label:
                              'Ordered: ${_formatDate(order.orderedAt)} at ${_formatTime(order.orderedAt)}',
                        ),
                        if (order.confirmedAt != null)
                          _DetailRow(
                            icon: Icons.check_circle_outline,
                            label:
                                'Confirmed: ${_formatDate(order.confirmedAt)} at ${_formatTime(order.confirmedAt)}',
                          ),
                        if (order.outForDeliveryAt != null)
                          _DetailRow(
                            icon: Icons.local_shipping_outlined,
                            label:
                                'Out for Delivery: ${_formatDate(order.outForDeliveryAt)} at ${_formatTime(order.outForDeliveryAt)}',
                          ),
                        if (order.deliveredAt != null)
                          _DetailRow(
                            icon: Icons.done_all,
                            label:
                                'Delivered: ${_formatDate(order.deliveredAt)} at ${_formatTime(order.deliveredAt)}',
                          ),
                      ],
                    ),
                    SizedBox(height: 22.h),
                    _DetailSection(
                      title: 'Items (${order.itemCount})',
                      icon: Icons.shopping_bag_outlined,
                      children: [
                        if (order.items.isEmpty)
                          Text(
                            'No items available',
                            style: TextStyle(
                              color: AdminAppTheme.getTextSecondaryColor(
                                context,
                              ),
                            ),
                          )
                        else
                          ...order.items.map(
                            (item) => Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: AdminAppTheme.getTextSecondaryColor(
                                  context,
                                ).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Product Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item.productImage,
                                          width: 58.r,
                                          height: 58.r,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 58.r,
                                                  height: 58.r,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                );
                                              },
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.productName,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp.clamp(
                                                  12.0,
                                                  16.0,
                                                ),
                                              ),
                                            ),
                                            if (item.variantLabel != null &&
                                                item.variantLabel!.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4,
                                                ),
                                                child: Text(
                                                  'Variant: ${item.variantLabel}',
                                                  style: TextStyle(
                                                    fontSize: 12.sp.clamp(
                                                      10.0,
                                                      13.0,
                                                    ),
                                                    color:
                                                        AdminAppTheme.getTextSecondaryColor(
                                                          context,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            if (item.isFreeItem)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4,
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 6.w,
                                                    vertical: 2.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.orange.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'FREE ITEM',
                                                    style: TextStyle(
                                                      fontSize: 10.sp.clamp(
                                                        9.0,
                                                        11.0,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .orange
                                                          .shade700,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${item.quantity}x',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green.shade700,
                                                fontSize: 13.sp.clamp(
                                                  11.0,
                                                  14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            _calculateTotalQuantity(item),
                                            style: TextStyle(
                                              fontSize: 11.sp.clamp(10.0, 12.0),
                                              color:
                                                  AdminAppTheme.getTextSecondaryColor(
                                                    context,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${item.unitPrice.toStringAsFixed(0)} each',
                                        style: TextStyle(
                                          fontSize: 13.sp.clamp(11.0, 14.0),
                                          color:
                                              AdminAppTheme.getTextSecondaryColor(
                                                context,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        '₹${item.totalPrice.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.sp.clamp(13.0, 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      padding: AdminResponsive.cardPadding(context),
                      decoration: BoxDecoration(
                        color: AdminAppTheme.getTextSecondaryColor(
                          context,
                        ).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _amountRow('Subtotal', order.totalAmount),
                          if (order.couponApplied != null &&
                              order.couponApplied!.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Coupon (${order.couponApplied})',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp.clamp(12.0, 15.0),
                                      color:
                                          AdminAppTheme.getTextSecondaryColor(
                                            context,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    '-₹${order.discountAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 14.sp.clamp(12.0, 15.0),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (order.discountAmount > 0 &&
                              (order.couponApplied == null ||
                                  order.couponApplied!.isEmpty))
                            _amountRow('Discount', -order.discountAmount),
                          _amountRow('Delivery Fee', order.deliveryFee),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Divider(),
                          ),
                          _amountRow('Total', order.finalAmount, isBold: true),
                        ],
                      ),
                    ),
                    if (order.deliveryOtp != null ||
                        order.deliveryPersonName != null) ...[
                      SizedBox(height: 18.h),
                      _DetailSection(
                        title: 'Delivery Details',
                        icon: Icons.delivery_dining,
                        children: [
                          if (order.deliveryOtp != null &&
                              order.deliveryOtp!.isNotEmpty)
                            _DetailRow(
                              icon: Icons.pin,
                              label: 'OTP: ${order.deliveryOtp}',
                            ),
                          if (order.deliveryPersonName != null &&
                              order.deliveryPersonName!.isNotEmpty)
                            _DetailRow(
                              icon: Icons.person_pin,
                              label: order.deliveryPersonName!,
                              subtitle: order.deliveryPersonPhone,
                            ),
                        ],
                      ),
                    ],
                    if (order.cancellationReason != null &&
                        order.cancellationReason!.isNotEmpty) ...[
                      SizedBox(height: 18.h),
                      Container(
                        padding: AdminResponsive.cardPadding(context),
                        decoration: BoxDecoration(
                          color: AdminAppTheme.getErrorColor(
                            context,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AdminAppTheme.getErrorColor(
                              context,
                            ).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AdminAppTheme.getErrorColor(context),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cancellation Reason',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AdminAppTheme.getErrorColor(
                                        context,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    order.cancellationReason!,
                                    style: TextStyle(
                                      color: AdminAppTheme.getErrorColor(
                                        context,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 28.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _amountRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isBold
                    ? 16.sp.clamp(14.0, 18.0)
                    : 14.sp.clamp(12.0, 15.0),
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                color: isBold
                    ? Theme.of(context).colorScheme.onSurface
                    : AdminAppTheme.getTextSecondaryColor(context),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            value < 0
                ? '-₹${(-value).toStringAsFixed(0)}'
                : '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isBold
                  ? 18.sp.clamp(16.0, 20.0)
                  : 14.sp.clamp(12.0, 15.0),
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp.clamp(10.0, 13.0),
        ),
      ),
    );
  }
}

class _StatusFilterDropdown extends StatelessWidget {
  const _StatusFilterDropdown({
    required this.currentFilter,
    required this.onChanged,
  });

  final String currentFilter;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AdminAppTheme.getTextSecondaryColor(
          context,
        ).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentFilter,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          borderRadius: BorderRadius.circular(12),
          items: const [
            DropdownMenuItem(value: 'all', child: Text('All Orders')),
            DropdownMenuItem(value: 'placed', child: Text('Placed')),
            DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
            DropdownMenuItem(value: 'packed', child: Text('Packed')),
            DropdownMenuItem(
              value: 'out_for_delivery',
              child: Text('Out for delivery'),
            ),
            DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
            DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.onTap,
    required this.onStatusChanged,
    required this.onStartDelivery,
  });

  final Order order;
  final VoidCallback onTap;
  final ValueChanged<String> onStatusChanged;
  final Future<void> Function(Order order) onStartDelivery;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: AdminResponsive.cardPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.receipt_long,
                              color: Colors.green.shade600,
                              size: 20.sp.clamp(18.0, 22.0),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  '#${order.orderId}',
                                  maxLines: 1,
                                  minFontSize: 11,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp.clamp(14.0, 18.0),
                                  ),
                                ),
                                Text(
                                  '${order.itemCount} Items',
                                  style: TextStyle(
                                    color: AdminAppTheme.getTextSecondaryColor(
                                      context,
                                    ),
                                    fontSize: 13.sp.clamp(11.0, 14.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Flexible(child: _buildStatusChip(order.status)),
                  ],
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AdminAppTheme.getTextSecondaryColor(
                      context,
                    ).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    spacing: 16.w,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 18.sp.clamp(16.0, 20.0),
                            color: AdminAppTheme.getTextSecondaryColor(context),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            order.userName ?? 'N/A',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp.clamp(12.0, 15.0),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onLongPress: () {
                          Clipboard.setData(
                            ClipboardData(text: order.userPhone),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Phone number copied'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 18.sp.clamp(16.0, 20.0),
                              color: AdminAppTheme.getTextSecondaryColor(context),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              order.userPhone,
                              style: TextStyle(
                                fontSize: 14.sp.clamp(12.0, 15.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: AutoSizeText(
                        '₹${order.finalAmount.toStringAsFixed(0)}',
                        maxLines: 1,
                        minFontSize: 14,
                        style: TextStyle(
                          fontSize: 20.sp.clamp(17.0, 22.0),
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (order.cancellationReason != null &&
                        order.cancellationReason!.isNotEmpty)
                      Expanded(
                        child: Text(
                          'Cancelled: ${order.cancellationReason}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.sp.clamp(10.0, 13.0),
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildLifecycleActions(context, order, onStatusChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLifecycleActions(
    BuildContext context,
    Order order,
    ValueChanged<String> onStatusChanged,
  ) {
    final buttons = <Widget>[];

    if (order.status == 'placed') {
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Confirm Order',
          color: Colors.blue,
          icon: Icons.verified_outlined,
          onPressed: () => onStatusChanged('confirmed'),
        ),
      );
    } else if (order.status == 'confirmed') {
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Mark Packed',
          color: Colors.deepPurple,
          icon: Icons.inventory_2_outlined,
          onPressed: () => onStatusChanged('packed'),
        ),
      );
    } else if (order.status == 'packed') {
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Start Delivery',
          color: Colors.orange,
          icon: Icons.local_shipping_outlined,
          onPressed: () => onStartDelivery(order),
        ),
      );
    } else if (order.status == 'out_for_delivery') {
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Mark Delivered',
          color: Colors.green,
          icon: Icons.check_circle_outline,
          onPressed: () => onStatusChanged('delivered'),
        ),
      );
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Track Order',
          color: Colors.blueGrey,
          icon: Icons.map_outlined,
          onPressed: () {
            Get.to(() => LiveDeliveryMapPreviewScreen(order: order));
          },
        ),
      );
    }

    if (buttons.isEmpty) {
      return Text(
        'No further lifecycle action available',
        style: TextStyle(
          color: AdminAppTheme.getTextSecondaryColor(context),
          fontSize: 12.sp.clamp(10.0, 13.0),
        ),
      );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: buttons);
  }

  Widget _lifecycleButton({
    required BuildContext context,
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 18.sp.clamp(16.0, 20.0)),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AdminTextStyles.button(context).copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final colors = {
      'placed': const Color(0xFFFFA726),
      'packed': const Color(0xFF7E57C2),
      'confirmed': const Color(0xFF42A5F5),
      'out_for_delivery': const Color(0xFFFF7043),
      'delivered': const Color(0xFF66BB6A),
      'cancelled': const Color(0xFFEF5350),
    };
    final color = colors[status] ?? Colors.grey;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp.clamp(9.0, 12.0),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.icon,
    required this.children,
    this.trailing,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              icon,
              size: 20.sp.clamp(18.0, 22.0),
              color: AdminAppTheme.getTextSecondaryColor(context),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.72,
              ),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AdminTextStyles.sectionTitle(context),
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
        SizedBox(height: 12.h),
        ...children,
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onCopy,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18.sp.clamp(16.0, 20.0),
            color: AdminAppTheme.getTextSecondaryColor(context),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15.sp.clamp(13.0, 16.0)),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AdminAppTheme.getTextSecondaryColor(context),
                      fontSize: 13.sp.clamp(11.0, 14.0),
                    ),
                  ),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              icon: Icon(
                Icons.copy,
                size: 18,
                color: AdminAppTheme.getTextSecondaryColor(context),
              ),
              onPressed: onCopy,
              tooltip: 'Copy',
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }
}
