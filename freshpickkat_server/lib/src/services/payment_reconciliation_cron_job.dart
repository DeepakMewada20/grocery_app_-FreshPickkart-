import 'dart:async';

import 'package:serverpod/serverpod.dart';

import 'postgres/postgres_payment_service.dart';

class PaymentReconciliationCronJob {
  PaymentReconciliationCronJob(this._pod);

  static const int _reconciliationLock = 4200301;
  static const int _autoCancelLock = 4200302;

  final Serverpod _pod;
  final PostgresPaymentService _payments = PostgresPaymentService();

  Timer? _reconciliationTimer;
  Timer? _autoCancelTimer;
  bool _reconciliationRunning = false;
  bool _autoCancelRunning = false;

  void start() {
    _reconciliationTimer ??= Timer.periodic(
      const Duration(minutes: 2),
      (_) => unawaited(runPaymentReconciliation()),
    );
    _autoCancelTimer ??= Timer.periodic(
      const Duration(minutes: 1),
      (_) => unawaited(runAutoCancellation()),
    );

    unawaited(runPaymentReconciliation());
    unawaited(runAutoCancellation());
  }

  void stop() {
    _reconciliationTimer?.cancel();
    _autoCancelTimer?.cancel();
    _reconciliationTimer = null;
    _autoCancelTimer = null;
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
