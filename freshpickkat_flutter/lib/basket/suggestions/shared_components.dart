import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';

class SuggestionActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const SuggestionActionChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class SaveBadge extends StatelessWidget {
  final double amount;
  final Color accent;

  const SaveBadge({super.key, required this.amount, required this.accent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppSuggestionTheme>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Save ₹${amount.formatPrice}',
        style: TextStyle(
          color: accent == const Color(0xFFE6A23C) ? Colors.white : theme.ctaText,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class BestBadge extends StatelessWidget {
  const BestBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Color(0xFFE6A23C),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.star_rounded, color: Colors.white, size: 10),
    );
  }
}

class CTAButton extends StatelessWidget {
  final String label;
  final Color accent;
  final VoidCallback onTap;

  const CTAButton({
    super.key,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppSuggestionTheme>()!;
    final textCol = accent == const Color(0xFFE6A23C) ? Colors.white : theme.ctaText;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textCol,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_rounded, color: textCol, size: 13),
          ],
        ),
      ),
    );
  }
}
