import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';

class CategoryItemCard extends StatelessWidget {
  final String itemName;
  final String imagePath;
  final VoidCallback? onTap;

  const CategoryItemCard({
    super.key,
    required this.itemName,
    required this.imagePath,
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
          borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(12),
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
                  padding: const EdgeInsets.all(6),
                  child: _buildImage(imagePath),
                ),
              ),
            ),
            // Item Name
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 4),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    itemName,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 12,
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

  Widget _buildImage(String path) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    if (isNetwork) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(
            Icons.broken_image,
            size: 40,
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
          size: 40,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
