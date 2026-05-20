import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).brightness == Brightness.dark
        ? AdminAppTheme.getErrorColor(context)
        : AdminAppTheme.getErrorColor(context);

    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: AdminAppTheme.getErrorContainerColor(context),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 16.r, color: errorColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AdminTextStyles.caption(
                context,
              ).copyWith(color: errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
