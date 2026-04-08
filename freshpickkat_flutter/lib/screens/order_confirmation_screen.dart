import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/screens/order_detail_screen.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/widgets/payment_status_widget.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String orderId;

  const OrderConfirmationScreen({super.key, required this.orderId});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _checkAnimation;
  late Animation<double> _fadeAnimation;

  Order? _order;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.4, curve: Curves.easeOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
    _fetchOrder();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchOrder() async {
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

  void _navigateToOrderDetails() {
    Get.to(() => OrderDetailScreen(orderId: widget.orderId));
  }

  void _continueShopping() {
    Get.offAllNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => _continueShopping(),
      child: Scaffold(
        backgroundColor: cs.surface,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSuccessHeader(cs),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.15),
                            end: Offset.zero,
                          ).animate(_fadeAnimation),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                if (_order?.paymentStatus != 'paid' &&
                                    _order?.razorpayPaymentId != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: PaymentStatusWidget(
                                      orderId: _order!.orderId,
                                      paymentId: _order!.razorpayPaymentId!,
                                      amount: _order!.finalAmount,
                                      onSuccess: () {
                                        _fetchOrder();
                                      },
                                      onFailed: () {
                                        _fetchOrder();
                                      },
                                    ),
                                  ),
                                _buildOrderInfoCard(cs),
                                const SizedBox(height: 16),
                                _buildProductsCard(cs),
                                const SizedBox(height: 16),
                                _buildDeliveryAddressCard(cs),
                                const SizedBox(height: 16),
                                _buildTotalAmountCard(cs),
                                const SizedBox(height: 24),
                                _buildViewDetailsButton(cs),
                                const SizedBox(height: 12),
                                _buildContinueShoppingButton(cs),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSuccessHeader(ColorScheme cs) {
    final isPaid = _order?.paymentStatus == 'paid';
    final headerColor = isPaid ? Colors.green : Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40, bottom: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            headerColor.shade500,
            headerColor.shade600,
          ],
        ),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _checkAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(80, 80),
                painter: CheckPainter(progress: _checkAnimation.value),
              );
            },
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: _fadeAnimation,
            child: const Text(
              'Order Placed Successfully!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              _order?.paymentStatus == 'paid'
                  ? 'Payment Successful'
                  : 'Payment Pending',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard(ColorScheme cs) {
    final order = _order!;
    final estimatedDelivery = order.orderedAt.add(const Duration(days: 3));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.receipt_long_outlined,
            label: 'Order ID',
            value: order.orderId,
            cs: cs,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Order Date',
            value: _formatDate(order.orderedAt),
            cs: cs,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.local_shipping_outlined,
            label: 'Estimated Delivery',
            value: _formatDate(estimatedDelivery),
            cs: cs,
            valueColor: Colors.green.shade700,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.info_outline,
            label: 'Status',
            value: order.status.toUpperCase(),
            cs: cs,
            valueColor: _statusColor(order.status),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme cs,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: cs.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsCard(ColorScheme cs) {
    final order = _order!;
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
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined, size: 20, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                'Ordered Products (${order.itemCount})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...groupedRegular.map((entry) => _buildOrderItem(entry, cs)),
          ...comboGroups.map((group) => _buildOrderComboGroup(group, cs)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(_GroupedOrderItem entry, ColorScheme cs) {
    final item = entry.item;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item.productImage.isNotEmpty
                  ? Image.network(
                      item.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_outlined,
                        color: cs.onSurface.withValues(alpha: 0.3),
                      ),
                    )
                  : Icon(
                      Icons.image_outlined,
                      color: cs.onSurface.withValues(alpha: 0.3),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.variantLabel != null && item.variantLabel!.isNotEmpty)
                  Text(
                    item.variantLabel!,
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                ...entry.freeItems.map(
                  (freeItem) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'FREE: ${freeItem.productName} x${freeItem.quantity}',
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
          ),
          Text(
            'INR ${item.totalPrice.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
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
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
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

  Widget _buildDeliveryAddressCard(ColorScheme cs) {
    final order = _order!;
    final address = order.deliveryAddress;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20, color: cs.primary),
              const SizedBox(width: 8),
              Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person_outline,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.userName ?? 'Customer',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      order.userPhone,
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.home_outlined,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatAddress(address),
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmountCard(ColorScheme cs) {
    final order = _order!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer,
            cs.primaryContainer.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildBillRow(
            'Item Total',
            'INR ${order.totalAmount.toStringAsFixed(0)}',
            cs: cs,
          ),
          if (order.discountAmount > 0) ...[
            const SizedBox(height: 8),
            _buildBillRow(
              'Discount',
              '-INR ${order.discountAmount.toStringAsFixed(0)}',
              cs: cs,
              valueColor: Colors.green,
            ),
          ],
          const SizedBox(height: 8),
          _buildBillRow(
            'Delivery Fee',
            order.deliveryFee == 0
                ? 'FREE'
                : 'INR ${order.deliveryFee.toStringAsFixed(0)}',
            cs: cs,
            valueColor: order.deliveryFee == 0 ? Colors.green : cs.onSurface,
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              Text(
                'INR ${order.finalAmount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(
    String label,
    String value, {
    required ColorScheme cs,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: cs.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? cs.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildViewDetailsButton(ColorScheme cs) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _navigateToOrderDetails,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.receipt_long_outlined),
        label: const Text(
          'View Order Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueShoppingButton(ColorScheme cs) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _continueShopping,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: cs.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(Icons.shopping_bag_outlined, color: cs.primary),
        label: Text(
          'Continue Shopping',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: cs.primary,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${local.day} ${months[local.month - 1]} ${local.year}';
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

class CheckPainter extends CustomPainter {
  final double progress;

  CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, bgPaint);

    final circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, circlePaint);

    if (progress > 0.3) {
      final checkProgress = (progress - 0.3) / 0.7;
      final checkPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      final path = Path();
      const startOffset = Offset(24, 40);
      const midOffset = Offset(35, 50);
      const endOffset = Offset(56, 28);

      path.moveTo(startOffset.dx, startOffset.dy);

      final midT = checkProgress.clamp(0, 1);
      path.lineTo(
        startOffset.dx + (midOffset.dx - startOffset.dx) * midT,
        startOffset.dy + (midOffset.dy - startOffset.dy) * midT,
      );

      if (checkProgress > 0.5) {
        final endT = (checkProgress - 0.5) * 2;
        path.lineTo(
          midOffset.dx + (endOffset.dx - midOffset.dx) * endT,
          midOffset.dy + (endOffset.dy - midOffset.dy) * endT,
        );
      }

      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
