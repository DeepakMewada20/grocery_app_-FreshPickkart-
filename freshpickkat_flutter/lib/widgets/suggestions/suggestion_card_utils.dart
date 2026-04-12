import 'package:flutter/material.dart';

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
    final percentage = (progress * 100).toInt();
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                '₹${current.toInt()} / ₹${target.toInt()}',
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.8),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 10,
                  color: accent,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: accent.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
                minHeight: 6,
              );
            },
          ),
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
    
    // Limit to 3 images as per user requirement
    final displayImages = imageUrls.take(3).toList();

    return SizedBox(
      height: size,
      width: size + (displayImages.length - 1) * (size * 0.6),
      child: Stack(
        children: displayImages.asMap().entries.map((entry) {
          final idx = entry.key;
          final url = entry.value;
          return Positioned(
            left: idx * (size * 0.6),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.grey[200]),
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _VariantNode(label: curLabel, price: curPrice, color: cs.onSurface.withValues(alpha: 0.5)),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 14, color: accent.withValues(alpha: 0.5)),
          const SizedBox(width: 8),
          _VariantNode(label: vLabel, price: vPrice, color: accent, isBold: true),
        ],
      ),
    );
  }
}

class _VariantNode extends StatelessWidget {
  final String label;
  final String price;
  final Color color;
  final bool isBold;

  const _VariantNode({required this.label, required this.price, required this.color, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        Text(
          '₹$price',
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
