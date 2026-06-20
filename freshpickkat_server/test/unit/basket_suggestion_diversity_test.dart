import 'package:freshpickkat_server/src/services/basket_suggestions/basket_suggestion_service.dart';
import 'package:test/test.dart';

void main() {
  group('BasketSuggestionService Diversity and Finalization Tests', () {
    test('returns exactly 6 suggestions when enough are available', () {
      final pool = [
        {'type': 'bogo', 'score': 100},
        {'type': 'bogo', 'score': 90},
        {'type': 'bogo', 'score': 80},
        {'type': 'bogo', 'score': 70},
        {'type': 'combo', 'score': 60},
        {'type': 'variant', 'score': 50},
        {'type': 'reorder', 'score': 40},
      ];

      final result = BasketSuggestionService.testFinalizeResults(items: pool);

      expect(result.suggestions.length, equals(6));
      expect(result.bestSuggestion, isNotNull);
      expect(result.otherSuggestions?.length, equals(5));
    });

    test('prioritizes diversity of offers (no single type dominates)', () {
      // 5 BOGO offers and 1 Combo offer.
      // Without diversity, the 5 BOGOs would dominate (scores 100 to 60) and combo (score 50) might be excluded or lower ranked.
      // Under our new round-robin logic, the first pass selects:
      // BOGO-1 (score 100), Combo-1 (score 50).
      // The second pass selects the remaining BOGOs.
      final pool = [
        {'type': 'bogo', 'score': 100},
        {'type': 'bogo', 'score': 90},
        {'type': 'bogo', 'score': 80},
        {'type': 'bogo', 'score': 70},
        {'type': 'bogo', 'score': 60},
        {'type': 'combo', 'score': 50},
      ];

      final result = BasketSuggestionService.testFinalizeResults(items: pool);

      expect(result.suggestions.length, equals(6));

      // Verify that the combo suggestion is included in the output!
      final hasCombo = result.suggestions.any((s) => s.type == 'combo');
      expect(hasCombo, isTrue);

      // Verify categories of returned suggestions
      final bogoCount = result.suggestions
          .where((s) => s.type == 'bogo')
          .length;
      final comboCount = result.suggestions
          .where((s) => s.type == 'combo')
          .length;
      expect(bogoCount, equals(5));
      expect(comboCount, equals(1));
    });

    test('correctly handles free delivery product action label', () {
      final pool = [
        {'type': 'product', 'actionLabel': 'FREE DELIVERY', 'score': 100},
        {'type': 'product', 'actionLabel': 'FREE DELIVERY', 'score': 90},
        {'type': 'product', 'actionLabel': 'FREE DELIVERY', 'score': 80},
        {'type': 'product', 'score': 70}, // regular product
        {'type': 'bogo', 'score': 60},
        {'type': 'combo', 'score': 50},
      ];

      final result = BasketSuggestionService.testFinalizeResults(items: pool);

      // We should get a diverse set of suggestions:
      // 1 free delivery product (score 100), 1 regular product (score 70), 1 bogo (score 60), 1 combo (score 50)
      // Then the remaining free delivery products (score 90, 80)
      expect(result.suggestions.length, equals(6));

      final freeDeliveryCount = result.suggestions
          .where(
            (s) => s.type == 'product' && s.action?.label == 'FREE DELIVERY',
          )
          .length;
      final regularProductCount = result.suggestions
          .where(
            (s) => s.type == 'product' && s.action?.label != 'FREE DELIVERY',
          )
          .length;
      final bogoCount = result.suggestions
          .where((s) => s.type == 'bogo')
          .length;
      final comboCount = result.suggestions
          .where((s) => s.type == 'combo')
          .length;

      expect(freeDeliveryCount, equals(3));
      expect(regularProductCount, equals(1));
      expect(bogoCount, equals(1));
      expect(comboCount, equals(1));
    });
  });
}
