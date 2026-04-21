import '../../generated/protocol.dart';

String _normalizeBogoUnit(String unit) {
  final normalized = unit.trim().toLowerCase();
  switch (normalized) {
    case 'g':
    case 'gm':
    case 'gram':
    case 'grams':
      return 'gm';
    case 'kg':
    case 'kgs':
    case 'kilogram':
    case 'kilograms':
      return 'gm';
    case 'ml':
      return 'ml';
    case 'l':
    case 'lt':
    case 'liter':
    case 'litre':
    case 'liters':
    case 'litres':
      return 'ml';
    case 'pc':
    case 'pcs':
    case 'piece':
    case 'pieces':
      return 'pc';
    case 'pack':
    case 'packs':
      return 'pack';
    default:
      return normalized;
  }
}

double _normalizeBogoQuantity(double value, String unit) {
  final normalized = unit.trim().toLowerCase();
  switch (normalized) {
    case 'kg':
    case 'kgs':
    case 'kilogram':
    case 'kilograms':
      return value * 1000;
    case 'l':
    case 'lt':
    case 'liter':
    case 'litre':
    case 'liters':
    case 'litres':
      return value * 1000;
    default:
      return value;
  }
}

double normalizedBogoVariantQuantity(ProductVariant variant) {
  return _normalizeBogoQuantity(variant.quantityValue, variant.quantityUnit);
}

ProductVariant resolveBogoVariant(Product product, {String? variantId}) {
  final variants = product.variants ?? const <ProductVariant>[];
  if (variants.isEmpty) {
    return ProductVariant(
      variantId: variantId ?? 'default',
      quantityValue: product.baseQuantity ?? 1,
      quantityUnit: product.baseUnit ?? 'pc',
      quantityDescription: product.quantityDescription,
      price: product.price,
      realPrice: product.realPrice,
      isAvailable: product.isAvailable,
      sortOrder: 0,
    );
  }

  if (variantId != null && variantId.trim().isNotEmpty) {
    for (final variant in variants) {
      if (variant.variantId == variantId) {
        return variant;
      }
    }
  }
  return variants.first;
}

ProductVariant? resolveConfiguredBogoTriggerVariant(
  Product triggerProduct,
  BogoOffer offer,
) {
  final configuredVariantId = offer.triggerVariantId?.trim();
  if (configuredVariantId != null && configuredVariantId.isNotEmpty) {
    for (final variant in triggerProduct.variants ?? const <ProductVariant>[]) {
      if (variant.variantId == configuredVariantId) {
        return variant;
      }
    }
  }

  if (offer.triggerBaseQuantity != null &&
      offer.triggerBaseQuantity! > 0 &&
      offer.triggerBaseUnit != null &&
      offer.triggerBaseUnit!.trim().isNotEmpty) {
    final thresholdUnit = offer.triggerBaseUnit!.trim();
    final thresholdQuantity = offer.triggerBaseQuantity!;
    for (final variant in triggerProduct.variants ?? const <ProductVariant>[]) {
      if (_normalizeBogoUnit(variant.quantityUnit) !=
          _normalizeBogoUnit(thresholdUnit)) {
        continue;
      }
      final normalizedVariant = _normalizeBogoQuantity(
        variant.quantityValue,
        variant.quantityUnit,
      );
      final normalizedThreshold = _normalizeBogoQuantity(
        thresholdQuantity,
        thresholdUnit,
      );
      if ((normalizedVariant - normalizedThreshold).abs() < 0.0001) {
        return variant;
      }
    }
  }

  return null;
}

bool isBogoTriggerEligible({
  required Product triggerProduct,
  required BogoOffer offer,
  required String? selectedVariantId,
}) {
  final selectedVariant = resolveBogoVariant(
    triggerProduct,
    variantId: selectedVariantId,
  );
  final configuredVariant = resolveConfiguredBogoTriggerVariant(
    triggerProduct,
    offer,
  );

  if (configuredVariant != null) {
    if (_normalizeBogoUnit(selectedVariant.quantityUnit) !=
        _normalizeBogoUnit(configuredVariant.quantityUnit)) {
      return selectedVariant.variantId == configuredVariant.variantId;
    }

    final selectedQuantity = _normalizeBogoQuantity(
      selectedVariant.quantityValue,
      selectedVariant.quantityUnit,
    );
    final configuredQuantity = _normalizeBogoQuantity(
      configuredVariant.quantityValue,
      configuredVariant.quantityUnit,
    );
    return selectedQuantity + 0.0001 >= configuredQuantity;
  }

  if (offer.triggerBaseQuantity != null &&
      offer.triggerBaseQuantity! > 0 &&
      offer.triggerBaseUnit != null &&
      offer.triggerBaseUnit!.trim().isNotEmpty) {
    if (_normalizeBogoUnit(selectedVariant.quantityUnit) !=
        _normalizeBogoUnit(offer.triggerBaseUnit!)) {
      return false;
    }

    final selectedQuantity = _normalizeBogoQuantity(
      selectedVariant.quantityValue,
      selectedVariant.quantityUnit,
    );
    final configuredQuantity = _normalizeBogoQuantity(
      offer.triggerBaseQuantity!,
      offer.triggerBaseUnit!,
    );
    return selectedQuantity + 0.0001 >= configuredQuantity;
  }

  return true;
}

List<ProductVariant> eligibleBogoTriggerVariants(
  Product triggerProduct,
  BogoOffer offer,
) {
  final variants = triggerProduct.variants ?? const <ProductVariant>[];
  if (variants.isEmpty) {
    return [resolveBogoVariant(triggerProduct)];
  }

  final eligible = variants
      .where((variant) => variant.isAvailable)
      .where(
        (variant) => isBogoTriggerEligible(
          triggerProduct: triggerProduct,
          offer: offer,
          selectedVariantId: variant.variantId,
        ),
      )
      .toList();

  eligible.sort(
    (a, b) => normalizedBogoVariantQuantity(a).compareTo(
      normalizedBogoVariantQuantity(b),
    ),
  );
  return eligible;
}
