import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/widgets/shared_dialogs.dart';
import '../services/api_client.dart';
import '../core/exceptions.dart';
import 'network_controller.dart';

/// A simple data holder for a subcategory's display name and image URL.
class SubcategoryOptionData {
  final String name;
  final String imageUrl;
  final List<String> names;

  const SubcategoryOptionData({
    required this.name,
    required this.imageUrl,
    required this.names,
  });
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

  List<List<String>> groupedSubcategoryOptionsFor(String categoryName) {
    return subCategories
        .where((s) => s.categoryId == categoryName)
        .map((s) => s.subCategoriesName)
        .toList();
  }

  /// Returns subcategory options with image URLs for the given category name.
  /// Each subcategory name appears as a separate entry. Entries sharing the
  /// same image URL are grouped together consecutively.
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
            names: [name],
          ),
        );
      }
    }
    result.sort((a, b) {
      final imageCmp = a.imageUrl.compareTo(b.imageUrl);
      if (imageCmp != 0) return imageCmp;
      return a.name.compareTo(b.name);
    });
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

  Future<bool> deleteCategory(String categoryName) async {
    try {
      final message = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await _client.category.deleteCategory(
          categoryName,
          uid,
          idToken,
        );
      });
      if (message.isEmpty) {
        await loadCategories();
        return true;
      }
      final shouldDeactivate = await showDeactivationDialog(
        title: 'Category In Use',
        message: message,
      );
      if (shouldDeactivate) {
        await setCategoryActive(categoryName, false);
        await loadCategories();
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setCategoryActive(String categoryName, bool isActive) async {
    try {
      return await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await _client.category.setCategoryActive(
          categoryName,
          isActive,
          uid,
          idToken,
        );
      });
    } catch (e) {
      return false;
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

  Future<bool> deleteSubCategory(
    String categoryName,
    String subCategoryName,
  ) async {
    try {
      final message = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await _client.subCategory.deleteSubCategory(
          categoryName,
          subCategoryName,
          uid,
          idToken,
        );
      });
      if (message.isEmpty) {
        await loadCategories();
        return true;
      }
      final shouldDeactivate = await showDeactivationDialog(
        title: 'Sub-Category In Use',
        message: message,
      );
      if (shouldDeactivate) {
        await setCategoryActive(categoryName, false);
        await loadCategories();
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
