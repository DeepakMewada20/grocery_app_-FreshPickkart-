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

class BogoEndpoint extends Endpoint {
  final PostgresOfferService _offers = PostgresOfferService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();
  final OfferConflictService _conflicts = OfferConflictService();

  Future<protocol.OfferMutationResult> upsertOfferWithConflicts(
    Session session,
    protocol.BogoOffer offer,
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

    var conflict = await _conflicts.checkBogoConflicts(session, offer);
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
      conflict = await _conflicts.checkBogoConflicts(session, offer);
    }
    if (conflict.hasConflict) {
      return protocol.OfferMutationResult(
        success: false,
        message: conflict.message,
        conflict: conflict,
      );
    }

    final exclusivityErr =
        await VariantOfferExclusivityService.validateBogoSave(
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

    final offerId = await _offers.upsertBogoOffer(session, offer);
    if (offerId != null) {
      await NotificationOutboxService.instance.enqueueCampaign(
        session: session,
        draft: notificationDraft,
        fallbackEntityType: 'bogo',
        fallbackEntityId: offerId,
        extraData: {'offerType': 'bogo'},
      );
      await _audit.write(
        session,
        actorUserId: actor.id,
        action: 'upsert_with_conflicts',
        entityType: 'bogo_offer',
        entityId: offerId,
      );
    }
    return protocol.OfferMutationResult(
      success: offerId != null,
      message: offerId != null ? 'BOGO offer saved.' : 'Failed to save BOGO offer.',
      offerId: offerId,
    );
  }

  Future<bool> upsertOffer(
    Session session,
    protocol.BogoOffer offer,
    String firebaseUid,
    String idToken, {
    protocol.NotificationDraft? notificationDraft,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final exclusivityErr =
        await VariantOfferExclusivityService.validateBogoSave(
          session,
          offer,
          existingOfferId: offer.offerId,
        );
    if (exclusivityErr != null) {
      throw Exception(exclusivityErr);
    }

    final offerId = await _offers.upsertBogoOffer(session, offer);
    if (offerId != null) {
      await NotificationOutboxService.instance.enqueueCampaign(
        session: session,
        draft: notificationDraft,
        fallbackEntityType: 'bogo',
        fallbackEntityId: offerId,
        extraData: {'offerType': 'bogo'},
      );
    }
    return offerId != null;
  }

  Future<String> deleteOffer(
    Session session,
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      return await _offers.deleteBogoOffer(session, triggerProductId);
    } catch (error) {
      session.log('Error deleting bogo offer: $error', level: LogLevel.error);
      return 'An error occurred while removing the offer.';
    }
  }

  Future<protocol.DeleteImpactResponse> checkBogoDeleteImpact(
    Session session,
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final parsedTriggerId = tryParseUuid(triggerProductId);
    if (parsedTriggerId == null) {
      return protocol.DeleteImpactResponse(canHardDelete: true, references: []);
    }

    final rows = await protocol.BogoOfferRow.db.find(
      session,
      where: (t) => t.triggerProductId.equals(parsedTriggerId),
    );
    if (rows.isEmpty || rows.first.id == null) {
      return protocol.DeleteImpactResponse(canHardDelete: true, references: []);
    }

    return DeleteImpactService.checkBogoImpact(session, rows.first.id!);
  }

  Future<protocol.HardDeleteResponse> hardDeleteBogoOffer(
    Session session,
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final result = await _offers.hardDeleteBogoOffer(
      session,
      triggerProductId,
    );
    if (result.success) {
      await _audit.write(
        session,
        actorUserId: actor.id,
        action: 'hard_delete',
        entityType: 'bogo_offer',
        metadata: {'triggerProductId': triggerProductId},
      );
    }
    return result;
  }

  Future<bool> setBogoOfferActive(
    Session session,
    String triggerProductId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      return _offers.setBogoOfferActive(session, triggerProductId, isActive);
    } catch (error) {
      session.log(
        'Error updating bogo active state: $error',
        level: LogLevel.error,
      );
      return false;
    }
  }

  Future<List<protocol.BogoOffer>> getInactiveBogoOffers(
    Session session,
  ) async {
    return _offers.getInactiveBogoOffers(session);
  }

  Future<List<protocol.BogoOffer>> getAllOffers(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _offers.getAllBogoOffers(session);
  }

  Future<protocol.BogoOfferPage> getOffersPage(
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
    return _offers.getBogoOffersPage(
      session,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<List<protocol.BogoOffer>> getActiveOffers(Session session) {
    return _offers.getActiveBogoOffers(session);
  }

  Future<protocol.BogoOffer?> getActiveOfferForProduct(
    Session session,
    String productId,
  ) async {
    return _offers.getBogoOfferForProduct(session, productId);
  }

  Future<List<protocol.BogoOffer>> getActiveBogoOffersForProducts(
    Session session,
    List<String> productIds,
  ) async {
    return _offers.getActiveBogoOffersForProducts(session, productIds);
  }

  Future<protocol.BogoOffer?> getOfferForProduct(
    Session session,
    String triggerProductId,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _offers.getBogoOfferForProduct(session, triggerProductId);
  }
}
