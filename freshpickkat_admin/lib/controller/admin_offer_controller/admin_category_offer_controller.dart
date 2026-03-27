import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../../services/api_client.dart';
import '../../core/exceptions.dart';
import '../../controller/network_controller.dart';

class AdminCategoryOfferController extends GetxController {
  static AdminCategoryOfferController get instance => Get.put(AdminCategoryOfferController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController =
      Get.put(NetworkController(), tag: 'AdminCategoryOfferController');

  final categoryOffers = <CategoryOffer>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategoryOffers();
  }

  Future<void> loadCategoryOffers({bool force = false}) async {
    if (!force && categoryOffers.isNotEmpty) return;
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      networkController.hideError();
      final offers = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: true,
        );
        return await client.categoryOffer.getAllCategoryOffers(uid, idToken);
      });
      categoryOffers.assignAll(offers);
    } on NoInternetException {
      networkController.showError(onRetry: loadCategoryOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadCategoryOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadCategoryOffers);
    } catch (e) {
      print('Error loading category offers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createCategoryOffer(CategoryOffer offer) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.categoryOffer.upsertCategoryOffer(
        offer,
        uid,
        idToken,
      );
      if (result) {
        await loadCategoryOffers();
      }
      return result;
    } catch (e) {
      print('Error creating category offer: $e');
      return false;
    }
  }

  Future<bool> updateCategoryOffer(CategoryOffer offer) async {
    return createCategoryOffer(offer);
  }

  Future<bool> deleteCategoryOffer(String offerId) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.categoryOffer.deleteCategoryOffer(
        offerId,
        uid,
        idToken,
      );
      if (result) {
        await loadCategoryOffers();
      }
      return result;
    } catch (e) {
      print('Error deleting category offer: $e');
      return false;
    }
  }

  Future<bool> toggleCategoryOffer(String offerId, bool isActive) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.categoryOffer.setCategoryOfferActive(
        offerId,
        isActive,
        uid,
        idToken,
      );
      if (result) {
        await loadCategoryOffers();
      }
      return result;
    } catch (e) {
      print('Error toggling category offer: $e');
      return false;
    }
  }
}
