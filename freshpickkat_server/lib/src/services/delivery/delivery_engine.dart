import 'package:googleapis/firestore/v1.dart' as firestore_api;
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../firebase_service.dart';

class DeliveryEngine {
  static const String _projectId = 'freshpickkart-a6824';
  static const String _database =
      'projects/$_projectId/databases/(default)/documents';
  static const String _configCollection = 'delivery_config';
  static const String _rulesCollection = 'delivery_rules';
  static const String _usersCollection = 'users';
  static const String _defaultConfigId = 'default';

  static Future<DeliveryPricingResult> calculate({
    required Session session,
    required double cartTotal,
    String? userId,
    String? location,
  }) async {
    final config = await getDeliveryConfig();
    final rules = await getActiveDeliveryRules();

    final matchingRules = <DeliveryRule>[];
    for (final rule in rules) {
      if (!await matchesUserAsync(rule, userId)) continue;
      matchingRules.add(rule);
    }

    matchingRules.sort((a, b) => a.priority.compareTo(b.priority));
    if (matchingRules.isNotEmpty) {
      final selectedRule = matchingRules.first;
      return _buildResult(
        deliveryFee: selectedRule.deliveryFee,
        cartTotal: cartTotal,
        config: config,
        appliedRuleType: selectedRule.ruleType,
        appliedRuleName: selectedRule.name,
      );
    }

    final slab = _matchSlab(cartTotal, config.slabs);
    if (slab != null) {
      return _buildResult(
        deliveryFee: slab.fee,
        cartTotal: cartTotal,
        config: config,
        appliedRuleType: 'slab',
        appliedRuleName:
            '₹${slab.minOrderAmount.toStringAsFixed(0)} - ₹${slab.maxOrderAmount.toStringAsFixed(0)} slab',
      );
    }

    return _buildResult(
      deliveryFee: config.baseDeliveryFee,
      cartTotal: cartTotal,
      config: config,
      appliedRuleType: 'base_fee',
      appliedRuleName: 'Base delivery fee',
    );
  }

  static Future<DeliveryConfig> getDeliveryConfig() async {
    final firestore = await FirebaseService.getFirestoreClient();
    final docPath = '$_database/$_configCollection/$_defaultConfigId';

    try {
      final doc = await firestore.projects.databases.documents.get(docPath);
      if (doc.fields != null) {
        return _deliveryConfigFromFirestore(doc.fields!, _defaultConfigId);
      }
    } catch (_) {}

    return DeliveryConfig(
      configId: _defaultConfigId,
      baseDeliveryFee: 40,
      freeDeliveryThreshold: 300,
      slabs: [
        DeliverySlab(minOrderAmount: 0, maxOrderAmount: 199, fee: 40),
        DeliverySlab(minOrderAmount: 200, maxOrderAmount: 299, fee: 20),
        DeliverySlab(minOrderAmount: 300, maxOrderAmount: 999999, fee: 0),
      ],
      isActive: true,
      updatedAt: DateTime.now(),
    );
  }

