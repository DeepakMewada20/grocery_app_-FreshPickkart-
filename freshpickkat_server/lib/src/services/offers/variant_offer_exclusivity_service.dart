import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../postgres/postgres_support.dart';
import 'effective_offer_resolver.dart';

class VariantOfferExclusivityService {
  /// Validates that saving a BOGO offer wouldn't cause any variant to have
  /// multiple variant-based offers (BOGO / Combo / Free Delivery).
  ///
  /// Returns `null` if valid, or an error message if blocked.
  static Future<String?> validateBogoSave(
    Session session,
    BogoOffer offer, {
    String? existingOfferId,
  }) async {
    final productId = offer.triggerProductId;
    final productRow = await ProductRow.db.findById(
      session,
      tryParseUuid(productId) ?? UuidValue.fromString(productId),
    );
    if (productRow == null) return null;

    final variantRows = await ProductVariantRow.db.find(
      session,
      where: (t) => t.productId.equals(productRow.id!),
    );

    // Existing BOGO offers on this product (exclude the one being edited)
    final existingBogoRows = await BogoOfferRow.db.find(
      session,
      where: (t) =>
          t.triggerProductId.equals(productRow.id!) & t.status.equals('active'),
    );
    final now = DateTime.now().toUtc();
    final existingBogo = existingBogoRows
        .where(
          (r) =>
              !now.isBefore(r.startsAt) &&
              !now.isAfter(r.endsAt) &&
              r.id.toString() != existingOfferId,
        )
        .toList();

    // Existing combo offers involving this product
    final comboItemRows = await ComboOfferItemRow.db.find(
      session,
      where: (t) => t.productId.equals(productRow.id!),
    );
    final comboIds = comboItemRows.map((r) => r.comboOfferId).toSet();
    final comboRows = comboIds.isEmpty
        ? <ComboOfferRow>[]
        : await ComboOfferRow.db.find(
            session,
            where: (t) => t.id.inSet(comboIds) & t.status.equals('active'),
          );
    final activeComboIds = comboRows
        .where((r) => !now.isBefore(r.startsAt) && !now.isAfter(r.endsAt))
        .map((r) => r.id!.toString())
        .toSet();
    final applicableComboItems = comboItemRows
        .where((r) => activeComboIds.contains(r.comboOfferId.toString()))
        .toList();

    return _checkExclusivity(
      variantRows: variantRows,
      productHasFreeDelivery: productRow.isFreeDelivery,
      existingBogoRows: existingBogo,
      existingComboItems: applicableComboItems,
      proposedBogoVariantId: offer.triggerVariantId?.trim(),
      proposedBogoIsProductLevel:
          offer.triggerVariantId == null ||
          offer.triggerVariantId!.trim().isEmpty,
    );
  }

  /// Validates that saving a combo offer wouldn't violate exclusivity.
  static Future<String?> validateComboSave(
    Session session,
    ComboOffer offer, {
    String? existingComboId,
  }) async {
    // Check each product in the combo
    for (final item in offer.comboProducts) {
      final err = await _validateComboProduct(
        session,
        productId: item.productId,
        variantId: item.variantId?.trim(),
        existingComboId: existingComboId,
      );
      if (err != null) return err;
    }
    return null;
  }

  static Future<String?> _validateComboProduct(
    Session session, {
    required String productId,
    String? variantId,
    String? existingComboId,
  }) async {
    final parsedProductId = tryParseUuid(productId);
    if (parsedProductId == null) return null;

    final productRow = await ProductRow.db.findById(session, parsedProductId);
    if (productRow == null) return null;

    final variantRows = await ProductVariantRow.db.find(
      session,
      where: (t) => t.productId.equals(productRow.id!),
    );

    // Existing active BOGO offers on this product
    final bogoRows = await BogoOfferRow.db.find(
      session,
      where: (t) =>
          t.triggerProductId.equals(productRow.id!) & t.status.equals('active'),
    );
    final now = DateTime.now().toUtc();
    final activeBogo = bogoRows
        .where(
          (r) => !now.isBefore(r.startsAt) && !now.isAfter(r.endsAt),
        )
        .toList();

    // Existing combo offers involving this product (exclude the one being edited)
    final comboItemRows = await ComboOfferItemRow.db.find(
      session,
      where: (t) => t.productId.equals(productRow.id!),
    );
    final otherComboItemRows = existingComboId != null
        ? comboItemRows
              .where((r) => r.comboOfferId.toString() != existingComboId)
              .toList()
        : comboItemRows;
    final otherComboIds = otherComboItemRows.map((r) => r.comboOfferId).toSet();
    final otherComboRows = otherComboIds.isEmpty
        ? <ComboOfferRow>[]
        : await ComboOfferRow.db.find(
            session,
            where: (t) => t.id.inSet(otherComboIds) & t.status.equals('active'),
          );
    final activeOtherComboIds = otherComboRows
        .where((r) => !now.isBefore(r.startsAt) && !now.isAfter(r.endsAt))
        .map((r) => r.id!.toString())
        .toSet();
    final applicableOtherComboItems = otherComboItemRows
        .where((r) => activeOtherComboIds.contains(r.comboOfferId.toString()))
        .toList();

    return _checkExclusivity(
      variantRows: variantRows,
      productHasFreeDelivery: productRow.isFreeDelivery,
      existingBogoRows: activeBogo,
      existingComboItems: applicableOtherComboItems,
      proposedComboVariantId: variantId,
    );
  }

