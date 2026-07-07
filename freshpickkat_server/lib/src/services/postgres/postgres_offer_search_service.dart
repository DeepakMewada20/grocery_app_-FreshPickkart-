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
    final searchJoin = normalizedQuery.length >= 2
        ? 'JOIN product_search_document psd ON psd."productId" = p.id'
        : '';
    final searchPredicate = normalizedQuery.length >= 2
        ? 'AND psd."searchText" ILIKE \'%\' || @query || \'%\''
        : '';
    final baseWhere = _baseWhereForType(normalizedType);
    final outerWhere = _whereForType(normalizedType);
    final orderBy = _orderByForType(normalizedType);
    final offerProductsCte = _offerProductsCte(
      normalizedType,
      searchJoin: searchJoin,
      searchPredicate: searchPredicate,
      baseWhere: baseWhere,
    );

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
      $offerProductsCte
      SELECT COUNT(DISTINCT product_uuid) AS "totalCount"
      FROM offer_products
      WHERE TRUE
        $outerWhere
      ''',
      parameters: QueryParameters.named(countParams),
    );
    final totalCount = totalResult.isEmpty
        ? 0
        : asInt(totalResult.first.toColumnMap()['totalCount']);

    final result = await session.db.unsafeQuery(
      '''
      $offerProductsCte
      SELECT product_id AS "productId", sort_value AS "sortValue"
      FROM offer_products
      WHERE TRUE
        $outerWhere
      ORDER BY $orderBy
      LIMIT @limit OFFSET @offset
      ''',
      parameters: QueryParameters.named(resultsParams),
    );

    final productIds = result
        .map((row) => row.toColumnMap()['productId']?.toString())
        .whereType<String>()
        .toList();
    final products = _catalog.flattenToVariantProducts(
      await _catalog.hydrateProductsByIds(session, productIds),
    );
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
      case 'discount_40':
        return 'AND calculated_discount_percentage >= 40';
      case 'discount':
        return 'AND calculated_discount_percentage > 0';
      case 'best_seller':
      case 'best seller':
        return 'AND most_purchase_count > 0';
      case 'new_arrival':
      case 'new arrival':
        return '';
      case 'free_delivery':
      case 'free delivery':
        return 'AND is_free_delivery = TRUE';
      case 'free_gift':
      case 'free gift':
        return '';
      default:
        return '';
    }
  }

  String _baseWhereForType(String offerType) {
    switch (offerType) {
      case 'bogo':
        return '''
        AND bo.status = 'active'
        AND (bo."startsAt" IS NULL OR bo."startsAt" <= NOW())
        AND (bo."endsAt" IS NULL OR bo."endsAt" >= NOW())
        ''';
      case 'free_gift':
      case 'free gift':
        return '''
        AND smgm.status = 'active'
        AND (smgm."startsAt" IS NULL OR smgm."startsAt" <= NOW())
        AND (smgm."endsAt" IS NULL OR smgm."endsAt" >= NOW())
        ''';
      default:
        return '';
    }
  }

  String _extraJoinForType(String offerType) {
    switch (offerType) {
      case 'bogo':
        return 'JOIN bogo_offer bo ON bo."triggerProductId" = p.id';
      case 'free_gift':
      case 'free gift':
        return 'JOIN shop_more_get_more_offer smgm ON smgm."freeProductId" = p.id';
      default:
        return '';
    }
  }

  String _sortExpressionForType(String offerType) {
    switch (offerType) {
      case 'best_seller':
      case 'best seller':
        return 'p."mostPurchaseCount"';
      case 'new_arrival':
      case 'new arrival':
        return 'p."createdAt"';
      case 'bogo':
        return 'bo."createdAt"';
      case 'free_gift':
      case 'free gift':
        return 'smgm."minimumOrderAmount"';
      default:
        return 'p."createdAt"';
    }
  }

  String _orderByForType(String offerType) {
    switch (offerType) {
      case 'best_seller':
      case 'best seller':
        return 'sort_value DESC, product_id DESC';
      case 'new_arrival':
      case 'new arrival':
        return 'created_at DESC, product_id DESC';
      case 'discount':
      case 'discount_40':
        return 'created_at DESC, product_id DESC';
      case 'free_delivery':
      case 'free delivery':
        return 'trending_score DESC, most_purchase_count DESC, product_id DESC';
      case 'bogo':
        return 'sort_value DESC, product_id DESC';
      case 'free_gift':
      case 'free gift':
        return 'sort_value ASC, product_id ASC';
      default:
        return 'product_name ASC, product_id ASC';
    }
  }

  String _offerProductsCte(
    String offerType, {
    required String searchJoin,
    required String searchPredicate,
    required String baseWhere,
  }) {
    final categoryOfferPrice = '''
      CASE
        WHEN active_category_offer."discountType" = 'percentage'
          THEN COALESCE(
            default_variant."listPrice",
            default_variant."salePrice",
            0
          ) *
            (1 - (active_category_offer."discountValue" / 100))
        WHEN active_category_offer."discountType" = 'flat'
          THEN COALESCE(
            default_variant."listPrice",
            default_variant."salePrice",
            0
          ) - active_category_offer."discountValue"
        ELSE NULL
      END
    ''';

    final effectivePrice = '''
      CASE
        WHEN category_offer_price IS NOT NULL
          AND category_offer_price < sale_price
          THEN category_offer_price
        ELSE sale_price
      END
    ''';

    return '''
      WITH priced_products AS (
        SELECT
          p.id AS product_uuid,
          p.id::text AS product_id,
          p.name AS product_name,
          p."createdAt" AS created_at,
          p."mostPurchaseCount" AS most_purchase_count,
          p."trendingScore" AS trending_score,
          ${_sortExpressionForType(offerType)} AS sort_value,
          COALESCE(default_variant."salePrice", 0) AS sale_price,
          COALESCE(
            default_variant."listPrice",
            default_variant."salePrice",
            0
          ) AS list_price,
          p."isFreeDelivery" AS is_free_delivery,
          $categoryOfferPrice AS category_offer_price
        FROM product p
        JOIN category c ON c.id = p."categoryId"
        $searchJoin
        ${_extraJoinForType(offerType)}
        LEFT JOIN LATERAL (
          SELECT
            pv."salePrice",
            pv."listPrice"
          FROM product_variant pv
          WHERE pv."productId" = p.id
          ORDER BY
            pv."isDefault" DESC,
            pv."isAvailable" DESC,
            pv."sortOrder" ASC,
            pv.label ASC
          LIMIT 1
        ) default_variant ON TRUE
        LEFT JOIN LATERAL (
          SELECT
            co."discountType",
            co."discountValue"
          FROM category_offer co
          WHERE co."categoryId" = p."categoryId"
            AND co.status = 'active'
            AND (co."startsAt" IS NULL OR co."startsAt" <= NOW())
            AND (co."endsAt" IS NULL OR co."endsAt" >= NOW())
          ORDER BY co.priority DESC
          LIMIT 1
        ) active_category_offer ON TRUE
        WHERE p.status = 'active'
          AND c.status = 'active'
          $baseWhere
          $searchPredicate
      ),
      effective_products AS (
        SELECT
          *,
          $effectivePrice AS effective_price
        FROM priced_products
      ),
      offer_products AS (
        SELECT
          *,
          CASE
            WHEN list_price > 0 AND effective_price < list_price
              THEN ((list_price - effective_price) / list_price) * 100
            ELSE 0
          END AS calculated_discount_percentage
        FROM effective_products
      )
    ''';
  }

  double calculateDiscountPercentageForTesting({
    required double listPrice,
    required double salePrice,
    String? categoryDiscountType,
    double? categoryDiscountValue,
  }) {
    final categoryOfferValue = categoryDiscountValue;
    double? categoryOfferPrice;
    if (categoryDiscountType == 'percentage' && categoryOfferValue != null) {
      categoryOfferPrice = listPrice * (1 - (categoryOfferValue / 100));
    } else if (categoryDiscountType == 'flat' && categoryOfferValue != null) {
      categoryOfferPrice = listPrice - categoryOfferValue;
    }

    final effectivePrice =
        categoryOfferPrice != null && categoryOfferPrice < salePrice
        ? categoryOfferPrice
        : salePrice;
    if (listPrice <= 0 || effectivePrice >= listPrice) return 0;
    return ((listPrice - effectivePrice) / listPrice) * 100;
  }

  String orderByForTesting(String offerType) => _orderByForType(offerType);
}
