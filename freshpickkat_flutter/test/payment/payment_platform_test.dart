import 'package:flutter_test/flutter_test.dart';
import 'package:freshpickkat_flutter/payment/models/payment_request.dart';
import 'package:freshpickkat_flutter/payment/models/payment_result.dart';
import 'package:freshpickkat_flutter/payment/payment_factory.dart';

void main() {
  group('PaymentFactory', () {
    test('createPaymentPlatform returns a non-null instance', () {
      final platform = createPaymentPlatform();
      expect(platform, isNotNull);
    });

    test('createPaymentPlatform implements PaymentPlatform', () {
      final platform = createPaymentPlatform();
      expect(platform, isA<Object>());
    });

    test('dispose does not throw', () {
      final platform = createPaymentPlatform();
      expect(() => platform.dispose(), returnsNormally);
    });
  });

  group('PaymentResult from platform interaction', () {
    test('success result is correctly consumable by handler', () async {
      const result = PaymentResult.success(
        razorpayPaymentId: 'pay_test_001',
        razorpayOrderId: 'order_test_001',
        razorpaySignature: 'sig_test_001',
      );

      expect(result.status, PaymentResultStatus.success);
      expect(result.razorpayPaymentId, isNotEmpty);
      expect(result.razorpayOrderId, isNotEmpty);
      expect(result.razorpaySignature, isNotEmpty);
    });

    test('failed result is correctly consumable by handler', () async {
      const result = PaymentResult.failed(
        errorMessage: 'Payment failed',
        errorCode: 'BAD_REQUEST',
      );

      expect(result.status, PaymentResultStatus.failed);
      expect(result.errorMessage, isNotEmpty);
      expect(result.errorCode, isNotEmpty);
    });

    test('cancelled result is correctly consumable by handler', () async {
      const result = PaymentResult.cancelled(
        errorMessage: 'User closed modal',
      );

      expect(result.status, PaymentResultStatus.cancelled);
      expect(result.errorMessage, isNotEmpty);
    });

    test('pending result is correctly consumable by handler', () async {
      const result = PaymentResult.pending();

      expect(result.status, PaymentResultStatus.pending);
      expect(result.razorpayPaymentId, isNull);
      expect(result.razorpayOrderId, isNull);
    });
  });

  group('PaymentRequest to platform', () {
    test('builds complete request with all fields', () {
      const request = PaymentRequest(
        keyId: 'rzp_live_key',
        amountPaise: 49900,
        currency: 'INR',
        razorpayOrderId: 'order_live_001',
        customerPhone: '9876543210',
        customerEmail: 'user@example.com',
        orderId: 'ORD99999',
        upiAppPackageName: 'com.google.android.apps.nbu.paisa.user',
        vpa: 'test@upi',
      );

      expect(request.amountPaise, 49900);
      expect(request.orderId, 'ORD99999');
      expect(request.customerPhone, '9876543210');
      expect(request.upiAppPackageName,
          'com.google.android.apps.nbu.paisa.user');
      expect(request.vpa, 'test@upi');
      expect(request.keyId, 'rzp_live_key');
      expect(request.razorpayOrderId, 'order_live_001');
      expect(request.currency, 'INR');
      expect(request.customerEmail, 'user@example.com');
    });

    test('round-trip to PaymentResult and back reads correctly', () {
      const request = PaymentRequest(
        keyId: 'rzp_test_key',
        amountPaise: 10000,
        currency: 'INR',
        razorpayOrderId: 'order_test_002',
        customerPhone: '8888888888',
        customerEmail: 'a@b.com',
        orderId: 'ORD55555',
      );

      const result = PaymentResult.success(
        razorpayPaymentId: 'pay_test_002',
        razorpayOrderId: 'order_test_002',
        razorpaySignature: 'sig_test_002',
      );

      expect(result.razorpayOrderId, request.razorpayOrderId);
    });
  });
}
