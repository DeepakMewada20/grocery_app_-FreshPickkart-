import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:geolocator/geolocator.dart';
import 'package:freshpickkat_admin/controller/admin_order_controller.dart';
import 'package:freshpickkat_admin/services/admin_notification_navigation_service.dart';
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
  final Map<String, GlobalKey> _orderCardKeys = <String, GlobalKey>{};

  bool _isSearching = false;
  String _searchQuery = '';
  Worker? _orderFocusWorker;
  Timer? _highlightTimer;
  String? _highlightedOrderId;
  bool _handlingOrderFocus = false;

  Color _getStatusColor(String status) {
    return AdminAppTheme.getOrderStatusColor(context, status);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _orderFocusWorker = ever<String?>(
      AdminNotificationNavigationService.instance.focusedOrderId,
      (orderId) {
        if (orderId == null || orderId.isEmpty) return;
        unawaited(_handleOrderFocus(orderId));
      },
    );
    _loadInitial();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderId =
          AdminNotificationNavigationService.instance.focusedOrderId.value;
      if (orderId == null || orderId.isEmpty) return;
      unawaited(_handleOrderFocus(orderId));
    });
  }

  @override
  void dispose() {
    _orderFocusWorker?.dispose();
    _highlightTimer?.cancel();
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

  Future<void> _handleOrderFocus(String orderId) async {
    if (_handlingOrderFocus || !mounted) return;
    _handlingOrderFocus = true;
    try {
      setState(() {
        _isSearching = false;
        _searchQuery = '';
      });

      final messenger = ScaffoldMessenger.of(context);
      final found = await _orderController.loadOrderForFocus(orderId);
      if (!mounted) return;
      if (!found) {
        AdminNotificationNavigationService.instance.markOrderHandled(orderId);
        messenger.showSnackBar(
          SnackBar(
            content: Text('Order $orderId not found.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      await Future<void>.delayed(Duration.zero);
      if (!mounted) return;

      _highlightTimer?.cancel();
      setState(() => _highlightedOrderId = orderId);
      _highlightTimer = Timer(const Duration(seconds: 4), () {
        if (!mounted || _highlightedOrderId != orderId) return;
        setState(() => _highlightedOrderId = null);
      });

      final contextForCard = _orderCardKeys[orderId]?.currentContext;
      if (contextForCard != null && contextForCard.mounted) {
        await Scrollable.ensureVisible(
          contextForCard,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          alignment: 0.18,
        );
      }
      AdminNotificationNavigationService.instance.markOrderHandled(orderId);
    } finally {
      _handlingOrderFocus = false;
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.location_off,
              color: AdminAppTheme.getWarningColor(context),
            ),
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
            ? Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  autofocus: true,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 15.sp.clamp(13.0, 16.0),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Order ID / Customer / Phone',
                    hintStyle: TextStyle(
                      color: AdminAppTheme.getTextSecondaryColor(
                        context,
                      ).withValues(alpha: 0.6),
                      fontSize: 14.sp.clamp(12.0, 15.0),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.sp.clamp(18.0, 22.0),
                      color: AdminAppTheme.getTextSecondaryColor(context),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
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

          // Handle replacement filter
          if (statusFilter == 'replacement') {
            if (o.orderType != 'replacement') return false;
          } else if (statusFilter != 'all') {
            // Handle other status filters
            if (o.status != statusFilter) return false;
          }

          // Search filter
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
                child: _StatusFilterChips(
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
                  color: AdminAppTheme.getSuccessColor(context),
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
                              key: _orderCardKeys.putIfAbsent(
                                order.orderId,
                                () => GlobalKey(),
                              ),
                              order: order,
                              isHighlighted:
                                  order.orderId == _highlightedOrderId,
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
                          color: AdminAppTheme.getBorderColor(context),
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
                              ? AdminAppTheme.getSuccessContainerColor(context)
                              : AdminAppTheme.getWarningContainerColor(context),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.paymentStatus.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: order.paymentStatus == 'paid'
                                ? AdminAppTheme.getSuccessColor(context)
                                : AdminAppTheme.getWarningColor(context),
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
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 58.r,
                                              height: 58.r,
                                              decoration: BoxDecoration(
                                                color:
                                                    AdminAppTheme.getSubtleBorderColor(
                                                      context,
                                                    ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.image_not_supported,
                                                color:
                                                    AdminAppTheme.getMutedIconColor(
                                                      context,
                                                    ),
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
                                                        AdminAppTheme.getWarningContainerColor(
                                                          context,
                                                        ),
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
                                              color:
                                                  AdminAppTheme.getSuccessContainerColor(
                                                    context,
                                                  ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '${item.quantity}x',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AdminAppTheme.getSuccessColor(
                                                      context,
                                                    ),
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
                                      color: AdminAppTheme.getSuccessColor(
                                        context,
                                      ),
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
                  : AdminAppTheme.getTextPrimaryColor(context),
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

class _StatusFilterChips extends StatelessWidget {
  const _StatusFilterChips({
    required this.currentFilter,
    required this.onChanged,
  });

  final String currentFilter;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final filters = [
      ('all', 'All Orders'),
      ('placed', 'Placed'),
      ('confirmed', 'Confirmed'),
      ('packed', 'Packed'),
      ('out_for_delivery', 'Out for delivery'),
      ('delivered', 'Delivered'),
      ('cancelled', 'Cancelled'),
      ('replacement', 'Replacement'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...filters.map((filter) {
            final value = filter.$1;
            final label = filter.$2;
            final isSelected = currentFilter == value;

            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: FilterChip(
                selected: isSelected,
                onSelected: (selected) {
                  onChanged(value);
                },
                label: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp.clamp(10.0, 13.0),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                backgroundColor: AdminAppTheme.getTextSecondaryColor(
                  context,
                ).withValues(alpha: 0.08),
                selectedColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.12),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : AdminAppTheme.getTextSecondaryColor(
                          context,
                        ).withValues(alpha: 0.2),
                  width: 1,
                ),
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : AdminAppTheme.getTextSecondaryColor(context),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  const _OrderCard({
    super.key,
    required this.order,
    required this.isHighlighted,
    required this.onTap,
    required this.onStatusChanged,
    required this.onStartDelivery,
  });

  final Order order;
  final bool isHighlighted;
  final VoidCallback onTap;
  final Future<void> Function(String) onStatusChanged;
  final Future<void> Function(Order order) onStartDelivery;

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final highlightColor = AdminAppTheme.getWarningColor(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: widget.isHighlighted
            ? highlightColor.withValues(alpha: 0.08)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isHighlighted
              ? highlightColor
              : AdminAppTheme.getTextSecondaryColor(
                  context,
                ).withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AdminAppTheme.getScrimShadowColor(context, alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: AdminThemeTokens.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: widget.onTap,
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Order ID, Items, Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            '#${order.orderId}',
                            maxLines: 1,
                            minFontSize: 13,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp.clamp(14.0, 18.0),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${order.itemCount} Items',
                            style: TextStyle(
                              color: AdminAppTheme.getTextSecondaryColor(
                                context,
                              ),
                              fontSize: 12.sp.clamp(10.0, 13.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(child: _buildStatusChip(order.status)),
                  ],
                ),

                SizedBox(height: 12.h),

                // Divider
                Divider(
                  height: 1,
                  color: AdminAppTheme.getTextSecondaryColor(
                    context,
                  ).withValues(alpha: 0.1),
                ),

                SizedBox(height: 12.h),

                // User Info in compact format
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16.sp.clamp(14.0, 18.0),
                      color: AdminAppTheme.getTextSecondaryColor(context),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        order.userName ?? 'N/A',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp.clamp(11.0, 14.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(text: order.userPhone));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Phone number copied'),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 16.sp.clamp(14.0, 18.0),
                            color: AdminAppTheme.getTextSecondaryColor(context),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            order.userPhone,
                            style: TextStyle(
                              fontSize: 12.sp.clamp(10.0, 13.0),
                              color: AdminAppTheme.getTextSecondaryColor(
                                context,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Divider
                Divider(
                  height: 1,
                  color: AdminAppTheme.getTextSecondaryColor(
                    context,
                  ).withValues(alpha: 0.1),
                ),

                SizedBox(height: 12.h),

                // Amount and Replacement
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          AutoSizeText(
                            '₹${order.finalAmount.toStringAsFixed(0)}',
                            maxLines: 1,
                            minFontSize: 14,
                            style: TextStyle(
                              fontSize: 20.sp.clamp(17.0, 22.0),
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          if (order.orderType == 'replacement')
                            Padding(
                              padding: EdgeInsets.only(left: 8.w),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AdminAppTheme.getWarningColor(
                                    context,
                                  ).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Replacement',
                                  style: TextStyle(
                                    color: AdminAppTheme.getWarningColor(
                                      context,
                                    ),
                                    fontSize: 11.sp.clamp(9.0, 12.0),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (order.cancellationReason != null &&
                        order.cancellationReason!.isNotEmpty)
                      Expanded(
                        child: Text(
                          'Cancelled',
                          style: TextStyle(
                            color: AdminAppTheme.getErrorColor(context),
                            fontSize: 12.sp.clamp(10.0, 13.0),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 12.h),
                _buildLifecycleActions(context, order, widget.onStatusChanged),
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
    Future<void> Function(String) onStatusChanged,
  ) {
    final buttons = <Widget>[];
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (order.status == 'placed') {
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Confirm',
          color: primaryColor,
          icon: Icons.verified_outlined,
          isLoading: _isLoading,
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  try {
                    await onStatusChanged('confirmed');
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
        ),
      );
    } else if (order.status == 'confirmed') {
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Mark Packed',
          color: primaryColor,
          icon: Icons.inventory_2_outlined,
          isLoading: _isLoading,
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  try {
                    await onStatusChanged('packed');
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
        ),
      );
    } else if (order.status == 'packed') {
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Start Delivery',
          color: primaryColor,
          icon: Icons.local_shipping_outlined,
          isLoading: _isLoading,
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  try {
                    await widget.onStartDelivery(order);
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
        ),
      );
    } else if (order.status == 'out_for_delivery') {
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Mark Delivered',
          color: primaryColor,
          icon: Icons.check_circle_outline,
          isLoading: _isLoading,
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  try {
                    await onStatusChanged('delivered');
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
        ),
      );
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Track',
          color: primaryColor,
          icon: Icons.map_outlined,
          isLoading: false,
          onPressed: () {
            Get.to(() => LiveDeliveryMapPreviewScreen(order: order));
          },
        ),
      );
    }

    if (buttons.isEmpty) {
      return Text(
        'No further action available',
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
    required bool isLoading,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AdminThemeTokens.white,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: isLoading
          ? SizedBox(
              width: 18.sp,
              height: 18.sp,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AdminThemeTokens.white,
              ),
            )
          : Icon(icon, size: 18.sp.clamp(16.0, 20.0)),
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AdminTextStyles.button(
          context,
        ).copyWith(color: AdminThemeTokens.white),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = AdminAppTheme.getOrderStatusColor(context, status);

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
