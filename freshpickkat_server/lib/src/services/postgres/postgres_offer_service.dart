import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../dependency_checker.dart';
import 'postgres_support.dart';

class PostgresOfferService {
  Future<bool> upsertBogoOffer(Session session, BogoOffer offer) async {
    final triggerProductId = parseUuid(
      offer.triggerProductId,
      fieldName: 'triggerProductId',
    );
    final triggerVariantId = tryParseUuid(offer.triggerVariantId);

    return session.db.transaction<bool>((transaction) async {
      BogoOfferRow? row;
      final providedId = tryParseUuid(offer.offerId);
      if (providedId != null) {
        row = await BogoOfferRow.db.findById(
          session,
          providedId,
          transaction: transaction,
        );
      }
      row ??= await _findBogoByTrigger(
        session,
        triggerProductId: triggerProductId,
        triggerVariantId: triggerVariantId,
        transaction: transaction,
      );

      final now = DateTime.now().toUtc();
      if (row == null) {
        row = await BogoOfferRow.db.insertRow(
          session,
          BogoOfferRow(
            triggerProductId: triggerProductId,
            triggerVariantId: triggerVariantId,
            minTriggerQuantity: offer.minTriggerQuantity ?? 1,
            triggerBaseQuantity: offer.triggerBaseQuantity,
            triggerBaseUnit: cleanNullableString(offer.triggerBaseUnit),
            title: offer.offerTitle.trim().isEmpty
                ? 'Buy 1 Get 1'
                : offer.offerTitle.trim(),
            startsAt: offer.startDate.toUtc(),
            endsAt: offer.endDate.toUtc(),
            status: offer.isActive ? 'active' : 'inactive',
            deactivatedAt: offer.isActive ? null : now,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      } else {
        row = await BogoOfferRow.db.updateRow(
          session,
          row.copyWith(
            triggerProductId: triggerProductId,
            triggerVariantId: triggerVariantId,
            minTriggerQuantity: offer.minTriggerQuantity ?? 1,
            triggerBaseQuantity: offer.triggerBaseQuantity,
            triggerBaseUnit: cleanNullableString(offer.triggerBaseUnit),
            title: offer.offerTitle.trim().isEmpty
                ? row.title
                : offer.offerTitle.trim(),
            startsAt: offer.startDate.toUtc(),
            endsAt: offer.endDate.toUtc(),
            status: offer.isActive ? 'active' : 'inactive',
            deactivatedAt: offer.isActive ? null : now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      }

      await _syncBogoRewards(
        session,
        offerId: row.id!,
        offer: offer,
        transaction: transaction,
      );
      return true;
    });
  }

  Future<String> deleteBogoOffer(
    Session session,
    String triggerProductId,
  ) async {
    final parsedTriggerId = tryParseUuid(triggerProductId);
    if (parsedTriggerId == null) return 'Invalid product ID';

    final rows = await BogoOfferRow.db.find(
      session,
      where: (t) => t.triggerProductId.equals(parsedTriggerId),
    );
    if (rows.isEmpty) return 'Offer not found';

    final offerId = rows.first.id;
    if (offerId == null) return 'Offer not found';

    final refs = await DependencyChecker.checkBogoOffer(session, offerId);
    if (refs.isEmpty) {
      final now = DateTime.now().toUtc();
      await BogoOfferRow.db.updateRow(
        session,
        rows.first.copyWith(
          status: 'inactive',
          deactivatedAt: now,
          updatedAt: now,
        ),
      );
      return '';
    }

    return DependencyChecker.formatRefs(refs);
  }

  Future<HardDeleteResponse> hardDeleteBogoOffer(
    Session session,
    String triggerProductId,
  ) async {
    final parsedTriggerId = tryParseUuid(triggerProductId);
    if (parsedTriggerId == null) {
      return HardDeleteResponse(
        success: false,
        action: 'invalid_id',
        message: 'Invalid product ID.',
      );
    }

    final rows = await BogoOfferRow.db.find(
      session,
      where: (t) => t.triggerProductId.equals(parsedTriggerId),
    );
    if (rows.isEmpty || rows.first.id == null) {
      return HardDeleteResponse(
        success: false,
        action: 'not_found',
        message: 'Offer not found.',
      );
    }

    await BogoOfferRow.db.deleteRow(session, rows.first);
    return HardDeleteResponse(
      success: true,
      action: 'hard_delete',
      message: 'BOGO offer permanently deleted.',
    );
  }

  Future<bool> setBogoOfferActive(
    Session session,
    String triggerProductId,
    bool isActive,
  ) async {
    final parsedTriggerId = tryParseUuid(triggerProductId);
    if (parsedTriggerId == null) return false;

    final rows = await BogoOfferRow.db.find(
      session,
      where: (t) => t.triggerProductId.equals(parsedTriggerId),
    );
    if (rows.isEmpty) return false;

    final now = DateTime.now().toUtc();
    await BogoOfferRow.db.updateRow(
      session,
      rows.first.copyWith(
        status: isActive ? 'active' : 'inactive',
        deactivatedAt: isActive ? null : now,
        updatedAt: now,
      ),
    );
    return true;
  }

  Future<List<BogoOffer>> getInactiveBogoOffers(Session session) async {
    final rows = await BogoOfferRow.db.find(
      session,
      where: (t) => t.status.equals('inactive'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    return _hydrateBogoOffers(session, rows);
  }

  Future<List<BogoOffer>> getAllBogoOffers(Session session) async {
    final rows = await BogoOfferRow.db.find(
      session,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    return _hydrateBogoOffers(session, rows);
  }

  Future<BogoOfferPage> getBogoOffersPage(
    Session session, {
    int limit = 20,
    String? pageToken,
  }) async {
    final offers = await getAllBogoOffers(session);
    offers.sort((a, b) {
      final titleCompare = a.offerTitle.toLowerCase().compareTo(
        b.offerTitle.toLowerCase(),
      );
      if (titleCompare != 0) return titleCompare;
      return a.triggerProductId.compareTo(b.triggerProductId);
    });

    final offset = int.tryParse(pageToken ?? '') ?? 0;
    final safeOffset = offset.clamp(0, offers.length);
    final end =
        (safeOffset + clampPageLimit(limit, defaultLimit: 20)) //
            .clamp(0, offers.length);

    return BogoOfferPage(
      offers: offers.sublist(safeOffset, end),
      nextPageToken: end < offers.length ? '$end' : null,
      totalCount: offers.length,
    );
  }

  Future<List<BogoOffer>> getActiveBogoOffers(Session session) async {
    final now = DateTime.now().toUtc();
    final rows = await BogoOfferRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    final activeRows = rows.where(
      (row) => _isWithinWindow(now, row.startsAt, row.endsAt),
    );
    return _hydrateBogoOffers(session, activeRows.toList());
  }

  Future<BogoOffer?> getBogoOfferForProduct(
    Session session,
    String triggerProductId,
  ) async {
    final parsedTriggerId = tryParseUuid(triggerProductId);
    if (parsedTriggerId == null) return null;

    final rows = await BogoOfferRow.db.find(
      session,
      where: (t) =>
          t.triggerProductId.equals(parsedTriggerId) &
          t.status.equals('active'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    final now = DateTime.now().toUtc();
    final active = rows
        .where((row) => _isWithinWindow(now, row.startsAt, row.endsAt))
        .toList();
    if (active.isEmpty) return null;
    final hydrated = await _hydrateBogoOffers(session, [active.first]);
    return hydrated.isEmpty ? null : hydrated.first;
  }

  Future<List<BogoOffer>> getActiveBogoOffersForProducts(
    Session session,
    List<String> triggerProductIds,
  ) async {
    final parsedIds = triggerProductIds
        .map((id) => tryParseUuid(id))
        .whereType<UuidValue>()
        .toSet();
    if (parsedIds.isEmpty) return const [];

    final rows = await BogoOfferRow.db.find(
      session,
      where: (t) =>
          t.triggerProductId.inSet(parsedIds) & t.status.equals('active'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    final now = DateTime.now().toUtc();
    final activeRows = rows.where(
      (row) => _isWithinWindow(now, row.startsAt, row.endsAt),
    );
    return _hydrateBogoOffers(session, activeRows.toList());
  }

  Future<bool> upsertComboOffer(Session session, ComboOffer offer) async {
    return session.db.transaction<bool>((transaction) async {
      ComboOfferRow? row;
      final providedId = tryParseUuid(offer.comboId);
      if (providedId != null) {
        row = await ComboOfferRow.db.findById(
          session,
          providedId,
          transaction: transaction,
        );
      }

      final now = DateTime.now().toUtc();
      if (row == null) {
        row = await ComboOfferRow.db.insertRow(
          session,
          ComboOfferRow(
            name: offer.name.trim(),
            description: cleanNullableString(offer.description),
            discountType: offer.discountType.trim(),
            discountValue: offer.discountValue,
            minQuantityPerProduct: offer.minQuantityPerProduct,
            maxUsagePerUser: offer.maxUsagePerUser,
            maxUsageTotal: offer.maxTotalUsage,
            usedCount: offer.usageCount,
            priority: offer.priority,
            startsAt: offer.startDate.toUtc(),
            endsAt: offer.endDate.toUtc(),
            status: offer.isActive ? 'active' : 'inactive',
            deactivatedAt: offer.isActive ? null : now,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      } else {
        row = await ComboOfferRow.db.updateRow(
          session,
          row.copyWith(
            name: offer.name.trim(),
            description: cleanNullableString(offer.description),
            discountType: offer.discountType.trim(),
            discountValue: offer.discountValue,
            minQuantityPerProduct: offer.minQuantityPerProduct,
            maxUsagePerUser: offer.maxUsagePerUser,
            maxUsageTotal: offer.maxTotalUsage,
            usedCount: offer.usageCount,
            priority: offer.priority,
            startsAt: offer.startDate.toUtc(),
            endsAt: offer.endDate.toUtc(),
            status: offer.isActive ? 'active' : 'inactive',
            deactivatedAt: offer.isActive ? null : now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      }

      await _syncComboItems(
        session,
        comboOfferId: row.id!,
        items: offer.comboProducts,
        transaction: transaction,
      );
      return true;
    });
  }

  Future<String> deleteComboOffer(Session session, String comboId) async {
    final parsedId = tryParseUuid(comboId);
    if (parsedId == null) return 'Invalid offer ID';

    final row = await ComboOfferRow.db.findById(session, parsedId);
    if (row == null) return 'Offer not found';

    final refs = await DependencyChecker.checkComboOffer(session, parsedId);
    if (refs.isEmpty) {
      final now = DateTime.now().toUtc();
      await ComboOfferRow.db.updateRow(
        session,
        row.copyWith(
          status: 'inactive',
          deactivatedAt: now,
          updatedAt: now,
        ),
      );
      return '';
    }

    return DependencyChecker.formatRefs(refs);
  }

  Future<HardDeleteResponse> hardDeleteComboOffer(
    Session session,
    String comboId,
  ) async {
    final parsedId = tryParseUuid(comboId);
    if (parsedId == null) {
      return HardDeleteResponse(
        success: false,
        action: 'invalid_id',
        message: 'Invalid offer ID.',
      );
    }

    final row = await ComboOfferRow.db.findById(session, parsedId);
    if (row == null) {
      return HardDeleteResponse(
        success: false,
        action: 'not_found',
        message: 'Offer not found.',
      );
    }

    await ComboOfferRow.db.deleteRow(session, row);
    return HardDeleteResponse(
      success: true,
      action: 'hard_delete',
      message: 'Combo offer permanently deleted.',
    );
  }

  Future<List<ComboOffer>> getActiveComboOffers(Session session) async {
    final now = DateTime.now().toUtc();
    final rows = await ComboOfferRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      orderBy: (t) => t.priority,
      orderDescending: true,
    );
    final filtered = rows
        .where((row) => _isWithinWindow(now, row.startsAt, row.endsAt))
        .toList();
    return _hydrateComboOffers(session, filtered);
  }

  Future<List<ComboOffer>> getInactiveComboOffers(Session session) async {
    final rows = await ComboOfferRow.db.find(
      session,
      where: (t) => t.status.equals('inactive'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    return _hydrateComboOffers(session, rows);
  }

  Future<List<ComboOffer>> getAllComboOffers(Session session) async {
    final rows = await ComboOfferRow.db.find(
      session,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    return _hydrateComboOffers(session, rows);
  }

  Future<List<ComboOffer>> getActiveComboOffersForProducts(
    Session session,
    List<String> productIds,
  ) async {
    final parsedIds = productIds
        .map((id) => tryParseUuid(id))
        .whereType<UuidValue>()
        .toSet();
    if (parsedIds.isEmpty) return const [];

    final itemRows = await ComboOfferItemRow.db.find(
      session,
      where: (t) => t.productId.inSet(parsedIds),
    );
    final comboIds = itemRows.map((r) => r.comboOfferId).toSet();
    if (comboIds.isEmpty) return const [];

    final rows = await ComboOfferRow.db.find(
      session,
      where: (t) => t.id.inSet(comboIds) & t.status.equals('active'),
      orderBy: (t) => t.priority,
      orderDescending: true,
    );
    final now = DateTime.now().toUtc();
    final activeRows = rows.where(
      (row) => _isWithinWindow(now, row.startsAt, row.endsAt),
    );
    return _hydrateComboOffers(session, activeRows.toList());
  }

  Future<ComboOfferPage> getComboOffersPage(
    Session session, {
    int limit = 20,
    String? pageToken,
  }) async {
    final offers = await getAllComboOffers(session);
    offers.sort((a, b) {
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    final offset = int.tryParse(pageToken ?? '') ?? 0;
    final safeOffset = offset.clamp(0, offers.length);
    final end =
        (safeOffset + clampPageLimit(limit, defaultLimit: 20)) //
            .clamp(0, offers.length);

    return ComboOfferPage(
      offers: offers.sublist(safeOffset, end),
      nextPageToken: end < offers.length ? '$end' : null,
      totalCount: offers.length,
    );
  }

  Future<bool> setComboOfferActive(
    Session session,
    String comboId,
    bool isActive,
  ) async {
    final parsedId = tryParseUuid(comboId);
    if (parsedId == null) return false;

    final row = await ComboOfferRow.db.findById(session, parsedId);
    if (row == null) return false;
    final now = DateTime.now().toUtc();
    await ComboOfferRow.db.updateRow(
      session,
      row.copyWith(
        status: isActive ? 'active' : 'inactive',
        deactivatedAt: isActive ? null : now,
        updatedAt: now,
      ),
    );
    return true;
  }

  Future<List<ComboOffer>> checkApplicableCombos(
    Session session,
    List<CartItemInput> cartItems,
  ) async {
    final allCombos = await getActiveComboOffers(session);
    final applicable = <ComboOffer>[];
    for (final combo in allCombos) {
      if (_isComboApplicable(combo, cartItems)) {
        applicable.add(combo);
      }
    }
    return applicable;
  }

  Future<bool> upsertCategoryOffer(
    Session session,
    CategoryOffer offer,
  ) async {
    final category = await _resolveCategory(session, offer.categoryId);
    if (category?.id == null) {
      throw Exception('Category not found.');
    }

    return session.db.transaction<bool>((transaction) async {
      CategoryOfferRow? row;
      final providedId = tryParseUuid(offer.offerId);
      if (providedId != null) {
        row = await CategoryOfferRow.db.findById(
          session,
          providedId,
          transaction: transaction,
        );
      }

      final now = DateTime.now().toUtc();
      if (row == null) {
        row = await CategoryOfferRow.db.insertRow(
          session,
          CategoryOfferRow(
            categoryId: category!.id!,
            name: offer.name.trim(),
            description: cleanNullableString(offer.description),
            discountType: offer.discountType.trim(),
            discountValue: offer.discountValue,
            maxDiscountAmount: offer.maxDiscount,
            minOrderAmount: offer.minOrderAmount,
            priority: offer.priority,
            startsAt: offer.startDate.toUtc(),
            endsAt: offer.endDate.toUtc(),
            status: offer.isActive ? 'active' : 'inactive',
            deactivatedAt: offer.isActive ? null : now,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      } else {
        row = await CategoryOfferRow.db.updateRow(
          session,
          row.copyWith(
            categoryId: category!.id!,
            name: offer.name.trim(),
            description: cleanNullableString(offer.description),
            discountType: offer.discountType.trim(),
            discountValue: offer.discountValue,
            maxDiscountAmount: offer.maxDiscount,
            minOrderAmount: offer.minOrderAmount,
            priority: offer.priority,
            startsAt: offer.startDate.toUtc(),
            endsAt: offer.endDate.toUtc(),
            status: offer.isActive ? 'active' : 'inactive',
            deactivatedAt: offer.isActive ? null : now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
      }

      await _syncCategoryOfferScopes(
        session,
        offerId: row.id!,
        productIds: offer.productIds ?? const <String>[],
        exclusions: offer.excludeProductIds ?? const <String>[],
        transaction: transaction,
      );
      return true;
    });
  }

  Future<String> deleteCategoryOffer(Session session, String offerId) async {
    final parsedId = tryParseUuid(offerId);
    if (parsedId == null) return 'Invalid offer ID';

    final row = await CategoryOfferRow.db.findById(session, parsedId);
    if (row == null) return 'Offer not found';

    final refs = await DependencyChecker.checkCategoryOffer(session, parsedId);
    if (refs.isEmpty) {
      final now = DateTime.now().toUtc();
      await CategoryOfferRow.db.updateRow(
        session,
        row.copyWith(
          status: 'inactive',
          deactivatedAt: now,
          updatedAt: now,
        ),
      );
      return '';
    }

    return DependencyChecker.formatRefs(refs);
  }

  Future<HardDeleteResponse> hardDeleteCategoryOffer(
    Session session,
    String offerId,
  ) async {
    final parsedId = tryParseUuid(offerId);
    if (parsedId == null) {
      return HardDeleteResponse(
        success: false,
        action: 'invalid_id',
        message: 'Invalid offer ID.',
      );
    }

    final row = await CategoryOfferRow.db.findById(session, parsedId);
    if (row == null) {
      return HardDeleteResponse(
        success: false,
        action: 'not_found',
        message: 'Offer not found.',
      );
    }

    await CategoryOfferRow.db.deleteRow(session, row);
    return HardDeleteResponse(
      success: true,
      action: 'hard_delete',
      message: 'Category offer permanently deleted.',
    );
  }

  Future<List<CategoryOffer>> getActiveCategoryOffers(Session session) async {
    final now = DateTime.now().toUtc();
    final rows = await CategoryOfferRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
      orderBy: (t) => t.priority,
      orderDescending: true,
    );
    final filtered = rows
        .where((row) => _isWithinWindow(now, row.startsAt, row.endsAt))
        .toList();
    return _hydrateCategoryOffers(session, filtered);
  }

  Future<List<CategoryOffer>> getInactiveCategoryOffers(Session session) async {
    final rows = await CategoryOfferRow.db.find(
      session,
      where: (t) => t.status.equals('inactive'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    return _hydrateCategoryOffers(session, rows);
  }

  Future<List<CategoryOffer>> getAllCategoryOffers(Session session) async {
    final rows = await CategoryOfferRow.db.find(
      session,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
    return _hydrateCategoryOffers(session, rows);
  }

  Future<CategoryOfferPage> getCategoryOffersPage(
    Session session, {
    int limit = 20,
    String? pageToken,
  }) async {
    final offers = await getAllCategoryOffers(session);
    offers.sort((a, b) {
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    final offset = int.tryParse(pageToken ?? '') ?? 0;
    final safeOffset = offset.clamp(0, offers.length);
    final end =
        (safeOffset + clampPageLimit(limit, defaultLimit: 20)) //
            .clamp(0, offers.length);

    return CategoryOfferPage(
      offers: offers.sublist(safeOffset, end),
      nextPageToken: end < offers.length ? '$end' : null,
      totalCount: offers.length,
    );
  }

  Future<bool> setCategoryOfferActive(
    Session session,
    String offerId,
    bool isActive,
  ) async {
    final parsedId = tryParseUuid(offerId);
    if (parsedId == null) return false;

    final row = await CategoryOfferRow.db.findById(session, parsedId);
    if (row == null) return false;
    final now = DateTime.now().toUtc();
    await CategoryOfferRow.db.updateRow(
      session,
      row.copyWith(
        status: isActive ? 'active' : 'inactive',
        deactivatedAt: isActive ? null : now,
        updatedAt: now,
      ),
    );
    return true;
  }

  Future<List<BogoOffer>> _hydrateBogoOffers(
    Session session,
    List<BogoOfferRow> rows,
  ) async {
    if (rows.isEmpty) return [];

    final offerIds = rows.map((row) => row.id!).toSet();
    final rewards = await BogoOfferRewardRow.db.find(
      session,
      where: (t) => t.bogoOfferId.inSet(offerIds),
    );
    final rewardsByOffer = <String, List<BogoOfferRewardRow>>{};
    for (final reward in rewards) {
      rewardsByOffer
          .putIfAbsent(reward.bogoOfferId.toString(), () => [])
          .add(reward);
    }

    return rows.map((row) {
      final rowRewards =
          rewardsByOffer[row.id!.toString()] ?? const <BogoOfferRewardRow>[];
      return BogoOffer(
        offerId: row.id!.toString(),
        triggerProductId: row.triggerProductId.toString(),
        triggerVariantId: row.triggerVariantId?.toString(),
        minTriggerQuantity: row.minTriggerQuantity,
        triggerBaseQuantity: row.triggerBaseQuantity,
        triggerBaseUnit: row.triggerBaseUnit,
        freeProductIds: rowRewards
            .map((reward) => reward.rewardProductId.toString())
            .toList(),
        freeProducts: rowRewards
            .map(
              (reward) => BogoFreeProduct(
                productId: reward.rewardProductId.toString(),
                variantId: reward.rewardVariantId?.toString(),
                freeQuantity: reward.freeQuantity,
              ),
            )
            .toList(),
        offerTitle: row.title,
        isActive: row.status == 'active',
        startDate: row.startsAt,
        endDate: row.endsAt,
        createdAt: row.createdAt,
      );
    }).toList();
  }

  Future<List<ComboOffer>> _hydrateComboOffers(
    Session session,
    List<ComboOfferRow> rows,
  ) async {
    if (rows.isEmpty) return [];

    final comboIds = rows.map((row) => row.id!).toSet();
    final items = await ComboOfferItemRow.db.find(
      session,
      where: (t) => t.comboOfferId.inSet(comboIds),
    );
    final productIds = items.map((item) => item.productId).toSet();
    final products = productIds.isEmpty
        ? <ProductRow>[]
        : await ProductRow.db.find(
            session,
            where: (t) => t.id.inSet(productIds),
          );
    final productNameById = {
      for (final product in products) product.id!.toString(): product.name,
    };

    final itemsByCombo = <String, List<ComboOfferItemRow>>{};
    for (final item in items) {
      itemsByCombo
          .putIfAbsent(item.comboOfferId.toString(), () => [])
          .add(item);
    }

    return rows.map((row) {
      final comboItems =
          itemsByCombo[row.id!.toString()] ?? const <ComboOfferItemRow>[];
      comboItems.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return ComboOffer(
        comboId: row.id!.toString(),
        name: row.name,
        description: row.description,
        comboProducts: comboItems
            .map(
              (item) => ComboProductItem(
                productId: item.productId.toString(),
                productName: productNameById[item.productId.toString()],
                quantity: item.quantity,
                variantId: item.productVariantId?.toString(),
              ),
            )
            .toList(),
        discountType: row.discountType,
        discountValue: row.discountValue,
        minQuantityPerProduct: row.minQuantityPerProduct,
        startDate: row.startsAt,
        endDate: row.endsAt,
        isActive: row.status == 'active',
        priority: row.priority,
        maxUsagePerUser: row.maxUsagePerUser ?? 0,
        usageCount: row.usedCount,
        maxTotalUsage: row.maxUsageTotal,
        createdAt: row.createdAt,
      );
    }).toList();
  }

  Future<List<CategoryOffer>> _hydrateCategoryOffers(
    Session session,
    List<CategoryOfferRow> rows,
  ) async {
    if (rows.isEmpty) return [];

    final categoryIds = rows.map((row) => row.categoryId).toSet();
    final categories = await CategoryRow.db.find(
      session,
      where: (t) => t.id.inSet(categoryIds),
    );
    final categoryById = {
      for (final category in categories) category.id!.toString(): category,
    };

    return rows.map((row) {
      final category = categoryById[row.categoryId.toString()];
      final categoryName = category?.name ?? row.categoryId.toString();
      return CategoryOffer(
        offerId: row.id!.toString(),
        name: row.name,
        description: row.description,
        categoryId: categoryName,
        categoryName: categoryName,
        discountType: row.discountType,
        discountValue: row.discountValue,
        maxDiscount: row.maxDiscountAmount,
        minOrderAmount: row.minOrderAmount,
        productIds:
            row.scopeProductIds != null && row.scopeProductIds!.isNotEmpty
            ? row.scopeProductIds!
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList()
            : null,
        excludeProductIds:
            row.excludeProductIds != null && row.excludeProductIds!.isNotEmpty
            ? row.excludeProductIds!
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList()
            : null,
        startDate: row.startsAt,
        endDate: row.endsAt,
        isActive: row.status == 'active',
        priority: row.priority,
        createdAt: row.createdAt,
      );
    }).toList();
  }

  Future<BogoOfferRow?> _findBogoByTrigger(
    Session session, {
    required UuidValue triggerProductId,
    required UuidValue? triggerVariantId,
    required Transaction transaction,
  }) async {
    final rows = await BogoOfferRow.db.find(
      session,
      where: (t) => t.triggerProductId.equals(triggerProductId),
      transaction: transaction,
    );
    for (final row in rows) {
      if (row.triggerVariantId == triggerVariantId) {
        return row;
      }
    }
    return null;
  }

  Future<void> _syncBogoRewards(
    Session session, {
    required UuidValue offerId,
    required BogoOffer offer,
    required Transaction transaction,
  }) async {
    final freeProducts = offer.freeProducts ?? [];
    final desiredRows = freeProducts
        .map(
          (p) => _RewardSpec(
            productId: UuidValue.fromString(p.productId),
            variantId: p.variantId != null
                ? UuidValue.fromString(p.variantId!)
                : null,
            freeQuantity: _normalizeFreeQuantity(p.freeQuantity),
          ),
        )
        .toList();

    final existing = await BogoOfferRewardRow.db.find(
      session,
      where: (t) => t.bogoOfferId.equals(offerId),
      transaction: transaction,
    );
    if (existing.isNotEmpty) {
      await BogoOfferRewardRow.db.delete(
        session,
        existing,
        transaction: transaction,
      );
    }

    for (final spec in desiredRows) {
      await BogoOfferRewardRow.db.insertRow(
        session,
        BogoOfferRewardRow(
          bogoOfferId: offerId,
          rewardProductId: spec.productId,
          rewardVariantId: spec.variantId,
          freeQuantity: spec.freeQuantity,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
    }
  }

  Future<void> _syncComboItems(
    Session session, {
    required UuidValue comboOfferId,
    required List<ComboProductItem> items,
    required Transaction transaction,
  }) async {
    final existing = await ComboOfferItemRow.db.find(
      session,
      where: (t) => t.comboOfferId.equals(comboOfferId),
      transaction: transaction,
    );
    if (existing.isNotEmpty) {
      await ComboOfferItemRow.db.delete(
        session,
        existing,
        transaction: transaction,
      );
    }

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final productId = tryParseUuid(item.productId);
      if (productId == null) continue;
      await ComboOfferItemRow.db.insertRow(
        session,
        ComboOfferItemRow(
          comboOfferId: comboOfferId,
          productId: productId,
          productVariantId: tryParseUuid(item.variantId),
          quantity: item.quantity,
          sortOrder: i,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
    }
  }

  Future<void> _syncCategoryOfferScopes(
    Session session, {
    required UuidValue offerId,
    required List<String> productIds,
    required List<String> exclusions,
    required Transaction transaction,
  }) async {
    final scopeStr = productIds
        .map(tryParseUuid)
        .whereType<UuidValue>()
        .map((id) => id.toString())
        .join(',');
    final exclStr = exclusions
        .map(tryParseUuid)
        .whereType<UuidValue>()
        .map((id) => id.toString())
        .join(',');
    final row = await CategoryOfferRow.db.findById(
      session,
      offerId,
      transaction: transaction,
    );
    if (row == null) return;
    final updated = row.copyWith(
      scopeProductIds: scopeStr.isEmpty ? null : scopeStr,
      excludeProductIds: exclStr.isEmpty ? null : exclStr,
    );
    await CategoryOfferRow.db.updateRow(
      session,
      updated,
      transaction: transaction,
    );
  }

  Future<CategoryRow?> _resolveCategory(
    Session session,
    String rawValue,
  ) async {
    final trimmed = rawValue.trim();
    if (trimmed.isEmpty) return null;

    final parsedId = tryParseUuid(trimmed);
    if (parsedId != null) {
      final byId = await CategoryRow.db.findById(session, parsedId);
      if (byId != null) return byId;
    }

    final rows = await CategoryRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
    );
    final lowered = trimmed.toLowerCase();
    for (final row in rows) {
      if (row.name.trim().toLowerCase() == lowered) {
        return row;
      }
    }
    return null;
  }

  bool _isComboApplicable(ComboOffer combo, List<CartItemInput> cartItems) {
    for (final comboProduct in combo.comboProducts) {
      CartItemInput? cartItem;
      for (final item in cartItems) {
        final matchesVariant =
            comboProduct.variantId == null ||
            comboProduct.variantId!.trim().isEmpty ||
            item.variantId == comboProduct.variantId;
        if (item.productId == comboProduct.productId &&
            matchesVariant &&
            item.quantity >= comboProduct.quantity) {
          cartItem = item;
          break;
        }
      }
      if (cartItem == null) return false;
    }
    return true;
  }

  bool _isWithinWindow(DateTime now, DateTime startsAt, DateTime endsAt) {
    return !now.isBefore(startsAt) && !now.isAfter(endsAt);
  }

  int _normalizeFreeQuantity(int? quantity) {
    final value = quantity ?? 1;
    return value <= 0 ? 1 : value;
  }
}

class _RewardSpec {
  _RewardSpec({
    required this.productId,
    this.variantId,
    required this.freeQuantity,
  });

  final UuidValue productId;
  final UuidValue? variantId;
  final int freeQuantity;
}
