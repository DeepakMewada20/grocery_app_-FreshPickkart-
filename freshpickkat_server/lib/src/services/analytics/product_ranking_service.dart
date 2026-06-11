import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../postgres/postgres_catalog_service.dart';
import '../postgres/postgres_support.dart';

class ProductRankingService {
  static const int _defaultLimit = 10;
  static const int _maxLimit = 50;

  final PostgresCatalogService _catalog = PostgresCatalogService();

  Future<List<ProductRankingItem>> getTrendingProducts(
    Session session, {
    int limit = _defaultLimit,
  }) {
    return _rankByColumn(
      session,
      limit: limit,
      metricType: 'trending',
      metricColumn: 'trendingScore',
    );
  }

  Future<List<ProductRankingItem>> getMostSellingProducts(
    Session session, {
    int limit = _defaultLimit,
  }) {
    return _rankByColumn(
      session,
      limit: limit,
      metricType: 'most_selling',
      metricColumn: 'mostPurchaseCount',
    );
  }

  Future<List<ProductRankingItem>> getMostViewedProducts(
    Session session, {
    int limit = _defaultLimit,
  }) {
    return _rankByColumn(
      session,
      limit: limit,
      metricType: 'most_viewed',
      metricColumn: 'mostSearchCount',
    );
  }

  Future<List<ProductRankingItem>> getFrequentlyReorderedProducts(
    Session session, {
    int limit = _defaultLimit,
  }) {
    return _rankByColumn(
      session,
      limit: limit,
      metricType: 'frequently_reordered',
      metricColumn: 'reorderCount',
    );
  }

  Future<List<RankingRow>> getRankedProductIds(
    Session session, {
    required int limit,
    required String metricType,
    required String metricColumn,
  }) async {
    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultLimit,
      maxLimit: _maxLimit,
    );

    final result = await session.db.unsafeQuery(
      '''
      SELECT
        p.id::text AS "productId",
        p."$metricColumn" AS "metricValue",
        p."last7DaysSold" AS "last7DaysSold",
        p."last7DaysViews" AS "last7DaysViews",
        p."reorderCount" AS "reorderCount",
        p."trendingScore" AS "trendingScore"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = 'active'
        AND c.status = 'active'
      ORDER BY p."$metricColumn" DESC, p.id DESC
      LIMIT @limit
      ''',
      parameters: QueryParameters.named({'limit': pageSize}),
    );

    final rows = <RankingRow>[];
    for (final row in result) {
      final map = row.toColumnMap();
      final productId = map['productId']?.toString();
      if (productId == null || productId.isEmpty) continue;
      rows.add(
        RankingRow(
          productId: productId,
          metricValue: asDouble(map['metricValue']),
          last7DaysSold: asInt(map['last7DaysSold']),
          last7DaysViews: asInt(map['last7DaysViews']),
          reorderCount: asInt(map['reorderCount']),
          trendingScore: asDouble(map['trendingScore']),
        ),
      );
    }
    return rows;
  }

  static List<ProductRankingItem> buildRankingItems({
    required List<RankingRow> rows,
    required Map<String, Product> productsById,
    required String metricType,
  }) {
    final ranked = <ProductRankingItem>[];
    for (var index = 0; index < rows.length; index++) {
      final row = rows[index];
      final product = productsById[row.productId];
      if (product == null) continue;
      ranked.add(
        ProductRankingItem(
          product: product,
          rank: ranked.length + 1,
          metricType: metricType,
          metricValue: row.metricValue,
          last7DaysSold: row.last7DaysSold,
          last7DaysViews: row.last7DaysViews,
          reorderCount: row.reorderCount,
          trendingScore: row.trendingScore,
        ),
      );
    }
    return ranked;
  }

  Future<List<ProductRankingItem>> _rankByColumn(
    Session session, {
    required int limit,
    required String metricType,
    required String metricColumn,
  }) async {
    final rows = await getRankedProductIds(
      session,
      limit: limit,
      metricType: metricType,
      metricColumn: metricColumn,
    );

    final products = await _catalog.hydrateProductsByIds(
      session,
      rows.map((row) => row.productId).toList(),
    );
    final productsById = {
      for (final product in products)
        if (product.productId != null) product.productId!: product,
    };

    return ProductRankingService.buildRankingItems(
      rows: rows,
      productsById: productsById,
      metricType: metricType,
    );
  }
}

class RankingRow {
  const RankingRow({
    required this.productId,
    required this.metricValue,
    required this.last7DaysSold,
    required this.last7DaysViews,
    required this.reorderCount,
    required this.trendingScore,
  });

  final String productId;
  final double metricValue;
  final int last7DaysSold;
  final int last7DaysViews;
  final int reorderCount;
  final double trendingScore;
}
