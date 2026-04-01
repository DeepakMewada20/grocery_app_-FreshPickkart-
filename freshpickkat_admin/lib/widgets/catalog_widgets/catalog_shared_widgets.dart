import 'package:flutter/material.dart';

class CatalogStatCard extends StatelessWidget {
  const CatalogStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.breakdown = const [],
    this.compact = false,
    this.selected = false,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final List<CatalogStatBreakdown> breakdown;
  final bool compact;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final minWidth = compact ? 160.0 : 150.0;
    final maxWidth = compact ? 160.0 : double.infinity;
    final padding = compact ? 8.0 : 14.0;
    final radius = compact ? 14.0 : 16.0;
    final avatarRadius = compact ? 16.0 : 20.0;
    final iconSize = compact ? 18.0 : 24.0;
    final titleFontSize = compact ? 12.0 : 14.0;
    final valueFontSize = compact ? 15.0 : 18.0;
    final spacing = compact ? 7.0 : 12.0;
    final breakdownSpacing = compact ? 6.0 : 8.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
          child: Ink(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: selected
                  ? color.withValues(alpha: 0.16)
                  : color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: selected ? color : color.withValues(alpha: 0.18),
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: color.withValues(
                        alpha: selected ? 0.18 : 0.12,
                      ),
                      foregroundColor: color,
                      child: Icon(icon, size: iconSize),
                    ),
                    SizedBox(width: spacing),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: titleFontSize,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: valueFontSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (breakdown.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: breakdownSpacing,
                    runSpacing: breakdownSpacing,
                    children: breakdown
                        .map(
                          (item) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${item.label} ${item.value}',
                              style: TextStyle(
                                color: item.color,
                                fontSize: compact ? 10 : 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CatalogStatBreakdown {
  const CatalogStatBreakdown({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;
}

class CatalogOfferFilterChip extends StatelessWidget {
  const CatalogOfferFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class CatalogInlineBadge extends StatelessWidget {
  const CatalogInlineBadge({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
