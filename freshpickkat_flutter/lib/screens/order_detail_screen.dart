import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/order_controller.dart';
import 'package:freshpickkat_flutter/screens/complaint_detail_screen.dart'
    deferred as complaint_detail_screen;
import 'package:freshpickkat_flutter/screens/report_delivery_issue_screen.dart';
import 'package:freshpickkat_flutter/screens/report_product_issue_screen.dart';
import 'package:freshpickkat_flutter/services/order_service.dart';
import 'package:freshpickkat_flutter/services/product_complaint_service.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/order_item_grouping.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/utils/app_snackbar.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:freshpickkat_flutter/tracking/screens/order_tracking_map_screen.dart'
    deferred as order_tracking_map_screen;

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Order? _order;
  RefundRecord? _refund;
  bool _isLoading = true;
  bool _isCancelling = false;
  String? _error;
  Complaint? _activeProductComplaint;
  Complaint? _activeDeliveryComplaint;
  Worker? _ordersWorker;
  Timer? _otpCountdownTimer;

  @override
  void initState() {
    super.initState();
    _ordersWorker = ever(OrderController.instance.orders, (_) {
      _syncFromList();
    });
    _otpCountdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _order?.status == 'delivery_otp_pending') {
        setState(() {});
      }
    });
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final auth = AuthController.instance;
      final user = auth.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            _error = ErrorMessages.loginRequired;
            _isLoading = false;
          });
        }
        return;
      }
      final idToken = await auth.requireIdToken();
      final hydrated = await ServerpodClient().client.orderDetail
          .getOrderDetailHydrated(widget.orderId, user.uid, idToken);
      if (mounted) {
        setState(() {
          _order = hydrated.order;
          _refund = hydrated.refund;
          _activeProductComplaint = hydrated.activeProductComplaint;
          _activeDeliveryComplaint = hydrated.activeDeliveryComplaint;
          _isLoading = false;
          if (hydrated.order == null) {
            _error = ErrorMessages.orderNotFound;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _syncFromList() {
    if (!mounted) return;

    Order? updated;
    for (final order in OrderController.instance.orders) {
      if (order.orderId == widget.orderId) {
        updated = order;
        break;
      }
    }
    if (updated == null) return;

    setState(() {
      _order = updated;
    });
    _loadOrderComplaint(updated);
  }

  @override
  @override
  void dispose() {
    _ordersWorker?.dispose();
    _otpCountdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: true,
      child: Scaffold(
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
      ),
    );
  }

  List<String> _getStatusTimeline(String currentStatus) {
    if (currentStatus == 'cancelled') {
      return ['placed', 'cancelled'];
    }
    if (currentStatus == 'delivery_otp_pending' ||
        currentStatus == 'delivered') {
      return [
        'placed',
        'confirmed',
        'packed',
        'out_for_delivery',
        'delivery_otp_pending',
        'delivered',
      ];
    }
    return ['placed', 'confirmed', 'packed', 'out_for_delivery', 'delivered'];
  }

  int _getStatusIndex(String status) {
    const statusMap = {
      'placed': 0,
      'confirmed': 1,
      'packed': 2,
      'out_for_delivery': 3,
      'delivery_otp_pending': 4,
      'delivered': 5,
      'cancelled': 1,
    };
    return statusMap[status] ?? 0;
  }

  String _getStatusLabel(String status) {
    const labels = {
      'placed': 'Placed',
      'confirmed': 'Confirmed',
      'packed': 'Packed',
      'out_for_delivery': 'On the Way',
      'delivery_otp_pending': 'OTP Pending',
      'delivered': 'Delivered',
      'cancelled': 'Cancelled',
    };
    return labels[status] ?? status;
  }

  Widget _buildContent(ColorScheme cs) {
    final order = _order!;
    return RefreshIndicator(
      onRefresh: _fetch,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppResponsive.pagePadding(context).copyWith(
          bottom: 24.h + MediaQuery.paddingOf(context).bottom,
        ),
        child: AppResponsive.constrainContent(
          context: context,
          maxWidth: AppResponsive.maxDetailWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(order, cs),
              SizedBox(height: 20.h),
              _buildStatusTimeline(order, cs),
              if (order.status == 'out_for_delivery')
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: _buildTrackingCard(order, cs),
                ),
              if (order.status == 'delivery_otp_pending')
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: _buildDeliveryOtpCard(order, cs),
                ),
              if (_showActionsCard(order))
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: _buildActionsCard(order, cs),
                ),
              if (_refund != null)
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: _buildRefundInfoCard(order, cs),
                ),
              SizedBox(height: 16.h),
              _buildComplaintCta(order, cs),
              SizedBox(height: 16.h),
              _buildAddress(order, cs),
              SizedBox(height: 16.h),
              _buildItems(order, cs),
              SizedBox(height: 16.h),
              _buildTotals(order, cs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(Order order, ColorScheme cs) {
    final timeline = _getStatusTimeline(order.status);
    final currentIndex = _getStatusIndex(order.status);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Progress',
            style: AppTextStyles.sectionTitle(context),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: AppResponsive.isSmallPhone(context) ? 74.h : 86.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                timeline.length,
                (index) {
                  final status = timeline[index];
                  final isCompleted = index < currentIndex;
                  final isCurrent = index == currentIndex;

                  return Expanded(
                    child: Column(
                      children: [
                        // Status Point
                        Container(
                          width: 38.r,
                          height: 38.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted || isCurrent
                                ? Colors.green
                                : cs.outlineVariant,
                            border: isCurrent
                                ? Border.all(
                                    color: Colors.green,
                                    width: 2.5.r,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Icon(
                              isCompleted ||
                                      (isCurrent && status == 'delivered')
                                  ? Icons.check
                                  : (isCurrent
                                        ? Icons.circle
                                        : Icons.circle_outlined),
                              color: isCompleted || isCurrent
                                  ? Colors.white
                                  : cs.outlineVariant,
                              size: isCurrent ? 19.r : 15.r,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Status Label
                        Expanded(
                          child: AutoSizeText(
                            _getStatusLabel(status),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isCompleted || isCurrent
                                  ? Colors.green
                                  : cs.onSurface.withValues(alpha: 0.5),
                              fontSize: 11.sp,
                              fontWeight: isCompleted || isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            minFontSize: 8,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Progress indicator line
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / timeline.length,
              minHeight: 6.h,
              backgroundColor: cs.outlineVariant,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${((currentIndex + 1) / timeline.length * 100).round()}% Complete',
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.6),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Order order, ColorScheme cs) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Order ID: ${order.orderId}',
            style: AppTextStyles.body(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            minFontSize: 11,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Text(
            'Placed on ${_formatDate(order.orderedAt)}',
            style: AppTextStyles.caption(context),
          ),
          if (order.status == 'delivered' && order.deliveredAt != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                'Delivered on ${_formatDate(order.deliveredAt!)}',
                style: AppTextStyles.caption(context).copyWith(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildStatusChip(
                'Order: ${order.status}',
                _statusColor(order.status),
              ),
              _buildStatusChip(
                'Payment: ${order.paymentStatus}',
                _statusColor(order.paymentStatus),
              ),
              if (_showRefundStatus(order)) ...[
                _buildStatusChip(
                  'Refund: ${_refundLabel(order)}',
                  _refundStatusColor(order),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(Order order, ColorScheme cs) {
    final bool canCancel = _canCancelOrder(order);
    final bool paymentBlocked = _isPaymentBlocked(order);
    final bool showRefund = _showRefundStatus(order);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showRefund)
            AutoSizeText(
              'Refund Status: ${_refundLabel(order)}',
              style: TextStyle(
                color: _refundStatusColor(order),
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              minFontSize: 11,
            ),
          if (showRefund && canCancel) SizedBox(height: 12.h),
          if (paymentBlocked) ...[
            SizedBox(height: paymentBlocked && showRefund ? 12.h : 0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.outlineVariant,
                  foregroundColor: cs.onSurface.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text('Cancel Order'),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              _paymentBlockMessage(order),
              style: TextStyle(
                color: cs.error,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (canCancel)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isCancelling ? null : _showCancelConfirmation,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  _isCancelling
                      ? (order.status == 'packed' ||
                                order.status == 'out_for_delivery'
                            ? 'Requesting...'
                            : 'Cancelling...')
                      : (order.status == 'packed' ||
                                order.status == 'out_for_delivery'
                            ? 'Request Cancellation'
                            : 'Cancel Order'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrackingCard(Order order, ColorScheme cs) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your order is on the way',
            style: AppTextStyles.sectionTitle(
              context,
            ).copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            'Open the live map only when you want to follow the rider.',
            style: AppTextStyles.caption(context),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await navigateDeferred(
                  loadLibrary: order_tracking_map_screen.loadLibrary,
                  pageBuilder: () =>
                      order_tracking_map_screen.OrderTrackingMapScreen(
                        orderId: order.orderId,
                      ),
                );
              },
              icon: const Icon(Icons.map_outlined),
              label: const Text('Track Order'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOtpCard(Order order, ColorScheme cs) {
    DateTime? expiresAt;
    if (order.deliveryOtpExpiresAt != null) {
      expiresAt = order.deliveryOtpExpiresAt;
    }
    final isExpired = expiresAt != null && expiresAt.isBefore(DateTime.now());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 20.sp,
                color: cs.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Delivery Verification',
                style: AppTextStyles.sectionTitle(
                  context,
                ).copyWith(fontSize: 16.sp),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (!isExpired && order.deliveryOtp != null) ...[
            Text(
              'Your One-Time Password',
              style: TextStyle(
                fontSize: 12.sp,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              order.deliveryOtp!,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 6,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 16.h),
            Divider(height: 1, color: cs.outlineVariant.withValues(alpha: 0.5)),
            SizedBox(height: 16.h),
            Row(
              children: [
                Icon(
                  Icons.receipt_outlined,
                  size: 16.sp,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Order Amount: ₹${order.finalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16.sp,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Expires in: ',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  _formatOtpCountdown(expiresAt!),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14.sp,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Provide this OTP only when the order is physically handed over to you.',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: cs.onSurface.withValues(alpha: 0.6),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Icon(
                  Icons.timer_off_outlined,
                  size: 20.sp,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
                SizedBox(width: 8.w),
                Text(
                  'OTP Expired',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Please request a new OTP.',
              style: TextStyle(
                fontSize: 13.sp,
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Text(
            'Status: ${order.status == 'delivery_otp_pending' ? 'Waiting for Delivery Confirmation' : order.status}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  String _formatOtpCountdown(DateTime expiresAt) {
    final remaining = expiresAt.difference(DateTime.now());
    if (remaining.isNegative) return 'Expired';
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildRefundInfoCard(Order order, ColorScheme cs) {
    final refund = _refund;
    if (refund == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.currency_rupee, size: 20.sp, color: cs.primary),
              SizedBox(width: 8.w),
              Text(
                'Refund Information',
                style: AppTextStyles.sectionTitle(
                  context,
                ).copyWith(fontSize: 16.sp),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _refundInfoRow('Refund Status', _refundLabel(order), cs),
          SizedBox(height: 10.h),
          _refundInfoRow('Refund Amount', '₹${refund.amount.formatPrice}', cs),
          SizedBox(height: 10.h),
          _refundInfoRow('Refund ID', refund.refundId, cs),
          SizedBox(height: 10.h),
          _refundInfoRow('Initiated Date', _formatDate(refund.createdAt), cs),
          SizedBox(height: 10.h),
          _refundInfoRow('Expected Time', '2–5 Business Days', cs),
          if (refund.status == 'failed') ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: cs.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16.sp, color: cs.error),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'We are processing your refund manually. '
                      'It may take 2–3 business days for the refund '
                      'to reflect in your account.',
                      style: TextStyle(
                        color: cs.error,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _refundInfoRow(String label, String value, ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.6),
            fontSize: 13.sp,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: AutoSizeText(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        minFontSize: 9,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildAddress(Order order, ColorScheme cs) {
    final address = order.deliveryAddress;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Address',
            style: AppTextStyles.sectionTitle(
              context,
            ).copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            _formatAddress(address),
            style: AppTextStyles.caption(context),
          ),
        ],
      ),
    );
  }

  Widget _buildItems(Order order, ColorScheme cs) {
    final grouped = groupOrderItems(order.items);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items (${order.itemCount})',
            style: AppTextStyles.sectionTitle(
              context,
            ).copyWith(fontSize: 16.sp),
          ),
          SizedBox(height: 12.h),
          if (grouped.bogoGroups.isNotEmpty) ...[
            _buildOrderSectionTitle('BOGO Offers', cs),
            ...grouped.bogoGroups.map(
              (entry) => _buildOrderRegularItem(entry, cs),
            ),
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
              (item) => _buildOrderRegularItem(
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

  Widget _buildOrderRegularItem(GroupedOrderItem entry, ColorScheme cs) {
    final item = entry.item;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${item.productName}${item.variantLabel != null && item.variantLabel!.isNotEmpty ? ' (${item.variantLabel})' : ''} x${item.quantity}',
                  style: AppTextStyles.body(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              AutoSizeText(
                'INR ${item.totalPrice.formatPrice}',
                style: TextStyle(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
                minFontSize: 11,
                maxLines: 1,
              ),
            ],
          ),
          ...entry.freeItems.map(
            (freeItem) => Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: AutoSizeText(
                'FREE: ${freeItem.productName}${freeItem.variantLabel != null && freeItem.variantLabel!.isNotEmpty ? ' (${freeItem.variantLabel})' : ''} x${freeItem.quantity}',
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
          SizedBox(height: 10.h),
          _buildComplaintControls(item, cs),
        ],
      ),
    );
  }

  Future<void> _loadOrderComplaint(Order order) async {
    if (order.status == 'cancelled') return;
    final complaintType = order.status == 'delivered' ? 'product' : 'delivery';
    try {
      final complaint = await ProductComplaintService.instance
          .getActiveComplaintForOrder(
            orderNumber: order.orderId,
            complaintType: complaintType,
          );
      if (!mounted) return;
      setState(() {
        if (complaintType == 'product') {
          _activeProductComplaint = complaint;
        } else {
          _activeDeliveryComplaint = complaint;
        }
      });
    } catch (_) {}
  }

  Widget _buildComplaintControls(OrderItem item, ColorScheme cs) {
    return const SizedBox.shrink();
  }

  Widget _buildComplaintCta(Order order, ColorScheme cs) {
    if (order.status == 'cancelled') return const SizedBox.shrink();
    final isDelivered = order.status == 'delivered';
    final complaint = isDelivered
        ? _activeProductComplaint
        : _activeDeliveryComplaint;
    final title = isDelivered
        ? 'Report Product Issue'
        : 'Report Delivery Issue';
    final subtitle = complaint == null
        ? (isDelivered
              ? 'Select affected products and submit one complaint.'
              : 'Submit one delivery-related complaint for this order.')
        : 'Active complaint: ${complaint.status}';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.report_problem_outlined, color: cs.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.62),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          OutlinedButton(
            onPressed: () async {
              if (complaint != null) {
                await navigateDeferred(
                  loadLibrary: complaint_detail_screen.loadLibrary,
                  pageBuilder: () =>
                      complaint_detail_screen.ComplaintDetailScreen(
                        complaint: complaint,
                      ),
                );
                return;
              }
              if (isDelivered) {
                final deliveredAt = order.deliveredAt;
                if (deliveredAt != null) {
                  final deadline = deliveredAt.add(const Duration(days: 1));
                  if (DateTime.now().isAfter(deadline)) {
                    AppSnackbar.show(
                      'Complaint period expired',
                      'You can only report product issues within 1 day of delivery.',
                    );
                    return;
                  }
                }
              }
              final result = await Get.to<dynamic>(
                () => isDelivered
                    ? ReportProductIssueScreen(
                        orderNumber: order.orderId,
                        items: order.items,
                        activeComplaint: _activeProductComplaint,
                      )
                    : ReportDeliveryIssueScreen(
                        orderNumber: order.orderId,
                        orderStatus: order.status,
                        currentAddress: order.deliveryAddress,
                        activeComplaint: _activeDeliveryComplaint,
                      ),
              );
              if (!mounted) return;
              if (result == true) {
                await _fetch();
                return;
              }
              if (result is Complaint) {
                setState(() {
                  if (result.complaintType == 'product') {
                    _activeProductComplaint = result;
                  } else {
                    _activeDeliveryComplaint = result;
                  }
                });
              }
            },
            child: Text(complaint == null ? 'Report' : 'View'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderComboGroup(GroupedOrderCombo group, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12.r),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                    SizedBox(height: 6.h),
                    _buildComplaintControls(item, cs),
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

  Widget _buildTotals(Order order, ColorScheme cs) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_outlined, size: 20.sp, color: cs.primary),
              SizedBox(width: 8.w),
              Text(
                'Bill Summary',
                style: AppTextStyles.sectionTitle(
                  context,
                ).copyWith(fontSize: 16.sp),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildRow(
            Icons.shopping_bag_outlined,
            'Item Total',
            'INR ${order.totalAmount.formatPrice}',
            cs,
          ),
          if (order.couponApplied != null && order.couponApplied!.isNotEmpty)
            _buildRow(
              Icons.local_offer_outlined,
              'Coupon (${order.couponApplied!.toUpperCase()})',
              '-INR ${order.discountAmount.formatPrice}',
              cs,
              valueColor: Colors.green,
            )
          else if (order.discountAmount > 0)
            _buildRow(
              Icons.discount_outlined,
              'Discount',
              '-INR ${order.discountAmount.formatPrice}',
              cs,
              valueColor: Colors.green,
            ),
          _buildRow(
            Icons.local_shipping_outlined,
            'Delivery Fee',
            order.deliveryFee == 0
                ? 'FREE'
                : 'INR ${order.deliveryFee.formatPrice}',
            cs,
            valueColor: order.deliveryFee == 0 ? Colors.green : null,
          ),
          SizedBox(height: 12.h),
          Divider(color: cs.outlineVariant),
          SizedBox(height: 4.h),
          _buildRow(
            Icons.payments_outlined,
            'Paid',
            'INR ${order.finalAmount.formatPrice}',
            cs,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    IconData icon,
    String label,
    String value,
    ColorScheme cs, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: cs.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.receiptLabel(context, total: isTotal),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 12.w),
          AutoSizeText(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.receiptValue(
              context,
              total: isTotal,
              color: valueColor,
            ),
            minFontSize: 11,
            maxLines: 1,
          ),
        ],
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
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day-$month-${local.year} $hour:$minute';
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
      case 'success':
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

  bool _canCancelOrder(Order order) {
    if (order.status == 'cancelled' || order.status == 'delivered') {
      return false;
    }
    return order.status == 'placed' ||
        order.status == 'confirmed' ||
        order.status == 'packed' ||
        order.status == 'out_for_delivery';
  }

  bool _isPaymentBlocked(Order order) {
    return order.paymentStatus == 'pending' ||
        order.paymentStatus == 'failed' ||
        order.paymentStatus == 'cancelled';
  }

  String _paymentBlockMessage(Order order) {
    switch (order.paymentStatus) {
      case 'pending':
        return ErrorMessages.cancelPaymentPending;
      case 'failed':
        return ErrorMessages.cancelPaymentFailed;
      case 'cancelled':
        return ErrorMessages.cancelPaymentCancelled;
      default:
        return '';
    }
  }

  bool _showActionsCard(Order order) {
    return _canCancelOrder(order) ||
        _showRefundStatus(order) ||
        _isPaymentBlocked(order);
  }

  bool _showRefundStatus(Order order) {
    return order.refundStatus.toLowerCase() != 'none' &&
        order.refundStatus.toLowerCase() != '' &&
        _refund != null;
  }

  String _refundLabel(Order order) {
    final status = (_refund?.status ?? order.refundStatus).toLowerCase();
    switch (status) {
      case 'initiated':
      case 'pending':
        return 'Initiated';
      case 'processed':
        return 'Completed';
      case 'failed':
        return 'Failed';
      default:
        return status.isEmpty ? 'None' : status;
    }
  }

  Color _refundStatusColor(Order order) {
    switch ((_refund?.status ?? order.refundStatus).toLowerCase()) {
      case 'initiated':
      case 'pending':
        return Colors.orange;
      case 'processed':
        return Colors.green;
      case 'failed':
        return Colors.redAccent;
      default:
        return Colors.blueGrey;
    }
  }

  Future<void> _showCancelConfirmation() async {
    final order = _order;
    if (order == null) return;

    final status = order.status;
    final amount = order.finalAmount;
    final deliveryFee = order.deliveryFee;
    final refundEstimate = status == 'out_for_delivery'
        ? amount - deliveryFee
        : amount;

    // Stage 3: Out For Delivery — show warning first
    if (status == 'out_for_delivery') {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Important Cancellation Notice'),
          content: Text(
            'Your order is already out for delivery.\n\n'
            'If you continue:\n'
            '• Delivery charges will not be refunded.\n'
            '• Additional cancellation charges may apply.\n'
            '• The final refund amount may be lower than the original payment amount.\n\n'
            'Do you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep Order'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Continue Cancellation'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
      if (!mounted) return;
      // Fall through to the reason dialog below
    }

    // Stage 2/3: packed or out_for_delivery — reason dialog
    if (status == 'packed' || status == 'out_for_delivery') {
      final reasonController = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Request Order Cancellation?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your order is currently being prepared.\n\n'
                'Cancellation requires approval from our team.\n\n'
                'If approved, the refund will be processed according to our cancellation policy.',
              ),
              if (status == 'out_for_delivery') ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Estimated refund: ₹${refundEstimate.formatPrice}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
              SizedBox(height: 12.h),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep Order'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Request Cancellation'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        _requestCancellation(reason: reasonController.text.trim());
        reasonController.dispose();
      }
      return;
    }

    // Stage 1: placed/confirmed — direct cancel with full refund
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: Text(
          'Your order has not entered processing yet.\n\n'
          'If you cancel now, you will receive a full refund of ₹${amount.formatPrice}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      _cancelOrder();
    }
  }

  Future<void> _cancelOrder() async {
    final currentUser = AuthController.instance.currentUser;
    if (currentUser == null) {
      AppSnackbar.show('Login required', ErrorMessages.loginToCancel);
      return;
    }

    setState(() {
      _isCancelling = true;
    });

    try {
      final result = await OrderService.instance.cancelOrder(
        orderId: widget.orderId,
        userId: currentUser.uid,
      );
      await _fetch();
      if (mounted) {
        if (result.success) {
          final msg = _cancelSuccessMessage(result);
          AppSnackbar.show('Order Cancelled', msg);
        } else {
          AppSnackbar.error(
            'Cancel failed',
            result.error ?? ErrorMessages.cancelFailed,
          );
        }
      }
    } catch (e) {
      AppLogger.error('OrderDetail', e);
      if (mounted) {
        AppSnackbar.error('Cancel failed', ErrorMessages.cancelFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCancelling = false;
        });
      }
    }
  }

  String _cancelSuccessMessage(PaymentActionResult result) {
    switch (result.status) {
      case 'refunded':
        return result.message ?? ErrorMessages.refundInitiated;
      case 'cancelled':
        return result.message ?? ErrorMessages.orderCancelledSuccess;
      default:
        return result.message ?? ErrorMessages.orderCancelledSuccess;
    }
  }

  Future<void> _requestCancellation({String reason = ''}) async {
    final currentUser = AuthController.instance.currentUser;
    if (currentUser == null) {
      AppSnackbar.show('Login required', ErrorMessages.loginToCancel);
      return;
    }

    setState(() {
      _isCancelling = true;
    });

    try {
      final result = await OrderService.instance.requestCancellation(
        orderId: widget.orderId,
        userId: currentUser.uid,
        reason: reason.isEmpty ? 'User requested cancellation' : reason,
      );
      await _fetch();
      if (mounted) {
        if (result.success) {
          AppSnackbar.show(
            'Request Submitted',
            result.message ?? ErrorMessages.cancellationRequestSubmitted,
          );
        } else {
          AppSnackbar.error(
            'Request failed',
            result.error ?? 'Could not submit cancellation request.',
          );
        }
      }
    } catch (e) {
      AppLogger.error('OrderDetail', e);
      if (mounted) {
        AppSnackbar.error('Request failed', ErrorMessages.cancelFailed);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCancelling = false;
        });
      }
    }
  }
}
