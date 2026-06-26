import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../postgres/postgres_auto_refund_service.dart';
import '../../generated/protocol.dart' as protocol;
import '../postgres/postgres_audit_log_service.dart';
import '../postgres/postgres_payment_link_service.dart';
import '../postgres/postgres_payment_service.dart';
import '../postgres/postgres_refund_service.dart';
import '../postgres/postgres_referral_service.dart';

class PaymentReconciliationCronJob {
  PaymentReconciliationCronJob(this._pod);

  static const int _reconciliationLock = 4200301;
  static const int _autoCancelLock = 4200302;
  static const int _paymentLinkExpiryLock = 4200303;
  static const int _autoRefundLock = 4200304;
  static const int _sessionExpiryLock = 4200305;
  static const int _orphanDetectionLock = 4200306;
  static const int _paymentLinkReconciliationLock = 4200307;
  static const int _holdReleaseLock = 4200308;
  static const int _autoReversalLock = 4200309;
  static const int _referralExpiryLock = 4200310;

  final Serverpod _pod;
  final PostgresPaymentService _payments = PostgresPaymentService();
  final PostgresPaymentLinkService _paymentLinks = PostgresPaymentLinkService();
  final PostgresAutoRefundService _autoRefund = PostgresAutoRefundService();
  final PostgresRefundService _refunds = PostgresRefundService();
  final PostgresAuditLogService _auditLog = PostgresAuditLogService();
  final PostgresReferralService _referral = PostgresReferralService();

  Timer? _reconciliationTimer;
  Timer? _autoCancelTimer;
  Timer? _paymentLinkExpiryTimer;
  Timer? _autoRefundTimer;
  Timer? _sessionExpiryTimer;
  Timer? _orphanDetectionTimer;
  Timer? _paymentLinkReconciliationTimer;
  Timer? _holdReleaseTimer;
  Timer? _autoReversalTimer;
  Timer? _referralExpiryTimer;
  bool _reconciliationRunning = false;
  bool _autoCancelRunning = false;
  bool _paymentLinkExpiryRunning = false;
  bool _autoRefundRunning = false;
  bool _sessionExpiryRunning = false;
  bool _orphanDetectionRunning = false;
  bool _paymentLinkReconciliationRunning = false;
  bool _holdReleaseRunning = false;
  bool _autoReversalRunning = false;
  bool _referralExpiryRunning = false;
  final Set<String> _reportedOrphanIds = {};

  void start() {
    // Startup recovery: reset stale PROCESSING auto-refund jobs
    unawaited(
      _runLocked(_autoRefundLock, (session) async {
        await _recoverStaleProcessingJobs(session);
      }),
    );

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
      const Duration(hours: 6),
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
    _paymentLinkReconciliationTimer ??= Timer.periodic(
      const Duration(minutes: 5),
      (_) => unawaited(runPaymentLinkReconciliation()),
    );
    _holdReleaseTimer ??= Timer.periodic(
      const Duration(days: 1),
      (_) => unawaited(runHoldRelease()),
    );
    _autoReversalTimer ??= Timer.periodic(
      const Duration(days: 1),
      (_) => unawaited(runAutoReversal()),
    );
    _referralExpiryTimer ??= Timer.periodic(
      const Duration(days: 1),
      (_) => unawaited(runReferralExpiry()),
    );

    unawaited(runPaymentReconciliation());
    unawaited(runAutoCancellation());
    unawaited(runPaymentLinkExpiry());
    unawaited(runAutoRefundProcessing());
    unawaited(runSessionExpiry());
    unawaited(runOrphanDetection());
    unawaited(runPaymentLinkReconciliation());
    unawaited(runHoldRelease());
    unawaited(runAutoReversal());
    unawaited(runReferralExpiry());
  }

