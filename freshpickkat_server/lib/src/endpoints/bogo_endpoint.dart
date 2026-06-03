import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/notification_outbox_service.dart';
import '../services/offer_conflict_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_offer_service.dart';

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
      } else if (conflict.productIds.isNotEmpty &&
          forceDisableFreeDelivery &&
          !_conflicts.isCategoryFreeDeliveryConflict(conflict)) {
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

    final result = await _offers.upsertBogoOffer(session, offer);
    if (result) {
      await NotificationOutboxService.instance.enqueueCampaign(
        session: session,
        draft: notificationDraft,
        fallbackEntityType: 'bogo',
        fallbackEntityId: offer.offerId ?? offer.triggerProductId,
        extraData: {'offerType': 'bogo'},
      );
      await _audit.write(
        session,
        actorUserId: actor.id,
        action: 'upsert_with_conflicts',
        entityType: 'bogo_offer',
        entityId: offer.offerId ?? offer.triggerProductId,
      );
    }
    return protocol.OfferMutationResult(
      success: result,
      message: result ? 'BOGO offer saved.' : 'Failed to save BOGO offer.',
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
    final result = await _offers.upsertBogoOffer(session, offer);
    if (result) {
      await NotificationOutboxService.instance.enqueueCampaign(
        session: session,
        draft: notificationDraft,
        fallbackEntityType: 'bogo',
        fallbackEntityId: offer.offerId ?? offer.triggerProductId,
        extraData: {'offerType': 'bogo'},
      );
    }
    return result;
  }

  Future<bool> deleteOffer(
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
    return _offers.deleteBogoOffer(session, triggerProductId);
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
