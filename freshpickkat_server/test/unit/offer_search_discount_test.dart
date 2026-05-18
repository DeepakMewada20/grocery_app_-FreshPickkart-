import 'package:freshpickkat_server/src/services/postgres/postgres_offer_search_service.dart';
import 'package:test/test.dart';

void main() {
  group('PostgresOfferSearchService discount filtering', () {
    final service = PostgresOfferSearchService();

    test('matches flat discount equivalent to 40 percent', () {
      final discount = service.calculateDiscountPercentageForTesting(
        listPrice: 50,
        salePrice: 30,
      );

      expect(discount, 40);
    });

    test('matches percentage discount equivalent to 40 percent', () {
      final discount = service.calculateDiscountPercentageForTesting(
        listPrice: 100,
        salePrice: 60,
      );

      expect(discount, 40);
    });

    test('excludes products below 40 percent', () {
      final discount = service.calculateDiscountPercentageForTesting(
        listPrice: 100,
        salePrice: 70,
      );

      expect(discount, lessThan(40));
    });

    test('includes category offer only when it improves effective price', () {
      final discount = service.calculateDiscountPercentageForTesting(
        listPrice: 50,
        salePrice: 40,
        categoryDiscountType: 'flat',
        categoryDiscountValue: 20,
      );

      expect(discount, 40);
    });
  });

  group('PostgresOfferSearchService new arrivals', () {
    test('sort by createdAt descending without updatedAt cutoff', () {
      final service = PostgresOfferSearchService();
      final orderBy = service.orderByForTesting('new_arrival');

      expect(orderBy, contains('created_at DESC'));
      expect(orderBy, isNot(contains('updatedAt')));
      expect(orderBy, isNot(contains('updated_at')));
    });
  });
}
