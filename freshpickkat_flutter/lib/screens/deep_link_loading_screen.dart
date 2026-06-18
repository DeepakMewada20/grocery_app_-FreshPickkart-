import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/routes/route_manager.dart';
import 'package:freshpickkat_flutter/screens/category_item_screen.dart'
    deferred as categoryItemScreen;
import 'package:freshpickkat_flutter/screens/coupons_screen.dart'
    deferred as couponsScreen;
import 'package:freshpickkat_flutter/screens/deep_link_not_found_screen.dart'
    deferred as deepLinkNotFoundScreen;
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart'
    deferred as productDetailScreen;
import 'package:freshpickkat_flutter/services/deep_link_service.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';

class DeepLinkLoadingScreen extends StatefulWidget {
  const DeepLinkLoadingScreen({
    super.key,
    required this.type,
    this.target,
  });

  final DeepLinkType type;
  final DeepLinkTarget? target;

  @override
  State<DeepLinkLoadingScreen> createState() => _DeepLinkLoadingScreenState();
}

class _DeepLinkLoadingScreenState extends State<DeepLinkLoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolve());
  }

  Future<void> _resolve() async {
    final target = widget.target ?? RouteManager.fromGetXRoute(widget.type);
    if (!mounted) return;

    if (target == null) {
      await _openNotFound();
      return;
    }

    switch (target.type) {
      case DeepLinkType.product:
        final product = await DeepLinkService.instance.resolveProduct(
          target.value,
        );
        if (!mounted) return;
        if (product == null) {
          await navigateDeferred(
            loadLibrary: () => deepLinkNotFoundScreen.loadLibrary(),
            pageBuilder: () =>
                deepLinkNotFoundScreen.DeepLinkNotFoundScreen.product(
                  productId: target.value,
                ),
            routeName: RouteManager.productNotFound,
          );
        } else {
          await navigateDeferred(
            loadLibrary: () => productDetailScreen.loadLibrary(),
            pageBuilder: () =>
                productDetailScreen.ProductDetailScreen(product: product),
          );
        }
        break;
      case DeepLinkType.category:
        final categoryName = await DeepLinkService.instance.resolveCategoryName(
          target.value,
        );
        if (!mounted) return;
        if (categoryName == null) {
          await navigateDeferred(
            loadLibrary: () => deepLinkNotFoundScreen.loadLibrary(),
            pageBuilder: () =>
                deepLinkNotFoundScreen.DeepLinkNotFoundScreen.category(
                  categoryId: target.value,
                ),
            routeName: RouteManager.deepLinkNotFound,
          );
        } else {
          await navigateDeferred(
            loadLibrary: () => categoryItemScreen.loadLibrary(),
            pageBuilder: () => categoryItemScreen.CategoryItemsScreen(
              categoryName: categoryName,
              subCategoryGroupName: 'All',
            ),
          );
        }
        break;
      case DeepLinkType.offer:
        final code = target.value.trim();
        if (code.isEmpty) {
          await _openNotFound();
        } else {
          await navigateDeferred(
            loadLibrary: () => couponsScreen.loadLibrary(),
            pageBuilder: () =>
                couponsScreen.CouponsScreen(autoApplyCouponCode: code),
          );
        }
        break;
    }
  }

  Future<void> _openNotFound() async {
    await navigateDeferred(
      loadLibrary: () => deepLinkNotFoundScreen.loadLibrary(),
      pageBuilder: () => deepLinkNotFoundScreen.DeepLinkNotFoundScreen(),
      routeName: RouteManager.deepLinkNotFound,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Opening FreshPickKat...',
                style: TextStyle(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
