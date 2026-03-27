import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import '../services/api_client.dart';
import '../core/exceptions.dart';
import 'network_controller.dart';

class AdminOfferController extends GetxController {
  static AdminOfferController get instance => Get.put(AdminOfferController());

  Client get client => ServerpodAdminClient().client;
  final NetworkController networkController =
      Get.put(NetworkController(), tag: 'AdminOfferController');

  final _bogoOffers = <BogoOffer>[].obs;
  final _comboOffers = <ComboOffer>[].obs;
  final _categoryOffers = <CategoryOffer>[].obs;
  final _freeDeliveryRules = <FreeDeliveryRule>[].obs;
  final isLoading = false.obs;

  List<BogoOffer> get bogoOffers => _bogoOffers;
  List<ComboOffer> get comboOffers => _comboOffers;
  List<CategoryOffer> get categoryOffers => _categoryOffers;
  List<FreeDeliveryRule> get freeDeliveryRules => _freeDeliveryRules;

  Future<void> loadBogoOffers() async {
    try {
      isLoading.value = true;
      networkController.hideError();
      final offers = await ApiClient().request(() async {
        return await client.bogo.getActiveOffers();
      });
      _bogoOffers.assignAll(offers);
    } on NoInternetException {
      networkController.showError(onRetry: loadBogoOffers);
    } on NetworkException {
      networkController.showError(onRetry: loadBogoOffers);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadBogoOffers);
    } catch (e) {
      print('Error loading BOGO offers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadComboOffers() async {
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
      _comboOffers.assignAll(offers);
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

  Future<void> loadCategoryOffers() async {
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
      _categoryOffers.assignAll(offers);
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

  Future<void> loadFreeDeliveryRules() async {
    try {
      isLoading.value = true;
      networkController.hideError();
      final rules = await ApiClient().request(() async {
        final uid = AdminSessionService.requireUid();
        final idToken = await AdminSessionService.requireIdToken(
          forceRefresh: true,
        );
        return await client.freeDelivery.getAllFreeDeliveryRules(uid, idToken);
      });
      _freeDeliveryRules.assignAll(rules);
    } on NoInternetException {
      networkController.showError(onRetry: loadFreeDeliveryRules);
    } on NetworkException {
      networkController.showError(onRetry: loadFreeDeliveryRules);
    } on RequestTimeoutException {
      networkController.showError(onRetry: loadFreeDeliveryRules);
    } catch (e) {
      print('Error loading free delivery rules: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAll() async {
    await Future.wait([
      loadBogoOffers(),
      loadComboOffers(),
      loadCategoryOffers(),
      loadFreeDeliveryRules(),
    ]);
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

  Future<bool> createFreeDeliveryRule(FreeDeliveryRule rule) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.freeDelivery.upsertFreeDeliveryRule(
        rule,
        uid,
        idToken,
      );
      if (result) {
        await loadFreeDeliveryRules();
      }
      return result;
    } catch (e) {
      print('Error creating free delivery rule: $e');
      return false;
    }
  }

  Future<bool> updateFreeDeliveryRule(FreeDeliveryRule rule) async {
    return createFreeDeliveryRule(rule);
  }

  Future<bool> deleteFreeDeliveryRule(String ruleId) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.freeDelivery.deleteFreeDeliveryRule(
        ruleId,
        uid,
        idToken,
      );
      if (result) {
        await loadFreeDeliveryRules();
      }
      return result;
    } catch (e) {
      print('Error deleting free delivery rule: $e');
      return false;
    }
  }

  Future<bool> toggleFreeDeliveryRule(String ruleId, bool isActive) async {
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );
      final result = await client.freeDelivery.setFreeDeliveryRuleActive(
        ruleId,
        isActive,
        uid,
        idToken,
      );
      if (result) {
        await loadFreeDeliveryRules();
      }
      return result;
    } catch (e) {
      print('Error toggling free delivery rule: $e');
      return false;
    }
  }
}
