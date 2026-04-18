import 'package:flutter/material.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 9, color: color.withValues(alpha: 0.85)),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.9),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isGold = accent == const Color(0xFFD4952A);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accent.withValues(alpha: isDark ? 0.6 : 0.5),
          width: 1,
        ),
      ),
      child: Text(
        'Save ₹${amount.formatPrice}',
        style: TextStyle(
          color: isGold
              ? (isDark ? const Color(0xFFD4952A) : const Color(0xFFB87E1C))
              : accent,
          fontSize: 11,
          fontWeight: FontWeight.w700,
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFD4952A).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.star_rounded, color: Color(0xFFD4952A), size: 9),
          SizedBox(width: 3),
          Text(
            'BEST',
            style: TextStyle(
              color: Color(0xFFD4952A),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: isDark ? 0.18 : 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: accent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 3),
            Icon(Icons.arrow_forward_ios_rounded, color: accent, size: 10),
          ],
        ),
      ),
    );
  }
}
