import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../postgres/postgres_audit_log_service.dart';
import '../postgres/postgres_support.dart';

class CascadeDeactivationService {
  final PostgresAuditLogService _auditLog = PostgresAuditLogService();

  // ═══════════════════════════════════════════════════════════════
  // Public API
  // ═══════════════════════════════════════════════════════════════

  Future<CascadeImpactResponse> analyzeDeactivation(
    Session session,
    String entityType,
    String entityId,
  ) async {
    final parsedId = tryParseUuid(entityId);
    if (parsedId == null) {
      return CascadeImpactResponse(
        primaryEntity: CascadeEntityInfo(
          entityType: entityType,
          entityId: entityId,
          entityName: entityId,
          action: 'error',
          reason: 'Invalid ID',
        ),
        affectedEntities: [],
        protectedEntities: [],
      );
    }

    final (actions, _) = await _analyze(session, entityType, parsedId);
    final affected = actions
        .where((a) => a.action != 'keep')
        .toList();
    final kept = actions
        .where((a) => a.action == 'keep')
        .toList();

    final primary = CascadeEntityInfo(
      entityType: entityType,
      entityId: entityId,
      entityName: await _resolveName(session, entityType, parsedId),
      action: 'deactivate',
      reason: 'Manual deactivation requested',
    );

    return CascadeImpactResponse(
      primaryEntity: primary,
      affectedEntities: affected,
      protectedEntities: kept,
    );
  }

  Future<CascadeExecuteResponse> executeDeactivation(
    Session session,
    String entityType,
    String entityId,
    String actorUserId,
  ) async {
    final parsedId = tryParseUuid(entityId);
    if (parsedId == null) {
      return CascadeExecuteResponse(
        success: false,
        action: 'error',
        deactivatedCount: 0,
        protectedCount: 0,
        message: 'Invalid entity ID',
      );
    }

    final actorId = tryParseUuid(actorUserId);

    return session.db.transaction((tx) async {
      final (actions, productName) = await _analyze(session, entityType, parsedId, tx);

      int deactivatedCount = 0;
      int protectedCount = 0;

      for (final action in actions) {
        switch (action.action) {
          case 'deactivate':
            await _setInactive(session, action.entityType, action.entityId, tx);
            await _auditLog.write(
              session,
              actorUserId: actorId,
              action: 'cascade_deactivate',
              entityType: action.entityType,
              entityId: action.entityId,
              metadata: {
                'reason': action.reason,
                'cascadedFrom': '$entityType:$entityId',
              },
              transaction: tx,
            );
            deactivatedCount++;
          case 'delete_combo_item':
            await _deleteComboItem(session, action.entityId, tx);
            await _auditLog.write(
              session,
              actorUserId: actorId,
              action: 'cascade_combo_item_removed',
              entityType: 'combo_item',
              entityId: action.entityId,
              metadata: {
                'reason': action.reason,
                'cascadedFrom': '$entityType:$entityId',
              },
              transaction: tx,
            );
            deactivatedCount++;
          case 'keep':
            protectedCount++;
        }
      }

      final success = actions.any((a) => a.action != 'keep');
      return CascadeExecuteResponse(
        success: success,
        action: 'cascade_deactivation',
        deactivatedCount: deactivatedCount,
        protectedCount: protectedCount,
        message: success
            ? 'Deactivated $deactivatedCount entit${deactivatedCount == 1 ? 'y' : 'ies'}'
            : 'No entities needed deactivation',
      );
    });
  }

  Future<int> deactivateOrphanBanners(Session session) async {
    final activeBanners = await BannerRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
    );

