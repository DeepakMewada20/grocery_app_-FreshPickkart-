import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../config/env_service.dart';

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
    final response = await http
        .post(
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
        )
        .timeout(const Duration(seconds: 30));

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
    final response = await http
        .post(
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
        )
        .timeout(const Duration(seconds: 30));
    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  Future<Map<String, dynamic>> fetchPaymentStatus(String paymentId) async {
    final response = await http
        .get(
          Uri.parse('$razorpayBaseUrl/payments/$paymentId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
          },
        )
        .timeout(const Duration(seconds: 30));
    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  Future<Map<String, dynamic>> createPaymentLink({
    required int amountInPaise,
    required String description,
    required Map<String, String> customer,
    required Map<String, String> notes,
    int expiryMinutes = 20,
    String? callbackUrl,
  }) async {
    final now = DateTime.now().toUtc();
    final expiresAt = now.add(Duration(minutes: expiryMinutes));
    final expiresAtUnix = (expiresAt.millisecondsSinceEpoch / 1000).round();

    final body = <String, dynamic>{
      'amount': amountInPaise,
      'currency': 'INR',
      'accept_partial': false,
      'description': description,
      'customer': {
        'name': customer['name'] ?? '',
        'contact': customer['contact'] ?? '',
        'email': customer['email'] ?? '',
      },
      'notify': {
        'sms': false,
        'email': false,
      },
      'reminder_enable': false,
      'notes': notes,
      'expire_by': expiresAtUnix,
    };

    if (callbackUrl != null && callbackUrl.isNotEmpty) {
      body['callback_url'] = callbackUrl;
      body['callback_method'] = 'get';
    }

    final response = await http
        .post(
          Uri.parse('$razorpayBaseUrl/payment_links'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 30));

    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  Future<Map<String, dynamic>> fetchPaymentLinkStatus(
    String razorpayPaymentLinkId,
  ) async {
    final response = await http
        .get(
          Uri.parse('$razorpayBaseUrl/payment_links/$razorpayPaymentLinkId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
          },
        )
        .timeout(const Duration(seconds: 30));
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
    final response = await http
        .get(
          Uri.parse('$razorpayBaseUrl/payments/$paymentId/refunds/$refundId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
          },
        )
        .timeout(const Duration(seconds: 30));
    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  Future<Map<String, dynamic>> createUpiQr({
    required int amountInPaise,
    required String description,
    required Map<String, String> notes,
    int expiryMinutes = 5,
  }) async {
    final now = DateTime.now().toUtc();
    final closeBy = now.add(Duration(minutes: expiryMinutes));
    final closeByUnix = (closeBy.millisecondsSinceEpoch / 1000).round();

    final orderNumber = description.replaceAll('COD payment - Order ', '');
    final body = <String, dynamic>{
      'type': 'upi_qr',
      'name': 'COD-Order-$orderNumber',
      'usage': 'single_use',
      'fixed_amount': true,
      'payment_amount': amountInPaise,
      'description': description,
      'close_by': closeByUnix,
      'notes': notes,
    };

    final response = await http
        .post(
          Uri.parse('$razorpayBaseUrl/payments/qr_codes'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 30));

    stderr.writeln(
      '[Razorpay QR] statusCode=${response.statusCode} body=${response.body}',
    );

    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  Future<Map<String, dynamic>> fetchQrCode(String qrId) async {
    final response = await http
        .get(
          Uri.parse('$razorpayBaseUrl/payments/qr_codes/$qrId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
          },
        )
        .timeout(const Duration(seconds: 30));

    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  Future<Map<String, dynamic>> fetchQrPayments(String qrId) async {
    final response = await http
        .get(
          Uri.parse('$razorpayBaseUrl/payments/qr_codes/$qrId/payments'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
          },
        )
        .timeout(const Duration(seconds: 30));

    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }

  Future<Map<String, dynamic>> closeQrCode(String qrId) async {
    final response = await http
        .post(
          Uri.parse('$razorpayBaseUrl/payments/qr_codes/$qrId/close'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
          },
        )
        .timeout(const Duration(seconds: 30));

    return {
      'statusCode': response.statusCode,
      'body': response.body,
      'data': response.body.isNotEmpty ? jsonDecode(response.body) : null,
    };
  }
}
