import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_payment_link_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_order_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_payment_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Payment link fixes', (sessionBuilder, endpoints) {
    late PostgresPaymentLinkService paymentLinkService;
    late PostgresOrderService orderService;
    late PostgresPaymentService paymentService;

    setUp(() {
      paymentLinkService = PostgresPaymentLinkService();
      orderService = PostgresOrderService();
      paymentService = PostgresPaymentService();
    });

    test(
      'cancelPendingOrder removes order from findActivePendingOrder',
      () async {
        final session = sessionBuilder.build();
        try {
          final now = DateTime.now().toUtc();
          final firebaseUid = 'test_fb_${now.microsecondsSinceEpoch}';
          final user = await protocol.AppUserRow.db.insertRow(
            session,
            protocol.AppUserRow(
              phoneNumber: '9999999101',
              name: 'PLF Test User 1',
              role: 'customer',
              status: 'active',
              firebaseUid: firebaseUid,
            ),
          );

          final order = await protocol.CustomerOrderRow.db.insertRow(
            session,
            protocol.CustomerOrderRow(
              orderNumber: 'plf-${now.microsecondsSinceEpoch}',
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
              orderedAt: now,
            ),
          );

          var active = await orderService.findActivePendingOrder(
            session,
            firebaseUid,
          );
          expect(active, isNotNull);
          expect(active!.orderNumber, equals(order.orderNumber));

          await orderService.cancelPendingOrder(
            session,
            order.orderNumber,
            firebaseUid,
            reason: 'Test cancel',
          );

          active = await orderService.findActivePendingOrder(
            session,
            firebaseUid,
          );
          expect(active, isNull);
        } finally {
          await session.close();
        }
      },
    );

    test(
      'multiple payment transactions with null gatewayOrderId is allowed',
      () async {
        final session = sessionBuilder.build();
        try {
          final now = DateTime.now().toUtc();
          final user1 = await protocol.AppUserRow.db.insertRow(
            session,
            protocol.AppUserRow(
              phoneNumber: '9999999102',
              name: 'PLF Test User 2',
              role: 'customer',
              status: 'active',
            ),
          );

          final order1 = await protocol.CustomerOrderRow.db.insertRow(
            session,
            protocol.CustomerOrderRow(
              orderNumber: 'plf-null-${now.microsecondsSinceEpoch}',
              userId: user1.id!,
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
              orderedAt: now,
            ),
          );

          await protocol.PaymentTransactionRow.db.insertRow(
            session,
            protocol.PaymentTransactionRow(
              orderId: order1.id!,
              userId: user1.id!,
              idempotencyKey: 'null-gw-1-${now.microsecondsSinceEpoch}',
              gatewayName: 'razorpay',
              gatewayOrderId: null,
              amount: 100.0,
              paymentStatus: 'pending',
            ),
          );

          final user2 = await protocol.AppUserRow.db.insertRow(
            session,
            protocol.AppUserRow(
              phoneNumber: '9999999103',
              name: 'PLF Test User 3',
              role: 'customer',
              status: 'active',
            ),
          );

          final order2 = await protocol.CustomerOrderRow.db.insertRow(
            session,
            protocol.CustomerOrderRow(
              orderNumber: 'plf-null-2-${now.microsecondsSinceEpoch}',
              userId: user2.id!,
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
              orderedAt: now,
            ),
          );

          await protocol.PaymentTransactionRow.db.insertRow(
            session,
            protocol.PaymentTransactionRow(
              orderId: order2.id!,
              userId: user2.id!,
              idempotencyKey: 'null-gw-2-${now.microsecondsSinceEpoch}',
              gatewayName: 'razorpay',
              gatewayOrderId: null,
              amount: 100.0,
              paymentStatus: 'pending',
            ),
          );

          final all = await protocol.PaymentTransactionRow.db.find(session);
          final nullGw = all.where((t) => t.gatewayOrderId == null);
          expect(nullGw.length, greaterThanOrEqualTo(2));
        } finally {
          await session.close();
        }
      },
    );

    test('disablePaymentLink sets linkStatus to DISABLED', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999104',
            name: 'PLF Test User 4',
            role: 'customer',
            status: 'active',
          ),
        );

        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'plf-disable-${now.microsecondsSinceEpoch}',
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
            paymentLinkUrl: 'https://rzp.io/i/test',
            paymentLinkExpiresAt: now.add(const Duration(hours: 1)),
            orderedAt: now,
          ),
        );

        await paymentLinkService.disablePaymentLink(session, order.orderNumber);

        final updated = await protocol.CustomerOrderRow.db.findById(
          session,
          order.id!,
        );
        expect(updated, isNotNull);
        expect(updated!.linkStatus, equals('DISABLED'));
      } finally {
        await session.close();
      }
    });

    test('expireStaleSessions cancels expired link orders', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999105',
            name: 'PLF Test User 5',
            role: 'customer',
            status: 'active',
          ),
        );

        final orderNumber = 'plf-exp-${now.microsecondsSinceEpoch}';
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

    test('getPaymentSessionStatus returns correct data', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await protocol.AppUserRow.db.insertRow(
          session,
          protocol.AppUserRow(
            phoneNumber: '9999999106',
            name: 'PLF Test User 6',
            role: 'customer',
            status: 'active',
          ),
        );

        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'plf-status-${now.microsecondsSinceEpoch}',
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
        expect(result['paymentLinkUrl'], equals('https://rzp.io/i/test'));
      } finally {
        await session.close();
      }
    });
  });
}
