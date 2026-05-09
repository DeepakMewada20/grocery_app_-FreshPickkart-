import 'package:serverpod/serverpod.dart';

class TrendingScoreService {
  Future<int> updateLast7DaysSold(Session session) {
    return session.db.unsafeExecute(
      '''
      UPDATE product p
      SET "last7DaysSold" = COALESCE((
            SELECT SUM(oi.quantity)::bigint
            FROM order_item oi
            JOIN customer_order co ON co.id = oi."orderId"
            WHERE oi."productId" = p.id
              AND oi."isFreeItem" = false
              AND co."paymentStatus" = 'paid'
              AND co."orderedAt" >= (NOW() AT TIME ZONE 'utc') - INTERVAL '7 days'
          ), 0),
          "updatedAt" = NOW()
      WHERE p.status = 'active'
      ''',
    );
  }

  Future<int> calculateTrendingScores(Session session) {
    return session.db.unsafeExecute(
      '''
      UPDATE product
      SET "trendingScore" =
            ("last7DaysSold" * 0.6)
          + ("last7DaysViews" * 0.2)
          + ("reorderCount" * 0.2),
          "updatedAt" = NOW()
      WHERE status = 'active'
      ''',
    );
  }
}
