import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/widgets/suggestions/suggestion_card.dart';
import 'package:get/get.dart';

class BasketSuggestionsSection extends StatelessWidget {
  const BasketSuggestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cart = CartController.instance;
      final suggestions = cart.basketSuggestions;

      if (cart.isBasketSuggestionsLoading.value) {
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

      if (suggestions.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: suggestions.length,
          itemBuilder: (context, i) => SuggestionCard(
            suggestion: suggestions[i],
            index: i,
          ),
        ),
      );
    });
  }
}
