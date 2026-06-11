import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/business/validation_service.dart';
import '../services/notification_outbox_service.dart';
import '../services/offer_conflict_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_offer_service.dart';

class ComboOfferEndpoint extends Endpoint {
  final PostgresOfferService _offers = PostgresOfferService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();
  final OfferConflictService _conflicts = OfferConflictService();

  Future<OfferMutationResult> upsertComboOfferWithConflicts(
    Session session,
    ComboOffer offer,
    String firebaseUid,
    String idToken, {
    NotificationDraft? notificationDraft,
    bool force = false,
  }) async {
    try {
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      ValidationService.validateComboOffer(offer);

      var conflict = await _conflicts.checkComboConflicts(session, offer);
      if (force) {
        for (var attempt = 0; attempt < 3 && conflict.hasConflict; attempt++) {
          if (conflict.bogoOffer != null) {
            await _conflicts.disableBogo(
              session,
              conflict.bogoOffer!.triggerProductId,
            );
          } else if (conflict.productIds.isNotEmpty) {
            for (final pid in conflict.productIds) {
              await _conflicts.disableFreeDeliveryForProduct(session, pid);
            }
          } else {
            break;
          }
          conflict = await _conflicts.checkComboConflicts(session, offer);
        }
      }
      if (conflict.hasConflict) {
        return OfferMutationResult(
          success: false,
          message: conflict.message,
          conflict: conflict,
        );
      }

      final result = await _offers.upsertComboOffer(session, offer);
      if (result) {
        await NotificationOutboxService.instance.enqueueCampaign(
          session: session,
          draft: notificationDraft,
          fallbackEntityType: 'combo',
          fallbackEntityId: offer.comboId ?? offer.name,
          extraData: {'offerType': 'combo'},
        );
        await _audit.write(
          session,
          actorFirebaseUid: firebaseUid,
          action: 'upsert',
          entityType: 'combo_offer',
          entityId: offer.comboId,
        );
      }
      return OfferMutationResult(
        success: result,
        message: result ? 'Combo offer saved.' : 'Failed to save combo offer.',
      );
    } catch (error) {
      session.log('Error upserting combo offer: ', level: LogLevel.error);
      return OfferMutationResult(
        success: false,
        message: 'Failed to save combo offer.',
      );
    }
  }

  Future<bool> upsertComboOffer(
    Session session,
    ComboOffer offer,
    String firebaseUid,
    String idToken, {
    NotificationDraft? notificationDraft,
  }) async {
    try {
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      ValidationService.validateComboOffer(offer);
      final result = await _offers.upsertComboOffer(session, offer);
      if (result) {
        await NotificationOutboxService.instance.enqueueCampaign(
          session: session,
          draft: notificationDraft,
          fallbackEntityType: 'combo',
          fallbackEntityId: offer.comboId ?? offer.name,
          extraData: {'offerType': 'combo'},
        );
        await _audit.write(
          session,
          actorFirebaseUid: firebaseUid,
          action: 'upsert',
          entityType: 'combo_offer',
          entityId: offer.comboId,
        );
      }
      return result;
    } catch (error) {
      session.log('Error upserting combo offer: $error', level: LogLevel.error);
      return false;
    }
  }

  Future<String> deleteComboOffer(
    Session session,
    String comboId,
    String firebaseUid,
    String idToken,
  ) async {
    try {
      await _adminGuard.ensureAdminSeller(
        session,
        firebaseUid: firebaseUid,
        idToken: idToken,
      );
      final result = await _offers.deleteComboOffer(session, comboId);
      if (result.isEmpty) {
        await _audit.write(
          session,
          actorFirebaseUid: firebaseUid,
          action: 'delete',
          entityType: 'combo_offer',
          entityId: comboId,
        );
      }
      return result;
    } catch (error) {
      session.log('Error deleting combo offer: $error', level: LogLevel.error);
      return 'An error occurred while removing the offer.';
    }
  }

  Future<List<ComboOffer>> getActiveComboOffers(Session session) {
    return _offers.getActiveComboOffers(session);
  }

  Future<List<ComboOffer>> getActiveComboOffersForProducts(
    Session session,
    List<String> productIds,
  ) async {
    return _offers.getActiveComboOffersForProducts(session, productIds);
  }

  Future<List<ComboOffer>> getInactiveComboOffers(Session session) async {
    return _offers.getInactiveComboOffers(session);
  }

  Future<List<ComboOffer>> getAllComboOffers(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _offers.getAllComboOffers(session);
  }

  Future<ComboOfferPage> getComboOffersPage(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 20,
    String? pageToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _offers.getComboOffersPage(
      session,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<bool> setComboOfferActive(
    Session session,
    String comboId,
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
      return _offers.setComboOfferActive(session, comboId, isActive);
    } catch (error) {
      session.log(
        'Error updating combo active state: $error',
        level: LogLevel.error,
      );
      return false;
    }
  }

  Future<List<ComboOffer>> checkApplicableCombos(
    Session session,
    List<CartItemInput> cartItems,
  ) {
    return _offers.checkApplicableCombos(session, cartItems);
  }
}
