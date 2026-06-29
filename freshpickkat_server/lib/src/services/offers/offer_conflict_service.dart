import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../postgres/postgres_offer_service.dart';
import '../postgres/postgres_product_compat_service.dart';
import '../postgres/postgres_support.dart';

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

    final freeDeliveryProducts = await _freeDeliveryProducts(
      session,
      productIds,
    );
    if (freeDeliveryProducts.isNotEmpty) {
      return OfferConflictResponse(
        hasConflict: true,
        conflictType: 'combo_product_free_delivery',
        message: 'This combo contains a product with active Free Delivery.',
        productIds: freeDeliveryProducts
            .map((product) => product.productId)
            .whereType<String>()
            .toList(),
        productNames: freeDeliveryProducts
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

  Future<OfferConflictResponse> checkShopMoreGetMoreConflicts(
    Session session,
    ShopMoreGetMoreOffer offer,
  ) async {
    if (!offer.isActive) return _none();

    final bogoOffers = await _offers.getActiveBogoOffersForProducts(
      session,
      [offer.freeProductId],
    );
    if (bogoOffers.isNotEmpty) {
      final bogo = bogoOffers.first;
      return OfferConflictResponse(
        hasConflict: true,
        conflictType: 'smgm_bogo',
        message:
            'The reward product has an active BOGO offer.',
        productIds: [bogo.triggerProductId],
        productNames: await _productNames(session, [bogo.triggerProductId]),
        bogoOffer: bogo,
      );
    }

    final combos = await _offers.getActiveComboOffersForProducts(
      session,
      [offer.freeProductId],
    );
    if (combos.isNotEmpty) {
      final combo = combos.first;
      final comboProductIds = combo.comboProducts
          .map((item) => item.productId)
          .toList();
      return OfferConflictResponse(
        hasConflict: true,
        conflictType: 'smgm_combo',
        message:
            'The reward product is part of an active combo.',
        productIds: comboProductIds,
        productNames: await _productNames(session, comboProductIds),
        comboOffer: combo,
      );
    }

    final freeDeliveryProducts = await _freeDeliveryProducts(
      session,
      [offer.freeProductId],
    );
    if (freeDeliveryProducts.isNotEmpty) {
      return OfferConflictResponse(
        hasConflict: true,
        conflictType: 'smgm_product_free_delivery',
        message: 'The reward product has active Free Delivery.',
        productIds: freeDeliveryProducts
            .map((product) => product.productId)
            .whereType<String>()
            .toList(),
        productNames: freeDeliveryProducts
            .map((product) => product.productName)
            .toList(),
      );
    }

    final parsedFreeProductId = tryParseUuid(offer.freeProductId);
    if (parsedFreeProductId != null) {
      final duplicateSmgm = await ShopMoreGetMoreOfferRow.db.find(
        session,
        where: (t) =>
            t.freeProductId.equals(parsedFreeProductId) &
            t.status.equals('active'),
      );
      if (duplicateSmgm.isNotEmpty) {
        final dup = duplicateSmgm.first;
        return OfferConflictResponse(
          hasConflict: true,
          conflictType: 'smgm_duplicate',
          message:
              'Another active Shop More, Get More offer already uses this reward product.',
          productIds: [offer.freeProductId],
          productNames: await _productNames(session, [offer.freeProductId]),
        );
      }
    }

    return _none();
  }

  Future<bool> disableShopMoreGetMore(Session session, String offerId) {
    return _offers.setShopMoreGetMoreOfferActive(session, offerId, false);
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

      if (sourceType != 'shop_more_get_more') {
        final smgmRows = await ShopMoreGetMoreOfferRow.db.find(
          session,
          where: (t) => t.status.equals('active'),
        );
        final parsedIds = ids.map(tryParseUuid).whereType<UuidValue>().toSet();
        final conflictingSmgm = smgmRows
            .where((row) => parsedIds.contains(row.freeProductId))
            .toList();
        if (conflictingSmgm.isNotEmpty) {
          final smgmIds = conflictingSmgm
              .map((row) => row.freeProductId.toString())
              .toList();
          return OfferConflictResponse(
            hasConflict: true,
            conflictType: '${sourceType}_smgm',
            message:
                'This product is used as a reward in an active Shop More, Get More offer.',
            productIds: smgmIds,
            productNames: await _productNames(session, smgmIds),
          );
        }
      }
    } else {
      final freeDeliveryProducts = await _freeDeliveryProducts(
        session,
        ids,
      );
      if (freeDeliveryProducts.isNotEmpty) {
        return OfferConflictResponse(
          hasConflict: true,
          conflictType: 'bogo_product_free_delivery',
          message: 'BOGO conflicts with active Free Delivery on this product.',
          productIds: freeDeliveryProducts
              .map((product) => product.productId)
              .whereType<String>()
              .toList(),
          productNames: freeDeliveryProducts
              .map((product) => product.productName)
              .toList(),
        );
      }

      final smgmRows = await ShopMoreGetMoreOfferRow.db.find(
        session,
        where: (t) => t.status.equals('active'),
      );
      final parsedIds = ids.map(tryParseUuid).whereType<UuidValue>().toSet();
      final conflictingSmgm = smgmRows
          .where((row) => parsedIds.contains(row.freeProductId))
          .toList();
      if (conflictingSmgm.isNotEmpty) {
        final smgmIds = conflictingSmgm
            .map((row) => row.freeProductId.toString())
            .toList();
        return OfferConflictResponse(
          hasConflict: true,
          conflictType: 'bogo_smgm',
          message:
              'This product is used as a reward in an active Shop More, Get More offer.',
          productIds: smgmIds,
          productNames: await _productNames(session, smgmIds),
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
            'This product is part of an active combo.',
        productIds: comboProductIds,
        productNames: await _productNames(session, comboProductIds),
        comboOffer: combo,
      );
    }

    return _none();
  }

  Future<List<Product>> _freeDeliveryProducts(
    Session session,
    List<String> productIds,
  ) async {
    final products = await _products.getProductsByIds(session, productIds);
    return products.where((product) => product.isFreeDelivery).toList();
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
