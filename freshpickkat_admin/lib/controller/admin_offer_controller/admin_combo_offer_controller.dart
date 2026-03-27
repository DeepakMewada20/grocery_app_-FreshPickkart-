import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
import '../../controller/network_controller.dart';

class AdminComboOfferController extends GetxController {
  static AdminComboOfferController get instance => Get.put(AdminComboOfferController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController =
      Get.put(NetworkController(), tag: 'AdminComboOfferController');

  final comboOffers = <ComboOffer>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadComboOffers();
  }

  Future<void> loadComboOffers({bool force = false}) async {
    if (!force && comboOffers.isNotEmpty) return;
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      networkController.hideError();
      final offers = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: true,
        );
        return await client.comboOffer.getAllComboOffers(uid, idToken);
      });
      comboOffers.assignAll(offers);
    } on NoInternetException {
      networkController.showError(onRetry: loadComboOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadComboOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadComboOffers);
    } catch (e) {
      print('Error loading combo offers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createComboOffer(ComboOffer offer) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.comboOffer.upsertComboOffer(
        offer,
        uid,
        idToken,
      );
      if (result) {
        await loadComboOffers();
      }
      return result;
    } catch (e) {
      print('Error creating combo offer: $e');
      return false;
    }
  }

  Future<bool> updateComboOffer(ComboOffer offer) async {
    return createComboOffer(offer);
  }

  Future<bool> deleteComboOffer(String comboId) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.comboOffer.deleteComboOffer(
        comboId,
        uid,
        idToken,
      );
      if (result) {
        await loadComboOffers();
      }
      return result;
    } catch (e) {
      print('Error deleting combo offer: $e');
      return false;
    }
  }

  Future<bool> toggleComboOffer(String comboId, bool isActive) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.comboOffer.setComboOfferActive(
        comboId,
        isActive,
        uid,
        idToken,
      );
      if (result) {
        await loadComboOffers();
      }
      return result;
    } catch (e) {
      print('Error toggling combo offer: $e');
      return false;
    }
  }
}
