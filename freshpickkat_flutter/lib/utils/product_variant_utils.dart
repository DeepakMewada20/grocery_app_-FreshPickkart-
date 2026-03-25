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
      label: product.quantity,
      price: product.price,
      realPrice: product.realPrice,
      isAvailable: product.isAvailable,
      sortOrder: 0,
    ),
  ];
}

String inferProductVariantId(Product product) {
  final variants = sortedProductVariants(product);
  final matched = variants.where(
    (variant) =>
        variant.label == product.quantity &&
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
    quantity: selectedVariant.label,
    price: selectedVariant.price,
    realPrice: selectedVariant.realPrice,
    isAvailable: selectedVariant.isAvailable,
    variants: sortedProductVariants(product),
  );
}
