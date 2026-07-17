import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';

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
                    fontSize: 10.5.sp,
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
                  fontSize: 10.5.sp,
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        SizedBox(height: 6.h),
        // Custom gradient progress bar
        LayoutBuilder(
          builder: (context, constraints) {
            final barWidth = constraints.maxWidth;
            return Container(
              height: 4.h,
              width: barWidth,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(AppRadius.medium),
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
                        height: 4.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.medium),
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
      height: size.r + 4.h,
      width: size.r + (displayImages.length - 1) * overlap.w + 4.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: displayImages.asMap().entries.map((entry) {
          final idx = entry.key;
          final url = entry.value;

          return Positioned(
            left: (idx * overlap).w,
            child: Container(
              width: size.r,
              height: size.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 2.r,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: Offset(1.w, 2.h),
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
          padding: AppSpacing.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: dimBg,
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                curLabel,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  color: dimText,
                  fontWeight: FontWeight.w500,
                ),
                minFontSize: 7,
                maxLines: 1,
              ),
              SizedBox(height: 1.h),
              AutoSizeText(
                '\u20b9$curPrice',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: dimText,
                  fontWeight: FontWeight.w700,
                ),
                minFontSize: 8,
                maxLines: 1,
              ),
            ],
          ),
        ),
        // Arrow
        Padding(
          padding: AppSpacing.symmetric(horizontal: 6),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 10.r,
            color: accent.withValues(alpha: 0.5),
          ),
        ),
        // Suggested variant pill (highlighted)
        Container(
          padding: AppSpacing.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(
              color: accent.withValues(alpha: isDark ? 0.3 : 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                vLabel,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  color: accent.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
                ),
                minFontSize: 7,
                maxLines: 1,
              ),
              SizedBox(height: 1.h),
              AutoSizeText(
                '\u20b9$vPrice',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
                minFontSize: 8,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
