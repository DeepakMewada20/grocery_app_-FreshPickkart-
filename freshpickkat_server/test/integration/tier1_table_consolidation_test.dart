import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:freshpickkat_server/src/services/admin/dependency_checker.dart';
import 'package:freshpickkat_server/src/services/postgres/postgres_support.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Tier 1 table consolidation', (sessionBuilder, endpoints) {
    late String categoryId;
    late String subCategoryId;
    late String productId;
    late String suffix;

    setUp(() async {
      suffix = DateTime.now().microsecondsSinceEpoch.toString();
      final seed = await _seedCategoryAndProduct(sessionBuilder, suffix);
      categoryId = seed.categoryId;
      subCategoryId = seed.subCategoryId;
      productId = seed.productId;
    });

    test(
      'product subCategoryIds are hydrated into subcategory names',
      () async {
        final products = await endpoints.product.getProductsByIds(
          sessionBuilder,
          [productId],
        );

        expect(products.length, 1);
        expect(products.first.subcategory, isNotEmpty);
        expect(
          products.first.subcategory.first,
          contains('Test Subcat $suffix'),
        );
      },
    );

    test('browse subCategoryId filter uses subCategoryIds column', () async {
      final session = sessionBuilder.build();
      try {
        final result = await session.db.unsafeQuery(
          '''SELECT p.id::text AS "productId"
             FROM product p
             JOIN category c ON c.id = p."categoryId"
             WHERE p.status = 'active'
               AND c.status = 'active'
               AND (
                 p."subCategoryIds" IS NOT NULL
                 AND ',' || p."subCategoryIds" || ',' LIKE '%,' || @id || ',%'
               )
             LIMIT 10''',
          parameters: QueryParameters.named({'id': subCategoryId}),
        );
        final ids = result.map((r) => r.toColumnMap()['productId']?.toString());
        expect(ids, contains(productId));
      } finally {
        await session.close();
      }
    });

    test('browse by categoryId still works via endpoint', () async {
      final page = await endpoints.productPg.getActiveProductsPage(
        sessionBuilder,
        limit: 10,
        categoryId: categoryId,
      );

      expect(page.products.any((p) => p.productId == productId), isTrue);
    });

    test('raw SQL filter by subCategoryId via string_to_array works', () async {
      final session = sessionBuilder.build();
      try {
        final result = await session.db.unsafeQuery(
          '''SELECT COUNT(*) AS cnt
             FROM product p
             JOIN category c ON c.id = p."categoryId"
             WHERE p.status = 'active'
               AND c.status = 'active'
               AND @id = ANY(string_to_array(p."subCategoryIds", ','))''',
          parameters: QueryParameters.named({'id': subCategoryId}),
        );
        final count = result.isNotEmpty
            ? (result.first.toColumnMap()['cnt'] as int?) ?? 0
            : 0;
        expect(count, greaterThan(0));
      } finally {
        await session.close();
      }
    });

    test('coupon productIds column is persisted and read back', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        final coupon = await protocol.CouponRow.db.insertRow(
          session,
          protocol.CouponRow(
            code: 'SCOPE-$suffix',
            description: 'Product scope test',
            couponType: 'FLAT_DISCOUNT',
            discountValue: 10,
            minOrderAmount: 0,
            productIds: '$productId,550e8400-e29b-41d4-a716-446655440000',
            startsAt: now.subtract(const Duration(days: 1)),
            endsAt: now.add(const Duration(days: 1)),
            createdAt: now,
            updatedAt: now,
          ),
        );

        expect(coupon.id, isNotNull);

        final fetched = await protocol.CouponRow.db.findById(
          session,
          coupon.id!,
        );
        expect(fetched, isNotNull);
        expect(fetched!.productIds, contains(productId));

        // Verify it can be parsed into List<String>
        final ids = fetched.productIds!
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        expect(ids.length, 2);
        expect(ids, contains(productId));
      } finally {
        await session.close();
      }
    });

    test(
      'category offer scopeProductIds and excludeProductIds columns work',
      () async {
        final session = sessionBuilder.build();
        try {
          final now = DateTime.now().toUtc();
          final catId = tryParseUuid(categoryId)!;
          final offer = await protocol.CategoryOfferRow.db.insertRow(
            session,
            protocol.CategoryOfferRow(
              categoryId: catId,
              name: 'Cat Offer $suffix',
              description: 'Consolidation test',
              discountType: 'percentage',
              discountValue: 10,
              maxDiscountAmount: 100,
              priority: 1,
              scopeProductIds:
                  '$productId,550e8400-e29b-41d4-a716-446655440000',
              excludeProductIds: '660e8400-e29b-41d4-a716-446655440001',
              startsAt: now.subtract(const Duration(days: 1)),
              endsAt: now.add(const Duration(days: 1)),
              createdAt: now,
              updatedAt: now,
            ),
          );

          expect(offer.id, isNotNull);

          final fetched = await protocol.CategoryOfferRow.db.findById(
            session,
            offer.id!,
          );
          expect(fetched, isNotNull);
          expect(fetched!.scopeProductIds, contains(productId));
          expect(
            fetched.excludeProductIds,
            contains('660e8400-e29b-41d4-a716-446655440001'),
          );
        } finally {
          await session.close();
        }
      },
    );

    test(
      'subcategory deletion cleans up product subCategoryIds column',
      () async {
        final session = sessionBuilder.build();
        try {
          // Create a second subcategory to verify only the deleted one is removed
          const otherSubCatIdStr = '770e8400-e29b-41d4-a716-446655440002';
          final productRow = await protocol.ProductRow.db.findById(
            session,
            tryParseUuid(productId)!,
          );
          expect(productRow, isNotNull);
          // Set both subCategoryIds
          final updated = productRow!.copyWith(
            subCategoryIds: '$subCategoryId,$otherSubCatIdStr',
          );
          await protocol.ProductRow.db.updateRow(session, updated);

          // Simulate subcategory deletion cleanup
          await session.db.unsafeQuery(
            '''UPDATE product
             SET "subCategoryIds" = (
               SELECT string_agg(elem, ',')
               FROM unnest(string_to_array("subCategoryIds", ',')) AS elem
               WHERE elem != @id
             )
             WHERE "subCategoryIds" IS NOT NULL
               AND @id = ANY(string_to_array("subCategoryIds", ','))''',
            parameters: QueryParameters.named({
              'id': subCategoryId,
            }),
          );

          final refreshed = await protocol.ProductRow.db.findById(
            session,
            tryParseUuid(productId)!,
          );
          expect(refreshed, isNotNull);
          expect(refreshed!.subCategoryIds, isNot(contains(subCategoryId)));
          expect(refreshed.subCategoryIds, contains(otherSubCatIdStr));
        } finally {
          await session.close();
        }
      },
    );

    test('DependencyChecker.checkProduct finds coupon reference', () async {
      final session = sessionBuilder.build();
      try {
        final now = DateTime.now().toUtc();
        await protocol.CouponRow.db.insertRow(
          session,
          protocol.CouponRow(
            code: 'DEPCHECK-$suffix',
            description: 'Dependency check test',
            couponType: 'FLAT_DISCOUNT',
            discountValue: 10,
            minOrderAmount: 0,
            productIds: productId,
            startsAt: now.subtract(const Duration(days: 1)),
            endsAt: now.add(const Duration(days: 1)),
            createdAt: now,
            updatedAt: now,
          ),
        );

        final pid = tryParseUuid(productId)!;
        final refs = await DependencyChecker.checkProduct(session, pid);

        expect(refs.any((r) => r.contains('coupon')), isTrue);
      } finally {
        await session.close();
      }
    });

    test(
      'DependencyChecker.checkProduct finds category offer reference',
      () async {
        final session = sessionBuilder.build();
        try {
          final now = DateTime.now().toUtc();
          final catId = tryParseUuid(categoryId)!;
          await protocol.CategoryOfferRow.db.insertRow(
            session,
            protocol.CategoryOfferRow(
              categoryId: catId,
              name: 'Dep Check Offer $suffix',
              description: 'Category offer dep check',
              discountType: 'percentage',
              discountValue: 15,
              priority: 1,
              scopeProductIds: productId,
              startsAt: now.subtract(const Duration(days: 1)),
              endsAt: now.add(const Duration(days: 1)),
              createdAt: now,
              updatedAt: now,
            ),
          );

          final pid = tryParseUuid(productId)!;
          final refs = await DependencyChecker.checkProduct(session, pid);

          expect(refs.any((r) => r.contains('category offer scope')), isTrue);
        } finally {
          await session.close();
        }
      },
    );
  });
}

