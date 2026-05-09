import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/analytics/product_ranking_service.dart';
import '../services/analytics/redis_analytics_service.dart';

class ProductRankingEndpoint extends Endpoint {
  final RedisAnalyticsService _redisAnalytics = RedisAnalyticsService.instance;
  final ProductRankingService _rankings = ProductRankingService();

  Future<bool> recordProductView(Session session, String productId) {
    return _redisAnalytics.recordProductView(session, productId);
  }

  Future<List<ProductRankingItem>> getTrendingProducts(
    Session session, {
    int limit = 10,
  }) {
    return _rankings.getTrendingProducts(session, limit: limit);
  }

  Future<List<ProductRankingItem>> getMostSellingProducts(
    Session session, {
    int limit = 10,
  }) {
    return _rankings.getMostSellingProducts(session, limit: limit);
  }

  Future<List<ProductRankingItem>> getMostViewedProducts(
    Session session, {
    int limit = 10,
  }) {
    return _rankings.getMostViewedProducts(session, limit: limit);
  }

  Future<List<ProductRankingItem>> getFrequentlyReorderedProducts(
    Session session, {
    int limit = 10,
  }) {
    return _rankings.getFrequentlyReorderedProducts(session, limit: limit);
  }
}
