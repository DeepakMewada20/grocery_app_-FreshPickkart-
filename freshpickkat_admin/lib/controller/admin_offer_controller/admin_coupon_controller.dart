import 'package:freshpickkat_admin/controller/network_controller.dart';
import 'package:freshpickkat_admin/core/exceptions.dart';
import 'package:freshpickkat_admin/services/api_client.dart';
import 'package:freshpickkat_admin/widgets/cascade_deactivation_dialog.dart';
import 'package:freshpickkat_admin/widgets/delete_impact_dialog.dart';
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
  final RxList<Coupon> inactiveCoupons = <Coupon>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingInactive = false.obs;
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

  Future<void> loadInactiveCoupons() async {
    if (isLoadingInactive.value) return;
    isLoadingInactive.value = true;
    try {
      final result = await ApiClient().request(() async {
        return await _client.coupon.getInactiveCoupons();
      });
      inactiveCoupons.assignAll(result);
    } catch (_) {
    } finally {
      isLoadingInactive.value = false;
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
      if (isActive) {
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
      } else {
        final index = coupons.indexWhere((c) => c.code == code);
        if (index == -1) return false;
        final couponId = coupons[index].id;
        if (couponId == null || couponId.isEmpty) return false;
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );
        final ctx = Get.context;
        if (ctx == null) return false;
        final impact = await _client.cascade.analyzeCascadeDeactivation(
          'coupon', couponId, uid, idToken,
        );
        if (!ctx.mounted) return false;
        final proceed = await showCascadeDeactivationDialog(context: ctx, impact: impact);
        if (!proceed) return false;
        await _client.cascade.executeCascadeDeactivation(
          'coupon', couponId, uid, idToken,
        );
        coupons[index] = coupons[index].copyWith(isActive: false);
        return true;
      }
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

  Future<bool?> deleteCoupon(String code) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );

      final impact = await _client.coupon.checkCouponDeleteImpact(
        code,
        uid,
        idToken,
      );

      final choice = await showDeleteImpactDialog(
        context: Get.context!,
        impact: impact,
        entityName: 'Coupon',
      );

      switch (choice) {
        case DeleteChoice.hardDelete:
          final result = await _client.coupon.hardDeleteCoupon(
            code,
            uid,
            idToken,
          );
          if (result.success) {
            coupons.removeWhere((c) => c.code == code);
            return null;
          }
          return false;
        case DeleteChoice.softDelete:
          await setCouponActive(code, false);
          return true;
        case DeleteChoice.cancel:
          return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
