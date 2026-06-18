import 'dart:async';

import 'package:serverpod/serverpod.dart';

import 'postgres/postgres_auto_refund_service.dart';
import 'postgres/postgres_audit_log_service.dart';
import 'postgres/postgres_payment_link_service.dart';
import 'postgres/postgres_payment_service.dart';
import 'postgres/postgres_refund_service.dart';

class PaymentReconciliationCronJob {
  PaymentReconciliationCronJob(this._pod);

  static const int _reconciliationLock = 4200301;
  static const int _autoCancelLock = 4200302;
  static const int _paymentLinkExpiryLock = 4200303;
  static const int _autoRefundLock = 4200304;
  static const int _sessionExpiryLock = 4200305;
  static const int _orphanDetectionLock = 4200306;

  final Serverpod _pod;
  final PostgresPaymentService _payments = PostgresPaymentService();
  final PostgresPaymentLinkService _paymentLinks = PostgresPaymentLinkService();
  final PostgresAutoRefundService _autoRefund = PostgresAutoRefundService();
  final PostgresRefundService _refunds = PostgresRefundService();
  final PostgresAuditLogService _auditLog = PostgresAuditLogService();

  Timer? _reconciliationTimer;
  Timer? _autoCancelTimer;
  Timer? _paymentLinkExpiryTimer;
  Timer? _autoRefundTimer;
  Timer? _sessionExpiryTimer;
  Timer? _orphanDetectionTimer;
  bool _reconciliationRunning = false;
  bool _autoCancelRunning = false;
  bool _paymentLinkExpiryRunning = false;
  bool _autoRefundRunning = false;
  bool _sessionExpiryRunning = false;
  bool _orphanDetectionRunning = false;

  void start() {
    _reconciliationTimer ??= Timer.periodic(
      const Duration(minutes: 2),
      (_) => unawaited(runPaymentReconciliation()),
    );
    _autoCancelTimer ??= Timer.periodic(
      const Duration(minutes: 1),
      (_) => unawaited(runAutoCancellation()),
    );
    _paymentLinkExpiryTimer ??= Timer.periodic(
      const Duration(minutes: 1),
      (_) => unawaited(runPaymentLinkExpiry()),
    );
    _autoRefundTimer ??= Timer.periodic(
      const Duration(seconds: 60),
      (_) => unawaited(runAutoRefundProcessing()),
    );
    _sessionExpiryTimer ??= Timer.periodic(
      const Duration(minutes: 1),
      (_) => unawaited(runSessionExpiry()),
    );
    _orphanDetectionTimer ??= Timer.periodic(
      const Duration(minutes: 5),
      (_) => unawaited(runOrphanDetection()),
    );

    unawaited(runPaymentReconciliation());
    unawaited(runAutoCancellation());
    unawaited(runPaymentLinkExpiry());
    unawaited(runAutoRefundProcessing());
    unawaited(runSessionExpiry());
    unawaited(runOrphanDetection());
  }

  void stop() {
    _reconciliationTimer?.cancel();
    _autoCancelTimer?.cancel();
    _paymentLinkExpiryTimer?.cancel();
    _autoRefundTimer?.cancel();
    _sessionExpiryTimer?.cancel();
    _orphanDetectionTimer?.cancel();
    _reconciliationTimer = null;
    _autoCancelTimer = null;
    _paymentLinkExpiryTimer = null;
    _autoRefundTimer = null;
    _sessionExpiryTimer = null;
    _orphanDetectionTimer = null;
  }

  Future<void> runPaymentReconciliation() async {
    if (_reconciliationRunning) return;
    _reconciliationRunning = true;
    try {
      await _runLocked(_reconciliationLock, (session) async {
        await _payments.reconcileAllPendingPayments(session, limit: 200);
      });
    } finally {
      _reconciliationRunning = false;
    }
  }

  Future<void> runAutoCancellation() async {
    if (_autoCancelRunning) return;
    _autoCancelRunning = true;
    try {
      await _runLocked(_autoCancelLock, (session) async {
        await _payments.autoCancelPendingPayments(
          session,
          timeout: const Duration(minutes: 10),
        );
      });
    } finally {
      _autoCancelRunning = false;
    }
  }

