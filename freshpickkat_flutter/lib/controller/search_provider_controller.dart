import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class SearchProviderController extends GetxController {
  static SearchProviderController get instance =>
      Get.put(SearchProviderController(), permanent: true);

  final Client _client = ServerpodClient().client;

  final suggestions = <Product>[].obs;
  final searchResults = <Product>[].obs;
  final isLoadingSuggestions = false.obs;
  final isLoadingResults = false.obs;
  final errorMessage = ''.obs;

  // Mutex lock to prevent duplicate API calls
  bool _isFetchingSuggestions = false;
  bool _isFetchingResults = false;

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }
    if (_isFetchingSuggestions) return;

    _isFetchingSuggestions = true;
    try {
      isLoadingSuggestions.value = true;
      // Using searchProducts to get full product objects instead of just names
      final result = await _client.product.searchProducts(query);
      suggestions.assignAll(result);
    } catch (e) {
      print('Error fetching suggestions: $e');
    } finally {
      isLoadingSuggestions.value = false;
      _isFetchingSuggestions = false;
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    if (_isFetchingResults) return;

    _isFetchingResults = true;
    try {
      isLoadingResults.value = true;
      errorMessage.value = '';
      final result = await _client.product.searchProducts(query);
      searchResults.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error searching products: $e');
    } finally {
      isLoadingResults.value = false;
      _isFetchingResults = false;
    }
  }

  void clearSearch() {
    suggestions.clear();
    searchResults.clear();
    errorMessage.value = '';
  }
}
