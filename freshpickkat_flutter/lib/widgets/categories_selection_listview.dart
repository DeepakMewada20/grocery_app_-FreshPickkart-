import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/screens/view_all_products_screen.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
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
  late RxList<Product> products = <Product>[].obs;
  late RxBool isLoading = false.obs;
  final _client = ServerpodClient().client;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      isLoading.value = true;
      final sortType = widget.sortBy ?? 'name';

      final fetchedProducts = await _client.product.getProducts(
        limit: 10,
        sortBy: sortType,
      );

      products.assignAll(fetchedProducts);
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value && products.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Colors.blue),
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
                            builder: (_) => const ViewAllProductsScreen(),
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
