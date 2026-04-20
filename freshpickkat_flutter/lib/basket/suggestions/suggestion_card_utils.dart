import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';

class SuggestionProgressBar extends StatelessWidget {
  final double current;
  final double target;
  final Color accent;

  const SuggestionProgressBar({
    super.key,
    required this.current,
    required this.target,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    if (target <= 0) return const SizedBox.shrink();
    
    final progress = (current / target).clamp(0.0, 1.0);
    final remaining = (target - current).clamp(0, double.infinity).toInt();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (remaining > 0)
              Flexible(
                child: Text(
                  '₹$remaining more',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: cs.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              Text(
                'Unlocked',
                style: TextStyle(
                  fontSize: 10.5,
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        // Custom gradient progress bar
        LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth;
            return Container(
              height: 4,
              width: barWidth,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: value,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              accent.withValues(alpha: 0.5),
                              accent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}


class OverlappingThumbs extends StatelessWidget {
  final List<String> imageUrls;
  final double size;

  const OverlappingThumbs({
    super.key,
    required this.imageUrls,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox.shrink();
    
    // Take up to 4 images for a richer look if available
    final displayImages = imageUrls.take(4).toList();
    final overlap = size * 0.55;

    return SizedBox(
      height: size + 4, // Extra space for shadows
      width: size + (displayImages.length - 1) * overlap + 4,
      child: Stack(
        clipBehavior: Clip.none,
        children: displayImages.asMap().entries.map((entry) {
          final idx = entry.key;
          final url = entry.value;
          
          return Positioned(
            left: idx * overlap,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.white, 
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: SafeNetworkImage(
                  url: url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class VariantComparisonView extends StatelessWidget {
  final String curLabel;
  final String curPrice;
  final String vLabel;
  final String vPrice;
  final Color accent;

  const VariantComparisonView({
    super.key,
    required this.curLabel,
    required this.curPrice,
    required this.vLabel,
    required this.vPrice,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    final dimText = cs.onSurface.withValues(alpha: isDark ? 0.45 : 0.4);
    final dimBg = cs.onSurface.withValues(alpha: isDark ? 0.06 : 0.05);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current variant pill (muted)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: dimBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                curLabel,
                style: TextStyle(
                  fontSize: 9.5,
                  color: dimText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '\u20b9$curPrice',
                style: TextStyle(
                  fontSize: 12,
                  color: dimText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Arrow
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 10,
            color: accent.withValues(alpha: 0.5),
          ),
        ),
        // Suggested variant pill (highlighted)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: accent.withValues(alpha: isDark ? 0.3 : 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                vLabel,
                style: TextStyle(
                  fontSize: 9.5,
                  color: accent.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '\u20b9$vPrice',
                style: TextStyle(
                  fontSize: 12,
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
