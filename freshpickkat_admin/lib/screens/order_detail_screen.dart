import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:freshpickkat_admin/controller/admin_order_controller.dart';
import 'package:freshpickkat_admin/services/admin_snackbar_service.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/utils/order_item_grouping.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/tracking/screens/live_delivery_map_preview_screen.dart'
    deferred as live_delivery_map_preview_screen;
import 'package:freshpickkat_admin/utils/deferred_navigation.dart';
import 'package:freshpickkat_admin/widgets/refund_info_card.dart';
import 'package:freshpickkat_admin/screens/delivery_photo_verification_screen.dart';

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
  bool _refundLoading = false;
  bool _refundRetrying = false;
  RefundRecord? _refund;
  final AdminOrderController _orderController = AdminOrderController.instance;
  PaymentSessionData? _qrSession;
  bool _showQrSection = false;
  Timer? _pollTimer;
  Timer? _countdownTimer;
  int _localExpiresInSeconds = 0;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
    _loadRefund();
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
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadRefund() async {
    if (_order.refundStatus == 'none') return;
    setState(() => _refundLoading = true);
    try {
      _refund = await _orderController.getRefundStatus(_order.orderId);
    } catch (_) {}
    if (mounted) setState(() => _refundLoading = false);
  }

  Future<void> _retryRefund() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Retry Refund'),
        content: const Text(
          'This will attempt to process the refund again. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminAppTheme.getErrorColor(context),
              foregroundColor: AdminThemeTokens.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _refundRetrying = true);
    try {
      final result = await _orderController.retryRefund(_order.orderId);
      if (mounted) {
        if (result.status == 'failed') {
          debugPrint(
            'Refund retry failed for order ${_order.orderId}: ${result.failureReason}',
          );
          AdminSnackbarService.show(context, 'Refund failed: ${result.failureReason ?? "Unknown error"}');
        } else {
          setState(() {
            _refund = result;
            _order = _order.copyWith(refundStatus: result.status);
          });
          AdminSnackbarService.show(context, 'Refund retried successfully. Amount: ₹${result.amount.toStringAsFixed(2)}');
        }
      }
    } catch (e) {
      debugPrint('Refund retry exception for order ${_order.orderId}: $e');
      if (mounted) {
        AdminSnackbarService.show(context, 'Refund retry: $e');
      }
    } finally {
      if (mounted) setState(() => _refundRetrying = false);
    }
  }

  Future<void> _onRefresh() async {
    try {
      // Attempt on-demand UPI QR payment recovery for eligible orders
      final recoveredOrder = await _orderController.recoverQrPayment(
        _order.orderId,
      );
      if (recoveredOrder != null && recoveredOrder.paymentStatus == 'paid') {
        if (mounted) {
          setState(() => _order = recoveredOrder);
        }
      }

      await _orderController.loadInitial(force: true);
      final updated = _orderController.orders
          .where((o) => o.orderId == _order.orderId)
          .firstOrNull;
      if (updated != null && mounted) {
        setState(() => _order = updated);
      }
      await _loadRefund();
    } catch (_) {}
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
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                  if (order.paymentMode == 'cod' && order.paymentCollectedAt != null) ...[
                    _DetailRow(
                      icon: Icons.payments_outlined,
                      label: 'COD: ₹${order.finalAmount.toStringAsFixed(2)}',
                    ),
                    _DetailRow(
                      icon: Icons.person_outline,
                      label: 'Collected by: ${order.paymentCollectedBy ?? 'N/A'}',
                    ),
                    _DetailRow(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Mode: ${order.paymentCollectionMode == 'cash' ? 'Cash' : 'UPI QR'}',
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: TextButton.icon(
                        onPressed: _showCodPaymentReceipt,
                        icon: Icon(Icons.receipt_long, size: 18.sp),
                        label: Text(
                          'View Receipt',
                          style: TextStyle(fontSize: 13.sp.clamp(11.0, 14.0)),
                        ),
                      ),
                    ),
                  ],
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
                        color: AdminAppTheme.getTextSecondaryColor(context),
                      ),
                    )
                  else
                    ..._buildGroupedOrderItemWidgets(groupedItems, order),
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
                      order.mrpTotal > 0 ? order.mrpTotal : order.totalAmount,
                    ),
                    if (order.productDiscountAmount > 0)
                      _amountRow(
                        'Product Discount',
                        -order.productDiscountAmount,
                      ),
                    if (order.comboDiscountAmount > 0)
                      _amountRow('Combo Savings', -order.comboDiscountAmount),
                    if (order.bogoDiscountAmount > 0)
                      _amountRow('BOGO Savings', -order.bogoDiscountAmount),
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
                    if (order.freshPointsUsed > 0)
                      _amountRow(
                        'FreshPoints Used (${order.freshPointsUsed})',
                        -order.freshPointsValue,
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: const Divider(),
                    ),
                    _amountRow('To Pay', order.finalAmount, isBold: true),
                    if (order.freshPointsUsed > 0)
                      _amountRow('Paid via UPI/Card', order.actualPaymentAmount, isBold: true),
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
              if (order.status == 'delivered') ...[
                SizedBox(height: 12.h),
                _DeliveryProofSection(order: order),
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
                                color: AdminAppTheme.getErrorColor(context),
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
              if (order.paymentMode == 'cod' &&
                  order.codFailureReason != null &&
                  order.codFailureReason!.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: AdminResponsive.cardPadding(context),
                  decoration: BoxDecoration(
                    color: AdminAppTheme.getErrorContainerColor(context),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AdminAppTheme.getErrorColor(context)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        color: AdminAppTheme.getErrorColor(context),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'COD Delivery Failure',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AdminAppTheme.getErrorColor(context),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Reason: ${_codFailureReasonLabel(order.codFailureReason)}',
                              style: AdminTextStyles.caption(context),
                            ),
                            if (order.cancelledAt != null) ...[
                              SizedBox(height: 2.h),
                              Text(
                                'Failed at: ${_formatDate(order.cancelledAt)}',
                                style: AdminTextStyles.caption(context),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (order.refundStatus != 'none') ...[
                SizedBox(height: 12.h),
                if (_refundLoading)
                  _DetailSection(
                    title: 'Refund Info',
                    icon: Icons.monetization_on_outlined,
                    children: [
                      _DetailRow(
                        icon: Icons.info_outline,
                        label: 'Loading refund details...',
                      ),
                    ],
                  )
                else if (_refund != null)
                  RefundInfoCard(
                    refund: _refund!,
                    retryButton: _refund!.status == 'failed'
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _refundRetrying ? null : _retryRefund,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AdminAppTheme.getErrorColor(
                                  context,
                                ),
                                foregroundColor: AdminThemeTokens.white,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: _refundRetrying
                                  ? SizedBox(
                                      width: 18.sp,
                                      height: 18.sp,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AdminThemeTokens.white,
                                      ),
                                    )
                                  : const Icon(Icons.refresh),
                              label: Text(
                                _refundRetrying
                                    ? 'Retrying...'
                                    : 'Retry Refund',
                              ),
                            ),
                          )
                        : null,
                  )
                else
                  _DetailSection(
                    title: 'Refund Info',
                    icon: Icons.monetization_on_outlined,
                    children: [
                      _DetailRow(
                        icon: Icons.info_outline,
                        label:
                            'Refund Status: ${order.refundStatus.toUpperCase()}',
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
                      setState(
                        () => _order = _order.copyWith(status: 'confirmed'),
                      );
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
                      setState(
                        () => _order = _order.copyWith(status: 'packed'),
                      );
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
                      setState(
                        () => _order = _order.copyWith(
                          status: 'out_for_delivery',
                        ),
                      );
                    }
                  } finally {
                    if (mounted) setState(() => _isLoading = false);
                  }
                },
        ),
      );
    } else if (order.status == 'out_for_delivery') {
      if (order.paymentMode == 'cod' && order.paymentStatus != 'paid') {
        if (_showQrSection) {
          return _buildQrSection(context, order);
        }
        return _buildCodPaymentCollectionSection(context, order);
      }
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'Photo Delivery',
          color: primaryColor,
          icon: Icons.camera_alt_outlined,
          isLoading: _isLoading,
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  try {
                    await _orderController.markDeliveryPhotoPending(order);
                    if (mounted) {
                      setState(() {
                        _order = _order.copyWith(
                          status: 'delivery_photo_pending',
                          deliveryVerificationMethod: 'photo',
                        );
                      });
                    }
                    } catch (e) {
                    if (mounted) {
                      AdminSnackbarService.show(context, 'Failed to start photo delivery: $e');
                    }
                    if (mounted) setState(() => _isLoading = false);
                    return;
                  }
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeliveryPhotoVerificationScreen(order: order),
                    ),
                  );
                  if (mounted) setState(() => _isLoading = false);
                  if (result == true && mounted) {
                    setState(() {
                      _order = _order.copyWith(
                        status: 'delivered',
                        deliveryVerificationMethod: 'photo',
                        deliveredByRole: 'admin',
                        deliveryCompletedAt: DateTime.now(),
                      );
                    });
                  }
                },
        ),
      );
      buttons.add(
        _lifecycleButton(
          context: context,
          label: 'OTP Delivery',
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
                      AdminSnackbarService.show(context, 'Delivery OTP sent to customer. Waiting for verification.');
                      setState(
                        () => _order = _order.copyWith(
                          status: 'delivery_otp_pending',
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      AdminSnackbarService.show(context, 'Failed: $e');
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
          onPressed: () async {
            await navigateDeferred(
              loadLibrary: live_delivery_map_preview_screen.loadLibrary,
              pageBuilder: () =>
                  live_delivery_map_preview_screen.LiveDeliveryMapPreviewScreen(
                    order: order,
                  ),
            );
          },
        ),
      );

      // Mark Delivery Failed for COD orders
      if (order.paymentMode == 'cod' && order.paymentStatus == 'paid') {
        buttons.add(
          _lifecycleButton(
            context: context,
            label: 'Mark Delivery Failed',
            color: Colors.red,
            icon: Icons.cancel_outlined,
            isLoading: _isLoading,
            onPressed: _isLoading
                ? null
                : () => _showCodDeliveryFailedDialog(context, order),
          ),
        );
      }
    }

    if (order.status == 'delivery_otp_pending') {
      return _buildOtpVerificationSection(context, order);
    }

    if (order.status == 'delivery_photo_pending') {
      return _buildPhotoPendingSection(context, order);
    }

    if (buttons.isEmpty) {
      return Text(
        'No further action available',
        style: AdminTextStyles.caption(context),
      );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: buttons);
  }

  Widget _buildCodPaymentCollectionSection(
      BuildContext context, Order order) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: AdminResponsive.cardPadding(context),
      decoration: BoxDecoration(
        color: AdminAppTheme.getWarningContainerColor(context),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AdminAppTheme.getWarningColor(context).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                color: AdminAppTheme.getWarningColor(context),
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Collect COD Payment',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp.clamp(14.0, 18.0),
                  color: AdminAppTheme.getWarningColor(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Collect ₹${order.finalAmount.toStringAsFixed(2)} before delivery.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp.clamp(12.0, 16.0),
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _collectCodPayment(context, order, 'cash'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminAppTheme.getSuccessColor(context),
                    foregroundColor: AdminThemeTokens.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.money),
                  label: Text(
                    'Cash',
                    style: AdminTextStyles.button(context)
                        .copyWith(color: AdminThemeTokens.white),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _startQrPaymentSession(context, order),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: AdminThemeTokens.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.qr_code_scanner),
                  label: Text(
                    'UPI QR',
                    style: AdminTextStyles.button(context)
                        .copyWith(color: AdminThemeTokens.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
                color: AdminAppTheme.getTextSecondaryColor(
                  context,
                ).withValues(alpha: 0.3),
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
                style: AdminTextStyles.button(
                  context,
                ).copyWith(color: AdminThemeTokens.white),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          _buildResendOtpButton(context, order),
        ],
      ),
    );
  }

  Widget _buildPhotoPendingSection(BuildContext context, Order order) {
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
                Icons.camera_alt_outlined,
                color: cs.primary,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Photo Verification',
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
            'Photo verification is in progress.',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp.clamp(12.0, 16.0),
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please take a photo of the delivery to complete verification.',
            style: TextStyle(
              fontSize: 13.sp.clamp(11.0, 15.0),
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        DeliveryPhotoVerificationScreen(order: order),
                  ),
                );
                if (result == true && mounted) {
                  setState(() {
                    _order = _order.copyWith(
                      status: 'delivered',
                      deliveryVerificationMethod: 'photo',
                      deliveredByRole: 'admin',
                      deliveryCompletedAt: DateTime.now(),
                    );
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: AdminThemeTokens.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(
                'Continue Photo Verification',
                style: AdminTextStyles.button(context)
                    .copyWith(color: AdminThemeTokens.white),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                try {
                  await _orderController.cancelDeliveryPhotoPending(order);
                  if (mounted) {
                    setState(() {
                      _order = _order.copyWith(
                        status: 'out_for_delivery',
                        deliveryVerificationMethod: null,
                      );
                    });
                    AdminSnackbarService.show(context, 'Photo verification cancelled.');
                  }
                } catch (e) {
                  if (mounted) {
                    AdminSnackbarService.show(context, 'Failed: $e');
                  }
                }
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: AdminAppTheme.getErrorColor(context)),
                foregroundColor: AdminAppTheme.getErrorColor(context),
              ),
              icon: const Icon(Icons.close),
              label: const Text('Cancel Photo Verification'),
            ),
          ),
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
          canResend
              ? 'Resend OTP'
              : 'Resend OTP in 00:${_otpResendCountdown.toString().padLeft(2, '0')}',
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

  Future<void> _collectCodPayment(
      BuildContext context, Order order, String mode) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(mode == 'cash' ? 'Collect Cash' : 'Collect via UPI QR'),
        content: Text(
          'Confirm ₹${order.finalAmount.toStringAsFixed(2)} '
          '${mode == 'cash' ? 'cash' : 'UPI QR'} payment collection?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminAppTheme.getSuccessColor(context),
              foregroundColor: AdminThemeTokens.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await _orderController.collectCodPayment(order, mode);
      if (context.mounted) {
        AdminSnackbarService.show(
          context,
          '₹${order.finalAmount.toStringAsFixed(2)} collected successfully.',
        );
        setState(() {
          _order = _order.copyWith(
            paymentStatus: 'paid',
            paymentCollectedAt: DateTime.now(),
            paymentCollectedBy: 'You',
            paymentCollectionMode: mode,
          );
        });
      }
    } catch (e) {
      if (context.mounted) {
        AdminSnackbarService.show(context, 'Payment collection failed: $e');
      }
    }
  }

  Future<void> _startQrPaymentSession(
    BuildContext context,
    Order order,
  ) async {
    setState(() => _isLoading = true);
    try {
      final session = await _orderController.createQrPaymentSession(
        order.orderId,
      );
      if (session != null && mounted) {
        setState(() {
          _qrSession = session;
          _localExpiresInSeconds = session.expiresInSeconds ?? 0;
          _showQrSection = true;
        });
        _startPolling(context);
        if (session.status == 'PAID') {
          _handleQrPaid(context, order, session);
        }
      } else {
        if (mounted) {
          AdminSnackbarService.show(
            context,
            'Failed to create QR session',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AdminSnackbarService.show(
          context,
          'Failed to start QR payment: $e',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startPolling(BuildContext context) {
    _pollTimer?.cancel();
    _countdownTimer?.cancel();
    final orderId = _order.orderId;

    // Sync local countdown from server on each poll
    void syncCountdown(PaymentSessionData session) {
      setState(() {
        _qrSession = session;
        _localExpiresInSeconds = session.expiresInSeconds ?? 0;
      });
    }

    // Local 1-second countdown timer for smooth UI
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        _countdownTimer?.cancel();
        return;
      }
      setState(() {
        if (_localExpiresInSeconds > 0) {
          _localExpiresInSeconds--;
        }
      });
      // Local expiry: if countdown hit 0 but server still says ACTIVE
      if (_localExpiresInSeconds <= 0 &&
          _qrSession?.status == 'ACTIVE' &&
          mounted) {
        _pollTimer?.cancel();
        _countdownTimer?.cancel();
        setState(() {
          _qrSession = _qrSession?.copyWith(
            status: 'EXPIRED',
            expiresInSeconds: 0,
          );
        });
      }
    });

    // Server poll every 5 seconds as fallback (primary: webhook pub/sub)
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!mounted) {
        _pollTimer?.cancel();
        return;
      }
      try {
        final session = await _orderController.getQrPaymentSession(orderId);
        if (session == null || !mounted) return;

        syncCountdown(session);

        if (session.status == 'PAID') {
          _pollTimer?.cancel();
          _countdownTimer?.cancel();
          _handleQrPaid(context, _order, session);
        } else if (session.status == 'EXPIRED' ||
            session.status == 'CANCELLED' ||
            session.status == 'FAILED') {
          _pollTimer?.cancel();
          _countdownTimer?.cancel();
          // Grace check: wait 3s in case webhook fires just after expiry
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted && _qrSession?.status != 'PAID') {
              setState(() {});
            }
          });
        }
      } catch (_) {}
    });
  }

  void _handleQrPaid(
    BuildContext context,
    Order order,
    PaymentSessionData session,
  ) {
    setState(() {
      _showQrSection = false;
      _qrSession = null;
      _order = order.copyWith(
        paymentStatus: 'paid',
        paymentCollectedAt: session.paidAt ?? DateTime.now(),
        paymentCollectedBy: 'You',
        paymentCollectionMode: 'upi_qr',
      );
    });
    AdminSnackbarService.show(context, 'Payment received via UPI QR!');
  }

  Future<void> _regenerateQr(BuildContext context, Order order) async {
    setState(() => _isLoading = true);
    try {
      final session = await _orderController.regenerateQrPaymentSession(
        order.orderId,
      );
      if (session != null && mounted) {
        setState(() {
          _qrSession = session;
          _localExpiresInSeconds = session.expiresInSeconds ?? 0;
          _showQrSection = true;
        });
        _startPolling(context);
      }
    } catch (e) {
      if (mounted) {
        AdminSnackbarService.show(
          context,
          'Failed to regenerate QR: $e',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshQrSession(BuildContext context) async {
    try {
      final session = await _orderController.getQrPaymentSession(
        _order.orderId,
      );
      if (session != null && mounted) {
        setState(() => _qrSession = session);
      }
    } catch (_) {}
  }

  Widget _buildQrSection(BuildContext context, Order order) {
    final cs = Theme.of(context).colorScheme;
    final session = _qrSession;
    final status = session?.status ?? 'CREATED';
    final qrImageUrl = session?.qrImageUrl ?? '';
    final minutes = (_localExpiresInSeconds / 60).floor();
    final seconds = _localExpiresInSeconds % 60;
    final qrSize = MediaQuery.of(context).size.width - 48;

    return Container(
      width: double.infinity,
      padding: AdminResponsive.cardPadding(context),
      decoration: BoxDecoration(
        color: AdminAppTheme.getWarningContainerColor(context),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AdminAppTheme.getWarningColor(context).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: cs.primary,
                  size: 22.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Online Payment (UPI QR)',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp.clamp(14.0, 18.0),
                    color: cs.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              'Amount: ₹${order.finalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp.clamp(12.0, 16.0),
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            if (status == 'ACTIVE' || status == 'CREATED') ...[
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Status: ACTIVE',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                'Expires in: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 16.h),
              if (qrImageUrl.isNotEmpty)
                Center(
                  child: Container(
                    width: qrSize,
                    height: qrSize + 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: InteractiveViewer(
                        constrained: true,
                        minScale: 0.5,
                        maxScale: 5.0,
                        child: Image.network(
                          qrImageUrl,
                          width: qrSize,
                          height: qrSize + 100,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            width: qrSize,
                            height: qrSize + 100,
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.qr_code,
                              size: 100.sp,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: cs.primary),
                      SizedBox(height: 8.h),
                      Text(
                        'Generating QR...',
                        style: TextStyle(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16.h),
              Center(
                child: TextButton.icon(
                  onPressed: () => _refreshQrSession(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ),
            ] else if (status == 'PAID') ...[
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 22.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Payment Received',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ] else if (status == 'EXPIRED' || status == 'CANCELLED' || status == 'FAILED') ...[
              Row(
                children: [
                  Icon(Icons.timer_off, color: Colors.orange, size: 22.sp),
                  SizedBox(width: 8.w),
                  Text(
                    status == 'EXPIRED' ? 'QR Expired' : 'Session $status',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => _regenerateQr(context, order),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Regenerate QR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: AdminThemeTokens.white,
                  ),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            Center(
              child: Text(
                'Customer scans with GPay / PhonePe / Paytm / BHIM',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
    );
  }

  static const _codFailureReasons = [
    'CUSTOMER_REFUSED',
    'CUSTOMER_UNAVAILABLE',
    'PAYMENT_REFUSED',
    'ADDRESS_NOT_FOUND',
    'DELIVERY_FAILED',
    'OTHER',
  ];

  static const _codFailureReasonLabels = {
    'CUSTOMER_REFUSED': 'Customer Refused',
    'CUSTOMER_UNAVAILABLE': 'Customer Unavailable',
    'PAYMENT_REFUSED': 'Payment Refused',
    'ADDRESS_NOT_FOUND': 'Address Not Found',
    'DELIVERY_FAILED': 'Delivery Failed',
    'OTHER': 'Other',
  };

  String _codFailureReasonLabel(String? reason) {
    if (reason == null) return '';
    return _codFailureReasonLabels[reason] ?? reason;
  }

  Future<void> _showCodDeliveryFailedDialog(
      BuildContext context, Order order) async {
    String? selectedReason;
    final noteController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Mark Delivery Failed'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Record a COD delivery failure. This will cancel the order '
                  'and may restrict the customer\'s COD access.',
                ),
                const SizedBox(height: 16),
                const Text('Failure Reason',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedReason,
                  decoration: const InputDecoration(
                    hintText: 'Select reason',
                    border: OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  items: _codFailureReasons.map((r) => DropdownMenuItem(
                    value: r,
                    child: Text(_codFailureReasonLabel(r)),
                  )).toList(),
                  onChanged: (v) => setDialogState(() => selectedReason = v),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note (optional)',
                    hintText: 'Additional details...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedReason == null
                  ? null
                  : () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Mark Failed'),
            ),
          ],
        ),
      ),
    );

    if (result != true || selectedReason == null) return;

    try {
      await _orderController.markCodDeliveryFailed(
        order,
        selectedReason!,
        failureNote: noteController.text.trim().isEmpty
            ? null
            : noteController.text.trim(),
      );
      if (context.mounted) {
        AdminSnackbarService.show(
          context,
          'Delivery marked as failed: ${_codFailureReasonLabel(selectedReason)}',
        );
        setState(() {
          _order = _order.copyWith(
            status: 'cancelled',
            cancellationReason: 'COD_DELIVERY_FAILURE: $selectedReason',
            codFailureReason: selectedReason,
            cancelledAt: DateTime.now(),
          );
        });
      }
    } catch (e) {
      if (context.mounted) {
        AdminSnackbarService.show(
          context,
          'Failed to record COD failure: $e',
        );
      }
    }
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
        AdminSnackbarService.show(context, 'Order delivered successfully!');
        setState(() {
          _order = _order.copyWith(
            status: 'delivered',
            deliveryVerificationMethod: 'otp',
            deliveredByRole: 'admin',
            deliveryCompletedAt: DateTime.now(),
          );
        });
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
        AdminSnackbarService.show(context, 'New OTP sent to customer.');
      }
    } on StateError catch (e) {
      if (context.mounted) {
        AdminSnackbarService.show(context, e.message);
      }
    } catch (e) {
      if (context.mounted) {
        AdminSnackbarService.show(context, 'Failed to resend OTP: $e');
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
    Order order,
  ) {
    final smgmItems = <OrderItem>[];
    final orphanedPaidItems = <OrderItem>[];
    final bogoGroups = groupedItems.bogoGroups.map((g) {
      final nonSmgm = g.freeItems
          .where((f) => f.rewardSource != 'SHOP_MORE_GET_MORE')
          .toList();
      smgmItems.addAll(
        g.freeItems.where((f) => f.rewardSource == 'SHOP_MORE_GET_MORE'),
      );
      return AdminGroupedOrderItem(item: g.item, freeItems: nonSmgm);
    }).where((g) {
      if (g.freeItems.isEmpty) orphanedPaidItems.add(g.item);
      return g.freeItems.isNotEmpty;
    }).toList();

    smgmItems.addAll(
      groupedItems.individualItems
          .where((i) => i.rewardSource == 'SHOP_MORE_GET_MORE'),
    );
    final combinedItems = [
      ...orphanedPaidItems,
      ...groupedItems.individualItems
          .where((i) => i.rewardSource != 'SHOP_MORE_GET_MORE'),
    ];
    smgmItems.addAll(
      combinedItems.where((i) => i.isFreeItem),
    );
    combinedItems.removeWhere((i) => i.isFreeItem);
    final hasProductLevelFreeDelivery =
        combinedItems.any((i) => (i.isFreeDelivery ?? false) && !i.isFreeItem);
    final orderLevelFreeDelivery =
        order.freeDeliveryApplied && !hasProductLevelFreeDelivery;
    final freeDeliveryItems = orderLevelFreeDelivery
        ? combinedItems.where((i) => !i.isFreeItem).toList()
        : combinedItems
            .where((i) => (i.isFreeDelivery ?? false) && !i.isFreeItem)
            .toList();
    final otherItems = combinedItems
        .where((i) => !freeDeliveryItems.contains(i))
        .toList();

    return [
      if (bogoGroups.isNotEmpty) ...[
        _orderItemSectionTitle('BOGO Offers'),
        ...bogoGroups.map(_buildBogoOrderItem),
      ],
      if (smgmItems.isNotEmpty) ...[
        _orderItemSectionTitle('SMGM Free Gifts'),
        ...smgmItems.map(
          (item) => _buildOrderItemCard(
            item.copyWith(
              variantLabel: item.rewardOfferName?.isNotEmpty == true &&
                      item.variantLabel?.isNotEmpty == true
                  ? '${item.rewardOfferName} - ${item.variantLabel}'
                  : item.variantLabel,
            ),
            footer: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AdminAppTheme.getSuccessColor(context),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'FREE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp.clamp(8.0, 11.0),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (item.rewardOfferName?.isNotEmpty == true)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      'Unlocked via ${item.rewardOfferName}',
                      style: TextStyle(
                        fontSize: 11.sp.clamp(10.0, 12.0),
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
      if (freeDeliveryItems.isNotEmpty) ...[
        _orderItemSectionTitle('Free Delivery Product'),
        ...freeDeliveryItems.map(_buildOrderItemCard),
      ],
      if (groupedItems.comboGroups.isNotEmpty) ...[
        _orderItemSectionTitle('Combo Offers'),
        ...groupedItems.comboGroups.map(_buildComboOrderGroup),
      ],
      if (otherItems.isNotEmpty) ...[
        _orderItemSectionTitle('Individual Items'),
        ...otherItems.map(_buildOrderItemCard),
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
    return Column(
      children: [
        _buildOrderItemCard(group.item),
        ...group.freeItems.map(
          (item) => _buildOrderItemCard(
            item,
            footer: Container(
              margin: EdgeInsets.only(top: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AdminAppTheme.getSuccessColor(context),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'FREE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp.clamp(8.0, 11.0),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
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

  Future<void> _showCodPaymentReceipt() async {
    try {
      final receipt = await _orderController.getCodPaymentReceipt(widget.order.orderId);
      if (!mounted || receipt == null) return;

      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Payment Receipt',
                  style: TextStyle(
                    fontSize: 18.sp.clamp(16.0, 20.0),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              const Divider(),
              _receiptRow('Order Number', receipt.orderNumber),
              _receiptRow('Payment Method', receipt.paymentMethod),
              _receiptRow(
                'Collection Method',
                receipt.collectionMethod == 'cash' ? 'Cash' : 'UPI QR',
              ),
              _receiptRow(
                'Amount Collected',
                '₹${receipt.amountCollected.toStringAsFixed(2)}',
              ),
              if (receipt.collectionTime != null)
                _receiptRow(
                  'Collection Time',
                  '${_formatDate(receipt.collectionTime)} ${_formatTime(receipt.collectionTime)}',
                ),
              if (receipt.collectedBy != null)
                _receiptRow('Collected By', receipt.collectedBy!),
              _receiptRow('Payment Status', receipt.paymentStatus),
              if (receipt.gatewayTransactionReference != null)
                _receiptRow(
                  'Transaction Ref',
                  receipt.gatewayTransactionReference!,
                ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        AdminSnackbarService.show(context, 'Failed to load receipt: $e');
      }
    }
  }

  Widget _receiptRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    return formatDate(dateTime);
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
    AdminSnackbarService.show(context, '$label copied');
  }

  void _launchPhoneCall(String phone) async {
    final uri = Uri.parse('tel:${phone.replaceAll(RegExp(r'[^\d+]'), '')}');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!mounted) return;
      AdminSnackbarService.show(context, 'Could not launch phone dialer');
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

class _DeliveryProofSection extends StatefulWidget {
  const _DeliveryProofSection({required this.order});

  final Order order;

  @override
  State<_DeliveryProofSection> createState() => _DeliveryProofSectionState();
}

class _DeliveryProofSectionState extends State<_DeliveryProofSection> {
  bool _showPhoto = false;

  Order get order => widget.order;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final method = order.deliveryVerificationMethod ?? 'otp';
    final isPhoto = method == 'photo';

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
                Icons.check_circle,
                size: 20.sp.clamp(18.0, 22.0),
                color: AdminAppTheme.getSuccessColor(context),
              ),
              Text(
                'Delivery Completed',
                style: AdminTextStyles.sectionTitle(context).copyWith(
                  color: AdminAppTheme.getSuccessColor(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildRow(context, Icons.verified_user_outlined, 'Verification',
              isPhoto ? 'Photo Proof' : 'OTP'),
          if (order.deliveredByName != null &&
              order.deliveredByName!.isNotEmpty)
            _buildRow(context, Icons.person_pin, 'Delivered By',
                order.deliveredByName!),
          if (order.deliveryCompletedAt != null)
            _buildRow(context, Icons.access_time, 'Delivered At',
                formatDate(order.deliveryCompletedAt!)),
          if (order.deliveredByRole != null)
            _buildRow(
                context, Icons.badge_outlined, 'Role', order.deliveredByRole!),
          if (isPhoto && order.deliveryProofDistanceMeters != null)
            _buildRow(context, Icons.straighten, 'Distance From Address',
                '${order.deliveryProofDistanceMeters!.toStringAsFixed(0)} meters'),
          if (isPhoto && order.deliveryProofGpsAccuracy != null)
            _buildRow(context, Icons.satellite_alt, 'GPS Accuracy',
                '${order.deliveryProofGpsAccuracy!.toStringAsFixed(1)}m'),
          if (isPhoto &&
              order.deliveryProofLatitude != null &&
              order.deliveryProofLongitude != null)
            _buildRow(
              context,
              Icons.location_on_outlined,
              'Proof Coordinates',
              '${order.deliveryProofLatitude!.toStringAsFixed(6)}, '
                  '${order.deliveryProofLongitude!.toStringAsFixed(6)}',
            ),
          if (isPhoto && order.deliveryProofImageUrl != null &&
              order.deliveryProofImageUrl!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            if (_showPhoto) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: GestureDetector(
                  onTap: () => _showFullImage(context, order.deliveryProofImageUrl!),
                  child: Image.network(
                    order.deliveryProofImageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: cs.surfaceContainerHighest,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.broken_image,
                                size: 32, color: cs.onSurfaceVariant),
                            SizedBox(height: 4),
                            Text('Image unavailable',
                                style: TextStyle(color: cs.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Tap to view full image',
                style: TextStyle(
                  fontSize: 12.sp.clamp(10.0, 13.0),
                  color: cs.primary,
                ),
              ),
            ] else ...[
              OutlinedButton.icon(
                onPressed: () => setState(() => _showPhoto = true),
                icon: const Icon(Icons.image_outlined),
                label: const Text('Show Photo'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 18.sp.clamp(16.0, 20.0),
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp.clamp(10.0, 13.0),
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AdminTextStyles.body(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: const Text('Delivery Proof'),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Center(
                  child: Text('Failed to load image',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String formatDate(DateTime? dateTime) {
  if (dateTime == null) return 'N/A';
  return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}';
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
                icon: Icon(Icons.phone, size: 18, color: cs.primary),
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
