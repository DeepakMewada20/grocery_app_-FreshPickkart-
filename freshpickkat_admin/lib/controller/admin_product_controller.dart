import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../services/api_client.dart';
import '../core/exceptions.dart';
import '../widgets/delete_impact_dialog.dart';
import '../widgets/shared_dialogs.dart';
import 'network_controller.dart';

class AdminProductController extends GetxController {
  static AdminProductController get instance =>
      Get.find<AdminProductController>();

  final _client = ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminProductController',
  );
  final int pageSize = 20;

  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> inactiveProducts = <Product>[].obs;
  final RxnString nextPageToken = RxnString(null);
  final RxInt totalCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxnString error = RxnString(null);
  final RxBool isLoadingInactive = false.obs;

  String categoryFilter = 'All';

  bool _matchesCurrentFilter(Product product) {
    return categoryFilter == 'All' || product.category == categoryFilter;
  }

  void _sortProducts() {
    products.sort(
      (a, b) =>
          a.productName.toLowerCase().compareTo(b.productName.toLowerCase()),
    );
  }

  void _upsertLocalProduct(Product product) {
    final index = products.indexWhere((p) => p.productId == product.productId);
    final matchesFilter = _matchesCurrentFilter(product);

    if (!matchesFilter) {
      if (index != -1) {
        products.removeAt(index);
        if (totalCount.value > 0) totalCount.value--;
      }
      return;
    }

    if (index != -1) {
      products[index] = product;
    } else {
      products.add(product);
      totalCount.value++;
    }
    _sortProducts();
  }

  Future<void> loadInitial({String? category}) async {
    if (isLoading.value) return;
    categoryFilter = category ?? 'All';

    products.clear();
    nextPageToken.value = null;
    totalCount.value = 0;
    hasMore.value = true;
    error.value = null;

    await loadMore(isInitial: true);
  }

  Future<void> loadMore({bool isInitial = false}) async {
    if (isLoadingMore.value) return;
    if (!hasMore.value && !isInitial) return;

    if (isInitial || products.isEmpty) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    networkController.hideError();

    try {
      final page = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );

        return await _client.product.getProductsPage(
          firebaseUid: uid,
          idToken: idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
          sortBy: 'name',
          category: categoryFilter == 'All' ? null : categoryFilter,
        );
      });

      if (isInitial) {
        products.assignAll(page.products);
      } else {
        products.addAll(page.products);
      }
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.products.isNotEmpty;
      error.value = null;
    } on NoInternetException {
      networkController.showError(
        onRetry: () => loadMore(isInitial: isInitial),
      );
    } on NetworkException {
      networkController.showError(
        onRetry: () => loadMore(isInitial: isInitial),
      );
    } on RequestTimeoutException {
      networkController.showError(
        onRetry: () => loadMore(isInitial: isInitial),
      );
    } catch (e) {
      error.value = _friendlyLoadError(e);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadInactiveProducts() async {
    if (isLoadingInactive.value) return;
    isLoadingInactive.value = true;
    error.value = null;
    try {
      final page = await ApiClient().request(() async {
        return await _client.product.getInactiveProductsPage(
          limit: 200,
          sortBy: 'name',
        );
      });
      inactiveProducts.assignAll(page.products);
    } on NoInternetException {
      networkController.showError(onRetry: loadInactiveProducts);
    } on NetworkException {
      networkController.showError(onRetry: loadInactiveProducts);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadInactiveProducts);
    } catch (e) {
      error.value = _friendlyLoadError(e);
    } finally {
      isLoadingInactive.value = false;
    }
  }

  String _friendlyLoadError(Object error) {
    final raw = error.toString().toLowerCase();
    if (raw.contains('internal server error') ||
        raw.contains('status code 500') ||
        raw.contains('serverpodclientexception')) {
      return 'Unable to load products right now. Please try again.';
    }
    return 'Unable to load products right now. Please try again.';
  }

  Future<Product?> addProduct(Product product) async {
    try {
      final newId = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await _client.product.uploadProduct(product, uid, idToken);
      });
      if (newId == null || newId.trim().isEmpty) return null;
      final createdProduct = product.copyWith(productId: newId);
      _upsertLocalProduct(createdProduct);
      return createdProduct;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );

      // Step 1: Check for variant conflicts before updating
      final conflictMessage = await ApiClient().request<String>(() async {
        return _client.product.checkProductUpdateConflicts(
          product,
          uid,
          idToken,
        );
      });

      if (conflictMessage.isNotEmpty) {
        final shouldProceed = await showDeactivationDialog(
          title: 'Variants In Use',
          message: conflictMessage,
        );
        if (!shouldProceed) return;
      }

      // Step 2: Actually update — server returns the full hydrated product
      final updatedProduct = await ApiClient().request<Product?>(() async {
        return _client.product.updateProduct(product, uid, idToken);
      });

      if (updatedProduct != null) {
        _upsertLocalProduct(updatedProduct);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> deleteProduct(String productId) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );

      final impact = await _client.product.checkProductDeleteImpact(
        productId,
        uid,
        idToken,
      );

      final choice = await showDeleteImpactDialog(
        context: Get.context!,
        impact: impact,
        entityName: 'Product',
      );

      switch (choice) {
        case DeleteChoice.hardDelete:
          final result = await _client.product.hardDeleteProduct(
            productId,
            uid,
            idToken,
          );
          if (result.success) {
            products.removeWhere((p) => p.productId == productId);
            totalCount.value--;
            return null;
          }
          return false;
        case DeleteChoice.softDelete:
          await deactivateProduct(productId, false);
          return true;
        case DeleteChoice.cancel:
          return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deactivateProduct(String productId, bool isActive) async {
    try {
      await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken();
        await _client.product.deactivateProduct(productId, isActive, uid, idToken);
      });
    } catch (e) {
      rethrow;
    }
  }
}
