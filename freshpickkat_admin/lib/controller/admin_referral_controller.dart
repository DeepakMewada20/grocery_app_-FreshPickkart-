import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import '../services/serverpod_client.dart';
import '../services/api_client.dart';
import '../services/admin_session_service.dart';
import 'network_controller.dart';

class AdminReferralController extends GetxController {
  static AdminReferralController get instance =>
      Get.put(AdminReferralController());

  client.Client get _client => ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'AdminReferralController',
  );

  final settings = Rxn<client.ReferralSettings>();
  final analytics = Rxn<client.ReferralAdminStats>();
  final fraudAnalytics = Rxn<Map<String, dynamic>>();
  final referrals = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isLoadingAnalytics = false.obs;
  final isLoadingReferrals = false.obs;
  final isApproving = false.obs;
  final fraudBreakdown = Rxn<Map<String, dynamic>>();

  String? _nextPageToken;
  bool get hasMore => _nextPageToken != null;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings({bool force = false}) async {
    if (!force && settings.value != null) return;
    isLoading.value = true;
    try {
      final result = await ApiClient().request(() => _client.referral.getSettings());
      settings.value = result;
      networkController.hideError();
    } catch (e) {
      debugPrint('AdminReferralController.loadSettings error: $e');
      networkController.showError(onRetry: loadSettings);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveSettings(client.ReferralSettings updated) async {
    isSaving.value = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(forceRefresh: false);
      final result = await ApiClient().request(
        () => _client.referral.updateSettings(updated, uid, idToken),
      );
      settings.value = result;
      return true;
    } catch (e) {
      debugPrint('AdminReferralController.saveSettings error: $e');
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> loadAnalytics() async {
    isLoadingAnalytics.value = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(forceRefresh: false);

      final analyticsResult = await ApiClient().request<client.ReferralAdminStats>(
        () => _client.referral.getReferralAnalytics(uid, idToken),
      );
      analytics.value = analyticsResult;

      ApiClient().request<Map<String, dynamic>>(
        () => _client.referral.getFraudAnalytics(uid, idToken),
      ).then((result) {
        fraudAnalytics.value = result;
      }).catchError((_) {
        debugPrint('AdminReferralController.loadAnalytics fraud error (non-fatal)');
      });

      networkController.hideError();
    } catch (e) {
      debugPrint('AdminReferralController.loadAnalytics error: $e');
      networkController.showError(onRetry: loadAnalytics);
    } finally {
      isLoadingAnalytics.value = false;
    }
  }

  Future<void> loadReferrals({bool loadMore = false, String? statusFilter}) async {
    if (loadMore) {
      if (isLoadingReferrals.value || !hasMore) return;
    } else {
      _nextPageToken = null;
    }

    isLoadingReferrals.value = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(forceRefresh: false);
      final result = await ApiClient().request(
        () => _client.referral.listReferrals(
          uid,
          idToken,
          limit: 20,
          pageToken: loadMore ? _nextPageToken : null,
          statusFilter: statusFilter,
        ),
      );

      final items = (result['referrals'] as List<dynamic>)
          .cast<Map<String, dynamic>>();
      _nextPageToken = result['nextPageToken'] as String?;

      if (loadMore) {
        referrals.addAll(items);
      } else {
        referrals.assignAll(items);
      }
      networkController.hideError();
    } catch (e) {
      debugPrint('AdminReferralController.loadReferrals error: $e');
      networkController.showError(onRetry: () => loadReferrals(loadMore: loadMore, statusFilter: statusFilter));
    } finally {
      isLoadingReferrals.value = false;
    }
  }

  Future<bool> approveReward(String referralId) async {
    isApproving.value = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(forceRefresh: false);
      await ApiClient().request(
        () => _client.referral.approveReward(referralId, uid, idToken),
      );
      return true;
    } catch (e) {
      debugPrint('AdminReferralController.approveReward error: $e');
      return false;
    } finally {
      isApproving.value = false;
    }
  }

  Future<bool> rejectReward(String referralId, String reason) async {
    isApproving.value = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(forceRefresh: false);
      await ApiClient().request(
        () => _client.referral.rejectReward(referralId, reason, uid, idToken),
      );
      return true;
    } catch (e) {
      debugPrint('AdminReferralController.rejectReward error: $e');
      return false;
    } finally {
      isApproving.value = false;
    }
  }

  Future<bool> reverseReward(String referralId, String reason) async {
    isApproving.value = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(forceRefresh: false);
      await ApiClient().request(
        () => _client.referral.reverseReward(referralId, reason, uid, idToken),
      );
      return true;
    } catch (e) {
      debugPrint('AdminReferralController.reverseReward error: $e');
      return false;
    } finally {
      isApproving.value = false;
    }
  }

  Future<void> loadFraudBreakdown(String referralId) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(forceRefresh: false);
      final result = await ApiClient().request(
        () => _client.referral.getFraudBreakdown(referralId, uid, idToken),
      );
      fraudBreakdown.value = result;
    } catch (e) {
      debugPrint('AdminReferralController.loadFraudBreakdown error: $e');
    }
  }
}
