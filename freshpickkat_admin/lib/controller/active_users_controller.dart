import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../services/api_client.dart';
import '../core/exceptions.dart';
import 'package:freshpickkat_admin/services/admin_auth_failure_handler.dart';
import 'network_controller.dart';

class ActiveUsersController extends GetxController {
  static ActiveUsersController get instance =>
      Get.find<ActiveUsersController>();

  final _client = ServerpodAdminClient().client;
  final NetworkController networkController = Get.put(
    NetworkController(),
    tag: 'ActiveUsersController',
  );

  final Rx<List<ActiveUserStatistics>> activeUsers =
      Rx<List<ActiveUserStatistics>>([]);
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString(null);
  final RxInt totalUsers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadActiveUsers();
  }

  Future<void> loadActiveUsers({int limit = 100}) async {
    isLoading.value = true;
    error.value = null;
    networkController.hideError();
    try {
      final results = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: false,
        );

        return await _client.admin.getActiveUsersWithStats(
          uid,
          idToken,
          limit: limit,
        );
      });

      activeUsers.value = results;
      totalUsers.value = results.length;
    } on NoInternetException {
      networkController.showError(onRetry: loadActiveUsers);
    } on NetworkException {
      networkController.showError(onRetry: loadActiveUsers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadActiveUsers);
    } catch (e) {
      if (AdminAuthFailureHandler.isAuthFailure(e)) {
        await AdminAuthFailureHandler.handle(e);
      } else {
        error.value = 'Error loading active users: ${e.toString()}';
      }
    } finally {
      isLoading.value = false;
    }
  }
}
