import 'package:test/test.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/postgres/postgres_auto_refund_service.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_payment_service.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Auto-refund job', (sessionBuilder, endpoints) {
    late PostgresAutoRefundService autoRefundService;
    late PostgresPaymentService paymentService;

    setUp(() {
      autoRefundService = PostgresAutoRefundService();
      paymentService = PostgresPaymentService();
    });

    test('duplicate payment creates auto-refund job', () async {
      final orderId = await _seedCompletedOrder(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        await paymentService.completePaymentVerification(
          session,
          orderNumber: orderId,
          razorpayOrderId: 'rzp_dup1_${DateTime.now().microsecondsSinceEpoch}',
          razorpayPaymentId:
              'pay_dup1_${DateTime.now().microsecondsSinceEpoch}',
        );

        final jobs = await protocol.AutoRefundJobRow.db.find(
          session,
          where: (t) => t.orderNumber.equals(orderId),
        );
        expect(jobs, isNotEmpty);
      } finally {
        await session.close();
      }
    });

    test('identical gatewayPaymentId does not create duplicate job', () async {
      final orderId = await _seedCompletedOrder(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        final gwPaymentId =
            'pay_dedup_${DateTime.now().microsecondsSinceEpoch}';
        await paymentService.completePaymentVerification(
          session,
          orderNumber: orderId,
          razorpayOrderId: 'rzp_dedup_${DateTime.now().microsecondsSinceEpoch}',
          razorpayPaymentId: gwPaymentId,
        );
        await paymentService.completePaymentVerification(
          session,
          orderNumber: orderId,
          razorpayOrderId:
              'rzp_dedup2_${DateTime.now().microsecondsSinceEpoch}',
          razorpayPaymentId: gwPaymentId,
        );

        final jobs = await protocol.AutoRefundJobRow.db.find(
          session,
          where: (t) => t.orderNumber.equals(orderId),
        );
        expect(jobs.length, lessThanOrEqualTo(1));
      } finally {
        await session.close();
      }
    });

    test('createJob with dedup (ON CONFLICT DO NOTHING)', () async {
      final orderId = await _seedCompletedOrder(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        final custOrder = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderId),
        );
        final paymentTxns = await protocol.PaymentTransactionRow.db.find(
          session,
          where: (t) => t.orderId.equals(custOrder!.id!),
        );
        final paymentTxn = paymentTxns.first;

        final gwPaymentId =
            'pay_dedup_job_${DateTime.now().microsecondsSinceEpoch}';
        final jobRow = protocol.AutoRefundJobRow(
          orderId: paymentTxn.orderId,
          orderNumber: orderId,
          customerId: paymentTxn.userId,
          gatewayPaymentId: gwPaymentId,
          paymentTransactionId: paymentTxn.id!,
          amount: 100.0,
          jobStatus: 'PENDING',
          attemptCount: 0,
        );

        await autoRefundService.createJob(session, job: jobRow);
        await autoRefundService.createJob(session, job: jobRow);

        final jobs = await protocol.AutoRefundJobRow.db.find(
          session,
          where: (t) => t.orderNumber.equals(orderId),
        );
        expect(
          jobs.where((j) => j.gatewayPaymentId == gwPaymentId).length,
          lessThanOrEqualTo(1),
        );
      } finally {
        await session.close();
      }
    });

    test('updateJobStatus updates job status', () async {
      final orderId = await _seedCompletedOrder(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        final custOrder = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderId),
        );
        final paymentTxns = await protocol.PaymentTransactionRow.db.find(
          session,
          where: (t) => t.orderId.equals(custOrder!.id!),
        );
        final paymentTxn = paymentTxns.first;

        final job = await protocol.AutoRefundJobRow.db.insertRow(
          session,
          protocol.AutoRefundJobRow(
            orderId: paymentTxn.orderId,
            orderNumber: orderId,
            customerId: paymentTxn.userId,
            gatewayPaymentId:
                'pay_update_${DateTime.now().microsecondsSinceEpoch}',
            paymentTransactionId: paymentTxn.id!,
            amount: 100.0,
            jobStatus: 'PENDING',
            attemptCount: 0,
          ),
        );

        await autoRefundService.updateJobStatus(
          session,
          job,
          status: 'COMPLETED',
          error: null,
          processedAt: DateTime.now().toUtc(),
        );

        final updated = await protocol.AutoRefundJobRow.db.findById(
          session,
          job.id!,
        );
        expect(updated, isNotNull);
        expect(updated!.jobStatus, equals('COMPLETED'));
      } finally {
        await session.close();
      }
    });

    test('loadPendingJobs returns pending jobs', () async {
      final orderId = await _seedCompletedOrder(sessionBuilder);
      final session = sessionBuilder.build();
      try {
        final custOrder = await protocol.CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderId),
        );
        final paymentTxns = await protocol.PaymentTransactionRow.db.find(
          session,
          where: (t) => t.orderId.equals(custOrder!.id!),
        );
        final paymentTxn = paymentTxns.first;

        await protocol.AutoRefundJobRow.db.insertRow(
          session,
          protocol.AutoRefundJobRow(
            orderId: paymentTxn.orderId,
            orderNumber: orderId,
            customerId: paymentTxn.userId,
            gatewayPaymentId:
                'pay_cron_${DateTime.now().microsecondsSinceEpoch}',
            paymentTransactionId: paymentTxn.id!,
            amount: 100.0,
            jobStatus: 'PENDING',
          ),
        );

        final pendingJobs = await autoRefundService.loadPendingJobs(session);
        expect(pendingJobs, isNotEmpty);
      } finally {
        await session.close();
      }
    });
  });
}

Future<String> _seedCompletedOrder(
  TestSessionBuilder sessionBuilder,
) async {
  final session = sessionBuilder.build();
  try {
    final now = DateTime.now().toUtc();
    final user = await protocol.AppUserRow.db.insertRow(
      session,
      protocol.AppUserRow(
        phoneNumber: '9999999997',
        name: 'AR Test User',
        role: 'customer',
        status: 'active',
      ),
    );

    final order = await protocol.CustomerOrderRow.db.insertRow(
      session,
      protocol.CustomerOrderRow(
        orderNumber: 'ar-${now.microsecondsSinceEpoch}',
        userId: user.id!,
        orderStatus: 'confirmed',
        paymentStatus: 'paid',
        refundStatus: 'none',
        itemCount: 1,
        totalAmount: 100.0,
        discountAmount: 0.0,
        deliveryFee: 0.0,
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
        idempotencyKey: 'ar-txn-${now.microsecondsSinceEpoch}',
        gatewayName: 'razorpay',
        gatewayOrderId: 'rzp_ar_${now.microsecondsSinceEpoch}',
        gatewayPaymentId: 'pay_ar_${now.microsecondsSinceEpoch}',
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
