import 'dart:async';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class AdminPaymentMonitoringController extends GetxController {
  final _client = ServerpodAdminClient().client;

  final orders = <Order>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final error = RxnString();
  final hasMore = false.obs;
  final totalCount = 0.obs;

  final searchQuery = RxString('');
  final statusFilter = RxString('');
  final paymentStatusFilter = RxString('');

  String? _nextPageToken;
  Timer? _debounce;

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      searchQuery.value = value;
      load();
    });
  }

  void setStatusFilter(String? status) {
    statusFilter.value = status ?? '';
    load();
  }

  void setPaymentStatusFilter(String? paymentStatus) {
    paymentStatusFilter.value = paymentStatus ?? '';
    load();
  }

  Future<void> load() async {
    _nextPageToken = null;
    hasMore.value = false;
    isLoading.value = true;
    error.value = null;
    try {
      final page = await _fetchPage();
      orders.assignAll(page.orders);
      totalCount.value = page.totalCount;
      _nextPageToken = page.nextPageToken;
      hasMore.value = page.nextPageToken != null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    final token = _nextPageToken;
    if (token == null || isLoadingMore.value) return;
    isLoadingMore.value = true;
    error.value = null;
    try {
      final page = await _fetchPage(pageToken: token);
      orders.addAll(page.orders);
      totalCount.value = page.totalCount;
      _nextPageToken = page.nextPageToken;
      hasMore.value = page.nextPageToken != null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<OrderPage> _fetchPage({String? pageToken}) async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.payment.adminSearchOrders(
        firebaseUid: uid,
        idToken: token,
        query: searchQuery.value.isEmpty ? null : searchQuery.value,
        status: statusFilter.value.isEmpty ? null : statusFilter.value,
        paymentStatus:
            paymentStatusFilter.value.isEmpty
                ? null
                : paymentStatusFilter.value,
        limit: 20,
        pageToken: pageToken,
      );
    });
  }

  Future<Map<String, dynamic>> getPaymentDetail(String orderId) async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.payment.adminGetPaymentDetail(
        orderId,
        firebaseUid: uid,
        idToken: token,
      );
    });
  }

  Future<PaymentActionResult> getLivePaymentStatus(
    String razorpayPaymentId,
  ) async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.payment.adminGetLivePaymentStatus(
        razorpayPaymentId,
        firebaseUid: uid,
        idToken: token,
      );
    });
  }

  Future<Map<String, dynamic>> getRefundDetail(String orderId) async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.payment.adminGetRefundDetail(
        orderId,
        firebaseUid: uid,
        idToken: token,
      );
    });
  }

  Future<PaymentActionResult> reconcileAll() async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.payment.adminReconcileAllPendingPayments(
        firebaseUid: uid,
        idToken: token,
      );
    });
  }
}
