import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/view_all_products_screen.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:freshpickkat_flutter/widgets/view_all_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoriesSelectionListview extends StatefulWidget {
  final String titalWord;
  final String? sortBy; // 'trending', 'best_sellers', or null for default

  const CategoriesSelectionListview({
    super.key,
    required this.titalWord,
    this.sortBy,
  });

  @override
  State<CategoriesSelectionListview> createState() =>
      _CategoriesSelectionListviewState();
}

class _CategoriesSelectionListviewState
    extends State<CategoriesSelectionListview> {
  @override
  void initState() {
    super.initState();
    _triggerFetch();
  }

  void _triggerFetch() {
    final productController = ProductProviderController.instance;
    if (widget.sortBy == 'trending') {
      productController.fetchTrendingIfEmpty();
    } else if (widget.sortBy == 'best_sellers') {
      productController.fetchBestSellersIfEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productController = ProductProviderController.instance;

    return Obx(() {
      List<Product> products;
      bool isLoading;

      if (widget.sortBy == 'trending') {
        products = productController.trendingProducts;
        isLoading = productController.isLoading.value && products.isEmpty;
      } else if (widget.sortBy == 'best_sellers') {
        products = productController.bestSellersProducts;
        isLoading = productController.isLoading.value && products.isEmpty;
      } else {
        products = productController.allProducts;
        isLoading = productController.isLoading.value && products.isEmpty;
      }

      if (isLoading) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 28.h),
          child: SizedBox(
            height: AppResponsive.horizontalProductListHeight(context),
            child: HorizontalProductListShimmer(
              height: AppResponsive.horizontalProductListHeight(context),
              itemCount: 5,
              itemWidth: AppResponsive.horizontalCardWidth(context),
            ),
          ),
        );
      }

      if (products.isEmpty) return const SizedBox.shrink();

      final itemCount = (products.length > 5 ? 5 : products.length) + 1;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.h, left: 12.w, right: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.titalWord,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle(context),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewAllProductsScreen(
                          sortBy: widget.sortBy,
                          title: widget.titalWord,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Color(0xFF1B8A4C)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: AppResponsive.horizontalProductListHeight(context),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // Show ViewAllCard as last item
                if (index == itemCount - 1) {
                  return SizedBox(
                    width: AppResponsive.horizontalCardWidth(context),
                    child: ViewAllCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ViewAllProductsScreen(
                              sortBy: widget.sortBy,
                              title: widget.titalWord,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                final p = products[index];
                final uniqueKey = '${p.productId}_trending_$index';
                return Container(
                  width: AppResponsive.horizontalCardWidth(context),
                  margin: EdgeInsets.only(right: 12.w),
                  child: KeyedSubtree(
                    key: ValueKey(uniqueKey),
                    child: ProductCard(
                      product: p,
                      enableHero: false,
                      heroTagSuffix: '_trending',
                      onAddPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
