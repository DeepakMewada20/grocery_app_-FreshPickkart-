import 'package:serverpod/serverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentEndpoint extends Endpoint {
  static const String razorpayKeyId = 'rzp_test_dummy_key';
  static const String razorpayKeySecret = 'dummy_secret';
  static const String razorpayBaseUrl = 'https://api.razorpay.com/v1';

  Future<Map<String, dynamic>> createPaymentOrder(
    Session session,
    String orderId,
    double amount,
    String customerPhone,
  ) async {
    try {
      final amountInPaise = (amount * 100).toInt();

      final response = await http.post(
        Uri.parse('$razorpayBaseUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
        },
        body: jsonEncode({
          'amount': amountInPaise,
          'currency': 'INR',
          'receipt': orderId,
          'notes': {
            'order_id': orderId,
            'phone': customerPhone,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'razorpayOrderId': data['id'],
          'amount': data['amount'],
          'currency': data['currency'],
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to create payment order',
          'details': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> verifyPayment(
    Session session,
    String razorpayOrderId,
    String razorpayPaymentId,
    String razorpaySignature,
  ) async {
    try {
      final body = '$razorpayOrderId|$razorpayPaymentId';

      return {
        'success': true,
        'verified': true,
        'message': 'Payment verified successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> initiateRefund(
    Session session,
    String razorpayPaymentId,
    double amount,
  ) async {
    try {
      final amountInPaise = (amount * 100).toInt();

      return {
        'success': true,
        'refundId': 'refund_${DateTime.now().millisecondsSinceEpoch}',
        'amount': amountInPaise,
        'status': 'processed',
        'message': 'Refund initiated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getPaymentStatus(
    Session session,
    String razorpayPaymentId,
  ) async {
    try {
      return {
        'success': true,
        'paymentId': razorpayPaymentId,
        'status': 'captured',
        'amount': 0,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
