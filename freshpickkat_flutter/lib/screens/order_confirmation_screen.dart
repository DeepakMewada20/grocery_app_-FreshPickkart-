import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/screens/order_detail_screen.dart'
    deferred as order_detail_screen;
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/order_item_grouping.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/payment_status_widget.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

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

  Future<void> _navigateToOrderDetails() async {
    await navigateDeferred(
      loadLibrary: () => order_detail_screen.loadLibrary(),
      pageBuilder: () =>
          order_detail_screen.OrderDetailScreen(orderId: widget.orderId),
    );
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
                  padding: EdgeInsets.only(
                    bottom: ScreenScale.h(24) + MediaQuery.paddingOf(context).bottom,
                  ),
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
                          child: AppResponsive.constrainContent(
                            context: context,
                            maxWidth: AppResponsive.maxCheckoutWidth,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppResponsive.pageHorizontalPadding(
                                  context,
                                ),
                              ),
                              child: Column(
                                children: [
                                  if (_order?.paymentStatus != 'paid' &&
                                      _order?.razorpayPaymentId != null)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: ScreenScale.h(16)),
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
                                  SizedBox(height: ScreenScale.h(16)),
                                  _buildProductsCard(cs),
                                  SizedBox(height: ScreenScale.h(16)),
                                  _buildDeliveryAddressCard(cs),
                                  SizedBox(height: ScreenScale.h(16)),
                                  _buildTotalAmountCard(cs),
                                  SizedBox(height: ScreenScale.h(24)),
                                  _buildViewDetailsButton(cs),
                                  SizedBox(height: ScreenScale.h(12)),
                                  _buildContinueShoppingButton(cs),
                                ],
                              ),
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
    final isCod = _order?.paymentMode == 'cod';
    final headerColor = (isPaid || isCod) ? Colors.green : Colors.orange;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: ScreenScale.h(36), bottom: ScreenScale.h(30)),
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
                painter: _CheckPainter(progress: _checkAnimation.value),
              );
            },
          ),
          SizedBox(height: ScreenScale.h(16)),
          FadeTransition(
            opacity: _fadeAnimation,
            child: AutoSizeText(
              'Order Placed Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenScale.sp(22),
                fontWeight: FontWeight.bold,
              ),
              minFontSize: 16,
              maxLines: 2,
            ),
          ),
          SizedBox(height: ScreenScale.h(8)),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              _order?.paymentStatus == 'paid'
                  ? 'Payment Successful'
                  : _order?.paymentMode == 'cod'
                      ? 'Pay on Delivery'
                      : 'Payment Pending',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: ScreenScale.sp(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard(ColorScheme cs) {
    final order = _order!;
    final estimatedDelivery = order.orderedAt.add(const Duration(days: 1));

    return Container(
      padding: EdgeInsets.all(ScreenScale.w(16)),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(ScreenScale.r(16)),
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
          Divider(height: ScreenScale.h(24)),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Order Date',
            value: _formatDate(order.orderedAt),
            cs: cs,
          ),
          Divider(height: ScreenScale.h(24)),
          _buildInfoRow(
            icon: Icons.local_shipping_outlined,
            label: 'Estimated Delivery',
            value: _formatDate(estimatedDelivery),
            cs: cs,
            valueColor: Colors.green.shade700,
          ),
          Divider(height: ScreenScale.h(24)),
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
          width: ScreenScale.r(36),
          height: ScreenScale.r(36),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(ScreenScale.r(10)),
          ),
          child: Icon(icon, size: ScreenScale.r(18), color: cs.primary),
        ),
        SizedBox(width: ScreenScale.w(12)),
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
              SizedBox(height: ScreenScale.h(2)),
              AutoSizeText(
                value,
                style: TextStyle(
                  fontSize: ScreenScale.sp(14),
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? cs.onSurface,
                ),
                minFontSize: 10,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductsCard(ColorScheme cs) {
    final order = _order!;
    final grouped = groupOrderItems(order.items);

    return Container(
      padding: EdgeInsets.all(ScreenScale.w(16)),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(ScreenScale.r(16)),
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
              Icon(Icons.shopping_bag_outlined, size: ScreenScale.r(20), color: cs.primary),
              SizedBox(width: ScreenScale.w(8)),
              Expanded(
                child: Text(
                  'Ordered Products (${order.items.length})',
                  style: AppText.sectionTitle(
                    context,
                  ).copyWith(fontSize: ScreenScale.sp(16)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenScale.h(16)),
          if (grouped.bogoGroups.isNotEmpty) ...[
            _buildOrderSectionTitle('BOGO Offers', cs),
            ...grouped.bogoGroups.map((entry) => _buildOrderItem(entry, cs)),
          ],
          if (grouped.comboGroups.isNotEmpty) ...[
            _buildOrderSectionTitle('Combo Offers', cs),
            ...grouped.comboGroups.map(
              (group) => _buildOrderComboGroup(group, cs),
            ),
          ],
          if (grouped.individualItems.isNotEmpty) ...[
            _buildOrderSectionTitle('Individual Items', cs),
            ...grouped.individualItems.map(
              (item) => _buildOrderItem(
                GroupedOrderItem(item: item, freeItems: const []),
                cs,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderSectionTitle(String title, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.only(top: ScreenScale.h(4), bottom: ScreenScale.h(8)),
      child: Text(
        title,
        style: AppText.bodyMedium(context).copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w700,
          fontSize: ScreenScale.sp(13),
        ),
      ),
    );
  }

  Widget _buildOrderItem(GroupedOrderItem entry, ColorScheme cs) {
    final item = entry.item;
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenScale.h(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenScale.r(52),
            height: ScreenScale.r(52),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(ScreenScale.r(10)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenScale.r(10)),
              child: SafeNetworkImage(
                url: item.productImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: ScreenScale.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontSize: ScreenScale.sp(14),
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
                      fontSize: ScreenScale.sp(12),
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: ScreenScale.h(4)),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    fontSize: ScreenScale.sp(12),
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                ...entry.freeItems.map(
                  (freeItem) {
                    final isSmgm =
                        freeItem.rewardSource == 'SHOP_MORE_GET_MORE';
                    return Padding(
                      padding: EdgeInsets.only(top: ScreenScale.h(4)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ScreenScale.w(6),
                                  vertical: ScreenScale.h(2),
                                ),
                                decoration: BoxDecoration(
                                  color: isSmgm
                                      ? Colors.orange
                                      : Colors.green.shade600,
                                  borderRadius: BorderRadius.circular(ScreenScale.r(4)),
                                ),
                                child: Text(
                                  isSmgm ? 'REWARD' : 'FREE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenScale.sp(9),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              SizedBox(width: ScreenScale.w(6)),
                              AutoSizeText(
                                '${freeItem.productName} x${freeItem.quantity}',
                                style: TextStyle(
                                  color: isSmgm
                                      ? Colors.orange.shade800
                                      : Colors.green.shade700,
                                  fontSize: ScreenScale.sp(12),
                                  fontWeight: FontWeight.w600,
                                ),
                                minFontSize: 9,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          if (isSmgm)
                            Padding(
                              padding: EdgeInsets.only(left: ScreenScale.w(2), top: ScreenScale.h(2)),
                              child: Text(
                                'Unlocked via ${freeItem.rewardOfferName ?? "Shop More, Get More"}',
                                style: TextStyle(
                                  color: Colors.orange.shade400,
                                  fontSize: ScreenScale.sp(10),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: ScreenScale.w(8)),
          AutoSizeText(
            'INR ${item.totalPrice.formatPrice}',
            style: TextStyle(
              fontSize: ScreenScale.sp(14),
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
            minFontSize: 10,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderComboGroup(GroupedOrderCombo group, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenScale.h(12)),
      child: Container(
        padding: EdgeInsets.all(ScreenScale.w(12)),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(ScreenScale.r(12)),
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
                SizedBox(width: ScreenScale.w(8)),
                Flexible(
                  child: AutoSizeText(
                    comboDiscountBadgeText(
                      group.discountType,
                      group.discountValue,
                    ),
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: ScreenScale.sp(12),
                      fontWeight: FontWeight.w700,
                    ),
                    minFontSize: 9,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenScale.h(8)),
            ...group.items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: ScreenScale.h(6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.productName}${item.variantLabel != null && item.variantLabel!.isNotEmpty ? ' (${item.variantLabel})' : ''} x${item.quantity}',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.75),
                          fontSize: ScreenScale.sp(13),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: ScreenScale.w(8)),
                    AutoSizeText(
                      'INR ${item.totalPrice.formatPrice}',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.75),
                        fontSize: ScreenScale.sp(13),
                      ),
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ScreenScale.h(4)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Combo total x${group.bundleQuantity}',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: ScreenScale.w(8)),
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
                        fontSize: ScreenScale.sp(12),
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
      padding: EdgeInsets.all(ScreenScale.w(16)),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(ScreenScale.r(16)),
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
              Icon(Icons.location_on_outlined, size: ScreenScale.r(20), color: cs.primary),
              SizedBox(width: ScreenScale.w(8)),
              Expanded(
                child: Text(
                  'Delivery Address',
                  style: AppText.sectionTitle(
                    context,
                  ).copyWith(fontSize: ScreenScale.sp(16)),
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenScale.h(12)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person_outline,
                size: ScreenScale.r(18),
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
              SizedBox(width: ScreenScale.w(8)),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      order.userPhone,
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenScale.h(8)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.home_outlined,
                size: ScreenScale.r(18),
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
              SizedBox(width: ScreenScale.w(8)),
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
      padding: EdgeInsets.all(ScreenScale.w(16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer,
            cs.primaryContainer.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(ScreenScale.r(16)),
      ),
      child: Column(
        children: [
          _buildBillRow(
            'Item Total',
            'INR ${order.totalAmount.formatPrice}',
            cs: cs,
          ),
          if (order.discountAmount > 0) ...[
            SizedBox(height: ScreenScale.h(8)),
            _buildBillRow(
              'Discount',
              '-INR ${order.discountAmount.formatPrice}',
              cs: cs,
              valueColor: Colors.green,
            ),
          ],
          SizedBox(height: ScreenScale.h(8)),
          _buildBillRow(
            'Delivery Fee',
            order.deliveryFee == 0
                ? 'FREE'
                : 'INR ${order.deliveryFee.formatPrice}',
            cs: cs,
            valueColor: order.deliveryFee == 0 ? Colors.green : cs.onSurface,
          ),
          if (order.freshPointsUsed > 0) ...[
            SizedBox(height: ScreenScale.h(8)),
            _buildBillRow(
              'FreshPoints Used (${order.freshPointsUsed})',
              '-INR ${order.freshPointsValue.formatPrice}',
              cs: cs,
              valueColor: Colors.green,
            ),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  order.freshPointsUsed > 0
                      ? 'Paid via UPI/Card'
                      : order.paymentMode == 'cod'
                          ? 'Pay on Delivery'
                          : 'Total Paid',
                  style: AppText.receiptLabel(context, total: true),
                ),
              ),
              SizedBox(width: ScreenScale.w(12)),
              AutoSizeText(
                'INR ${
                  order.freshPointsUsed > 0
                      ? order.actualPaymentAmount.formatPrice
                      : order.finalAmount.formatPrice
                }',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: ScreenScale.sp(20),
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
                minFontSize: 13,
                maxLines: 1,
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
        Expanded(
          child: Text(
            label,
            style: AppText.receiptLabel(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: ScreenScale.w(12)),
        AutoSizeText(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: ScreenScale.sp(14),
            fontWeight: FontWeight.w600,
            color: valueColor ?? cs.onSurface,
          ),
          minFontSize: 10,
          maxLines: 1,
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
          padding: EdgeInsets.symmetric(vertical: ScreenScale.h(16)),
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenScale.r(12)),
          ),
        ),
        icon: const Icon(Icons.receipt_long_outlined),
        label: AutoSizeText(
          'View Order Details',
          style: TextStyle(
            fontSize: ScreenScale.sp(16),
            fontWeight: FontWeight.w600,
          ),
          minFontSize: 12,
          maxLines: 1,
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
          padding: EdgeInsets.symmetric(vertical: ScreenScale.h(16)),
          side: BorderSide(color: cs.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenScale.r(12)),
          ),
        ),
        icon: Icon(Icons.shopping_bag_outlined, color: cs.primary),
        label: AutoSizeText(
          'Continue Shopping',
          style: TextStyle(
            fontSize: ScreenScale.sp(16),
            fontWeight: FontWeight.w600,
            color: cs.primary,
          ),
          minFontSize: 12,
          maxLines: 1,
        ),
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

class _CheckPainter extends CustomPainter {
  final double progress;

  _CheckPainter({required this.progress});

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
  bool shouldRepaint(_CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
