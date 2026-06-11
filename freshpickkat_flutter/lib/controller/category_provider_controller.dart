import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/error_messages.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class CategoryProviderController extends GetxController {
  // --------- SINGLETON PATTERN ---------
  static CategoryProviderController get instance =>
      Get.find<CategoryProviderController>();
  // -------------------------------------

  final Client _client = ServerpodClient().client;
  // States
  final categories = <Category>[].obs;
  final subCategories = <SubCategory>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Mutex lock to prevent duplicate API calls
  bool _isFetching = false;

  Future<void> fetchCategoriesIfEmpty() async {
    if (_isFetching) return;
    if (categories.isNotEmpty) return;
    if (isLoading.value) return;

    _isFetching = true;
    try {
      await _fetchHierarchy();
    } catch (e) {
      // error handled in _fetchHierarchy
    } finally {
      _isFetching = false;
    }
  }

  Future<void> forceFetchCategories() async {
    if (_isFetching) return;
    clearCache();

    _isFetching = true;
    try {
      await _fetchHierarchy();
    } catch (e) {
      // error handled in _fetchHierarchy
    } finally {
      _isFetching = false;
    }
  }

  void clearCache() {
    categories.clear();
    subCategories.clear();
    errorMessage.value = '';
    _isFetching = false;
  }

  Future<void> refreshData() async {
    if (_isFetching) return;

    _isFetching = true;
    try {
      await _fetchHierarchy();
    } catch (e) {
      // error handled in _fetchHierarchy
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _fetchHierarchy() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final hierarchy = await _client.category.getCategoryHierarchy();
      categories.assignAll(hierarchy.categories);
      subCategories.assignAll(hierarchy.subCategories);
    } catch (e) {
      errorMessage.value = ErrorMessages.loadFailed('categories');
      AppLogger.error('Categories', e);
    } finally {
      isLoading.value = false;
    }
  }

  void populateFromHydrated(HomePageHydratedData data) {
    categories.assignAll(data.categories);
    subCategories.assignAll(data.subCategories);
  }

  // Utility methods
  void clearData() {
    categories.clear();
    subCategories.clear();
  }

  bool get hasData => categories.isNotEmpty;
}
