import 'package:serverpod/serverpod.dart' as serverpod;
import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_payment_link_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_payment_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Payment link flow', (sessionBuilder, endpoints) {
    late PostgresPaymentLinkService paymentLinkService;
    late PostgresPaymentService paymentService;

    setUp(() {
      paymentLinkService = PostgresPaymentLinkService();
      paymentService = PostgresPaymentService();
    });

    test('getPaymentSessionStatus returns session data for seeded order', () async {
      final session = sessionBuilder.build();
      try {
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999001',
            name: 'PL Test User',
            role: 'customer',
            status: 'active',
          ),
        );

        final now = DateTime.now().toUtc();
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'pl-test-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'pending',
            paymentStatus: 'pending',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            discountAmount: 0.0,
            deliveryFee: 0.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            paymentLinkUrl: 'https://rzp.io/i/test',
            paymentLinkExpiresAt: now.add(const Duration(hours: 1)),
            orderedAt: now,
          ),
        );

        final result = await paymentLinkService.getPaymentSessionStatus(
          session,
          order.orderNumber,
        );

        expect(result['orderNumber'], equals(order.orderNumber));
        expect(result['paymentStatus'], equals('pending'));
        expect(result['orderStatus'], equals('pending'));
        expect(result['paymentLinkUrl'], equals('https://rzp.io/i/test'));
      } finally {
        await session.close();
      }
    });

    test('disablePaymentLink disables link on an order', () async {
      final session = sessionBuilder.build();
      try {
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999002',
            name: 'PL Test User 2',
            role: 'customer',
            status: 'active',
          ),
        );

        final now = DateTime.now().toUtc();
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'pl-disable-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'pending',
            paymentStatus: 'pending',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            discountAmount: 0.0,
            deliveryFee: 0.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            paymentLinkUrl: 'https://rzp.io/i/test',
            paymentLinkExpiresAt: now.add(const Duration(hours: 1)),
            orderedAt: now,
          ),
        );

        await paymentLinkService.disablePaymentLink(session, order.orderNumber);

        final updated = await protocol.CustomerOrderRow.db.findById(session, order.id!);
        expect(updated, isNotNull);
        expect(updated!.linkStatus, equals('DISABLED'));
      } finally {
        await session.close();
      }
    });

    test('expireStaleSessions marks expired link orders as failed', () async {
      final session = sessionBuilder.build();
      try {
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999003',
            name: 'PL Test User 3',
            role: 'customer',
            status: 'active',
          ),
        );

        final now = DateTime.now().toUtc();
        final orderNumber = 'expired-${now.microsecondsSinceEpoch}';
        await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: orderNumber,
            userId: user.id!,
            orderStatus: 'placed',
            paymentStatus: 'pending',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            discountAmount: 0.0,
            deliveryFee: 0.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            paymentLinkUrl: 'https://rzp.io/i/expired',
            paymentLinkExpiresAt: now.subtract(const Duration(hours: 1)),
            orderedAt: now.subtract(const Duration(hours: 2)),
          ),
        );

        await paymentService.expireStaleSessions(session);

        final expiredOrder = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderNumber),
        );
        expect(expiredOrder, isNotNull);
        expect(expiredOrder!.paymentStatus, equals('cancelled'));
      } finally {
        await session.close();
      }
    });

    test('completePaymentVerification updates order status', () async {
      final session = sessionBuilder.build();
      try {
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999004',
            name: 'PL Test User 4',
            role: 'customer',
            status: 'active',
          ),
        );

        final now = DateTime.now().toUtc();
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'pl-verify-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'pending',
            paymentStatus: 'pending',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            discountAmount: 0.0,
            deliveryFee: 0.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            paymentLinkUrl: 'https://rzp.io/i/test',
            paymentLinkExpiresAt: now.add(const Duration(hours: 1)),
            orderedAt: now,
          ),
        );

        await protocol.PaymentTransactionRow.db.insertRow(
          session,
          protocol.PaymentTransactionRow(
            orderId: order.id!,
            userId: user.id!,
            idempotencyKey: 'pl-verify-${now.microsecondsSinceEpoch}',
            gatewayName: 'razorpay',
            amount: 100.0,
            paymentStatus: 'pending',
          ),
        );

        await paymentService.completePaymentVerification(
          session,
          orderNumber: order.orderNumber,
          razorpayOrderId: 'rzp_test_${now.microsecondsSinceEpoch}',
          razorpayPaymentId: 'pay_test_${now.microsecondsSinceEpoch}',
        );

        final updated = await protocol.CustomerOrderRow.db.findById(session, order.id!);
        expect(updated, isNotNull);
        expect(updated!.paymentStatus, equals('paid'));
      } finally {
        await session.close();
      }
    });
  });
}
