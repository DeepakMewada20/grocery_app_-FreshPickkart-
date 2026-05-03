import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
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
  }) async {
    final pageSize = clampPageLimit(limit, defaultLimit: 10, maxLimit: 50);
    final resolvedFilters = await _resolveLegacyFilters(
      session,
      category: category,
      subcategories: subcategories,
    );
    if (resolvedFilters.noResults) return const [];

    final orderClause = switch (sortBy) {
      'trending' => 'p."mostSearchCount" DESC, p.id DESC',
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

    final result = await session.db.unsafeQuery(
      '''
      SELECT p.id::text AS "productId"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = 'active'
        AND c.status = 'active'
        ${resolvedFilters.whereSql}
        $cursorPredicate
      ORDER BY $orderClause
      LIMIT @limit
      ''',
      parameters: QueryParameters.named({
        ...resolvedFilters.parameters,
        if (lastProductName != null) ...{
          'lastProductName': lastProductName,
          'lastProductId': lastProductId ?? '00000000-0000-0000-0000-000000000000',
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
      'trending' => 'p."mostSearchCount" DESC, p.id DESC',
      'best_sellers' => 'p."mostPurchaseCount" DESC, p.id DESC',
      _ => 'p.name ASC, p.id ASC',
    };

    final cursorPredicate = _productPageCursorPredicate(sortBy);
    final totalCount = await _countProducts(
      session,
      filters: resolvedFilters,
    );
    final result = await session.db.unsafeQuery(
      '''
      SELECT
        p.id::text AS "productId",
        p.name AS "productName",
        p."mostSearchCount" AS "mostSearchCount",
        p."mostPurchaseCount" AS "mostPurchaseCount"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = 'active'
        AND c.status = 'active'
        ${resolvedFilters.whereSql}
        $cursorPredicate
      ORDER BY $orderClause
      LIMIT @limit
      ''',
      parameters: QueryParameters.named({
        ...resolvedFilters.parameters,
        if (sortBy == 'trending' || sortBy == 'best_sellers')
          'cursorMetric': cursor == null ? null : asInt(cursor['metric'])
        else
          'cursorName': cursor?['name']?.toString(),
        'cursorProductId': cursor?['productId']?.toString(),
        'limit': pageSize + 1,
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
            ? asInt(map['mostSearchCount'])
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

    final products = await _catalog.hydrateProductsByIds(session, productIds);
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
      return true;
    });
  }

  Future<bool> deleteProduct(
    Session session,
    String productId,
  ) async {
    final parsedProductId = parseUuid(productId, fieldName: 'productId');
    return session.db.transaction<bool>((transaction) async {
      final existing = await ProductRow.db.findById(
        session,
        parsedProductId,
        transaction: transaction,
      );
      if (existing == null) return false;

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
      return true;
    });
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
  }) async {
    final result = await session.db.unsafeQuery(
      '''
      SELECT COUNT(*) AS "totalCount"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = 'active'
        AND c.status = 'active'
        ${filters.whereSql}
      ''',
      parameters: QueryParameters.named(filters.parameters),
    );
    return result.isEmpty ? 0 : asInt(result.first.toColumnMap()['totalCount']);
  }

  String _productPageCursorPredicate(String sortBy) {
    return switch (sortBy) {
      'trending' =>
        '''
        AND (
          @cursorMetric::integer IS NULL
          OR p."mostSearchCount" < @cursorMetric::integer
          OR (
            p."mostSearchCount" = @cursorMetric::integer
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
    return rows
        .where((row) => target.contains(row.name.trim().toLowerCase()))
        .map((row) => row.id!)
        .toList();
  }

  Future<void> _replaceProductVariants(
    Session session, {
    required UuidValue productId,
    required Product product,
    required Transaction transaction,
  }) async {
    await ProductVariantRow.db.deleteWhere(
      session,
      where: (t) => t.productId.equals(productId),
      transaction: transaction,
    );

    final variants = (product.variants == null || product.variants!.isEmpty)
        ? <ProductVariant>[
            ProductVariant(
              variantId:
                  'default-${DateTime.now().microsecondsSinceEpoch}-${_random.nextInt(1000)}',
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
      await ProductVariantRow.db.insertRow(
        session,
        ProductVariantRow(
          productId: productId,
          label:
              cleanNullableString(variant.quantityDescription) ??
              '${variant.quantityValue} ${variant.quantityUnit}'.trim(),
          sku: (() {
            final sku = cleanNullableString(variant.variantId);
            if (sku == null || sku.isEmpty || sku.toLowerCase() == 'default') {
              return '${productId.toString()}-default';
            }
            return sku;
          })(),
          quantityValue: variant.quantityValue,
          quantityUnit: variant.quantityUnit.trim(),
          quantityDescription: cleanNullableString(variant.quantityDescription),
          salePrice: variant.price,
          listPrice: variant.realPrice,
          isAvailable: variant.isAvailable,
          isDefault: index == 0,
          sortOrder: variant.sortOrder ?? index,
        ),
        transaction: transaction,
      );
      index++;
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
