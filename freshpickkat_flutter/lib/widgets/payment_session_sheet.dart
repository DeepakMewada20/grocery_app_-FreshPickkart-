import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/services/payment_link_service.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:share_plus/share_plus.dart';

class PaymentSessionSheet extends StatefulWidget {
  final String orderId;
  final double amount;

  const PaymentSessionSheet({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  State<PaymentSessionSheet> createState() => _PaymentSessionSheetState();
}

class _PaymentSessionSheetState extends State<PaymentSessionSheet> {
  String? _paymentLinkUrl;
  String? _linkError;
  bool _isGeneratingLink = false;
  Map<String, dynamic>? _sessionStatus;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchSessionStatus();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchSessionStatus() async {
    try {
      final status = await PaymentLinkService.instance.getPaymentSessionStatus(
        widget.orderId,
      );
      if (status['error'] != null) return;
      setState(() => _sessionStatus = status);
    } catch (_) {}
  }

  Future<void> _generateLink() async {
    setState(() {
      _isGeneratingLink = true;
      _linkError = null;
    });

    try {
      final authController = AuthController.instance;
      final firebaseUid = authController.currentUser?.uid ?? '';
      final idToken = await authController.requireIdToken();
      final result = await PaymentLinkService.instance.getOrCreatePaymentLink(
        widget.orderId,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );

      if (result['success'] == true) {
        setState(() {
          _paymentLinkUrl = result['paymentLink'] as String?;
          _isGeneratingLink = false;
        });
        await _fetchSessionStatus();
      } else {
        setState(() {
          _linkError = result['error'] as String? ?? 'Failed to create link';
          _isGeneratingLink = false;
        });
      }
    } catch (e) {
      setState(() {
        _linkError = e.toString();
        _isGeneratingLink = false;
      });
    }
  }

  Future<void> _shareLink() async {
    if (_paymentLinkUrl == null) {
      await _generateLink();
    }
    if (_paymentLinkUrl != null && mounted) {
      await Share.share(
        'Pay for your order ${widget.orderId}: $_paymentLinkUrl',
      );
    }
  }

  Future<void> _copyLink() async {
    if (_paymentLinkUrl == null) {
      await _generateLink();
    }
    if (_paymentLinkUrl != null && mounted) {
      await Clipboard.setData(ClipboardData(text: _paymentLinkUrl!));
      if (mounted) {
        Get.snackbar(
          'Link Copied',
          'Payment link copied to clipboard',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _fetchSessionStatus();
      if (_sessionStatus?['paymentStatus'] == 'paid') {
        _refreshTimer?.cancel();
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final amountText = '₹${widget.amount.formatPrice}';
    final expiresIn = _sessionStatus?['expiresInSeconds'] as int? ?? 1800;
    final minutes = expiresIn ~/ 60;
    final seconds = expiresIn % 60;
    final isPaid = _sessionStatus?['paymentStatus'] == 'paid';

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: AppResponsive.sheetConstraints(context),
          child: Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            child: Padding(
              padding: AppSpacing.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: cs.outlineVariant,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Title
                  Text(
                    'Payment Session',
                    style: AppText.sectionTitle(context),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.h),

                  // Amount
                  Text(
                    amountText,
                    style: AppText.sectionTitle(context).copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),

                  // Order ID
                  Text(
                    'Order #${widget.orderId}',
                    style: AppText.caption(context).copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),

                  // Timer
                  if (!isPaid)
                    Container(
                      padding: AppSpacing.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: cs.errorContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Icon(
                            Icons.timer_outlined,
                            size: AppIcons.small,
                            color: cs.error,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Expires in ${minutes}m ${seconds}s',
                            style: AppText.caption(context).copyWith(
                              color: cs.error,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Link section
                  if (_paymentLinkUrl != null) ...[
                    SizedBox(height: 12.h),
                    Container(
                      padding: AppSpacing.all(12),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _paymentLinkUrl!,
                              style: AppText.caption(context).copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.copy, size: AppIcons.button),
                            onPressed: _copyLink,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: 32.r,
                              minHeight: 32.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (_linkError != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      _linkError!,
                      style: AppText.caption(context).copyWith(
                        color: cs.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  SizedBox(height: 24.h),

                  // Pay Now button
                  FilledButton.icon(
                    onPressed: isPaid
                        ? null
                        : () {
                            Navigator.of(context).pop(true);
                          },
                    icon: const Icon(Icons.payment),
                    label: const Text('Pay Now'),
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 48.h),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Link buttons row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isGeneratingLink ? null : _shareLink,
                          icon: _isGeneratingLink
                              ? SizedBox(
                                  width: 16.r,
                                  height: 16.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.r,
                                  ),
                                )
                              : const Icon(Icons.share),
                          label: const Text('Share Link'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 44.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isGeneratingLink ? null : _copyLink,
                          icon: _isGeneratingLink
                              ? SizedBox(
                                  width: 16.r,
                                  height: 16.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.r,
                                  ),
                                )
                              : const Icon(Icons.copy),
                          label: const Text('Copy Link'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 44.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Refresh status
                  OutlinedButton.icon(
                    onPressed: () {
                      _fetchSessionStatus();
                      _startAutoRefresh();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Check Payment Status'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 44.h),
                    ),
                  ),

                  // Paid status
                  if (isPaid) ...[
                    SizedBox(height: 12.h),
                    Container(
                      padding: AppSpacing.all(12),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: cs.primary,
                            size: AppIcons.medium,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Payment received! Redirecting...',
                            style: AppText.caption(context).copyWith(
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 12.h),

                  // Close
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
