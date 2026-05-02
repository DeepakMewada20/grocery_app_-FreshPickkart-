import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart' as protocol;
import '../services/postgres/postgres_offer_service.dart';

class BogoEndpoint extends Endpoint {
  final PostgresOfferService _offers = PostgresOfferService();

  Future<bool> upsertOffer(Session session, protocol.BogoOffer offer) {
    return _offers.upsertBogoOffer(session, offer);
  }

  Future<bool> deleteOffer(Session session, String triggerProductId) {
    return _offers.deleteBogoOffer(session, triggerProductId);
  }

  Future<List<protocol.BogoOffer>> getAllOffers(Session session) {
    return _offers.getAllBogoOffers(session);
  }

  Future<protocol.BogoOfferPage> getOffersPage(
    Session session, {
    int limit = 20,
    String? pageToken,
  }) {
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
  ) {
    return _offers.getBogoOfferForProduct(session, triggerProductId);
  }
}