  /// Validates that enabling free delivery on a product wouldn't violate
  /// exclusivity.
  static Future<String?> validateFreeDeliveryEnable(
    Session session,
    String productId,
  ) async {
    final parsedId = tryParseUuid(productId);
    if (parsedId == null) return null;

    final productRow = await ProductRow.db.findById(session, parsedId);
    if (productRow == null) return null;

    final variantRows = await ProductVariantRow.db.find(
      session,
      where: (t) => t.productId.equals(productRow.id!),
    );

    // Existing active BOGO offers
    final bogoRows = await BogoOfferRow.db.find(
      session,
      where: (t) =>
          t.triggerProductId.equals(productRow.id!) & t.status.equals('active'),
    );
    final now = DateTime.now().toUtc();
    final activeBogo = bogoRows
        .where(
          (r) => !now.isBefore(r.startsAt) && !now.isAfter(r.endsAt),
        )
        .toList();

    // Existing combo offers involving this product
    final comboItemRows = await ComboOfferItemRow.db.find(
      session,
      where: (t) => t.productId.equals(productRow.id!),
    );
    final comboIds = comboItemRows.map((r) => r.comboOfferId).toSet();
    final comboRows = comboIds.isEmpty
        ? <ComboOfferRow>[]
        : await ComboOfferRow.db.find(
            session,
            where: (t) => t.id.inSet(comboIds) & t.status.equals('active'),
          );
    final activeComboIds = comboRows
        .where((r) => !now.isBefore(r.startsAt) && !now.isAfter(r.endsAt))
        .map((r) => r.id!.toString())
        .toSet();
    final applicableComboItems = comboItemRows
        .where((r) => activeComboIds.contains(r.comboOfferId.toString()))
        .toList();

    return _checkExclusivity(
      variantRows: variantRows,
      productHasFreeDelivery: false,
      existingBogoRows: activeBogo,
      existingComboItems: applicableComboItems,
      proposedFreeDelivery: true,
    );
  }

  /// Validates that disabling free delivery wouldn't leave any orphan state.
  /// Disabling FD can only remove offers, so this is always valid, but we
  /// include the hook for completeness / future rules.
  static Future<String?> validateFreeDeliveryDisable(
    Session session,
    String productId,
  ) async {
    // Disabling FD only removes the FD offer — it cannot cause a conflict.
    return null;
  }

  /// Validates that saving a Shop More, Get More offer wouldn't violate
  /// exclusivity (the reward product shouldn't already be in another offer).
  static Future<String?> validateShopMoreGetMoreSave(
    Session session,
    ShopMoreGetMoreOffer offer, {
    String? existingOfferId,
  }) async {
    final productId = offer.freeProductId;
    final parsedProductId = tryParseUuid(productId);
    if (parsedProductId == null) return null;

    final productRow = await ProductRow.db.findById(session, parsedProductId);
    if (productRow == null) return null;

    final variantRows = await ProductVariantRow.db.find(
      session,
      where: (t) => t.productId.equals(productRow.id!),
    );

    // Existing BOGO offers where this product is the trigger
    final bogoRows = await BogoOfferRow.db.find(
      session,
      where: (t) =>
          t.triggerProductId.equals(productRow.id!) & t.status.equals('active'),
    );
    final now = DateTime.now().toUtc();
    final activeBogo = bogoRows
        .where(
          (r) => !now.isBefore(r.startsAt) && !now.isAfter(r.endsAt),
        )
        .toList();

    // Existing combo offers involving this product
    final comboItemRows = await ComboOfferItemRow.db.find(
      session,
      where: (t) => t.productId.equals(productRow.id!),
    );
    final comboIds = comboItemRows.map((r) => r.comboOfferId).toSet();
    final comboRows = comboIds.isEmpty
        ? <ComboOfferRow>[]
        : await ComboOfferRow.db.find(
            session,
            where: (t) => t.id.inSet(comboIds) & t.status.equals('active'),
          );
    final activeComboIds = comboRows
        .where((r) => !now.isBefore(r.startsAt) && !now.isAfter(r.endsAt))
        .map((r) => r.id!.toString())
        .toSet();
    final applicableComboItems = comboItemRows
        .where((r) => activeComboIds.contains(r.comboOfferId.toString()))
        .toList();

    return _checkExclusivity(
      variantRows: variantRows,
      productHasFreeDelivery: productRow.isFreeDelivery,
      existingBogoRows: activeBogo,
      existingComboItems: applicableComboItems,
      proposedShopMoreGetMore: true,
      proposedShopMoreGetMoreVariantId: offer.freeVariantId,
    );
  }

