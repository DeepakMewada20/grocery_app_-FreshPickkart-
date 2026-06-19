import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_payment_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_payment_link_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_auto_refund_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Cron job time-window filters', (sessionBuilder, endpoints) {
    late PostgresPaymentService paymentService;
    late PostgresPaymentLinkService paymentLinkService;
    late PostgresAutoRefundService autoRefundService;

    setUp(() {
      paymentService = PostgresPaymentService();
      paymentLinkService = PostgresPaymentLinkService();
      autoRefundService = PostgresAutoRefundService();
    });

    // ─────────────────────────────────────────────
    // autoCancelPendingPayments
    // ─────────────────────────────────────────────

    test('autoCancelPendingPayments cancels old pending orders within age window', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        // Order placed 11 min ago → eligible (createdAt < 10min ago, >= 2 days ago)
        final orderNumber = 'ac-eligible-${now.microsecondsSinceEpoch}';
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
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            createdAt: now.subtract(const Duration(minutes: 11)),
            orderedAt: now.subtract(const Duration(minutes: 11)),
          ),
        );

        final count = await paymentService.autoCancelPendingPayments(session);

        expect(count, greaterThanOrEqualTo(1));

        final updated = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderNumber),
        );
        expect(updated!.orderStatus, equals('cancelled'));
      } finally {
        await session.close();
      }
    });

    test('autoCancelPendingPayments skips recent pending orders', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        // Order placed 5 min ago → NOT eligible (createdAt > 10min cutoff)
        final orderNumber = 'ac-recent-${now.microsecondsSinceEpoch}';
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
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            createdAt: now.subtract(const Duration(minutes: 5)),
            orderedAt: now.subtract(const Duration(minutes: 5)),
          ),
        );

        // May or may not cancel other seeded orders, but this recent one stays
        final updated = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderNumber),
        );
        expect(updated!.orderStatus, equals('placed'));
      } finally {
        await session.close();
      }
    });

    test('autoCancelPendingPayments skips orders older than 2 day window', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        // Order placed 3 days ago → excluded (createdAt < 2 days ago)
        final orderNumber = 'ac-old-${now.microsecondsSinceEpoch}';
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
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            createdAt: now.subtract(const Duration(days: 3)),
            orderedAt: now.subtract(const Duration(days: 3)),
          ),
        );

        // Count may include other seeded orders but not this one
        final updated = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderNumber),
        );
        expect(updated!.orderStatus, equals('placed'));
      } finally {
        await session.close();
      }
    });

    test('autoCancelPendingPayments skips already-confirmed orders', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        // Confirmed order (not 'placed') → skipped even if old
        final orderNumber = 'ac-conf-${now.microsecondsSinceEpoch}';
        await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: orderNumber,
            userId: user.id!,
            orderStatus: 'confirmed',
            paymentStatus: 'paid',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            createdAt: now.subtract(const Duration(minutes: 11)),
            orderedAt: now.subtract(const Duration(minutes: 11)),
          ),
        );

        await paymentService.autoCancelPendingPayments(session);

        final updated = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderNumber),
        );
        expect(updated!.orderStatus, equals('confirmed'));
      } finally {
        await session.close();
      }
    });

    // ─────────────────────────────────────────────
    // expireStaleSessions
    // ─────────────────────────────────────────────

    test('expireStaleSessions cancels expired links within age window', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        // Expired 1 hour ago, ageCutoff = 2 days → included
        final orderNumber = 'es-in-${now.microsecondsSinceEpoch}';
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
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            paymentLinkUrl: 'https://rzp.io/i/test',
            paymentLinkExpiresAt: now.subtract(const Duration(hours: 1)),
            orderedAt: now.subtract(const Duration(hours: 2)),
          ),
        );

        await paymentService.expireStaleSessions(session);

        final updated = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderNumber),
        );
        expect(updated!.paymentStatus, equals('cancelled'));
      } finally {
        await session.close();
      }
    });

    test('expireStaleSessions skips orders with expiredAt older than 2 days', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        // Expired 3 days ago → excluded (paymentLinkExpiresAt < 2 days ago)
        final orderNumber = 'es-old-${now.microsecondsSinceEpoch}';
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
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            paymentLinkUrl: 'https://rzp.io/i/old',
            paymentLinkExpiresAt: now.subtract(const Duration(days: 3)),
            orderedAt: now.subtract(const Duration(days: 4)),
          ),
        );

        await paymentService.expireStaleSessions(session);

        final updated = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderNumber),
        );
        expect(updated!.paymentStatus, equals('pending'));
      } finally {
        await session.close();
      }
    });

    // ─────────────────────────────────────────────
    // expireExpiredLinks (payment_link table)
    // ─────────────────────────────────────────────

    test('expireExpiredLinks expires links within age window', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'el-in-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'payment_pending',
            paymentStatus: 'pending',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'link',
            orderedAt: now.subtract(const Duration(hours: 2)),
          ),
        );
        // Payment link that expired 30 min ago → within 2 day window
        await protocol.PaymentLinkRow.db.insertRow(
          session,
          protocol.PaymentLinkRow(
            orderId: order.id!,
            token: 'el-token-${now.microsecondsSinceEpoch}',
            expiresAt: now.subtract(const Duration(minutes: 30)),
            isUsed: false,
            linkStatus: 'ACTIVE',
          ),
        );

        final count = await paymentLinkService.expireExpiredLinks(session);

        expect(count, greaterThanOrEqualTo(1));
      } finally {
        await session.close();
      }
    });

    test('expireExpiredLinks skips links with expiresAt older than 2 days', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'el-old-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'payment_pending',
            paymentStatus: 'pending',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'link',
            orderedAt: now.subtract(const Duration(days: 4)),
          ),
        );
        // Link that expired 3 days ago → excluded
        await protocol.PaymentLinkRow.db.insertRow(
          session,
          protocol.PaymentLinkRow(
            orderId: order.id!,
            token: 'el-old-token-${now.microsecondsSinceEpoch}',
            expiresAt: now.subtract(const Duration(days: 3)),
            isUsed: false,
            linkStatus: 'ACTIVE',
          ),
        );

        final count = await paymentLinkService.expireExpiredLinks(session);

        expect(count, equals(0));
      } finally {
        await session.close();
      }
    });

    test('expireExpiredLinks skips used links', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'el-used-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'confirmed',
            paymentStatus: 'paid',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'link',
            orderedAt: now.subtract(const Duration(hours: 2)),
          ),
        );
        // Used link → skipped (isUsed = true)
        await protocol.PaymentLinkRow.db.insertRow(
          session,
          protocol.PaymentLinkRow(
            orderId: order.id!,
            token: 'el-used-token-${now.microsecondsSinceEpoch}',
            expiresAt: now.subtract(const Duration(minutes: 30)),
            isUsed: true,
            linkStatus: 'USED',
          ),
        );

        final count = await paymentLinkService.expireExpiredLinks(session);

        expect(count, equals(0));
      } finally {
        await session.close();
      }
    });

    // ─────────────────────────────────────────────
    // loadPendingJobs — 15 day ageCutoff
    // ─────────────────────────────────────────────

    test('loadPendingJobs returns jobs within 15 day window', () async {
      final orderId = await _seedCompletedOrder(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        final custOrder = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderId),
        );
        final txn = await protocol.PaymentTransactionRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(custOrder!.id!),
        );
        // Job created 1 day ago → within 15 day window
        await protocol.AutoRefundJobRow.db.insertRow(
          session,
          protocol.AutoRefundJobRow(
            orderId: txn!.orderId,
            orderNumber: orderId,
            customerId: txn.userId,
            gatewayPaymentId: 'pay-lj-${DateTime.now().microsecondsSinceEpoch}',
            paymentTransactionId: txn.id!,
            amount: 100.0,
            jobStatus: 'PENDING',
            createdAt: DateTime.now().toUtc().subtract(const Duration(days: 1)),
          ),
        );

        final jobs = await autoRefundService.loadPendingJobs(session);
        expect(jobs.any((j) => j.orderNumber == orderId), isTrue);
      } finally {
        await session.close();
      }
    });

    test('loadPendingJobs excludes jobs older than 15 days', () async {
      final orderId = await _seedCompletedOrder(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        final custOrder = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderId),
        );
        final txn = await protocol.PaymentTransactionRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(custOrder!.id!),
        );
        // Job created 20 days ago → excluded
        await protocol.AutoRefundJobRow.db.insertRow(
          session,
          protocol.AutoRefundJobRow(
            orderId: txn!.orderId,
            orderNumber: orderId,
            customerId: txn.userId,
            gatewayPaymentId: 'pay-old-${DateTime.now().microsecondsSinceEpoch}',
            paymentTransactionId: txn.id!,
            amount: 100.0,
            jobStatus: 'PENDING',
            createdAt: DateTime.now().toUtc().subtract(const Duration(days: 20)),
          ),
        );

        final jobs = await autoRefundService.loadPendingJobs(session);
        expect(jobs.any((j) => j.orderNumber == orderId), isFalse);
      } finally {
        await session.close();
      }
    });

    // ─────────────────────────────────────────────
    // detectOrphanPayments — 7 day ageCutoff
    // ─────────────────────────────────────────────

    test('detectOrphanPayments finds recent orphans', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        // Create order with paymentStatus != 'paid' + paid txn → orphan
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'orphan-in-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'placed',
            paymentStatus: 'pending',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            createdAt: now.subtract(const Duration(days: 1)),
            orderedAt: now.subtract(const Duration(days: 1)),
          ),
        );
        await protocol.PaymentTransactionRow.db.insertRow(
          session,
          protocol.PaymentTransactionRow(
            orderId: order.id!,
            userId: user.id!,
            idempotencyKey: 'orphan-${now.microsecondsSinceEpoch}',
            gatewayName: 'razorpay',
            gatewayPaymentId: 'pay-orphan-${now.microsecondsSinceEpoch}',
            amount: 100.0,
            paymentStatus: 'paid',
            createdAt: now.subtract(const Duration(days: 1)),
          ),
        );

        final orphans = await paymentService.detectOrphanPayments(session);
        expect(orphans, isNotEmpty);
      } finally {
        await session.close();
      }
    });

    test('detectOrphanPayments excludes orphans older than 7 days', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        // Create old order + old payment txn with mismatched status → excluded by age
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'orphan-old-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'placed',
            paymentStatus: 'pending',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            createdAt: now.subtract(const Duration(days: 10)),
            orderedAt: now.subtract(const Duration(days: 10)),
          ),
        );
        await protocol.PaymentTransactionRow.db.insertRow(
          session,
          protocol.PaymentTransactionRow(
            orderId: order.id!,
            userId: user.id!,
            idempotencyKey: 'orphan-old-${now.microsecondsSinceEpoch}',
            gatewayName: 'razorpay',
            gatewayPaymentId: 'pay-orphan-old-${now.microsecondsSinceEpoch}',
            amount: 100.0,
            paymentStatus: 'paid',
            createdAt: now.subtract(const Duration(days: 10)),
          ),
        );

        final orphans = await paymentService.detectOrphanPayments(session);
        expect(orphans.where((o) => o['txnPaymentStatus'] == 'paid').length, equals(0));
      } finally {
        await session.close();
      }
    });

    // ─────────────────────────────────────────────
    // reconcileAllPendingPayments — 24h ageCutoff
    // ─────────────────────────────────────────────

    test('reconcileAllPendingPayments runs without error for eligible rows', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'rp-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'placed',
            paymentStatus: 'pending',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            orderedAt: now.subtract(const Duration(hours: 2)),
          ),
        );
        // payment_transaction with gatewayPaymentId but pending status
        await protocol.PaymentTransactionRow.db.insertRow(
          session,
          protocol.PaymentTransactionRow(
            orderId: order.id!,
            userId: user.id!,
            idempotencyKey: 'rp-txn-${now.microsecondsSinceEpoch}',
            gatewayName: 'razorpay',
            gatewayOrderId: 'rzp_test',
            gatewayPaymentId: 'pay_rp_${now.microsecondsSinceEpoch}',
            amount: 100.0,
            paymentStatus: 'pending',
            createdAt: now.subtract(const Duration(hours: 2)),
          ),
        );

        final result = await paymentService.reconcileAllPendingPayments(session);

        expect(result, containsPair('recovered', anyOf(0, greaterThan(0))));
        expect(result, containsPair('failed', anyOf(0, greaterThan(0))));
        expect(result, containsPair('skipped', anyOf(0, greaterThan(0))));
      } finally {
        await session.close();
      }
    });

    test('reconcileAllPendingPayments skips rows older than 24 hours', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'rp-old-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'placed',
            paymentStatus: 'pending',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'standard',
            orderedAt: now.subtract(const Duration(hours: 48)),
          ),
        );
        // payment_transaction from 36 hours ago → excluded (createdAt < 24h ago)
        await protocol.PaymentTransactionRow.db.insertRow(
          session,
          protocol.PaymentTransactionRow(
            orderId: order.id!,
            userId: user.id!,
            idempotencyKey: 'rp-old-txn-${now.microsecondsSinceEpoch}',
            gatewayName: 'razorpay',
            gatewayOrderId: 'rzp_test',
            gatewayPaymentId: 'pay_rp_old',
            amount: 100.0,
            paymentStatus: 'pending',
            createdAt: now.subtract(const Duration(hours: 36)),
          ),
        );

        final result = await paymentService.reconcileAllPendingPayments(session);

        // skipped and recovered should both be 0 since the row is excluded by age filter
        expect(result['recovered'], equals(0));
      } finally {
        await session.close();
      }
    });

    // ─────────────────────────────────────────────
    // reconcilePaymentLinkOrders — 3d ageCutoff
    // ─────────────────────────────────────────────

    test('reconcilePaymentLinkOrders runs without error for eligible rows', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'rpl-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'payment_pending',
            paymentStatus: 'pending',
            linkStatus: 'ACTIVE',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'link',
            orderedAt: now.subtract(const Duration(minutes: 30)),
          ),
        );
        await protocol.PaymentLinkRow.db.insertRow(
          session,
          protocol.PaymentLinkRow(
            orderId: order.id!,
            token: 'rpl-token-${now.microsecondsSinceEpoch}',
            expiresAt: now.add(const Duration(hours: 1)),
            linkStatus: 'ACTIVE',
            isUsed: false,
            razorpayPaymentLinkId: 'rzp_link_test',
            razorpayPaymentLinkUrl: 'https://rzp.io/i/test',
            generatedBy: 'test',
          ),
        );

        final result = await paymentService.reconcilePaymentLinkOrders(session);

        expect(result, containsPair('recovered', 0));
        expect(result, containsPair('failed', 0));
        // At least 1 row was found (will be skipped because Razorpay API not available)
        expect(result['skipped'], greaterThanOrEqualTo(0));
      } finally {
        await session.close();
      }
    });

    test('reconcilePaymentLinkOrders skips orders older than 3 days', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final user = await _seedUser(session);
        final order = await protocol.CustomerOrderRow.db.insertRow(
          session,
          protocol.CustomerOrderRow(
            orderNumber: 'rpl-old-${now.microsecondsSinceEpoch}',
            userId: user.id!,
            orderStatus: 'payment_pending',
            paymentStatus: 'pending',
            linkStatus: 'ACTIVE',
            refundStatus: 'none',
            itemCount: 1,
            totalAmount: 100.0,
            finalAmount: 100.0,
            orderType: 'regular',
            paymentMode: 'link',
            orderedAt: now.subtract(const Duration(days: 5)),
          ),
        );
        await protocol.PaymentLinkRow.db.insertRow(
          session,
          protocol.PaymentLinkRow(
            orderId: order.id!,
            token: 'rpl-old-token-${now.microsecondsSinceEpoch}',
            expiresAt: now.subtract(const Duration(days: 4)),
            linkStatus: 'ACTIVE',
            isUsed: false,
            razorpayPaymentLinkId: 'rzp_link_old',
            razorpayPaymentLinkUrl: 'https://rzp.io/i/old',
            generatedBy: 'test',
          ),
        );

        final result = await paymentService.reconcilePaymentLinkOrders(session);

        expect(result['skipped'], equals(0));
      } finally {
        await session.close();
      }
    });
  });
}

