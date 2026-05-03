import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'postgres_support.dart';

class PostgresCatalogService {
  static const int _defaultLimit = 20;
  static const int _maxLimit = 50;

  Future<ProductPage> getActiveProductsPage(
    Session session, {
    int limit = _defaultLimit,
    String? pageToken,
    String? categoryId,
    String? subCategoryId,
  }) async {
    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultLimit,
      maxLimit: _maxLimit,
    );
    final parsedCategoryId = tryParseUuid(categoryId);
    final parsedSubCategoryId = tryParseUuid(subCategoryId);
    final cursor = _decodeBrowseCursor(pageToken);

    final totalCount = await _countBrowseProducts(
      session,
      categoryId: parsedCategoryId,
      subCategoryId: parsedSubCategoryId,
    );

    final result = await session.db.unsafeQuery(
      '''
      SELECT
        p.id::text AS "productId",
        p."createdAt" AS "createdAt"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = 'active'
        AND c.status = 'active'
        AND (@categoryId IS NULL OR p."categoryId" = @categoryId)
        AND (
          @subCategoryId IS NULL OR EXISTS (
            SELECT 1
            FROM product_sub_category psc
            JOIN sub_category sc ON sc.id = psc."subCategoryId"
            WHERE psc."productId" = p.id
              AND psc."subCategoryId" = @subCategoryId
              AND sc.status = 'active'
          )
        )
        AND (
          @cursorCreatedAt IS NULL
          OR p."createdAt" < @cursorCreatedAt
          OR (
            p."createdAt" = @cursorCreatedAt
            AND p.id::text < @cursorProductId
          )
        )
      ORDER BY p."createdAt" DESC, p.id DESC
      LIMIT @limit
      ''',
      parameters: QueryParameters.named({
        'categoryId': parsedCategoryId,
        'subCategoryId': parsedSubCategoryId,
        'cursorCreatedAt': cursor?.createdAt,
        'cursorProductId': cursor?.productId,
        'limit': pageSize + 1,
      }),
    );

    final productIds = <String>[];
    final cursorRows = <_BrowseCursor>[];
    for (final row in result) {
      final map = row.toColumnMap();
      final productId = map['productId']?.toString();
      if (productId == null || productId.isEmpty) continue;

      final createdAt = asDateTime(map['createdAt']);
      productIds.add(productId);
      cursorRows.add(
        _BrowseCursor(
          productId: productId,
          createdAt: createdAt,
        ),
      );
    }

    final hasMore = productIds.length > pageSize;
    if (hasMore) {
      productIds.removeLast();
      cursorRows.removeLast();
    }

    final products = await hydrateProductsByIds(
      session,
      productIds,
    );

    final nextPageToken = hasMore && cursorRows.isNotEmpty
        ? encodeCursor({
            'createdAt': cursorRows.last.createdAt.toUtc().toIso8601String(),
            'productId': cursorRows.last.productId,
          })
        : null;