  void stop() {
    _reconciliationTimer?.cancel();
    _autoCancelTimer?.cancel();
    _paymentLinkExpiryTimer?.cancel();
    _autoRefundTimer?.cancel();
    _sessionExpiryTimer?.cancel();
    _orphanDetectionTimer?.cancel();
    _paymentLinkReconciliationTimer?.cancel();
    _holdReleaseTimer?.cancel();
    _autoReversalTimer?.cancel();
    _referralExpiryTimer?.cancel();
    _reconciliationTimer = null;
    _autoCancelTimer = null;
    _paymentLinkExpiryTimer = null;
    _autoRefundTimer = null;
    _sessionExpiryTimer = null;
    _orphanDetectionTimer = null;
    _paymentLinkReconciliationTimer = null;
    _holdReleaseTimer = null;
    _autoReversalTimer = null;
    _referralExpiryTimer = null;
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

  Future<void> runPaymentLinkReconciliation() async {
    if (_paymentLinkReconciliationRunning) return;
    _paymentLinkReconciliationRunning = true;
    try {
      await _runLocked(_paymentLinkReconciliationLock, (session) async {
        await _payments.reconcilePaymentLinkOrders(session, limit: 50);
      });
    } finally {
      _paymentLinkReconciliationRunning = false;
    }
  }

  /// Release held referral rewards whose [holdExpiresAt] has elapsed.
  Future<void> runHoldRelease() async {
    if (_holdReleaseRunning) return;
    _holdReleaseRunning = true;
    try {
      await _runLocked(_holdReleaseLock, (session) async {
        final released = await _referral.releaseHeldRewards(session);
        if (released > 0) {
          session.log(
            'Released $released held referral reward(s)',
            level: LogLevel.info,
          );
        }
      });
    } finally {
      _holdReleaseRunning = false;
    }
  }

  /// Auto-reverse referral rewards past the configured window.
  Future<void> runAutoReversal() async {
    if (_autoReversalRunning) return;
    _autoReversalRunning = true;
    try {
      await _runLocked(_autoReversalLock, (session) async {
        final reversed = await _referral.autoReverseExpiredRewards(session);
        if (reversed > 0) {
          session.log(
            'Auto-reversed $reversed expired referral reward(s)',
            level: LogLevel.info,
          );
        }
      });
    } finally {
      _autoReversalRunning = false;
    }
  }

  /// Expire old SIGNED_UP referrals past the configured window.
  Future<void> runReferralExpiry() async {
    if (_referralExpiryRunning) return;
    _referralExpiryRunning = true;
    try {
      await _runLocked(_referralExpiryLock, (session) async {
        final expired = await _referral.expireOldReferrals(session);
        if (expired > 0) {
          session.log(
            'Expired $expired old referral(s)',
            level: LogLevel.info,
          );
        }
      });
    } finally {
      _referralExpiryRunning = false;
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
        // Recover stale PROCESSING jobs before loading new ones
        await _recoverStaleProcessingJobs(session);

        final pendingJobs = await _autoRefund.loadPendingJobs(
          session,
          limit: 25,
        );
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

  Future<void> _processAutoRefundJob(
    Session session,
    protocol.AutoRefundJobRow job,
  ) async {
    final pj = await session.db.transaction<protocol.AutoRefundJobRow?>((
      transaction,
    ) async {
      final locked = await session.db.unsafeQuery(
        'SELECT id FROM "auto_refund_job" WHERE "id" = @id FOR UPDATE',
        parameters: QueryParameters.named({'id': job.id!.toJson()}),
        transaction: transaction,
      );
      if (locked.isEmpty) return null;

      final currentJob = await protocol.AutoRefundJobRow.db.findById(
        session,
        job.id!,
        transaction: transaction,
      );
      if (currentJob == null || currentJob.jobStatus != 'PENDING') return null;

      await protocol.AutoRefundJobRow.db.updateRow(
        session,
        currentJob.copyWith(
          jobStatus: 'PROCESSING',
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
      return currentJob.copyWith(jobStatus: 'PROCESSING');
    });

    if (pj == null) return;

    await _auditLog.write(
      session,
      action: 'AUTO_REFUND_PROCESSING',
      entityType: 'payment',
      entityId: pj.orderNumber,
      metadata: {
        'gatewayPaymentId': pj.gatewayPaymentId,
        'amount': pj.amount.toString(),
      },
    );

    try {
      final existingRefunds = await protocol.RefundRecordRow.db.find(
        session,
        where: (t) =>
            t.gatewayRefundId.equals(pj.gatewayPaymentId) &
            (t.refundStatus.equals('processed') |
                t.refundStatus.equals('pending')),
        limit: 1,
      );
      if (existingRefunds.isNotEmpty) {
        session.log(
          'Auto-refund already processed for ${pj.gatewayPaymentId}, marking COMPLETED',
          level: LogLevel.info,
        );
        await _autoRefund.updateJobStatus(
          session,
          pj,
          status: 'COMPLETED',
          error: null,
        );
        return;
      }

      final refundResult = await _refunds.refund(
        session,
        orderNumber: pj.orderNumber,
        amount: pj.amount,
        source: 'auto_refund',
        reason: 'Auto-refund for duplicate payment',
      );

      if (refundResult.refundId != 'error') {
        final now = DateTime.now().toUtc();
        await protocol.AutoRefundJobRow.db.updateRow(
          session,
          pj.copyWith(
            jobStatus: 'COMPLETED',
            lastError: null,
            processedAt: now,
            updatedAt: now,
          ),
        );
      } else {
        await _handleRefundFailure(
          session,
          pj,
          refundResult.failureReason ?? 'Refund failed',
        );
      }

      if (refundResult.refundId != 'error') {
        await _auditLog.write(
          session,
          action: 'AUTO_REFUND_COMPLETED',
          entityType: 'payment',
          entityId: pj.orderNumber,
          metadata: {
            'gatewayPaymentId': pj.gatewayPaymentId,
            'gatewayRefundId': refundResult.gatewayRefundId ?? '',
            'amount': pj.amount.toString(),
          },
        );

        session.log(
          'Auto-refund completed for job ${pj.id}: order=${pj.orderNumber}, '
          'refundId=${refundResult.gatewayRefundId}',
          level: LogLevel.info,
        );
      }
    } catch (e) {
      await _handleRefundFailure(session, pj, e.toString());
    }
  }

  Future<void> _handleRefundFailure(
    Session session,
    protocol.AutoRefundJobRow job,
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

    await protocol.AutoRefundJobRow.db.updateRow(
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

  /// Recover auto-refund jobs stuck in PROCESSING state (e.g., after a crash).
  Future<void> _recoverStaleProcessingJobs(Session session) async {
    final now = DateTime.now().toUtc();
    final staleThreshold = now.subtract(const Duration(minutes: 5));
    final result = await session.db.unsafeQuery(
      'WITH updated AS ('
      'UPDATE "auto_refund_job" SET "jobStatus" = \'PENDING\', '
      '"updatedAt" = @now WHERE "jobStatus" = \'PROCESSING\' '
      'AND "updatedAt" < @staleThreshold RETURNING 1'
      ') SELECT count(*)::int AS cnt FROM updated',
      parameters: QueryParameters.named({
        'now': now.toIso8601String(),
        'staleThreshold': staleThreshold.toIso8601String(),
      }),
    );
    final count = (result.first.toColumnMap()['cnt'] as int?) ?? 0;
    if (count > 0) {
      session.log(
        'Recovered $count stale PROCESSING auto-refund job(s)',
        level: LogLevel.warning,
      );
      await _auditLog.write(
        session,
        action: 'AUTO_REFUND_RECOVERED_AFTER_CRASH',
        entityType: 'payment',
        entityId: 'cron',
        metadata: {'count': count.toString()},
      );
    }
  }

  /// Expire stale payment sessions where the payment link has expired.
  Future<void> runSessionExpiry() async {
    if (_sessionExpiryRunning) return;
    _sessionExpiryRunning = true;
    try {
      await _runLocked(_sessionExpiryLock, (session) async {
        final expired = await _payments.expireStaleSessions(session);
        if (expired > 0) {
          session.log(
            'Expired $expired stale payment sessions',
            level: LogLevel.info,
          );
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
        var newCount = 0;
        for (final orphan in orphans) {
          final key = orphan['gatewayPaymentId'] ?? orphan['orderNumber'] ?? '';
          if (key.isEmpty || _reportedOrphanIds.add(key)) {
            await _auditLog.write(
              session,
              action: 'ORPHAN_PAYMENT_DETECTED',
              entityType: 'payment',
              metadata: orphan.map((k, v) => MapEntry(k, v?.toString() ?? '')),
            );
            newCount++;
          }
        }
        if (newCount > 0) {
          session.log(
            'Detected $newCount new orphan payment(s)',
            level: LogLevel.warning,
          );
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
