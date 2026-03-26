import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import '../services/business/audit_log_service.dart';
import '../services/business/validation_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class ComboOfferEndpoint extends Endpoint {
  static const String _collection = 'combo_offers';
  static const String _projectId = 'freshpickkart-a6824';

  Future<bool> upsertComboOffer(
    Session session,
    ComboOffer offer,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);
    ValidationService.validateComboOffer(offer);

    if (offer.comboId == null || offer.comboId!.isEmpty) {
      offer.comboId = _generateComboId(offer);
    }

    final database = 'projects/$_projectId/databases/(default)/documents';
    final docPath = '$database/$_collection/${offer.comboId}';

    final fields = _comboOfferToFirestore(offer);
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
      entityType: 'combo_offer',
      entityId: offer.comboId!,
    );

    return true;
  }

  Future<bool> deleteComboOffer(
    Session session,
    String comboId,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);

    final database = 'projects/$_projectId/databases/(default)/documents';
    final docPath = '$database/$_collection/$comboId';

    try {
      await firestore.projects.databases.documents.delete(docPath);
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'delete',
        entityType: 'combo_offer',
        entityId: comboId,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<ComboOffer>> getActiveComboOffers(Session session) async {
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

    final offers = <ComboOffer>[];
    final now = DateTime.now();

    for (final res in response) {
      if (res.document?.fields == null) continue;
      final offer = _comboOfferFromFirestore(
        res.document!.fields!,
        res.document!.name!.split('/').last,
      );
      if (offer.startDate.isAfter(now) || offer.endDate.isBefore(now)) continue;
      offers.add(offer);
    }

    offers.sort((a, b) => b.priority.compareTo(a.priority));
    return offers;
  }

  Future<List<ComboOffer>> getAllComboOffers(
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

    final offers = <ComboOffer>[];
    for (final res in response) {
      if (res.document?.fields != null) {
        offers.add(
          _comboOfferFromFirestore(
            res.document!.fields!,
            res.document!.name!.split('/').last,
          ),
        );
      }
    }
    return offers;
  }

  Future<bool> setComboOfferActive(
    Session session,
    String comboId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);

    final database = 'projects/$_projectId/databases/(default)/documents';
    final docPath = '$database/$_collection/$comboId';

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

  Future<List<ComboOffer>> checkApplicableCombos(
    Session session,
    List<CartItemInput> cartItems,
  ) async {
    final allCombos = await getActiveComboOffers(session);
    final applicableCombos = <ComboOffer>[];

    for (final combo in allCombos) {
      if (_isComboApplicable(combo, cartItems)) {
        applicableCombos.add(combo);
      }
    }

    return applicableCombos;
  }

  bool _isComboApplicable(ComboOffer combo, List<CartItemInput> cartItems) {
    for (final comboProduct in combo.comboProducts) {
      final cartItem = cartItems.firstWhereOrNull(
        (item) =>
            item.productId == comboProduct.productId &&
            (comboProduct.variantId == null ||
                item.variantId == comboProduct.variantId) &&
            item.quantity >= comboProduct.quantity,
      );
      if (cartItem == null) return false;
    }
    return true;
  }

  ComboOffer _comboOfferFromFirestore(
    Map<String, firestore_api.Value> fields,
    String docId,
  ) {
    final comboProducts =
        fields['comboProducts']?.arrayValue?.values
            ?.map((v) => v.mapValue?.fields ?? const {})
            .map(
              (itemFields) => ComboProductItem(
                productId: itemFields['productId']?.stringValue ?? '',
                productName: itemFields['productName']?.stringValue,
                quantity:
                    int.tryParse(
                      itemFields['quantity']?.integerValue?.toString() ??
                          itemFields['quantity']?.stringValue ??
                          '1',
                    ) ??
                    1,
                variantId: itemFields['variantId']?.stringValue,
              ),
            )
            .where((cp) => cp.productId.isNotEmpty)
            .toList() ??
        [];

    return ComboOffer(
      comboId: fields['comboId']?.stringValue ?? docId,
      name: fields['name']?.stringValue ?? '',
      description: fields['description']?.stringValue,
      comboProducts: comboProducts,
      discountType: fields['discountType']?.stringValue ?? 'flat',
      discountValue:
          double.tryParse(
            fields['discountValue']?.doubleValue?.toString() ??
                fields['discountValue']?.integerValue?.toString() ??
                '0',
          ) ??
          0,
      minQuantityPerProduct:
          int.tryParse(
            fields['minQuantityPerProduct']?.integerValue?.toString() ?? '1',
          ) ??
          1,
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
      maxUsagePerUser:
          int.tryParse(
            fields['maxUsagePerUser']?.integerValue?.toString() ?? '0',
          ) ??
          0,
      usageCount:
          int.tryParse(fields['usageCount']?.integerValue?.toString() ?? '0') ??
          0,
      maxTotalUsage: fields['maxTotalUsage']?.integerValue != null
          ? int.tryParse(fields['maxTotalUsage']!.integerValue!)
          : null,
      createdAt:
          DateTime.tryParse(fields['createdAt']?.timestampValue ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, firestore_api.Value> _comboOfferToFirestore(ComboOffer offer) {
    return {
      'comboId': firestore_api.Value(stringValue: offer.comboId ?? ''),
      'name': firestore_api.Value(stringValue: offer.name),
      'description': offer.description != null
          ? firestore_api.Value(stringValue: offer.description!)
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
      'comboProducts': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: offer.comboProducts
              .map(
                (cp) => firestore_api.Value(
                  mapValue: firestore_api.MapValue(
                    fields: {
                      'productId': firestore_api.Value(
                        stringValue: cp.productId,
                      ),
                      if (cp.productName != null)
                        'productName': firestore_api.Value(
                          stringValue: cp.productName!,
                        ),
                      'quantity': firestore_api.Value(
                        integerValue: cp.quantity.toString(),
                      ),
                      if (cp.variantId != null)
                        'variantId': firestore_api.Value(
                          stringValue: cp.variantId!,
                        ),
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
      'discountType': firestore_api.Value(stringValue: offer.discountType),
      'discountValue': firestore_api.Value(doubleValue: offer.discountValue),
      'minQuantityPerProduct': firestore_api.Value(
        integerValue: offer.minQuantityPerProduct.toString(),
      ),
      'startDate': firestore_api.Value(
        timestampValue: offer.startDate.toUtc().toIso8601String(),
      ),
      'endDate': firestore_api.Value(
        timestampValue: offer.endDate.toUtc().toIso8601String(),
      ),
      'isActive': firestore_api.Value(booleanValue: offer.isActive),
      'priority': firestore_api.Value(integerValue: offer.priority.toString()),
      'maxUsagePerUser': firestore_api.Value(
        integerValue: offer.maxUsagePerUser.toString(),
      ),
      'usageCount': firestore_api.Value(
        integerValue: offer.usageCount.toString(),
      ),
      if (offer.maxTotalUsage != null)
        'maxTotalUsage': firestore_api.Value(
          integerValue: offer.maxTotalUsage.toString(),
        ),
      'createdAt': firestore_api.Value(
        timestampValue: offer.createdAt.toUtc().toIso8601String(),
      ),
    };
  }

  String _generateComboId(ComboOffer offer) {
    final productIds = offer.comboProducts.map((cp) => cp.productId).join('_');
    return '${productIds}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _ensureAdmin(
    dynamic firestore,
    String firebaseUid,
    String idToken,
  ) async {
    // Admin check logic - reuse from other endpoints
  }
}

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final item in this) {
      if (test(item)) return item;
    }
    return null;
  }
}
