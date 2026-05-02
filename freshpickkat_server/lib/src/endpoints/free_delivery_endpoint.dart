import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/business/validation_service.dart';
import '../services/delivery/delivery_engine.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';

class FreeDeliveryEndpoint extends Endpoint {
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();

  Future<DeliveryConfig> getDeliveryConfig(Session session) async {
    return DeliveryEngine.getDeliveryConfig(session);
  }

  Future<bool> upsertDeliveryConfig(
    Session session,
    DeliveryConfig config,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    ValidationService.validateDeliveryConfig(config);

    final result = await DeliveryEngine.saveDeliveryConfig(session, config);
    if (result) {
      await _audit.write(
        session,
        actorFirebaseUid: firebaseUid,
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
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return DeliveryEngine.getAllDeliveryRules(session);
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
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    ValidationService.validateDeliveryRule(rule);

    final result = await DeliveryEngine.upsertDeliveryRule(session, rule);
    if (result) {
      await _audit.write(
        session,
        actorFirebaseUid: firebaseUid,
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
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final result = await DeliveryEngine.deleteDeliveryRule(session, ruleId);
    if (result) {
      await _audit.write(
        session,
        actorFirebaseUid: firebaseUid,
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
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return DeliveryEngine.setDeliveryRuleActive(session, ruleId, isActive);
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
}
