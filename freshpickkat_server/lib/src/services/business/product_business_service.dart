import '../../generated/protocol.dart';

class ProductBusinessService {
  static const Map<String, double> _unitConversions = {
    'gm': 1.0,
    'kg': 1000.0,
    'litre': 1000.0,
    'ml': 1.0,
    'pc': 1.0,
    'pack': 1.0,
  };

  static double convertToBaseUnit(double quantity, String unit) {
    final factor = _unitConversions[unit.toLowerCase()] ?? 1.0;
    return quantity * factor;
  }

  static double calculateRealPriceForVariant({
    required double baseRealPrice,
    required double baseQuantity,
    required String baseUnit,
    required double variantQuantity,
    required String variantUnit,
  }) {
    final baseInBaseUnit = convertToBaseUnit(baseQuantity, baseUnit);
    final variantInBaseUnit = convertToBaseUnit(variantQuantity, variantUnit);

    if (baseInBaseUnit <= 0) return 0;

    final ratio = variantInBaseUnit / baseInBaseUnit;
    return baseRealPrice * ratio;
  }

  static Product normalizeForSave(Product product) {
    final normalizedVariants = _normalizeVariants(product);
    final primaryVariant = normalizedVariants.first;
    final normalizedRealPrice = _nonNegative(primaryVariant.realPrice);
    final normalizedPrice = _nonNegative(primaryVariant.price);

    double resolvedDiscount = _resolveDiscount(
      realPrice: normalizedRealPrice,
      price: normalizedPrice,
      requestedDiscount: product.discount,
    );

    final resolvedAvailable = _resolveAvailability(
      quantityText: product.quantity,
      requestedAvailability: product.isAvailable,
    );

    return product.copyWith(
      quantity: _formatQuantityString(
        primaryVariant.quantityValue,
        primaryVariant.quantityUnit,
      ),
      baseUnit: primaryVariant.quantityUnit,
      baseQuantity: primaryVariant.quantityValue,
      realPrice: normalizedRealPrice,
      price: normalizedPrice,
      discount: resolvedDiscount,
      discountType: product.discountType ?? 'percentage',
      discountValue: product.discountValue ?? resolvedDiscount,
      isAvailable: primaryVariant.isAvailable && resolvedAvailable,
      countryOfOrigin: product.countryOfOrigin?.trim().isEmpty == true
          ? null
          : product.countryOfOrigin?.trim(),
      bogoFreeProductIds: product.bogoFreeProductIds,
      variants: normalizedVariants,
    );
  }

  static List<ProductVariant> _normalizeVariants(Product product) {
    final baseUnit = product.baseUnit ?? 'gm';
    final baseQuantity = product.baseQuantity ?? 1.0;

    final source = (product.variants == null || product.variants!.isEmpty)
        ? <ProductVariant>[
            ProductVariant(
              variantId: 'default',
              quantityValue: baseQuantity,
              quantityUnit: baseUnit,
              price: product.price,
              realPrice: product.realPrice,
              isAvailable: product.isAvailable,
              sortOrder: 0,
            ),
          ]
        : product.variants!;

    return source.asMap().entries.map((entry) {
      final index = entry.key;
      final variant = entry.value;
      final variantUnit = variant.quantityUnit.isNotEmpty
          ? variant.quantityUnit
          : baseUnit;
      final variantQuantity = variant.quantityValue > 0
          ? variant.quantityValue
          : baseQuantity;

      double realPrice = variant.realPrice;
      if (realPrice <= 0 && variant.price > 0) {
        realPrice = calculateRealPriceForVariant(
          baseRealPrice: product.realPrice > 0
              ? product.realPrice
              : product.price,
          baseQuantity: baseQuantity,
          baseUnit: baseUnit,
          variantQuantity: variantQuantity,
          variantUnit: variantUnit,
        );
      }

      return variant.copyWith(
        variantId: variant.variantId.trim().isEmpty
            ? 'variant_$index'
            : variant.variantId.trim(),
        quantityValue: variantQuantity,
        quantityUnit: variantUnit,
        price: _nonNegative(variant.price),
        realPrice: _nonNegative(realPrice),
        isAvailable: variant.isAvailable,
        sortOrder: variant.sortOrder ?? index,
      );
    }).toList()..sort((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0));
  }

  static double _nonNegative(double value) => value < 0 ? 0 : value;

  static double _resolveDiscount({
    required double realPrice,
    required double price,
    required double requestedDiscount,
  }) {
    if (realPrice <= 0 || price >= realPrice) {
      return 0;
    }
    if (requestedDiscount > 0) {
      return requestedDiscount.clamp(0, 100).toDouble();
    }

    final calculated = ((realPrice - price) / realPrice) * 100;
    return calculated.clamp(0, 100).toDouble();
  }

  static bool _resolveAvailability({
    required String quantityText,
    required bool requestedAvailability,
  }) {
    final parsed = _extractLeadingNumber(quantityText);
    if (parsed != null && parsed <= 0) return false;
    return requestedAvailability;
  }

  static double? _extractLeadingNumber(String input) {
    final match = RegExp(r'^\s*([0-9]+(\.[0-9]+)?)').firstMatch(input);
    if (match == null) return null;
    return double.tryParse(match.group(1)!);
  }

  static String _formatQuantityString(double quantity, String unit) {
    if (unit.toLowerCase() == 'kg' && quantity >= 1) {
      return '${quantity.toStringAsFixed(quantity.truncateToDouble() == quantity ? 0 : 2)} $unit';
    }
    if (quantity == quantity.truncateToDouble()) {
      return '${quantity.toInt()} $unit';
    }
    return '$quantity $unit';
  }

  static String getDisplayDiscount({
    required double discount,
    required String? discountType,
    required double? discountValue,
  }) {
    if (discountType == 'flat' && discountValue != null && discountValue > 0) {
      return '₹${discountValue.toStringAsFixed(0)} off';
    } else if (discount > 0) {
      return '${discount.toStringAsFixed(0)}% off';
    }
    return '';
  }

  static double calculatePriceFromDiscount({
    required double realPrice,
    required double discount,
    required String? discountType,
  }) {
    if (discountType == 'flat') {
      return (realPrice - discount).clamp(0, double.infinity);
    }
    return realPrice * (1 - discount / 100);
  }
}
