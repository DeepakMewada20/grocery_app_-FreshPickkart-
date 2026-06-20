import 'dart:async';
import 'package:serverpod/serverpod.dart';
import '../admin/cascade_deactivation_service.dart';

class BannerCleanupCronJob {
  BannerCleanupCronJob(this._pod);

  static const int _cleanupLock = 4200402;

  final Serverpod _pod;
  final CascadeDeactivationService _cascade = CascadeDeactivationService();
  Timer? _cleanupTimer;
  bool _running = false;

  void start() {
    _cleanupTimer ??= Timer.periodic(
      const Duration(hours: 12),
      (_) => unawaited(_runCleanup()),
    );
  }

  void stop() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  Future<void> _runCleanup() async {
    if (_running) return;
    _running = true;
    try {
      await _runLocked(_cleanupLock, (session) async {
        final count = await _cascade.deactivateOrphanBanners(session);
        if (count > 0) {
          session.log(
            'BannerCleanup: Deactivated $count orphan banner(s)',
            level: LogLevel.info,
          );
        }
      });
    } finally {
      _running = false;
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
        'Banner cleanup cron job failed: $error',
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
