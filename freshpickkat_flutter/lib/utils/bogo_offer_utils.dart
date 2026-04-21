import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';

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

bool _canCompareBogoUnits(String first, String second) {
  return _normalizeBogoUnit(first) == _normalizeBogoUnit(second);
}

ProductVariant? resolveConfiguredBogoTriggerVariant(
  Product triggerProduct,
  BogoOffer offer,
) {
  final configuredVariantId = offer.triggerVariantId?.trim();
  if (configuredVariantId != null && configuredVariantId.isNotEmpty) {
    for (final variant in sortedProductVariants(triggerProduct)) {
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
    for (final variant in sortedProductVariants(triggerProduct)) {
      if (!_canCompareBogoUnits(variant.quantityUnit, thresholdUnit)) {
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

bool isBogoTriggerVariantEligible(
  Product triggerProduct, {
  required BogoOffer offer,
  required String? selectedVariantId,
}) {
  final selectedVariant = resolveProductVariant(
    triggerProduct,
    variantId: selectedVariantId,
  );
  final configuredVariant = resolveConfiguredBogoTriggerVariant(
    triggerProduct,
    offer,
  );

  if (configuredVariant != null) {
    if (!_canCompareBogoUnits(
      selectedVariant.quantityUnit,
      configuredVariant.quantityUnit,
    )) {
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
    if (!_canCompareBogoUnits(
      selectedVariant.quantityUnit,
      offer.triggerBaseUnit!,
    )) {
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
  final variants = sortedProductVariants(triggerProduct);
  return variants
      .where(
        (variant) => isBogoTriggerVariantEligible(
          triggerProduct,
          offer: offer,
          selectedVariantId: variant.variantId,
        ),
      )
      .toList(growable: false);
}

String formatBogoTriggerVariantLabel(ProductVariant variant) {
  return formatQuantityString(variant.quantityValue, variant.quantityUnit);
}

String? bogoTriggerThresholdLabel(Product triggerProduct, BogoOffer offer) {
  final configuredVariant = resolveConfiguredBogoTriggerVariant(
    triggerProduct,
    offer,
  );
  if (configuredVariant != null) {
    return formatQuantityString(
      configuredVariant.quantityValue,
      configuredVariant.quantityUnit,
    );
  }
  if (offer.triggerBaseQuantity != null &&
      offer.triggerBaseQuantity! > 0 &&
      offer.triggerBaseUnit != null &&
      offer.triggerBaseUnit!.trim().isNotEmpty) {
    return formatQuantityString(
      offer.triggerBaseQuantity!,
      offer.triggerBaseUnit!,
    );
  }
  return null;
}

String buildBogoIneligibleMessage(Product triggerProduct, BogoOffer offer) {
  final thresholdLabel = bogoTriggerThresholdLabel(triggerProduct, offer);
  final eligibleVariants = eligibleBogoTriggerVariants(triggerProduct, offer);

  if (eligibleVariants.isEmpty) {
    if (thresholdLabel == null) {
      return 'Free product is not available on this pack. Please select an eligible pack.';
    }
    return 'Free product is available on $thresholdLabel and above packs. Please select an eligible pack.';
  }

  final eligibleLabels = eligibleVariants
      .map(
        (variant) => formatQuantityString(
          variant.quantityValue,
          variant.quantityUnit,
        ),
      )
      .toList(growable: false);

  if (eligibleLabels.length == 1) {
    return 'Free product is available on ${eligibleLabels.first} pack. Please select that pack to unlock the gift.';
  }

  final previewLabels = eligibleLabels.take(3).join(', ');
  final suffix = eligibleLabels.length > 3 ? ', or a larger pack' : '';
  if (thresholdLabel == null) {
    return 'Free product is available on $previewLabels$suffix. Please select one of those packs.';
  }
  return 'Free product is available on $thresholdLabel and above packs. Please select $previewLabels$suffix.';
}
