import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'postgres_catalog_service.dart';
import 'postgres_offer_service.dart';
import 'postgres_support.dart';

class PostgresOfferSearchService {
  static const int _defaultLimit = 20;
  static const int _maxLimit = 50;

  final PostgresCatalogService _catalog = PostgresCatalogService();
  final PostgresOfferService _offers = PostgresOfferService();

  Future<OfferSearchPage> searchProductsWithOfferFilters(
    Session session, {
    required String query,
    required String offerFilter,
    int limit = _defaultLimit,
    String? pageToken,
  }) {
    return getProductsByOffer(
      session,
      offerType: offerFilter,
      query: query,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<OfferSearchPage> getBogoProducts(
    Session session, {
    String query = '',
    int limit = _defaultLimit,
    String? pageToken,
  }) {
    return getProductsByOffer(
      session,
      offerType: 'bogo',
      query: query,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<OfferSearchPage> getComboProducts(
    Session session, {
    String query = '',
    int limit = _defaultLimit,
    String? pageToken,
  }) async {
    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultLimit,
      maxLimit: _maxLimit,
    );
    final offset = int.tryParse(pageToken ?? '')?.clamp(0, 1 << 30) ?? 0;
    final normalizedQuery = query.trim().toLowerCase();
    final allCombos = await _offers.getActiveComboOffers(session);
    final filtered = normalizedQuery.isEmpty
        ? allCombos
        : allCombos.where((combo) {
            final text = [
              combo.name,
              combo.description ?? '',
              ...combo.comboProducts.map((item) => item.productName ?? ''),
            ].join(' ').toLowerCase();
            return text.contains(normalizedQuery);
          }).toList();

    final end = (offset + pageSize).clamp(0, filtered.length);
    final pageCombos = filtered.sublist(offset.clamp(0, filtered.length), end);
    final productIds = pageCombos
        .expand((combo) => combo.comboProducts)
        .map((item) => item.productId)
        .where((id) => id.trim().isNotEmpty)
        .toSet()
        .toList();
    final products = await _catalog.hydrateProductsByIds(session, productIds);
    final productById = {
      for (final product in products)
        if (product.productId != null) product.productId!: product,
    };

    return OfferSearchPage(
      items: pageCombos
          .map(
            (combo) => OfferSearchItem(
              offerType: 'combo',
              comboOffer: combo,
              relatedProducts: combo.comboProducts
                  .map((item) => productById[item.productId])
                  .whereType<Product>()
                  .toList(),
            ),
          )
          .toList(),
      nextPageToken: end < filtered.length ? '$end' : null,
      totalCount: filtered.length,
    );
  }

  Future<OfferSearchPage> getProductsByOffer(
    Session session, {
    required String offerType,
    String query = '',
    int limit = _defaultLimit,
    String? pageToken,
  }) async {
    final normalizedType = offerType.trim().toLowerCase();
    if (normalizedType == 'combo') {
      return getComboProducts(
        session,
        query: query,
        limit: limit,
        pageToken: pageToken,
      );
    }

    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultLimit,
      maxLimit: _maxLimit,
    );
    final offset = int.tryParse(pageToken ?? '')?.clamp(0, 1 << 30) ?? 0;
    final normalizedQuery = query.trim();
    final where = _whereForType(normalizedType);
    final searchJoin = normalizedQuery.length >= 2
        ? 'JOIN product_search_document psd ON psd."productId" = p.id'
        : '';
    final searchPredicate = normalizedQuery.length >= 2
        ? 'AND psd."searchText" ILIKE \'%\' || @query || \'%\''
        : '';
    final orderBy = _orderByForType(normalizedType);

    final countParams = <String, dynamic>{};
    final resultsParams = <String, dynamic>{
      'limit': pageSize,
      'offset': offset,
    };

    if (normalizedQuery.length >= 2) {
      countParams['query'] = normalizedQuery;
      resultsParams['query'] = normalizedQuery;
    }

    final totalResult = await session.db.unsafeQuery(
      '''
      SELECT COUNT(DISTINCT p.id) AS "totalCount"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      $searchJoin
      ${_extraJoinForType(normalizedType)}
      WHERE p.status = 'active'
        AND c.status = 'active'
        $where
        $searchPredicate
      ''',
      parameters: QueryParameters.named(countParams),
    );
    final totalCount = totalResult.isEmpty
        ? 0
        : asInt(totalResult.first.toColumnMap()['totalCount']);

    final result = await session.db.unsafeQuery(
      '''
      SELECT p.id::text AS "productId", ${_selectSortColumn(normalizedType)}
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      $searchJoin
      ${_extraJoinForType(normalizedType)}
      WHERE p.status = 'active'
        AND c.status = 'active'
        $where
        $searchPredicate
      ORDER BY $orderBy
      LIMIT @limit OFFSET @offset
      ''',
      parameters: QueryParameters.named(resultsParams),
    );

    final productIds = result
        .map((row) => row.toColumnMap()['productId']?.toString())
        .whereType<String>()
        .toList();
    final products = await _catalog.hydrateProductsByIds(session, productIds);
    final bogoOffers = normalizedType == 'bogo'
        ? await _offers.getActiveBogoOffersForProducts(
            session,
            products
                .map((product) => product.productId)
                .whereType<String>()
                .toList(),
          )
        : const <BogoOffer>[];
    final bogoByProduct = {
      for (final offer in bogoOffers) offer.triggerProductId: offer,
    };

    return OfferSearchPage(
      items: products
          .map(
            (product) => OfferSearchItem(
              offerType: normalizedType,
              product: product,
              bogoOffer: product.productId == null
                  ? null
                  : bogoByProduct[product.productId],
            ),
          )
          .toList(),
      nextPageToken: offset + products.length < totalCount
          ? '${offset + products.length}'
          : null,
      totalCount: totalCount,
    );
  }

  String _whereForType(String offerType) {
    switch (offerType) {
      case 'bogo':
        return '''
        AND bo.status = 'active'
        AND NOW() BETWEEN bo."startsAt" AND bo."endsAt"
        ''';
      case 'discount':
        return '''
        AND (
          p."discountType" IS NOT NULL
          OR EXISTS (
            SELECT 1
            FROM category_offer co
            WHERE co."categoryId" = p."categoryId"
              AND co.status = 'active'
              AND NOW() BETWEEN co."startsAt" AND co."endsAt"
          )
        )
        ''';
      case 'best_seller':
      case 'best seller':
        return 'AND p."mostPurchaseCount" > 0';
      case 'new_arrival':
      case 'new arrival':
        return '';
      case 'free_delivery':
      case 'free delivery':
        return '';
      default:
        return '';
    }
  }

  String _extraJoinForType(String offerType) {
    if (offerType == 'bogo') {
      return 'JOIN bogo_offer bo ON bo."triggerProductId" = p.id';
    }
    return '';
  }

  String _selectSortColumn(String offerType) {
    switch (offerType) {
      case 'best_seller':
      case 'best seller':
        return 'p."mostPurchaseCount" AS "sortValue"';
      case 'new_arrival':
      case 'new arrival':
        return 'p."createdAt" AS "sortValue"';
      case 'bogo':
        return 'bo."createdAt" AS "sortValue"';
      default:
        return 'p."createdAt" AS "sortValue"';
    }
  }

  String _orderByForType(String offerType) {
    switch (offerType) {
      case 'best_seller':
      case 'best seller':
        return '"sortValue" DESC, "productId" DESC';
      case 'new_arrival':
      case 'new arrival':
        return '"sortValue" DESC, "productId" DESC';
      case 'discount':
        return 'p."createdAt" DESC, p.id DESC';
      case 'free_delivery':
      case 'free delivery':
        return 'p."trendingScore" DESC, p."mostPurchaseCount" DESC, p.id DESC';
      case 'bogo':
        return '"sortValue" DESC, "productId" DESC';
      default:
        return 'p.name ASC, p.id ASC';
    }
  }
}
