import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';

class AdminProductController extends GetxController {
  static AdminProductController get instance =>
      Get.find<AdminProductController>();

  final _client = ServerpodAdminClient().client;
  final int pageSize = 20;

  final RxList<Product> products = <Product>[].obs;
  final RxnString nextPageToken = RxnString(null);
  final RxInt totalCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxnString error = RxnString(null);

  String categoryFilter = 'All';

  Future<void> loadInitial({String? category}) async {
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

    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );

      final page = await _client.product.getProductsPage(
        firebaseUid: uid,
        idToken: idToken,
        limit: pageSize,
        pageToken: nextPageToken.value,
        sortBy: 'name',
        category: categoryFilter == 'All' ? null : categoryFilter,
      );

      if (isInitial) {
        products.assignAll(page.products);
      } else {
        products.addAll(page.products);
      }
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.products.isNotEmpty;
      error.value = null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      await _client.product.uploadProduct(product, uid, idToken);
      // Refresh list
      await loadInitial(category: categoryFilter);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      await _client.product.updateProduct(product, uid, idToken);

      // Update local item to avoid full reload if possible,
      // but simpler is to just refresh the current page or specific item.
      final index = products.indexWhere(
        (p) => p.productId == product.productId,
      );
      if (index != -1) {
        products[index] = product;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      await _client.product.deleteProduct(productId, uid, idToken);
      products.removeWhere((p) => p.productId == productId);
      totalCount.value--;
    } catch (e) {
      rethrow;
    }
  }
}
