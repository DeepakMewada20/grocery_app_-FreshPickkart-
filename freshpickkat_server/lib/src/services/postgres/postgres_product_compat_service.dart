import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../dependency_checker.dart';
import 'postgres_catalog_service.dart';
import 'postgres_product_search_service.dart';
import 'postgres_support.dart';

class PostgresProductCompatService {
  PostgresProductCompatService({
    PostgresCatalogService? catalog,
    PostgresProductSearchService? search,
  }) : _catalog = catalog ?? PostgresCatalogService(),
       _search = search ?? PostgresProductSearchService();

  final PostgresCatalogService _catalog;
  final PostgresProductSearchService _search;
  static final Random _random = Random();

  Future<List<Product>> getProductsByIds(
    Session session,
    List<String> productIds,
  ) {
    final uniqueIds = <String>[];
    final seen = <String>{};
    for (final productId in productIds) {
      final trimmed = productId.trim();
      if (trimmed.isEmpty || !seen.add(trimmed)) continue;
      uniqueIds.add(trimmed);
    }

    return _catalog.hydrateProductsByIds(session, uniqueIds);
  }

  Future<List<Product>> getProducts(
    Session session, {
    int limit = 10,
    String? lastProductName,
    String? lastProductId,
    String? category,
    List<String>? subcategories,
    String sortBy = 'name',
    bool? freeDelivery,
  }) async {
    final pageSize = clampPageLimit(limit, defaultLimit: 10, maxLimit: 50);
    final resolvedFilters = await _resolveLegacyFilters(
      session,
      category: category,
      subcategories: subcategories,
    );
    if (resolvedFilters.noResults) return const [];

    final orderClause = switch (sortBy) {
      'trending' => 'p."trendingScore" DESC, p.id DESC',
      'best_sellers' => 'p."mostPurchaseCount" DESC, p.id DESC',
      _ => 'p.name ASC, p.id ASC',
    };

    final cursorPredicate =
        sortBy == 'name' && cleanNullableString(lastProductName) != null
        ? '''
          AND (
            p.name > @lastProductName
            OR (
              p.name = @lastProductName
              AND p.id::text > @lastProductId
            )
          )
        '''
        : '';

    final freeDeliveryPredicate = freeDelivery == true
        ? 'AND (p."isFreeDelivery" = TRUE OR c."isFreeDelivery" = TRUE)'
        : '';

    final result = await session.db.unsafeQuery(
      '''
      SELECT p.id::text AS "productId"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = 'active'
        AND c.status = 'active'
        ${resolvedFilters.whereSql}
        $freeDeliveryPredicate
        $cursorPredicate
      ORDER BY $orderClause
      LIMIT @limit
      ''',
      parameters: QueryParameters.named({
        ...resolvedFilters.parameters,
        if (lastProductName != null) ...{
          'lastProductName': lastProductName,
          'lastProductId':
              lastProductId ?? '00000000-0000-0000-0000-000000000000',
        },
        'limit': pageSize,
      }),
    );

    final productIds = result
        .map((row) => row.toColumnMap()['productId']?.toString())
        .whereType<String>()
        .toList();
    return _catalog.hydrateProductsByIds(session, productIds);
  }

