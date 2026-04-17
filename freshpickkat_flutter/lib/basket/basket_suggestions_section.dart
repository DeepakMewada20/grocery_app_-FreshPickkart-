import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card.dart';
import 'package:get/get.dart';

class BasketSuggestionsSection extends StatelessWidget {
  const BasketSuggestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = CartController.instance;
      final suggestions = cart.basketSuggestions;
      final isLoading = cart.isBasketSuggestionsLoading.value;
      final oldSuggestions = cart.oldBasketSuggestions;

      if (isLoading && oldSuggestions.isEmpty) {
        return const SizedBox(
          height: 120,
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
        );
      }

      final bestSuggestion = cart.bestBasketSuggestion.value;
      final baseSuggestions = isLoading && oldSuggestions.isNotEmpty
          ? oldSuggestions.toList()
          : suggestions.toList();
      final displaySuggestions = bestSuggestion != null
          ? [
              bestSuggestion,
              ...baseSuggestions.where((s) => s.id != bestSuggestion.id),
            ]
          : baseSuggestions;

      if (displaySuggestions.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: displaySuggestions.length,
          itemBuilder: (context, i) => SuggestionCard(
            suggestion: displaySuggestions[i],
            index: i,
          ),
        ),
      );
    });
  }
}
