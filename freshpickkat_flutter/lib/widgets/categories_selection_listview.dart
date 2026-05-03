import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/view_all_products_screen.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:freshpickkat_flutter/widgets/view_all_card.dart';
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
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: SizedBox(
            height: 260,
            child: HorizontalProductListShimmer(
              height: 260,
              itemCount: 5,
              itemWidth: 160,
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
            padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.titalWord,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
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
            height: 289,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // Show ViewAllCard as last item
                if (index == itemCount - 1) {
                  return SizedBox(
                    width: 160,
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
                // Show regular ProductCard
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: ProductCard(
                    product: p,
                    heroTagSuffix: '_trending',
                    onAddPressed: () {},
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
