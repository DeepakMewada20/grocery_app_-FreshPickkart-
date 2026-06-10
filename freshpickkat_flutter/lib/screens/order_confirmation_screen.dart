import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/screens/order_detail_screen.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/order_item_grouping.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/payment_status_widget.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';

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
                  padding: EdgeInsets.only(
                    bottom: 24.h + MediaQuery.paddingOf(context).bottom,
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
                                      padding: EdgeInsets.only(bottom: 16.h),
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
                                  SizedBox(height: 16.h),
                                  _buildProductsCard(cs),
                                  SizedBox(height: 16.h),
                                  _buildDeliveryAddressCard(cs),
                                  SizedBox(height: 16.h),
                                  _buildTotalAmountCard(cs),
                                  SizedBox(height: 24.h),
                                  _buildViewDetailsButton(cs),
                                  SizedBox(height: 12.h),
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
    final headerColor = isPaid ? Colors.green : Colors.orange;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 36.h, bottom: 30.h),
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
          SizedBox(height: 16.h),
          FadeTransition(
            opacity: _fadeAnimation,
            child: AutoSizeText(
              'Order Placed Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
              minFontSize: 16,
              maxLines: 2,
            ),
          ),
          SizedBox(height: 8.h),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              _order?.paymentStatus == 'paid'
                  ? 'Payment Successful'
                  : 'Payment Pending',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 16.sp,
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
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
          Divider(height: 24.h),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Order Date',
            value: _formatDate(order.orderedAt),
            cs: cs,
          ),
          Divider(height: 24.h),
          _buildInfoRow(
            icon: Icons.local_shipping_outlined,
            label: 'Estimated Delivery',
            value: _formatDate(estimatedDelivery),
            cs: cs,
            valueColor: Colors.green.shade700,
          ),
          Divider(height: 24.h),
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
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.r, color: cs.primary),
        ),
        SizedBox(width: 12.w),
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
              SizedBox(height: 2.h),
              AutoSizeText(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
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
              Icon(Icons.shopping_bag_outlined, size: 20.r, color: cs.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Ordered Products (${order.itemCount})',
                  style: AppTextStyles.sectionTitle(
                    context,
                  ).copyWith(fontSize: 16.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
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
      padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
      child: Text(
        title,
        style: AppTextStyles.body(context).copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w700,
          fontSize: 13.sp,
        ),
      ),
    );
  }

  Widget _buildOrderItem(GroupedOrderItem entry, ColorScheme cs) {
    final item = entry.item;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: SafeNetworkImage(
                url: item.productImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontSize: 14.sp,
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
                      fontSize: 12.sp,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: 4.h),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                ...entry.freeItems.map(
                  (freeItem) => Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: AutoSizeText(
                      'FREE: ${freeItem.productName} x${freeItem.quantity}',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      minFontSize: 9,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          AutoSizeText(
            'INR ${item.totalPrice.formatPrice}',
            style: TextStyle(
              fontSize: 14.sp,
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
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
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
                SizedBox(width: 8.w),
                Flexible(
                  child: AutoSizeText(
                    comboDiscountBadgeText(
                      group.discountType,
                      group.discountValue,
                    ),
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    minFontSize: 9,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ...group.items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.productName}${item.variantLabel != null && item.variantLabel!.isNotEmpty ? ' (${item.variantLabel})' : ''} x${item.quantity}',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.75),
                          fontSize: 13.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    AutoSizeText(
                      'INR ${item.totalPrice.formatPrice}',
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.75),
                        fontSize: 13.sp,
                      ),
                      minFontSize: 10,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
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
                SizedBox(width: 8.w),
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
                        fontSize: 12.sp,
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
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
              Icon(Icons.location_on_outlined, size: 20.r, color: cs.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Delivery Address',
                  style: AppTextStyles.sectionTitle(
                    context,
                  ).copyWith(fontSize: 16.sp),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person_outline,
                size: 18.r,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
              SizedBox(width: 8.w),
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
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.home_outlined,
                size: 18.r,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
              SizedBox(width: 8.w),
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primaryContainer,
            cs.primaryContainer.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _buildBillRow(
            'Item Total',
            'INR ${order.totalAmount.formatPrice}',
            cs: cs,
          ),
          if (order.discountAmount > 0) ...[
            SizedBox(height: 8.h),
            _buildBillRow(
              'Discount',
              '-INR ${order.discountAmount.formatPrice}',
              cs: cs,
              valueColor: Colors.green,
            ),
          ],
          SizedBox(height: 8.h),
          _buildBillRow(
            'Delivery Fee',
            order.deliveryFee == 0
                ? 'FREE'
                : 'INR ${order.deliveryFee.formatPrice}',
            cs: cs,
            valueColor: order.deliveryFee == 0 ? Colors.green : cs.onSurface,
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total Paid',
                  style: AppTextStyles.receiptLabel(context, total: true),
                ),
              ),
              SizedBox(width: 12.w),
              AutoSizeText(
                'INR ${order.finalAmount.formatPrice}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 20.sp,
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
            style: AppTextStyles.receiptLabel(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 12.w),
        AutoSizeText(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 14.sp,
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
          padding: EdgeInsets.symmetric(vertical: 16.h),
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: const Icon(Icons.receipt_long_outlined),
        label: AutoSizeText(
          'View Order Details',
          style: TextStyle(
            fontSize: 16.sp,
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
          padding: EdgeInsets.symmetric(vertical: 16.h),
          side: BorderSide(color: cs.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        icon: Icon(Icons.shopping_bag_outlined, color: cs.primary),
        label: AutoSizeText(
          'Continue Shopping',
          style: TextStyle(
            fontSize: 16.sp,
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
