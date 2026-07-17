import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/services/payment_service.dart';
import 'package:freshpickkat_flutter/utils/app_snackbar.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

enum PaymentStatus {
  verified,
  verifying,
  pending,
  failed,
  cancelled,
  unknown,
}

class PaymentStatusWidget extends StatefulWidget {
  final String orderId;
  final String paymentId;
  final double amount;
  final VoidCallback? onSuccess;
  final VoidCallback? onFailed;

  const PaymentStatusWidget({
    super.key,
    required this.orderId,
    required this.paymentId,
    required this.amount,
    this.onSuccess,
    this.onFailed,
  });

  @override
  State<PaymentStatusWidget> createState() => _PaymentStatusWidgetState();
}

class _PaymentStatusWidgetState extends State<PaymentStatusWidget>
    with SingleTickerProviderStateMixin {
  PaymentStatus _status = PaymentStatus.unknown;
  bool _isRetrying = false;
  bool _isCheckingStatus = false;
  String _statusMessage = '';
  String _detailMessage = '';
  Timer? _autoCheckTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _checkPaymentStatus();
    _startAutoCheck();
  }

  void _startAutoCheck() {
    _autoCheckTimer?.cancel();
    _autoCheckTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkPaymentStatus();
    });
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Waiting For Payment';
      case 'verifying':
        return 'Payment Verification In Progress';
      case 'paid':
        return 'Payment Successful';
      case 'failed':
        return 'Payment Failed';
      case 'cancelled':
        return 'Payment Cancelled';
      case 'refunded':
        return 'Payment Refunded';
      default:
        return 'Checking Payment Status...';
    }
  }

  Future<void> _checkPaymentStatus() async {
    if (!mounted) return;

    try {
      final paymentService = PaymentService.instance;
      final statusResult = await paymentService.getPaymentStatusWithMessage(
        widget.paymentId,
        widget.orderId,
      );

      if (!mounted) return;

      final apiStatus = statusResult.status?.toLowerCase().trim() ?? '';
      final message = statusResult.message ?? '';

      if (apiStatus == 'paid') {
        setState(() {
          _status = PaymentStatus.verified;
          _statusMessage = 'Payment Successful';
          _detailMessage = '';
        });
        _autoCheckTimer?.cancel();
        widget.onSuccess?.call();
        return;
      }

      if (apiStatus == 'failed') {
        setState(() {
          _status = PaymentStatus.failed;
          _statusMessage = 'Payment could not be confirmed.';
          _detailMessage = message.isNotEmpty
              ? message
              : 'If money was debited from your account, it will either be '
                    'automatically reversed by your bank or reflected after '
                    'payment verification.';
        });
        _autoCheckTimer?.cancel();
        widget.onFailed?.call();
        return;
      }

      if (apiStatus == 'cancelled') {
        setState(() {
          _status = PaymentStatus.cancelled;
          _statusMessage = 'Payment Cancelled';
          _detailMessage = message;
        });
        _autoCheckTimer?.cancel();
        widget.onFailed?.call();
        return;
      }

      if (apiStatus == 'verifying') {
        setState(() {
          _status = PaymentStatus.verifying;
          _statusMessage = 'Payment Verification In Progress';
          _detailMessage =
              'We are confirming your payment. '
              'This should complete shortly.';
        });
        return;
      }

      setState(() {
        _status = PaymentStatus.pending;
        _statusMessage = _statusLabel(apiStatus);
        _detailMessage = message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = PaymentStatus.pending;
        _statusMessage = 'Checking payment status...';
        _detailMessage = '';
      });
    }
  }

  Future<void> _retryPayment() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
      _statusMessage = 'Retrying...';
      _detailMessage = '';
    });

    try {
      final paymentService = PaymentService.instance;
      final result = await paymentService.recoverPendingPayments();

      if (!mounted) return;

      if (result.success == true) {
        await _checkPaymentStatus();
      } else {
        setState(() {
          _statusMessage = 'Retry failed. Please try again.';
          _detailMessage = result.error ?? '';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusMessage = 'Retry failed. Please try again.';
        _detailMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  Future<void> _checkStatusNow() async {
    if (_isCheckingStatus) return;

    setState(() {
      _isCheckingStatus = true;
    });

    try {
      await _checkPaymentStatus();
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingStatus = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _autoCheckTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        border: Border.all(color: _getBorderColor(), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusIcon(),
          SizedBox(height: ScreenScale.h(12)),
          AutoSizeText(
            _statusMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ScreenScale.sp(14),
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
            ),
            minFontSize: 11,
            maxLines: 3,
          ),
          if (_detailMessage.isNotEmpty) ...[
            SizedBox(height: ScreenScale.h(8)),
            AutoSizeText(
              _detailMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ScreenScale.sp(12),
                color: Colors.grey.shade600,
              ),
              minFontSize: 10,
              maxLines: 4,
            ),
          ],
          if (_status == PaymentStatus.pending ||
              _status == PaymentStatus.verifying) ...[
            SizedBox(height: ScreenScale.h(16)),
            _buildRetryButton(),
            SizedBox(height: ScreenScale.h(8)),
            Text(
              _status == PaymentStatus.verifying
                  ? 'Auto-checking every 10 seconds'
                  : 'Auto-checking every 10 seconds',
              style: TextStyle(
                fontSize: ScreenScale.sp(11),
                color: Colors.grey.shade600,
              ),
            ),
          ],
          if (_status == PaymentStatus.failed ||
              _status == PaymentStatus.cancelled) ...[
            SizedBox(height: ScreenScale.h(16)),
            _buildRetryButton(),
            SizedBox(height: ScreenScale.h(8)),
            _buildCheckStatusButton(),
            SizedBox(height: ScreenScale.h(8)),
            _buildSupportButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (_status) {
      case PaymentStatus.verified:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case PaymentStatus.verifying:
        icon = Icons.sync;
        color = Colors.blue;
        break;
      case PaymentStatus.pending:
        icon = Icons.hourglass_top;
        color = Colors.orange;
        break;
      case PaymentStatus.failed:
        icon = Icons.error;
        color = Colors.red;
        break;
      case PaymentStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.grey;
        break;
      case PaymentStatus.unknown:
        icon = Icons.help;
        color = Colors.grey;
        break;
    }

    if (_status == PaymentStatus.verifying ||
        _status == PaymentStatus.pending) {
      return ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          width: ScreenScale.r(60),
          height: ScreenScale.r(60),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: ScreenScale.r(32), color: color),
        ),
      );
    }

    return Container(
      width: ScreenScale.r(60),
      height: ScreenScale.r(60),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: ScreenScale.r(32), color: color),
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton.icon(
      onPressed: _isRetrying ? null : _retryPayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        padding: AppSpacing.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
      icon: _isRetrying
          ? SizedBox(
              width: AppIcons.button,
              height: AppIcons.button,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(Icons.refresh, size: AppIcons.button),
      label: AutoSizeText(
        _isRetrying ? 'Retrying...' : 'Retry Payment',
        maxLines: 1,
        minFontSize: 11,
      ),
    );
  }

  Widget _buildCheckStatusButton() {
    return OutlinedButton.icon(
      onPressed: _isCheckingStatus ? null : _checkStatusNow,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.primaryGreen,
        side: const BorderSide(color: AppTheme.primaryGreen),
        padding: AppSpacing.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
      icon: _isCheckingStatus
          ? SizedBox(
              width: AppIcons.button,
              height: AppIcons.button,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.primaryGreen,
              ),
            )
          : Icon(Icons.search, size: AppIcons.button),
      label: AutoSizeText(
        _isCheckingStatus ? 'Checking...' : 'Check Payment Status',
        maxLines: 1,
        minFontSize: 11,
      ),
    );
  }

  Widget _buildSupportButton() {
    return OutlinedButton.icon(
      onPressed: () {
        AppSnackbar.show(
          'Contact Support',
          'Please contact us at freshpickkart@gmail.com',
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: AppSpacing.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
      icon: Icon(Icons.support_agent, size: AppIcons.button),
      label: const Text('Contact Support'),
    );
  }

  Color _getBackgroundColor() {
    switch (_status) {
      case PaymentStatus.verified:
        return Colors.green.shade50;
      case PaymentStatus.verifying:
        return Colors.blue.shade50;
      case PaymentStatus.pending:
        return Colors.orange.shade50;
      case PaymentStatus.failed:
        return Colors.red.shade50;
      case PaymentStatus.cancelled:
        return Colors.grey.shade100;
      case PaymentStatus.unknown:
        return Colors.grey.shade100;
    }
  }

  Color _getBorderColor() {
    switch (_status) {
      case PaymentStatus.verified:
        return Colors.green.shade200;
      case PaymentStatus.verifying:
        return Colors.blue.shade200;
      case PaymentStatus.pending:
        return Colors.orange.shade200;
      case PaymentStatus.failed:
        return Colors.red.shade200;
      case PaymentStatus.cancelled:
        return Colors.grey.shade300;
      case PaymentStatus.unknown:
        return Colors.grey.shade300;
    }
  }

  Color _getTextColor() {
    switch (_status) {
      case PaymentStatus.verified:
        return Colors.green.shade800;
      case PaymentStatus.verifying:
        return Colors.blue.shade800;
      case PaymentStatus.pending:
        return Colors.orange.shade800;
      case PaymentStatus.failed:
        return Colors.red.shade800;
      case PaymentStatus.cancelled:
        return Colors.grey.shade700;
      case PaymentStatus.unknown:
        return Colors.grey.shade700;
    }
  }
}