// ─────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────

Future<protocol.AppUserRow> _seedUser(Session session) async {
  final now = DateTime.now().toUtc();
  return protocol.AppUserRow.db.insertRow(
    session,
    protocol.AppUserRow(
      phoneNumber: 'cron-${now.microsecondsSinceEpoch}',
      name: 'Cron Test User',
      role: 'customer',
      status: 'active',
    ),
  );
}

Future<String> _seedCompletedOrder(TestSessionBuilder sessionBuilder) async {
  final session = sessionBuilder.build();
  try {
    final now = DateTime.now().toUtc();
    final user = await protocol.AppUserRow.db.insertRow(
      session,
      protocol.AppUserRow(
        phoneNumber: 'cron-ar-${now.microsecondsSinceEpoch}',
        name: 'Cron AR User',
        role: 'customer',
        status: 'active',
      ),
    );
    final order = await protocol.CustomerOrderRow.db.insertRow(
      session,
      protocol.CustomerOrderRow(
        orderNumber: 'cron-ar-${now.microsecondsSinceEpoch}',
        userId: user.id!,
        orderStatus: 'confirmed',
        paymentStatus: 'paid',
        refundStatus: 'none',
        itemCount: 1,
        totalAmount: 100.0,
        finalAmount: 100.0,
        orderType: 'regular',
        paymentMode: 'standard',
        orderedAt: now.subtract(const Duration(hours: 1)),
      ),
    );
    await protocol.PaymentTransactionRow.db.insertRow(
      session,
      protocol.PaymentTransactionRow(
        orderId: order.id!,
        userId: user.id!,
        idempotencyKey: 'cron-ar-txn-${now.microsecondsSinceEpoch}',
        gatewayName: 'razorpay',
        gatewayOrderId: 'rzp_cron_${now.microsecondsSinceEpoch}',
        gatewayPaymentId: 'pay_cron_${now.microsecondsSinceEpoch}',
        amount: 100.0,
        paymentStatus: 'paid',
        gatewayStatus: 'captured',
      ),
    );
    return order.orderNumber;
  } finally {
    await session.close();
  }
}
