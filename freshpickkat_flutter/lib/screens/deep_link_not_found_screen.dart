import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/routes/route_manager.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_icons.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
import 'package:get/get.dart';

class DeepLinkNotFoundScreen extends StatelessWidget {
  const DeepLinkNotFoundScreen({
    super.key,
    this.title = 'Link not found',
    this.message = 'This link is no longer available.',
  });

  factory DeepLinkNotFoundScreen.product({required String productId}) {
    return DeepLinkNotFoundScreen(
      title: 'Product not found',
      message: 'This product is unavailable or has been removed.',
    );
  }

  factory DeepLinkNotFoundScreen.category({required String categoryId}) {
    return DeepLinkNotFoundScreen(
      title: 'Category not found',
      message: 'This category is unavailable or has been removed.',
    );
  }

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: cs.onSurface,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    color: cs.onSurface.withValues(alpha: 0.48),
                    size: 42,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.68),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 26),
                FilledButton(
                  onPressed: () => Get.offAllNamed(RouteManager.home),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(180, 48),
                  ),
                  child: const Text('Go to home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
