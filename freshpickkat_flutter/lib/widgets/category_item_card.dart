import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItemCard extends StatelessWidget {
  final String itemName;
  final String? imagePath;
  final VoidCallback? onTap;

  const CategoryItemCard({
    super.key,
    required this.itemName,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Container
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  color: isDark
                      ? const Color(0xFF2E2E2E)
                      : const Color(0xFFE8F5E9), // light green tint
                  border: isDark
                      ? null
                      : Border.all(
                          color: AppTheme.lightDivider,
                          width: 1,
                        ),
                ),
                child: Padding(
                  padding: AppSpacing.all(6),
                  child: _buildImage(imagePath),
                ),
              ),
            ),
            // Item Name
            Expanded(
              child: Container(
                width: double.infinity,
                padding: AppSpacing.only(top: 4),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AutoSizeText(
                    itemName,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    minFontSize: 9,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? path) {
    if (path == null || path.isEmpty) {
      return Center(
        child: Icon(
          Icons.category,
          size: 36.r,
          color: Colors.grey[400],
        ),
      );
    }
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    if (isNetwork) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(
            Icons.broken_image,
            size: 36.r,
            color: Colors.grey[400],
          ),
        ),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Center(
        child: Icon(
          Icons.broken_image,
          size: 36.r,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
