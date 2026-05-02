import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshpickkat_admin/controller/admin_order_controller.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_state_view.dart';
import '../widgets/network_error_widget.dart';

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
            'Delivery tracking armed. Push will send after first live location.',
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

        return Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                child: (isLoading && orders.isEmpty) || (filtered.isEmpty && (isLoading || isLoadingMore))
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                        ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  _orderController.statusFilter == 'all' && _searchQuery.isEmpty
                                      ? Icons.shopping_bag_outlined
                                      : Icons.search_off,
                                  size: 64,
                                  color: AdminAppTheme.getBorderColor(context),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _orderController.statusFilter == 'all' && _searchQuery.isEmpty
                                      ? 'No orders yet'
                                      : 'No matching orders',
                                  style: TextStyle(
                                    color: AdminAppTheme.getTextSecondaryColor(
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
                        padding: const EdgeInsets.all(12),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                            filtered.length +
                            (hasMore || isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= filtered.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Order #${order.orderId}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _statusChip(order.status),
                      ],
                    ),
                    const SizedBox(height: 24),
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
                    const SizedBox(height: 20),
                    _DetailSection(
                      title: 'Delivery Address',
                      icon: Icons.location_on_outlined,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
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
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${order.deliveryAddress.city}, ${order.deliveryAddress.state}',
                                style: TextStyle(
                                  color: AdminAppTheme.getTextSecondaryColor(
                                    context,
                                  ),
                                ),
                              ),
                              Text(
                                '${order.deliveryAddress.zipCode}, ${order.deliveryAddress.country}',
                                style: TextStyle(
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
                    const SizedBox(height: 20),
                    _DetailSection(
                      title: 'Payment & Timeline',
                      icon: Icons.payment_outlined,
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
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
                    const SizedBox(height: 24),
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
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
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
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: 60,
                                                  height: 60,
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
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.productName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
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
                                                    fontSize: 12,
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
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
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
                                                      fontSize: 10,
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
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
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
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _calculateTotalQuantity(item),
                                            style: TextStyle(
                                              fontSize: 11,
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
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${item.unitPrice.toStringAsFixed(0)} each',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color:
                                              AdminAppTheme.getTextSecondaryColor(
                                                context,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        '₹${item.totalPrice.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
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
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Coupon (${order.couponApplied})',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          AdminAppTheme.getTextSecondaryColor(
                                            context,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    '-₹${order.discountAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 14,
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
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(),
                          ),
                          _amountRow('Total', order.finalAmount, isBold: true),
                        ],
                      ),
                    ),
                    if (order.deliveryOtp != null ||
                        order.deliveryPersonName != null) ...[
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
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
                            const SizedBox(width: 12),
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
                                  const SizedBox(height: 4),
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
                    const SizedBox(height: 32),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: isBold
                  ? Theme.of(context).colorScheme.onSurface
                  : AdminAppTheme.getTextSecondaryColor(context),
            ),
          ),
          Text(
            value < 0
                ? '-₹${(-value).toStringAsFixed(0)}'
                : '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
      margin: const EdgeInsets.only(bottom: 12),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: Colors.green.shade600,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${order.orderId}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${order.itemCount} Items',
                              style: TextStyle(
                                color: AdminAppTheme.getTextSecondaryColor(
                                  context,
                                ),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _buildStatusChip(order.status),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AdminAppTheme.getTextSecondaryColor(
                      context,
                    ).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 18,
                              color: AdminAppTheme.getTextSecondaryColor(
                                context,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                order.userName ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: AdminAppTheme.getBorderColor(context),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 18,
                            color: AdminAppTheme.getTextSecondaryColor(context),
                          ),
                          const SizedBox(width: 8),
                          Text(order.userPhone),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${order.finalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (order.cancellationReason != null &&
                        order.cancellationReason!.isNotEmpty)
                      Expanded(
                        child: Text(
                          'Cancelled: ${order.cancellationReason}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
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
    }

    if (buttons.isEmpty) {
      return Text(
        'No further lifecycle action available',
        style: TextStyle(
          color: AdminAppTheme.getTextSecondaryColor(context),
          fontSize: 12,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(label),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
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
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AdminAppTheme.getTextSecondaryColor(context),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (trailing != null) ...[const Spacer(), trailing!],
          ],
        ),
        const SizedBox(height: 12),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AdminAppTheme.getTextSecondaryColor(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 15)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: AdminAppTheme.getTextSecondaryColor(context),
                      fontSize: 13,
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