  static Future<bool> saveDeliveryConfig(DeliveryConfig config) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final docPath = '$_database/$_configCollection/$_defaultConfigId';
    final doc = firestore_api.Document(
      fields: _deliveryConfigToFirestore(
        config.copyWith(
          configId: _defaultConfigId,
          updatedAt: DateTime.now(),
        ),
      ),
    );
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: doc.fields!.keys.toList(),
    );
    return true;
  }

  static Future<List<DeliveryRule>> getActiveDeliveryRules() async {
    final firestore = await FirebaseService.getFirestoreClient();
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: _rulesCollection)],
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
      _database,
    );

    final now = DateTime.now();
    final rules = <DeliveryRule>[];
    for (final res in response) {
      if (res.document?.fields == null) continue;
      final doc = res.document!;
      final rule = _deliveryRuleFromFirestore(
        doc.fields!,
        doc.name!.split('/').last,
      );
      if (rule.ruleType != 'user_rule') {
        if (rule.startDate.isAfter(now) || rule.endDate.isBefore(now)) continue;
      }
      rules.add(rule);
    }
    return rules;
  }

  static Future<List<DeliveryRule>> getAllDeliveryRules() async {
    final firestore = await FirebaseService.getFirestoreClient();
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: _rulesCollection)],
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      _database,
    );

    final rules = <DeliveryRule>[];
    for (final res in response) {
      if (res.document?.fields == null) continue;
      final doc = res.document!;
      rules.add(
        _deliveryRuleFromFirestore(doc.fields!, doc.name!.split('/').last),
      );
    }
    return rules;
  }

  static Future<bool> upsertDeliveryRule(DeliveryRule rule) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final ruleId =
        rule.ruleId?.trim().isNotEmpty == true
        ? rule.ruleId!
        : 'delivery_rule_${DateTime.now().millisecondsSinceEpoch}';
    final docPath = '$_database/$_rulesCollection/$ruleId';
    final doc = firestore_api.Document(
      fields: _deliveryRuleToFirestore(
        rule.copyWith(
          ruleId: ruleId,
          createdAt: rule.createdAt,
        ),
      ),
    );
    await firestore.projects.databases.documents.patch(
      doc,
      docPath,
      updateMask_fieldPaths: doc.fields!.keys.toList(),
    );
    return true;
  }

  static Future<bool> deleteDeliveryRule(String ruleId) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final docPath = '$_database/$_rulesCollection/$ruleId';
    try {
      await firestore.projects.databases.documents.delete(docPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> setDeliveryRuleActive(
    String ruleId,
    bool isActive,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final docPath = '$_database/$_rulesCollection/$ruleId';
    try {
      await firestore.projects.databases.documents.patch(
        firestore_api.Document(
          fields: {'isActive': firestore_api.Value(booleanValue: isActive)},
        ),
        docPath,
        updateMask_fieldPaths: ['isActive'],
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static DeliverySlab? _matchSlab(double cartTotal, List<DeliverySlab> slabs) {
    for (final slab in slabs) {
      if (cartTotal >= slab.minOrderAmount && cartTotal <= slab.maxOrderAmount) {
        return slab;
      }
    }
    return null;
  }

  static Future<int> _getCompletedOrdersCount(String? userId) async {
    if (userId == null || userId.trim().isEmpty) return 0;
    final firestore = await FirebaseService.getFirestoreClient();
    final docPath = '$_database/$_usersCollection/$userId';
    try {
      final doc = await firestore.projects.databases.documents.get(docPath);
      return int.tryParse(doc.fields?['completedOrdersCount']?.integerValue ?? '') ?? 0;
    } catch (_) {
      return 0;
    }
  }

  static Future<bool> _isNewUser(String userId) async {
    final count = await _getCompletedOrdersCount(userId);
    return count <= 0;
  }

  static Future<bool> matchesUserAsync(DeliveryRule rule, String? userId) async {
    final target = rule.targetUserType?.trim().toLowerCase();
    if (target == null || target.isEmpty || target == 'all') {
      return true;
    }
    if (target == 'new_user') {
      return _isNewUser(userId ?? '');
    }
    if (target == 'specific_order') {
      if (rule.targetOrderCount == null || rule.targetOrderCount! <= 0) return false;
      final count = await _getCompletedOrdersCount(userId);
      return count == (rule.targetOrderCount! - 1);
    }
    return false;
  }

  static DeliveryPricingResult _buildResult({
    required double deliveryFee,
    required double cartTotal,
    required DeliveryConfig config,
    required String appliedRuleType,
    required String appliedRuleName,
  }) {
    final freeThreshold = config.freeDeliveryThreshold;
    double? remainingAmount;
    double? progressPercent;
    String? message;

    if (deliveryFee <= 0) {
      message = 'FREE Delivery unlocked';
      progressPercent = 100;
      remainingAmount = 0;
    }

    return DeliveryPricingResult(
      deliveryFee: deliveryFee < 0 ? 0 : deliveryFee,
      isFree: deliveryFee <= 0,
      message: message,
      remainingAmount: remainingAmount,
      progressPercent: progressPercent,
      appliedRuleType: appliedRuleType,
      appliedRuleName: appliedRuleName,
      freeDeliveryThreshold: freeThreshold,
      baseDeliveryFee: config.baseDeliveryFee,
    );
  }

  static DeliveryConfig _deliveryConfigFromFirestore(
    Map<String, firestore_api.Value> fields,
    String docId,
  ) {
    final slabs =
        fields['slabs']?.arrayValue?.values
            ?.map((value) {
              final slabFields = value.mapValue?.fields;
              if (slabFields == null) return null;
              return DeliverySlab(
                minOrderAmount: _getDouble(slabFields['minOrderAmount']) ?? 0,
                maxOrderAmount: _getDouble(slabFields['maxOrderAmount']) ?? 0,
                fee: _getDouble(slabFields['fee']) ?? 0,
              );
            })
            .whereType<DeliverySlab>()
            .toList() ??
        <DeliverySlab>[];

    return DeliveryConfig(
      configId: fields['configId']?.stringValue ?? docId,
      baseDeliveryFee: _getDouble(fields['baseDeliveryFee']) ?? 40,
      freeDeliveryThreshold: _getDouble(fields['freeDeliveryThreshold']),
      slabs: slabs,
      isActive: fields['isActive']?.booleanValue ?? true,
      updatedAt:
          DateTime.tryParse(fields['updatedAt']?.timestampValue ?? '') ??
          DateTime.now(),
    );
  }

  static Map<String, firestore_api.Value> _deliveryConfigToFirestore(
    DeliveryConfig config,
  ) {
    return {
      'configId': firestore_api.Value(stringValue: config.configId ?? _defaultConfigId),
      'baseDeliveryFee': firestore_api.Value(doubleValue: config.baseDeliveryFee),
      if (config.freeDeliveryThreshold != null)
        'freeDeliveryThreshold': firestore_api.Value(
          doubleValue: config.freeDeliveryThreshold!,
        ),
      'slabs': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: config.slabs
              .map(
                (slab) => firestore_api.Value(
                  mapValue: firestore_api.MapValue(
                    fields: {
                      'minOrderAmount': firestore_api.Value(
                        doubleValue: slab.minOrderAmount,
                      ),
                      'maxOrderAmount': firestore_api.Value(
                        doubleValue: slab.maxOrderAmount,
                      ),
                      'fee': firestore_api.Value(doubleValue: slab.fee),
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
      'isActive': firestore_api.Value(booleanValue: config.isActive),
      'updatedAt': firestore_api.Value(
        timestampValue: config.updatedAt.toUtc().toIso8601String(),
      ),
    };
  }

  static DeliveryRule _deliveryRuleFromFirestore(
    Map<String, firestore_api.Value> fields,
    String docId,
  ) {
    return DeliveryRule(
      ruleId: fields['ruleId']?.stringValue ?? docId,
      name: fields['name']?.stringValue ?? '',
      description: fields['description']?.stringValue,
      ruleType: fields['ruleType']?.stringValue ?? 'special_event',
      deliveryFee: _getDouble(fields['deliveryFee']) ?? 0,
      priority: int.tryParse(fields['priority']?.integerValue ?? '999') ?? 999,
      targetUserType: fields['targetUserType']?.stringValue,
      targetOrderCount: int.tryParse(fields['targetOrderCount']?.integerValue ?? ''),
      isActive: fields['isActive']?.booleanValue ?? true,
      startDate:
          DateTime.tryParse(fields['startDate']?.timestampValue ?? '') ??
          DateTime.now(),
      endDate:
          DateTime.tryParse(fields['endDate']?.timestampValue ?? '') ??
          DateTime.now().add(const Duration(days: 30)),
      createdAt:
          DateTime.tryParse(fields['createdAt']?.timestampValue ?? '') ??
          DateTime.now(),
    );
  }

  static Map<String, firestore_api.Value> _deliveryRuleToFirestore(
    DeliveryRule rule,
  ) {
    return {
      'ruleId': firestore_api.Value(stringValue: rule.ruleId ?? ''),
      'name': firestore_api.Value(stringValue: rule.name),
      if (rule.description != null)
        'description': firestore_api.Value(stringValue: rule.description!),
      'ruleType': firestore_api.Value(stringValue: rule.ruleType),
      'deliveryFee': firestore_api.Value(doubleValue: rule.deliveryFee),
      'priority': firestore_api.Value(integerValue: rule.priority.toString()),
      if (rule.targetUserType != null)
        'targetUserType': firestore_api.Value(stringValue: rule.targetUserType!),
      if (rule.targetOrderCount != null)
        'targetOrderCount': firestore_api.Value(integerValue: rule.targetOrderCount!.toString()),
      'isActive': firestore_api.Value(booleanValue: rule.isActive),
      'startDate': firestore_api.Value(
        timestampValue: rule.startDate.toUtc().toIso8601String(),
      ),
      'endDate': firestore_api.Value(
        timestampValue: rule.endDate.toUtc().toIso8601String(),
      ),
      'createdAt': firestore_api.Value(
        timestampValue: rule.createdAt.toUtc().toIso8601String(),
      ),
    };
  }

  static double? _getDouble(firestore_api.Value? value) {
    if (value == null) return null;
    return double.tryParse(
      value.doubleValue?.toString() ?? value.integerValue?.toString() ?? '',
    );
  }
}
