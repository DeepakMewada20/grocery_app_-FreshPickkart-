import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

class DeleteImpactService {
  static Future<DeleteImpactResponse> checkProductImpact(
    Session session,
    UuidValue productId,
  ) async {
    final refs = <DeleteImpactReference>[];

    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.linkedProductId.equals(productId),
    );
    if (bannerCount > 0) {
      refs.add(DeleteImpactReference(type: 'banners', count: bannerCount));
    }

    final bogoTriggerCount = await BogoOfferRow.db.count(
      session,
      where: (t) => t.triggerProductId.equals(productId),
    );
    if (bogoTriggerCount > 0) {
      refs.add(
        DeleteImpactReference(type: 'bogo_offers', count: bogoTriggerCount),
      );
    }

    final bogoRewardCount = await BogoOfferRewardRow.db.count(
      session,
      where: (t) => t.rewardProductId.equals(productId),
    );
    if (bogoRewardCount > 0) {
      refs.add(
        DeleteImpactReference(type: 'bogo_rewards', count: bogoRewardCount),
      );
    }

    final comboCount = await ComboOfferItemRow.db.count(
      session,
      where: (t) => t.productId.equals(productId),
    );
    if (comboCount > 0) {
      refs.add(DeleteImpactReference(type: 'combo_offers', count: comboCount));
    }

    final idStr = productId.toString();

    final catScopeResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM category_offer WHERE "scopeProductIds" IS NOT NULL AND @id = ANY(string_to_array("scopeProductIds", \',\'))',
      parameters: QueryParameters.named({'id': idStr}),
    );
    final catScopeCount = catScopeResult.isNotEmpty
        ? (catScopeResult.first.toColumnMap()['cnt'] as int?) ?? 0
        : 0;
    if (catScopeCount > 0) {
      refs.add(
        DeleteImpactReference(type: 'category_offers', count: catScopeCount),
      );
    }

    final catExclResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM category_offer WHERE "excludeProductIds" IS NOT NULL AND @id = ANY(string_to_array("excludeProductIds", \',\'))',
      parameters: QueryParameters.named({'id': idStr}),
    );
    final catExclCount = catExclResult.isNotEmpty
        ? (catExclResult.first.toColumnMap()['cnt'] as int?) ?? 0
        : 0;
    if (catExclCount > 0) {
      refs.add(
        DeleteImpactReference(
          type: 'category_offer_exclusions',
          count: catExclCount,
        ),
      );
    }

    final couponResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM coupon WHERE "productIds" IS NOT NULL AND @id = ANY(string_to_array("productIds", \',\'))',
      parameters: QueryParameters.named({'id': idStr}),
    );
    final couponCount = couponResult.isNotEmpty
        ? (couponResult.first.toColumnMap()['cnt'] as int?) ?? 0
        : 0;
    if (couponCount > 0) {
      refs.add(DeleteImpactReference(type: 'coupons', count: couponCount));
    }

    final cartResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM user_cart_item WHERE "productId" = @id',
      parameters: QueryParameters.named({'id': idStr}),
    );
    final cartCount = cartResult.isNotEmpty
        ? (cartResult.first.toColumnMap()['cnt'] as int?) ?? 0
        : 0;
    if (cartCount > 0) {
      refs.add(
        DeleteImpactReference(type: 'cart_items', count: cartCount),
      );
    }

    return DeleteImpactResponse(
      canHardDelete: refs.isEmpty,
      references: refs,
    );
  }

  static Future<DeleteImpactResponse> checkCouponImpact(
    Session session,
    UuidValue couponId,
  ) async {
    final refs = <DeleteImpactReference>[];

    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.couponId.equals(couponId),
    );
    if (bannerCount > 0) {
      refs.add(DeleteImpactReference(type: 'banners', count: bannerCount));
    }

    final deliveryRuleCount = await FreeDeliveryRuleRow.db.count(
      session,
      where: (t) => t.couponId.equals(couponId),
    );
    if (deliveryRuleCount > 0) {
      refs.add(
        DeleteImpactReference(
          type: 'free_delivery_rules',
          count: deliveryRuleCount,
        ),
      );
    }

    return DeleteImpactResponse(
      canHardDelete: refs.isEmpty,
      references: refs,
    );
  }

  static Future<DeleteImpactResponse> checkBogoImpact(
    Session session,
    UuidValue offerId,
  ) async {
    final refs = <DeleteImpactReference>[];

    final offerIdStr = offerId.toString();
    final bannerResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM banner WHERE "actionType" = \'offer\' AND "offerId" = @id',
      parameters: QueryParameters.named({'id': offerIdStr}),
    );
    final bannerCount = bannerResult.isNotEmpty
        ? (bannerResult.first.toColumnMap()['cnt'] as int?) ?? 0
        : 0;
    if (bannerCount > 0) {
      refs.add(DeleteImpactReference(type: 'banners', count: bannerCount));
    }

    return DeleteImpactResponse(
      canHardDelete: refs.isEmpty,
      references: refs,
    );
  }

  static Future<DeleteImpactResponse> checkComboImpact(
    Session session,
    UuidValue comboId,
  ) async {
    final refs = <DeleteImpactReference>[];

    final bannerCount = await BannerRow.db.count(
      session,
      where: (t) => t.comboOfferId.equals(comboId),
    );
    if (bannerCount > 0) {
      refs.add(DeleteImpactReference(type: 'banners', count: bannerCount));
    }

    return DeleteImpactResponse(
      canHardDelete: refs.isEmpty,
      references: refs,
    );
  }

  static Future<DeleteImpactResponse> checkCategoryOfferImpact(
    Session session,
    UuidValue offerId,
  ) async {
    final refs = <DeleteImpactReference>[];

    final offerIdStr = offerId.toString();
    final bannerResult = await session.db.unsafeQuery(
      'SELECT COUNT(*) AS cnt FROM banner WHERE "actionType" = \'offer\' AND "offerId" = @id',
      parameters: QueryParameters.named({'id': offerIdStr}),
    );
    final bannerCount = bannerResult.isNotEmpty
        ? (bannerResult.first.toColumnMap()['cnt'] as int?) ?? 0
        : 0;
    if (bannerCount > 0) {
      refs.add(DeleteImpactReference(type: 'banners', count: bannerCount));
    }

    return DeleteImpactResponse(
      canHardDelete: refs.isEmpty,
      references: refs,
    );
  }

  static Future<DeleteImpactResponse> checkBannerImpact(
    Session session,
    UuidValue bannerId,
  ) async {
    return DeleteImpactResponse(
      canHardDelete: true,
      references: [],
    );
  }
}
