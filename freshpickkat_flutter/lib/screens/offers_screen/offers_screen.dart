import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Screen shown when user taps an "offer" type banner.
/// Displays all products that have an active offer/discount.
class OffersScreen extends StatefulWidget {
  /// Optional — if set, a specific offer card is highlighted/scrolled to.
  final String? highlightOfferId;

  const OffersScreen({super.key, this.highlightOfferId});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final _productController = ProductProviderController.instance;
  final _networkController = NetworkController.instance;
  String _sortBy = 'discount'; // 'discount' | 'price_low' | 'price_high'

  @override
  void initState() {
    super.initState();
    ever(_networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (_networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('offers')) {
          _productController.fetchProducts();
        }
      }
    });
  }

  List<Product> get _filteredProducts {
    final products = _productController.allProducts.where((p) {
      final hasDiscount =
          p.discountType != null &&
          p.discountType!.isNotEmpty &&
          p.realPrice > p.price;

      // Also include BOGO products
      final isBogo =
          p.bogoFreeProductIds != null && p.bogoFreeProductIds!.isNotEmpty;

      return hasDiscount || isBogo;
    }).toList();

    switch (_sortBy) {
      case 'discount':
        products.sort((a, b) {
          final discA = a.realPrice - a.price;
          final discB = b.realPrice - b.price;
          return discB.compareTo(discA);
        });
        break;
      case 'price_low':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: cs.onSurface,
        elevation: 0,
        title: Text(
          'Special Offers',
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort_rounded, color: cs.onSurface),
            tooltip: 'Sort',
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'discount',
                child: Row(
                  children: [
                    Icon(
                      Icons.percent,
                      size: 18,
                      color: _sortBy == 'discount'
                          ? AppTheme.primaryGreen
                          : cs.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Best Discount',
                      style: TextStyle(
                        fontWeight: _sortBy == 'discount'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _sortBy == 'discount'
                            ? AppTheme.primaryGreen
                            : cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'price_low',
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      size: 18,
                      color: _sortBy == 'price_low'
                          ? AppTheme.primaryGreen
                          : cs.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Price: Low to High',
                      style: TextStyle(
                        fontWeight: _sortBy == 'price_low'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _sortBy == 'price_low'
                            ? AppTheme.primaryGreen
                            : cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'price_high',
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      size: 18,
                      color: _sortBy == 'price_high'
                          ? AppTheme.primaryGreen
                          : cs.onSurface,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Price: High to Low',
                      style: TextStyle(
                        fontWeight: _sortBy == 'price_high'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _sortBy == 'price_high'
                            ? AppTheme.primaryGreen
                            : cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final isLoading = _productController.isLoading.value;
          final hasData = _productController.hasData;

          if (isLoading && !hasData) {
            return ProductGridShimmer(
              itemCount: 6,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            );
          }

          final products = _filteredProducts;

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(28.w),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_offer_outlined,
                      size: 56.r,
                      color: cs.onSurface.withValues(alpha: 0.3),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'No offers right now',
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Check back soon for exciting deals.',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.5),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Column(
              children: [
                // ── Smart Analysis Section ──────────────────────────────────
                Obx(() {
                  final cart = CartController.instance;
                  final suggestions = cart.basketSuggestions;
                  if (suggestions.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 8.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryGreen.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                size: 16.r,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                'Smart Analysis for You',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.sectionTitle(
                                  context,
                                ).copyWith(fontSize: 16.sp),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppResponsive.horizontalProductListHeight(
                          context,
                        ).clamp(170.h, 220.h).toDouble(),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: suggestions.length,
                          itemBuilder: (context, i) => SuggestionCard(
                            suggestion: suggestions[i],
                            index: i,
                            width: (MediaQuery.sizeOf(context).width * 0.85)
                                .clamp(280.w, 520.w),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'All Offers',
                        style: AppTextStyles.sectionTitle(
                          context,
                        ).copyWith(fontSize: 16.sp),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  );
                }),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Obx(() {
                    final count = _filteredProducts.length;
                    return Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 18.r,
                          color: AppTheme.primaryGreen,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            '$count deal${count == 1 ? '' : 's'} available',
                            style: TextStyle(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.builder(
                        gridDelegate: AppResponsive.productGridDelegate(
                          context,
                          constraints.maxWidth,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final p = products[index];
                          return ProductCard(
                            product: p,
                            heroTagSuffix: '_offers',
                            onAddPressed: () {},
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
