import 'package:freshpickkat_flutter/payment/models/payment_request.dart';
import 'package:freshpickkat_flutter/payment/models/payment_result.dart';
import 'package:freshpickkat_flutter/payment/platform/payment_platform.dart';
import 'package:freshpickkat_flutter/payment/platform/web_razorpay_bridge_stub.dart'
    if (dart.library.html) 'package:freshpickkat_flutter/payment/platform/web_razorpay_bridge.dart';

class WebPaymentPlatform implements PaymentPlatform {
  @override
  Future<PaymentResult> startPayment(PaymentRequest request) async {
    final options = <String, dynamic>{
      'key': request.keyId,
      'amount': request.amountPaise,
      'currency': request.currency,
      'name': 'FreshPickKart',
      'description': 'Order ${request.orderId}',
      'order_id': request.razorpayOrderId,
      'prefill': {
        'contact': request.customerPhone,
        'email': request.customerEmail,
      },
      'theme': {
        'color': '#1b8a4c',
      },
      'notes': {
        'order_id': request.orderId,
      },
    };

    final result = await openRazorpayCheckoutBridge(options);

    final status = result['status'] as String?;
    switch (status) {
      case 'success':
        return PaymentResult.success(
          razorpayPaymentId: result['razorpay_payment_id'] as String? ?? '',
          razorpayOrderId: result['razorpay_order_id'] as String? ?? '',
          razorpaySignature: result['razorpay_signature'] as String? ?? '',
        );

      case 'failed':
        final error = result['error'] is Map
            ? Map<String, dynamic>.from(result['error'] as Map)
            : <String, dynamic>{};
        return PaymentResult.failed(
          errorMessage: error['description']?.toString(),
          errorCode: error['reason']?.toString(),
          razorpayPaymentId: error['metadata'] is Map
              ? (error['metadata'] as Map)['payment_id']?.toString()
              : null,
        );

      case 'cancelled':
        return const PaymentResult.cancelled(
          errorMessage: 'Payment modal closed by user',
        );

      default:
        return const PaymentResult.pending();
    }
  }

  @override
  void dispose() {}
}
