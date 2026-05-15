import 'package:freshpickkat_admin/controller/network_controller.dart';
import 'package:freshpickkat_admin/core/exceptions.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';

class AdminCouponController extends GetxController {
  static AdminCouponController get instance =>
      Get.find<AdminCouponController>();

  final _client = ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminCouponController',
  );

  final RxList<Coupon> coupons = <Coupon>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString(null);

  @override
  void onInit() {
    super.onInit();
    loadCoupons();
  }

  Future<void> loadCoupons({bool force = false}) async {
    if (!force && coupons.isNotEmpty) return;
    if (isLoading.value) return;
    isLoading.value = true;
    error.value = null;
    networkController.hideError();
    try {
      final result = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await _client.coupon.fetchCoupons(uid, idToken);
      });
      coupons.assignAll(result);
    } on NoInternetException {
      networkController.showError(onRetry: loadCoupons);
    } on NetworkException {
      networkController.showError(onRetry: loadCoupons);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadCoupons);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadCoupon(
    Coupon coupon, {
    NotificationDraft? notificationDraft,
  }) async {
    try {
      await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        await _client.coupon.uploadCoupon(
          coupon,
          uid,
          idToken,
          notificationDraft: notificationDraft,
        );
      });
      await loadCoupons(force: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> setCouponActive(String code, bool isActive) async {
    try {
      final ok = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await _client.coupon.setCouponActive(
          code,
          isActive,
          uid,
          idToken,
        );
      });
      if (ok) {
        final index = coupons.indexWhere((c) => c.code == code);
        if (index != -1) {
          coupons[index] = coupons[index].copyWith(isActive: isActive);
        }
      }
      return ok;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateCoupon(
    Coupon updated, {
    NotificationDraft? notificationDraft,
  }) async {
    try {
      final ok = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await _client.coupon.updateCoupon(updated, uid, idToken);
      });
      if (ok) {
        final index = coupons.indexWhere((c) => c.code == updated.code);
        if (index != -1) {
          coupons[index] = updated;
        }
      }
      return ok;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteCoupon(String code) async {
    try {
      final ok = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        return await _client.coupon.deleteCoupon(code, uid, idToken);
      });
      if (ok) {
        coupons.removeWhere((c) => c.code == code);
      }
      return ok;
    } catch (e) {
      rethrow;
    }
  }
}
