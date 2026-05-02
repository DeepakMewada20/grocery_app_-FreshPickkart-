import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/tracking/controllers/delivery_tracking_controller.dart';
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

  final Map<String, String?> _nextPageTokens = {};
  final Map<String, bool> _hasMoreMap = {};
  final Map<String, int> _totalCounts = {};

  String statusFilter = 'all';

  Future<void> loadInitial({String? status, bool force = false}) async {
    statusFilter = status ?? 'all';

    if (force) {
      _nextPageTokens[statusFilter] = null;
      _hasMoreMap[statusFilter] = true;
      _totalCounts[statusFilter] = 0;
    }

    final currentFilteredCount = orders.where((o) {
      if (statusFilter == 'all') return true;
      return o.status == statusFilter;
    }).length;

    nextPageToken.value = _nextPageTokens[statusFilter];
    totalCount.value = _totalCounts[statusFilter] ?? 0;
    hasMore.value = _hasMoreMap[statusFilter] ?? true;
    error.value = null;

    if (currentFilteredCount < 10 && hasMore.value) {
      await loadMore(isInitial: orders.isEmpty);
    }
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
          forceRefresh: false,
        );
        return await _client.order.getOrdersPage(
          firebaseUid: uid,
          idToken: idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
          status: statusFilter == 'all' ? null : statusFilter,
        );
      });

      final bool isFirstPage = nextPageToken.value == null;

      _nextPageTokens[statusFilter] = page.nextPageToken;
      _totalCounts[statusFilter] = page.totalCount;
      _hasMoreMap[statusFilter] =
          page.nextPageToken != null && page.orders.isNotEmpty;

      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = _hasMoreMap[statusFilter]!;

      // If it's the first page (initial or force), clear old orders for this status
      if (isFirstPage) {
        if (statusFilter == 'all') {
          orders.clear();
        } else {
          orders.removeWhere((o) => o.status == statusFilter);
        }
      }

      for (final newOrder in page.orders) {
        final index = orders.indexWhere((o) => o.orderId == newOrder.orderId);
        if (index != -1) {
          orders[index] = newOrder;
        } else {
          orders.add(newOrder);
        }
      }

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
          forceRefresh: false,
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

      if (Get.isRegistered<DeliveryTrackingController>()) {
        await Get.find<DeliveryTrackingController>().syncOrderStatus(
          orderId: order.orderId,
          status: status,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startDelivery(Order order) async {
    if (!Get.isRegistered<DeliveryTrackingController>()) {
      throw StateError('Delivery tracking controller is not available');
    }

    await Get.find<DeliveryTrackingController>().beginActualDelivery(
      order: order,
      onPromoteToOutForDelivery: () =>
          updateOrderStatus(order, 'out_for_delivery'),
    );
  }
}
