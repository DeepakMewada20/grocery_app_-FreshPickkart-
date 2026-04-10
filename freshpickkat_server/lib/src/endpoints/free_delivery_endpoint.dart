import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/business/audit_log_service.dart';
import '../services/business/validation_service.dart';
import '../services/delivery/delivery_engine.dart';
import '../services/firebase_service.dart';

class FreeDeliveryEndpoint extends Endpoint {
  Future<DeliveryConfig> getDeliveryConfig(Session session) async {
    return DeliveryEngine.getDeliveryConfig();
  }

  Future<bool> upsertDeliveryConfig(
    Session session,
    DeliveryConfig config,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);
    ValidationService.validateDeliveryConfig(config);

    final result = await DeliveryEngine.saveDeliveryConfig(config);
    if (result) {
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'upsert',
        entityType: 'delivery_config',
        entityId: config.configId ?? 'default',
      );
    }
    return result;
  }

  Future<List<DeliveryRule>> getAllDeliveryRules(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);
    return DeliveryEngine.getAllDeliveryRules();
  }

  Future<DeliveryRulePage> getDeliveryRulesPage(
    Session session,
    String firebaseUid,
    String idToken, {
    int limit = 20,
    String? pageToken,
  }) async {
    final rules = await getAllDeliveryRules(session, firebaseUid, idToken);
    rules.sort((a, b) {
      final priorityCompare = a.priority.compareTo(b.priority);
      if (priorityCompare != 0) return priorityCompare;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });

    final offset = int.tryParse(pageToken ?? '') ?? 0;
    final safeOffset = offset.clamp(0, rules.length);
    final end = (safeOffset + limit).clamp(0, rules.length);
    final pageItems = rules.sublist(safeOffset, end);
    final nextOffset = end < rules.length ? '$end' : null;

    return DeliveryRulePage(
      rules: pageItems,
      nextPageToken: nextOffset,
      totalCount: rules.length,
    );
  }

  Future<bool> upsertDeliveryRule(
    Session session,
    DeliveryRule rule,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);
    ValidationService.validateDeliveryRule(rule);

    final result = await DeliveryEngine.upsertDeliveryRule(rule);
    if (result) {
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'upsert',
        entityType: 'delivery_rule',
        entityId: rule.ruleId ?? rule.name,
      );
    }
    return result;
  }

  Future<bool> deleteDeliveryRule(
    Session session,
    String ruleId,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);

    final result = await DeliveryEngine.deleteDeliveryRule(ruleId);
    if (result) {
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'delete',
        entityType: 'delivery_rule',
        entityId: ruleId,
      );
    }
    return result;
  }

  Future<bool> setDeliveryRuleActive(
    Session session,
    String ruleId,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await _ensureAdmin(firestore, firebaseUid, idToken);
    return DeliveryEngine.setDeliveryRuleActive(ruleId, isActive);
  }

  Future<DeliveryPricingResult> calculateDeliveryPricing(
    Session session,
    double cartTotal, {
    String? userId,
    String? location,
  }) async {
    return DeliveryEngine.calculate(
      session: session,
      cartTotal: cartTotal,
      userId: userId,
      location: location,
    );
  }

  Future<void> _ensureAdmin(
    dynamic firestore,
    String firebaseUid,
    String idToken,
  ) async {}
}
