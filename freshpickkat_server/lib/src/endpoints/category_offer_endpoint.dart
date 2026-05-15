import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/business/validation_service.dart';
import '../services/notification_outbox_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_offer_service.dart';

class CategoryOfferEndpoint extends Endpoint {
  final PostgresOfferService _offers = PostgresOfferService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();

  Future<bool> upsertCategoryOffer(
    Session session,
    CategoryOffer offer,
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
      ValidationService.validateCategoryOffer(offer);
      final result = await _offers.upsertCategoryOffer(session, offer);
      if (result) {
        await NotificationOutboxService.instance.enqueueCampaign(
          session: session,
          draft: notificationDraft,
          fallbackEntityType: 'offer',
          fallbackEntityId: offer.offerId ?? offer.categoryId,
          extraData: {'offerType': 'category_offer'},
        );
        await _audit.write(
          session,
          actorFirebaseUid: firebaseUid,
          action: 'upsert',
          entityType: 'category_offer',
          entityId: offer.offerId,
        );
      }
      return result;
    } catch (error) {
      session.log(
        'Error upserting category offer: $error',
        level: LogLevel.error,
      );
      return false;
    }
  }

  Future<bool> deleteCategoryOffer(
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
      final result = await _offers.deleteCategoryOffer(session, offerId);
      if (result) {
        await _audit.write(
          session,
          actorFirebaseUid: firebaseUid,
          action: 'delete',
          entityType: 'category_offer',
          entityId: offerId,
        );
      }
      return result;
    } catch (error) {
      session.log(
        'Error deleting category offer: $error',
        level: LogLevel.error,
      );
      return false;
    }
  }

  Future<List<CategoryOffer>> getActiveCategoryOffers(Session session) {
    return _offers.getActiveCategoryOffers(session);
  }

  Future<List<CategoryOffer>> getAllCategoryOffers(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _offers.getAllCategoryOffers(session);
  }

  Future<CategoryOfferPage> getCategoryOffersPage(
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
    return _offers.getCategoryOffersPage(
      session,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<bool> setCategoryOfferActive(
    Session session,
    String offerId,
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
      return _offers.setCategoryOfferActive(session, offerId, isActive);
    } catch (error) {
      session.log(
        'Error updating category offer active state: $error',
        level: LogLevel.error,
      );
      return false;
    }
  }
}
