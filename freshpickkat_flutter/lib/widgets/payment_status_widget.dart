import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/services/payment_service.dart';
import 'package:get/get.dart';

enum PaymentStatus {
  verified,
  pending,
  failed,
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
  String _statusMessage = 'Verifying payment...';
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

  Future<void> _checkPaymentStatus() async {
    if (!mounted) return;

    try {
      final paymentService = PaymentService.instance;
      final result = await paymentService.verifyPayment(
        orderId: widget.orderId,
        razorpayOrderId: '',
        paymentId: widget.paymentId,
        signature: '',
      );

      if (!mounted) return;

      if (result.success == true && result.verified == true) {
        setState(() {
          _status = PaymentStatus.verified;
          _statusMessage = 'Payment Verified!';
        });
        _autoCheckTimer?.cancel();
        widget.onSuccess?.call();
        return;
      }

      final gatewayStatus = await paymentService.fetchGatewayPaymentStatus(
        widget.paymentId,
        widget.orderId,
      );

      if (!mounted) return;

      final status = gatewayStatus.status?.toLowerCase().trim() ?? '';

      if (status == 'captured' || status == 'authorized') {
        setState(() {
          _status = PaymentStatus.verified;
          _statusMessage = 'Payment Verified!';
        });
        _autoCheckTimer?.cancel();
        widget.onSuccess?.call();
      } else if (status == 'failed' ||
          status == 'error' ||
          status == 'refunded') {
        setState(() {
          _status = PaymentStatus.failed;
          _statusMessage = 'Payment Failed';
        });
        _autoCheckTimer?.cancel();
        widget.onFailed?.call();
      } else {
        setState(() {
          _status = PaymentStatus.pending;
          _statusMessage = 'Payment is being processed...';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = PaymentStatus.pending;
        _statusMessage = 'Checking payment status...';
      });
    }
  }

  Future<void> _retryPayment() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
      _statusMessage = 'Retrying...';
    });

    try {
      final paymentService = PaymentService.instance;
      final result = await paymentService.verifyPayment(
        orderId: widget.orderId,
        razorpayOrderId: '',
        paymentId: widget.paymentId,
        signature: '',
      );

      if (!mounted) return;

      if (result.success == true && result.verified == true) {
        setState(() {
          _status = PaymentStatus.verified;
          _statusMessage = 'Payment Verified!';
          _isRetrying = false;
        });
        _autoCheckTimer?.cancel();
        widget.onSuccess?.call();
        return;
      }

      final gatewayStatus = await paymentService.fetchGatewayPaymentStatus(
        widget.paymentId,
        widget.orderId,
      );

      if (!mounted) return;

      final status = gatewayStatus.status?.toLowerCase().trim() ?? '';

      if (status == 'captured' || status == 'authorized') {
        setState(() {
          _status = PaymentStatus.verified;
          _statusMessage = 'Payment Verified!';
          _isRetrying = false;
        });
        _autoCheckTimer?.cancel();
        widget.onSuccess?.call();
      } else if (status == 'failed' || status == 'error') {
        setState(() {
          _status = PaymentStatus.failed;
          _statusMessage = 'Payment Failed. Please contact support.';
          _isRetrying = false;
        });
        _autoCheckTimer?.cancel();
        widget.onFailed?.call();
      } else {
        setState(() {
          _statusMessage = 'Still processing. We\'ll notify you when done.';
          _isRetrying = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusMessage = 'Retry failed. Please try again.';
        _isRetrying = false;
      });
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
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: _getBorderColor(), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusIcon(),
          SizedBox(height: 12.h),
          AutoSizeText(
            _statusMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
            ),
            minFontSize: 11,
            maxLines: 3,
          ),
          if (_status == PaymentStatus.pending) ...[
            SizedBox(height: 16.h),
            _buildRetryButton(),
            SizedBox(height: 8.h),
            Text(
              'Auto-checking every 10 seconds',
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          if (_status == PaymentStatus.failed) ...[
            SizedBox(height: 16.h),
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
      case PaymentStatus.pending:
        icon = Icons.hourglass_top;
        color = Colors.orange;
        break;
      case PaymentStatus.failed:
        icon = Icons.error;
        color = Colors.red;
        break;
      case PaymentStatus.unknown:
        icon = Icons.sync;
        color = Colors.grey;
        break;
    }

    if (_status == PaymentStatus.pending) {
      return ScaleTransition(
        scale: _pulseAnimation,
        child: Container(
          width: 60.r,
          height: 60.r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 32.r, color: color),
        ),
      );
    }

    return Container(
      width: 60.r,
      height: 60.r,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 32.r, color: color),
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton.icon(
      onPressed: _isRetrying ? null : _retryPayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      icon: _isRetrying
          ? SizedBox(
              width: 18.r,
              height: 18.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(Icons.refresh, size: 18.r),
      label: AutoSizeText(
        _isRetrying ? 'Retrying...' : 'Retry Now',
        maxLines: 1,
        minFontSize: 11,
      ),
    );
  }

  Widget _buildSupportButton() {
    return OutlinedButton.icon(
      onPressed: () {
        Get.snackbar(
          'Contact Support',
          'Please contact us at support@freshpickkat.com',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      icon: Icon(Icons.support_agent, size: 18.r),
      label: const Text('Contact Support'),
    );
  }

  Color _getBackgroundColor() {
    switch (_status) {
      case PaymentStatus.verified:
        return Colors.green.shade50;
      case PaymentStatus.pending:
        return Colors.orange.shade50;
      case PaymentStatus.failed:
        return Colors.red.shade50;
      case PaymentStatus.unknown:
        return Colors.grey.shade100;
    }
  }

  Color _getBorderColor() {
    switch (_status) {
      case PaymentStatus.verified:
        return Colors.green.shade200;
      case PaymentStatus.pending:
        return Colors.orange.shade200;
      case PaymentStatus.failed:
        return Colors.red.shade200;
      case PaymentStatus.unknown:
        return Colors.grey.shade300;
    }
  }

  Color _getTextColor() {
    switch (_status) {
      case PaymentStatus.verified:
        return Colors.green.shade800;
      case PaymentStatus.pending:
        return Colors.orange.shade800;
      case PaymentStatus.failed:
        return Colors.red.shade800;
      case PaymentStatus.unknown:
        return Colors.grey.shade700;
    }
  }
}