  Future<ProductPage> getProductsPage(
    Session session, {
    int limit = 20,
    String? pageToken,
    String? category,
    List<String>? subcategories,
    String sortBy = 'name',
    String statusFilter = 'active',
  }) async {
    final pageSize = clampPageLimit(limit, defaultLimit: 20, maxLimit: 50);
    final cursor = decodeCursor(pageToken);
    final resolvedFilters = await _resolveLegacyFilters(
      session,
      category: category,
      subcategories: subcategories,
    );
    if (resolvedFilters.noResults) {
      return ProductPage(
        products: const [],
        nextPageToken: null,
        totalCount: 0,
      );
    }

    final orderClause = switch (sortBy) {
      'trending' => 'p."trendingScore" DESC, p.id DESC',
      'best_sellers' => 'p."mostPurchaseCount" DESC, p.id DESC',
      _ => 'p.name ASC, p.id ASC',
    };

    final cursorPredicate = _productPageCursorPredicate(sortBy);
    final totalCount = await _countProducts(
      session,
      filters: resolvedFilters,
      statusFilter: statusFilter,
    );
    final result = await session.db.unsafeQuery(
      '''
      SELECT
        p.id::text AS "productId",
        p.name AS "productName",
        p."trendingScore" AS "trendingScore",
        p."mostSearchCount" AS "mostSearchCount",
        p."mostPurchaseCount" AS "mostPurchaseCount"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = @statusFilter
        AND c.status = 'active'
        ${resolvedFilters.whereSql}
        $cursorPredicate
      ORDER BY $orderClause
      LIMIT @limit
      ''',
      parameters: QueryParameters.named({
        ...resolvedFilters.parameters,
        if (sortBy == 'trending')
          'cursorMetric': cursor == null ? null : asDouble(cursor['metric'])
        else if (sortBy == 'best_sellers')
          'cursorMetric': cursor == null ? null : asInt(cursor['metric'])
        else
          'cursorName': cursor?['name']?.toString(),
        'cursorProductId': cursor?['productId']?.toString(),
        'limit': pageSize + 1,
        'statusFilter': statusFilter,
      }),
    );

    final productIds = <String>[];
    final cursorRows = <Map<String, dynamic>>[];
    for (final row in result) {
      final map = row.toColumnMap();
      final productId = map['productId']?.toString();
      if (productId == null || productId.isEmpty) continue;

      productIds.add(productId);
      cursorRows.add({
        'productId': productId,
        'name': map['productName']?.toString(),
        'metric': sortBy == 'trending'
            ? asDouble(map['trendingScore'])
            : sortBy == 'best_sellers'
            ? asInt(map['mostPurchaseCount'])
            : null,
      });
    }

    final hasMore = productIds.length > pageSize;
    if (hasMore) {
      productIds.removeLast();
      cursorRows.removeLast();
    }

    final products = await _catalog.hydrateProductsByIds(
      session,
      productIds,
      statusFilter: statusFilter,
    );
    final nextPageToken = hasMore && cursorRows.isNotEmpty
        ? encodeCursor(cursorRows.last)
        : null;

    return ProductPage(
      products: products,
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  Future<int> getProductsCount(
    Session session, {
    String? category,
    List<String>? subcategories,
  }) async {
    final resolvedFilters = await _resolveLegacyFilters(
      session,
      category: category,
      subcategories: subcategories,
    );
    if (resolvedFilters.noResults) return 0;
    return _countProducts(session, filters: resolvedFilters);
  }

  Future<List<String>> getProductSuggestions(
    Session session,
    String query,
  ) async {
    final page = await _catalog.searchActiveProducts(
      session,
      query: query,
      limit: 10,
    );
    final names = <String>[];
    final seen = <String>{};
    for (final product in page.products) {
      if (seen.add(product.productName)) {
        names.add(product.productName);
      }
    }
    return names;
  }

  Future<List<Product>> searchProducts(
    Session session,
    String query,
  ) async {
    final page = await _catalog.searchActiveProducts(
      session,
      query: query,
      limit: 20,
    );
    return page.products;
  }

  Future<ProductPage> searchProductsPage(
    Session session, {
    required String query,
    int limit = 20,
    String? pageToken,
  }) async {
    return _catalog.searchActiveProducts(
      session,
      query: query,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<String?> uploadProduct(
    Session session,
    Product product,
  ) async {
    return session.db.transaction<String?>((transaction) async {
      final category = await _resolveCategoryByName(
        session,
        product.category,
        transaction: transaction,
      );
      if (category?.id == null) {
        throw Exception('Category not found: ${product.category}');
      }

      final now = DateTime.now().toUtc();
      final slug = await _generateUniqueProductSlug(
        session,
        product.productName,
        transaction: transaction,
      );
      final inserted = await ProductRow.db.insertRow(
        session,
        ProductRow(
          categoryId: category!.id!,
          name: product.productName.trim(),
          slug: slug,
          shortDescription: cleanNullableString(product.shortDescription),
          description: cleanNullableString(product.description),
          primaryImageUrl: cleanNullableString(product.imageUrl),
          countryOfOrigin: cleanNullableString(product.countryOfOrigin),
          baseUnit: cleanNullableString(product.baseUnit),
          baseQuantity: product.baseQuantity,
          quantityDescription:
              cleanNullableString(product.quantityDescription) ??
              cleanNullableString(product.quantity),
          stock: product.stock,
          stockUnit: cleanNullableString(product.stockUnit),
          discountType: product.discountType,
          isFreeDelivery: product.isFreeDelivery,
          mostSearchCount: product.mostSearch,
          mostPurchaseCount: product.mostPurchases,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );
      if (inserted.id == null) {
        throw Exception('Failed to create product.');
      }
      final productId = inserted.id!;

      await _replaceProductVariants(
        session,
        productId: productId,
        product: product,
        transaction: transaction,
      );
      await _replaceProductSubCategories(
        session,
        productId: productId,
        subCategoryNames: product.subcategory,
        transaction: transaction,
      );
      await _search.rebuildSearchDocument(
        session,
        productId: productId,
        transaction: transaction,
      );

      return productId.toString();
    });
  }

  Future<bool> updateProduct(
    Session session,
    Product product,
  ) async {
    final productId = parseUuid(
      product.productId ?? '',
      fieldName: 'productId',
    );

    return session.db.transaction<bool>((transaction) async {
      final existing = await ProductRow.db.findById(
        session,
        productId,
        transaction: transaction,
      );
      if (existing == null) {
        throw Exception('Product not found.');
      }

      final category = await _resolveCategoryByName(
        session,
        product.category,
        transaction: transaction,
      );
      if (category?.id == null) {
        throw Exception('Category not found: ${product.category}');
      }

      final updated = existing.copyWith(
        categoryId: category!.id!,
        name: product.productName.trim(),
        shortDescription: cleanNullableString(product.shortDescription),
        description: cleanNullableString(product.description),
        primaryImageUrl: cleanNullableString(product.imageUrl),
        countryOfOrigin: cleanNullableString(product.countryOfOrigin),
        baseUnit: cleanNullableString(product.baseUnit),
        baseQuantity: product.baseQuantity,
        quantityDescription:
            cleanNullableString(product.quantityDescription) ??
            cleanNullableString(product.quantity),
        stock: product.stock,
        stockUnit: cleanNullableString(product.stockUnit),
        discountType: product.discountType,
        isFreeDelivery: product.isFreeDelivery,
        mostSearchCount: product.mostSearch,
        mostPurchaseCount: product.mostPurchases,
        updatedAt: DateTime.now().toUtc(),
      );

      await ProductRow.db.updateRow(
        session,
        updated,
        transaction: transaction,
      );
      await _replaceProductVariants(
        session,
        productId: productId,
        product: product,
        transaction: transaction,
      );
      await _replaceProductSubCategories(
        session,
        productId: productId,
        subCategoryNames: product.subcategory,
        transaction: transaction,
      );
      await _search.rebuildSearchDocument(
        session,
        productId: productId,
        transaction: transaction,
      );

      final comboItems = await ComboOfferItemRow.db.find(
        session,
        where: (t) => t.productId.equals(productId),
        transaction: transaction,
      );
      if (comboItems.isNotEmpty) {
        final comboIds = comboItems.map((item) => item.comboOfferId).toSet();
        await ComboOfferRow.db.updateWhere(
          session,
          columnValues: (t) => [t.updatedAt(DateTime.now().toUtc())],
          where: (t) => t.id.inSet(comboIds),
          transaction: transaction,
        );
      }

      return true;
    });
  }

  Future<String> deleteProduct(
    Session session,
    String productId,
  ) async {
    final parsedProductId = parseUuid(productId, fieldName: 'productId');
    final existing = await ProductRow.db.findById(session, parsedProductId);
    if (existing == null) return 'Product not found';

    final refs = await DependencyChecker.checkProduct(session, parsedProductId);
    if (refs.isNotEmpty) {
      return DependencyChecker.formatRefs(refs);
    }

    await session.db.transaction((transaction) async {
      await ProductRow.db.updateRow(
        session,
        existing.copyWith(
          status: 'inactive',
          deactivatedAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
      await _search.rebuildSearchDocument(
        session,
        productId: parsedProductId,
        transaction: transaction,
      );
    });

    return '';
  }

  Future<bool> setProductActive(
    Session session,
    String productId,
    bool isActive,
  ) async {
    final parsedProductId = parseUuid(productId, fieldName: 'productId');
    final existing = await ProductRow.db.findById(session, parsedProductId);
    if (existing == null) return false;
    final now = DateTime.now().toUtc();
    await ProductRow.db.updateRow(
      session,
      existing.copyWith(
        status: isActive ? 'active' : 'inactive',
        deactivatedAt: isActive ? null : now,
        updatedAt: now,
      ),
    );
    return true;
  }



  Future<int> migrateProducts(Session session) async {
    return 0;
  }

  Future<int> initializeProductMetrics(Session session) async {
    return ProductRow.db.count(session);
  }

  Future<bool> incrementProductSearch(
    Session session,
    String productId,
  ) async {
    final parsedProductId = parseUuid(productId, fieldName: 'productId');
    final product = await ProductRow.db.findById(session, parsedProductId);
    if (product == null) return false;

    await ProductRow.db.updateRow(
      session,
      product.copyWith(
        mostSearchCount: product.mostSearchCount + 1,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    return true;
  }

  Future<bool> incrementProductPurchase(
    Session session,
    String productId,
  ) async {
    final parsedProductId = parseUuid(productId, fieldName: 'productId');
    final product = await ProductRow.db.findById(session, parsedProductId);
    if (product == null) return false;

    await ProductRow.db.updateRow(
      session,
      product.copyWith(
        mostPurchaseCount: product.mostPurchaseCount + 1,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    return true;
  }

  Future<int> seedProductMetricsForTesting(Session session) async {
    return ProductRow.db.count(session);
  }

  Future<int> _countProducts(
    Session session, {
    required _ResolvedProductFilters filters,
    String statusFilter = 'active',
  }) async {
    final result = await session.db.unsafeQuery(
      '''
      SELECT COUNT(*) AS "totalCount"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = @statusFilter
        AND c.status = 'active'
        ${filters.whereSql}
      ''',
      parameters: QueryParameters.named({
        ...filters.parameters,
        'statusFilter': statusFilter,
      }),
    );
    return result.isEmpty ? 0 : asInt(result.first.toColumnMap()['totalCount']);
  }

  String _productPageCursorPredicate(String sortBy) {
    return switch (sortBy) {
      'trending' =>
        '''
        AND (
          @cursorMetric::double precision IS NULL
          OR p."trendingScore" < @cursorMetric::double precision
          OR (
            p."trendingScore" = @cursorMetric::double precision
            AND p.id::text < @cursorProductId::text
          )
        )
      ''',
      'best_sellers' =>
        '''
        AND (
          @cursorMetric::integer IS NULL
          OR p."mostPurchaseCount" < @cursorMetric::integer
          OR (
            p."mostPurchaseCount" = @cursorMetric::integer
            AND p.id::text < @cursorProductId::text
          )
        )
      ''',
      _ =>
        '''
        AND (
          @cursorName::text IS NULL
          OR p.name > @cursorName::text
          OR (
            p.name = @cursorName::text
            AND p.id::text > @cursorProductId::text
          )
        )
      ''',
    };
  }

  Future<_ResolvedProductFilters> _resolveLegacyFilters(
    Session session, {
    String? category,
    List<String>? subcategories,
  }) async {
    final params = <String, Object?>{};
    final clauses = <String>[];

    final normalizedCategory = cleanNullableString(category);
    if (normalizedCategory != null) {
      final categoryRow = await _resolveCategoryByName(
        session,
        normalizedCategory,
      );
      if (categoryRow?.id == null) {
        return const _ResolvedProductFilters(noResults: true);
      }
      clauses.add('AND p."categoryId" = @categoryId::uuid');
      params['categoryId'] = categoryRow!.id.toString();
    }

    final normalizedSubcategories = (subcategories ?? const <String>[])
        .map(cleanNullableString)
        .whereType<String>()
        .toList();
    if (normalizedSubcategories.isNotEmpty) {
      final subCategoryIds = await _resolveSubCategoryIdsByNames(
        session,
        normalizedSubcategories,
      );
      if (subCategoryIds.isEmpty) {
        return const _ResolvedProductFilters(noResults: true);
      }
      clauses.add('''
        AND EXISTS (
          SELECT 1
          FROM product_sub_category psc
          JOIN sub_category sc ON sc.id = psc."subCategoryId"
          WHERE psc."productId" = p.id
            AND psc."subCategoryId" = ANY(@subCategoryIds::uuid[])
            AND sc.status = 'active'
        )
      ''');
      params['subCategoryIds'] = subCategoryIds
          .map((id) => id.toString())
          .toList();
    }

    return _ResolvedProductFilters(
      whereSql: clauses.join('\n'),
      parameters: params,
    );
  }

  Future<CategoryRow?> _resolveCategoryByName(
    Session session,
    String categoryName, {
    Transaction? transaction,
  }) async {
    final normalized = categoryName.trim().toLowerCase();
    final rows = await CategoryRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      transaction: transaction,
    );
    for (final row in rows) {
      if (row.name.trim().toLowerCase() == normalized) {
        return row;
      }
    }
    return null;
  }

  Future<List<UuidValue>> _resolveSubCategoryIdsByNames(
    Session session,
    List<String> subCategoryNames, {
    Transaction? transaction,
  }) async {
    final target = subCategoryNames
        .map((name) => name.trim().toLowerCase())
        .toSet();
    final rows = await SubCategoryRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      transaction: transaction,
    );
    // After migration, subcategory names are stored individually (no commas/ampersands).
    // We still do a fallback split check to handle any legacy data gracefully.
    return rows
        .where((row) {
          final normalizedRowName = row.name.trim().toLowerCase();
          if (target.contains(normalizedRowName)) return true;
          // Fallback: legacy grouped names that haven't been migrated yet
          final parts = normalizedRowName
              .split(RegExp(r'[,&]'))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toSet();
          return target.any((t) => parts.contains(t));
        })
        .map((row) => row.id!)
        .toList();
  }

  Future<void> _replaceProductVariants(
    Session session, {
    required UuidValue productId,
    required Product product,
    required Transaction transaction,
  }) async {
    // Fetch existing variants to synchronize
    final existingRows = await ProductVariantRow.db.find(
      session,
      where: (t) => t.productId.equals(productId),
      transaction: transaction,
    );
    final existingMap = {for (final row in existingRows) row.sku: row};
    final seenSkus = <String?>{};

    final variants = (product.variants == null || product.variants!.isEmpty)
        ? <ProductVariant>[
            ProductVariant(
              variantId: 'default',
              quantityValue: product.baseQuantity ?? 1,
              quantityUnit:
                  cleanNullableString(product.baseUnit) ??
                  cleanNullableString(product.quantity) ??
                  'unit',
              quantityDescription:
                  cleanNullableString(product.quantityDescription) ??
                  cleanNullableString(product.quantity),
              price: product.price,
              realPrice: product.realPrice,
              isAvailable: product.isAvailable,
              sortOrder: 0,
            ),
          ]
        : product.variants!;

    var index = 0;
    for (final variant in variants) {
      final sku = (() {
        final vId = cleanNullableString(variant.variantId);
        if (vId == null || vId.isEmpty || vId.toLowerCase() == 'default') {
          return '${productId.toString()}-default';
        }
        return vId;
      })();
      seenSkus.add(sku);

      final label =
          cleanNullableString(variant.quantityDescription) ??
          '${variant.quantityValue} ${variant.quantityUnit}'.trim();

      if (existingMap.containsKey(sku)) {
        // Update existing variant
        final existing = existingMap[sku]!;
        await ProductVariantRow.db.updateRow(
          session,
          existing.copyWith(
            label: label,
            quantityValue: variant.quantityValue,
            quantityUnit: variant.quantityUnit.trim(),
            quantityDescription:
                cleanNullableString(variant.quantityDescription),
            salePrice: variant.price,
            listPrice: variant.realPrice,
            isAvailable: variant.isAvailable,
            isDefault: index == 0,
            sortOrder: variant.sortOrder ?? index,
            updatedAt: DateTime.now().toUtc(),
          ),
          transaction: transaction,
        );
      } else {
        // Insert new variant
        await ProductVariantRow.db.insertRow(
          session,
          ProductVariantRow(
            productId: productId,
            label: label,
            sku: sku,
            quantityValue: variant.quantityValue,
            quantityUnit: variant.quantityUnit.trim(),
            quantityDescription:
                cleanNullableString(variant.quantityDescription),
            salePrice: variant.price,
            listPrice: variant.realPrice,
            isAvailable: variant.isAvailable,
            isDefault: index == 0,
            sortOrder: variant.sortOrder ?? index,
          ),
          transaction: transaction,
        );
      }
      index++;
    }

    // Clean up removed variants — safe pre-check before attempting delete.
    // Using try/catch here would abort the whole transaction on FK violation
    // (PostgreSQL error 25P02). Instead, we check references first.
    for (final existing in existingRows) {
      if (!seenSkus.contains(existing.sku)) {
        final variantRowId = existing.id;
        if (variantRowId == null) continue;

        final variantRefs = await DependencyChecker.checkVariant(
          session,
          variantRowId,
        );
        final referenced = variantRefs.isNotEmpty;

        if (referenced) {
          // Referenced by order_item / bogo / combo — cannot delete (ON DELETE RESTRICT).
          // Mark unavailable so it is hidden from the catalog but keeps FK integrity.
          await ProductVariantRow.db.updateRow(
            session,
            existing.copyWith(
              isAvailable: false,
              updatedAt: DateTime.now().toUtc(),
            ),
            transaction: transaction,
          );
        } else {
          // Not referenced anywhere — safe to hard-delete.
          await ProductVariantRow.db.deleteRow(
            session,
            existing,
            transaction: transaction,
          );
        }
      }
    }
  }

  Future<void> _replaceProductSubCategories(
    Session session, {
    required UuidValue productId,
    required List<String> subCategoryNames,
    required Transaction transaction,
  }) async {
    await ProductSubCategoryRow.db.deleteWhere(
      session,
      where: (t) => t.productId.equals(productId),
      transaction: transaction,
    );

    final subCategoryIds = await _resolveSubCategoryIdsByNames(
      session,
      subCategoryNames,
      transaction: transaction,
    );
    for (final subCategoryId in subCategoryIds.toSet()) {
      await ProductSubCategoryRow.db.insertRow(
        session,
        ProductSubCategoryRow(
          productId: productId,
          subCategoryId: subCategoryId,
        ),
        transaction: transaction,
      );
    }
  }



  /// Checks whether updating [product] would delete variants that are
  /// referenced by orders or offers. Returns a human-readable message listing
  /// the conflicts, or an empty string if no conflicts exist.
  Future<String> checkVariantDeletionConflicts(
    Session session,
    Product product,
  ) async {
    final productId = parseUuid(
      product.productId ?? '',
      fieldName: 'productId',
    );

    final existingRows = await ProductVariantRow.db.find(
      session,
      where: (t) => t.productId.equals(productId),
    );
    if (existingRows.isEmpty) return '';

    final seenSkus = <String?>{};
    final variants = (product.variants == null || product.variants!.isEmpty)
        ? <ProductVariant>[
            ProductVariant(
              variantId: 'default',
              quantityValue: product.baseQuantity ?? 1,
              quantityUnit:
                  cleanNullableString(product.baseUnit) ??
                  cleanNullableString(product.quantity) ??
                  'unit',
              quantityDescription:
                  cleanNullableString(product.quantityDescription) ??
                  cleanNullableString(product.quantity),
              price: product.price,
              realPrice: product.realPrice,
              isAvailable: product.isAvailable,
              sortOrder: 0,
            ),
          ]
        : product.variants!;

    for (final variant in variants) {
      final sku = (() {
        final vId = cleanNullableString(variant.variantId);
        if (vId == null || vId.isEmpty || vId.toLowerCase() == 'default') {
          return '${productId.toString()}-default';
        }
        return vId;
      })();
      seenSkus.add(sku);
    }

    final variantRefs = <String>[];
    for (final existing in existingRows) {
      if (!seenSkus.contains(existing.sku)) {
        final variantRowId = existing.id;
        if (variantRowId == null) continue;

        final variantRefs = await DependencyChecker.checkVariant(
          session,
          variantRowId,
        );
        final referenced = variantRefs.isNotEmpty;
        if (referenced) {
          variantRefs.add(existing.sku ?? 'unknown');
        }
      }
    }

    if (variantRefs.isEmpty) return '';

    return 'This product has variants (${variantRefs.join(', ')}) that are linked to existing orders or offers. These variants cannot be deleted — they will be hidden instead. Do you want to continue?';
  }

  Future<String> _generateUniqueProductSlug(
    Session session,
    String productName, {
    Transaction? transaction,
  }) async {
    final baseSlug = _slugify(productName);
    var candidate = baseSlug;
    var counter = 0;

    while (true) {
      final existing = await ProductRow.db.findFirstRow(
        session,
        where: (t) => t.slug.equals(candidate),
        transaction: transaction,
      );
      if (existing == null) return candidate;

      counter++;
      candidate = '$baseSlug-${counter + _random.nextInt(100)}';
    }
  }

  String _slugify(String value) {
    final collapsed = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-{2,}'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return collapsed.isEmpty
        ? 'product-${DateTime.now().millisecondsSinceEpoch}'
        : collapsed;
  }
}

class _ResolvedProductFilters {
  const _ResolvedProductFilters({
    this.whereSql = '',
    this.parameters = const {},
    this.noResults = false,
  });

  final String whereSql;
  final Map<String, Object?> parameters;
  final bool noResults;
}
