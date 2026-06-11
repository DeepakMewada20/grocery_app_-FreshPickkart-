import '../generated/protocol.dart';

class FeaturedVariantResolver {
  /// Selects the single best variant to display on the homepage.
  ///
  /// Priority (higher wins):
  /// 1. BOGO — first available variant with `bogoFreeProductIds`
  /// 2. Free Delivery — first available variant with `isFreeDelivery`
  /// 3. Combo Offer — first available variant with `comboOfferIds`
  /// 4. Discount — first available variant with `realPrice > price`
  /// 5. Default — first available variant, else the first variant
  ///
  /// Among tied-priority variants, the one with the highest absolute
  /// discount benefit (`realPrice - price`) is preferred.
  static ProductVariant resolve(List<ProductVariant> variants) {
    if (variants.isEmpty) {
      throw ArgumentError('variants must not be empty');
    }

    // Priority 1: BOGO
    final bogo = _firstWithOffer(
      variants,
      (v) => v.bogoFreeProductIds?.isNotEmpty == true,
    );
    if (bogo != null) return bogo;

    // Priority 2: Free Delivery
    final freeDelivery = _firstWithOffer(
      variants,
      (v) => v.isFreeDelivery,
    );
    if (freeDelivery != null) return freeDelivery;

    // Priority 3: Combo Offer
    final combo = _firstWithOffer(
      variants,
      (v) => v.comboOfferIds?.isNotEmpty == true,
    );
    if (combo != null) return combo;

    // Priority 4: Discount (any variant with sale price below list price)
    final discount = _firstWithOffer(
      variants,
      (v) => v.realPrice > v.price,
    );
    if (discount != null) return discount;

    // Priority 5: first available variant, else the first variant
    for (final v in variants) {
      if (v.isAvailable) return v;
    }
    return variants.first;
  }

  /// Among variants matching [predicate], picks the available one with
  /// the highest absolute discount ([realPrice] - [price]).
  static ProductVariant? _firstWithOffer(
    List<ProductVariant> variants,
    bool Function(ProductVariant) predicate,
  ) {
    final matched = <ProductVariant>[];
    for (final v in variants) {
      if (v.isAvailable && predicate(v)) {
        matched.add(v);
      }
    }
    if (matched.isEmpty) return null;

    matched.sort(
      (a, b) => (b.realPrice - b.price).compareTo(a.realPrice - a.price),
    );
    return matched.first;
  }
}