    int deactivated = 0;
    for (final banner in activeBanners) {
      final targetActive = await _isBannerTargetActive(session, banner);
      if (!targetActive) {
        final now = DateTime.now().toUtc();
        await BannerRow.db.updateRow(
          session,
          banner.copyWith(
            status: 'inactive',
            deactivatedAt: now,
            updatedAt: now,
          ),
        );
        await _auditLog.write(
          session,
          actorUserId: null,
          action: 'banner_cleanup_deactivate',
          entityType: 'banner',
          entityId: banner.id?.toString(),
          metadata: {'reason': 'Target entity is inactive'},
        );
        deactivated++;
      }
    }
    return deactivated;
  }

  // ═══════════════════════════════════════════════════════════════
  // Analysis — returns (actions, primaryEntityName)
  // ═══════════════════════════════════════════════════════════════

  Future<(List<CascadeEntityInfo>, String)> _analyze(
    Session session,
    String entityType,
    UuidValue entityId, [
    Transaction? tx,
  ]) async {
    switch (entityType) {
      case 'product':
        final name = await _resolveProductName(session, entityId, tx);
        final actions = await _analyzeProduct(session, entityId, tx);
        return (actions, name);
      case 'bogo_offer':
        final name = await _resolveBogoOfferName(session, entityId, tx);
        return (await _analyzeBogoOffer(session, entityId, tx), name);
      case 'combo_offer':
        final name = await _resolveComboOfferName(session, entityId, tx);
        return (await _analyzeComboOffer(session, entityId, tx), name);
      case 'category_offer':
        final name = await _resolveCategoryOfferName(session, entityId, tx);
        return (await _analyzeCategoryOffer(session, entityId, tx), name);
      case 'coupon':
        final name = await _resolveCouponName(session, entityId, tx);
        return (await _analyzeCoupon(session, entityId, tx), name);
      case 'delivery_rule':
        final name = await _resolveDeliveryRuleName(session, entityId, tx);
        return (await _analyzeDeliveryRule(session, entityId, tx), name);
      case 'banner':
        final name = await _resolveBannerName(session, entityId, tx);
        return (await _analyzeBanner(session, entityId, tx), name);
      case 'shop_more_get_more_offer':
        final name = await _resolveShopMoreGetMoreOfferName(session, entityId, tx);
        return (await _analyzeShopMoreGetMoreOffer(session, entityId, tx), name);
      default:
        return (
          [CascadeEntityInfo(
            entityType: entityType,
            entityId: entityId.toString(),
            entityName: entityId.toString(),
            action: 'error',
            reason: 'Unknown entity type: $entityType',
          )],
          entityId.toString(),
        );
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Per-entity analysis
  // ═══════════════════════════════════════════════════════════════

  Future<List<CascadeEntityInfo>> _analyzeProduct(
    Session session,
    UuidValue productId, [
    Transaction? tx,
  ]) async {
    final actions = <CascadeEntityInfo>[];

    // 1. Product itself
    actions.add(_info('product', productId.toString(), action: 'deactivate',
        reason: 'Manual product deactivation'));

    // 2. Variants
    final variants = await ProductVariantRow.db.find(
      session,
      where: (t) => t.productId.equals(productId),
      transaction: tx,
    );
    for (final v in variants) {
      actions.add(_info('variant', v.id?.toString() ?? '',
          entityName: v.sku ?? 'unknown',
          action: 'deactivate', reason: 'Parent product deactivated'));
    }

    // 3. BOGO offers where this product is the trigger
    final bogoTriggers = await BogoOfferRow.db.find(
      session,
      where: (t) => t.triggerProductId.equals(productId),
      transaction: tx,
    );
    for (final bogo in bogoTriggers) {
      actions.add(_info('bogo_offer', bogo.id?.toString() ?? '',
          entityName: bogo.title.isNotEmpty ? bogo.title : 'Untitled BOGO',
          action: 'deactivate', reason: 'Trigger product deactivated'));
      await _addBannerRefsForBogo(session, bogo.id!, actions, tx);
    }

    // 4. BOGO offers where this product is a reward
    final rewardRows = await BogoOfferRewardRow.db.find(
      session,
      where: (t) => t.rewardProductId.equals(productId),
      transaction: tx,
    );
    for (final reward in rewardRows) {
      final bogoId = reward.bogoOfferId;
      final bogo = await BogoOfferRow.db.findById(session, bogoId, transaction: tx);
      if (bogo == null) continue;

      final otherRewards = await BogoOfferRewardRow.db.find(
        session,
        where: (t) =>
            t.bogoOfferId.equals(bogoId) &
            t.id.notEquals(reward.id!),
        transaction: tx,
      );
      if (otherRewards.isEmpty) {
        actions.add(_info('bogo_offer', bogoId.toString(),
            entityName: bogo.title.isNotEmpty ? bogo.title : 'Untitled BOGO',
            action: 'deactivate', reason: 'Reward product deactivated (no other rewards)'));
        await _addBannerRefsForBogo(session, bogoId, actions, tx);
      }
    }

    // 5. Combo offers — Option A
    final comboItems = await ComboOfferItemRow.db.find(
      session,
      where: (t) => t.productId.equals(productId),
      transaction: tx,
    );
    for (final item in comboItems) {
      final comboId = item.comboOfferId;
      final combo = await ComboOfferRow.db.findById(session, comboId, transaction: tx);
      if (combo == null) continue;

      final remainingItems = await ComboOfferItemRow.db.find(
        session,
        where: (t) =>
            t.comboOfferId.equals(comboId) &
            t.id.notEquals(item.id!),
        transaction: tx,
      );
      int activeRemaining = 0;
      for (final rem in remainingItems) {
        final p = await ProductRow.db.findById(session, rem.productId, transaction: tx);
        if (p != null && p.status == 'active') activeRemaining++;
      }

      // Always deactivate combo banners (image may be stale)
      await _addBannerRefsForCombo(session, comboId, actions,
          tx: tx, action: 'deactivate',
          reason: 'Combo product deactivated — banner may show outdated content');

      if (activeRemaining < 2) {
        // Not enough products for combo
        actions.add(_info('combo_offer', comboId.toString(),
            entityName: combo.name ?? 'Untitled Combo',
            action: 'deactivate', reason: 'Only $activeRemaining active product(s) remaining (minimum 2 needed)'));
      } else {
        // Remove combo item, keep combo active
        actions.add(_info('combo_offer_item', item.id?.toString() ?? '',
            entityName: combo.name ?? 'Untitled Combo',
            action: 'delete_combo_item', reason: 'Product deactivated — removed from combo'));
      }
    }

    // 5a. Shop More, Get More offers where this product is the reward
    final smgmRewards = await ShopMoreGetMoreOfferRow.db.find(
      session,
      where: (t) => t.freeProductId.equals(productId) & t.status.equals('active'),
      transaction: tx,
    );
    for (final smgm in smgmRewards) {
      actions.add(_info('shop_more_get_more_offer', smgm.id?.toString() ?? '',
          entityName: smgm.name.isNotEmpty ? smgm.name : 'Untitled SMGM',
          action: 'deactivate', reason: 'Reward product deactivated'));
      await _addBannerRefsForShopMoreGetMore(session, smgm.id!, actions, tx);
    }

    // 6. Category offers (scopeProductIds CSV)
    final allProducts = [productId.toString()];
    for (final v in variants) {
      if (v.id != null) allProducts.add(v.id.toString());
    }
    final categoryOffers = await CategoryOfferRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      transaction: tx,
    );
    for (final offer in categoryOffers) {
      final scopeIds = _parseCsv(offer.scopeProductIds);
      final excludeIds = _parseCsv(offer.excludeProductIds);
      final matched = scopeIds.any((id) => allProducts.contains(id));
      if (!matched) continue;
      if (excludeIds.any((id) => allProducts.contains(id))) continue;

      final remainingScopeIds = scopeIds.where((id) => !allProducts.contains(id)).toList();
      if (remainingScopeIds.isEmpty) {
        actions.add(_info('category_offer', offer.id?.toString() ?? '',
            entityName: offer.name ?? 'Untitled Category Offer',
            action: 'deactivate', reason: 'No active products remain in scope'));
        await _addBannerRefsForOffer(session, offer.id!, actions, tx);
      } else {
        int activeRemaining = 0;
        for (final sid in remainingScopeIds) {
          final pid = tryParseUuid(sid);
          if (pid != null) {
            final p = await ProductRow.db.findById(session, pid, transaction: tx);
            if (p != null && p.status == 'active') activeRemaining++;
          }
        }
        if (activeRemaining > 0) {
          actions.add(_info('category_offer', offer.id?.toString() ?? '',
              entityName: offer.name ?? 'Untitled Category Offer',
              action: 'keep', reason: 'Still has $activeRemaining other active product(s) in scope'));
        } else {
          actions.add(_info('category_offer', offer.id?.toString() ?? '',
              entityName: offer.name ?? 'Untitled Category Offer',
              action: 'deactivate', reason: 'No active products remain in scope'));
          await _addBannerRefsForOffer(session, offer.id!, actions, tx);
        }
      }
    }

    // 7. Coupons (productIds CSV)
    final coupons = await CouponRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      transaction: tx,
    );
    for (final coupon in coupons) {
      final cpIds = _parseCsv(coupon.productIds);
      final matched = cpIds.any((id) => productId.toString() == id);
      if (!matched) continue;

      final remainingCpIds = cpIds.where((id) => productId.toString() != id).toList();
      if (remainingCpIds.isEmpty) {
        actions.add(_info('coupon', coupon.id?.toString() ?? '',
            entityName: coupon.code ?? 'Untitled Coupon',
            action: 'deactivate', reason: 'No active products remain in coupon'));
        await _addBannerRefsForCoupon(session, coupon.id!, actions, tx);
        await _addFreeDeliveryRulesForCoupon(session, coupon.id!, actions, tx);
      } else {
        int activeRemaining = 0;
        for (final cpid in remainingCpIds) {
          final pid = tryParseUuid(cpid);
          if (pid != null) {
            final p = await ProductRow.db.findById(session, pid, transaction: tx);
            if (p != null && p.status == 'active') activeRemaining++;
          }
        }
        if (activeRemaining > 0) {
          actions.add(_info('coupon', coupon.id?.toString() ?? '',
              entityName: coupon.code ?? 'Untitled Coupon',
              action: 'keep', reason: 'Still applies to $activeRemaining other active product(s)'));
        } else {
          actions.add(_info('coupon', coupon.id?.toString() ?? '',
              entityName: coupon.code ?? 'Untitled Coupon',
              action: 'deactivate', reason: 'No active products remain in coupon'));
          await _addBannerRefsForCoupon(session, coupon.id!, actions, tx);
          await _addFreeDeliveryRulesForCoupon(session, coupon.id!, actions, tx);
        }
      }
    }

    // 8. Banners directly linked to this product
    await _addBannerRefsForProduct(session, productId, actions, tx);

    return actions;
  }

  Future<List<CascadeEntityInfo>> _analyzeBogoOffer(
    Session session,
    UuidValue offerId, [
    Transaction? tx,
  ]) async {
    final actions = <CascadeEntityInfo>[];
    actions.add(_info('bogo_offer', offerId.toString(), action: 'deactivate',
        reason: 'Manual offer deactivation'));
    await _addBannerRefsForBogo(session, offerId, actions, tx);
    return actions;
  }

  Future<List<CascadeEntityInfo>> _analyzeComboOffer(
    Session session,
    UuidValue offerId, [
    Transaction? tx,
  ]) async {
    final actions = <CascadeEntityInfo>[];
    actions.add(_info('combo_offer', offerId.toString(), action: 'deactivate',
        reason: 'Manual offer deactivation'));
    await _addBannerRefsForCombo(session, offerId, actions,
        tx: tx, action: 'deactivate', reason: 'Offer deactivated');
    return actions;
  }

  Future<List<CascadeEntityInfo>> _analyzeCategoryOffer(
    Session session,
    UuidValue offerId, [
    Transaction? tx,
  ]) async {
    final actions = <CascadeEntityInfo>[];
    actions.add(_info('category_offer', offerId.toString(), action: 'deactivate',
        reason: 'Manual offer deactivation'));
    await _addBannerRefsForOffer(session, offerId, actions, tx);
    return actions;
  }

  Future<List<CascadeEntityInfo>> _analyzeCoupon(
    Session session,
    UuidValue couponId, [
    Transaction? tx,
  ]) async {
    final actions = <CascadeEntityInfo>[];
    actions.add(_info('coupon', couponId.toString(), action: 'deactivate',
        reason: 'Manual coupon deactivation'));
    await _addBannerRefsForCoupon(session, couponId, actions, tx);
    await _addFreeDeliveryRulesForCoupon(session, couponId, actions, tx);
    return actions;
  }

  Future<List<CascadeEntityInfo>> _analyzeDeliveryRule(
    Session session,
    UuidValue ruleId, [
    Transaction? tx,
  ]) async {
    return [
      _info('delivery_rule', ruleId.toString(), action: 'deactivate',
          reason: 'Manual rule deactivation'),
    ];
  }

  Future<List<CascadeEntityInfo>> _analyzeBanner(
    Session session,
    UuidValue bannerId, [
    Transaction? tx,
  ]) async {
    return [
      _info('banner', bannerId.toString(), action: 'deactivate',
          reason: 'Manual banner deactivation'),
    ];
  }

  Future<List<CascadeEntityInfo>> _analyzeShopMoreGetMoreOffer(
    Session session,
    UuidValue offerId, [
    Transaction? tx,
  ]) async {
    final actions = <CascadeEntityInfo>[];
    actions.add(_info('shop_more_get_more_offer', offerId.toString(), action: 'deactivate',
        reason: 'Manual offer deactivation'));
    await _addBannerRefsForShopMoreGetMore(session, offerId, actions, tx);
    return actions;
  }

  // ═══════════════════════════════════════════════════════════════
  // Banner helpers
  // ═══════════════════════════════════════════════════════════════

  Future<void> _addBannerRefsForProduct(
    Session session,
    UuidValue productId,
    List<CascadeEntityInfo> actions, [
    Transaction? tx,
  ]) async {
    final banners = await BannerRow.db.find(
      session,
      where: (t) => t.linkedProductId.equals(productId) & t.status.equals('active'),
      transaction: tx,
    );
    for (final b in banners) {
      actions.add(_info('banner', b.id?.toString() ?? '',
          entityName: b.title,
          action: 'deactivate', reason: 'Linked product deactivated'));
    }
    final csvBanners = await BannerRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      transaction: tx,
    );
    for (final b in csvBanners) {
      if (b.linkedProductIds == null || b.linkedProductIds!.isEmpty) continue;
      final ids = _parseCsv(b.linkedProductIds!);
      if (ids.contains(productId.toString())) {
        actions.add(_info('banner', b.id?.toString() ?? '',
            entityName: b.title,
            action: 'deactivate', reason: 'Linked product deactivated'));
      }
    }
  }

  Future<void> _addBannerRefsForBogo(
    Session session,
    UuidValue offerId,
    List<CascadeEntityInfo> actions, [
    Transaction? tx,
  ]) async {
    final offerIdStr = offerId.toString();
    final banners = await BannerRow.db.find(
      session,
      where: (t) =>
          t.actionType.equals('offer') &
          t.offerId.equals(offerIdStr) &
          t.status.equals('active'),
      transaction: tx,
    );
    for (final b in banners) {
      actions.add(_info('banner', b.id?.toString() ?? '',
          entityName: b.title,
          action: 'deactivate', reason: 'Linked BOGO offer deactivated'));
    }
  }

  Future<void> _addBannerRefsForCombo(
    Session session,
    UuidValue offerId,
    List<CascadeEntityInfo> actions, {
    Transaction? tx,
    required String action,
    required String reason,
  }) async {
    final banners = await BannerRow.db.find(
      session,
      where: (t) => t.comboOfferId.equals(offerId) & t.status.equals('active'),
      transaction: tx,
    );
    for (final b in banners) {
      actions.add(_info('banner', b.id?.toString() ?? '',
          entityName: b.title,
          action: action, reason: reason));
    }
  }

  Future<void> _addBannerRefsForOffer(
    Session session,
    UuidValue offerId,
    List<CascadeEntityInfo> actions, [
    Transaction? tx,
  ]) async {
    final offerIdStr = offerId.toString();
    final banners = await BannerRow.db.find(
      session,
      where: (t) =>
          t.actionType.equals('offer') &
          t.offerId.equals(offerIdStr) &
          t.status.equals('active'),
      transaction: tx,
    );
    for (final b in banners) {
      actions.add(_info('banner', b.id?.toString() ?? '',
          entityName: b.title,
          action: 'deactivate', reason: 'Linked offer deactivated'));
    }
  }

  Future<void> _addBannerRefsForCoupon(
    Session session,
    UuidValue couponId,
    List<CascadeEntityInfo> actions, [
    Transaction? tx,
  ]) async {
    final banners = await BannerRow.db.find(
      session,
      where: (t) => t.couponId.equals(couponId) & t.status.equals('active'),
      transaction: tx,
    );
    for (final b in banners) {
      actions.add(_info('banner', b.id?.toString() ?? '',
          entityName: b.title,
          action: 'deactivate', reason: 'Linked coupon deactivated'));
    }
  }

  Future<void> _addFreeDeliveryRulesForCoupon(
    Session session,
    UuidValue couponId,
    List<CascadeEntityInfo> actions, [
    Transaction? tx,
  ]) async {
    final rules = await FreeDeliveryRuleRow.db.find(
      session,
      where: (t) => t.couponId.equals(couponId) & t.status.equals('active'),
      transaction: tx,
    );
    for (final r in rules) {
      actions.add(_info('free_delivery_rule', r.id?.toString() ?? '',
          entityName: r.name,
          action: 'deactivate', reason: 'Linked coupon deactivated'));
    }
  }

  Future<void> _addBannerRefsForShopMoreGetMore(
    Session session,
    UuidValue offerId,
    List<CascadeEntityInfo> actions, [
    Transaction? tx,
  ]) async {
    final offerIdStr = offerId.toString();
    final banners = await BannerRow.db.find(
      session,
      where: (t) =>
          t.actionType.equals('offer') &
          t.offerId.equals(offerIdStr) &
          t.status.equals('active'),
      transaction: tx,
    );
    for (final b in banners) {
      actions.add(_info('banner', b.id?.toString() ?? '',
          entityName: b.title,
          action: 'deactivate', reason: 'Linked Shop More, Get More offer deactivated'));
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Execution helpers
  // ═══════════════════════════════════════════════════════════════

  Future<void> _setInactive(
    Session session,
    String entityType,
    String entityId, [
    Transaction? tx,
  ]) async {
    final parsedId = tryParseUuid(entityId);
    if (parsedId == null) return;
    final now = DateTime.now().toUtc();

    switch (entityType) {
      case 'product':
        final row = await ProductRow.db.findById(session, parsedId, transaction: tx);
        if (row != null) {
          await ProductRow.db.updateRow(session, row.copyWith(
            status: 'inactive', deactivatedAt: now, updatedAt: now,
          ), transaction: tx);
        }
      case 'variant':
        final row = await ProductVariantRow.db.findById(session, parsedId, transaction: tx);
        if (row != null) {
          await ProductVariantRow.db.updateRow(session, row.copyWith(
            status: 'inactive', deactivatedAt: now, updatedAt: now,
          ), transaction: tx);
        }
      case 'bogo_offer':
        final row = await BogoOfferRow.db.findById(session, parsedId, transaction: tx);
        if (row != null) {
          await BogoOfferRow.db.updateRow(session, row.copyWith(
            status: 'inactive', deactivatedAt: now, updatedAt: now,
          ), transaction: tx);
        }
      case 'combo_offer':
        final row = await ComboOfferRow.db.findById(session, parsedId, transaction: tx);
        if (row != null) {
          await ComboOfferRow.db.updateRow(session, row.copyWith(
            status: 'inactive', deactivatedAt: now, updatedAt: now,
          ), transaction: tx);
        }
      case 'category_offer':
        final row = await CategoryOfferRow.db.findById(session, parsedId, transaction: tx);
        if (row != null) {
          await CategoryOfferRow.db.updateRow(session, row.copyWith(
            status: 'inactive', deactivatedAt: now, updatedAt: now,
          ), transaction: tx);
        }
      case 'coupon':
        final row = await CouponRow.db.findById(session, parsedId, transaction: tx);
        if (row != null) {
          await CouponRow.db.updateRow(session, row.copyWith(
            status: 'inactive', deactivatedAt: now, updatedAt: now,
          ), transaction: tx);
        }
      case 'free_delivery_rule':
        final row = await FreeDeliveryRuleRow.db.findById(session, parsedId, transaction: tx);
        if (row != null) {
          await FreeDeliveryRuleRow.db.updateRow(session, row.copyWith(
            status: 'inactive', deactivatedAt: now, updatedAt: now,
          ), transaction: tx);
        }
      case 'delivery_rule':
        final row = await DeliveryRuleRow.db.findById(session, parsedId, transaction: tx);
        if (row != null) {
          await DeliveryRuleRow.db.updateRow(session, row.copyWith(
            status: 'inactive', deactivatedAt: now, updatedAt: now,
          ), transaction: tx);
        }
      case 'banner':
        final row = await BannerRow.db.findById(session, parsedId, transaction: tx);
        if (row != null) {
          await BannerRow.db.updateRow(session, row.copyWith(
            status: 'inactive', deactivatedAt: now, updatedAt: now,
          ), transaction: tx);
        }
      case 'shop_more_get_more_offer':
        final smgmRow = await ShopMoreGetMoreOfferRow.db.findById(session, parsedId, transaction: tx);
        if (smgmRow != null) {
          await ShopMoreGetMoreOfferRow.db.updateRow(session, smgmRow.copyWith(
            status: 'inactive', deactivatedAt: now, updatedAt: now,
          ), transaction: tx);
        }
    }
  }

  Future<void> _deleteComboItem(
    Session session,
    String comboItemId, [
    Transaction? tx,
  ]) async {
    final parsedId = tryParseUuid(comboItemId);
    if (parsedId == null) return;
    final row = await ComboOfferItemRow.db.findById(session, parsedId, transaction: tx);
    if (row != null) {
      await ComboOfferItemRow.db.deleteRow(session, row, transaction: tx);
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Banner cleanup — target active check
  // ═══════════════════════════════════════════════════════════════

  Future<bool> _isBannerTargetActive(Session session, BannerRow banner) async {
    if (banner.linkedProductId != null) {
      final p = await ProductRow.db.findById(session, banner.linkedProductId!);
      return p != null && p.status == 'active';
    }
    if (banner.comboOfferId != null) {
      final o = await ComboOfferRow.db.findById(session, banner.comboOfferId!);
      return o != null && o.status == 'active';
    }
    if (banner.couponId != null) {
      final c = await CouponRow.db.findById(session, banner.couponId!);
      return c != null && c.status == 'active';
    }
    if (banner.offerId != null && banner.actionType == 'offer') {
      final oid = tryParseUuid(banner.offerId!);
      if (oid == null) return true;
      final bogo = await BogoOfferRow.db.findById(session, oid);
      if (bogo != null) return bogo.status == 'active';
      final cat = await CategoryOfferRow.db.findById(session, oid);
      if (cat != null) return cat.status == 'active';
      final smgm = await ShopMoreGetMoreOfferRow.db.findById(session, oid);
      if (smgm != null) return smgm.status == 'active';
    }
    if (banner.linkedCategoryId != null) {
      final cat = await CategoryRow.db.findById(session, banner.linkedCategoryId!);
      return cat != null && cat.status == 'active';
    }
    if (banner.linkedProductIds != null && banner.linkedProductIds!.isNotEmpty) {
      final ids = _parseCsv(banner.linkedProductIds!);
      for (final idStr in ids) {
        final pid = tryParseUuid(idStr);
        if (pid != null) {
          final p = await ProductRow.db.findById(session, pid);
          if (p != null && p.status == 'active') return true;
        }
      }
      return false;
    }
    return true;
  }

  // ═══════════════════════════════════════════════════════════════
  // Name resolvers
  // ═══════════════════════════════════════════════════════════════

  Future<String> _resolveName(Session session, String entityType, UuidValue id, [Transaction? tx]) async {
    switch (entityType) {
      case 'product': return _resolveProductName(session, id, tx);
      case 'bogo_offer': return _resolveBogoOfferName(session, id, tx);
      case 'combo_offer': return _resolveComboOfferName(session, id, tx);
      case 'category_offer': return _resolveCategoryOfferName(session, id, tx);
      case 'coupon': return _resolveCouponName(session, id, tx);
      case 'delivery_rule': return _resolveDeliveryRuleName(session, id, tx);
      case 'banner': return _resolveBannerName(session, id, tx);
      case 'shop_more_get_more_offer': return _resolveShopMoreGetMoreOfferName(session, id, tx);
      default: return id.toString();
    }
  }

  Future<String> _resolveProductName(Session session, UuidValue id, [Transaction? tx]) async {
    final row = await ProductRow.db.findById(session, id, transaction: tx);
    return row?.name ?? id.toString();
  }

  Future<String> _resolveBogoOfferName(Session session, UuidValue id, [Transaction? tx]) async {
    final row = await BogoOfferRow.db.findById(session, id, transaction: tx);
    return row == null ? id.toString() : (row.title.isNotEmpty ? row.title : id.toString());
  }

  Future<String> _resolveComboOfferName(Session session, UuidValue id, [Transaction? tx]) async {
    final row = await ComboOfferRow.db.findById(session, id, transaction: tx);
    return row?.name ?? id.toString();
  }

  Future<String> _resolveCategoryOfferName(Session session, UuidValue id, [Transaction? tx]) async {
    final row = await CategoryOfferRow.db.findById(session, id, transaction: tx);
    return row?.name ?? id.toString();
  }

  Future<String> _resolveCouponName(Session session, UuidValue id, [Transaction? tx]) async {
    final row = await CouponRow.db.findById(session, id, transaction: tx);
    return row?.code ?? id.toString();
  }

  Future<String> _resolveDeliveryRuleName(Session session, UuidValue id, [Transaction? tx]) async {
    final row = await DeliveryRuleRow.db.findById(session, id, transaction: tx);
    return row?.name ?? id.toString();
  }

  Future<String> _resolveBannerName(Session session, UuidValue id, [Transaction? tx]) async {
    final row = await BannerRow.db.findById(session, id, transaction: tx);
    return row?.title ?? id.toString();
  }

  Future<String> _resolveShopMoreGetMoreOfferName(Session session, UuidValue id, [Transaction? tx]) async {
    final row = await ShopMoreGetMoreOfferRow.db.findById(session, id, transaction: tx);
    return row?.name ?? id.toString();
  }

  // ═══════════════════════════════════════════════════════════════
  // Utilities
  // ═══════════════════════════════════════════════════════════════

  CascadeEntityInfo _info(
    String type,
    String id, {
    String entityName = '',
    required String action,
    required String reason,
  }) {
    return CascadeEntityInfo(
      entityType: type,
      entityId: id,
      entityName: entityName,
      action: action,
      reason: reason,
    );
  }

  List<String> _parseCsv(String? csv) {
    if (csv == null || csv.trim().isEmpty) return [];
    return csv.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }
}
