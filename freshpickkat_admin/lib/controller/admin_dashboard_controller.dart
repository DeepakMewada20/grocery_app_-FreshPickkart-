import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';

class AdminDashboardController extends GetxController {
  static AdminDashboardController get instance =>
      Get.find<AdminDashboardController>();

  final _client = ServerpodAdminClient().client;

  final Rx<AdminDashboardStats?> stats = Rx<AdminDashboardStats?>(null);
  final Rx<AdminAnalytics?> analytics = Rx<AdminAnalytics?>(null);
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString(null);

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    error.value = null;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );

      final results = await Future.wait([
        _client.admin.getDashboardStats(uid, idToken),
        _client.admin.getAnalytics(uid, idToken),
      ]);

      stats.value = results[0] as AdminDashboardStats;
      analytics.value = results[1] as AdminAnalytics;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
