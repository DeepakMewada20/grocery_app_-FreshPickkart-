import 'dart:async';
import 'dart:convert';
import 'package:freshpickkat_flutter/payment/models/payment_request.dart';
import 'package:freshpickkat_flutter/payment/models/payment_result.dart';
import 'package:freshpickkat_flutter/payment/platform/payment_platform.dart';
import 'package:razorpay_flutter_customui/razorpay_flutter_customui.dart';

class MobilePaymentPlatform implements PaymentPlatform {
  Razorpay? _razorpay;
  Completer<PaymentResult>? _completer;

  @override
  Future<PaymentResult> startPayment(PaymentRequest request) async {
    _completer = Completer<PaymentResult>();
    _razorpay ??= Razorpay();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);

    final options = {
      'key': request.keyId,
      'amount': request.amountPaise,
      'currency': request.currency,
      'order_id': request.razorpayOrderId,
      'contact': request.customerPhone,
      'email': request.customerEmail,
      'method': 'upi',
      if (request.vpa != null && request.vpa!.isNotEmpty) 'vpa': request.vpa,
      if (request.vpa == null || request.vpa!.isEmpty) '_[flow]': 'intent',
      if (request.upiAppPackageName != null)
        'upi_app_package_name': request.upiAppPackageName,
      'notes': {
        'order_id': request.orderId,
      },
    };

    _razorpay?.submit(options);

    return _completer!.future;
  }

  void _handleSuccess(dynamic response) {
    if (_completer == null || _completer!.isCompleted) return;
    final payload = response is Map
        ? (response['data'] is Map ? response['data'] as Map : response)
        : <dynamic, dynamic>{};
    final paymentId = payload['razorpay_payment_id'] as String?;
    final orderId = payload['razorpay_order_id'] as String?;
    final signature = payload['razorpay_signature'] as String?;

    _completer!.complete(PaymentResult.success(
      razorpayPaymentId: paymentId ?? '',
      razorpayOrderId: orderId ?? '',
      razorpaySignature: signature ?? '',
    ));
  }

  void _handleError(dynamic response) {
    if (_completer == null || _completer!.isCompleted) return;
    final payload = response is Map
        ? (response['data'] is Map ? response['data'] as Map : response)
        : <dynamic, dynamic>{};
    final errorData = _extractRazorpayError(payload);
    final metadata = errorData['metadata'];
    final paymentId = metadata is Map ? metadata['payment_id']?.toString() : null;
    final code = (errorData['reason'] ??
            errorData['code'] ??
            payload['code'] ??
            payload['error_code'] ??
            'unknown')
        .toString();
    final message = (errorData['description'] ??
            payload['message'] ??
            payload['description'] ??
            '')
        .toString();

    final normalizedCode = code.toLowerCase().trim();
    final normalizedMessage = message.toLowerCase();
    final isCancelled = normalizedCode == 'payment_cancelled' ||
        normalizedCode == '2' ||
        normalizedMessage.contains('payment cancelled') ||
        normalizedMessage.contains('payment canceled') ||
        normalizedMessage.contains('cancelled by user');

    _completer!.complete(PaymentResult(
      status: isCancelled
          ? PaymentResultStatus.cancelled
          : PaymentResultStatus.failed,
      razorpayPaymentId: paymentId,
      errorMessage: message.isNotEmpty ? message : null,
      errorCode: code,
    ));
  }

  Map<String, dynamic> _extractRazorpayError(Map payload) {
    final message = payload['message'];
    if (message is Map) {
      final error = message['error'];
      if (error is Map<String, dynamic>) return error;
      if (error is Map) return Map<String, dynamic>.from(error);
    }
    if (message is String && message.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(message);
        if (decoded is Map && decoded['error'] is Map) {
          return Map<String, dynamic>.from(decoded['error'] as Map);
        }
      } catch (_) {}
    }
    return <String, dynamic>{};
  }

  @override
  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(const PaymentResult.cancelled());
    }
    _completer = null;
  }
}
