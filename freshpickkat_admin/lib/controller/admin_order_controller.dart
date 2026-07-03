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

  RxString statusFilter = 'all'.obs;

  Future<void> loadInitial({String? status, bool force = false}) async {
    statusFilter.value = status ?? 'all';

    if (force) {
      _nextPageTokens[statusFilter.value] = null;
      _hasMoreMap[statusFilter.value] = true;
      _totalCounts[statusFilter.value] = 0;
    }

    nextPageToken.value = _nextPageTokens[statusFilter.value];
    totalCount.value = _totalCounts[statusFilter.value] ?? 0;
    hasMore.value = _hasMoreMap[statusFilter.value] ?? true;
    error.value = null;

    isLoading.value = true;
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
          forceRefresh: false,
        );
        return await _client.order.getOrdersPage(
          firebaseUid: uid,
          idToken: idToken,
          limit: pageSize,
          pageToken: nextPageToken.value,
          status: statusFilter.value == 'all' ? null : statusFilter.value,
        );
      });

      final bool isFirstPage = nextPageToken.value == null;

      _nextPageTokens[statusFilter.value] = page.nextPageToken;
      _totalCounts[statusFilter.value] = page.totalCount;
      _hasMoreMap[statusFilter.value] =
          page.nextPageToken != null && page.orders.isNotEmpty;

      nextPageToken.value = page.nextPageToken;
      totalCount.value = page.totalCount;
      hasMore.value = _hasMoreMap[statusFilter.value]!;

      // If it's the first page (initial or force), clear old orders for this status
      if (isFirstPage) {
        if (statusFilter.value == 'all') {
          orders.clear();
        } else {
          orders.removeWhere((o) => o.status == statusFilter.value);
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

  Future<bool> loadOrderForFocus(String orderId) async {
    final target = orderId.trim();
    if (target.isEmpty) return false;

    statusFilter.value = 'all';
    await loadInitial(status: 'all', force: true);
    if (orders.any((order) => order.orderId == target)) return true;

    var pagesScanned = 0;
    while (hasMore.value && pagesScanned < 25) {
      pagesScanned += 1;
      await loadMore();
      if (orders.any((order) => order.orderId == target)) return true;
    }

    return false;
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

  Future<bool> collectCodPayment(Order order, String collectionMode) async {
    return await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      return await _client.order.collectCodPayment(
        order.orderId,
        collectionMode,
        firebaseUid: uid,
        idToken: idToken,
      );
    });
  }

  Future<bool> generateDeliveryOtp(Order order) async {
    return await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      return await _client.order.generateDeliveryOtp(
        order.orderId,
        firebaseUid: uid,
        idToken: idToken,
      );
    });
  }

  Future<bool> markDeliveryPhotoPending(Order order) async {
    return await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      return await _client.order.markDeliveryPhotoPending(
        order.orderId,
        firebaseUid: uid,
        idToken: idToken,
      );
    });
  }

  Future<bool> cancelDeliveryPhotoPending(Order order) async {
    return await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      return await _client.order.cancelDeliveryPhotoPending(
        order.orderId,
        firebaseUid: uid,
        idToken: idToken,
      );
    });
  }

  Future<bool> verifyDeliveryOtp(Order order, String otp) async {
    return await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      return await _client.order.verifyDeliveryOtp(
        order.orderId,
        otp,
        firebaseUid: uid,
        idToken: idToken,
      );
    });
  }

  Future<bool> resendDeliveryOtp(Order order) async {
    return await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      return await _client.order.resendDeliveryOtp(
        order.orderId,
        firebaseUid: uid,
        idToken: idToken,
      );
    });
  }

  Future<Map<String, dynamic>?> getActiveDeliveryOtp(Order order) async {
    try {
      return await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await _client.order.getActiveDeliveryOtp(
          order.orderId,
          firebaseUid: uid,
          idToken: idToken,
        );
      });
    } catch (_) {
      return null;
    }
  }

  Future<RefundRecord?> getRefundStatus(String orderId) async {
    return await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      return await _client.refund.adminGetRefundStatus(orderId, uid, idToken);
    });
  }

  Future<RefundRecord> retryRefund(String orderId) async {
    return await ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );
      return await _client.refund.initiateRefund(orderId, uid, idToken);
    });
  }

  Future<void> startDelivery(Order order) async {
    if (!Get.isRegistered<DeliveryTrackingController>()) {
      await updateOrderStatus(order, 'out_for_delivery');
      return;
    }

    await Get.find<DeliveryTrackingController>().beginActualDelivery(
      order: order,
      onPromoteToOutForDelivery: () =>
          updateOrderStatus(order, 'out_for_delivery'),
    );
  }
}
