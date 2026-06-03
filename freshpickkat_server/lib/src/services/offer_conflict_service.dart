import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'postgres/postgres_offer_service.dart';
import 'postgres/postgres_product_compat_service.dart';
import 'postgres/postgres_support.dart';

class OfferConflictService {
  OfferConflictService({
    PostgresOfferService? offers,
    PostgresProductCompatService? products,
  }) : _offers = offers ?? PostgresOfferService(),
       _products = products ?? PostgresProductCompatService();

  final PostgresOfferService _offers;
  final PostgresProductCompatService _products;

  Future<OfferConflictResponse> checkBogoConflicts(
    Session session,
    BogoOffer offer,
  ) async {
    return _checkProductOfferConflicts(
      session,
      productIds: [offer.triggerProductId],
      sourceType: 'bogo',
    );
  }

  Future<OfferConflictResponse> checkFreeDeliveryProductConflicts(
    Session session,
    List<String> productIds,
  ) async {
    return _checkProductOfferConflicts(
      session,
      productIds: productIds,
      sourceType: 'free_delivery',
    );
  }

  Future<OfferConflictResponse> checkFreeDeliveryCategoryConflicts(
    Session session,
    String categoryName,
  ) async {
    final productIds = await _activeProductIdsForCategory(
      session,
      categoryName,
    );
    return _checkProductOfferConflicts(
      session,
      productIds: productIds,
      sourceType: 'free_delivery',
    );
  }

