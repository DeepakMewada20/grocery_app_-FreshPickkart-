import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshpickkat_admin/controller/admin_order_controller.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import '../widgets/admin_app_bar.dart';
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

  static const _statusColors = {
    'placed': Color(0xFFFFA726),
    'packed': Color(0xFF7E57C2),
    'confirmed': Color(0xFF42A5F5),
    'out_for_delivery': Color(0xFFFF7043),
    'delivered': Color(0xFF66BB6A),
    'cancelled': Color(0xFFEF5350),
  };

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

  Future<void> _loadInitial() async {
    await _orderController.loadInitial();
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
          backgroundColor: Colors.red,
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
          backgroundColor: Colors.red,
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
                foregroundColor: Colors.white,
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AdminAppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search order id / customer / phone',
                  hintStyle: TextStyle(color: Colors.white70),
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

        if (isLoading && orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null && orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load orders',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          );
        }

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No orders yet',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 18),
                ),
              ],
            ),
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
              color: Colors.white,
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
                onRefresh: _loadInitial,
                color: Colors.green,
                child: filtered.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No matching orders',
                                  style: TextStyle(color: Colors.grey.shade600),
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

  void _showOrderDetails(Order order) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
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
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
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
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              Text(
                                '${order.deliveryAddress.zipCode}, ${order.deliveryAddress.country}',
                                style: TextStyle(color: Colors.grey.shade600),
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
                          label: 'Ordered on: ${order.orderedAt}',
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
                            style: TextStyle(color: Colors.grey.shade500),
                          )
                        else
                          ...order.items.map(
                            (item) => Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${item.quantity}x',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                      ),
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
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '₹${item.unitPrice.toStringAsFixed(0)} each',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '₹${item.totalPrice.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
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
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _amountRow('Subtotal', order.totalAmount),
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
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.red.shade700,
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
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order.cancellationReason!,
                                    style: TextStyle(
                                      color: Colors.red.shade600,
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
              color: isBold ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          Text(
            value < 0
                ? '-₹${(-value).toStringAsFixed(0)}'
                : '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? Colors.black87 : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = _statusColors[status] ?? Colors.grey;

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
        color: Colors.grey.shade100,
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
        color: Colors.white,
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
                                color: Colors.grey.shade600,
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
                    color: Colors.grey.shade50,
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
                              color: Colors.grey.shade600,
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
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 18,
                            color: Colors.grey.shade600,
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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
                _buildLifecycleActions(order, onStatusChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLifecycleActions(
    Order order,
    ValueChanged<String> onStatusChanged,
  ) {
    final buttons = <Widget>[];

    if (order.status == 'placed') {
      buttons.add(
        _lifecycleButton(
          label: 'Confirm Order',
          color: Colors.blue,
          icon: Icons.verified_outlined,
          onPressed: () => onStatusChanged('confirmed'),
        ),
      );
    } else if (order.status == 'confirmed') {
      buttons.add(
        _lifecycleButton(
          label: 'Mark Packed',
          color: Colors.deepPurple,
          icon: Icons.inventory_2_outlined,
          onPressed: () => onStatusChanged('packed'),
        ),
      );
    } else if (order.status == 'packed') {
      buttons.add(
        _lifecycleButton(
          label: 'Start Delivery',
          color: Colors.orange,
          icon: Icons.local_shipping_outlined,
          onPressed: () => onStartDelivery(order),
        ),
      );
    } else if (order.status == 'out_for_delivery') {
      buttons.add(
        _lifecycleButton(
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
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
      );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: buttons);
  }

  Widget _lifecycleButton({
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
            Icon(icon, size: 20, color: Colors.grey.shade600),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
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
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 15)),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              icon: Icon(Icons.copy, size: 18, color: Colors.grey.shade500),
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
