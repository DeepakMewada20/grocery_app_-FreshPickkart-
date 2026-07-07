import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/business/validation_service.dart';
import '../services/delivery/delivery_charge_calculator.dart';
import '../services/delivery/delivery_engine.dart';
import '../services/background/notification_outbox_service.dart';
import '../services/offers/offer_conflict_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_support.dart';
import '../services/offers/variant_offer_exclusivity_service.dart';

class FreeDeliveryEndpoint extends Endpoint {
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();
  final OfferConflictService _conflicts = OfferConflictService();

  Future<DeliveryConfig> getDeliveryConfig(Session session) async {
    return DeliveryEngine.getDeliveryConfig(session);
  }

  Future<DeliveryPricingResult> getUserDeliveryOffer(
    Session session,
    String userId,
  ) async {
    return DeliveryEngine.getUserDeliveryOffer(session, userId);
  }

  Future<OfferMutationResult> setProductFreeDelivery(
    Session session,
    String productId,
    bool isFreeDelivery,
    String firebaseUid,
    String idToken, {
    bool confirmDisableConflictingCombo = false,
    bool forceDisableBogo = false,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final parsedId = parseUuid(productId, fieldName: 'productId');
    final product = await ProductRow.db.findById(session, parsedId);
    if (product == null) {
      return OfferMutationResult(success: false, message: 'Product not found.');
    }

    if (isFreeDelivery) {
      var conflict = await _conflicts.checkFreeDeliveryProductConflicts(
        session,
        [productId],
      );
      for (var attempt = 0; attempt < 3 && conflict.hasConflict; attempt++) {
        if (conflict.comboOffer?.comboId != null &&
            confirmDisableConflictingCombo) {
          await _conflicts.disableCombo(session, conflict.comboOffer!.comboId!);
        } else if (conflict.bogoOffer != null && forceDisableBogo) {
          await _conflicts.disableBogo(
            session,
            conflict.bogoOffer!.triggerProductId,
          );
        } else {
          break;
        }
        conflict = await _conflicts.checkFreeDeliveryProductConflicts(
          session,
          [productId],
        );
      }
      if (conflict.hasConflict) {
        return OfferMutationResult(
          success: false,
          message: conflict.message,
          conflict: conflict,
        );
      }

      final exclusivityErr =
          await VariantOfferExclusivityService.validateFreeDeliveryEnable(
            session,
            productId,
          );
      if (exclusivityErr != null) {
        return OfferMutationResult(
          success: false,
          message: exclusivityErr,
        );
      }
    }

    await ProductRow.db.updateRow(
      session,
      product.copyWith(
        isFreeDelivery: isFreeDelivery,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _audit.write(
      session,
      actorUserId: actor.id,
      action: isFreeDelivery ? 'enable' : 'disable',
      entityType: 'product_free_delivery',
      entityId: productId,
    );
    return OfferMutationResult(
      success: true,
      message: 'Product Free Delivery updated.',
    );
  }

  Future<bool> upsertDeliveryConfig(
    Session session,
    DeliveryConfig config,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    ValidationService.validateDeliveryConfig(config);

    final result = await DeliveryEngine.saveDeliveryConfig(session, config);
    if (result) {
      await _audit.write(
        session,
        actorFirebaseUid: firebaseUid,
        action: 'upsert',
        entityType: 'delivery_config',
        entityId: config.configId ?? 'default',
      );
    }
    return result;
  }

  Future<List<DeliveryRule>> getInactiveDeliveryRules(Session session) async {
    return DeliveryEngine.getInactiveDeliveryRules(session);
  }

  Future<List<DeliveryRule>> getAllDeliveryRules(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return DeliveryEngine.getAllDeliveryRules(session);
  }

  Future<DeliveryRulePage> getDeliveryRulesPage(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 20,
    String? pageToken,
  }) async {
    final rules = await getAllDeliveryRules(session, firebaseUid, idToken);
    rules.sort((a, b) {
      final sortCompare = a.sortOrder.compareTo(b.sortOrder);
      if (sortCompare != 0) return sortCompare;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    final offset = int.tryParse(pageToken ?? '') ?? 0;
    final safeOffset = offset.clamp(0, rules.length);
    final end = (safeOffset + limit).clamp(0, rules.length);
    final pageItems = rules.sublist(safeOffset, end);
    final nextOffset = end < rules.length ? '$end' : null;

    return DeliveryRulePage(
      rules: pageItems,
      nextPageToken: nextOffset,
      totalCount: rules.length,
    );
  }

  Future<FreeDeliveryHydrated> getFreeDeliveryHydrated(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    final results = await Future.wait([
      DeliveryEngine.getDeliveryConfig(session),
      getAllDeliveryRules(session, firebaseUid, idToken),
    ]);
    final config = results[0] as DeliveryConfig;
    final rules = results[1] as List<DeliveryRule>;
    return FreeDeliveryHydrated(
      deliveryConfig: config,
      deliveryRules: rules,
      totalCount: rules.length,
    );
  }

  Future<bool> upsertDeliveryRule(
    Session session,
    DeliveryRule rule,
    String firebaseUid,
    String idToken, {
    NotificationDraft? notificationDraft,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    ValidationService.validateDeliveryRule(rule);

    final result = await DeliveryEngine.upsertDeliveryRule(session, rule);
    if (result) {
      await NotificationOutboxService.instance.enqueueCampaign(
        session: session,
        draft: notificationDraft,
        fallbackEntityType: 'delivery',
        fallbackEntityId: rule.ruleId ?? rule.name,
        extraData: {'deliveryRule': rule.name},
      );
      await _audit.write(
        session,
        actorFirebaseUid: firebaseUid,
        action: 'upsert',
        entityType: 'delivery_rule',
        entityId: rule.ruleId ?? rule.name,
      );
    }
    return result;
  }

  Future<String> deleteDeliveryRule(
    Session session,
    String ruleId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final result = await DeliveryEngine.deleteDeliveryRule(session, ruleId);
    if (result.isEmpty) {
      await _audit.write(
        session,
        actorFirebaseUid: firebaseUid,
        action: 'delete',
        entityType: 'delivery_rule',
        entityId: ruleId,
      );
    }
    return result;
  }

  Future<bool> setDeliveryRuleActive(
    Session session,
    String ruleId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return DeliveryEngine.setDeliveryRuleActive(session, ruleId, isActive);
  }

  Future<bool> moveDeliveryRuleUp(
    Session session,
    String ruleId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return DeliveryEngine.moveDeliveryRuleUp(session, ruleId);
  }

  Future<bool> moveDeliveryRuleDown(
    Session session,
    String ruleId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return DeliveryEngine.moveDeliveryRuleDown(session, ruleId);
  }

  Future<DeliveryPricingResult> calculateDeliveryPricing(
    Session session,
    double cartTotal, {
    String? userId,
    String? location,
    List<CartItemInput>? cartItems,
  }) async {
    return DeliveryChargeCalculator.calculate(
      session: session,
      cartTotal: cartTotal,
      userId: userId,
      location: location,
      cartItems: cartItems,
    );
  }
}
