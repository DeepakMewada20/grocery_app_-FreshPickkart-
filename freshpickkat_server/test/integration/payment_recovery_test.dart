import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_payment_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Payment recovery', (sessionBuilder, endpoints) {
    test('create pending order -> start verification (two-step)', () async {
      final orderId = await _createPendingOrder(endpoints, sessionBuilder);

      // Step 1: Client reports success → sets to VERIFYING
      final verifyResult = await endpoints.payment.verifyPayment(
        sessionBuilder,
        orderId,
        'rzp_test_order',
        'fake_payment_id',
        '',
      );
      expect(verifyResult.success, isTrue);
      expect(verifyResult.verified, isFalse);

      final updatedOrder = await _findOrder(sessionBuilder, orderId);
      expect(updatedOrder, isNotNull);
      expect(updatedOrder!.paymentStatus, equals('verifying'));
      expect(updatedOrder.orderStatus, equals('payment_verification'));
    });

    test('webhook can complete payment verification directly', () async {
      final orderId = await _createPendingOrder(endpoints, sessionBuilder);
      final session = sessionBuilder.build();

      try {
        // Webhook calls PostgresPaymentService.completePaymentVerification
        final paymentService = PostgresPaymentService();
        final result = await paymentService.completePaymentVerification(
          session,
          orderNumber: orderId,
          razorpayOrderId: 'rzp_test_order',
          razorpayPaymentId: 'fake_payment_id',
        );
        expect(result.success, isTrue);
        expect(result.verified, isTrue);

        final updatedOrder = await _findOrder(sessionBuilder, orderId);
        expect(updatedOrder, isNotNull);
        expect(updatedOrder!.paymentStatus, equals('paid'));
        expect(updatedOrder.orderStatus, equals('confirmed'));
      } finally {
        await session.close();
      }
    });

    test('mark payment as cancelled', () async {
      final orderId = await _createPendingOrder(endpoints, sessionBuilder);

      final cancelResult = await endpoints.payment.markPaymentFailed(
        sessionBuilder,
        orderId,
        'integration-user',
        '',
      );
      expect(cancelResult.success, isTrue);

      final updatedOrder = await _findOrder(sessionBuilder, orderId);
      expect(updatedOrder, isNotNull);
      expect(updatedOrder!.paymentStatus, equals('cancelled'));
      expect(updatedOrder.orderStatus, equals('payment_failed'));
    });
  });
}

Future<protocol.CustomerOrderRow?> _findOrder(
  TestSessionBuilder sessionBuilder,
  String orderId,
) async {
  final session = sessionBuilder.build();
  try {
    return protocol.CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderId),
    );
  } finally {
    await session.close();
  }
}

Future<String> _createPendingOrder(
  TestEndpoints endpoints,
  TestSessionBuilder sessionBuilder,
) async {
  final productId = await _seedProduct(sessionBuilder);
  final order = protocol.Order(
    orderId: '',
    userId: 'integration-user',
    userName: 'Integration Tester',
    userPhone: '9999999999',
    items: [
      protocol.OrderItem(
        productId: productId,
        productName: 'Integration Product',
        productImage: 'https://example.com/product.png',
        quantity: 1,
        unitPrice: 100.0,
        totalPrice: 100.0,
        isFreeItem: false,
      ),
    ],
    itemCount: 1,
    totalAmount: 100.0,
    discountAmount: 0.0,
    deliveryFee: 0.0,
    finalAmount: 100.0,
    status: 'pending',
    paymentStatus: 'pending',
    refundStatus: 'none',
    orderType: 'regular',
    sourceOrderNumber: null,
    complaintId: null,
    deliveryAddress: protocol.Address(
      street: '123 Testing Rd',
      city: 'Testville',
      state: 'Test',
      zipCode: '000000',
      country: 'Testland',
    ),
    orderedAt: DateTime.now(),
    freshPointsUsed: 0,
    freshPointsValue: 0.0,
    actualPaymentAmount: 100.0,
  );

  final idempotencyKey = 'itest-${DateTime.now().millisecondsSinceEpoch}';
  final orderId = await endpoints.order.createPendingOrder(
    sessionBuilder,
    order,
    idempotencyKey,
    freshPointsToRedeem: 0,
  );
  return orderId;
}

Future<String> _seedProduct(TestSessionBuilder sessionBuilder) async {
  final session = sessionBuilder.build();
  try {
    final category = await protocol.CategoryRow.db.insertRow(
      session,
      protocol.CategoryRow(
        name: 'Integration Category',
        slug: 'integration-category-${DateTime.now().millisecondsSinceEpoch}',
      ),
    );

    final product = await protocol.ProductRow.db.insertRow(
      session,
      protocol.ProductRow(
        categoryId: category.id!,
        name: 'Integration Product',
        slug: 'integration-product-${DateTime.now().millisecondsSinceEpoch}',
        primaryImageUrl: 'https://example.com/product.png',
      ),
    );

    return product.id!.toString();
  } finally {
    await session.close();
  }
}
