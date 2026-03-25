import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:get/get.dart';

class BogoController extends GetxController {
  static BogoController get instance =>
      Get.put(BogoController(), permanent: true);

  final Client _client = ServerpodClient().client;
  final RxList<BogoOffer> activeOffers = <BogoOffer>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveOffers();
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
