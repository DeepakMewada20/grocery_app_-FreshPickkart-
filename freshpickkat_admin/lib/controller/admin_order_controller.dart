import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../services/api_client.dart';
import '../core/exceptions.dart';
import 'network_controller.dart';

class AdminOrderController extends GetxController {
  static AdminOrderController get instance => Get.find<AdminOrderController>();

  final _client = ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminOrderController',
  );
  final int pageSize = 20;

  final RxList<Order> orders = <Order>[].obs;
  final RxnString nextPageToken = RxnString(null);
  final RxInt totalCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxnString error = RxnString(null);

  String statusFilter = 'all';

  Future<void> loadInitial({String? status}) async {
    statusFilter = status ?? 'all';

    orders.clear();
    nextPageToken.value = null;
    totalCount.value = 0;
    hasMore.value = true;
    error.value = null;

    await loadMore(isInitial: true);
  }

  Future<void> loadMore({bool isInitial = false}) async {
    if (isLoadingMore.value) return;
    if (!hasMore.value && !isInitial) return;

    if (isInitial || orders.isEmpty) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    networkController.hideError();

    try {
      final page = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: true,
        );       
        return await _client.order.getOrdersPage(
          firebaseUid: uid,
          idToken: idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
          status: statusFilter == 'all' ? null : statusFilter,
        );
      });

      if (isInitial) orders.clear();
      orders.addAll(page.orders);
      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = page.nextPageToken != null && page.orders.isNotEmpty;
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
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> updateOrderStatus(
    Order order,
    String status, {
    String? cancellationReason,
  }) async {
    try {
      await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: true,
        );
        await _client.order.updateOrderStatus(
          order.orderId,
          status,
          cancellationReason: cancellationReason,
          firebaseUid: uid,
          idToken: idToken,
        );
      });

      // Update local item
      final index = orders.indexWhere((o) => o.orderId == order.orderId);
      if (index != -1) {
        orders[index] = order.copyWith(
          status: status,
          cancellationReason: cancellationReason,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
