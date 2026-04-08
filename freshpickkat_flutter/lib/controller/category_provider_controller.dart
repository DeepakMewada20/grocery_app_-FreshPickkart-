import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class CategoryProviderController extends GetxController {
  // --------- SINGLETON PATTERN ---------
  static CategoryProviderController get instance =>
      Get.put(CategoryProviderController(), permanent: true);
  // -------------------------------------

  final Client _client = ServerpodClient().client;
  // States
  final categories = <Category>[].obs;
  final subCategories = <SubCategory>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchCategoriesIfEmpty() async {
    if (categories.isEmpty && !isLoading.value) {
      await fetchCategories();
    }
  }

  Future<void> forceFetchCategories() async {
    clearCache();
    await Future.wait([
      fetchCategories(),
      fetchSubCategories(),
    ]);
  }

  void clearCache() {
    categories.clear();
    subCategories.clear();
    errorMessage.value = '';
  }

  Future<void> refreshData() async {
    await Future.wait([
      fetchCategories(),
      fetchSubCategories(),
    ]);
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final List<Category> result = await _client.category.getCategories();

      categories.assignAll(result);
      print('Categories fetched: ${result.length}');
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final List<SubCategory> result = await _client.subCategory
          .getSubCategories();

      subCategories.assignAll(result);
      print('SubCategories fetched: ${result.length}');
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Utility methods
  void clearData() {
    categories.clear();
    subCategories.clear();
  }

  bool get hasData => categories.isNotEmpty;
}
