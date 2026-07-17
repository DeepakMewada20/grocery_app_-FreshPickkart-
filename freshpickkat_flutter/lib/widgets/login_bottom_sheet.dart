import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

class LoginBottomSheet extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const LoginBottomSheet({
    super.key,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: AppResponsive.sheetConstraints(context),
          child: Container(
            padding: AppSpacing.symmetric(horizontal: 24, vertical: 24),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.extraLarge)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: cs.onSurface),
                  ),
                ),
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/3081/3081986.png',
                  height: ScreenScale.h(100).clamp(72.0, 120.0),
                  color: AppTheme.primaryGreen,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.shopping_cart_outlined,
                    size: 72,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                SizedBox(height: ScreenScale.h(16)),
                AutoSizeText(
                  'Hey Stranger!',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: ScreenScale.sp(24),
                    fontWeight: FontWeight.bold,
                  ),
                  minFontSize: 18,
                  maxLines: 1,
                ),
                SizedBox(height: ScreenScale.h(8)),
                Text(
                  'Please Login/Signup before adding items to the cart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontSize: ScreenScale.sp(16),
                  ),
                ),
                SizedBox(height: ScreenScale.h(24)),
                SizedBox(
                  width: double.infinity,
                  height: ScreenScale.h(50).clamp(44.0, 56.0),
                  child: ElevatedButton(
                    onPressed: onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                    ),
                    child: AutoSizeText(
                      'Login/Signup',
                      style: TextStyle(
                        fontSize: ScreenScale.sp(16),
                        fontWeight: FontWeight.bold,
                      ),
                      minFontSize: 12,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