  /// Core exclusivity check.
  ///
  /// Builds a per-variant set of active offer types ({'bogo', 'combo',
  /// 'free_delivery', 'shop_more_get_more'}), applies proposed changes, then
  /// verifies no variant has more than one type active.
  static Future<String?> _checkExclusivity({
    required List<ProductVariantRow> variantRows,
    required bool productHasFreeDelivery,
    required List<BogoOfferRow> existingBogoRows,
    required List<ComboOfferItemRow> existingComboItems,
    String? proposedBogoVariantId,
    bool proposedBogoIsProductLevel = false,
    String? proposedComboVariantId,
    bool proposedFreeDelivery = false,
    bool proposedShopMoreGetMore = false,
    String? proposedShopMoreGetMoreVariantId,
  }) async {
    if (variantRows.isEmpty) return null;

    // Identify default variant for product-level BOGO / FD
    final defaultVariant = variantRows.cast<ProductVariantRow?>().firstWhere(
      (v) => v != null && v.isDefault,
      orElse: () => variantRows.cast<ProductVariantRow?>().firstWhere(
        (v) => v != null && v.isAvailable,
        orElse: () => variantRows.first,
      ),
    );

    // Build FD sources (before proposed change)
    final fdSourcesBefore = <ProductVariantRow>[
      for (final v in variantRows)
        if (v.isFreeDelivery) v,
      if (productHasFreeDelivery && defaultVariant != null) defaultVariant,
    ];

    // Per-variant active offer types
    final activeTypes = <String, Set<String>>{};
    for (final v in variantRows) {
      activeTypes[v.id!.toString()] = <String>{};
    }

    // ── Populate existing BOGO ──
    for (final bogo in existingBogoRows) {
      if (bogo.triggerVariantId != null) {
        final vid = bogo.triggerVariantId.toString();
        if (activeTypes.containsKey(vid)) {
          activeTypes[vid]!.add('bogo');
        }
      } else {
        // Product-level BOGO → only default variant
        if (defaultVariant != null) {
          activeTypes[defaultVariant.id.toString()]!.add('bogo');
        }
      }
    }

    // ── Populate existing combo ──
    for (final item in existingComboItems) {
      if (item.productVariantId != null) {
        final vid = item.productVariantId.toString();
        if (activeTypes.containsKey(vid)) {
          activeTypes[vid]!.add('combo');
        }
      } else {
        // Product-level combo item → applies to all variants
        for (final v in variantRows) {
          activeTypes[v.id.toString()]!.add('combo');
        }
      }
    }

    // ── Populate existing Free Delivery (with inheritance) ──
    for (final v in variantRows) {
      if (EffectiveOfferResolver.effectiveFreeDelivery(
        quantityValue: v.quantityValue,
        quantityUnit: v.quantityUnit,
        freeDeliverySources: fdSourcesBefore,
      )) {
        activeTypes[v.id.toString()]!.add('free_delivery');
      }
    }

    // ── Apply proposed changes ──

    // Proposed BOGO
    if (proposedBogoVariantId != null && proposedBogoVariantId.isNotEmpty) {
      if (activeTypes.containsKey(proposedBogoVariantId)) {
        activeTypes[proposedBogoVariantId]!.add('bogo');
      }
    } else if (proposedBogoIsProductLevel && defaultVariant != null) {
      activeTypes[defaultVariant.id.toString()]!.add('bogo');
    }

    // Proposed combo
    if (proposedComboVariantId != null && proposedComboVariantId.isNotEmpty) {
      if (activeTypes.containsKey(proposedComboVariantId)) {
        activeTypes[proposedComboVariantId]!.add('combo');
      }
    } else {
      // Proposed product-level combo item → check all variants with existing offers
      // (only check conflict — don't mark all since a single combo item targets one product)
    }

    // Proposed Free Delivery
    if (proposedFreeDelivery && defaultVariant != null) {
      final fdSourcesAfter = <ProductVariantRow>[
        for (final v in variantRows)
          if (v.isFreeDelivery) v,
        defaultVariant,
      ];
      for (final v in variantRows) {
        if (EffectiveOfferResolver.effectiveFreeDelivery(
          quantityValue: v.quantityValue,
          quantityUnit: v.quantityUnit,
          freeDeliverySources: fdSourcesAfter,
        )) {
          activeTypes[v.id.toString()]!.add('free_delivery');
        }
      }
    }

    // Proposed Shop More, Get More
    if (proposedShopMoreGetMore && defaultVariant != null) {
      if (proposedShopMoreGetMoreVariantId != null &&
          proposedShopMoreGetMoreVariantId.isNotEmpty) {
        if (activeTypes.containsKey(proposedShopMoreGetMoreVariantId)) {
          activeTypes[proposedShopMoreGetMoreVariantId]!
              .add('shop_more_get_more');
        }
      } else {
        activeTypes[defaultVariant.id.toString()]!.add('shop_more_get_more');
      }
    }

    // ── Check for conflicts ──
    for (final v in variantRows) {
      final types = activeTypes[v.id.toString()]!;
      if (types.length > 1) {
        final label = v.label;
        final typeNames = types.join(', ');
        return 'Variant "$label" already participates in $typeNames. '
            'A product variant can have only one active variant-based offer at a time.';
      }
    }

    return null;
  }
}
