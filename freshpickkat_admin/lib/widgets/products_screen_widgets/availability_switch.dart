import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';

class AvailabilitySwitch extends StatelessWidget {
  const AvailabilitySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final inactiveColor = Theme.of(context).brightness == Brightness.dark
        ? AdminAppTheme.getTextSecondaryColor(context)
        : AdminAppTheme.getNeutralColor(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AdminAppTheme.getSubtleBorderColor(context)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    value ? Icons.check_circle : Icons.cancel_outlined,
                    size: 20.sp.clamp(18.0, 22.0),
                    color: value
                        ? AdminAppTheme.getSuccessColor(context)
                        : inactiveColor,
                  ),
                  SizedBox(width: AdminSpacing.md),
                  Expanded(
                    child: Text(
                      'Available for Order',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AdminTextStyles.body(context),
                    ),
                  ),
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