  Future<void> runPaymentLinkExpiry() async {
    if (_paymentLinkExpiryRunning) return;
    _paymentLinkExpiryRunning = true;
    try {
      await _runLocked(_paymentLinkExpiryLock, (session) async {
        await _paymentLinks.expireExpiredLinks(session);
      });
    } finally {
      _paymentLinkExpiryRunning = false;
    }
  }

  /// Process pending auto-refund jobs (up to 25 per cycle).
  /// Applies retry strategy: immediate → +5min → +15min → +60min → +6hr → MANUAL_REVIEW.
  Future<void> runAutoRefundProcessing() async {
    if (_autoRefundRunning) return;
    _autoRefundRunning = true;
    try {
      await _runLocked(_autoRefundLock, (session) async {
        final pendingJobs = await _autoRefund.loadPendingJobs(session, limit: 25);
        for (final job in pendingJobs) {
          try {
            await _processAutoRefundJob(session, job);
          } catch (e) {
            session.log(
              'Auto-refund job ${job.id} processing error: $e',
              level: LogLevel.error,
            );
          }
        }
      });
    } finally {
      _autoRefundRunning = false;
    }
  }

  Future<void> _processAutoRefundJob(Session session, AutoRefundJobRow job) async {
    // Acquire row-level lock on the job
    final locked = await session.db.unsafeQuery(
      'SELECT id FROM "auto_refund_job" WHERE "id" = @id FOR UPDATE',
      parameters: QueryParameters.named({'id': job.id!.toJson()}),
    );
    if (locked.isEmpty) return;

    // Re-check status under lock
    final currentJob = await AutoRefundJobRow.db.findById(session, job.id!);
    if (currentJob == null || currentJob.jobStatus != 'PENDING') return;

    // Transition to PROCESSING
    await _autoRefund.updateJobStatus(session, currentJob, status: 'PROCESSING');

    await _auditLog.write(
      session,
      action: 'AUTO_REFUND_PROCESSING',
      entityType: 'payment',
      entityId: currentJob.orderNumber,
      metadata: {'gatewayPaymentId': currentJob.gatewayPaymentId, 'amount': currentJob.amount.toString()},
    );

    try {
      // Execute refund using existing refund module
      final refundResult = await _refunds.refund(
        session,
        orderNumber: currentJob.orderNumber,
        amount: currentJob.amount,
        source: 'auto_refund',
        reason: 'Auto-refund for duplicate payment',
      );

      if (refundResult.refundId != 'error') {
        // COMPLETED
        final now = DateTime.now().toUtc();
        await AutoRefundJobRow.db.updateRow(
          session,
          currentJob.copyWith(
            jobStatus: 'COMPLETED',
            lastError: null,
            processedAt: now,
            updatedAt: now,
          ),
        );

        await _auditLog.write(
          session,
          action: 'AUTO_REFUND_COMPLETED',
          entityType: 'payment',
          entityId: currentJob.orderNumber,
          metadata: {
            'gatewayPaymentId': currentJob.gatewayPaymentId,
            'gatewayRefundId': refundResult.gatewayRefundId ?? '',
            'amount': currentJob.amount.toString(),
          },
        );

        session.log(
          'Auto-refund completed for job ${currentJob.id}: order=${currentJob.orderNumber}, '
          'refundId=${refundResult.gatewayRefundId}',
          level: LogLevel.info,
        );
      } else {
        // FAILED — apply retry strategy
        await _handleRefundFailure(session, currentJob, refundResult.failureReason ?? 'Refund failed');
      }
    } catch (e) {
      await _handleRefundFailure(session, currentJob, e.toString());
    }
  }

