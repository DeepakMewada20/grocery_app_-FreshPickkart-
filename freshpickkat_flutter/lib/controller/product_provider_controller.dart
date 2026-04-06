import 'package:flutter/foundation.dart';
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
      debugPrint(
        'Fetched ${newProducts.length} products (Cat: ${currentCategory.value}, Subs: $currentSubcategories, Sort: ${currentSortBy.value}), total: ${allProducts.length}',
      );
    } catch (e) {
      errorMessage.value = e.toString();
      debugPrint('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductsByIds(List<String> productIds) async {
    final trimmedIds = productIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
    if (trimmedIds.isEmpty) return;

    final loadedIds = allProducts
        .map((product) => product.productId)
        .whereType<String>()
        .toSet();
    final missingIds = trimmedIds
        .where((id) => !loadedIds.contains(id))
        .toList();
    if (missingIds.isEmpty) return;

    try {
      final fetched = await _client.product.getProductsByIds(missingIds);
      if (fetched.isEmpty) return;

      final merged = [...allProducts];
      final existingIds = merged
          .map((product) => product.productId)
          .whereType<String>()
          .toSet();

      for (final product in fetched) {
        final productId = product.productId;
        if (productId == null || existingIds.contains(productId)) continue;
        merged.add(product);
        existingIds.add(productId);
      }

      allProducts.assignAll(merged);
    } catch (e) {
      debugPrint('Error fetching products by ids: $e');
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

  Future<void> resetHomeFeed() async {
    currentCategory.value = '';
    currentSubcategories.clear();
    currentSortBy.value = 'name';
    clearProducts();
    await fetchProducts();
  }

  bool get hasData => allProducts.isNotEmpty;
}
