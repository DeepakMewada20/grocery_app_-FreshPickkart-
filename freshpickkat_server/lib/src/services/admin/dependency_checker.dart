import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class DependencyChecker {
  /// Checks if a product is referenced by any active entity.
  static Future<List<String>> checkProduct(
    Session session,
    UuidValue productId,
  ) async {
    final refs = <String>[];
    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.linkedProductId.equals(productId),
    );
    if (bannerCount > 0) refs.add('$bannerCount banner(s)');

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

    final idStr = productId.toString();
    final catScopeResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM category_offer WHERE "scopeProductIds" IS NOT NULL AND @id = ANY(string_to_array("scopeProductIds", \',\'))',
      parameters: QueryParameters.named({'id': idStr}),
    );
    final catScopeCount = catScopeResult.isNotEmpty
        ? (catScopeResult.first.toColumnMap()['cnt'] as int?) ?? 0
        : 0;
    if (catScopeCount > 0) refs.add('$catScopeCount category offer scope(s)');

    final catExclResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM category_offer WHERE "excludeProductIds" IS NOT NULL AND @id = ANY(string_to_array("excludeProductIds", \',\'))',
      parameters: QueryParameters.named({'id': idStr}),
    );
    final catExclCount = catExclResult.isNotEmpty
        ? (catExclResult.first.toColumnMap()['cnt'] as int?) ?? 0
        : 0;
    if (catExclCount > 0) refs.add('$catExclCount category offer exclusion(s)');

    final comboCount = await ComboOfferItemRow.db.count(
      session,
      where: (t) => t.productId.equals(productId),
    );
    if (comboCount > 0) refs.add('$comboCount combo offer(s)');

    final smgmCount = await ShopMoreGetMoreOfferRow.db.count(
      session,
      where: (t) => t.freeProductId.equals(productId),
    );
    if (smgmCount > 0) refs.add('$smgmCount Shop More, Get More offer(s)');

    final couponResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM coupon WHERE "productIds" IS NOT NULL AND @id = ANY(string_to_array("productIds", \',\'))',
      parameters: QueryParameters.named({'id': idStr}),
    );
    final couponCount = couponResult.isNotEmpty
        ? (couponResult.first.toColumnMap()['cnt'] as int?) ?? 0
        : 0;
    if (couponCount > 0) refs.add('$couponCount coupon(s)');

    return refs;
  }

  /// Checks if a product variant is referenced by any entity.
  static Future<List<String>> checkVariant(
    Session session,
    UuidValue variantId,
  ) async {
    final refs = <String>[];
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

    final smgmCount = await ShopMoreGetMoreOfferRow.db.count(
      session,
      where: (t) => t.freeVariantId.equals(variantId),
    );
    if (smgmCount > 0) refs.add('$smgmCount Shop More, Get More offer(s)');

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
    final subIdStr = subCategoryId.toString();
    final productSubResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM product WHERE "subCategoryIds" IS NOT NULL AND @id = ANY(string_to_array("subCategoryIds", \',\'))',
      parameters: QueryParameters.named({'id': subIdStr}),
    );
    final productSubCount = productSubResult.isNotEmpty
        ? (productSubResult.first.toColumnMap()['cnt'] as int?) ?? 0
        : 0;
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

    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.couponId.equals(couponId),
    );
    if (bannerCount > 0) refs.add('$bannerCount banner(s)');

    final deliveryRuleCount = await FreeDeliveryRuleRow.db.count(
      session,
      where: (t) => t.couponId.equals(couponId),
    );
    if (deliveryRuleCount > 0)
      refs.add('$deliveryRuleCount free delivery rule(s)');

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
    return refs;
  }

  /// Checks if a Shop More, Get More offer is referenced by any entity.
  static Future<List<String>> checkShopMoreGetMoreOffer(
    Session session,
    UuidValue offerId,
  ) async {
    final refs = <String>[];
    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.offerId.equals(offerId.toString()),
    );
    if (bannerCount > 0) refs.add('$bannerCount banner(s)');

    final orderCount = await OrderItemRow.db.count(
      session,
      where: (t) => t.rewardOfferId.equals(offerId.toString()),
    );
    if (orderCount > 0) refs.add('$orderCount order(s)');

    return refs;
  }

  /// Checks if a delivery rule is referenced by any entity.
  static Future<List<String>> checkDeliveryRule(
    Session session,
    UuidValue ruleId,
  ) async {
    final refs = <String>[];

    // Check orders that applied this delivery rule (via freeDeliveryReason text match)
    final ruleRow = await DeliveryRuleRow.db.findById(session, ruleId);
    final ruleName = ruleRow?.name;
    if (ruleName != null && ruleName.isNotEmpty) {
      final orderCount = await CustomerOrderRow.db.count(
        session,
        where: (t) =>
            t.freeDeliveryApplied.equals(true) &
            t.freeDeliveryReason.equals(ruleName),
      );
      if (orderCount > 0) {
        refs.add('$orderCount order(s)');
      }
    }

    // Check banners referencing this delivery rule via offerId
    final ruleIdStr = ruleId.toString();
    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.offerId.equals(ruleIdStr) & t.status.equals('active'),
    );
    if (bannerCount > 0) refs.add('$bannerCount banner(s)');

    return refs;
  }

  /// Builds a human-readable error message from a list of references.
  static String formatRefs(List<String> refs) {
    if (refs.isEmpty) return '';
    return 'This entity is used in ${refs.join(', ')}. '
        'To delete, first remove these associations or deactivate the entity.';
  }
}
