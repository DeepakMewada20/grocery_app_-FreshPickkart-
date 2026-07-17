import 'package:flutter_test/flutter_test.dart';
import 'package:freshpickkat_flutter/payment/models/payment_result.dart';

void main() {
  group('PaymentResultStatus enum', () {
    test('has all expected values', () {
      expect(PaymentResultStatus.values, hasLength(4));
      expect(PaymentResultStatus.values, contains(PaymentResultStatus.success));
      expect(PaymentResultStatus.values, contains(PaymentResultStatus.failed));
      expect(PaymentResultStatus.values, contains(PaymentResultStatus.cancelled));
      expect(PaymentResultStatus.values, contains(PaymentResultStatus.pending));
    });
  });

  group('PaymentResult.success', () {
    test('creates success result with all fields', () {
      const result = PaymentResult.success(
        razorpayPaymentId: 'pay_abc123',
        razorpayOrderId: 'order_xyz789',
        razorpaySignature: 'sig_def456',
      );

      expect(result.status, PaymentResultStatus.success);
      expect(result.razorpayPaymentId, 'pay_abc123');
      expect(result.razorpayOrderId, 'order_xyz789');
      expect(result.razorpaySignature, 'sig_def456');
      expect(result.errorMessage, isNull);
      expect(result.errorCode, isNull);
    });

    test('creates success result with empty signature', () {
      const result = PaymentResult.success(
        razorpayPaymentId: 'pay_abc123',
        razorpayOrderId: 'order_xyz789',
      );

      expect(result.status, PaymentResultStatus.success);
      expect(result.razorpayPaymentId, 'pay_abc123');
      expect(result.razorpaySignature, isNull);
    });
  });

  group('PaymentResult.failed', () {
    test('creates failed result with error details', () {
      const result = PaymentResult.failed(
        errorMessage: 'Payment failed at gateway',
        errorCode: 'PAYMENT_FAILED',
        razorpayPaymentId: 'pay_abc123',
      );

      expect(result.status, PaymentResultStatus.failed);
      expect(result.errorMessage, 'Payment failed at gateway');
      expect(result.errorCode, 'PAYMENT_FAILED');
      expect(result.razorpayPaymentId, 'pay_abc123');
      expect(result.razorpaySignature, isNull);
    });

    test('creates failed result without optional fields', () {
      const result = PaymentResult.failed();

      expect(result.status, PaymentResultStatus.failed);
      expect(result.errorMessage, isNull);
      expect(result.errorCode, isNull);
      expect(result.razorpayPaymentId, isNull);
      expect(result.razorpaySignature, isNull);
    });
  });

  group('PaymentResult.cancelled', () {
    test('creates cancelled result with error message', () {
      const result = PaymentResult.cancelled(
        errorMessage: 'User cancelled payment',
      );

      expect(result.status, PaymentResultStatus.cancelled);
      expect(result.errorMessage, 'User cancelled payment');
      expect(result.errorCode, isNull);
      expect(result.razorpayPaymentId, isNull);
      expect(result.razorpaySignature, isNull);
    });

    test('creates cancelled result without message', () {
      const result = PaymentResult.cancelled();

      expect(result.status, PaymentResultStatus.cancelled);
      expect(result.errorMessage, isNull);
    });
  });

  group('PaymentResult.pending', () {
    test('creates pending result with no fields', () {
      const result = PaymentResult.pending();

      expect(result.status, PaymentResultStatus.pending);
      expect(result.razorpayPaymentId, isNull);
      expect(result.razorpayOrderId, isNull);
      expect(result.razorpaySignature, isNull);
      expect(result.errorMessage, isNull);
      expect(result.errorCode, isNull);
    });
  });

  group('PaymentResult equality', () {
    test('identical success results are equal', () {
      const a = PaymentResult.success(
        razorpayPaymentId: 'pay_123',
        razorpayOrderId: 'order_456',
        razorpaySignature: 'sig_789',
      );
      const b = PaymentResult.success(
        razorpayPaymentId: 'pay_123',
        razorpayOrderId: 'order_456',
        razorpaySignature: 'sig_789',
      );

      expect(a, equals(b));
    });

    test('different results are not equal', () {
      const a = PaymentResult.success(
        razorpayPaymentId: 'pay_123',
        razorpayOrderId: 'order_456',
      );
      const b = PaymentResult.failed(errorMessage: 'Failed');

      expect(a, isNot(equals(b)));
    });
  });
}
