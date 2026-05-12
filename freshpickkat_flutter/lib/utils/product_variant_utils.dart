import 'package:freshpickkat_client/freshpickkat_client.dart';

List<ProductVariant> sortedProductVariants(Product product) {
  final variants = product.variants ?? const <ProductVariant>[];
  if (variants.isNotEmpty) {
    final copy = [...variants];
    copy.sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));
    return copy;
  }

  return [
    ProductVariant(
      variantId: 'default',
      quantityValue:
          product.baseQuantity ?? _parseQuantityValue(product.quantity),
      quantityUnit: product.baseUnit ?? _parseQuantityUnit(product.quantity),
      quantityDescription: product.quantityDescription,
      price: product.price,
      realPrice: product.realPrice,
      isAvailable: product.isAvailable,
      sortOrder: 0,
    ),
  ];
}

double _parseQuantityValue(String text) {
  final match = RegExp(r'^([0-9]+(\.[0-9]+)?)').firstMatch(text.trim());
  if (match != null) {
    return double.tryParse(match.group(1) ?? '1') ?? 1;
  }
  return 1;
}

String _parseQuantityUnit(String text) {
  final lower = text.toLowerCase().trim();
  if (lower.contains('kg')) return 'kg';
  if (lower.contains('litre') || lower.contains('l')) return 'litre';
  if (lower.contains('ml')) return 'ml';
  if (lower.contains('pc') ||
      lower.contains('piece') ||
      lower.contains('pcs')) {
    return 'pc';
  }
  if (lower.contains('pack')) return 'pack';
  return 'gm';
}

String formatQuantityString(double quantityValue, String quantityUnit) {
  if (quantityUnit == 'kg' && quantityValue >= 1) {
    return '${quantityValue.toStringAsFixed(quantityValue.truncateToDouble() == quantityValue ? 0 : 2)} $quantityUnit';
  }
  if (quantityValue == quantityValue.truncateToDouble()) {
    return '${quantityValue.toInt()} $quantityUnit';
  }
  return '$quantityValue $quantityUnit';
}

String productBaseQuantityLabel(Product product) {
  final quantityValue =
      product.baseQuantity ?? _parseQuantityValue(product.quantity);
  final quantityUnit = product.baseUnit ?? _parseQuantityUnit(product.quantity);
  return formatQuantityString(quantityValue, quantityUnit);
}

String? productQuantityDescriptionLabel(Product product) {
  final description = product.quantityDescription?.trim();
  if (description == null || description.isEmpty) return null;
  return description;
}

String productFullQuantityLabel(Product product) {
  final base = productBaseQuantityLabel(product);
  final description = productQuantityDescriptionLabel(product);
  if (description == null) return base;
  return '$base ($description)';
}

String inferProductVariantId(Product product) {
  final variants = sortedProductVariants(product);
  final matched = variants.where(
    (variant) =>
        variant.quantityValue ==
            (product.baseQuantity ?? _parseQuantityValue(product.quantity)) &&
        variant.quantityUnit ==
            (product.baseUnit ?? _parseQuantityUnit(product.quantity)) &&
        variant.price == product.price &&
        variant.realPrice == product.realPrice,
  );
  if (matched.isNotEmpty) {
    return matched.first.variantId;
  }
  return variants.first.variantId;
}

ProductVariant resolveProductVariant(Product product, {String? variantId}) {
  final variants = sortedProductVariants(product);
  if (variantId != null) {
    final matched = variants.where((variant) => variant.variantId == variantId);
    if (matched.isNotEmpty) {
      return matched.first;
    }
  }
  return variants.first;
}

Product applyVariantToProduct(Product product, {String? variantId}) {
  final selectedVariant = resolveProductVariant(product, variantId: variantId);
  return product.copyWith(
    quantity: formatQuantityString(
      selectedVariant.quantityValue,
      selectedVariant.quantityUnit,
    ),
    baseQuantity: selectedVariant.quantityValue,
    baseUnit: selectedVariant.quantityUnit,
    quantityDescription:
        selectedVariant.quantityDescription ?? product.quantityDescription,
    price: selectedVariant.price,
    realPrice: selectedVariant.realPrice,
    isAvailable: selectedVariant.isAvailable,
    variants: sortedProductVariants(product),
  );
}
