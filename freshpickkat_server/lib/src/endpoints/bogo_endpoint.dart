import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_offer_service.dart';

class BogoEndpoint extends Endpoint {
  final PostgresOfferService _offers = PostgresOfferService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();

  Future<bool> upsertOffer(
    Session session,
    protocol.BogoOffer offer,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _offers.upsertBogoOffer(session, offer);
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
