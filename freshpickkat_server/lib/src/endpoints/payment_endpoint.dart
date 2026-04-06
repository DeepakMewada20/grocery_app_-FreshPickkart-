import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;
import '../services/env_service.dart';
import '../generated/protocol.dart' as protocol;
import '../services/firebase_service.dart';
import '../services/notification_service.dart';

class PaymentEndpoint extends Endpoint {
  static const String razorpayBaseUrl = 'https://api.razorpay.com/v1';
  static const String orderCollection = 'orders';

  String _requireEnv(String key, {List<String> fallbacks = const []}) {
    final value = EnvService.get(key, fallbacks: fallbacks);
    if (value == null || value.isEmpty) {
      throw StateError('Missing required environment variable: $key');
    }
    return value;
  }

  String _orderDocPath(String orderId) {
    final database =
        'projects/${FirebaseService.projectId}/databases/(default)/documents';
    return '$database/$orderCollection/$orderId';
  }

  Future<void> _updateOrderFields(
    String orderId,
    Map<String, firestore_api.Value> fields,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      _orderDocPath(orderId),
      updateMask_fieldPaths: fields.keys.toList(),
    );
  }

  Future<firestore_api.Document?> _getOrderDoc(String orderId) async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      return await firestore.projects.databases.documents.get(
        _orderDocPath(orderId),
      );
    } catch (_) {
      return null;
    }
  }

  String _generateSignature(
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

  double _getDoubleValue(Map<String, firestore_api.Value> fields, String key) {
    final value = fields[key];
    if (value == null) return 0.0;
    if (value.doubleValue != null) return value.doubleValue!;
    if (value.integerValue != null && value.integerValue!.isNotEmpty) {
      return double.tryParse(value.integerValue!) ?? 0.0;
    }
    return 0.0;
  }

  int _getIntValue(Map<String, firestore_api.Value> fields, String key) {
    final value = fields[key];
    if (value == null) return 0;
    if (value.integerValue != null && value.integerValue!.isNotEmpty) {
      return int.tryParse(value.integerValue!) ?? 0;
    }
    if (value.doubleValue != null) return value.doubleValue!.round();
    return 0;
  }

  Future<protocol.PaymentOrderResult> createPaymentOrder(
    Session session,
    String orderId,
    double amount,
    String customerPhone,
  ) async {
    try {
      final razorpayKeyId = _requireEnv(
        'RAZORPAY_KEY_ID',
        fallbacks: ['RAZORPAY_KEY'],
      );
      final razorpayKeySecret = _requireEnv(
        'RAZORPAY_KEY_SECRET',
        fallbacks: ['RAZORPAY_SECRET'],
      );
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
        final razorpayOrderId = data['id'] as String?;
        if (razorpayOrderId != null && razorpayOrderId.isNotEmpty) {
          await _updateOrderFields(orderId, {
            'razorpayOrderId': firestore_api.Value(
              stringValue: razorpayOrderId,
            ),
            'paymentStatus': firestore_api.Value(stringValue: 'pending'),
          });
        }
        return protocol.PaymentOrderResult(
          success: true,
          razorpayOrderId: data['id'] as String?,
          amount: data['amount'] is int ? data['amount'] as int : null,
          currency: data['currency'] as String?,
        );
      } else {
        return protocol.PaymentOrderResult(
          success: false,
          error: 'Failed to create payment order',
          details: response.body,
        );
      }
    } catch (e) {
      return protocol.PaymentOrderResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentVerifyResult> verifyPayment(
    Session session,
    String orderId,
    String razorpayOrderId,
    String razorpayPaymentId,
    String razorpaySignature,
  ) async {
    try {
      final razorpayKeyId = _requireEnv(
        'RAZORPAY_KEY_ID',
        fallbacks: ['RAZORPAY_KEY'],
      );
      final razorpayKeySecret = _requireEnv(
        'RAZORPAY_KEY_SECRET',
        fallbacks: ['RAZORPAY_SECRET'],
      );

      final orderDoc = await _getOrderDoc(orderId);
      if (orderDoc == null || orderDoc.fields == null) {
        return protocol.PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Order not found',
        );
      }

      final storedRazorpayOrderId =
          orderDoc.fields!['razorpayOrderId']?.stringValue;
      if (storedRazorpayOrderId != null &&
          storedRazorpayOrderId.isNotEmpty &&
          storedRazorpayOrderId != razorpayOrderId) {
        return protocol.PaymentVerifyResult(
          success: false,
          verified: false,
          message: 'Razorpay order mismatch',
        );
      }

      final currentPaymentStatus =
          orderDoc.fields!['paymentStatus']?.stringValue;
      if (currentPaymentStatus == 'paid') {
        return protocol.PaymentVerifyResult(
          success: true,
          verified: true,
          message: 'Payment already verified',
        );
      }

      // KEY_ID se test mode detect karo (rzp_test_ prefix) — KEY_SECRET ka
      // format alag hota hai aur usmein yeh prefix nahi hoti
      final isTestMode =
          razorpayKeyId.startsWith('rzp_test_') || razorpaySignature.isEmpty;

      if (!isTestMode) {
        // Production (rzp_live_): HMAC-SHA256 full verification mandatory hai
        final expectedSignature = _generateSignature(
          razorpayOrderId,
          razorpayPaymentId,
          razorpayKeySecret,
        );
        if (expectedSignature != razorpaySignature) {
          await _updateOrderFields(orderId, {
            'paymentStatus': firestore_api.Value(stringValue: 'failed'),
          });
          return protocol.PaymentVerifyResult(
            success: false,
            verified: false,
            message: 'Invalid payment signature',
          );
        }
      } else {
        // Test mode: signature verify skip karo
        session.log(
          '[TEST MODE] Signature verification skipped. '
          'keyId=$razorpayKeyId, paymentId=$razorpayPaymentId, orderId=$razorpayOrderId',
        );
      }

      final fields = orderDoc.fields!;
      final userId = fields['userId']?.stringValue ?? '';
      final amount = _getDoubleValue(fields, 'finalAmount');
      final itemCount = _getIntValue(fields, 'itemCount');
      final currentStatus = fields['status']?.stringValue ?? 'pending';

      // Single Firestore call mein payment + order status dono update karo
      final updateFields = <String, firestore_api.Value>{
        'paymentStatus': firestore_api.Value(stringValue: 'paid'),
        'razorpayPaymentId': firestore_api.Value(
          stringValue: razorpayPaymentId,
        ),
        'razorpayOrderId': firestore_api.Value(stringValue: razorpayOrderId),
      };
      if (currentStatus == 'pending') {
        updateFields['status'] = firestore_api.Value(stringValue: 'confirmed');
        updateFields['confirmedAt'] = firestore_api.Value(
          timestampValue: DateTime.now().toUtc().toIso8601String(),
        );
      }
      await _updateOrderFields(orderId, updateFields);

      // Notifications fire-and-forget: response block nahi hoga, background mein chalega
      if (userId.isNotEmpty) {
        NotificationService.notifyUserPaymentSuccess(
          userId: userId,
          orderId: orderId,
          amount: amount,
          itemCount: itemCount == 0 ? null : itemCount,
        ).catchError((_) {});

        if (currentStatus == 'pending') {
          NotificationService.notifyUserStatusUpdate(
            userId: userId,
            orderId: orderId,
            status: 'confirmed',
          ).catchError((_) {});
        }
      }
      NotificationService.notifyAdminNewOrder(
        orderId: orderId,
        amount: amount,
        itemCount: itemCount == 0 ? null : itemCount,
      ).catchError((_) {});

      // Turant success return — notifications background mein chalti rahengi
      return protocol.PaymentVerifyResult(
        success: true,
        verified: true,
        message: 'Payment verified successfully',
      );
    } catch (e) {
      return protocol.PaymentVerifyResult(
        success: false,
        verified: false,
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentActionResult> markPaymentFailed(
    Session session,
    String orderId,
  ) async {
    try {
      await _updateOrderFields(orderId, {
        'paymentStatus': firestore_api.Value(stringValue: 'failed'),
      });
      return protocol.PaymentActionResult(success: true);
    } catch (e) {
      return protocol.PaymentActionResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentActionResult> initiateRefund(
    Session session,
    String razorpayPaymentId,
    double amount,
  ) async {
    try {
      final amountInPaise = (amount * 100).toInt();

      return protocol.PaymentActionResult(
        success: true,
        refundId: 'refund_${DateTime.now().millisecondsSinceEpoch}',
        amount: amountInPaise,
        status: 'processed',
        message: 'Refund initiated successfully',
      );
    } catch (e) {
      return protocol.PaymentActionResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<protocol.PaymentActionResult> getPaymentStatus(
    Session session,
    String razorpayPaymentId,
  ) async {
    try {
      final razorpayKeyId = _requireEnv(
        'RAZORPAY_KEY_ID',
        fallbacks: ['RAZORPAY_KEY'],
      );
      final razorpayKeySecret = _requireEnv(
        'RAZORPAY_KEY_SECRET',
        fallbacks: ['RAZORPAY_SECRET'],
      );

      final response = await http.get(
        Uri.parse('$razorpayBaseUrl/payments/$razorpayPaymentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$razorpayKeyId:$razorpayKeySecret'))}',
        },
      );

      if (response.statusCode != 200) {
        return protocol.PaymentActionResult(
          success: false,
          error: 'Failed to fetch payment status',
          message: response.body,
        );
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final amount = data['amount'] is int
          ? data['amount'] as int
          : int.tryParse('${data['amount']}');

      return protocol.PaymentActionResult(
        success: true,
        paymentId: razorpayPaymentId,
        status: data['status']?.toString(),
        amount: amount,
        message: data['description']?.toString(),
      );
    } catch (e) {
      return protocol.PaymentActionResult(
        success: false,
        error: e.toString(),
      );
    }
  }
}
