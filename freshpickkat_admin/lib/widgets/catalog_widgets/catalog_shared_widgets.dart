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
    final accent = AdminAppTheme.getSuccessColor(context);
    final isDark = AdminAppTheme.isDark(context);

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
      ),
      side: BorderSide(
        color: selected
            ? accent
            : AdminAppTheme.getBorderColor(context),
      ),
      backgroundColor: isDark
          ? AdminThemeTokens.darkSurfaceElevated
          : Theme.of(context).colorScheme.surface,
      selectedColor: accent.withValues(alpha: isDark ? 0.2 : 0.12),
      labelStyle: TextStyle(
        fontSize: 12.sp.clamp(10.0, 13.0),
        fontWeight: FontWeight.w600,
        color: selected
            ? accent
            : AdminAppTheme.getTextPrimaryColor(context),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
    );
  }
}

/// Data for one offer-type filter pill on the Offers tab.
class CatalogOfferTypeFilterItem {
  const CatalogOfferTypeFilterItem({
    required this.value,
    required this.label,
    required this.count,
    required this.icon,
    required this.accentColor,
    this.subtitle,
  });

  final String value;
  final String label;
  final String count;
  final IconData icon;
  final Color accentColor;
  final String? subtitle;
}

/// Horizontal offer-type filter pills (Offers tab).
class CatalogOffersTypeFilterBar extends StatelessWidget {
  const CatalogOffersTypeFilterBar({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
  });

  final List<CatalogOfferTypeFilterItem> items;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58.h.clamp(54.0, 64.0),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = items[index];
          return CatalogOfferTypeFilterPill(
            item: item,
            selected: selectedValue == item.value,
            onTap: () => onSelected(item.value),
          );
        },
      ),
    );
  }
}

class CatalogOfferTypeFilterPill extends StatelessWidget {
  const CatalogOfferTypeFilterPill({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final CatalogOfferTypeFilterItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = AdminAppTheme.isDark(context);
    final accent = item.accentColor;
    final bgAlpha = selected ? (isDark ? 0.22 : 0.14) : (isDark ? 0.1 : 0.06);

    return Material(
      color: AdminThemeTokens.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: bgAlpha),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected
                  ? accent
                  : accent.withValues(alpha: isDark ? 0.28 : 0.2),
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 17.r,
                color: selected ? accent : accent.withValues(alpha: 0.85),
              ),
              SizedBox(width: 7.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 12.sp.clamp(11.0, 13.0),
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                      color: selected
                          ? accent
                          : AdminAppTheme.getTextPrimaryColor(context),
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 10.sp.clamp(9.0, 11.0),
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                        color: AdminAppTheme.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: selected
                      ? accent.withValues(alpha: isDark ? 0.28 : 0.18)
                      : AdminAppTheme.getTextSecondaryColor(
                          context,
                        ).withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(7.r),
                ),
                child: Text(
                  item.count,
                  style: TextStyle(
                    fontSize: 12.sp.clamp(11.0, 13.0),
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: selected
                        ? accent
                        : AdminAppTheme.getTextPrimaryColor(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
