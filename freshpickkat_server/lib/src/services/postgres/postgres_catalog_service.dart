import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../effective_offer_resolver.dart';
import '../featured_variant_resolver.dart';
import 'postgres_support.dart';

class PostgresCatalogService {
  static const int _defaultLimit = 20;
  static const int _maxLimit = 50;

  Future<List<String>> getActiveProductIds(
    Session session, {
    int limit = _defaultLimit,
  }) async {
    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultLimit,
      maxLimit: _maxLimit,
    );

    final result = await session.db.unsafeQuery(
      '''
      SELECT p.id::text AS "productId"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = 'active'
        AND c.status = 'active'
      ORDER BY p."createdAt" DESC, p.id DESC
      LIMIT @limit
      ''',
      parameters: QueryParameters.named({'limit': pageSize}),
    );

    return result
        .map((row) => row.toColumnMap()['productId']?.toString())
        .where((id) => id != null && id.isNotEmpty)
        .cast<String>()
        .toList();
  }

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
      categoryId: categoryId,
      subCategoryId: subCategoryId,
    );

    final catIdStr = categoryId?.toString();
    final subCatIdStr = subCategoryId?.toString();
    final result = await session.db.unsafeQuery(
      '''
      SELECT
        p.id::text AS "productId",
        p."createdAt" AS "createdAt"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = 'active'
        AND c.status = 'active'
        AND (@categoryId:text IS NULL OR p."categoryId"::text = @categoryId:text)
        AND (
          @subCategoryId:text IS NULL OR EXISTS (
            SELECT 1
            FROM sub_category sc
            WHERE sc.id::text = @subCategoryId:text
              AND sc.status = 'active'
              AND @subCategoryId:text = ANY(
                string_to_array(p."subCategoryIds", ',')
              )
          )
        )
        AND (
          @cursorCreatedAt:timestamp IS NULL
          OR p."createdAt" < @cursorCreatedAt:timestamp
          OR (
            p."createdAt" = @cursorCreatedAt:timestamp
            AND p.id::text < @cursorProductId:text
          )
        )
      ORDER BY p."createdAt" DESC, p.id DESC
      LIMIT @limit:int4
      ''',
      parameters: QueryParameters.named({
        'categoryId': catIdStr,
        'subCategoryId': subCatIdStr,
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
      products: flattenToVariantProducts(products),
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
    double similarityThreshold = 0.05,
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
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      similarityThreshold: threshold,
    );

    final catIdStr = categoryId?.toString();
    final subCatIdStr = subCategoryId?.toString();
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
          AND similarity(psd."searchText", @query) > @threshold:float8
          AND (@categoryId:text IS NULL OR p."categoryId"::text = @categoryId:text)
          AND (
            @subCategoryId:text IS NULL OR EXISTS (
              SELECT 1
              FROM sub_category sc
              WHERE sc.id::text = @subCategoryId:text
                AND sc.status = 'active'
                AND @subCategoryId:text = ANY(
                  string_to_array(p."subCategoryIds", ',')
                )
            )
          )
      )
      SELECT
        "productId",
        "rank",
        "sourceCreatedAt"
      FROM ranked
      WHERE (
        @cursorRank:float8 IS NULL
        OR "rank" < @cursorRank:float8
        OR (
          "rank" = @cursorRank:float8
          AND (
            "sourceCreatedAt" < @cursorCreatedAt:timestamp
            OR (
              "sourceCreatedAt" = @cursorCreatedAt:timestamp
              AND "productId" < @cursorProductId:text
            )
          )
        )
      )
      ORDER BY "rank" DESC, "sourceCreatedAt" DESC, "productId" DESC
      LIMIT @limit:int4
      ''',
      parameters: QueryParameters.named({
        'query': normalizedQuery,
        'threshold': threshold,
        'categoryId': catIdStr,
        'subCategoryId': subCatIdStr,
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
      products: flattenToVariantProducts(products),
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  Future<int> _countBrowseProducts(
    Session session, {
    required String? categoryId,
    required String? subCategoryId,
  }) async {
    String query;
    Map<String, Object?> params;

    if (categoryId != null && subCategoryId != null) {
      query = "SELECT COUNT(*) AS \"totalCount\""
          " FROM product p"
          " JOIN category c ON c.id = p.\"categoryId\""
          " WHERE p.status = 'active'"
          "  AND c.status = 'active'"
          "  AND p.\"categoryId\"::text = @categoryId"
          "  AND p.\"subCategoryIds\" IS NOT NULL"
          "  AND ',' || p.\"subCategoryIds\" || ',' LIKE '%,' || @subCategoryId || ',%'";
      params = {'categoryId': categoryId, 'subCategoryId': subCategoryId};
    } else if (categoryId != null) {
      query = "SELECT COUNT(*) AS \"totalCount\""
          " FROM product p"
          " JOIN category c ON c.id = p.\"categoryId\""
          " WHERE p.status = 'active'"
          "  AND c.status = 'active'"
          "  AND p.\"categoryId\"::text = @categoryId";
      params = {'categoryId': categoryId};
    } else if (subCategoryId != null) {
      query = "SELECT COUNT(*) AS \"totalCount\""
          " FROM product p"
          " JOIN category c ON c.id = p.\"categoryId\""
          " WHERE p.status = 'active'"
          "  AND c.status = 'active'"
          "  AND p.\"subCategoryIds\" IS NOT NULL"
          "  AND ',' || p.\"subCategoryIds\" || ',' LIKE '%,' || @subCategoryId || ',%'";
      params = {'subCategoryId': subCategoryId};
    } else {
      query = "SELECT COUNT(*) AS \"totalCount\""
          " FROM product p"
          " JOIN category c ON c.id = p.\"categoryId\""
          " WHERE p.status = 'active'"
          "  AND c.status = 'active'";
      params = {};
    }

    final result = await session.db.unsafeQuery(
      query,
      parameters: QueryParameters.named(params),
    );

    if (result.isEmpty) return 0;
    return asInt(result.first.toColumnMap()['totalCount']);
  }

  Future<int> _countSearchProducts(
    Session session, {
    required String query,
    required String? categoryId,
    required String? subCategoryId,
    required double similarityThreshold,
  }) async {
    String sql;
    Map<String, Object?> params;

    final baseQuery = "SELECT COUNT(*) AS \"totalCount\""
        " FROM product_search_document psd"
        " JOIN product p ON p.id = psd.\"productId\""
        " JOIN category c ON c.id = p.\"categoryId\""
        " WHERE p.status = 'active'"
        "  AND c.status = 'active'"
        "  AND psd.\"searchText\" ILIKE '%' || @query || '%'"
        "  AND similarity(psd.\"searchText\", @query) > @threshold::float8";

    if (categoryId != null && subCategoryId != null) {
      sql = "$baseQuery"
          " AND p.\"categoryId\"::text = @categoryId"
          " AND p.\"subCategoryIds\" IS NOT NULL"
          " AND @subCategoryId = ANY(string_to_array(p.\"subCategoryIds\", ','))";
      params = {
        'query': query,
        'threshold': similarityThreshold,
        'categoryId': categoryId,
        'subCategoryId': subCategoryId,
      };
    } else if (categoryId != null) {
      sql = "$baseQuery AND p.\"categoryId\"::text = @categoryId";
      params = {
        'query': query,
        'threshold': similarityThreshold,
        'categoryId': categoryId,
      };
    } else if (subCategoryId != null) {
      sql = "$baseQuery"
          " AND p.\"subCategoryIds\" IS NOT NULL"
          " AND @subCategoryId = ANY(string_to_array(p.\"subCategoryIds\", ','))";
      params = {
        'query': query,
        'threshold': similarityThreshold,
        'subCategoryId': subCategoryId,
      };
    } else {
      sql = baseQuery;
      params = {
        'query': query,
        'threshold': similarityThreshold,
      };
    }

    final result = await session.db.unsafeQuery(
      sql,
      parameters: QueryParameters.named(params),
    );

    if (result.isEmpty) return 0;
    return asInt(result.first.toColumnMap()['totalCount']);
  }

  Future<List<Product>> hydrateProductsByIds(
    Session session,
    List<String> orderedProductIds, {
    String statusFilter = 'active',
  }) async {
    if (orderedProductIds.isEmpty) return const [];

    final productIds = orderedProductIds
        .map((id) => tryParseUuid(id))
        .whereType<UuidValue>()
        .toSet();

    var products = await ProductRow.db.find(
      session,
      where: (t) => t.id.inSet(productIds) & t.status.equals(statusFilter),
    );

    // --- Batch 1: Independent queries ---
    final batch1 = await Future.wait([
      Future.value(products),
      ProductVariantRow.db.find(
        session,
        where: (t) =>
            t.productId.inSet(productIds) & t.status.equals('active'),
      ),
      BogoOfferRow.db.find(
        session,
        where: (t) =>
            t.triggerProductId.inSet(productIds) & t.status.equals('active'),
      ),
      ComboOfferItemRow.db.find(
        session,
        where: (t) => t.productId.inSet(productIds),
      ),
    ] as List<Future<dynamic>>);

    products = batch1[0] as List<ProductRow>;
    final variants = batch1[1] as List<ProductVariantRow>;
    final bogoOfferRows = batch1[2] as List<BogoOfferRow>;
    final comboItemRows = batch1[3] as List<ComboOfferItemRow>;

    final productById = {
      for (final product in products) product.id!.toString(): product,
    };

    final variantsByProduct = <String, List<ProductVariantRow>>{};
    for (final variant in variants) {
      variantsByProduct
          .putIfAbsent(variant.productId.toString(), () => [])
          .add(variant);
    }

    final now = DateTime.now().toUtc();
    final activeBogoOfferRows = bogoOfferRows.where(
      (row) => !now.isBefore(row.startsAt) && !now.isAfter(row.endsAt),
    ).toList();
    final activeBogoOfferIds = activeBogoOfferRows
        .map((row) => row.id!)
        .toSet();

    final subCategoryIds = products
        .map((p) => p.subCategoryIds)
        .whereType<String>()
        .expand((s) => s.split(',').map((id) => tryParseUuid(id.trim())).whereType<UuidValue>())
        .toSet();
    final categoryIds = products.map((product) => product.categoryId).toSet();
    final comboOfferIdSet = comboItemRows.map((r) => r.comboOfferId).toSet();

    // --- Batch 2: Dependent queries ---
    final batch2 = await Future.wait([
      subCategoryIds.isEmpty
          ? Future.value(<SubCategoryRow>[])
          : SubCategoryRow.db.find(
              session,
              where: (t) =>
                  t.id.inSet(subCategoryIds) & t.status.equals('active'),
            ),
      CategoryRow.db.find(
        session,
        where: (t) => t.id.inSet(categoryIds) & t.status.equals('active'),
      ),
      activeBogoOfferIds.isEmpty
          ? Future.value(<BogoOfferRewardRow>[])
          : BogoOfferRewardRow.db.find(
              session,
              where: (t) => t.bogoOfferId.inSet(activeBogoOfferIds),
            ),
      CategoryOfferRow.db.find(
        session,
        where: (t) =>
            t.categoryId.inSet(categoryIds) & t.status.equals('active'),
      ),
      comboOfferIdSet.isEmpty
          ? Future.value(<ComboOfferRow>[])
          : ComboOfferRow.db.find(
              session,
              where: (t) =>
                  t.id.inSet(comboOfferIdSet) & t.status.equals('active'),
            ),
    ] as List<Future<dynamic>>);

    final subCategories = batch2[0] as List<SubCategoryRow>;
    final categories = batch2[1] as List<CategoryRow>;
    final bogoRewardRows = batch2[2] as List<BogoOfferRewardRow>;
    final categoryOfferRows = batch2[3] as List<CategoryOfferRow>;
    final activeComboOfferRows = batch2[4] as List<ComboOfferRow>;

    // Build variant-level BOGO maps (depends on bogoRewardRows from batch 2)
    final bogoByVariant = <String, Map<String, Set<String>>>{};
    final bogoByProductOnly = <String, Set<String>>{};
    for (final bogoOffer in activeBogoOfferRows) {
      final triggerProductId = bogoOffer.triggerProductId.toString();
      final triggerVariantIdStr = bogoOffer.triggerVariantId?.toString();
      for (final reward in bogoRewardRows) {
        if (reward.bogoOfferId != bogoOffer.id) continue;
        final rewardProductId = reward.rewardProductId.toString();
        if (triggerVariantIdStr != null && triggerVariantIdStr.isNotEmpty) {
          bogoByVariant
              .putIfAbsent(triggerProductId, () => {})
              .putIfAbsent(triggerVariantIdStr, () => <String>{})
              .add(rewardProductId);
        } else {
          bogoByProductOnly
              .putIfAbsent(triggerProductId, () => <String>{})
              .add(rewardProductId);
        }
      }
    }

    final subCategoryById = {
      for (final subCategory in subCategories)
        subCategory.id!.toString(): subCategory,
    };
    final subCategoryNamesByProduct = <String, List<String>>{};
    for (final product in products) {
      final ids = product.subCategoryIds;
      if (ids == null || ids.isEmpty) continue;
      final names = <String>[];
      for (final idStr in ids.split(',')) {
        final trimmed = idStr.trim();
        if (trimmed.isEmpty) continue;
        final subCategory = subCategoryById[trimmed];
        if (subCategory != null) {
          names.add(subCategory.name);
        }
      }
      if (names.isNotEmpty) {
        subCategoryNamesByProduct[product.id!.toString()] = names;
      }
    }

    final categoryById = {
      for (final category in categories) category.id!.toString(): category,
    };

    final bogoRewardsByProduct = <String, Set<String>>{};
    for (final entry in bogoByProductOnly.entries) {
      bogoRewardsByProduct[entry.key] = entry.value;
    }
    // For variant-level BOGO, also add to product-level aggregate
    // (so product-level field still reflects that BOGO exists for some variant)
    for (final entry in bogoByVariant.entries) {
      final allVariantsBogo = <String>{};
      for (final variantEntry in entry.value.entries) {
        allVariantsBogo.addAll(variantEntry.value);
      }
      if (allVariantsBogo.isNotEmpty) {
        bogoRewardsByProduct
            .putIfAbsent(entry.key, () => <String>{})
            .addAll(allVariantsBogo);
      }
    }

    final activeCategoryOffers = categoryOfferRows.where(
      (row) => !now.isBefore(row.startsAt) && !now.isAfter(row.endsAt),
    ).toList();
    activeCategoryOffers.sort((a, b) => b.priority.compareTo(a.priority));
    final categoryOfferByCategory = {
      for (final o in activeCategoryOffers)
        o.categoryId.toString(): o,
    };

    final activeComboOffers = activeComboOfferRows.where(
      (row) => !now.isBefore(row.startsAt) && !now.isAfter(row.endsAt),
    ).toList();
    final activeComboOfferIds =
        activeComboOffers.map((r) => r.id!.toString()).toSet();
    final comboByProduct = <String, List<String>>{};
    // Variant-level combo tracking: productId -> {variantId -> [comboOfferId]}
    final comboByVariant = <String, Map<String, List<String>>>{};
    for (final item in comboItemRows) {
      final comboOfferId = item.comboOfferId.toString();
      if (!activeComboOfferIds.contains(comboOfferId)) continue;
      final productId = item.productId.toString();
      final variantIdStr = item.productVariantId?.toString();
      if (variantIdStr != null && variantIdStr.isNotEmpty) {
        comboByVariant
            .putIfAbsent(productId, () => {})
            .putIfAbsent(variantIdStr, () => [])
            .add(comboOfferId);
      } else {
        comboByProduct.putIfAbsent(productId, () => []).add(comboOfferId);
      }
    }
    for (final list in comboByProduct.values) {
      list.sort();
    }
    for (final map in comboByVariant.values) {
      for (final list in map.values) {
        list.sort();
      }
    }

    final hydrated = <Product>[];
    for (final productId in orderedProductIds) {
      final productRow = productById[productId];
      if (productRow == null) continue;

      final category = categoryById[productRow.categoryId.toString()];
      if (category == null) continue;

      final variantRows =
          variantsByProduct[productId] ?? <ProductVariantRow>[];
      variantRows.sort((a, b) {
        if (a.isDefault != b.isDefault) return b.isDefault ? 1 : -1;
        final sortOrderCompare = a.sortOrder.compareTo(b.sortOrder);
        if (sortOrderCompare != 0) return sortOrderCompare;
        return a.label.compareTo(b.label);
      });

      // Build free delivery sources for inheritance
      final defaultForFD = variantRows.cast<ProductVariantRow?>().firstWhere(
        (v) => v != null && v.isDefault,
        orElse: () => variantRows.cast<ProductVariantRow?>().firstWhere(
          (v) => v != null && v.isAvailable,
          orElse: () => variantRows.isEmpty ? null : variantRows.first,
        ),
      );
      final freeDeliverySources = <ProductVariantRow>[
        for (final v in variantRows)
          if (v.isFreeDelivery) v,
        if (productRow.isFreeDelivery && defaultForFD != null)
          defaultForFD,
      ];

      final mappedVariants = variantRows
          .map(
            (variant) {
              final variantIdStr = variant.id!.toString();
              // Variant-level BOGO: check variant-specific first, then product-level
              final variantBogo =
                  bogoByVariant[productId]?[variantIdStr]?.toList()?..sort();
              final productBogo =
                  bogoByProductOnly[productId]?.toList()?..sort();
              // Product-level BOGO applies only to the default variant
              final resolvedBogo = variantBogo?.isNotEmpty == true
                  ? variantBogo
                  : (productBogo?.isNotEmpty == true &&
                          variant.id == defaultForFD?.id)
                      ? productBogo
                      : null;
              // Variant-level combo: check variant-specific first, then product-level
              final variantCombo = comboByVariant[productId]?[variantIdStr];
              final resolvedCombo = variantCombo?.isNotEmpty == true
                  ? variantCombo
                  : comboByProduct[productId]?.isNotEmpty == true
                      ? comboByProduct[productId]
                      : null;
              return ProductVariant(
                variantId: variantIdStr,
                quantityValue: variant.quantityValue,
                quantityUnit: variant.quantityUnit,
                quantityDescription: variant.quantityDescription,
                price: variant.salePrice,
                realPrice: variant.listPrice,
                isAvailable: variant.isAvailable && variant.status == 'active',
                sortOrder: variant.sortOrder,
                bogoFreeProductIds:
                    resolvedBogo?.isEmpty == true ? null : resolvedBogo,
                comboOfferIds:
                    resolvedCombo?.isEmpty == true ? null : resolvedCombo,
                isFreeDelivery: EffectiveOfferResolver.effectiveFreeDelivery(
                  quantityValue: variant.quantityValue,
                  quantityUnit: variant.quantityUnit,
                  freeDeliverySources: freeDeliverySources,),
              );
            },
          )
          .toList();

      final defaultVariant = variantRows.cast<ProductVariantRow?>().firstWhere(
        (variant) => variant != null && variant.isDefault,
        orElse: () => variantRows.cast<ProductVariantRow?>().firstWhere(
          (variant) => variant != null && variant.isAvailable,
          orElse: () => variantRows.isEmpty ? null : variantRows.first,
        ),
      );

      double salePrice = defaultVariant?.salePrice ?? 0.0;
      final listPrice = defaultVariant?.listPrice ?? salePrice;
      String? resolvedDiscountType = productRow.discountType;
      double? resolvedDiscountValue;

      // 1. Check for Category Offer first
      final applicableCategoryOffer = categoryOfferByCategory[productRow.categoryId.toString()];
      if (applicableCategoryOffer != null) {
        double categoryOfferPrice = salePrice;
        if (applicableCategoryOffer.discountType == 'percentage') {
          categoryOfferPrice = listPrice * (1 - (applicableCategoryOffer.discountValue / 100));
        } else if (applicableCategoryOffer.discountType == 'flat') {
          categoryOfferPrice = listPrice - applicableCategoryOffer.discountValue;
        }

        // Use the lower price but keep the product's own discount type/value
        if (categoryOfferPrice < salePrice) {
          salePrice = categoryOfferPrice;
        }
      }

      // 2. Check for BOGO (Dominant for display)
      final bogoFreeProductIds = bogoRewardsByProduct[productId]?.toList()
        ?..sort();
      
      if (bogoFreeProductIds != null && bogoFreeProductIds.isNotEmpty) {
        resolvedDiscountType = 'bogo';
      }

      final flatDiscount = listPrice > salePrice ? listPrice - salePrice : 0.0;
      final discountPercent = listPrice > 0 && flatDiscount > 0
          ? (flatDiscount / listPrice) * 100
          : 0.0;

      final resolvedDiscountValueFinal = resolvedDiscountValue ??
          (resolvedDiscountType == 'percentage'
              ? double.parse(discountPercent.toStringAsFixed(2))
              : flatDiscount > 0
                  ? double.parse(flatDiscount.toStringAsFixed(2))
                  : null);

      hydrated.add(
        Product(
          productId: productRow.id!.toString(),
          variantId: defaultVariant?.id?.toString(),
          productName: productRow.name,
          category: category.name,
          shortDescription: productRow.shortDescription,
          description: productRow.description,
          imageUrl: productRow.primaryImageUrl ?? '',
          price: salePrice,
          realPrice: listPrice,
          discount: double.parse(discountPercent.toStringAsFixed(2)),
          discountType: resolvedDiscountType,
          discountValue: resolvedDiscountValueFinal,
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
          isFreeDelivery: productRow.isFreeDelivery,
          bogoFreeProductIds: bogoFreeProductIds?.isEmpty == true
              ? null
              : bogoFreeProductIds,
          comboOfferIds: (comboByProduct[productId]?.isEmpty == true)
              ? null
              : comboByProduct[productId],
          hasCategoryOffer:
              categoryOfferByCategory.containsKey(productRow.categoryId.toString()),
          variants: mappedVariants.isEmpty ? null : mappedVariants,
        ),
      );
    }

    return hydrated;
  }

  List<Product> flattenToVariantProducts(
    List<Product> products, {
    bool onlyDefaultVariant = false,
    bool useFeaturedVariant = false,
  }) {
    if (products.isEmpty) return const [];

    final result = <Product>[];
    for (final product in products) {
      final variants = product.variants ?? [];
      if (variants.isEmpty) {
        result.add(product.copyWith(variants: []));
        continue;
      }

      List<ProductVariant> targetVariants;
      if (useFeaturedVariant) {
        targetVariants = [FeaturedVariantResolver.resolve(variants)];
      } else if (onlyDefaultVariant) {
        targetVariants = variants.take(1).toList();
      } else {
        targetVariants = variants;
      }

      for (final variant in targetVariants) {
        final quantityDesc = variant.quantityDescription;
        final quantityLabel = quantityDesc != null && quantityDesc.isNotEmpty
            ? quantityDesc
            : '${_compactNumber(variant.quantityValue)} ${variant.quantityUnit}'
                .trim();

        result.add(
          product.copyWith(
            variantId: variant.variantId,
            price: variant.price,
            realPrice: variant.realPrice,
            quantity: quantityLabel,
            baseQuantity: variant.quantityValue,
            baseUnit: variant.quantityUnit,
            quantityDescription: variant.quantityDescription,
            isAvailable: variant.isAvailable,
            discount: product.realPrice > 0 && product.realPrice > variant.price
                ? double.parse(
                    (((product.realPrice - variant.price) / product.realPrice) * 100)
                        .toStringAsFixed(2),
                  )
                : 0.0,
            variants: product.variants,
            bogoFreeProductIds: variant.bogoFreeProductIds,
            isFreeDelivery: variant.isFreeDelivery,
            comboOfferIds: variant.comboOfferIds,
          ),
        );
      }
    }
    return result;
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
