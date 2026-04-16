import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card_base.dart';
import 'package:freshpickkat_flutter/basket/suggestions/single_card.dart';
import 'package:freshpickkat_flutter/basket/suggestions/combined_card.dart';
import 'package:freshpickkat_flutter/utils/suggestion_navigation_helper.dart';

class SuggestionCard extends StatelessWidget {
  final client.BasketSuggestion suggestion;
  final int index;
  final double? width;

  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.index,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final s = suggestion;
    final isBest = s.isBest ?? false;
    final suggestionTheme = Theme.of(context).extension<AppSuggestionTheme>()!;
    final accent = isBest ? const Color(0xFFE6A23C) : suggestionTheme.ctaBackground;

    return SuggestionCardBase(
      suggestion: s,
      index: index,
      width: width,
      onTap: () => SuggestionNavigationHelper.handleTap(s),
      child: _buildBody(s, accent),
    );
  }

  Widget _buildBody(client.BasketSuggestion s, Color accent) {
    if (s.type == 'combined') {
      return CombinedCardBody(s: s, accent: accent);
    }
    return SingleCardBody(s: s, accent: accent);
  }
}
