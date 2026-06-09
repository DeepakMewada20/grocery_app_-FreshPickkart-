import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class DependencyChecker {
  /// Checks if a product is referenced by any active entity.
  static Future<List<String>> checkProduct(
    Session session,
    UuidValue productId,
  ) async {
    final refs = <String>[];
    final orderCount = await OrderItemRow.db.count(
      session,
      where: (t) => t.productId.equals(productId),
    );
    if (orderCount > 0) refs.add('$orderCount order(s)');

    final bannerLinkedCount = await BannerLinkedProductRow.db.count(
      session,
      where: (t) => t.productId.equals(productId),
    );
    final bannerDirectCount = await BannerRow.db.count(
      session,
      where: (t) => t.linkedProductId.equals(productId),
    );
    final totalBanners = bannerLinkedCount + bannerDirectCount;
    if (totalBanners > 0) refs.add('$totalBanners banner(s)');

    final bogoTriggerCount = await BogoOfferRow.db.count(
      session,
      where: (t) => t.triggerProductId.equals(productId),
    );
    if (bogoTriggerCount > 0) refs.add('$bogoTriggerCount BOGO offer(s)');

    final bogoRewardCount = await BogoOfferRewardRow.db.count(
      session,
      where: (t) => t.rewardProductId.equals(productId),
    );
    if (bogoRewardCount > 0) refs.add('$bogoRewardCount BOGO reward(s)');

    final catScopeCount = await CategoryOfferProductScopeRow.db.count(
      session,
      where: (t) => t.productId.equals(productId),
    );
    if (catScopeCount > 0) refs.add('$catScopeCount category offer scope(s)');

    final catExclCount = await CategoryOfferProductExclusionRow.db.count(
      session,
      where: (t) => t.productId.equals(productId),
    );
    if (catExclCount > 0) refs.add('$catExclCount category offer exclusion(s)');

    final comboCount = await ComboOfferItemRow.db.count(
      session,
      where: (t) => t.productId.equals(productId),
    );
    if (comboCount > 0) refs.add('$comboCount combo offer(s)');

    final couponCount = await CouponProductScopeRow.db.count(
      session,
      where: (t) => t.productId.equals(productId),
    );
    if (couponCount > 0) refs.add('$couponCount coupon(s)');

    return refs;
  }

  /// Checks if a product variant is referenced by any entity.
  static Future<List<String>> checkVariant(
    Session session,
    UuidValue variantId,
  ) async {
    final refs = <String>[];
    final orderCount = await OrderItemRow.db.count(
      session,
      where: (t) => t.productVariantId.equals(variantId),
    );
    if (orderCount > 0) refs.add('$orderCount order(s)');

    final bogoTriggerCount = await BogoOfferRow.db.count(
      session,
      where: (t) => t.triggerVariantId.equals(variantId),
    );
    if (bogoTriggerCount > 0) refs.add('$bogoTriggerCount BOGO offer(s)');

    final bogoRewardCount = await BogoOfferRewardRow.db.count(
      session,
      where: (t) => t.rewardVariantId.equals(variantId),
    );
    if (bogoRewardCount > 0) refs.add('$bogoRewardCount BOGO reward(s)');

    final comboCount = await ComboOfferItemRow.db.count(
      session,
      where: (t) => t.productVariantId.equals(variantId),
    );
    if (comboCount > 0) refs.add('$comboCount combo offer(s)');

    return refs;
  }

  /// Checks if a category is referenced by any entity.
  static Future<List<String>> checkCategory(
    Session session,
    UuidValue categoryId,
  ) async {
    final refs = <String>[];
    final productCount = await ProductRow.db.count(
      session,
      where: (t) => t.categoryId.equals(categoryId),
    );
    if (productCount > 0) refs.add('$productCount product(s)');

    final subCategoryCount = await SubCategoryRow.db.count(
      session,
      where: (t) => t.categoryId.equals(categoryId),
    );
    if (subCategoryCount > 0) refs.add('$subCategoryCount sub-categor(ies)');

    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.linkedCategoryId.equals(categoryId),
    );
    if (bannerCount > 0) refs.add('$bannerCount banner(s)');

    final offerCount = await CategoryOfferRow.db.count(
      session,
      where: (t) => t.categoryId.equals(categoryId),
    );
    if (offerCount > 0) refs.add('$offerCount category offer(s)');

    return refs;
  }

  /// Checks if a sub-category is referenced by any entity.
  static Future<List<String>> checkSubCategory(
    Session session,
    UuidValue subCategoryId,
  ) async {
    final refs = <String>[];
    final productSubCount = await ProductSubCategoryRow.db.count(
      session,
      where: (t) => t.subCategoryId.equals(subCategoryId),
    );
    if (productSubCount > 0) refs.add('$productSubCount product mapping(s)');

    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.linkedSubCategoryId.equals(subCategoryId),
    );
    if (bannerCount > 0) refs.add('$bannerCount banner(s)');

    return refs;
  }

  /// Checks if a coupon is referenced by any entity.
  static Future<List<String>> checkCoupon(
    Session session,
    UuidValue couponId,
  ) async {
    final refs = <String>[];
    final orderCount = await CustomerOrderRow.db.count(
      session,
      where: (t) => t.couponId.equals(couponId),
    );
    if (orderCount > 0) refs.add('$orderCount order(s)');

    final scopeCount = await CouponProductScopeRow.db.count(
      session,
      where: (t) => t.couponId.equals(couponId),
    );
    if (scopeCount > 0) refs.add('$scopeCount product scope(s)');

    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.couponId.equals(couponId),
    );
    if (bannerCount > 0) refs.add('$bannerCount banner(s)');

    final deliveryRuleCount = await FreeDeliveryRuleRow.db.count(
      session,
      where: (t) => t.couponId.equals(couponId),
    );
    if (deliveryRuleCount > 0) refs.add('$deliveryRuleCount free delivery rule(s)');

    return refs;
  }

  /// Checks if a combo offer is referenced by any entity.
  static Future<List<String>> checkComboOffer(
    Session session,
    UuidValue offerId,
  ) async {
    final refs = <String>[];
    final orderCount = await OrderItemRow.db.count(
      session,
      where: (t) => t.comboOfferId.equals(offerId),
    );
    if (orderCount > 0) refs.add('$orderCount order(s)');

    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.comboOfferId.equals(offerId),
    );
    if (bannerCount > 0) refs.add('$bannerCount banner(s)');

    return refs;
  }

  /// Checks if a BOGO offer is referenced by any entity.
  static Future<List<String>> checkBogoOffer(
    Session session,
    UuidValue offerId,
  ) async {
    final refs = <String>[];
    final orderCount = await OrderItemRow.db.count(
      session,
      where: (t) => t.bogoOfferId.equals(offerId),
    );
    if (orderCount > 0) refs.add('$orderCount order(s)');

    return refs;
  }

  /// Checks if a category offer is referenced by any entity.
  static Future<List<String>> checkCategoryOffer(
    Session session,
    UuidValue offerId,
  ) async {
    final refs = <String>[];
    final scopeCount = await CategoryOfferProductScopeRow.db.count(
      session,
      where: (t) => t.categoryOfferId.equals(offerId),
    );
    if (scopeCount > 0) refs.add('$scopeCount product scope(s)');

    final exclCount = await CategoryOfferProductExclusionRow.db.count(
      session,
      where: (t) => t.categoryOfferId.equals(offerId),
    );
    if (exclCount > 0) refs.add('$exclCount product exclusion(s)');

    return refs;
  }

  /// Checks if a delivery rule is referenced by any entity.
  static Future<List<String>> checkDeliveryRule(
    Session session,
    UuidValue ruleId,
  ) async {
    return <String>[];
  }

  /// Checks if a banner is referenced by any entity.
  static Future<List<String>> checkBanner(
    Session session,
    UuidValue bannerId,
  ) async {
    final refs = <String>[];
    final linkedProductCount = await BannerLinkedProductRow.db.count(
      session,
      where: (t) => t.bannerId.equals(bannerId),
    );
    if (linkedProductCount > 0) refs.add('$linkedProductCount linked product(s)');

    final placementCount = await BannerPlacementRow.db.count(
      session,
      where: (t) => t.bannerId.equals(bannerId),
    );
    if (placementCount > 0) refs.add('$placementCount placement(s)');

    return refs;
  }

  /// Builds a human-readable error message from a list of references.
  static String formatRefs(List<String> refs) {
    if (refs.isEmpty) return '';
    return 'This entity is used in ${refs.join(', ')}. '
        'To delete, first remove these associations or deactivate the entity.';
  }
}
