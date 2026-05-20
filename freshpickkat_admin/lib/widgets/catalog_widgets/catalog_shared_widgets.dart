import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';

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
    final minWidth = compact ? 150.w.clamp(136.0, 166.0).toDouble() : 0.0;
    final maxWidth = compact
        ? 166.w.clamp(150.0, 176.0).toDouble()
        : double.infinity;
    final padding = compact ? 8.r : 14.r;
    final radius = compact ? 14.r : 16.r;
    final avatarRadius = compact ? 16.r : 20.r;
    final iconSize = compact
        ? 18.sp.clamp(16.0, 20.0).toDouble()
        : 24.sp.clamp(20.0, 26.0).toDouble();
    final titleFontSize = compact
        ? 12.sp.clamp(10.0, 13.0).toDouble()
        : 14.sp.clamp(12.0, 15.0).toDouble();
    final valueFontSize = compact
        ? 15.sp.clamp(13.0, 17.0).toDouble()
        : 18.sp.clamp(16.0, 21.0).toDouble();
    final spacing = compact ? 7.w : 12.w;
    final breakdownSpacing = compact ? 6.w : 8.w;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? AdminAppTheme.getTextSecondaryColor(context)
        : AdminAppTheme.getTextSecondaryColor(context);
    final cardBackgroundAlpha = isDark
        ? (selected ? 0.18 : 0.12)
        : (selected ? 0.16 : 0.08);

    return Material(
      color: AdminThemeTokens.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
          child: Ink(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: color.withValues(alpha: cardBackgroundAlpha),
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
                              color: titleColor,
                              fontSize: titleFontSize,
                            ),
                          ),
                          SizedBox(height: 2.h),
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
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: breakdownSpacing,
                    runSpacing: breakdownSpacing,
                    children: breakdown
                        .map(
                          (item) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: item.color.withValues(
                                alpha: isDark ? 0.18 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${item.label} ${item.value}',
                              style: TextStyle(
                                color: item.color,
                                fontSize: compact
                                    ? 10.sp.clamp(9.0, 11.0)
                                    : 11.sp.clamp(10.0, 12.0),
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: Theme.of(context).brightness == Brightness.dark ? 0.18 : 0.1,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: color.withValues(alpha: 0.3))
            : null,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp.clamp(10.0, 13.0),
        ),
      ),
    );
  }
}
