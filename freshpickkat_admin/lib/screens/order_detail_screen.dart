import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freshpickkat_admin/controller/admin_order_controller.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/utils/order_item_grouping.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/tracking/screens/live_delivery_map_preview_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({
    super.key,
    required this.order,
    required this.onStatusChanged,
    required this.onStartDelivery,
  });

  final Order order;
  final Future<void> Function(String) onStatusChanged;
  final Future<void> Function(Order order) onStartDelivery;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Order _order;
  bool _isLoading = false;
  final TextEditingController _otpController = TextEditingController();
  Timer? _otpResendTimer;
  int _otpResendCountdown = 0;
  String? _otpError;
  bool _otpVerifying = false;
  bool _otpGenerating = false;
  final AdminOrderController _orderController = AdminOrderController.instance;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  @override
  void didUpdateWidget(OrderDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.order != oldWidget.order) {
      _order = widget.order;
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpResendTimer?.cancel();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    try {
      await _orderController.loadInitial(force: true);
      final updated = _orderController.orders.where(
        (o) => o.orderId == _order.orderId,
      ).firstOrNull;
      if (updated != null && mounted) {
        setState(() => _order = updated);
      }
    } catch (_) {
    }
  }

  void _startResendCountdown() {
    _otpResendTimer?.cancel();
    setState(() => _otpResendCountdown = 60);
    _otpResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _otpResendCountdown--;
        if (_otpResendCountdown <= 0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    final groupedItems = groupAdminOrderItems(order.items);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: AdminThemeTokens.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onSurface),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Text(
          'Order Details',
          style: AdminTextStyles.screenTitle(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: _buildStatusChip(order.status),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            AdminResponsive.pageHorizontalPadding(context),
            8.h,
            AdminResponsive.pageHorizontalPadding(context),
            AdminResponsive.bottomInset(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Text(
                  'Order #${order.orderId}',
                  style: TextStyle(
                    fontSize: 13.sp.clamp(11.0, 14.0),
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
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
                  onCopy: () => _copyToClipboard(order.userPhone, 'Phone'),
                  onCall: () => _launchPhoneCall(order.userPhone),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _DetailSection(
              title: 'Delivery Address',
              icon: Icons.location_on_outlined,
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
            SizedBox(height: 12.h),
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
                  ..._buildGroupedOrderItemWidgets(groupedItems),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AdminAppTheme.getTextSecondaryColor(
            context,
          ).withValues(alpha: 0.12),
          width: 1,
        ),
      ),
              child: Column(
                children: [
                  _amountRow(
                    'MRP Total',
                    order.mrpTotal > 0
                        ? order.mrpTotal
                        : order.totalAmount,
                  ),
                  if (order.productDiscountAmount > 0)
                    _amountRow(
                      'Product Discount',
                      -order.productDiscountAmount,
                    ),
                  if (order.comboDiscountAmount > 0)
                    _amountRow(
                      'Combo Savings',
                      -order.comboDiscountAmount,
                    ),
                  if (order.bogoDiscountAmount > 0)
                    _amountRow(
                      'BOGO Savings',
                      -order.bogoDiscountAmount,
                    ),
                  _amountRow('Items Total', order.totalAmount),
                  if (order.discountAmount > 0)
                    _amountRow(
                      order.couponApplied?.isNotEmpty == true
                          ? 'Coupon (${order.couponApplied})'
                          : 'Coupon Discount',
                      -order.discountAmount,
                    ),
                  _amountRow('Delivery Fee', order.deliveryFee),
                  if (order.freeDeliveryApplied &&
                      order.deliveryDiscountAmount > 0)
                    _amountRow(
                      'Delivery Fee Waived',
                      -order.deliveryDiscountAmount,
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Divider(),
                  ),
                  _amountRow('To Pay', order.finalAmount, isBold: true),
                ],
              ),
            ),
            if (order.deliveryPersonName != null &&
                order.deliveryPersonName!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              _DetailSection(
                title: 'Delivery Details',
                icon: Icons.delivery_dining,
                children: [
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
              SizedBox(height: 12.h),
              Container(
                padding: AdminResponsive.cardPadding(context),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: AdminTextStyles.caption(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (order.refundStatus != 'none') ...[
              SizedBox(height: 12.h),
              _DetailSection(
                title: 'Refund Info',
                icon: Icons.monetization_on_outlined,
                children: [
                  _DetailRow(
                    icon: Icons.info_outline,
                    label: 'Refund Status: ${order.refundStatus.toUpperCase()}',
                  ),
                  if (order.cancelledAt != null)
                    _DetailRow(
                      icon: Icons.cancel_outlined,
                      label: 'Cancelled: ${_formatDate(order.cancelledAt)}',
                    ),
                ],
              ),
            ],
            if (order.complaintId != null &&
                order.complaintId!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              _DetailSection(
                title: 'Complaint',
                icon: Icons.report_problem_outlined,
                children: [
                  _DetailRow(
                    icon: Icons.description_outlined,
                    label: 'Complaint ID: ${order.complaintId}',
                  ),
                ],
              ),
            ],
            SizedBox(height: 24.h),
            _buildLifecycleActions(context, order),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildLifecycleActions(BuildContext context, Order order) {
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
                    await widget.onStatusChanged('confirmed');
                    if (mounted) {
                      setState(() => _order = _order.copyWith(status: 'confirmed'));
                    }
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
                    await widget.onStatusChanged('packed');
                    if (mounted) {
                      setState(() => _order = _order.copyWith(status: 'packed'));
                    }
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
                    if (mounted) {
                      setState(() => _order = _order.copyWith(status: 'out_for_delivery'));
                    }
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
          label: 'Generate Delivery OTP',
          color: primaryColor,
          icon: Icons.pin_outlined,
          isLoading: _otpGenerating,
          onPressed: _otpGenerating
              ? null
              : () async {
                  setState(() => _otpGenerating = true);
                  try {
                    await _orderController.generateDeliveryOtp(order);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Delivery OTP sent to customer. Waiting for verification.',
                          ),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                      setState(() => _order = _order.copyWith(status: 'delivery_otp_pending'));
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed: $e'),
                          backgroundColor: AdminAppTheme.getErrorColor(context),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  } finally {
                    if (mounted) setState(() => _otpGenerating = false);
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

    if (order.status == 'delivery_otp_pending') {
      return _buildOtpVerificationSection(context, order);
    }

    if (buttons.isEmpty) {
      return Text(
        'No further action available',
        style: AdminTextStyles.caption(context),
      );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: buttons);
  }

  Widget _buildOtpVerificationSection(BuildContext context, Order order) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: AdminResponsive.cardPadding(context),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: cs.primary,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Delivery Verification Required',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp.clamp(14.0, 18.0),
                  color: cs.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Enter Customer OTP',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp.clamp(12.0, 16.0),
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp.clamp(20.0, 28.0),
              fontWeight: FontWeight.w700,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '_ _ _ _ _ _',
              hintStyle: TextStyle(
                fontSize: 24.sp.clamp(20.0, 28.0),
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
                color: AdminAppTheme.getTextSecondaryColor(context).withValues(alpha: 0.3),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AdminAppTheme.getBorderColor(context),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AdminAppTheme.getErrorColor(context),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            onChanged: (_) => setState(() => _otpError = null),
          ),
          if (_otpError != null) ...[
            SizedBox(height: 6.h),
            Text(
              _otpError!,
              style: TextStyle(
                color: AdminAppTheme.getErrorColor(context),
                fontSize: 12.sp.clamp(10.0, 13.0),
              ),
            ),
          ],
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _otpVerifying || _otpController.text.trim().length != 6
                  ? null
                  : () => _verifyOtp(context, order),
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminAppTheme.getSuccessColor(context),
                foregroundColor: AdminThemeTokens.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _otpVerifying
                  ? SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AdminThemeTokens.white,
                      ),
                    )
                  : const Icon(Icons.verified),
              label: Text(
                'Verify & Deliver',
                style: AdminTextStyles.button(context).copyWith(
                  color: AdminThemeTokens.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          _buildResendOtpButton(context, order),
        ],
      ),
    );
  }

  Widget _buildResendOtpButton(BuildContext context, Order order) {
    final bool canResend = _otpResendCountdown <= 0;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: canResend && !_otpVerifying
            ? () => _resendOtp(context, order)
            : null,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: canResend
                ? Theme.of(context).colorScheme.primary
                : AdminAppTheme.getBorderColor(context),
          ),
        ),
        icon: Icon(
          Icons.refresh,
          size: 18.sp,
          color: canResend
              ? Theme.of(context).colorScheme.primary
              : AdminAppTheme.getTextSecondaryColor(context),
        ),
        label: Text(
          canResend ? 'Resend OTP' : 'Resend OTP in 00:${_otpResendCountdown.toString().padLeft(2, '0')}',
          style: TextStyle(
            color: canResend
                ? Theme.of(context).colorScheme.primary
                : AdminAppTheme.getTextSecondaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp(BuildContext context, Order order) async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      setState(() => _otpError = 'Please enter a valid 6-digit OTP');
      return;
    }

    setState(() {
      _otpVerifying = true;
      _otpError = null;
    });

    try {
      await _orderController.verifyDeliveryOtp(order, otp);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Order delivered successfully!'),
            backgroundColor: AdminAppTheme.getSuccessColor(context),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        setState(() => _order = _order.copyWith(status: 'delivered'));
      }
    } on ArgumentError {
      if (mounted) {
        setState(() => _otpError = 'Invalid OTP. Please try again.');
      }
    } on StateError catch (e) {
      if (mounted) {
        setState(() => _otpError = e.message);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _otpError = 'Verification failed: $e');
      }
    } finally {
      if (mounted) setState(() => _otpVerifying = false);
    }
  }

  Future<void> _resendOtp(BuildContext context, Order order) async {
    setState(() => _otpError = null);
    try {
      await _orderController.resendDeliveryOtp(order);
      if (context.mounted) {
        _startResendCountdown();
        _otpController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('New OTP sent to customer.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } on StateError catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AdminAppTheme.getWarningColor(context),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend OTP: $e'),
            backgroundColor: AdminAppTheme.getErrorColor(context),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
    final cs = Theme.of(context).colorScheme;
    final color = AdminAppTheme.getOrderStatusColor(context, status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            status.replaceAll('_', ' ').toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp.clamp(9.0, 12.0),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedOrderItemWidgets(
    AdminGroupedOrderSections groupedItems,
  ) {
    return [
      if (groupedItems.bogoGroups.isNotEmpty) ...[
        _orderItemSectionTitle('BOGO Offers'),
        ...groupedItems.bogoGroups.map(_buildBogoOrderItem),
      ],
      if (groupedItems.comboGroups.isNotEmpty) ...[
        _orderItemSectionTitle('Combo Offers'),
        ...groupedItems.comboGroups.map(_buildComboOrderGroup),
      ],
      if (groupedItems.individualItems.isNotEmpty) ...[
        _orderItemSectionTitle('Individual Items'),
        ...groupedItems.individualItems.map(_buildOrderItemCard),
      ],
    ];
  }

  Widget _orderItemSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 13.sp.clamp(11.0, 14.0),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBogoOrderItem(AdminGroupedOrderItem group) {
    return _buildOrderItemCard(
      group.item,
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: group.freeItems
            .map(
              (item) => Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  'FREE: ${item.productName} x${item.quantity}',
                  style: TextStyle(
                    color: AdminAppTheme.getSuccessColor(context),
                    fontSize: 12.sp.clamp(10.0, 13.0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _buildComboOrderGroup(AdminGroupedOrderCombo group) {
    return Container(
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
          Text(
            '${group.name} x${group.bundleQuantity}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.sp.clamp(12.0, 16.0),
            ),
          ),
          SizedBox(height: 8.h),
          ...group.items.map(_buildOrderItemLine),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Combo total', style: AdminTextStyles.caption(context)),
              Text(
                '₹${group.discountedTotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemLine(OrderItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${item.productName}${item.variantLabel?.isNotEmpty == true ? ' (${item.variantLabel})' : ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AdminTextStyles.caption(context),
            ),
          ),
          SizedBox(width: 8.w),
          Text('x${item.quantity}', style: AdminTextStyles.caption(context)),
          SizedBox(width: 8.w),
          Text('₹${item.totalPrice.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildOrderItemCard(OrderItem item, {Widget? footer}) {
    return Container(
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
                        color: AdminAppTheme.getSubtleBorderColor(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        color: AdminAppTheme.getMutedIconColor(context),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp.clamp(12.0, 16.0),
                      ),
                    ),
                    if (item.variantLabel?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Variant: ${item.variantLabel}',
                          style: AdminTextStyles.caption(context),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${item.quantity}x',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AdminAppTheme.getSuccessColor(context),
                    ),
                  ),
                  Text(
                    _calculateTotalQuantity(item),
                    style: AdminTextStyles.caption(context),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${item.unitPrice.toStringAsFixed(2)} each',
                style: AdminTextStyles.caption(context),
              ),
              Text(
                '₹${item.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ?footer,
        ],
      ),
    );
  }

  String _calculateTotalQuantity(OrderItem item) {
    if (item.variantLabel == null || item.variantLabel!.isEmpty) {
      return '${item.quantity}x';
    }
    final variantRegex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = variantRegex.firstMatch(item.variantLabel!);

    if (match != null) {
      final variantQuantity = double.parse(match.group(1)!);
      final totalQty = variantQuantity * item.quantity;

      final unitMatch = RegExp(r'(\w+)$').firstMatch(item.variantLabel!);
      final unit = unitMatch?.group(1) ?? '';

      if (totalQty >= 1000 && unit.toLowerCase() == 'gm') {
        return '${(totalQty / 1000).toStringAsFixed(totalQty % 1000 == 0 ? 0 : 1)} kg';
      }

      return '${totalQty.toStringAsFixed(totalQty % 1 == 0 ? 0 : 1)} $unit';
    }

    return '${item.quantity}x';
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
                ? '-₹${(-value).toStringAsFixed(2)}'
                : '₹${value.toStringAsFixed(2)}',
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

  void _launchPhoneCall(String phone) async {
    final uri = Uri.parse('tel:${phone.replaceAll(RegExp(r'[^\d+]'), '')}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch phone dialer'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: AdminResponsive.cardPadding(context),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
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
                color: cs.onSurface.withValues(alpha: 0.5),
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
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    this.subtitle,
    this.onCopy,
    this.onCall,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onCopy;
  final VoidCallback? onCall;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18.sp.clamp(16.0, 20.0),
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: subtitle == null
                ? Text(
                    label,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AdminTextStyles.body(context),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AdminTextStyles.body(context),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AdminTextStyles.caption(context),
                        ),
                    ],
                  ),
          ),
          if (onCall != null)
            SizedBox(
              width: 32.r,
              height: 32.r,
              child: IconButton(
                icon: Icon(
                  Icons.phone,
                  size: 18,
                  color: cs.primary,
                ),
                onPressed: onCall,
                tooltip: 'Call',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          if (onCopy != null)
            SizedBox(
              width: 32.r,
              height: 32.r,
              child: IconButton(
                icon: Icon(
                  Icons.copy,
                  size: 18,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
                onPressed: onCopy,
                tooltip: 'Copy',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
        ],
      ),
    );
  }
}
