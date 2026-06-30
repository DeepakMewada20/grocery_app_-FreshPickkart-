import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/routes/route_manager.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/screens/category_item_screen.dart'
    deferred as category_item_screen;
import 'package:freshpickkat_flutter/screens/coupons_screen.dart'
    deferred as coupons_screen;
import 'package:freshpickkat_flutter/screens/deep_link_not_found_screen.dart'
    deferred as deep_link_not_found_screen;
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart'
    deferred as product_detail_screen;
import 'package:freshpickkat_flutter/services/deep_link_service.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';

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
          await _openNotFound();
        } else {
          await product_detail_screen.loadLibrary();
          if (!mounted) return;
          await Get.off(() =>
              product_detail_screen.ProductDetailScreen(product: product));
        }
        break;
      case DeepLinkType.category:
        final categoryName = await DeepLinkService.instance.resolveCategoryName(
          target.value,
        );
        if (!mounted) return;
        if (categoryName == null) {
          await _openNotFound();
        } else {
          await category_item_screen.loadLibrary();
          if (!mounted) return;
          await Get.off(() => category_item_screen.CategoryItemsScreen(
                categoryName: categoryName,
                subCategoryGroupName: 'All',
              ));
        }
        break;
      case DeepLinkType.offer:
        final code = target.value.trim();
        if (code.isEmpty) {
          await _openNotFound();
        } else {
          await coupons_screen.loadLibrary();
          if (!mounted) return;
          await Get.off(() =>
              coupons_screen.CouponsScreen(autoApplyCouponCode: code));
        }
        break;
      case DeepLinkType.invite:
        await Get.offAllNamed(RouteManager.home);
        break;
    }
  }

  Future<void> _openNotFound() async {
    await deep_link_not_found_screen.loadLibrary();
    if (!mounted) return;
    await Get.off(() {
      switch (widget.type) {
        case DeepLinkType.product:
          return deep_link_not_found_screen.DeepLinkNotFoundScreen.product(
            productId: '',
          );
        case DeepLinkType.category:
          return deep_link_not_found_screen.DeepLinkNotFoundScreen.category(
            categoryId: '',
          );
        default:
          return deep_link_not_found_screen.DeepLinkNotFoundScreen();
      }
    });
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
