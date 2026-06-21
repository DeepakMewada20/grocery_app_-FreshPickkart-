import 'package:serverpod/serverpod.dart' hide Order;

import '../generated/protocol.dart';
import '../services/postgres/postgres_order_service.dart';

class OrderPgEndpoint extends Endpoint {
  final PostgresOrderService _orderService = PostgresOrderService();

  Future<String> createPendingOrder(
    Session session,
    Order order,
    String idempotencyKey, {
    int freshPointsToRedeem = 0,
  }) {
    return _orderService.createPendingOrder(
      session,
      order: order,
      idempotencyKey: idempotencyKey,
      freshPointsToRedeem: freshPointsToRedeem,
    );
  }

  Future<OrderPage> getOrdersForUser(
    Session session, {
    required String userReference,
    int limit = 20,
    String? pageToken,
  }) {
    return _orderService.getOrdersForUser(
      session,
      userReference: userReference,
      limit: limit,
      pageToken: pageToken,
    );
  }
}
