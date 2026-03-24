import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart' as protocol;
import '../services/firebase_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class BogoEndpoint extends Endpoint {
  static const String bogoCollection = 'bogo_offers';
  static const String projectId = 'freshpickkart-a6824';

  // ── Admin: Save (create or update) a BOGO offer ────────────────────────────
  Future<bool> upsertOffer(Session session, protocol.BogoOffer offer) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';

    // Use triggerProductId as the document ID so it's easy to look up
    final docPath = '$database/$bogoCollection/${offer.triggerProductId}';
    offer.offerId = offer.triggerProductId;
    offer.createdAt = offer.createdAt;

    final fields = _bogoOfferToFirestore(offer);
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: fields.keys.toList(),
    );
    return true;
  }

  // ── Admin: Delete BOGO offer for a product ─────────────────────────────────
  Future<bool> deleteOffer(Session session, String triggerProductId) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';
    final docPath = '$database/$bogoCollection/$triggerProductId';
    try {
      await firestore.projects.databases.documents.delete(docPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── User App: Get all active BOGO offers ───────────────────────────────────
  Future<List<protocol.BogoOffer>> getActiveOffers(Session session) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: bogoCollection)],
      where: firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'isActive'),
          op: 'EQUAL',
          value: firestore_api.Value(booleanValue: true),
        ),
      ),
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    final offers = <protocol.BogoOffer>[];
    for (final res in response) {
      if (res.document?.fields != null) {
        offers.add(
          _bogoOfferFromFirestore(
            res.document!.fields!,
            res.document!.name!.split('/').last,
          ),
        );
      }
    }
    return offers;
  }

  // ── Get BOGO offer for a specific trigger product ──────────────────────────
  Future<protocol.BogoOffer?> getOfferForProduct(
    Session session,
    String triggerProductId,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$projectId/databases/(default)/documents';
    final docPath = '$database/$bogoCollection/$triggerProductId';

    try {
      final doc = await firestore.projects.databases.documents.get(docPath);
      if (doc.fields == null) return null;
      return _bogoOfferFromFirestore(doc.fields!, triggerProductId);
    } catch (_) {
      return null;
    }
  }

  // ── Serialization helpers ──────────────────────────────────────────────────

  protocol.BogoOffer _bogoOfferFromFirestore(
    Map<String, firestore_api.Value> fields,
    String docId,
  ) {
    final freeProductIdsList =
        fields['freeProductIds']?.arrayValue?.values
            ?.map((v) => v.stringValue ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        [];

    return protocol.BogoOffer(
      offerId: docId,
      triggerProductId: fields['triggerProductId']?.stringValue ?? docId,
      freeProductIds: freeProductIdsList,
      offerTitle: fields['offerTitle']?.stringValue ?? 'Buy 1 Get 1',
      isActive: fields['isActive']?.booleanValue ?? false,
      createdAt:
          DateTime.tryParse(fields['createdAt']?.timestampValue ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, firestore_api.Value> _bogoOfferToFirestore(
    protocol.BogoOffer offer,
  ) {
    return {
      'offerId': firestore_api.Value(stringValue: offer.triggerProductId),
      'triggerProductId': firestore_api.Value(
        stringValue: offer.triggerProductId,
      ),
      'freeProductIds': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: offer.freeProductIds
              .map((id) => firestore_api.Value(stringValue: id))
              .toList(),
        ),
      ),
      'offerTitle': firestore_api.Value(stringValue: offer.offerTitle),
      'isActive': firestore_api.Value(booleanValue: offer.isActive),
      'createdAt': firestore_api.Value(
        timestampValue: offer.createdAt.toUtc().toIso8601String(),
      ),
    };
  }
}
