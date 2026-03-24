import '../../generated/protocol.dart';

class ProductBusinessService {
  static Product normalizeForSave(Product product) {
    final normalizedRealPrice = _nonNegative(product.realPrice);
    final normalizedPrice = _nonNegative(product.price);

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
      realPrice: normalizedRealPrice,
      price: normalizedPrice,
      discount: resolvedDiscount,
      discountType: product.discountType ?? 'percentage',
      discountValue: product.discountValue ?? resolvedDiscount,
      isAvailable: resolvedAvailable,
      countryOfOrigin: product.countryOfOrigin?.trim().isEmpty == true
          ? null
          : product.countryOfOrigin?.trim(),
      bogoFreeProductIds: product.bogoFreeProductIds,
    );
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
}
