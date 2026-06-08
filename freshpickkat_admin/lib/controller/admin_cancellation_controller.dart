import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:get/get.dart';

class AdminCancellationController extends GetxController {
  final _client = ServerpodAdminClient().client;

  final orders = <Order>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final error = RxnString();
  final hasMore = false.obs;

  String? _nextPageToken;

  Future<void> loadRequests() async {
    _nextPageToken = null;
    hasMore.value = false;
    isLoading.value = true;
    error.value = null;
    try {
      final page = await _fetchPage();
      orders.assignAll(page.orders);
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
    try {
      final page = await _fetchPage(pageToken: token);
      orders.addAll(page.orders);
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
      return _client.order.listCancellationRequests(
        firebaseUid: uid,
        idToken: token,
        limit: 20,
        pageToken: pageToken,
      );
    });
  }

  Future<PaymentActionResult> approve(
    String orderId, {
    String? adminNote,
    double? amountOverride,
  }) async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.order.approveCancellationRequest(
        orderId,
        firebaseUid: uid,
        idToken: token,
        adminNote: adminNote ?? '',
        fixedRefundAmount: amountOverride,
      );
    });
  }

  Future<PaymentActionResult> reject(
    String orderId, {
    String? adminNote,
  }) async {
    return ApiClient().request(() async {
      final uid = AdminSessionService.requireUid();
      final token = await AdminSessionService.requireIdToken();
      return _client.order.rejectCancellationRequest(
        orderId,
        firebaseUid: uid,
        idToken: token,
        adminNote: adminNote ?? '',
      );
    });
  }

  void reload() {
    loadRequests();
  }
}
