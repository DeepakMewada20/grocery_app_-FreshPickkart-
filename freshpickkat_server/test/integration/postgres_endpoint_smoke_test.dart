import 'package:freshpickkat_server/src/generated/protocol.dart' as protocol;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('PostgreSQL endpoint smoke', (sessionBuilder, endpoints) {
    test('category endpoint reads active PostgreSQL categories', () async {
      await _seedCategory(sessionBuilder);

      final categories = await endpoints.category.getCategories(sessionBuilder);

      expect(
        categories.map((category) => category.categoryName),
        contains('Smoke Category'),
      );
      final category = categories.firstWhere(
        (category) => category.categoryName == 'Smoke Category',
      );
      expect(category.subCategory.keys, contains('Smoke Subcategory'));
    });

    test('banner endpoint creates and reads PostgreSQL banners', () async {
      final bannerId = await _seedBanner(sessionBuilder);

      final banners = await endpoints.banner.getBanners(
        sessionBuilder,
        screen: 'home_top',
        activeOnly: true,
      );

      expect(
        banners.map((banner) => banner.bannerId),
        contains(bannerId),
      );
    });

    test('coupon endpoint applies active PostgreSQL coupon', () async {
      await _seedCoupon(sessionBuilder, code: 'SMOKE10');

      final result = await endpoints.coupon.applyCoupon(
        sessionBuilder,
        '',
        'SMOKE10',
        100,
        const [],
      );

      expect(result.isValid, isTrue);
      expect(result.couponCode, equals('SMOKE10'));
      expect(result.discountAmount, equals(10));
    });

    test(
      'delivery endpoint calculates pricing from PostgreSQL engine',
      () async {
        final result = await endpoints.freeDelivery.calculateDeliveryPricing(
          sessionBuilder,
          250,
        );

        expect(result.deliveryFee, equals(20));
        expect(result.appliedRuleType, equals('slab'));
      },
    );
  });
}

Future<String> _seedBanner(TestSessionBuilder sessionBuilder) async {
  final session = sessionBuilder.build();
  try {
    final now = DateTime.now().toUtc();
    final inserted = await protocol.BannerRow.db.insertRow(
      session,
      protocol.BannerRow(
        title: 'Smoke Banner',
        imageUrl: 'https://example.com/banner.png',
        actionType: 'external_link',
        externalUrl: 'https://example.com',
        screenPlacements: 'home_top',
        priority: 1,
        startsAt: now.subtract(const Duration(days: 1)),
        endsAt: now.add(const Duration(days: 1)),
        status: 'active',
        createdAt: now,
        updatedAt: now,
      ),
    );

    return inserted.id!.toString();
  } finally {
    await session.close();
  }
}

Future<void> _seedCategory(TestSessionBuilder sessionBuilder) async {
  final session = sessionBuilder.build();
  try {
    final now = DateTime.now().toUtc();
    final suffix = now.microsecondsSinceEpoch;
    final category = await protocol.CategoryRow.db.insertRow(
      session,
      protocol.CategoryRow(
        name: 'Smoke Category',
        slug: 'smoke-category-$suffix',
        imageUrl: 'https://example.com/category.png',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await protocol.SubCategoryRow.db.insertRow(
      session,
      protocol.SubCategoryRow(
        categoryId: category.id!,
        name: 'Smoke Subcategory',
        slug: 'smoke-subcategory-$suffix',
        imageUrl: 'https://example.com/subcategory.png',
        createdAt: now,
        updatedAt: now,
      ),
    );
  } finally {
    await session.close();
  }
}

Future<void> _seedCoupon(
  TestSessionBuilder sessionBuilder, {
  required String code,
}) async {
  final session = sessionBuilder.build();
  try {
    final now = DateTime.now().toUtc();
    await protocol.CouponRow.db.insertRow(
      session,
      protocol.CouponRow(
        code: code,
        description: 'Smoke coupon',
        couponType: 'FLAT_DISCOUNT',
        discountValue: 10,
        minOrderAmount: 0,
        startsAt: now.subtract(const Duration(days: 1)),
        endsAt: now.add(const Duration(days: 1)),
        createdAt: now,
        updatedAt: now,
      ),
    );
  } finally {
    await session.close();
  }
}
