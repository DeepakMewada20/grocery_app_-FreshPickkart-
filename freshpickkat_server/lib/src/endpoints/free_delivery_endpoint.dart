import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import '../services/business/audit_log_service.dart';
import '../services/business/validation_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class FreeDeliveryEndpoint extends Endpoint {
  static const String _collection = 'free_delivery_rules';
  static const String _projectId = 'freshpickkart-a6824';
  static const double _baseDeliveryFee = 40.0;

  Future<bool> upsertFreeDeliveryRule(
    Session session,
    FreeDeliveryRule rule,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);
    ValidationService.validateFreeDeliveryRule(rule);

    if (rule.ruleId == null || rule.ruleId!.isEmpty) {
      rule.ruleId = 'rule_${DateTime.now().millisecondsSinceEpoch}';
    }

    final database = 'projects/$_projectId/databases/(default)/documents';
    final docPath = '$database/$_collection/${rule.ruleId}';

    final fields = _freeDeliveryRuleToFirestore(rule);
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
      entityType: 'free_delivery_rule',
      entityId: rule.ruleId!,
    );

    return true;
  }

  Future<bool> deleteFreeDeliveryRule(
    Session session,
    String ruleId,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);

    final database = 'projects/$_projectId/databases/(default)/documents';
    final docPath = '$database/$_collection/$ruleId';

    try {
      await firestore.projects.databases.documents.delete(docPath);
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'delete',
        entityType: 'free_delivery_rule',
        entityId: ruleId,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<FreeDeliveryRule>> getActiveFreeDeliveryRules(
    Session session,
  ) async {
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

    final rules = <FreeDeliveryRule>[];
    final now = DateTime.now();

    for (final res in response) {
      if (res.document?.fields == null) continue;
      final rule = _freeDeliveryRuleFromFirestore(
        res.document!.fields!,
        res.document!.name!.split('/').last,
      );
      if (rule.startDate.isAfter(now) || rule.endDate.isBefore(now)) continue;
      rules.add(rule);
    }

    return rules;
  }

  Future<List<FreeDeliveryRule>> getAllFreeDeliveryRules(
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

    final rules = <FreeDeliveryRule>[];
    for (final res in response) {
      if (res.document?.fields != null) {
        rules.add(
          _freeDeliveryRuleFromFirestore(
            res.document!.fields!,
            res.document!.name!.split('/').last,
          ),
        );
      }
    }
    return rules;
  }

  Future<FreeDeliveryRulePage> getFreeDeliveryRulesPage(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 20,
    String? pageToken,
  }) async {
    final rules = await getAllFreeDeliveryRules(session, firebaseUid, idToken);
    rules.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final offset = int.tryParse(pageToken ?? '') ?? 0;
    final safeOffset = offset.clamp(0, rules.length);
    final end = (safeOffset + limit).clamp(0, rules.length);
    final pageItems = rules.sublist(safeOffset, end);
    final nextOffset = end < rules.length ? '$end' : null;

    return FreeDeliveryRulePage(
      rules: pageItems,
      nextPageToken: nextOffset,
      totalCount: rules.length,
    );
  }

  Future<bool> setFreeDeliveryRuleActive(
    Session session,
    String ruleId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);

    final database = 'projects/$_projectId/databases/(default)/documents';
    final docPath = '$database/$_collection/$ruleId';

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

  Future<double> calculateDeliveryFee(
    Session session,
    double orderAmount,
    int itemCount,
    String? couponCode,
    String? userId,
  ) async {
    final rules = await getActiveFreeDeliveryRules(session);

    for (final rule in rules) {
      bool qualifies = false;

      if (rule.ruleType == 'min_order_amount' &&
          rule.minOrderAmount != null &&
          orderAmount >= rule.minOrderAmount!) {
        qualifies = true;
      } else if (rule.ruleType == 'min_items' &&
          rule.minItemsCount != null &&
          itemCount >= rule.minItemsCount!) {
        qualifies = true;
      } else if (rule.ruleType == 'coupon' &&
          rule.couponCode != null &&
          couponCode?.toUpperCase() == rule.couponCode!.toUpperCase()) {
        qualifies = true;
      } else if (rule.ruleType == 'user_specific' &&
          rule.userId != null &&
          rule.userId == userId) {
        qualifies = true;
      }

      if (qualifies) {
        return _baseDeliveryFee - rule.deliveryFeeWaived;
      }
    }

    return _baseDeliveryFee;
  }

  FreeDeliveryRule _freeDeliveryRuleFromFirestore(
    Map<String, firestore_api.Value> fields,
    String docId,
  ) {
    return FreeDeliveryRule(
      ruleId: fields['ruleId']?.stringValue ?? docId,
      name: fields['name']?.stringValue ?? '',
      description: fields['description']?.stringValue,
      ruleType: fields['ruleType']?.stringValue ?? 'min_order_amount',
      minOrderAmount:
          fields['minOrderAmount']?.doubleValue != null ||
              fields['minOrderAmount']?.integerValue != null
          ? double.tryParse(
              fields['minOrderAmount']?.doubleValue?.toString() ??
                  fields['minOrderAmount']?.integerValue?.toString() ??
                  '',
            )
          : null,
      minItemsCount: fields['minItemsCount']?.integerValue != null
          ? int.tryParse(fields['minItemsCount']!.integerValue!)
          : null,
      couponCode: fields['couponCode']?.stringValue,
      userId: fields['userId']?.stringValue,
      isActive: fields['isActive']?.booleanValue ?? true,
      startDate:
          DateTime.tryParse(fields['startDate']?.timestampValue ?? '') ??
          DateTime.now(),
      endDate:
          DateTime.tryParse(fields['endDate']?.timestampValue ?? '') ??
          DateTime.now().add(const Duration(days: 30)),
      deliveryFeeWaived:
          double.tryParse(
            fields['deliveryFeeWaived']?.doubleValue?.toString() ??
                fields['deliveryFeeWaived']?.integerValue?.toString() ??
                '40',
          ) ??
          _baseDeliveryFee,
      createdAt:
          DateTime.tryParse(fields['createdAt']?.timestampValue ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, firestore_api.Value> _freeDeliveryRuleToFirestore(
    FreeDeliveryRule rule,
  ) {
    return {
      'ruleId': firestore_api.Value(stringValue: rule.ruleId ?? ''),
      'name': firestore_api.Value(stringValue: rule.name),
      'description': rule.description != null
          ? firestore_api.Value(stringValue: rule.description!)
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
      'ruleType': firestore_api.Value(stringValue: rule.ruleType),
      if (rule.minOrderAmount != null)
        'minOrderAmount': firestore_api.Value(
          doubleValue: rule.minOrderAmount!,
        ),
      if (rule.minItemsCount != null)
        'minItemsCount': firestore_api.Value(
          integerValue: rule.minItemsCount.toString(),
        ),
      if (rule.couponCode != null)
        'couponCode': firestore_api.Value(stringValue: rule.couponCode!),
      if (rule.userId != null)
        'userId': firestore_api.Value(stringValue: rule.userId!),
      'isActive': firestore_api.Value(booleanValue: rule.isActive),
      'startDate': firestore_api.Value(
        timestampValue: rule.startDate.toUtc().toIso8601String(),
      ),
      'endDate': firestore_api.Value(
        timestampValue: rule.endDate.toUtc().toIso8601String(),
      ),
      'deliveryFeeWaived': firestore_api.Value(
        doubleValue: rule.deliveryFeeWaived,
      ),
      'createdAt': firestore_api.Value(
        timestampValue: rule.createdAt.toUtc().toIso8601String(),
      ),
    };
  }

  Future<void> _ensureAdmin(
    dynamic firestore,
    String firebaseUid,
    String idToken,
  ) async {}
}
