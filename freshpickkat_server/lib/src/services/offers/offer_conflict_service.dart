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
