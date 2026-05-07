import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_order_tracking_service.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Order tracking storage', (sessionBuilder, endpoints) {
    test(
      'persists tracking metadata and rider coordinates in PostgreSQL',
      () async {
        final orderId = await _createPendingOrder(endpoints, sessionBuilder);
        final session = sessionBuilder.build();
        final trackingService = PostgresOrderTrackingService();

        try {
          final seeded = await trackingService.seedUserLocation(
            session,
            orderNumber: orderId,
            userLatitude: 28.6139,
            userLongitude: 77.2090,
            userAddress: 'Customer address',
            userLocationType: 'saved',
          );

          expect(seeded.userLatitude, equals(28.6139));
          expect(seeded.userLongitude, equals(77.2090));
          expect(seeded.trackingEnabled, isFalse);

          final updated = await trackingService.updateRiderLocation(
            session,
            orderNumber: orderId,
            riderLatitude: 28.6200,
            riderLongitude: 77.2150,
          );

          expect(updated.trackingEnabled, isTrue);
          expect(updated.riderLatitude, equals(28.6200));
          expect(updated.riderLongitude, equals(77.2150));

          final order = await protocol.CustomerOrderRow.db.findFirstRow(
            session,
            where: (t) => t.orderNumber.equals(orderId),
          );
          expect(order?.id, isNotNull);

          final trackingRow = await protocol.OrderTrackingRow.db.findFirstRow(
            session,
            where: (t) => t.orderId.equals(order!.id!),
          );

          expect(trackingRow, isNotNull);
          expect(trackingRow!.trackingEnabled, isTrue);
          expect(trackingRow.userLatitude, equals(28.6139));
          expect(trackingRow.userLongitude, equals(77.2090));
          expect(trackingRow.riderLatitude, equals(28.6200));
          expect(trackingRow.riderLongitude, equals(77.2150));

          final fetched = await trackingService.getTracking(session, orderId);
          expect(fetched?.riderLatitude, equals(28.6200));
          expect(fetched?.riderLongitude, equals(77.2150));
        } finally {
          await session.close();
        }
      },
    );
  });
}

Future<String> _createPendingOrder(
  TestEndpoints endpoints,
  TestSessionBuilder sessionBuilder,
) async {
  final productId = await _seedProduct(sessionBuilder);
  final suffix = DateTime.now().microsecondsSinceEpoch;
  final order = protocol.Order(
    orderId: '',
    userId: 'tracking-user-$suffix',
    userName: 'Tracking Tester',
    userPhone: '9999999999',
    items: [
      protocol.OrderItem(
        productId: productId,
        productName: 'Tracking Product',
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
      street: '123 Tracking Rd',
      city: 'Testville',
      state: 'Test',
      zipCode: '000000',
      country: 'Testland',
      latitude: 28.6139,
      longitude: 77.2090,
    ),
    orderedAt: DateTime.now(),
  );

  return endpoints.order.createPendingOrder(
    sessionBuilder,
    order,
    'tracking-itest-$suffix',
  );
}

Future<String> _seedProduct(TestSessionBuilder sessionBuilder) async {
  final session = sessionBuilder.build();
  try {
    final suffix = DateTime.now().microsecondsSinceEpoch;
    final category = await protocol.CategoryRow.db.insertRow(
      session,
      protocol.CategoryRow(
        name: 'Tracking Category $suffix',
        slug: 'tracking-category-$suffix',
      ),
    );

    final product = await protocol.ProductRow.db.insertRow(
      session,
      protocol.ProductRow(
        categoryId: category.id!,
        name: 'Tracking Product $suffix',
        slug: 'tracking-product-$suffix',
        primaryImageUrl: 'https://example.com/product.png',
      ),
    );

    return product.id!.toString();
  } finally {
    await session.close();
  }
}
