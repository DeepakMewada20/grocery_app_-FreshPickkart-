import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

class ViewAllCard extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const ViewAllCard({
    super.key,
    required this.onTap,
    this.text = 'VIEW ALL',
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: cs.outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: ScreenScale.r(8),
              offset: Offset(0, ScreenScale.h(2)),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                text,
                maxLines: 1,
                minFontSize: 10,
                style: TextStyle(
                  color: AppTheme.primaryGreen,
                  fontSize: ScreenScale.sp(14),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: ScreenScale.h(8)),
              Icon(
                Icons.arrow_forward,
                color: AppTheme.primaryGreen,
                size: AppIcons.medium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
