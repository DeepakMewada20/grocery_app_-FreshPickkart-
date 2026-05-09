import 'package:freshpickkat_client/freshpickkat_client.dart';
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

  final suggestions = <Product>[].obs;
  final searchResults = <Product>[].obs;
  final offerResults = <OfferSearchItem>[].obs;
  final isLoadingSuggestions = false.obs;
  final isLoadingResults = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;
  final selectedOfferFilter = ''.obs;

  final hasMoreSuggestions = false.obs;
  final hasMoreResults = false.obs;
  final hasMoreOfferResults = false.obs;
  String? _nextPageTokenSuggestions;
  String? _nextPageTokenResults;
  String? _nextPageTokenOfferResults;
  String _currentQuery = '';
  String _lastOfferRequestKey = '';

  bool _isFetchingSuggestions = false;
  bool _isFetchingResults = false;
  bool _isFetchingOfferResults = false;

  static const int _pageSize = 20;

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }

    _currentQuery = query;
    if (_isFetchingSuggestions) return;

    _isFetchingSuggestions = true;
    try {
      isLoadingSuggestions.value = true;
      final result = await _client.product.searchProducts(
        query,
        limit: _pageSize,
        pageToken: null,
      );
      suggestions.assignAll(result.products);
      _nextPageTokenSuggestions = result.nextPageToken;
      hasMoreSuggestions.value = result.nextPageToken != null;
    } catch (e) {
      print('Error fetching suggestions: $e');
      suggestions.clear();
    } finally {
      isLoadingSuggestions.value = false;
      _isFetchingSuggestions = false;
    }
  }

  Future<void> loadMoreSuggestions() async {
    if (_currentQuery.isEmpty || _nextPageTokenSuggestions == null) return;
    if (_isFetchingSuggestions || isLoadingMore.value) return;

    isLoadingMore.value = true;
    try {
      final result = await _client.product.searchProducts(
        _currentQuery,
        limit: _pageSize,
        pageToken: _nextPageTokenSuggestions,
      );
      suggestions.addAll(result.products);
      _nextPageTokenSuggestions = result.nextPageToken;
      hasMoreSuggestions.value = result.nextPageToken != null;
    } catch (e) {
      print('Error loading more suggestions: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    _currentQuery = query;
    if (_isFetchingResults) return;

    _isFetchingResults = true;
    try {
      isLoadingResults.value = true;
      errorMessage.value = '';
      final result = await _client.product.searchProducts(
        query,
        limit: _pageSize,
        pageToken: null,
      );
      searchResults.assignAll(result.products);
      _nextPageTokenResults = result.nextPageToken;
      hasMoreResults.value = result.nextPageToken != null;
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error searching products: $e');
      searchResults.clear();
    } finally {
      isLoadingResults.value = false;
      _isFetchingResults = false;
    }
  }

  Future<void> selectOfferFilter(String filter, {String query = ''}) async {
    selectedOfferFilter.value = selectedOfferFilter.value == filter
        ? ''
        : filter;
    _nextPageTokenOfferResults = null;
    offerResults.clear();
    _lastOfferRequestKey = '';
    if (selectedOfferFilter.value.isNotEmpty) {
      await searchProductsWithOfferFilter(query);
    } else if (query.trim().length >= 2) {
      await searchProducts(query);
    }
  }

  Future<void> searchProductsWithOfferFilter(String query) async {
    final filter = selectedOfferFilter.value.trim();
    if (filter.isEmpty) {
      offerResults.clear();
      return;
    }
    final normalizedQuery = query.trim();
    final requestKey = '$filter::$normalizedQuery::first';
    if (_lastOfferRequestKey == requestKey && offerResults.isNotEmpty) return;
    if (_isFetchingOfferResults) return;

    _currentQuery = normalizedQuery;
    _isFetchingOfferResults = true;
    try {
      isLoadingResults.value = true;
      errorMessage.value = '';
      final result = await _client.product.searchProductsWithOfferFilters(
        query: normalizedQuery,
        offerFilter: filter,
        limit: _pageSize,
        pageToken: null,
      );
      offerResults.assignAll(result.items);
      _nextPageTokenOfferResults = result.nextPageToken;
      hasMoreOfferResults.value = result.nextPageToken != null;
      _lastOfferRequestKey = requestKey;
    } catch (e) {
      errorMessage.value = e.toString();
      offerResults.clear();
    } finally {
      isLoadingResults.value = false;
      _isFetchingOfferResults = false;
    }
  }

  Future<void> loadMoreOfferResults() async {
    final filter = selectedOfferFilter.value.trim();
    if (filter.isEmpty || _nextPageTokenOfferResults == null) return;
    if (_isFetchingOfferResults || isLoadingMore.value) return;

    isLoadingMore.value = true;
    try {
      final result = await _client.product.searchProductsWithOfferFilters(
        query: _currentQuery,
        offerFilter: filter,
        limit: _pageSize,
        pageToken: _nextPageTokenOfferResults,
      );
      offerResults.addAll(result.items);
      _nextPageTokenOfferResults = result.nextPageToken;
      hasMoreOfferResults.value = result.nextPageToken != null;
    } catch (e) {
      print('Error loading more offer results: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreResults() async {
    if (_currentQuery.isEmpty || _nextPageTokenResults == null) return;
    if (_isFetchingResults || isLoadingMore.value) return;

    isLoadingMore.value = true;
    try {
      final result = await _client.product.searchProducts(
        _currentQuery,
        limit: _pageSize,
        pageToken: _nextPageTokenResults,
      );
      searchResults.addAll(result.products);
      _nextPageTokenResults = result.nextPageToken;
      hasMoreResults.value = result.nextPageToken != null;
    } catch (e) {
      print('Error loading more results: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void clearSearch() {
    suggestions.clear();
    searchResults.clear();
    offerResults.clear();
    errorMessage.value = '';
    selectedOfferFilter.value = '';
    _nextPageTokenSuggestions = null;
    _nextPageTokenResults = null;
    _nextPageTokenOfferResults = null;
    hasMoreSuggestions.value = false;
    hasMoreResults.value = false;
    hasMoreOfferResults.value = false;
    _currentQuery = '';
    _lastOfferRequestKey = '';
  }
}
