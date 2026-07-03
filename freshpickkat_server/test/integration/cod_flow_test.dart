import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_order_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('COD order flow', (sessionBuilder, endpoints) {
    late PostgresOrderService orderService;

    setUp(() {
      orderService = PostgresOrderService();
    });

    Future<protocol.AppUserRow> _seedUser(
      String phone, {
      int freshPoints = 0,
    }) async {
      final session = sessionBuilder.build();
      try {
        return await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: phone,
            name: 'COD Test User $phone',
            role: 'customer',
            status: 'active',
            currentFreshPoints: freshPoints,
            totalEarned: freshPoints,
          ),
        );
      } finally {
        await session.close();
      }
    }

    Future<protocol.ProductRow> _seedProductWithStock(
      String slug, {
      double stock = 10,
    }) async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final category = await protocol.CategoryRow.db.insertRow(
          session,
          protocol.CategoryRow(
            name: 'COD Test Cat',
            slug: 'cod-cat-${now.microsecondsSinceEpoch}',
          ),
        );
        final product = await protocol.ProductRow.db.insertRow(
          session,
          protocol.ProductRow(
            categoryId: category.id!,
            name: 'COD Product',
            slug: slug,
            stock: stock,
          ),
        );
        await protocol.ProductVariantRow.db.insertRow(
          session,
          protocol.ProductVariantRow(
            productId: product.id!,
            label: '1 kg',
            quantityValue: 1.0,
            quantityUnit: 'kg',
            salePrice: 100.0,
            listPrice: 120.0,
            isDefault: true,
          ),
        );
        return product;
      } finally {
        await session.close();
      }
    }

    protocol.Order _buildOrder({
      required protocol.AppUserRow user,
      required String productId,
      required String orderNumber,
      double amount = 100.0,
      int freshPointsUsed = 0,
    }) {
      final now = DateTime.now().toUtc();
      return protocol.Order(
        orderId: orderNumber,
        userId: user.id.toString(),
        userPhone: user.phoneNumber,
        items: [
          protocol.OrderItem(
            productId: productId,
            productName: 'COD Product',
            productImage: 'https://example.com/img.jpg',
            quantity: 1,
            unitPrice: 100.0,
            totalPrice: amount,
            isFreeItem: false,
          ),
        ],
        itemCount: 1,
        totalAmount: amount,
        discountAmount: 0.0,
        deliveryFee: 0.0,
        freshPointsUsed: freshPointsUsed,
        freshPointsValue: freshPointsUsed > 0 ? freshPointsUsed.toDouble() : 0.0,
        actualPaymentAmount: amount - (freshPointsUsed > 0 ? freshPointsUsed.toDouble() : 0.0),
        finalAmount: amount - (freshPointsUsed > 0 ? freshPointsUsed.toDouble() : 0.0),
        status: 'pending',
        paymentStatus: 'pending',
        refundStatus: 'none',
        deliveryAddress: protocol.Address(
          street: '123 Test St',
          city: 'Test City',
          state: 'Test State',
          zipCode: '12345',
          country: 'India',
        ),
        orderedAt: now,
        orderType: 'regular',
        paymentMode: 'cod',
      );
    }

    test('creates COD order with confirmed status and COD payment mode', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser('9999999901');
        final product = await _seedProductWithStock('cod-happy-${now.microsecondsSinceEpoch}');

        final order = _buildOrder(
          user: user,
          productId: product.id.toString(),
          orderNumber: 'cod-happy-${now.microsecondsSinceEpoch}',
        );

        final result = await endpoints.checkout.createCodOrder(
          sessionBuilder,
          order,
          'cod-key-${now.microsecondsSinceEpoch}',
          freshPointsToRedeem: 0,
        );

        expect(result.success, isTrue);
        expect(result.orderId, isNotEmpty);

        final dbOrder = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(result.orderId!),
        );
        expect(dbOrder, isNotNull);
        expect(dbOrder!.orderStatus, equals('confirmed'));
        expect(dbOrder.paymentStatus, equals('pending'));
        expect(dbOrder.paymentMode, equals('cod'));
        expect(dbOrder.freshPointsUsed, equals(0));
        expect(dbOrder.confirmedAt, isNotNull);
      } finally {
        await session.close();
      }
    });

    test('duplicate idempotency key returns same order number', () async {
      final now = DateTime.now().toUtc();
      final idempotencyKey = 'cod-dup-${now.microsecondsSinceEpoch}';
      final user = await _seedUser('9999999902');
      final product = await _seedProductWithStock('cod-dup-${now.microsecondsSinceEpoch}');

      final order = _buildOrder(
        user: user,
        productId: product.id.toString(),
        orderNumber: 'cod-dup-${now.microsecondsSinceEpoch}',
      );

      final result1 = await endpoints.checkout.createCodOrder(
        sessionBuilder,
        order,
        idempotencyKey,
        freshPointsToRedeem: 0,
      );

      final result2 = await endpoints.checkout.createCodOrder(
        sessionBuilder,
        order,
        idempotencyKey,
        freshPointsToRedeem: 0,
      );

      expect(result1.success, isTrue);
      expect(result2.success, isTrue);
      expect(result2.orderId, equals(result1.orderId));
    });

    test('rejects COD order with FreshPoints when allowRedemptionOnCOD is false', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();

        // Ensure settings row exists with allowRedemptionOnCOD = false
        final existingSettings = await protocol.FreshPointsSettingsRow.db.findFirstRow(session);
        if (existingSettings != null) {
          await protocol.FreshPointsSettingsRow.db.updateRow(
            session,
            existingSettings.copyWith(allowRedemptionOnCOD: false),
          );
        } else {
          await protocol.FreshPointsSettingsRow.db.insertRow(
            session,
            protocol.FreshPointsSettingsRow(
              isEnabled: true,
              redemptionPercentageLimit: 50.0,
              allowRedemptionOnCOD: false,
              minimumOrderForRedemption: 0,
              enablePointExpiry: false,
              pointExpiryDays: 90,
              enableAdminAdjustments: true,
              updatedAt: now,
            ),
          );
        }

        final user = await _seedUser('9999999903', freshPoints: 500);
        final product = await _seedProductWithStock('cod-fp-disabled-${now.microsecondsSinceEpoch}');

        final order = _buildOrder(
          user: user,
          productId: product.id.toString(),
          orderNumber: 'cod-fp-disabled-${now.microsecondsSinceEpoch}',
          freshPointsUsed: 50,
          amount: 200.0,
        );

        final result = await endpoints.checkout.createCodOrder(
          sessionBuilder,
          order,
          'cod-fp-disabled-key-${now.microsecondsSinceEpoch}',
          freshPointsToRedeem: 50,
        );

        expect(result.success, isFalse);
        expect(result.error, contains('FreshPoints cannot be redeemed on COD'));
      } finally {
        await session.close();
      }
    });

    test('accepts COD order with FreshPoints when allowRedemptionOnCOD is true', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();

        // Ensure settings row exists with allowRedemptionOnCOD = true
        final existingSettings = await protocol.FreshPointsSettingsRow.db.findFirstRow(session);
        if (existingSettings != null) {
          await protocol.FreshPointsSettingsRow.db.updateRow(
            session,
            existingSettings.copyWith(allowRedemptionOnCOD: true),
          );
        } else {
          await protocol.FreshPointsSettingsRow.db.insertRow(
            session,
            protocol.FreshPointsSettingsRow(
              isEnabled: true,
              redemptionPercentageLimit: 50.0,
              allowRedemptionOnCOD: true,
              minimumOrderForRedemption: 0,
              enablePointExpiry: false,
              pointExpiryDays: 90,
              enableAdminAdjustments: true,
              updatedAt: now,
            ),
          );
        }

        final user = await _seedUser('9999999904', freshPoints: 500);
        final product = await _seedProductWithStock('cod-fp-enabled-${now.microsecondsSinceEpoch}');

        final order = _buildOrder(
          user: user,
          productId: product.id.toString(),
          orderNumber: 'cod-fp-enabled-${now.microsecondsSinceEpoch}',
          freshPointsUsed: 50,
          amount: 200.0,
        );

        final result = await endpoints.checkout.createCodOrder(
          sessionBuilder,
          order,
          'cod-fp-enabled-key-${now.microsecondsSinceEpoch}',
          freshPointsToRedeem: 50,
        );

        expect(result.success, isTrue);
        expect(result.orderId, isNotEmpty);

        final dbUser = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(dbUser!.currentFreshPoints, equals(450));
      } finally {
        await session.close();
      }
    });

    test('deducts stock on COD order creation', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final category = await protocol.CategoryRow.db.insertRow(
          session,
          protocol.CategoryRow(
            name: 'COD Stock Cat',
            slug: 'cod-stock-cat-${now.microsecondsSinceEpoch}',
          ),
        );
        final product = await protocol.ProductRow.db.insertRow(
          session,
          protocol.ProductRow(
            categoryId: category.id!,
            name: 'COD Stock Product',
            slug: 'cod-stock-${now.microsecondsSinceEpoch}',
            stock: 5,
          ),
        );

        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999905',
            name: 'COD Stock User',
            role: 'customer',
            status: 'active',
          ),
        );

        final order = _buildOrder(
          user: user,
          productId: product.id.toString(),
          orderNumber: 'cod-stock-${now.microsecondsSinceEpoch}',
        );

        await endpoints.checkout.createCodOrder(
          sessionBuilder,
          order,
          'cod-stock-key-${now.microsecondsSinceEpoch}',
          freshPointsToRedeem: 0,
        );

        final dbProduct = await protocol.ProductRow.db.findById(session, product.id!);
        expect(dbProduct!.stock, lessThan(5.0));
      } finally {
        await session.close();
      }
    });

    test('rejects COD order with empty idempotency key', () async {
      final now = DateTime.now().toUtc();
      final user = await _seedUser('9999999906');
      final product = await _seedProductWithStock('cod-empty-key-${now.microsecondsSinceEpoch}');

      final order = _buildOrder(
        user: user,
        productId: product.id.toString(),
        orderNumber: 'cod-empty-key-${now.microsecondsSinceEpoch}',
      );

      final result = await endpoints.checkout.createCodOrder(
        sessionBuilder,
        order,
        '',
        freshPointsToRedeem: 0,
      );

      expect(result.success, isFalse);
      expect(result.error, isNotEmpty);
    });

    test('COD order has confirmedAt set at creation time', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser('9999999907');
        final product = await _seedProductWithStock('cod-confirmed-at-${now.microsecondsSinceEpoch}');

        final order = _buildOrder(
          user: user,
          productId: product.id.toString(),
          orderNumber: 'cod-confirmed-at-${now.microsecondsSinceEpoch}',
        );

        final result = await endpoints.checkout.createCodOrder(
          sessionBuilder,
          order,
          'cod-confirmed-at-key-${now.microsecondsSinceEpoch}',
          freshPointsToRedeem: 0,
        );

        expect(result.success, isTrue);

        final dbOrder = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(result.orderId!),
        );
        expect(dbOrder, isNotNull);
        expect(dbOrder!.confirmedAt, isNotNull);
        expect(dbOrder.placedAt, isNotNull);
        expect(dbOrder.orderedAt, isNotNull);

        // confirmedAt should be close to now
        final diff = now.difference(dbOrder.confirmedAt!).inSeconds.abs();
        expect(diff, lessThan(5));
      } finally {
        await session.close();
      }
    });

    test('orders with different idempotency keys create separate orders', () async {
      final now = DateTime.now().toUtc();
      final user = await _seedUser('9999999908');
      final product = await _seedProductWithStock('cod-multi-${now.microsecondsSinceEpoch}');

      final order1 = _buildOrder(
        user: user,
        productId: product.id.toString(),
        orderNumber: 'cod-multi-1-${now.microsecondsSinceEpoch}',
      );
      final order2 = _buildOrder(
        user: user,
        productId: product.id.toString(),
        orderNumber: 'cod-multi-2-${now.microsecondsSinceEpoch}',
      );

      final r1 = await endpoints.checkout.createCodOrder(
        sessionBuilder,
        order1,
        'cod-multi-key-1-${now.microsecondsSinceEpoch}',
        freshPointsToRedeem: 0,
      );
      final r2 = await endpoints.checkout.createCodOrder(
        sessionBuilder,
        order2,
        'cod-multi-key-2-${now.microsecondsSinceEpoch}',
        freshPointsToRedeem: 0,
      );

      expect(r1.success, isTrue);
      expect(r2.success, isTrue);
      expect(r1.orderId, isNot(equals(r2.orderId)));
    });
  });
}
