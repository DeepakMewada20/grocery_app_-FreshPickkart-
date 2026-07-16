import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card.dart';
import 'package:freshpickkat_flutter/widgets/basket_loading_animation.dart';
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
        return const SuggestionSkeletonSection();
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
        height: AppResponsive.isWideWeb(context)
            ? 220.0
            : 180.h.clamp(166.0, 210.0).toDouble(),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
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
