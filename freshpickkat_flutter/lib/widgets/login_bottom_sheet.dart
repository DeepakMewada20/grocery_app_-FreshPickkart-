import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
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
                  height: 120.h.clamp(88.0, 130.0).toDouble(),
                  color: AppTheme.primaryGreen,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                SizedBox(height: 24.h),
                AutoSizeText(
                  'Hey Stranger!',
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  minFontSize: 18,
                  maxLines: 1,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Please Login/Signup before adding items to the cart.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 56.h.clamp(48.0, 64.0).toDouble(),
                  child: ElevatedButton(
                    onPressed: onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: AutoSizeText(
                      'Login/Signup',
                      style: TextStyle(
                        fontSize: 16.sp,
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
