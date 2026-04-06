import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';

class _GroupedOrderItem {
  final OrderItem item;
  final List<OrderItem> freeItems;

  const _GroupedOrderItem({
    required this.item,
    required this.freeItems,
  });
}

class _GroupedOrderCombo {
  final String comboId;
  final String name;
  final String discountType;
  final double discountValue;
  final List<OrderItem> items;

  const _GroupedOrderCombo({
    required this.comboId,
    required this.name,
    required this.discountType,
    required this.discountValue,
    required this.items,
  });

  int get bundleQuantity {
    if (items.isEmpty) return 0;
    final counts =
        items
            .map((item) => item.quantity ~/ (item.comboItemQuantity ?? 1))
            .where((count) => count > 0)
            .toList()
          ..sort();
    return counts.isEmpty ? 0 : counts.first;
  }

  double get originalTotal =>
      items.fold(0, (sum, item) => sum + item.totalPrice);
  double get discountedTotal => applyComboDiscount(
    originalTotal: originalTotal,
    discountType: discountType,
    discountValue: discountType == 'flat'
        ? discountValue * bundleQuantity
        : discountValue,
  );
}

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
              _buildStatusChip(
                'Order: ${order.status}',
                _statusColor(order.status),
              ),
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
    final freeByTrigger = <String, List<OrderItem>>{};
    final regularItems = <OrderItem>[];
    final comboMap = <String, List<OrderItem>>{};

    for (final item in order.items) {
      if (item.comboId != null && item.comboId!.trim().isNotEmpty) {
        comboMap.putIfAbsent(item.comboId!, () => <OrderItem>[]).add(item);
        continue;
      }
      if (item.isFreeItem && item.triggerProductId != null) {
        freeByTrigger
            .putIfAbsent(item.triggerProductId!, () => <OrderItem>[])
            .add(item);
        continue;
      }
      regularItems.add(item);
    }

    final groupedRegular = regularItems
        .map(
          (item) => _GroupedOrderItem(
            item: item,
            freeItems: freeByTrigger[item.productId] ?? const <OrderItem>[],
          ),
        )
        .toList();
    final comboGroups = comboMap.entries.map((entry) {
      final first = entry.value.first;
      return _GroupedOrderCombo(
        comboId: entry.key,
        name: first.comboName ?? 'Combo Offer',
        discountType: first.comboDiscountType ?? 'flat',
        discountValue: first.comboDiscountValue ?? 0,
        items: entry.value,
      );
    }).toList();

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
          ...groupedRegular.map((entry) => _buildOrderRegularItem(entry, cs)),
          ...comboGroups.map((group) => _buildOrderComboGroup(group, cs)),
        ],
      ),
    );
  }

  Widget _buildOrderRegularItem(_GroupedOrderItem entry, ColorScheme cs) {
    final item = entry.item;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${item.productName}${item.variantLabel != null && item.variantLabel!.isNotEmpty ? ' (${item.variantLabel})' : ''} x${item.quantity}',
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
          ...entry.freeItems.map(
            (freeItem) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'FREE: ${freeItem.productName}${freeItem.variantLabel != null && freeItem.variantLabel!.isNotEmpty ? ' (${freeItem.variantLabel})' : ''} x${freeItem.quantity}',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderComboGroup(_GroupedOrderCombo group, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  comboDiscountBadgeText(
                    group.discountType,
                    group.discountValue,
                  ),
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...group.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.productName}${item.variantLabel != null && item.variantLabel!.isNotEmpty ? ' (${item.variantLabel})' : ''} x${item.quantity}',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.75),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'INR ${item.totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.75),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Combo total x${group.bundleQuantity}',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'INR ${group.discountedTotal.formatPrice}',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'INR ${group.originalTotal.formatPrice}',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.45),
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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
          _buildRow(
            'Item Total',
            'INR ${order.totalAmount.toStringAsFixed(0)}',
            cs,
          ),
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
              color: isTotal
                  ? cs.onSurface
                  : cs.onSurface.withValues(alpha: 0.6),
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
