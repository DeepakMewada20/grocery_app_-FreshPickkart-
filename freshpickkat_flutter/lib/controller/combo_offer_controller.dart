import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class ComboOfferController extends GetxController {
  static ComboOfferController get instance => Get.find<ComboOfferController>();

  final Client _client = ServerpodClient().client;

  final activeComboOffers = <ComboOffer>[].obs;
  final applicableCombos = <ComboOffer>[].obs;
  final selectedComboId = Rxn<String>();
  final isLoading = false.obs;

  // Mutex lock to prevent duplicate API calls
  bool _isFetching = false;

  Future<void> fetchActiveComboOffersIfEmpty() async {
    if (_isFetching) return;
    if (activeComboOffers.isNotEmpty) return;
    if (isLoading.value) return;

    _isFetching = true;
    try {
      await fetchActiveComboOffers();
    } catch (e) {
      // error handled in fetchActiveComboOffers
    } finally {
      _isFetching = false;
    }
  }

  Future<void> forceFetchActiveComboOffers() async {
    if (_isFetching) return;
    activeComboOffers.clear();

    _isFetching = true;
    try {
      await fetchActiveComboOffers();
    } catch (e) {
      // error handled in fetchActiveComboOffers
    } finally {
      _isFetching = false;
    }
  }

  void clearCache() {
    activeComboOffers.clear();
    applicableCombos.clear();
    selectedComboId.value = null;
    _isFetching = false;
  }

  Future<void> fetchActiveComboOffers() async {
    try {
      isLoading.value = true;
      final offers = await _client.comboOffer.getActiveComboOffers();
      activeComboOffers.assignAll(offers);
    } catch (e) {
      AppLogger.error('ComboOffer', 'Active: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkApplicableCombos(List<CartItem> cartItems) async {
    try {
      final items = cartItems
          .map(
            (item) => CartItemInput(
              productId: item.productId,
              variantId: item.variantId,
              quantity: item.quantity,
            ),
          )
          .toList();

      final applicable = await _client.comboOffer.checkApplicableCombos(items);
      applicableCombos.assignAll(applicable);
    } catch (e) {
      AppLogger.error('ComboOffer', 'Applicable: $e');
    }
  }

  ComboOffer? getBestComboOffer() {
    if (applicableCombos.isEmpty) return null;
    return applicableCombos.reduce(
      (a, b) => (a.discountValue) > (b.discountValue) ? a : b,
    );
  }

  Future<bool> createComboOffer(
    ComboOffer offer,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      return await _client.comboOffer.upsertComboOffer(
        offer,
        firebaseUid,
        idToken,
      );
    } catch (e) {
      AppLogger.error('ComboOffer', 'Create: $e');
      return false;
    }
  }

  Future<bool> deleteComboOffer(
    String comboId,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      return await _client.comboOffer.deleteComboOffer(
        comboId,
        firebaseUid,
        idToken,
      );
    } catch (e) {
      AppLogger.error('ComboOffer', 'Delete: $e');
      return false;
    }
  }

  Future<bool> toggleComboOfferActive(
    String comboId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      return await _client.comboOffer.setComboOfferActive(
        comboId,
        isActive,
        firebaseUid,
        idToken,
      );
    } catch (e) {
      AppLogger.error('ComboOffer', 'Toggle: $e');
      return false;
    }
  }
}