Future<_CategoryProductSeed> _seedCategoryAndProduct(
  TestSessionBuilder sessionBuilder,
  String suffix,
) async {
  final session = sessionBuilder.build();
  try {
    final now = DateTime.now().toUtc();
    final category = await protocol.CategoryRow.db.insertRow(
      session,
      protocol.CategoryRow(
        name: 'Test Category $suffix',
        slug: 'test-category-$suffix',
        imageUrl: 'https://example.com/cat.png',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final subCategory = await protocol.SubCategoryRow.db.insertRow(
      session,
      protocol.SubCategoryRow(
        categoryId: category.id!,
        name: 'Test Subcat $suffix',
        slug: 'test-subcat-$suffix',
        imageUrl: 'https://example.com/subcat.png',
        createdAt: now,
        updatedAt: now,
      ),
    );

    final product = await protocol.ProductRow.db.insertRow(
      session,
      protocol.ProductRow(
        categoryId: category.id!,
        name: 'Test Product $suffix',
        slug: 'test-product-$suffix',
        primaryImageUrl: 'https://example.com/prod.png',
        isFreeDelivery: false,
        subCategoryIds: subCategory.id!.toString(),
        createdAt: now,
        updatedAt: now,
      ),
    );

    return _CategoryProductSeed(
      categoryId: category.id!.toString(),
      subCategoryId: subCategory.id!.toString(),
      productId: product.id!.toString(),
    );
  } finally {
    await session.close();
  }
}

class _CategoryProductSeed {
  final String categoryId;
  final String subCategoryId;
  final String productId;
  const _CategoryProductSeed({
    required this.categoryId,
    required this.subCategoryId,
    required this.productId,
  });
}