    return ProductPage(
      products: products,
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  Future<ProductPage> searchActiveProducts(
    Session session, {
    required String query,
    int limit = _defaultLimit,
    String? pageToken,
    String? categoryId,
    String? subCategoryId,
    double similarityThreshold = 0.2,
  }) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.length < 2) {
      return ProductPage(
        products: const [],
        nextPageToken: null,
        totalCount: 0,
      );
    }

    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultLimit,
      maxLimit: _maxLimit,
    );
    final parsedCategoryId = tryParseUuid(categoryId);
    final parsedSubCategoryId = tryParseUuid(subCategoryId);
    final cursor = _decodeSearchCursor(pageToken, normalizedQuery);
    final threshold = similarityThreshold.clamp(0.0, 1.0);

    final totalCount = await _countSearchProducts(
      session,
      query: normalizedQuery,
      categoryId: parsedCategoryId,
      subCategoryId: parsedSubCategoryId,
      similarityThreshold: threshold,
    );

    final result = await session.db.unsafeQuery(
      '''
      WITH ranked AS (
        SELECT
          psd."productId"::text AS "productId",
          similarity(psd."searchText", @query) AS "rank",
          psd."sourceCreatedAt" AS "sourceCreatedAt"
        FROM product_search_document psd
        JOIN product p ON p.id = psd."productId"
        JOIN category c ON c.id = p."categoryId"
        WHERE p.status = 'active'
          AND c.status = 'active'
          AND psd."searchText" ILIKE '%' || @query || '%'
          AND similarity(psd."searchText", @query) > @threshold
          AND (@categoryId IS NULL OR p."categoryId" = @categoryId)
          AND (
            @subCategoryId IS NULL OR EXISTS (
              SELECT 1
              FROM product_sub_category psc
              JOIN sub_category sc ON sc.id = psc."subCategoryId"
              WHERE psc."productId" = p.id
                AND psc."subCategoryId" = @subCategoryId
                AND sc.status = 'active'
            )
          )
      )
      SELECT
        "productId",
        "rank",
        "sourceCreatedAt"
      FROM ranked
      WHERE (
        @cursorRank IS NULL
        OR "rank" < @cursorRank
        OR (
          "rank" = @cursorRank
          AND (
            "sourceCreatedAt" < @cursorCreatedAt
            OR (
              "sourceCreatedAt" = @cursorCreatedAt
              AND "productId" < @cursorProductId
            )
          )
        )
      )
      ORDER BY "rank" DESC, "sourceCreatedAt" DESC, "productId" DESC
      LIMIT @limit
      ''',
      parameters: QueryParameters.named({
        'query': normalizedQuery,
        'threshold': threshold,
        'categoryId': parsedCategoryId,
        'subCategoryId': parsedSubCategoryId,
        'cursorRank': cursor?.rank,
        'cursorCreatedAt': cursor?.createdAt,
        'cursorProductId': cursor?.productId,
        'limit': pageSize + 1,
      }),
    );

    final productIds = <String>[];
    final cursorRows = <_SearchCursor>[];
    for (final row in result) {
      final map = row.toColumnMap();
      final productId = map['productId']?.toString();
      if (productId == null || productId.isEmpty) continue;

      productIds.add(productId);
      cursorRows.add(
        _SearchCursor(
          query: normalizedQuery,
          rank: asDouble(map['rank']),
          createdAt: asDateTime(map['sourceCreatedAt']),
          productId: productId,
        ),
      );
    }

    final hasMore = productIds.length > pageSize;
    if (hasMore) {
      productIds.removeLast();
      cursorRows.removeLast();
    }

    final products = await hydrateProductsByIds(
      session,
      productIds,
    );

    final nextPageToken = hasMore && cursorRows.isNotEmpty
        ? encodeCursor({
            'query': cursorRows.last.query,
            'rank': cursorRows.last.rank,
            'createdAt': cursorRows.last.createdAt.toUtc().toIso8601String(),
            'productId': cursorRows.last.productId,
          })
        : null;

    return ProductPage(
      products: products,
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  Future<int> _countBrowseProducts(
    Session session, {
    required UuidValue? categoryId,
    required UuidValue? subCategoryId,
  }) async {
    final result = await session.db.unsafeQuery(
      '''
      SELECT COUNT(*) AS "totalCount"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = 'active'
        AND c.status = 'active'
        AND (@categoryId IS NULL OR p."categoryId" = @categoryId)
        AND (
          @subCategoryId IS NULL OR EXISTS (
            SELECT 1
            FROM product_sub_category psc
            JOIN sub_category sc ON sc.id = psc."subCategoryId"
            WHERE psc."productId" = p.id
              AND psc."subCategoryId" = @subCategoryId
              AND sc.status = 'active'
          )
        )
      ''',
      parameters: QueryParameters.named({
        'categoryId': categoryId,
        'subCategoryId': subCategoryId,
      }),
    );

    if (result.isEmpty) return 0;
    return asInt(result.first.toColumnMap()['totalCount']);
  }

  Future<int> _countSearchProducts(
    Session session, {
    required String query,
    required UuidValue? categoryId,
    required UuidValue? subCategoryId,
    required double similarityThreshold,
  }) async {
    final result = await session.db.unsafeQuery(
      '''
      SELECT COUNT(*) AS "totalCount"
      FROM product_search_document psd
      JOIN product p ON p.id = psd."productId"
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = 'active'
        AND c.status = 'active'
        AND psd."searchText" ILIKE '%' || @query || '%'
        AND similarity(psd."searchText", @query) > @threshold
        AND (@categoryId IS NULL OR p."categoryId" = @categoryId)
        AND (
          @subCategoryId IS NULL OR EXISTS (
            SELECT 1
            FROM product_sub_category psc
            JOIN sub_category sc ON sc.id = psc."subCategoryId"
            WHERE psc."productId" = p.id
              AND psc."subCategoryId" = @subCategoryId
              AND sc.status = 'active'
          )
        )
      ''',
      parameters: QueryParameters.named({
        'query': query,
        'threshold': similarityThreshold,
        'categoryId': categoryId,
        'subCategoryId': subCategoryId,
      }),
    );

    if (result.isEmpty) return 0;
    return asInt(result.first.toColumnMap()['totalCount']);
  }

  Future<List<Product>> hydrateProductsByIds(
    Session session,
    List<String> orderedProductIds,
  ) async {
    if (orderedProductIds.isEmpty) return const [];

    final productIds = orderedProductIds
        .map((id) => parseUuid(id, fieldName: 'productId'))
        .toSet();

    final products = await ProductRow.db.find(
      session,
      where: (t) => t.id.inSet(productIds) & t.status.equals('active'),
    );

    if (products.isEmpty) return const [];

    final productById = {
      for (final product in products) product.id!.toString(): product,
    };

    final variants = await ProductVariantRow.db.find(
      session,
      where: (t) => t.productId.inSet(productIds),
    );
    final variantsByProduct = <String, List<ProductVariantRow>>{};
    for (final variant in variants) {
      variantsByProduct
          .putIfAbsent(variant.productId.toString(), () => [])
          .add(variant);
    }

    final mappings = await ProductSubCategoryRow.db.find(
      session,
      where: (t) => t.productId.inSet(productIds),
    );
    final subCategoryIds = mappings.map((row) => row.subCategoryId).toSet();
    final subCategories = subCategoryIds.isEmpty
        ? <SubCategoryRow>[]
        : await SubCategoryRow.db.find(
            session,
            where: (t) =>
                t.id.inSet(subCategoryIds) & t.status.equals('active'),
          );
    final subCategoryById = {
      for (final subCategory in subCategories)
        subCategory.id!.toString(): subCategory,
    };
    final subCategoryNamesByProduct = <String, List<String>>{};
    for (final mapping in mappings) {
      final subCategory = subCategoryById[mapping.subCategoryId.toString()];
      if (subCategory == null) continue;

      subCategoryNamesByProduct
          .putIfAbsent(mapping.productId.toString(), () => [])
          .add(subCategory.name);
    }

    final categoryIds = products.map((product) => product.categoryId).toSet();
    final categories = await CategoryRow.db.find(
      session,
      where: (t) => t.id.inSet(categoryIds) & t.status.equals('active'),
    );
    final categoryById = {
      for (final category in categories) category.id!.toString(): category,
    };

    final now = DateTime.now().toUtc();
    final bogoOfferRows = await BogoOfferRow.db.find(
      session,
      where: (t) =>
          t.triggerProductId.inSet(productIds) & t.status.equals('active'),
    );
    final activeBogoOfferRows = bogoOfferRows.where(
      (row) => !now.isBefore(row.startsAt) && !now.isAfter(row.endsAt),
    );
    final activeBogoOfferIds = activeBogoOfferRows
        .map((row) => row.id!)
        .toSet();
    final triggerProductByOfferId = {
      for (final row in activeBogoOfferRows)
        row.id!.toString(): row.triggerProductId.toString(),
    };
    final bogoRewardRows = activeBogoOfferIds.isEmpty
        ? const <BogoOfferRewardRow>[]
        : await BogoOfferRewardRow.db.find(
            session,
            where: (t) => t.bogoOfferId.inSet(activeBogoOfferIds),
          );
    final bogoRewardsByProduct = <String, Set<String>>{};
    for (final reward in bogoRewardRows) {
      final triggerProductId =
          triggerProductByOfferId[reward.bogoOfferId.toString()];
      if (triggerProductId == null) continue;
      bogoRewardsByProduct
          .putIfAbsent(triggerProductId, () => <String>{})
          .add(reward.rewardProductId.toString());
    }

    final hydrated = <Product>[];
    for (final productId in orderedProductIds) {
      final productRow = productById[productId];
      if (productRow == null) continue;

      final category = categoryById[productRow.categoryId.toString()];
      if (category == null) continue;

      final variantRows =
          variantsByProduct[productId] ?? const <ProductVariantRow>[];
      variantRows.sort((a, b) {
        if (a.isDefault != b.isDefault) return b.isDefault ? 1 : -1;
        final sortOrderCompare = a.sortOrder.compareTo(b.sortOrder);
        if (sortOrderCompare != 0) return sortOrderCompare;
        return a.label.compareTo(b.label);
      });

      final mappedVariants = variantRows
          .map(
            (variant) => ProductVariant(
              variantId: variant.id!.toString(),
              quantityValue: variant.quantityValue,
              quantityUnit: variant.quantityUnit,
              quantityDescription: variant.quantityDescription,
              price: variant.salePrice,
              realPrice: variant.listPrice,
              isAvailable: variant.isAvailable,
              sortOrder: variant.sortOrder,
            ),
          )
          .toList();

      final defaultVariant = variantRows.cast<ProductVariantRow?>().firstWhere(
        (variant) => variant != null && variant.isDefault,
        orElse: () => variantRows.cast<ProductVariantRow?>().firstWhere(
          (variant) => variant != null && variant.isAvailable,
          orElse: () => variantRows.isEmpty ? null : variantRows.first,
        ),
      );

      final salePrice = defaultVariant?.salePrice ?? 0.0;
      final listPrice = defaultVariant?.listPrice ?? salePrice;
      final discountValue = listPrice > salePrice ? listPrice - salePrice : 0.0;
      final discountPercent = listPrice > 0 && discountValue > 0
          ? (discountValue / listPrice) * 100
          : 0.0;
      final bogoFreeProductIds = bogoRewardsByProduct[productId]?.toList()
        ?..sort();

      hydrated.add(
        Product(
          productId: productRow.id!.toString(),
          productName: productRow.name,
          category: category.name,
          shortDescription: productRow.shortDescription,
          description: productRow.description,
          imageUrl: productRow.primaryImageUrl ?? '',
          price: salePrice,
          realPrice: listPrice,
          discount: double.parse(discountPercent.toStringAsFixed(2)),
          discountType: productRow.discountType,
          discountValue: discountValue > 0
              ? double.parse(discountValue.toStringAsFixed(2))
              : null,
          isAvailable:
              productRow.status == 'active' &&
              (defaultVariant == null || defaultVariant.isAvailable),
          addedAt: productRow.createdAt,
          subcategory: subCategoryNamesByProduct[productId] ?? const [],
          quantity: _formatQuantity(defaultVariant, productRow),
          baseUnit: productRow.baseUnit,
          baseQuantity: productRow.baseQuantity,
          quantityDescription: productRow.quantityDescription,
          countryOfOrigin: productRow.countryOfOrigin,
          stock: productRow.stock,
          stockUnit: productRow.stockUnit,
          mostSearch: productRow.mostSearchCount,
          mostPurchases: productRow.mostPurchaseCount,
          bogoFreeProductIds: bogoFreeProductIds?.isEmpty == true
              ? null
              : bogoFreeProductIds,
          variants: mappedVariants.isEmpty ? null : mappedVariants,
        ),
      );
    }

    return hydrated;
  }

  String _formatQuantity(ProductVariantRow? variant, ProductRow product) {
    final variantDescription = cleanNullableString(
      variant?.quantityDescription,
    );
    if (variantDescription != null) return variantDescription;

    final productDescription = cleanNullableString(product.quantityDescription);
    if (productDescription != null) return productDescription;

    if (variant != null) {
      return '${_compactNumber(variant.quantityValue)} ${variant.quantityUnit}'
          .trim();
    }

    final baseQuantity = product.baseQuantity;
    final baseUnit = cleanNullableString(product.baseUnit);
    if (baseQuantity != null && baseUnit != null) {
      return '${_compactNumber(baseQuantity)} $baseUnit'.trim();
    }

    return '';
  }

  String _compactNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  _BrowseCursor? _decodeBrowseCursor(String? token) {
    final data = decodeCursor(token);
    if (data == null) return null;

    final productId = data['productId']?.toString();
    final createdAtRaw = data['createdAt'];
    if (productId == null || createdAtRaw == null) {
      throw Exception('Invalid page token.');
    }

    return _BrowseCursor(
      productId: productId,
      createdAt: DateTime.parse(createdAtRaw.toString()),
    );
  }

  _SearchCursor? _decodeSearchCursor(
    String? token,
    String query,
  ) {
    final data = decodeCursor(token);
    if (data == null) return null;

    if (data['query']?.toString() != query) {
      throw Exception('Search page token does not match query.');
    }

    final productId = data['productId']?.toString();
    final createdAtRaw = data['createdAt'];
    final rankRaw = data['rank'];
    if (productId == null || createdAtRaw == null || rankRaw == null) {
      throw Exception('Invalid search page token.');
    }

    return _SearchCursor(
      query: query,
      rank: asDouble(rankRaw),
      createdAt: DateTime.parse(createdAtRaw.toString()),
      productId: productId,
    );
  }
}

class _BrowseCursor {
  _BrowseCursor({
    required this.productId,
    required this.createdAt,
  });

  final String productId;
  final DateTime createdAt;
}

class _SearchCursor {
  _SearchCursor({
    required this.query,
    required this.rank,
    required this.createdAt,
    required this.productId,
  });

  final String query;
  final double rank;
  final DateTime createdAt;
  final String productId;
}
