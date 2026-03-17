import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _client = ServerpodAdminClient().client;
  static const int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();
  final List<Order> _orders = [];
  String? _nextPageToken;
  int _totalCount = 0;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;
  String _searchQuery = '';
  String _statusFilter = 'all';

  static const _statuses = <String>[
    'pending',
    'confirmed',
    'out_for_delivery',
    'delivered',
    'cancelled',
  ];

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
    setState(() {
      _isLoading = true;
      _isLoadingMore = false;
      _error = null;
      _orders.clear();
      _nextPageToken = null;
      _totalCount = 0;
      _hasMore = true;
    });
    await _loadMore();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    if (!_hasMore) return;

    setState(() {
      if (_orders.isEmpty) {
        _isLoading = true;
      } else {
        _isLoadingMore = true;
      }
    });

    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final page = await _client.order.getOrdersPage(
        firebaseUid: uid,
        idToken: idToken,
        limit: _pageSize,
        pageToken: _nextPageToken,
        status: _statusFilter == 'all' ? null : _statusFilter,
      );

      if (!mounted) return;
      setState(() {
        _orders.addAll(page.orders);
        _nextPageToken = page.nextPageToken;
        _totalCount = page.totalCount;
        _hasMore = page.nextPageToken != null && page.orders.isNotEmpty;
      });
    } catch (e) {
      if (!mounted) return;
      if (_orders.isEmpty) {
        setState(() {
          _error = e.toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load more orders: $e')),
        );
      }
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _updateStatus(Order order, String status) async {
    String? reason;
    if (status == 'cancelled') {
      reason = await _askReason();
      if (reason == null) return;
    }

    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      await _client.order.updateOrderStatus(
        order.orderId,
        status,
        cancellationReason: reason,
        firebaseUid: uid,
        idToken: idToken,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order ${order.orderId} updated to $status')),
      );
      await _loadInitial();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
    }
  }

  Future<String?> _askReason() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancellation reason'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Enter reason'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
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
      appBar: AppBar(
        title: Text(
          _totalCount > 0 ? 'Orders ($_totalCount)' : 'Orders',
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _loadInitial, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading && _orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_error != null && _orders.isEmpty) {
            return Center(child: Text('Failed to load orders\n$_error'));
          }

          if (_orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }

          final filtered = _orders.where((o) {
            if (_statusFilter != 'all' && o.status != _statusFilter) {
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
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search order id / customer / phone',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: DropdownButtonFormField<String>(
                  initialValue: _statusFilter,
                  decoration: const InputDecoration(
                    labelText: 'Filter by status',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(
                      value: 'confirmed',
                      child: Text('Confirmed'),
                    ),
                    DropdownMenuItem(
                      value: 'out_for_delivery',
                      child: Text('Out for delivery'),
                    ),
                    DropdownMenuItem(
                      value: 'delivered',
                      child: Text('Delivered'),
                    ),
                    DropdownMenuItem(
                      value: 'cancelled',
                      child: Text('Cancelled'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _statusFilter = value;
                    });
                    _loadInitial();
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadInitial,
                  child: filtered.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('No matching orders')),
                          ],
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: filtered.length +
                              (_hasMore || _isLoadingMore
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index >= filtered.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final order = filtered[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _showOrderDetails(order),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              order.orderId,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          _statusChip(order.status),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Customer: ${order.userName ?? 'N/A'} (${order.userPhone})',
                                      ),
                                      Text(
                                        'Items: ${order.itemCount}  |  Amount: ₹${order.finalAmount.toStringAsFixed(0)}',
                                      ),
                                      Text('Payment: ${order.paymentStatus}'),
                                      if (order.cancellationReason != null &&
                                          order.cancellationReason!.isNotEmpty)
                                        Text(
                                          'Reason: ${order.cancellationReason}',
                                        ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: double.infinity,
                                        child: DropdownButtonFormField<String>(
                                          initialValue:
                                              _statuses.contains(order.status)
                                              ? order.status
                                              : 'pending',
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Update status',
                                            isDense: true,
                                          ),
                                          items: _statuses
                                              .map(
                                                (s) => DropdownMenuItem(
                                                  value: s,
                                                  child: Text(
                                                    s.replaceAll('_', ' '),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            if (value == null ||
                                                value == order.status) {
                                              return;
                                            }
                                            _updateStatus(order, value);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${order.orderId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Customer: ${order.userName ?? 'N/A'} (${order.userPhone})',
                  ),
                  Text('Status: ${order.status.replaceAll('_', ' ')}'),
                  Text('Payment: ${order.paymentStatus}'),
                  Text('Ordered: ${order.orderedAt}'),
                  const SizedBox(height: 12),
                  const Text(
                    'Delivery Address',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(order.deliveryAddress.street),
                  Text(
                    '${order.deliveryAddress.city}, ${order.deliveryAddress.state}',
                  ),
                  Text(
                    '${order.deliveryAddress.zipCode}, ${order.deliveryAddress.country}',
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Items',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (order.items.isEmpty)
                    const Text('No items available')
                  else
                    ...order.items.map(
                      (item) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(item.productName),
                        subtitle: Text(
                          'Qty: ${item.quantity} x ₹${item.unitPrice.toStringAsFixed(0)}',
                        ),
                        trailing: Text(
                          '₹${item.totalPrice.toStringAsFixed(0)}',
                        ),
                      ),
                    ),
                  const Divider(),
                  _amountRow('Subtotal', order.totalAmount),
                  _amountRow('Discount', -order.discountAmount),
                  _amountRow('Delivery Fee', order.deliveryFee),
                  _amountRow('Final Amount', order.finalAmount, isBold: true),
                  const SizedBox(height: 8),
                  if (order.deliveryOtp != null &&
                      order.deliveryOtp!.isNotEmpty)
                    Text('Delivery OTP: ${order.deliveryOtp}'),
                  if (order.deliveryPersonName != null &&
                      order.deliveryPersonName!.isNotEmpty)
                    Text(
                      'Delivery Partner: ${order.deliveryPersonName} (${order.deliveryPersonPhone ?? ''})',
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _amountRow(String label, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status) {
      case 'confirmed':
        color = Colors.blue;
        break;
      case 'out_for_delivery':
        color = Colors.orange;
        break;
      case 'delivered':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
