import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:get/get.dart';

class ResolvedComboProduct {
  final ComboProductItem comboItem;
  final Product baseProduct;
  final Product selectedProduct;
  final ProductVariant selectedVariant;

  const ResolvedComboProduct({
    required this.comboItem,
    required this.baseProduct,
    required this.selectedProduct,
    required this.selectedVariant,
  });

  int get bundleQuantity => comboItem.quantity;
  double get mrpUnitPrice => selectedProduct.realPrice;
  double get unitPrice => selectedVariant.price;
  double get bundleMrpTotal => mrpUnitPrice * bundleQuantity;
  double get bundleLineTotal => unitPrice * bundleQuantity;
}

List<ResolvedComboProduct> resolveComboProducts(
  ComboOffer combo,
  List<Product> allProducts,
) {
  final resolved = <ResolvedComboProduct>[];

  for (final comboItem in combo.comboProducts) {
    final baseProduct = allProducts.firstWhereOrNull(
      (product) => product.productId == comboItem.productId,
    );
    if (baseProduct == null) continue;

    final variant = resolveProductVariant(
      baseProduct,
      variantId: comboItem.variantId,
    );
    final selectedProduct = applyVariantToProduct(
      baseProduct,
      variantId: variant.variantId,
    );

    resolved.add(
      ResolvedComboProduct(
        comboItem: comboItem,
        baseProduct: baseProduct,
        selectedProduct: selectedProduct,
        selectedVariant: variant,
      ),
    );
  }

  return resolved;
}

double calculateComboOriginalUnitTotal(List<ResolvedComboProduct> products) {
  return products.fold(
    0,
    (sum, item) => sum + item.bundleLineTotal,
  );
}

double calculateComboMrpUnitTotal(List<ResolvedComboProduct> products) {
  return products.fold(
    0,
    (sum, item) => sum + item.bundleMrpTotal,
  );
}

double applyComboDiscount({
  required double originalTotal,
  required String discountType,
  required double discountValue,
}) {
  if (discountType == 'percentage') {
    return (originalTotal * (1 - (discountValue / 100))).clamp(
      0,
      double.infinity,
    );
  }
  return (originalTotal - discountValue).clamp(0, double.infinity);
}

String comboDiscountBadgeText(String discountType, double discountValue) {
  if (discountType == 'percentage') {
    return 'More ${discountValue.formatPrice}% off';
  }
  return 'More ₹${discountValue.formatPrice} off';
}

double calculateProratedComboLineTotal({
  required double sellingLineTotal,
  required double originalUnitTotal,
  required double comboUnitTotal,
}) {
  if (sellingLineTotal <= 0 || originalUnitTotal <= 0 || comboUnitTotal <= 0) {
    return 0;
  }
  final ratio = comboUnitTotal / originalUnitTotal;
  return (sellingLineTotal * ratio).clamp(0, double.infinity);
}
