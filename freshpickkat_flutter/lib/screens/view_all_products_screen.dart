import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:get/get.dart';

/// Displays a full list of products in a grid. The [sortBy] value is forwarded
/// to the server so the collection is ordered exactly as the originating
/// selection (e.g. "trending" or "best_sellers").
///
/// The [title] is shown in the app bar; if omitted it defaults to
/// "All Products".
class ViewAllProductsScreen extends StatefulWidget {
  final String? sortBy;
  final String? title;

  const ViewAllProductsScreen({
    super.key,
    this.sortBy,
    this.title,
  });

  @override
  State<ViewAllProductsScreen> createState() => _ViewAllProductsScreenState();
}

class _ViewAllProductsScreenState extends State<ViewAllProductsScreen> {
  final _client = ServerpodClient().client;
  late RxList<Product> products = <Product>[].obs;
  late RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      isLoading.value = true;
      final sortType = widget.sortBy ?? 'name';
      final fetched = await _client.product.getProducts(
        limit: 100,
        sortBy: sortType,
      );
      products.assignAll(fetched);
    } catch (e) {
      debugPrint('Failed to fetch products: $e');
      Get.snackbar(
        'Error',
        'Unable to load products',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.title ?? 'All Products',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (products.isEmpty) {
            return const Center(
              child: Text(
                'No products found',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.59,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return ProductCard(product: p);
              },
            ),
          );
        }),
      ),
    );
  }
}
