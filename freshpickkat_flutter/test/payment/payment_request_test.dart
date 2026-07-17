import 'package:flutter_test/flutter_test.dart';
import 'package:freshpickkat_flutter/payment/models/payment_request.dart';

void main() {
  group('PaymentRequest construction', () {
    test('creates with all required fields', () {
      const request = PaymentRequest(
        keyId: 'rzp_live_abc123',
        amountPaise: 50000,
        currency: 'INR',
        razorpayOrderId: 'order_xyz789',
        customerPhone: '9999999999',
        customerEmail: 'test@example.com',
        orderId: 'ORD12345',
      );

      expect(request.keyId, 'rzp_live_abc123');
      expect(request.amountPaise, 50000);
      expect(request.currency, 'INR');
      expect(request.razorpayOrderId, 'order_xyz789');
      expect(request.customerPhone, '9999999999');
      expect(request.customerEmail, 'test@example.com');
      expect(request.orderId, 'ORD12345');
      expect(request.upiAppPackageName, isNull);
      expect(request.vpa, isNull);
    });

    test('creates with optional UPI fields', () {
      const request = PaymentRequest(
        keyId: 'rzp_test_abc',
        amountPaise: 25000,
        currency: 'INR',
        razorpayOrderId: 'order_test_001',
        customerPhone: '8888888888',
        customerEmail: 'user@test.com',
        orderId: 'ORD67890',
        upiAppPackageName: 'com.phonepe.app',
        vpa: 'user@paytm',
      );

      expect(request.upiAppPackageName, 'com.phonepe.app');
      expect(request.vpa, 'user@paytm');
    });

    test('creates with test VPA only', () {
      const request = PaymentRequest(
        keyId: 'rzp_test_abc',
        amountPaise: 1000,
        currency: 'INR',
        razorpayOrderId: 'order_test_002',
        customerPhone: '7777777777',
        customerEmail: 'test@test.com',
        orderId: 'ORD11111',
        vpa: 'success@razorpay',
      );

      expect(request.vpa, 'success@razorpay');
      expect(request.upiAppPackageName, isNull);
    });
  });

  group('PaymentRequest amount edge cases', () {
    test('handles zero amount', () {
      const request = PaymentRequest(
        keyId: 'rzp_test_key',
        amountPaise: 0,
        currency: 'INR',
        razorpayOrderId: 'order_0',
        customerPhone: '9999999999',
        customerEmail: 'test@test.com',
        orderId: 'ORD00000',
      );

      expect(request.amountPaise, 0);
    });

    test('handles large amount', () {
      const request = PaymentRequest(
        keyId: 'rzp_test_key',
        amountPaise: 100000000,
        currency: 'INR',
        razorpayOrderId: 'order_big',
        customerPhone: '9999999999',
        customerEmail: 'test@test.com',
        orderId: 'ORDBIG',
      );

      expect(request.amountPaise, 100000000);
    });
  });
}
