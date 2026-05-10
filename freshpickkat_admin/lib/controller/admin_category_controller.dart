import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../services/api_client.dart';
import '../core/exceptions.dart';
import 'network_controller.dart';

/// A simple data holder for a subcategory's display name and image URL.
class SubcategoryOptionData {
  final String name;
  final String imageUrl;

  const SubcategoryOptionData({required this.name, required this.imageUrl});
}

class AdminCategoryController extends GetxController {
  static AdminCategoryController get instance =>
      Get.find<AdminCategoryController>();

  final _client = ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminCategoryController',
  );

  final RxList<Category> categories = <Category>[].obs;
  final RxList<SubCategory> subCategories = <SubCategory>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString(null);

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    error.value = null;
    networkController.hideError();
    try {
      final results = await ApiClient().request(() async {
        return await Future.wait([
          _client.category.getCategories(),
          _client.subCategory.getSubCategories(),
        ]);
      });
      categories.assignAll(results[0] as List<Category>);
      subCategories.assignAll(results[1] as List<SubCategory>);
    } on NoInternetException {
      networkController.showError(onRetry: loadCategories);
    } on NetworkException {
      networkController.showError(onRetry: loadCategories);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadCategories);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  List<String> subcategoryOptionsFor(String categoryName) {
    return subCategories
        .where((s) => s.categoryId == categoryName)
        .expand((s) => s.subCategoriesName)
        .toList()
      ..sort();
  }

  List<List<String>> groupedSubcategoryOptionsFor(String categoryName) {
    return subCategories
        .where((s) => s.categoryId == categoryName)
        .map((s) => s.subCategoriesName)
        .toList();
  }

  /// Returns subcategory options with image URLs for the given category name.
  List<SubcategoryOptionData> subcategoryOptionsWithImagesFor(
    String categoryName,
  ) {
    final result = <SubcategoryOptionData>[];
    for (final sub in subCategories) {
      if (sub.categoryId != categoryName) continue;
      for (final name in sub.subCategoriesName) {
        result.add(
          SubcategoryOptionData(
            name: name,
            imageUrl: sub.subCategoriesUrl,
          ),
        );
      }
    }
    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }

  Future<void> uploadCategory(Category category) async {
    try {
      await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        await _client.category.uploadCategory(category, uid, idToken);
      });
      await loadCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategory(String oldName, Category category) async {
    try {
      await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        await _client.category.updateCategory(oldName, category, uid, idToken);
      });
      await loadCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCategory(String categoryName) async {
    try {
      await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        await _client.category.deleteCategory(categoryName, uid, idToken);
      });
      await loadCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> uploadSubCategory(SubCategory subCategory) async {
    try {
      await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        await _client.subCategory.uploadSubCategory(subCategory, uid, idToken);
      });
      await loadCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSubCategory(
    String categoryName,
    String oldSubName,
    SubCategory subCategory,
  ) async {
    try {
      await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        await _client.subCategory.updateSubCategory(
          categoryName,
          oldSubName,
          subCategory,
          uid,
          idToken,
        );
      });
      await loadCategories();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSubCategory(
    String categoryName,
    String subCategoryName,
  ) async {
    try {
      await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        await _client.subCategory.deleteSubCategory(
          categoryName,
          subCategoryName,
          uid,
          idToken,
        );
      });
      await loadCategories();
    } catch (e) {
      rethrow;
    }
  }
}
