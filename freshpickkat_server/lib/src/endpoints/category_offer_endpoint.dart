import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import '../services/business/audit_log_service.dart';
import '../services/business/validation_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class CategoryOfferEndpoint extends Endpoint {
  static const String _collection = 'category_offers';
  static const String _projectId = 'freshpickkart-a6824';

  Future<bool> upsertCategoryOffer(
    Session session,
    CategoryOffer offer,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);
    ValidationService.validateCategoryOffer(offer);

    if (offer.offerId == null || offer.offerId!.isEmpty) {
      offer.offerId =
          '${offer.categoryId}_${DateTime.now().millisecondsSinceEpoch}';
    }

    final database = 'projects/$_projectId/databases/(default)/documents';
    final docPath = '$database/$_collection/${offer.offerId}';

    final fields = _categoryOfferToFirestore(offer);
    final doc = firestore_api.Document(fields: fields);
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: fields.keys.toList(),
    );

    await AuditLogService.write(
      firestore: firestore,
      actorUid: firebaseUid,
      action: 'upsert',
      entityType: 'category_offer',
      entityId: offer.offerId!,
    );

    return true;
  }

  Future<bool> deleteCategoryOffer(
    Session session,
    String offerId,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);

    final database = 'projects/$_projectId/databases/(default)/documents';
    final docPath = '$database/$_collection/$offerId';

    try {
      await firestore.projects.databases.documents.delete(docPath);
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'delete',
        entityType: 'category_offer',
        entityId: offerId,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<CategoryOffer>> getActiveCategoryOffers(Session session) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final database = 'projects/$_projectId/databases/(default)/documents';

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: _collection)],
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

    final offers = <CategoryOffer>[];
    final now = DateTime.now();

    for (final res in response) {
      if (res.document?.fields == null) continue;
      final offer = _categoryOfferFromFirestore(
        res.document!.fields!,
        res.document!.name!.split('/').last,
      );
      if (offer.startDate.isAfter(now) || offer.endDate.isBefore(now)) continue;
      offers.add(offer);
    }

    offers.sort((a, b) => b.priority.compareTo(a.priority));
    return offers;
  }

  Future<List<CategoryOffer>> getAllCategoryOffers(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);

    final database = 'projects/$_projectId/databases/(default)/documents';
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: _collection)],
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    final offers = <CategoryOffer>[];
    for (final res in response) {
      if (res.document?.fields != null) {
        offers.add(
          _categoryOfferFromFirestore(
            res.document!.fields!,
            res.document!.name!.split('/').last,
          ),
        );
      }
    }
    return offers;
  }

  Future<CategoryOfferPage> getCategoryOffersPage(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 20,
    String? pageToken,
  }) async {
    final offers = await getAllCategoryOffers(session, firebaseUid, idToken);
    offers.sort((a, b) {
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    final offset = int.tryParse(pageToken ?? '') ?? 0;
    final safeOffset = offset.clamp(0, offers.length);
    final end = (safeOffset + limit).clamp(0, offers.length);
    final pageItems = offers.sublist(safeOffset, end);
    final nextOffset = end < offers.length ? '$end' : null;

    return CategoryOfferPage(
      offers: pageItems,
      nextPageToken: nextOffset,
      totalCount: offers.length,
    );
  }

  Future<bool> setCategoryOfferActive(
    Session session,
    String offerId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);

    final database = 'projects/$_projectId/databases/(default)/documents';
    final docPath = '$database/$_collection/$offerId';

    try {
      final doc = firestore_api.Document(
        fields: {'isActive': firestore_api.Value(booleanValue: isActive)},
      );
      await firestore.projects.databases.documents.patch(
        doc,
        docPath,
        updateMask_fieldPaths: ['isActive'],
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  CategoryOffer _categoryOfferFromFirestore(
    Map<String, firestore_api.Value> fields,
    String docId,
  ) {
    return CategoryOffer(
      offerId: fields['offerId']?.stringValue ?? docId,
      name: fields['name']?.stringValue ?? '',
      description: fields['description']?.stringValue,
      categoryId: fields['categoryId']?.stringValue ?? '',
      categoryName: fields['categoryName']?.stringValue,
      discountType: fields['discountType']?.stringValue ?? 'flat',
      discountValue:
          double.tryParse(
            fields['discountValue']?.doubleValue?.toString() ??
                fields['discountValue']?.integerValue?.toString() ??
                '0',
          ) ??
          0,
      maxDiscount:
          fields['maxDiscount']?.doubleValue != null ||
              fields['maxDiscount']?.integerValue != null
          ? double.tryParse(
              fields['maxDiscount']?.doubleValue?.toString() ??
                  fields['maxDiscount']?.integerValue?.toString() ??
                  '',
            )
          : null,
      minOrderAmount:
          fields['minOrderAmount']?.doubleValue != null ||
              fields['minOrderAmount']?.integerValue != null
          ? double.tryParse(
              fields['minOrderAmount']?.doubleValue?.toString() ??
                  fields['minOrderAmount']?.integerValue?.toString() ??
                  '0',
            )
          : null,
      productIds: fields['productIds']?.arrayValue?.values
          ?.map((v) => v.stringValue ?? '')
          .where((s) => s.isNotEmpty)
          .toList(),
      excludeProductIds: fields['excludeProductIds']?.arrayValue?.values
          ?.map((v) => v.stringValue ?? '')
          .where((s) => s.isNotEmpty)
          .toList(),
      startDate:
          DateTime.tryParse(fields['startDate']?.timestampValue ?? '') ??
          DateTime.now(),
      endDate:
          DateTime.tryParse(fields['endDate']?.timestampValue ?? '') ??
          DateTime.now().add(const Duration(days: 30)),
      isActive: fields['isActive']?.booleanValue ?? true,
      priority:
          int.tryParse(fields['priority']?.integerValue?.toString() ?? '0') ??
          0,
      createdAt:
          DateTime.tryParse(fields['createdAt']?.timestampValue ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, firestore_api.Value> _categoryOfferToFirestore(
    CategoryOffer offer,
  ) {
    return {
      'offerId': firestore_api.Value(stringValue: offer.offerId ?? ''),
      'name': firestore_api.Value(stringValue: offer.name),
      'description': offer.description != null
          ? firestore_api.Value(stringValue: offer.description!)
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
      'categoryId': firestore_api.Value(stringValue: offer.categoryId),
      'categoryName': offer.categoryName != null
          ? firestore_api.Value(stringValue: offer.categoryName!)
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
      'discountType': firestore_api.Value(stringValue: offer.discountType),
      'discountValue': firestore_api.Value(doubleValue: offer.discountValue),
      if (offer.maxDiscount != null)
        'maxDiscount': firestore_api.Value(doubleValue: offer.maxDiscount!),
      if (offer.minOrderAmount != null)
        'minOrderAmount': firestore_api.Value(
          doubleValue: offer.minOrderAmount!,
        ),
      if (offer.productIds != null)
        'productIds': firestore_api.Value(
          arrayValue: firestore_api.ArrayValue(
            values: offer.productIds!
                .map((id) => firestore_api.Value(stringValue: id))
                .toList(),
          ),
        ),
      if (offer.excludeProductIds != null)
        'excludeProductIds': firestore_api.Value(
          arrayValue: firestore_api.ArrayValue(
            values: offer.excludeProductIds!
                .map((id) => firestore_api.Value(stringValue: id))
                .toList(),
          ),
        ),
      'startDate': firestore_api.Value(
        timestampValue: offer.startDate.toUtc().toIso8601String(),
      ),
      'endDate': firestore_api.Value(
        timestampValue: offer.endDate.toUtc().toIso8601String(),
      ),
      'isActive': firestore_api.Value(booleanValue: offer.isActive),
      'priority': firestore_api.Value(integerValue: offer.priority.toString()),
      'createdAt': firestore_api.Value(
        timestampValue: offer.createdAt.toUtc().toIso8601String(),
      ),
    };
  }

  Future<void> _ensureAdmin(
    dynamic firestore,
    String firebaseUid,
    String idToken,
  ) async {}
}
