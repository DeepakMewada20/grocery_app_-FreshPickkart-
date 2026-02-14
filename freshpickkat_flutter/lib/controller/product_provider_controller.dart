import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class ProductProviderController extends GetxController {
  // --------- SINGLETON PATTERN ---------
  static ProductProviderController get instance =>
      Get.put(ProductProviderController(), permanent: true);
  // -------------------------------------

  final Client _client = ServerpodClient().client;

  // States
  final allProducts = <Product>[].obs;
  final isLoading = false.obs;
  final isMoreDataAvailable = true.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Auto fetch once when app starts
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (!isMoreDataAvailable.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final newProducts = await _client.product.getProducts(
        limit: 10,
        lastProductName: allProducts.isEmpty
            ? null
            : allProducts.last.productName,
      );

      if (newProducts.length < 10) {
        isMoreDataAvailable.value = false;
      }

      allProducts.addAll(newProducts);
      print(
        'Fetched ${newProducts.length} products, total: ${allProducts.length}',
      );
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more products (pagination)
  Future<void> loadMore() async {
    if (!isLoading.value && isMoreDataAvailable.value) {
      await fetchProducts();
    }
  }

  // Utility methods
  void clearProducts() {
    allProducts.clear();
    isMoreDataAvailable.value = true;
  }

  void refreshProducts() {
    clearProducts();
    fetchProducts();
  }

  bool get hasData => allProducts.isNotEmpty;
}