  Future<void> _handleRefundFailure(
    Session session,
    AutoRefundJobRow job,
    String error,
  ) async {
    final attempt = job.attemptCount + 1;
    final now = DateTime.now().toUtc();
    String nextStatus;
    DateTime? nextRetryAt;

    // Retry schedule: immediate → +5min → +15min → +60min → +6hr
    switch (attempt) {
      case 1:
        nextRetryAt = now;
        nextStatus = 'PENDING';
        break;
      case 2:
        nextRetryAt = now.add(const Duration(minutes: 5));
        nextStatus = 'PENDING';
        break;
      case 3:
        nextRetryAt = now.add(const Duration(minutes: 15));
        nextStatus = 'PENDING';
        break;
      case 4:
        nextRetryAt = now.add(const Duration(minutes: 60));
        nextStatus = 'PENDING';
        break;
      case 5:
        nextRetryAt = now.add(const Duration(hours: 6));
        nextStatus = 'PENDING';
        break;
      default:
        nextRetryAt = null;
        nextStatus = 'MANUAL_REVIEW';
    }

    await AutoRefundJobRow.db.updateRow(
      session,
      job.copyWith(
        jobStatus: nextStatus,
        attemptCount: attempt,
        lastError: error,
        nextRetryAt: nextRetryAt,
        updatedAt: now,
      ),
    );

    final auditAction = nextStatus == 'MANUAL_REVIEW'
        ? 'AUTO_REFUND_FAILED'
        : 'AUTO_REFUND_RETRY';
    await _auditLog.write(
      session,
      action: auditAction,
      entityType: 'payment',
      entityId: job.orderNumber,
      metadata: {
        'gatewayPaymentId': job.gatewayPaymentId,
        'attempt': attempt.toString(),
        'nextRetryAt': nextRetryAt?.toIso8601String() ?? 'never',
        'error': error,
      },
    );

    session.log(
      'Auto-refund failed (attempt $attempt) for job ${job.id}: $error',
      level: LogLevel.warning,
    );
  }

  /// Expire stale payment sessions where the payment link has expired.
  Future<void> runSessionExpiry() async {
    if (_sessionExpiryRunning) return;
    _sessionExpiryRunning = true;
    try {
      await _runLocked(_sessionExpiryLock, (session) async {
        final expired = await _payments.expireStaleSessions(session);
        if (expired > 0) {
          session.log('Expired $expired stale payment sessions', level: LogLevel.info);
        }
      });
    } finally {
      _sessionExpiryRunning = false;
    }
  }

  /// Detect orphan payments (captured payments with no valid order mapping).
  Future<void> runOrphanDetection() async {
    if (_orphanDetectionRunning) return;
    _orphanDetectionRunning = true;
    try {
      await _runLocked(_orphanDetectionLock, (session) async {
        final orphans = await _payments.detectOrphanPayments(session);
        if (orphans.isNotEmpty) {
          for (final orphan in orphans) {
            await _auditLog.write(
              session,
              action: 'ORPHAN_PAYMENT_DETECTED',
              entityType: 'payment',
              metadata: orphan,
            );
          }
          session.log('Detected ${orphans.length} orphan payment(s)', level: LogLevel.warning);
        }
      });
    } finally {
      _orphanDetectionRunning = false;
    }
  }

  Future<void> _runLocked(
    int lockKey,
    Future<void> Function(Session session) task,
  ) async {
    final session = await _pod.createSession(enableLogging: true);
    var lockAcquired = false;
    try {
      lockAcquired = await _tryAdvisoryLock(session, lockKey);
      if (!lockAcquired) return;
      await task(session);
    } catch (error, stackTrace) {
      session.log(
        'Payment reconciliation cron job failed: $error',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    } finally {
      if (lockAcquired) {
        await _releaseAdvisoryLock(session, lockKey);
      }
      await session.close();
    }
  }

  Future<bool> _tryAdvisoryLock(Session session, int lockKey) async {
    final result = await session.db.unsafeQuery(
      'SELECT pg_try_advisory_lock(@lockKey::bigint) AS locked',
      parameters: QueryParameters.named({'lockKey': lockKey}),
    );
    if (result.isEmpty) return false;
    return result.first.toColumnMap()['locked'] == true;
  }

  Future<void> _releaseAdvisoryLock(Session session, int lockKey) async {
    await session.db.unsafeQuery(
      'SELECT pg_advisory_unlock(@lockKey::bigint)',
      parameters: QueryParameters.named({'lockKey': lockKey}),
    );
  }
}
