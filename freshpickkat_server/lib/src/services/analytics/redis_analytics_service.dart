import 'package:redis/redis.dart' as redis;
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../postgres/postgres_support.dart';

class RedisAnalyticsService {
  static const int rollingViewTtlSeconds = 604800;
  static const int dailyViewTtlSeconds = 691200;

  static final RedisAnalyticsService instance = RedisAnalyticsService._();

  RedisAnalyticsService._();

  final _redis = _AnalyticsRedisClient.instance;

  Future<bool> recordProductView(
    Session session,
    String productId,
  ) async {
    final parsedProductId = tryParseUuid(productId);
    if (parsedProductId == null) return false;
    final id = parsedProductId.toString();
    final day = _dayKey(DateTime.now().toUtc());

    try {
      await _redis.incr(session, 'product:views:$id');
      await _redis.incr(session, 'product:views:7d:$id');
      await _redis.expire(
        session,
        'product:views:7d:$id',
        rollingViewTtlSeconds,
      );
      await _redis.incr(session, 'product:views:day:$day:$id');
      await _redis.expire(
        session,
        'product:views:day:$day:$id',
        dailyViewTtlSeconds,
      );
      await _redis.sadd(session, 'product:analytics:view_ids', id);
      await _redis.sadd(session, 'product:analytics:day_view_ids:$day', id);
      await _redis.expire(
        session,
        'product:analytics:day_view_ids:$day',
        dailyViewTtlSeconds,
      );
      return true;
    } catch (error, stackTrace) {
      session.log(
        'Failed to record product view analytics: $error',
        level: LogLevel.warning,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> recordProductSoldQuantity(
    Session session,
    String productId,
    int quantity,
  ) async {
    final parsedProductId = tryParseUuid(productId);
    if (parsedProductId == null || quantity <= 0) return false;
    final id = parsedProductId.toString();
    try {
      await _redis.incrby(session, 'product:sold:$id', quantity);
      await _redis.sadd(session, 'product:analytics:sold_ids', id);
      return true;
    } catch (error, stackTrace) {
      session.log(
        'Failed to record product sold analytics: $error',
        level: LogLevel.warning,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> processPaidOrder(
    Session session,
    String orderNumber,
  ) async {
    final normalizedOrderNumber = orderNumber.trim();
    if (normalizedOrderNumber.isEmpty) return false;

    return session.db.transaction<bool>((transaction) async {
      final order = await CustomerOrderRow.db.findFirstRow(
        session,
        where: (t) => t.orderNumber.equals(normalizedOrderNumber),
        transaction: transaction,
        lockMode: LockMode.forUpdate,
      );
      if (order?.id == null ||
          order!.paymentStatus != 'paid' ||
          order.analyticsProcessedAt != null) {
        return false;
      }

      final items = await OrderItemRow.db.find(
        session,
        where: (t) => t.orderId.equals(order.id!) & t.isFreeItem.equals(false),
        transaction: transaction,
      );
      final soldByProduct = <String, int>{};
      for (final item in items) {
        if (item.quantity <= 0) continue;
        soldByProduct.update(
          item.productId.toString(),
          (quantity) => quantity + item.quantity,
          ifAbsent: () => item.quantity,
        );
      }

      if (soldByProduct.isNotEmpty) {
        final productIds = soldByProduct.keys.toList();
        final previousRows = await session.db.unsafeQuery(
          '''
          SELECT DISTINCT oi."productId"::text AS "productId"
          FROM order_item oi
          JOIN customer_order co ON co.id = oi."orderId"
          WHERE co."userId" = @userId::uuid
            AND co."paymentStatus" = 'paid'
            AND co.id <> @orderId::uuid
            AND oi."isFreeItem" = false
            AND oi."productId" = ANY(@productIds::uuid[])
          ''',
          parameters: QueryParameters.named({
            'userId': order.userId.toString(),
            'orderId': order.id!.toString(),
            'productIds': productIds,
          }),
          transaction: transaction,
        );
        final reorderedProductIds = previousRows
            .map((row) => row.toColumnMap()['productId']?.toString())
            .whereType<String>()
            .toSet();

        for (final entry in soldByProduct.entries) {
          await _redis.incrby(
            session,
            'product:sold:${entry.key}',
            entry.value,
          );
          await _redis.sadd(session, 'product:analytics:sold_ids', entry.key);
          if (reorderedProductIds.contains(entry.key)) {
            await _redis.incr(session, 'product:reorders:${entry.key}');
            await _redis.sadd(
              session,
              'product:analytics:reorder_ids',
              entry.key,
            );
          }
        }
      }

      await CustomerOrderRow.db.updateRow(
        session,
        order.copyWith(
          analyticsProcessedAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
      return true;
    });
  }

  Future<int> processUnprocessedPaidOrders(
    Session session, {
    int limit = 200,
  }) async {
    final rows = await CustomerOrderRow.db.find(
      session,
      where: (t) =>
          t.paymentStatus.equals('paid') & t.analyticsProcessedAt.equals(null),
      orderBy: (t) => t.orderedAt,
      limit: limit,
    );

    var processed = 0;
    for (final row in rows) {
      if (await processPaidOrder(session, row.orderNumber)) {
        processed++;
      }
    }
    return processed;
  }

  Future<int> syncCountersToPostgres(Session session) async {
    final viewDeltas = await _drainCounters(
      session,
      registryKey: 'product:analytics:view_ids',
      keyPrefix: 'product:views:',
    );
    final soldDeltas = await _drainCounters(
      session,
      registryKey: 'product:analytics:sold_ids',
      keyPrefix: 'product:sold:',
    );
    final reorderDeltas = await _drainCounters(
      session,
      registryKey: 'product:analytics:reorder_ids',
      keyPrefix: 'product:reorders:',
    );

    var updated = 0;
    updated += await _applyIntDeltas(
      session,
      columnName: 'mostSearchCount',
      deltas: viewDeltas,
    );
    updated += await _applyIntDeltas(
      session,
      columnName: 'mostPurchaseCount',
      deltas: soldDeltas,
    );
    updated += await _applyIntDeltas(
      session,
      columnName: 'reorderCount',
      deltas: reorderDeltas,
    );
    return updated;
  }

  Future<int> updateLast7DaysViews(Session session) async {
    final totals = <String, int>{};
    final now = DateTime.now().toUtc();
    for (var offset = 0; offset < 7; offset++) {
      final day = _dayKey(now.subtract(Duration(days: offset)));
      final ids = await _redis.smembers(
        session,
        'product:analytics:day_view_ids:$day',
      );
      for (final id in ids) {
        final value = await _redis.getInt(
          session,
          'product:views:day:$day:$id',
        );
        if (value <= 0) continue;
        totals.update(
          id,
          (existing) => existing + value,
          ifAbsent: () => value,
        );
      }
    }

    return session.db.transaction<int>((transaction) async {
      await session.db.unsafeExecute(
        '''
        UPDATE product
        SET "last7DaysViews" = 0,
            "updatedAt" = NOW()
        WHERE status = 'active'
        ''',
        transaction: transaction,
      );
      return _setIntColumnValues(
        session,
        columnName: 'last7DaysViews',
        values: totals,
        transaction: transaction,
      );
    });
  }

  Future<Map<String, int>> _drainCounters(
    Session session, {
    required String registryKey,
    required String keyPrefix,
  }) async {
    final ids = await _redis.smembers(session, registryKey);
    final deltas = <String, int>{};
    for (final id in ids) {
      final value = await _redis.getDelInt(session, '$keyPrefix$id');
      if (value > 0) {
        deltas[id] = value;
      }
    }
    return deltas;
  }

  Future<int> _applyIntDeltas(
    Session session, {
    required String columnName,
    required Map<String, int> deltas,
  }) async {
    if (deltas.isEmpty) return 0;
    final ids = deltas.keys.toList();
    final values = ids.map((id) => deltas[id]!).toList();
    return session.db.unsafeExecute(
      '''
      UPDATE product p
      SET "$columnName" = p."$columnName" + d.delta,
          "updatedAt" = NOW()
      FROM (
        SELECT
          unnest(@productIds::uuid[]) AS id,
          unnest(@deltas::bigint[]) AS delta
      ) d
      WHERE p.id = d.id
      ''',
      parameters: QueryParameters.named({
        'productIds': ids,
        'deltas': values,
      }),
    );
  }

  Future<int> _setIntColumnValues(
    Session session, {
    required String columnName,
    required Map<String, int> values,
    Transaction? transaction,
  }) async {
    if (values.isEmpty) return 0;
    final ids = values.keys.toList();
    final columnValues = ids.map((id) => values[id]!).toList();
    return session.db.unsafeExecute(
      '''
      UPDATE product p
      SET "$columnName" = v.value,
          "updatedAt" = NOW()
      FROM (
        SELECT
          unnest(@productIds::uuid[]) AS id,
          unnest(@values::bigint[]) AS value
      ) v
      WHERE p.id = v.id
      ''',
      parameters: QueryParameters.named({
        'productIds': ids,
        'values': columnValues,
      }),
      transaction: transaction,
    );
  }

  String _dayKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year$month$day';
  }
}

class _AnalyticsRedisClient {
  static final _AnalyticsRedisClient instance = _AnalyticsRedisClient._();

  _AnalyticsRedisClient._();

  redis.Command? _command;
  Future<redis.Command?>? _connecting;

  Future<int> incr(Session session, String key) async {
    final result = await _send(session, ['INCR', key]);
    return _parseInt(result);
  }

  Future<int> incrby(Session session, String key, int amount) async {
    final result = await _send(session, ['INCRBY', key, amount.toString()]);
    return _parseInt(result);
  }

  Future<String?> get(Session session, String key) async {
    final result = await _send(session, ['GET', key]);
    return result?.toString();
  }

  Future<int> getInt(Session session, String key) async {
    return _parseInt(await get(session, key));
  }

  Future<int> getDelInt(Session session, String key) async {
    final result = await _send(session, [
      'EVAL',
      "local v = redis.call('GET', KEYS[1]); "
          "if v then redis.call('DEL', KEYS[1]); end; "
          'return v',
      '1',
      key,
    ]);
    return _parseInt(result);
  }

  Future<bool> del(Session session, String key) async {
    final result = await _send(session, ['DEL', key]);
    return _parseInt(result) > 0;
  }

  Future<bool> expire(Session session, String key, int seconds) async {
    final result = await _send(session, ['EXPIRE', key, seconds.toString()]);
    return _parseInt(result) == 1;
  }

  Future<int> sadd(Session session, String key, String value) async {
    final result = await _send(session, ['SADD', key, value]);
    return _parseInt(result);
  }

  Future<Set<String>> smembers(Session session, String key) async {
    final result = await _send(session, ['SMEMBERS', key]);
    if (result is Iterable) {
      return result.map((value) => value.toString()).toSet();
    }
    return const <String>{};
  }

  Future<dynamic> _send(Session session, List<String> command) async {
    final redisCommand = await _connect(session);
    if (redisCommand == null) {
      throw StateError('Redis is not enabled.');
    }

    try {
      return await redisCommand.send_object(command);
    } catch (_) {
      _closeCommand();
      final retryCommand = await _connect(session);
      if (retryCommand == null) {
        throw StateError('Redis is not enabled.');
      }
      return retryCommand.send_object(command);
    }
  }

  Future<redis.Command?> _connect(Session session) async {
    if (_command != null) return _command;
    if (_connecting != null) return _connecting;

    _connecting = _createCommand(session);
    try {
      _command = await _connecting;
      return _command;
    } finally {
      _connecting = null;
    }
  }

  Future<redis.Command?> _createCommand(Session session) async {
    final config = session.serverpod.config.redis;
    if (config == null || !config.enabled) {
      return null;
    }

    final connection = redis.RedisConnection();
    final command = config.requireSsl
        ? await connection.connectSecure(config.host, config.port)
        : await connection.connect(config.host, config.port);

    final password = config.password;
    if (password != null) {
      final authResult = config.user == null
          ? await command.send_object(['AUTH', password])
          : await command.send_object(['AUTH', config.user!, password]);
      if (authResult != 'OK') {
        await command.get_connection().close();
        throw StateError('Redis authentication failed.');
      }
    }
    return command;
  }

  void _closeCommand() {
    try {
      _command?.get_connection().close();
    } catch (_) {}
    _command = null;
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is BigInt) return value.toInt();
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
