import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/services/search_history_service.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class SearchProviderController extends GetxController {
  static SearchProviderController get instance {
    if (!Get.isRegistered<SearchProviderController>()) {
      Get.put(SearchProviderController());
    }
    return Get.find<SearchProviderController>();
  }

  final Client _client = ServerpodClient().client;
  final SearchHistoryService _searchHistoryService;

  SearchProviderController({SearchHistoryService? searchHistoryService})
    : _searchHistoryService = searchHistoryService ?? SearchHistoryService();

  // States
  final searchResults = <Product>[].obs;
  final suggestions = <Product>[].obs;
  final offerResults = <OfferSearchItem>[].obs;
  final recentSearches = <String>[].obs;
  List<String> get recentSearchesList => recentSearches.toList();
  final isLoadingResults = false.obs;
  final isLoadingSuggestions = false.obs;
  final hasMoreResults = false.obs;
  final hasMoreSuggestions = false.obs;
  final hasMoreOfferResults = false.obs;
  final selectedFilter = ''.obs;
  RxString get selectedOfferFilter => selectedFilter;

  // UI States
  final expandedComboId = RxnString();

  String? _nextPageTokenResults;
  String? _nextPageTokenSuggestions;
  String? _nextPageTokenOfferResults;
  String _currentQuery = '';

  @override
  void onInit() {
    super.onInit();
    loadRecentSearch();
  }

  void loadRecentSearch() {
    recentSearches.assignAll(_searchHistoryService.loadRecentSearch());
  }

  Future<void> saveSearch(String query) async {
    recentSearches.assignAll(await _searchHistoryService.saveSearch(query));
  }

  Future<void> removeSearch(String query) async {
    recentSearches.assignAll(await _searchHistoryService.removeSearch(query));
  }

  Future<void> clearAll() async {
    await _searchHistoryService.clearAll();
    recentSearches.clear();
  }

  Future<void> fetchSuggestions(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      suggestions.clear();
      _nextPageTokenSuggestions = null;
      hasMoreSuggestions.value = false;
      return;
    }

    if (normalizedQuery == _currentQuery && suggestions.isNotEmpty) return;

    try {
      isLoadingSuggestions.value = true;
      _currentQuery = normalizedQuery;

      final result = await _client.product.searchProducts(
        normalizedQuery,
        limit: 15,
      );

      suggestions.assignAll(result.products);
      _nextPageTokenSuggestions = result.nextPageToken;
      hasMoreSuggestions.value = result.nextPageToken != null;
    } catch (e) {
      AppLogger.error('Search', 'Suggestions: $e');
      suggestions.clear();
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  Future<void> loadMoreSuggestions() async {
    if (isLoadingSuggestions.value || _nextPageTokenSuggestions == null) return;

    try {
      isLoadingSuggestions.value = true;
      final result = await _client.product.searchProducts(
        _currentQuery,
        limit: 15,
        pageToken: _nextPageTokenSuggestions,
      );

      suggestions.addAll(result.products);
      _nextPageTokenSuggestions = result.nextPageToken;
      hasMoreSuggestions.value = result.nextPageToken != null;
    } catch (e) {
      AppLogger.error('Search', 'MoreSuggestions: $e');
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) return;

    try {
      isLoadingResults.value = true;
      _currentQuery = normalizedQuery;
      selectedOfferFilter.value =
          ''; // Clear offer filter when searching general

      final result = await _client.product.searchProducts(
        normalizedQuery,
        limit: 20,
      );

      searchResults.assignAll(result.products);
      _nextPageTokenResults = result.nextPageToken;
      hasMoreResults.value = result.nextPageToken != null;
      await saveSearch(normalizedQuery);
    } catch (e) {
      AppLogger.error('Search', 'Products: $e');
      searchResults.clear();
    } finally {
      isLoadingResults.value = false;
    }
  }

  Future<void> loadMoreResults() async {
    if (isLoadingResults.value || _nextPageTokenResults == null) return;

    try {
      isLoadingResults.value = true;
      final result = await _client.product.searchProducts(
        _currentQuery,
        limit: 20,
        pageToken: _nextPageTokenResults,
      );

      searchResults.addAll(result.products);
      _nextPageTokenResults = result.nextPageToken;
      hasMoreResults.value = result.nextPageToken != null;
    } catch (e) {
      AppLogger.error('Search', 'MoreResults: $e');
    } finally {
      isLoadingResults.value = false;
    }
  }

  Future<void> selectOfferFilter(String filter, {String query = ''}) async {
    selectedOfferFilter.value = selectedOfferFilter.value == filter
        ? ''
        : filter;
    expandedComboId.value = null;

    if (selectedOfferFilter.value.isNotEmpty) {
      offerResults.clear();
      await searchProductsWithOfferFilter(query);
    } else if (query.trim().isNotEmpty) {
      await searchProducts(query);
    }
  }

  void toggleComboExpansion(String comboId) {
    if (expandedComboId.value == comboId) {
      expandedComboId.value = null;
    } else {
      expandedComboId.value = comboId;
    }
  }

  Future<void> searchProductsWithOfferFilter(String query) async {
    final filter = selectedOfferFilter.value.trim();
    if (filter.isEmpty) return;

    try {
      isLoadingResults.value = true;
      final normalizedQuery = query.trim();
      _currentQuery = normalizedQuery;

      if (filter == 'trending' || filter == 'best_seller') {
        final ranked = filter == 'trending'
            ? await _client.productRanking.getTrendingProducts(limit: 20)
            : await _client.productRanking.getMostSellingProducts(limit: 20);

        offerResults.assignAll(
          ranked.map(
            (item) => OfferSearchItem(offerType: filter, product: item.product),
          ),
        );
        _nextPageTokenOfferResults = null;
        hasMoreOfferResults.value = false;
        if (normalizedQuery.isNotEmpty) await saveSearch(normalizedQuery);
        return;
      }

      final result = await _client.product.searchProductsWithOfferFilters(
        query: normalizedQuery,
        offerFilter: filter,
        limit: 20,
      );

      offerResults.assignAll(result.items);
      _nextPageTokenOfferResults = result.nextPageToken;
      hasMoreOfferResults.value = result.nextPageToken != null;
      if (normalizedQuery.isNotEmpty) await saveSearch(normalizedQuery);
    } catch (e) {
      AppLogger.error('Search', 'OfferProducts(filter=$filter, query=$query): $e');
      offerResults.clear();
    } finally {
      isLoadingResults.value = false;
    }
  }

  Future<void> loadMoreOfferResults() async {
    if (isLoadingResults.value || _nextPageTokenOfferResults == null) return;

    try {
      isLoadingResults.value = true;
      final result = await _client.product.searchProductsWithOfferFilters(
        query: _currentQuery,
        offerFilter: selectedOfferFilter.value,
        limit: 20,
        pageToken: _nextPageTokenOfferResults,
      );

      offerResults.addAll(result.items);
      _nextPageTokenOfferResults = result.nextPageToken;
      hasMoreOfferResults.value = result.nextPageToken != null;
    } catch (e) {
      AppLogger.error('Search', 'MoreOffer: $e');
    } finally {
      isLoadingResults.value = false;
    }
  }

  void clearSearch() {
    searchResults.clear();
    suggestions.clear();
    offerResults.clear();
    _nextPageTokenResults = null;
    _nextPageTokenSuggestions = null;
    _nextPageTokenOfferResults = null;
    hasMoreResults.value = false;
    hasMoreSuggestions.value = false;
    hasMoreOfferResults.value = false;
    _currentQuery = '';
    selectedOfferFilter.value = '';
    expandedComboId.value = null;
  }
}
