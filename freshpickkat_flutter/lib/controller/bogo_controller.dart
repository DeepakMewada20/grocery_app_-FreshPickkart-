import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
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
    } finally {
      isLoading.value = false;
    }
  }

  BogoOffer? getOfferForProduct(String productId) {
    return activeOffers.firstWhereOrNull(
      (o) => o.triggerProductId == productId,
    );
  }

  Future<BogoOffer?> fetchOfferForProduct(String productId) async {
    final existing = getOfferForProduct(productId);
    if (existing != null) return existing;

    try {
      final offer = await _client.bogo.getActiveOfferForProduct(productId);
      if (offer != null) {
        if (!activeOffers.any((o) => o.triggerProductId == productId)) {
          activeOffers.add(offer);
        }
      }
      return offer;
    } catch (e) {
      return null;
    }
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
    final config = getFreeProductConfig(triggerProductId, freeProductId);
    if (config != null && config.variantId != null) {
      final product = Get.find<ProductProviderController>().allProducts
          .firstWhereOrNull(
            (p) => p.productId == config.productId,
          );
      if (product != null) {
        final variant = resolveProductVariant(
          product,
          variantId: config.variantId,
        );
        final qty =
            variant.quantityValue == variant.quantityValue.truncateToDouble()
            ? variant.quantityValue.toInt().toString()
            : variant.quantityValue.toString();
        final label = '$qty ${variant.quantityUnit}';
        final desc = variant.quantityDescription?.trim();
        final packLabel = desc != null && desc.isNotEmpty
            ? '$label ($desc)'
            : label;
        final freeQuantity = config.freeQuantity ?? 1;
        return freeQuantity > 1 ? '$freeQuantity x $packLabel' : packLabel;
      }
    }
    final normalizedFallback = fallback.trim();
    return normalizedFallback.isEmpty ? '1 item' : normalizedFallback;
  }
}
