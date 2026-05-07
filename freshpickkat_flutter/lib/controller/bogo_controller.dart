import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class BogoController extends GetxController {
  static BogoController get instance => Get.find<BogoController>();

  final Client _client = ServerpodClient().client;
  final RxList<BogoOffer> activeOffers = <BogoOffer>[].obs;
  final RxBool isLoading = false.obs;

  // Mutex lock to prevent duplicate API calls
  bool _isFetching = false;

  Future<void> fetchActiveOffersIfEmpty() async {
    if (_isFetching) return;
    if (activeOffers.isNotEmpty) return;
    if (isLoading.value) return;

    _isFetching = true;
    try {
      await fetchActiveOffers();
    } catch (e) {
      // error handled in fetchActiveOffers
    } finally {
      _isFetching = false;
    }
  }

  Future<void> forceFetchActiveOffers() async {
    if (_isFetching) return;
    activeOffers.clear();

    _isFetching = true;
    try {
      await fetchActiveOffers();
    } catch (e) {
      // error handled in fetchActiveOffers
    } finally {
      _isFetching = false;
    }
  }

  void clearCache() {
    activeOffers.clear();
    _isFetching = false;
  }

  Future<void> fetchActiveOffers() async {
    isLoading.value = true;
    try {
      final offers = await _client.bogo.getActiveOffers();
      activeOffers.assignAll(offers);
    } catch (e) {
      print('Error fetching BOGO offers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  BogoOffer? getOfferForProduct(String productId) {
    return activeOffers.firstWhereOrNull(
      (o) => o.triggerProductId == productId,
    );
  }

  BogoFreeProduct? getFreeProductConfig(
    String triggerProductId,
    String freeProductId,
  ) {
    final offer = getOfferForProduct(triggerProductId);
    return offer?.freeProducts?.firstWhereOrNull(
      (freeProduct) => freeProduct.productId == freeProductId,
    );
  }

  String freeProductQuantityLabel(
    String triggerProductId,
    String freeProductId, {
    required String fallback,
  }) {
    final configuredQuantity = getFreeProductConfig(
      triggerProductId,
      freeProductId,
    )?.quantity?.trim();

    if (configuredQuantity != null && configuredQuantity.isNotEmpty) {
      return configuredQuantity;
    }

    final normalizedFallback = fallback.trim();
    return normalizedFallback.isEmpty ? '1 item' : normalizedFallback;
  }
}
