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

  // Filters
  final currentCategory = ''.obs;
  final currentSubcategories = <String>[].obs;
  final currentSortBy = 'name'.obs; // 'name', 'trending', 'best_sellers'

  @override
  void onInit() {
    super.onInit();
    // Auto fetch once when app starts (Home screen context)
    fetchProducts();
  }

  /// Apply new filters and refresh products
  Future<void> setFilters({
    String? category,
    List<String>? subcategories,
  }) async {
    currentCategory.value = category ?? '';
    currentSubcategories.assignAll(subcategories ?? []);
    refreshProducts();
  }

  /// Change subcategories filter only
  Future<void> setSubcategories(List<String> subs) async {
    currentSubcategories.assignAll(subs);
    refreshProducts();
  }

  /// Change sort type and refresh products
  Future<void> setSortBy(String sortBy) async {
    currentSortBy.value = sortBy;
    refreshProducts();
  }

  Future<void> fetchProducts() async {
    if (!isMoreDataAvailable.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final newProducts = await _client.product.getProducts(
        limit: 12,
        lastProductName: allProducts.isEmpty
            ? null
            : allProducts.last.productName,
        category: currentCategory.value.isEmpty ? null : currentCategory.value,
        subcategories: currentSubcategories.isEmpty
            ? null
            : currentSubcategories.toList(),
        sortBy: currentSortBy.value,
      );

      if (newProducts.length < 10) {
        isMoreDataAvailable.value = false;
      }

      allProducts.addAll(newProducts);
      print(
        'Fetched ${newProducts.length} products (Cat: ${currentCategory.value}, Subs: $currentSubcategories, Sort: ${currentSortBy.value}), total: ${allProducts.length}',
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