  Future<OfferConflictResponse> checkComboConflicts(
    Session session,
    ComboOffer offer,
  ) async {
    final productIds = offer.comboProducts
        .map((item) => item.productId.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
    if (productIds.isEmpty || !offer.isActive) return _none();

    final bogoOffers = await _offers.getActiveBogoOffersForProducts(
      session,
      productIds,
    );
    if (bogoOffers.isNotEmpty) {
      final bogo = bogoOffers.first;
      return OfferConflictResponse(
        hasConflict: true,
        conflictType: 'combo_bogo',
        message:
            'This combo contains a product that already has an active BOGO offer.',
        productIds: [bogo.triggerProductId],
        productNames: await _productNames(session, [bogo.triggerProductId]),
        bogoOffer: bogo,
      );
    }

    final freeDelivery = await _freeDeliveryConflicts(session, productIds);
    if (freeDelivery.products.isNotEmpty) {
      return OfferConflictResponse(
        hasConflict: true,
        conflictType: freeDelivery.hasCategoryConflict
            ? 'combo_category_free_delivery'
            : 'combo_product_free_delivery',
        message: freeDelivery.hasCategoryConflict
            ? 'This combo contains a product from a category with active Free Delivery. Disable category Free Delivery first.'
            : 'This combo contains a product with active Free Delivery.',
        productIds: freeDelivery.products
            .map((product) => product.productId)
            .whereType<String>()
            .toList(),
        productNames: freeDelivery.products
            .map((product) => product.productName)
            .toList(),
      );
    }

    return _none();
  }

  Future<bool> disableCombo(Session session, String comboId) {
    return _offers.setComboOfferActive(session, comboId, false);
  }

  Future<bool> disableBogo(Session session, String triggerProductId) async {
    final parsedTriggerId = tryParseUuid(triggerProductId);
    if (parsedTriggerId == null) return false;
    final rows = await BogoOfferRow.db.find(
      session,
      where: (t) => t.triggerProductId.equals(parsedTriggerId),
    );
    if (rows.isEmpty) return false;
    final now = DateTime.now().toUtc();
    for (final row in rows) {
      await BogoOfferRow.db.updateRow(
        session,
        row.copyWith(
          status: 'inactive',
          deactivatedAt: now,
          updatedAt: now,
        ),
      );
    }
    return true;
  }

  Future<bool> disableFreeDeliveryForProduct(
    Session session,
    String productId,
  ) async {
    final parsedId = tryParseUuid(productId);
    if (parsedId == null) return false;
    final product = await ProductRow.db.findById(session, parsedId);
    if (product == null) return false;
    await ProductRow.db.updateRow(
      session,
      product.copyWith(
        isFreeDelivery: false,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    return true;
  }

  bool isCategoryFreeDeliveryConflict(OfferConflictResponse conflict) {
    return conflict.conflictType?.contains("category_free_delivery") ?? false;
  }

  Future<OfferConflictResponse> _checkProductOfferConflicts(
    Session session, {
    required List<String> productIds,
    required String sourceType,
  }) async {
    final ids = productIds
        .map((id) => id.trim())
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
    if (ids.isEmpty) return _none();

    if (sourceType != 'bogo') {
      final bogoOffers = await _offers.getActiveBogoOffersForProducts(
        session,
        ids,
      );
      if (bogoOffers.isNotEmpty) {
        final bogo = bogoOffers.first;
        return OfferConflictResponse(
          hasConflict: true,
          conflictType: 'free_delivery_bogo',
          message:
              'Free Delivery conflicts with an active BOGO offer on this product.',
          productIds: [bogo.triggerProductId],
          productNames: await _productNames(session, [bogo.triggerProductId]),
          bogoOffer: bogo,
        );
      }
    } else {
      final freeDelivery = await _freeDeliveryConflicts(session, ids);
      if (freeDelivery.products.isNotEmpty) {
        return OfferConflictResponse(
          hasConflict: true,
          conflictType: freeDelivery.hasCategoryConflict
              ? 'bogo_category_free_delivery'
              : 'bogo_product_free_delivery',
          message: freeDelivery.hasCategoryConflict
              ? 'BOGO conflicts with category-level Free Delivery. Disable category Free Delivery first.'
              : 'BOGO conflicts with active Free Delivery on this product.',
          productIds: freeDelivery.products
              .map((product) => product.productId)
              .whereType<String>()
              .toList(),
          productNames: freeDelivery.products
              .map((product) => product.productName)
              .toList(),
        );
      }
    }

    final combos = await _offers.getActiveComboOffersForProducts(session, ids);
    if (combos.isNotEmpty) {
      final combo = combos.first;
      final comboProductIds = combo.comboProducts
          .map((item) => item.productId)
          .toList();
      return OfferConflictResponse(
        hasConflict: true,
        conflictType: '${sourceType}_combo',
        message:
            'This product is part of an active combo. Confirming will disable the whole combo.',
        productIds: comboProductIds,
        productNames: await _productNames(session, comboProductIds),
        comboOffer: combo,
      );
    }

    return _none();
  }

  Future<_FreeDeliveryConflictDetail> _freeDeliveryConflicts(
    Session session,
    List<String> productIds,
  ) async {
    final products = await _products.getProductsByIds(session, productIds);
    final result = <String, Product>{};
    var hasCategoryConflict = false;
    for (final product in products) {
      if (product.isFreeDelivery) {
        final productId = product.productId;
        if (productId != null) result[productId] = product;
      }
    }

    final categoryNames = products
        .map((p) => p.category)
        .where((c) => c.trim().isNotEmpty)
        .toSet()
        .toList();
    if (categoryNames.isNotEmpty) {
      final freeCategories = await CategoryRow.db.find(
        session,
        where: (t) =>
            t.name.inSet(categoryNames.toSet()) & t.isFreeDelivery.equals(true),
      );
      final freeCategoryNames = freeCategories
          .map((c) => c.name.trim().toLowerCase())
          .toSet();
      if (freeCategoryNames.isNotEmpty) {
        for (final product in products) {
          if (freeCategoryNames.contains(
            product.category.trim().toLowerCase(),
          )) {
            hasCategoryConflict = true;
            final productId = product.productId;
            if (productId != null) result[productId] = product;
          }
        }
      }
    }

    return _FreeDeliveryConflictDetail(
      products: result.values.toList(),
      hasCategoryConflict: hasCategoryConflict,
    );
  }

  Future<List<String>> _activeProductIdsForCategory(
    Session session,
    String categoryName,
  ) async {
    final normalizedCategory = categoryName.trim().toLowerCase();
    if (normalizedCategory.isEmpty) return const [];

    final result = await session.db.unsafeQuery(
      """
      SELECT p.id::text AS "productId"
      FROM product p
      JOIN category c ON c.id = p."categoryId"
      WHERE p.status = @activeStatus
        AND c.status = @activeStatus
        AND lower(trim(c.name)) = @categoryName
      """,
      parameters: QueryParameters.named({
        "activeStatus": "active",
        "categoryName": normalizedCategory,
      }),
    );

    return result
        .map((row) => row.toColumnMap()["productId"]?.toString())
        .whereType<String>()
        .toList();
  }

  Future<List<String>> _productNames(
    Session session,
    List<String> productIds,
  ) async {
    final products = await _products.getProductsByIds(session, productIds);
    return products.map((product) => product.productName).toList();
  }

  OfferConflictResponse _none() => OfferConflictResponse(
    hasConflict: false,
    productIds: const [],
    productNames: const [],
  );
}

class _FreeDeliveryConflictDetail {
  const _FreeDeliveryConflictDetail({
    required this.products,
    required this.hasCategoryConflict,
  });

  final List<Product> products;
  final bool hasCategoryConflict;
}
