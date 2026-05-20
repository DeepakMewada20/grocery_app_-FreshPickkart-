import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.padding,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark
        ? AdminAppTheme.getTextSecondaryColor(context)
        : AdminAppTheme.getTextSecondaryColor(context);
    final titleColor = isDark
        ? Theme.of(context).colorScheme.onSurface
        : AdminAppTheme.getTextSecondaryColor(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AdminAppTheme.getSubtleBorderColor(context)),
      ),
      child: Padding(
        padding: padding ?? AdminResponsive.cardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18.sp.clamp(16.0, 20.0), color: mutedColor),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AdminTextStyles.cardTitle(
                      context,
                    ).copyWith(color: titleColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            child,
          ],
        ),
      ),
    );
  }
}
