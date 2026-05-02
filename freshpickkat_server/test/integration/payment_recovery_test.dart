import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Payment recovery', (sessionBuilder, endpoints) {
    test('create pending order -> verify payment succeeds', () async {
      final orderId = await _createPendingOrder(endpoints, sessionBuilder);

      final verifyResult = await endpoints.payment.verifyPayment(
        sessionBuilder,
        orderId,
        'rzp_test_order',
        'fake_payment_id',
        '',
      );
      expect(verifyResult.success, isTrue);
      expect(verifyResult.verified, isTrue);

      final updatedOrder = await _findOrder(sessionBuilder, orderId);
      expect(updatedOrder, isNotNull);
      expect(updatedOrder!.paymentStatus, equals('paid'));
      expect(updatedOrder.orderStatus, equals('confirmed'));
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
    deliveryAddress: protocol.Address(
      street: '123 Testing Rd',
      city: 'Testville',
      state: 'Test',
      zipCode: '000000',
      country: 'Testland',
    ),
    orderedAt: DateTime.now(),
  );

  final idempotencyKey = 'itest-${DateTime.now().millisecondsSinceEpoch}';
  final orderId = await endpoints.order.createPendingOrder(
    sessionBuilder,
    order,
    idempotencyKey,
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
