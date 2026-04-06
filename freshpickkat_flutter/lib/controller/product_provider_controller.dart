import 'package:flutter/foundation.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class ProductProviderController extends GetxController {
  static ProductProviderController get instance =>
      Get.put(ProductProviderController(), permanent: true);

  final Client _client = ServerpodClient().client;

  static const int _cacheLimit = 15;
  final Map<String, List<Product>> _productCache = {};

  // States
  final allProducts = <Product>[].obs;
  final isLoading = false.obs;
  final isMoreDataAvailable = true.obs;
  final errorMessage = ''.obs;

  // Filters
  final currentCategory = ''.obs;
  final currentSubcategories = <String>[].obs;
  final currentSortBy = 'name'.obs;

  String get _cacheKey {
    final sub = currentSubcategories.isEmpty
        ? 'all'
        : currentSubcategories.join(',').toLowerCase();
    return '${currentCategory.value}|$sub|${currentSortBy.value}';
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> setFilters({
    String? category,
    List<String>? subcategories,
  }) async {
    currentCategory.value = category ?? '';
    currentSubcategories.assignAll(subcategories ?? []);
    refreshProducts();
  }

  Future<void> setSubcategories(List<String> subs) async {
    currentSubcategories.assignAll(subs);
    refreshProducts();
  }

  Future<void> setSortBy(String sortBy) async {
    currentSortBy.value = sortBy;
    refreshProducts();
  }

  Future<void> fetchProducts() async {
    if (!isMoreDataAvailable.value) return;

    final key = _cacheKey;
    final isInitialFetch = allProducts.isEmpty;

    if (isInitialFetch && _productCache.containsKey(key)) {
      allProducts.assignAll(_productCache[key]!);
      isMoreDataAvailable.value = _productCache[key]!.length >= _cacheLimit;
      debugPrint(
        'Loaded from cache: ${_productCache[key]!.length} products (Key: $key)',
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final newProducts = await _client.product.getProducts(
        limit: _cacheLimit,
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

      if (isInitialFetch) {
        _productCache[key] = List.from(allProducts);
      }

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

  Future<void> loadMore() async {
    if (!isLoading.value && isMoreDataAvailable.value) {
      await fetchProducts();
    }
  }

  void clearProducts() {
    allProducts.clear();
    isMoreDataAvailable.value = true;
  }

  void refreshProducts() {
    final key = _cacheKey;
    if (_productCache.containsKey(key) && _productCache[key]!.isNotEmpty) {
      allProducts.assignAll(_productCache[key]!);
      isMoreDataAvailable.value = _productCache[key]!.length >= _cacheLimit;
    } else {
      clearProducts();
      fetchProducts();
    }
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
