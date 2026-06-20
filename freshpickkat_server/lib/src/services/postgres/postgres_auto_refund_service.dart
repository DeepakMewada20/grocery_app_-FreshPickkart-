import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../payments/payment_gateway_service.dart';

class PostgresAutoRefundService {
  final PaymentGatewayService _gateway;

  PostgresAutoRefundService({PaymentGatewayService? gateway})
    : _gateway = gateway ?? PaymentGatewayService();

  /// Create an auto-refund job when a duplicate payment is detected.
  /// Returns the created job, or null if a job already exists for this payment.
  Future<Map<String, dynamic>?> createJob(
    Session session, {
    required AutoRefundJobRow job,
  }) async {
    // Dedup: check if a job already exists for this gatewayPaymentId
    final existing = await getJobByGatewayPaymentId(
      session,
      job.gatewayPaymentId,
    );
    if (existing != null) {
      return existing;
    }

    // Validate amount > 0
    if (job.amount <= 0) {
      return null;
    }

    // Find the order to validate amount against
    final orderRow = await CustomerOrderRow.db.findById(session, job.orderId);
    if (orderRow == null) {
      return null;
    }

    // Suspicious amount validation: flag if > 1.5x order amount
    final orderAmount = orderRow.finalAmount;
    String jobStatus = 'PENDING';
    if (job.amount > orderAmount * 1.5) {
      jobStatus = 'MANUAL_REVIEW';
    }

    // Capture validation: check with Razorpay
    if (jobStatus == 'PENDING') {
      try {
        final paymentStatusResult = await _gateway.fetchPaymentStatus(
          job.gatewayPaymentId,
        );
        final statusCode = paymentStatusResult['statusCode'] as int? ?? 0;
        final data = paymentStatusResult['data'] as Map<String, dynamic>?;
        final rzpStatus = data?['status'] as String? ?? '';
        if (rzpStatus != 'captured') {
          jobStatus = 'MANUAL_REVIEW';
        }
        if (statusCode != 200) {
          session.log(
            'AutoRefund: payment status check failed for ${job.gatewayPaymentId}: status=$statusCode',
            level: LogLevel.warning,
          );
          jobStatus = 'MANUAL_REVIEW';
        }
      } catch (e) {
        session.log(
          'AutoRefund: error checking payment status for ${job.gatewayPaymentId}: $e',
          level: LogLevel.warning,
        );
        jobStatus = 'MANUAL_REVIEW';
      }
    }

    final now = DateTime.now().toUtc();
    final inserted = await AutoRefundJobRow.db.insertRow(
      session,
      job.copyWith(
        jobStatus: jobStatus,
        createdAt: now,
        updatedAt: now,
      ),
    );

    session.log(
      'Auto refund job created: gatewayPaymentId=${job.gatewayPaymentId}, '
      'amount=${job.amount}, status=$jobStatus',
      level: LogLevel.info,
    );

    return _jobToMap(inserted);
  }

  /// Load pending jobs ready for processing.
  Future<List<AutoRefundJobRow>> loadPendingJobs(
    Session session, {
    int limit = 25,
  }) async {
    final now = DateTime.now().toUtc();
    final ageCutoff = now.subtract(const Duration(days: 15));
    return AutoRefundJobRow.db.find(
      session,
      where: (t) =>
          t.jobStatus.equals('PENDING') &
          (t.nextRetryAt.equals(null) | (t.nextRetryAt <= now)) &
          (t.createdAt >= ageCutoff),
      orderBy: (t) => t.createdAt,
      limit: limit,
    );
  }

  /// Find an existing job by gateway payment ID (dedup check).
  Future<Map<String, dynamic>?> getJobByGatewayPaymentId(
    Session session,
    String gatewayPaymentId,
  ) async {
    final row = await AutoRefundJobRow.db.findFirstRow(
      session,
      where: (t) => t.gatewayPaymentId.equals(gatewayPaymentId),
    );
    if (row == null) return null;
    return _jobToMap(row);
  }

  /// List auto-refund jobs for a given order.
  Future<List<Map<String, dynamic>>> listJobsByOrder(
    Session session,
    String orderNumber,
  ) async {
    final rows = await AutoRefundJobRow.db.find(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
      orderBy: (t) => t.createdAt,
    );
    return rows.map(_jobToMap).toList();
  }

  /// Update job status.
  Future<void> updateJobStatus(
    Session session,
    AutoRefundJobRow job, {
    required String status,
    String? error,
    DateTime? processedAt,
  }) async {
    await AutoRefundJobRow.db.updateRow(
      session,
      job.copyWith(
        jobStatus: status,
        lastError: error ?? job.lastError,
        processedAt: processedAt ?? job.processedAt,
        attemptCount: job.attemptCount + 1,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  Map<String, dynamic> _jobToMap(AutoRefundJobRow row) {
    return {
      'id': row.id?.toJson(),
      'orderId': row.orderId.toJson(),
      'orderNumber': row.orderNumber,
      'customerId': row.customerId.toJson(),
      'gatewayPaymentId': row.gatewayPaymentId,
      'paymentTransactionId': row.paymentTransactionId.toJson(),
      'gatewayOrderId': row.gatewayOrderId,
      'amount': row.amount,
      'currency': row.currency,
      'jobStatus': row.jobStatus,
      'attemptCount': row.attemptCount,
      'nextRetryAt': row.nextRetryAt?.toIso8601String(),
      'lastError': row.lastError,
      'createdAt': row.createdAt.toIso8601String(),
      'updatedAt': row.updatedAt.toIso8601String(),
      'processedAt': row.processedAt?.toIso8601String(),
    };
  }
}
