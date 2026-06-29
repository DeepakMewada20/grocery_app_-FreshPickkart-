import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/admin/delete_impact_service.dart';
import '../services/background/notification_outbox_service.dart';
import '../services/offers/offer_conflict_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_offer_service.dart';
import '../services/postgres/postgres_support.dart';
import '../services/offers/variant_offer_exclusivity_service.dart';

class ShopMoreGetMoreEndpoint extends Endpoint {
  final PostgresOfferService _offers = PostgresOfferService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();
  final OfferConflictService _conflicts = OfferConflictService();

  Future<protocol.OfferMutationResult> upsertOfferWithConflicts(
    Session session,
    protocol.ShopMoreGetMoreOffer offer,
    String firebaseUid,
    String idToken, {
    protocol.NotificationDraft? notificationDraft,
    bool confirmDisableConflictingCombo = false,
    bool forceDisableFreeDelivery = false,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    // Phase B: Input validation (threshold, quantity, product, duplicates)
    final inputErr =
        await VariantOfferExclusivityService.validateShopMoreGetMoreInput(
          session,
          offer,
          existingOfferId: offer.offerId,
        );
    if (inputErr != null) {
      return protocol.OfferMutationResult(success: false, message: inputErr);
    }

    var conflict = await _conflicts.checkShopMoreGetMoreConflicts(session, offer);
    for (var attempt = 0; attempt < 3 && conflict.hasConflict; attempt++) {
      if (conflict.comboOffer != null && confirmDisableConflictingCombo) {
        await _conflicts.disableCombo(session, conflict.comboOffer!.comboId!);
      } else if (conflict.productIds.isNotEmpty && forceDisableFreeDelivery) {
        for (final pid in conflict.productIds) {
          await _conflicts.disableFreeDeliveryForProduct(session, pid);
        }
      } else {
        break;
      }
      conflict = await _conflicts.checkShopMoreGetMoreConflicts(session, offer);
    }
    if (conflict.hasConflict) {
      return protocol.OfferMutationResult(
        success: false,
        message: conflict.message,
        conflict: conflict,
      );
    }

    final exclusivityErr =
        await VariantOfferExclusivityService.validateShopMoreGetMoreSave(
          session,
          offer,
          existingOfferId: offer.offerId,
        );
    if (exclusivityErr != null) {
      return protocol.OfferMutationResult(
        success: false,
        message: exclusivityErr,
      );
    }

    final offerId = await _offers.upsertShopMoreGetMoreOffer(
      session,
      offer,
      updatedBy: actor.id.toString(),
    );
    if (offerId != null) {
      await NotificationOutboxService.instance.enqueueCampaign(
        session: session,
        draft: notificationDraft,
        fallbackEntityType: 'shop_more_get_more',
        fallbackEntityId: offerId,
        extraData: {'offerType': 'shop_more_get_more'},
      );
      await _audit.write(
        session,
        actorUserId: actor.id,
        action: 'upsert_with_conflicts',
        entityType: 'shop_more_get_more_offer',
        entityId: offerId,
      );
    }
    return protocol.OfferMutationResult(
      success: offerId != null,
      message: offerId != null ? 'Shop More, Get More offer saved.' : 'Failed to save offer.',
      offerId: offerId,
    );
  }

  Future<bool> upsertOffer(
    Session session,
    protocol.ShopMoreGetMoreOffer offer,
    String firebaseUid,
    String idToken, {
    protocol.NotificationDraft? notificationDraft,
  }) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    // Phase B: Input validation (threshold, quantity, product, duplicates)
    final inputErr =
        await VariantOfferExclusivityService.validateShopMoreGetMoreInput(
          session,
          offer,
          existingOfferId: offer.offerId,
        );
    if (inputErr != null) {
      throw Exception(inputErr);
    }

    final exclusivityErr =
        await VariantOfferExclusivityService.validateShopMoreGetMoreSave(
          session,
          offer,
          existingOfferId: offer.offerId,
        );
    if (exclusivityErr != null) {
      throw Exception(exclusivityErr);
    }

    final offerId = await _offers.upsertShopMoreGetMoreOffer(
      session,
      offer,
      updatedBy: actor.id.toString(),
    );
    if (offerId != null) {
      await NotificationOutboxService.instance.enqueueCampaign(
        session: session,
        draft: notificationDraft,
        fallbackEntityType: 'shop_more_get_more',
        fallbackEntityId: offerId,
        extraData: {'offerType': 'shop_more_get_more'},
      );
    }
    return offerId != null;
  }

  Future<String> deleteOffer(
    Session session,
    String offerId,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      return await _offers.deleteShopMoreGetMoreOffer(session, offerId);
    } catch (error) {
      session.log(
        'Error deleting Shop More, Get More offer: $error',
        level: LogLevel.error,
      );
      return 'An error occurred while removing the offer.';
    }
  }

  Future<protocol.DeleteImpactResponse> checkDeleteImpact(
    Session session,
    String offerId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final parsedId = tryParseUuid(offerId);
    if (parsedId == null) {
      return protocol.DeleteImpactResponse(canHardDelete: true, references: []);
    }

    final rows = await protocol.ShopMoreGetMoreOfferRow.db.find(
      session,
      where: (t) => t.id.equals(parsedId),
    );
    if (rows.isEmpty || rows.first.id == null) {
      return protocol.DeleteImpactResponse(canHardDelete: true, references: []);
    }

    return DeleteImpactService.checkShopMoreGetMoreImpact(
      session,
      rows.first.id!,
    );
  }

  Future<protocol.HardDeleteResponse> hardDeleteOffer(
    Session session,
    String offerId,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final result = await _offers.hardDeleteShopMoreGetMoreOffer(
      session,
      offerId,
    );
    if (result.success) {
      await _audit.write(
        session,
        actorUserId: actor.id,
        action: 'hard_delete',
        entityType: 'shop_more_get_more_offer',
        metadata: {'offerId': offerId},
      );
    }
    return result;
  }

  Future<bool> setOfferActive(
    Session session,
    String offerId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      final actor = await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      return _offers.setShopMoreGetMoreOfferActive(
        session,
        offerId,
        isActive,
        actorId: actor.id.toString(),
      );
    } catch (error) {
      session.log(
        'Error updating Shop More, Get More active state: $error',
        level: LogLevel.error,
      );
      return false;
    }
  }

  Future<List<protocol.ShopMoreGetMoreOffer>> getInactiveOffers(
    Session session,
  ) async {
    return _offers.getInactiveShopMoreGetMoreOffers(session);
  }

  Future<List<protocol.ShopMoreGetMoreOffer>> getAllOffers(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _offers.getAllShopMoreGetMoreOffers(session);
  }

  Future<protocol.ShopMoreGetMoreOfferPage> getOffersPage(
    Session session, {
    required String firebaseUid,
    required String idToken,
    int limit = 20,
    String? pageToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _offers.getShopMoreGetMoreOffersPage(
      session,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<List<protocol.ShopMoreGetMoreOffer>> getActiveOffers(
    Session session,
  ) {
    return _offers.getActiveShopMoreGetMoreOffers(session);
  }

  Future<protocol.ShopMoreGetMoreOffer?> getApplicableOffer(
    Session session,
    double eligibleAmount,
  ) {
    return _offers.getApplicableShopMoreGetMoreOffer(
      session,
      eligibleAmount: eligibleAmount,
    );
  }
}
