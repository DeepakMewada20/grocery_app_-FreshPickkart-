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

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }

    try {
      isLoadingSuggestions.value = true;
      // Using searchProducts to get full product objects instead of just names
      final result = await _client.product.searchProducts(query);
      suggestions.assignAll(result);
    } catch (e) {
      print('Error fetching suggestions: $e');
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

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
    }
  }

  void clearSearch() {
    suggestions.clear();
    searchResults.clear();
    errorMessage.value = '';
  }
}
