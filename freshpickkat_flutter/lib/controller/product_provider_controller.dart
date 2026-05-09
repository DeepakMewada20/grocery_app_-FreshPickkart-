import 'package:flutter/foundation.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class ProductProviderController extends GetxController {
  static ProductProviderController get instance =>
      Get.find<ProductProviderController>();

  final Client _client = ServerpodClient().client;

  static const int _cacheLimit = 15;
  final Map<String, List<Product>> _productCache = {};

  // States
  final allProducts = <Product>[].obs;
  final trendingProducts = <Product>[].obs;
  final bestSellersProducts = <Product>[].obs;
  final mostViewedProducts = <Product>[].obs;
  final frequentlyReorderedProducts = <Product>[].obs;
  final isLoading = false.obs;
  final isMoreDataAvailable = true.obs;
  final errorMessage = ''.obs;

  // Mutex lock to prevent duplicate API calls
  bool _isFetching = false;

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

  Future<void> fetchProductsIfEmpty() async {
    if (_isFetching) return;
    if (allProducts.isNotEmpty) return;
    if (isLoading.value) return;

    _isFetching = true;
    try {
      // ONLY fetch main products here. Trending and Best Sellers will be lazy-loaded by widgets.
      await fetchProducts();
    } catch (e) {
      // error handled in fetchProducts
    } finally {
      _isFetching = false;
    }
  }

  Future<void> fetchTrendingIfEmpty() async {
    if (trendingProducts.isNotEmpty) return;
    try {
      final rankings = await _client.productRanking.getTrendingProducts(
        limit: 10,
      );
      trendingProducts.assignAll(rankings.map((item) => item.product).toList());
    } catch (e) {
      debugPrint('Error fetching trending products: $e');
    }
  }

  Future<void> fetchBestSellersIfEmpty() async {
    if (bestSellersProducts.isNotEmpty) return;
    try {
      final rankings = await _client.productRanking.getMostSellingProducts(
        limit: 10,
      );
      bestSellersProducts.assignAll(
        rankings.map((item) => item.product).toList(),
      );
    } catch (e) {
      debugPrint('Error fetching best sellers: $e');
    }
  }

  Future<void> fetchMostViewedIfEmpty() async {
    if (mostViewedProducts.isNotEmpty) return;
    try {
      final rankings = await _client.productRanking.getMostViewedProducts(
        limit: 10,
      );
      mostViewedProducts.assignAll(
        rankings.map((item) => item.product).toList(),
      );
    } catch (e) {
      debugPrint('Error fetching most viewed products: $e');
    }
  }

  Future<void> fetchFrequentlyReorderedIfEmpty() async {
    if (frequentlyReorderedProducts.isNotEmpty) return;
    try {
      final rankings = await _client.productRanking
          .getFrequentlyReorderedProducts(limit: 10);
      frequentlyReorderedProducts.assignAll(
        rankings.map((item) => item.product).toList(),
      );
    } catch (e) {
      debugPrint('Error fetching frequently reordered products: $e');
    }
  }

  Future<void> forceFetchProducts() async {
    if (_isFetching) return;
    clearProducts();
    _productCache.clear();
    trendingProducts.clear();
    bestSellersProducts.clear();
    mostViewedProducts.clear();
    frequentlyReorderedProducts.clear();

    _isFetching = true;
    try {
      await fetchProducts();
    } catch (e) {
      // error handled in fetchProducts
    } finally {
      _isFetching = false;
    }
  }

  void clearCache() {
    allProducts.clear();
    _productCache.clear();
    isMoreDataAvailable.value = true;
    errorMessage.value = '';
    _isFetching = false;
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
    if (!isMoreDataAvailable.value && allProducts.isNotEmpty) return;

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

      final existingIds = allProducts
          .map((p) => p.productId)
          .whereType<String>()
          .toSet();

      for (final product in newProducts) {
        final id = product.productId;
        if (id != null && !existingIds.contains(id)) {
          allProducts.add(product);
          existingIds.add(id);
        }
      }

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
    if (_isFetching) return;
    if (!isLoading.value && isMoreDataAvailable.value) {
      await fetchProducts();
    }
  }

  void clearProducts() {
    allProducts.clear();
    isMoreDataAvailable.value = true;
  }

  void refreshProducts() {
    if (_isFetching) return;
    final key = _cacheKey;
    if (_productCache.containsKey(key) && _productCache[key]!.isNotEmpty) {
      allProducts.assignAll(_productCache[key]!);
      isMoreDataAvailable.value = _productCache[key]!.length >= _cacheLimit;
    } else {
      clearProducts();
      fetchProductsIfEmpty();
    }
  }

  Future<void> resetHomeFeed() async {
    if (_isFetching) return;
    currentCategory.value = '';
    currentSubcategories.clear();
    currentSortBy.value = 'name';
    clearProducts();
    await fetchProductsIfEmpty();
  }

  bool get hasData => allProducts.isNotEmpty;
}
