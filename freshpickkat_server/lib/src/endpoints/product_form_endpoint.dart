import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_offer_service.dart';

class ProductFormEndpoint extends Endpoint {
  final PostgresOfferService _offers = PostgresOfferService();

  Future<ProductFormReferenceData> getProductFormReferenceData(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    final results = await Future.wait([
      _offers.getAllBogoOffers(session),
      _offers.getAllComboOffers(session),
      _offers.getAllCategoryOffers(session),
    ]);

    return ProductFormReferenceData(
      bogoOffers: results[0] as List<BogoOffer>,
      comboOffers: results[1] as List<ComboOffer>,
      categoryOffers: results[2] as List<CategoryOffer>,
    );
  }
}
