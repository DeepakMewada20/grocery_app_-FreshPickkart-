import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../env_service.dart';

class PaymentGatewayService {
  static const String razorpayBaseUrl = 'https://api.razorpay.com/v1';

  String requireEnv(String key, {List<String> fallbacks = const []}) {
    final value = EnvService.get(key, fallbacks: fallbacks);
    if (value == null || value.isEmpty) {
      throw StateError('Missing required environment variable: $key');
    }
    return value;
  }

  String get razorpayKeyId =>
      requireEnv('RAZORPAY_KEY_ID', fallbacks: ['RAZORPAY_KEY']);

  String get razorpayKeySecret =>
      requireEnv('RAZORPAY_KEY_SECRET', fallbacks: ['RAZORPAY_SECRET']);

  bool get isTestMode => razorpayKeyId.startsWith('rzp_test_');

  String generateSignature(
    String razorpayOrderId,
    String razorpayPaymentId,
    String secret,
  ) {
    final hmac = Hmac(sha256, utf8.encode(secret));
    final digest = hmac.convert(
      utf8.encode('$razorpayOrderId|$razorpayPaymentId'),
    );
    return digest.toString();
  }

  Future<Map<String, dynamic>> createOrder({
    required String receipt,
    required int amountInPaise,
    required String customerPhone,
  }) async {
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
        'receipt': receipt,
        'notes': {
          'order_id': receipt,
          'phone': customerPhone,
        },
      }),
    );

    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  Future<Map<String, dynamic>> fetchPaymentStatus(String paymentId) async {
    final response = await http.get(
      Uri.parse('$razorpayBaseUrl/payments/$paymentId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
      },
    );
    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  Future<Map<String, dynamic>> createRefund({
    required String paymentId,
    required int amountInPaise,
    required String receipt,
    required Map<String, String> notes,
    String speed = 'optimum',
  }) async {
    final response = await http.post(
      Uri.parse('$razorpayBaseUrl/payments/$paymentId/refund'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
      },
      body: jsonEncode({
        'amount': amountInPaise,
        'speed': speed,
        'receipt': receipt,
        'notes': notes,
      }),
    );
    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  Future<Map<String, dynamic>> fetchRefund({
    required String paymentId,
    required String refundId,
  }) async {
    final response = await http.get(
      Uri.parse('$razorpayBaseUrl/payments/$paymentId/refunds/$refundId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
      },
    );
    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }
}
