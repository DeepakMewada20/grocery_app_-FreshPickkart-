import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_order_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_delivery_verification_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_delivery_settings_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('COD abuse prevention', (sessionBuilder, endpoints) {
    late PostgresOrderService orderService;
    late PostgresDeliveryVerificationService verificationService;

    setUp(() {
      orderService = PostgresOrderService();
      verificationService = PostgresDeliveryVerificationService();
    });

    Future<protocol.AppUserRow> _seedUser(
      String phone, {
      int codPlaced = 0,
      int codDelivered = 0,
      int codRejected = 0,
      bool isBlocked = false,
      String? blockedReason,
    }) async {
      final session = sessionBuilder.build();
      try {
        final fbUid = 'fb-$phone';
      return await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            firebaseUid: fbUid,
            phoneNumber: phone,
            name: 'COD Abuse Test $phone',
            role: 'customer',
            status: 'active',
            codOrdersPlaced: codPlaced,
            codOrdersDelivered: codDelivered,
            codOrdersRejected: codRejected,
            isCodBlocked: isBlocked,
            codBlockedReason: blockedReason,
          ),
        );
      } finally {
        await session.close();
      }
    }

    Future<protocol.ProductRow> _seedProduct(String slug) async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final category = await protocol.CategoryRow.db.insertRow(
          session,
          protocol.CategoryRow(
            name: 'COD Abuse Cat',
            slug: 'cod-abuse-cat-${now.microsecondsSinceEpoch}',
          ),
        );
        final product = await protocol.ProductRow.db.insertRow(
          session,
          protocol.ProductRow(
            categoryId: category.id!,
            name: 'COD Abuse Product',
            slug: slug,
            stock: 50,
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

    Future<protocol.CustomerOrderRow> _seedOrder({
      required protocol.AppUserRow user,
      required String orderNumber,
      String paymentMode = 'cod',
      String orderStatus = 'out_for_delivery',
      String paymentStatus = 'paid',
    }) async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        return await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            userId: user.id!,
            orderNumber: orderNumber,
            orderStatus: orderStatus,
            paymentStatus: paymentStatus,
            refundStatus: 'none',
            paymentMode: paymentMode,
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );
      } finally {
        await session.close();
      }
    }

    Future<protocol.CodSettingsRow> _seedCodSettings({
      int maxFailures = 3,
      bool autoBlock = true,
    }) async {
      final session = sessionBuilder.build();
      try {
        return await protocol.CodSettingsRow.db.insertRow(
          session,
          protocol.CodSettingsRow(
            maximumAllowedCodFailures: maxFailures,
            enableAutoBlocking: autoBlock,
          ),
        );
      } finally {
        await session.close();
      }
    }

    // ── CodFailureRecord serialization test ──
    test('CodFailureRecord serialization roundtrip', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser('abuse-serial-01');
        final order = await _seedOrder(user: user, orderNumber: 'abuse-serial-01');
        final now = DateTime.now().toUtc();

        final record = await protocol.CodFailureRecord.db.insertRow(
          session,
          protocol.CodFailureRecord(
            orderId: order.id!,
            userId: user.id!,
            reason: 'CUSTOMER_REFUSED',
            failureNote: 'Customer refused to accept delivery',
            recordedBy: 'admin-001',
            recordedAt: now,
          ),
        );

        expect(record.id, isNotNull);
        expect(record.reason, equals('CUSTOMER_REFUSED'));
        expect(record.failureNote, equals('Customer refused to accept delivery'));
        expect(record.recordedBy, equals('admin-001'));

        // Verify uniqueness constraint
        await expectLater(
          () async {
            await protocol.CodFailureRecord.db.insertRow(
              session,
              protocol.CodFailureRecord(
                orderId: order.id!,
                userId: user.id!,
                reason: 'OTHER',
                recordedAt: now,
              ),
            );
          },
          throwsA(isA<Exception>()),
        );
      } finally {
        await session.close();
      }
    });

    // ── markCodDeliveryFailed happy path ──
    test('markCodDeliveryFailed cancels order and records failure', () async {
      final session = sessionBuilder.build();
      try {
        await _seedCodSettings();
        final user = await _seedUser('abuse-mark-01');
        final order = await _seedOrder(
          user: user,
          orderNumber: 'abuse-mark-01',
        );

        final result = await orderService.markCodDeliveryFailed(
          session,
          'abuse-mark-01',
          reason: 'CUSTOMER_REFUSED',
          failureNote: 'Customer said no',
          recordedBy: 'admin-001',
        );

        expect(result['success'], isTrue);
        expect(result['codFailureReason'], equals('CUSTOMER_REFUSED'));

        // Verify order cancelled
        final updatedOrder = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals('abuse-mark-01'),
        );
        expect(updatedOrder!.orderStatus, equals('cancelled'));
        expect(updatedOrder.codFailureReason, equals('CUSTOMER_REFUSED'));
        expect(updatedOrder.cancelledAt, isNotNull);
        expect(updatedOrder.cancellationReason, contains('COD_DELIVERY_FAILURE'));

        // Verify failure record created
        final records = await protocol.CodFailureRecord.db.find(
          session,
          where: (t) => t.orderId.equals(order.id!),
        );
        expect(records.length, equals(1));
        expect(records.first.reason, equals('CUSTOMER_REFUSED'));

        // Verify user counter incremented
        final updatedUser = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updatedUser!.codOrdersRejected, equals(1));
      } finally {
        await session.close();
      }
    });

    // ── markCodDeliveryFailed — all 6 reasons ──
    for (final reason in [
      'CUSTOMER_REFUSED',
      'CUSTOMER_UNAVAILABLE',
      'PAYMENT_REFUSED',
      'ADDRESS_NOT_FOUND',
      'DELIVERY_FAILED',
      'OTHER',
    ]) {
      test('markCodDeliveryFailed with reason: $reason', () async {
        final session = sessionBuilder.build();
        try {
          await _seedCodSettings();
          final suffix = reason.toLowerCase().replaceAll('_', '-');
          final user = await _seedUser('abuse-reason-$suffix');
          await _seedOrder(
            user: user,
            orderNumber: 'abuse-reason-$suffix',
          );

          await orderService.markCodDeliveryFailed(
            session,
            'abuse-reason-$suffix',
            reason: reason,
            recordedBy: 'admin-001',
          );

          final record = await protocol.CodFailureRecord.db.findFirstRow(
            session,
            where: (t) => t.userId.equals(user.id!),
          );
          expect(record!.reason, equals(reason));
        } finally {
          await session.close();
        }
      });
    }

    // ── markCodDeliveryFailed — non-COD order ──
    test('markCodDeliveryFailed throws for non-COD order', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser('abuse-noncod-01');
        final order = await _seedOrder(
          user: user,
          orderNumber: 'abuse-noncod-01',
          paymentMode: 'standard',
        );

        await expectLater(
          () => orderService.markCodDeliveryFailed(
            session,
            'abuse-noncod-01',
            reason: 'CUSTOMER_REFUSED',
          ),
          throwsA(predicate((e) => e.toString().contains('non-COD'))),
        );
      } finally {
        await session.close();
      }
    });

    // ── markCodDeliveryFailed — wrong status ──
    test('markCodDeliveryFailed throws when not out_for_delivery', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser('abuse-status-01');
        await _seedOrder(
          user: user,
          orderNumber: 'abuse-status-01',
          orderStatus: 'confirmed',
        );

        await expectLater(
          () => orderService.markCodDeliveryFailed(
            session,
            'abuse-status-01',
            reason: 'CUSTOMER_REFUSED',
          ),
          throwsA(predicate((e) => e.toString().contains('out_for_delivery'))),
        );
      } finally {
        await session.close();
      }
    });

    // ── markCodDeliveryFailed — duplicate ──
    test('markCodDeliveryFailed throws for duplicate', () async {
      final session = sessionBuilder.build();
      try {
        await _seedCodSettings();
        final user = await _seedUser('abuse-dup-01');
        await _seedOrder(
          user: user,
          orderNumber: 'abuse-dup-01',
        );

        // First call succeeds
        await orderService.markCodDeliveryFailed(
          session,
          'abuse-dup-01',
          reason: 'CUSTOMER_REFUSED',
        );

        // Second call throws
        await expectLater(
          () => orderService.markCodDeliveryFailed(
            session,
            'abuse-dup-01',
            reason: 'OTHER',
          ),
          throwsA(predicate((e) => e.toString().contains('already recorded'))),
        );
      } finally {
        await session.close();
      }
    });

    // ── Auto-blocking at threshold ──
    test('auto-blocks user when codOrdersRejected reaches threshold', () async {
      final session = sessionBuilder.build();
      try {
        await _seedCodSettings(maxFailures: 2);
        final user = await _seedUser(
          'abuse-block-01',
          codRejected: 1, // already has 1 rejection
        );

        // Seed the order
        await _seedOrder(
          user: user,
          orderNumber: 'abuse-block-01',
        );

        // This failure takes rejections from 1 → 2, reaching threshold
        await orderService.markCodDeliveryFailed(
          session,
          'abuse-block-01',
          reason: 'CUSTOMER_REFUSED',
        );

        final updatedUser = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updatedUser!.isCodBlocked, isTrue);
        expect(updatedUser.codBlockedReason, equals('REPEATED_DELIVERY_REFUSAL'));
        expect(updatedUser.codBlockedAt, isNotNull);
        expect(updatedUser.codOrdersRejected, equals(2));
      } finally {
        await session.close();
      }
    });

    // ── Auto-blocking disabled ──
    test('does not auto-block when enableAutoBlocking is false', () async {
      final session = sessionBuilder.build();
      try {
        await _seedCodSettings(maxFailures: 1, autoBlock: false);
        final user = await _seedUser('abuse-noblock-01');

        await _seedOrder(
          user: user,
          orderNumber: 'abuse-noblock-01',
        );

        await orderService.markCodDeliveryFailed(
          session,
          'abuse-noblock-01',
          reason: 'CUSTOMER_REFUSED',
        );

        final updatedUser = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updatedUser!.isCodBlocked, isFalse);
        expect(updatedUser.codOrdersRejected, equals(1));
      } finally {
        await session.close();
      }
    });

    // ── Auto-unblock via updateOrderStatus('delivered') for ONLINE order ──
    test('auto-unblocks user when prepaid ONLINE order is delivered', () async {
      final session = sessionBuilder.build();
      try {
        await _seedCodSettings();
        final user = await _seedUser(
          'abuse-unblock-online-01',
          codPlaced: 3,
          codDelivered: 2,
          codRejected: 3,
          isBlocked: true,
          blockedReason: 'REPEATED_DELIVERY_REFUSAL',
        );

        // Seed a prepaid ORDER order that is paid and pending delivery
        final now = DateTime.now().toUtc();
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            userId: user.id!,
            orderNumber: 'abuse-unblock-online-01',
            orderStatus: 'out_for_delivery',
            paymentStatus: 'paid',
            refundStatus: 'none',
            paymentMode: 'standard',
            itemCount: 1,
            totalAmount: 200.0,
            finalAmount: 200.0,
            orderedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        // Deliver via updateOrderStatus
        await orderService.updateOrderStatus(
          session,
          'abuse-unblock-online-01',
          'delivered',
        );

        final updatedUser = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updatedUser!.isCodBlocked, isFalse);
        expect(updatedUser.codBlockedReason, isNull);
        expect(updatedUser.codBlockedAt, isNull);
        // Counters preserved
        expect(updatedUser.codOrdersRejected, equals(3));
        expect(updatedUser.codOrdersPlaced, equals(3));
        expect(updatedUser.codOrdersDelivered, equals(2));
      } finally {
        await session.close();
      }
    });

    // ── Auto-unblock via completePhotoDelivery for prepaid order ──
    test('auto-unblocks user when prepaid order delivered via photo', () async {
      final session = sessionBuilder.build();
      try {
        await _seedCodSettings();
        final user = await _seedUser(
          'abuse-unblock-photo-01',
          codRejected: 3,
          isBlocked: true,
          blockedReason: 'REPEATED_DELIVERY_REFUSAL',
        );

        // Seed a prepaid order with paid status
        final now = DateTime.now().toUtc();
        await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            userId: user.id!,
            orderNumber: 'abuse-unblock-photo-01',
            orderStatus: 'out_for_delivery',
            paymentStatus: 'paid',
            refundStatus: 'none',
            paymentMode: 'standard',
            itemCount: 1,
            totalAmount: 200.0,
            finalAmount: 200.0,
            orderedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        // Also need an address with coordinates for photo delivery
        final orderRow = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals('abuse-unblock-photo-01'),
        );
        await protocol.OrderAddressRow.db.insertRow(
          session,
          protocol.OrderAddressRow(
            orderId: orderRow!.id!,
            streetLine1: '123 Test St',
            city: 'Test City',
            state: 'Test State',
            postalCode: '12345',
            country: 'India',
            latitude: 28.6130,
            longitude: 77.2296,
            createdAt: now,
          ),
        );

        // Seed delivery settings
        final settingsService = PostgresDeliverySettingsService();
        await settingsService.getOrCreateSettings(session);

        // Deliver via photo
        await verificationService.completePhotoDelivery(
          session,
          orderId: 'abuse-unblock-photo-01',
          imageUrl: 'https://example.com/delivery.jpg',
          latitude: 28.6130,
          longitude: 77.2296,
          gpsAccuracy: 10.0,
          adminFirebaseUid: 'admin-fb-001',
          adminName: 'Test Admin',
        );

        final updatedUser = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updatedUser!.isCodBlocked, isFalse);
        expect(updatedUser.codBlockedReason, isNull);
        expect(updatedUser.codBlockedAt, isNull);
        // Counters preserved
        expect(updatedUser.codOrdersRejected, equals(3));
      } finally {
        await session.close();
      }
    });

    // ── Auto-unblock via SHAREABLE_LINK ──
    test('auto-unblocks user when shareable_link order is delivered', () async {
      final session = sessionBuilder.build();
      try {
        await _seedCodSettings();
        final user = await _seedUser(
          'abuse-unblock-link-01',
          codRejected: 3,
          isBlocked: true,
          blockedReason: 'REPEATED_DELIVERY_REFUSAL',
        );

        final now = DateTime.now().toUtc();
        await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            userId: user.id!,
            orderNumber: 'abuse-unblock-link-01',
            orderStatus: 'out_for_delivery',
            paymentStatus: 'paid',
            refundStatus: 'none',
            paymentMode: 'shareable_link',
            itemCount: 1,
            totalAmount: 200.0,
            finalAmount: 200.0,
            orderedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        await orderService.updateOrderStatus(
          session,
          'abuse-unblock-link-01',
          'delivered',
        );

        final updatedUser = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updatedUser!.isCodBlocked, isFalse);
      } finally {
        await session.close();
      }
    });

    // ── Non-blocked user unaffected ──
    test('auto-unblock does not affect non-blocked user', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser('abuse-nonblocked-01');

        final now = DateTime.now().toUtc();
        await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            userId: user.id!,
            orderNumber: 'abuse-nonblocked-01',
            orderStatus: 'out_for_delivery',
            paymentStatus: 'paid',
            refundStatus: 'none',
            paymentMode: 'standard',
            itemCount: 1,
            totalAmount: 200.0,
            finalAmount: 200.0,
            orderedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        await orderService.updateOrderStatus(
          session,
          'abuse-nonblocked-01',
          'delivered',
        );

        final updatedUser = await protocol.AppUserRow.db.findById(session, user.id!);
        expect(updatedUser!.isCodBlocked, isFalse);
      } finally {
        await session.close();
      }
    });

    // ── COD eligibility in checkout ──
    test('getCheckoutInitHydrated returns codAvailable=false for blocked user', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser(
          'abuse-checkout-01',
          isBlocked: true,
          blockedReason: 'REPEATED_DELIVERY_REFUSAL',
        );

        final result = await endpoints.checkout.getCheckoutInitHydrated(
          sessionBuilder,
          [],
          userId: 'fb-abuse-checkout-01',
          autoApplyCoupons: false,
          basketMode: 'cart',
          freshPointsToRedeem: 0,
        );

        expect(result.codAvailable, isFalse);
        expect(result.codDisabledReason, equals('REPEATED_DELIVERY_REFUSAL'));
      } finally {
        await session.close();
      }
    });

    test('getCheckoutInitHydrated returns codAvailable=true for normal user', () async {
      final session = sessionBuilder.build();
      try {
        final user = await _seedUser('abuse-checkout-02');

        final result = await endpoints.checkout.getCheckoutInitHydrated(
          sessionBuilder,
          [],
          userId: 'fb-abuse-checkout-02',
          autoApplyCoupons: false,
          basketMode: 'cart',
          freshPointsToRedeem: 0,
        );

        expect(result.codAvailable, isTrue);
        expect(result.codDisabledReason, isNull);
      } finally {
        await session.close();
      }
    });
  });
}
