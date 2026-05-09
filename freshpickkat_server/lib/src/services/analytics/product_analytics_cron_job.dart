import 'dart:async';

import 'package:serverpod/serverpod.dart';

import 'redis_analytics_service.dart';
import 'trending_score_service.dart';

class ProductAnalyticsCronJob {
  ProductAnalyticsCronJob(this._pod);

  static const int _redisSyncLock = 4200101;
  static const int _sevenDayAnalyticsLock = 4200102;
  static const int _trendingScoreLock = 4200103;

  final Serverpod _pod;
  final RedisAnalyticsService _redisAnalytics = RedisAnalyticsService.instance;
  final TrendingScoreService _trending = TrendingScoreService();

  Timer? _syncTimer;
  Timer? _sevenDayTimer;
  Timer? _trendingTimer;
  bool _syncRunning = false;
  bool _sevenDayRunning = false;
  bool _trendingRunning = false;

  void start() {
    final redisConfig = _pod.config.redis;
    if (redisConfig == null || !redisConfig.enabled) {
      return;
    }

    _syncTimer ??= Timer.periodic(
      const Duration(minutes: 5),
      (_) => unawaited(runRedisToPostgresSync()),
    );
    _sevenDayTimer ??= Timer.periodic(
      const Duration(hours: 1),
      (_) => unawaited(runSevenDayAnalyticsUpdate()),
    );
    _trendingTimer ??= Timer.periodic(
      const Duration(hours: 1),
      (_) => unawaited(runTrendingScoreCalculation()),
    );

    unawaited(runRedisToPostgresSync());
    unawaited(runSevenDayAnalyticsUpdate());
    unawaited(runTrendingScoreCalculation());
  }

  void stop() {
    _syncTimer?.cancel();
    _sevenDayTimer?.cancel();
    _trendingTimer?.cancel();
    _syncTimer = null;
    _sevenDayTimer = null;
    _trendingTimer = null;
  }

  Future<void> runRedisToPostgresSync() async {
    if (_syncRunning) return;
    _syncRunning = true;
    try {
      await _runLocked(_redisSyncLock, (session) async {
        await _redisAnalytics.processUnprocessedPaidOrders(session);
        await _redisAnalytics.syncCountersToPostgres(session);
      });
    } finally {
      _syncRunning = false;
    }
  }

  Future<void> runSevenDayAnalyticsUpdate() async {
    if (_sevenDayRunning) return;
    _sevenDayRunning = true;
    try {
      await _runLocked(_sevenDayAnalyticsLock, (session) async {
        await _trending.updateLast7DaysSold(session);
        await _redisAnalytics.updateLast7DaysViews(session);
      });
    } finally {
      _sevenDayRunning = false;
    }
  }

  Future<void> runTrendingScoreCalculation() async {
    if (_trendingRunning) return;
    _trendingRunning = true;
    try {
      await _runLocked(_trendingScoreLock, (session) async {
        await _trending.calculateTrendingScores(session);
      });
    } finally {
      _trendingRunning = false;
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
        'Product analytics cron job failed: $error',
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
