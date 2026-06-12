import '../generated/protocol.dart';

class EffectiveOfferResolver {
  /// Resolves free delivery for a variant using lower→higher quantity inheritance.
  ///
  /// [freeDeliverySources] are variants that directly have free delivery enabled
  /// (either via [ProductVariantRow.isFreeDelivery] or the default variant when
  /// [ProductRow.isFreeDelivery] is true). Among same-unit-group siblings, if any
  /// source has quantity <= current variant's quantity, this variant gets FD.
  static bool effectiveFreeDelivery({
    required double quantityValue,
    required String quantityUnit,
    required List<ProductVariantRow> freeDeliverySources,
  }) {
    final currentBase = _toBaseUnit(quantityValue, quantityUnit);
    final group = _unitGroup(quantityUnit);

    for (final source in freeDeliverySources) {
      if (_unitGroup(source.quantityUnit) != group) continue;
      if (_toBaseUnit(source.quantityValue, source.quantityUnit) > currentBase) {
        continue;
      }
      return true;
    }
    return false;
  }

  /// BOGO is strictly variant-specific — no inheritance.
  static bool effectiveBOGO(ProductVariant variant) {
    return variant.bogoFreeProductIds?.isNotEmpty == true;
  }

  /// Groups a unit string into a canonical measurement family.
  static String _unitGroup(String unit) {
    final u = unit.trim().toLowerCase();
    if (const {'g', 'gm', 'gram', 'grams', 'kg', 'kilogram', 'kilograms',
               'kilo', 'kilos', 'kilogramme', 'kilogrammes'}.contains(u)) {
      return 'mass';
    }
    if (const {'ml', 'milliliter', 'millilitre', 'milliliters', 'millilitres',
               'l', 'litre', 'liter', 'litres', 'liters',
               'lt'}.contains(u)) {
      return 'volume';
    }
    if (const {'pcs', 'pc', 'piece', 'pieces', 'count', 'unit', 'units',
               'nos', 'no', 'number', 'numbers', 'pack', 'packs'}.contains(u)) {
      return 'count';
    }
    return u;
  }

  /// Converts quantity to the base unit of its measurement family:
  ///   mass   → grams
  ///   volume → millilitres
  ///   count  → as-is
  static double _toBaseUnit(double quantity, String unit) {
    final u = unit.trim().toLowerCase();
    if (const {'kg', 'kilogram', 'kilograms', 'kilo', 'kilos',
               'kilogramme', 'kilogrammes'}.contains(u)) {
      return quantity * 1000;
    }
    if (const {'l', 'litre', 'liter', 'litres', 'liters',
               'lt'}.contains(u)) {
      return quantity * 1000;
    }
    return quantity;
  }
}
