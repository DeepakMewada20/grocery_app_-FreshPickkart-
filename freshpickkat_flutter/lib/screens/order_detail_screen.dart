import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Order? _order;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final order = await OrderController.instance.fetchOrderById(widget.orderId);
    if (mounted) {
      setState(() {
        _order = order;
        _isLoading = false;
        if (order == null) {
          _error = 'Order not found';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: cs.onSurface,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _buildContent(cs),
    );
  }

  Widget _buildContent(ColorScheme cs) {
    final order = _order!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(order, cs),
          const SizedBox(height: 16),
          _buildAddress(order, cs),
          const SizedBox(height: 16),
          _buildItems(order, cs),
          const SizedBox(height: 16),
          _buildTotals(order, cs),
        ],
      ),
    );
  }

  Widget _buildHeader(Order order, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ID: ${order.orderId}',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Placed on ${_formatDate(order.orderedAt)}',
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatusChip('Order: ${order.status}', _statusColor(order.status)),
              const SizedBox(width: 8),
              _buildStatusChip(
                'Payment: ${order.paymentStatus}',
                _statusColor(order.paymentStatus),
              ),
            ],
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

  Widget _buildAddress(Order order, ColorScheme cs) {
    final address = order.deliveryAddress;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Address',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatAddress(address),
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildItems(Order order, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items (${order.itemCount})',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.productName} x${item.quantity}',
                      style: TextStyle(color: cs.onSurface),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'INR ${item.totalPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotals(Order order, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill Summary',
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildRow('Item Total', 'INR ${order.totalAmount.toStringAsFixed(0)}', cs),
          if (order.discountAmount > 0)
            _buildRow(
              'Discount',
              '-INR ${order.discountAmount.toStringAsFixed(0)}',
              cs,
              valueColor: Colors.green,
            ),
          _buildRow(
            'Delivery Fee',
            order.deliveryFee == 0
                ? 'FREE'
                : 'INR ${order.deliveryFee.toStringAsFixed(0)}',
            cs,
            valueColor: order.deliveryFee == 0 ? Colors.green : cs.onSurface,
          ),
          const SizedBox(height: 8),
          Divider(color: cs.outlineVariant),
          _buildRow(
            'Paid',
            'INR ${order.finalAmount.toStringAsFixed(0)}',
            cs,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    ColorScheme cs, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? cs.onSurface : cs.onSurface.withValues(alpha: 0.6),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? cs.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day-$month-${local.year}';
  }

  String _formatAddress(Address address) {
    final parts = [
      address.street,
      address.city,
      address.state,
      address.zipCode,
      address.country,
    ].where((p) => p.trim().isNotEmpty).toList();
    return parts.join(', ');
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
