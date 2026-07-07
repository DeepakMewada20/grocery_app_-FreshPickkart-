import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../postgres/postgres_delivery_service.dart';

class DeliveryEngine {
  static final PostgresDeliveryService _storage = PostgresDeliveryService();

  static Future<DeliveryPricingResult> calculate({
    required Session session,
    required double cartTotal,
    String? userId,
    String? location,
  }) async {
    final config = await getDeliveryConfig(session);
    final rules = await getActiveDeliveryRules(session);

    final matchingRules = <DeliveryRule>[];
    for (final rule in rules) {
      if (!await matchesUserAsync(session, rule, userId)) continue;
      matchingRules.add(rule);
    }

    matchingRules.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (matchingRules.isNotEmpty) {
      final selectedRule = matchingRules.first;
      return _buildResult(
        deliveryFee: selectedRule.deliveryFee,
        cartTotal: cartTotal,
        config: config,
        deliverySource: 'delivery_rule',
        appliedRuleId: selectedRule.ruleId,
        appliedRuleType: 'delivery_rule',
        appliedRuleName: selectedRule.name,
      );
    }

    final slab = _matchSlab(cartTotal, config.slabs);
    if (slab != null) {
      return _buildResult(
        deliveryFee: slab.fee,
        cartTotal: cartTotal,
        config: config,
        deliverySource: 'delivery_slab',
        appliedRuleType: 'slab',
        appliedRuleName:
            '₹${slab.minOrderAmount.toStringAsFixed(0)} - ₹${slab.maxOrderAmount.toStringAsFixed(0)} slab',
      );
    }

    return _buildResult(
      deliveryFee: config.baseDeliveryFee,
      cartTotal: cartTotal,
      config: config,
      deliverySource: 'base_fee',
      appliedRuleType: 'base_fee',
      appliedRuleName: 'Base delivery fee',
    );
  }

  static Future<DeliveryConfig> getDeliveryConfig(Session session) {
    return _storage.getDeliveryConfig(session);
  }

  static Future<bool> saveDeliveryConfig(
    Session session,
    DeliveryConfig config,
  ) {
    return _storage.saveDeliveryConfig(session, config);
  }

  static Future<List<DeliveryRule>> getActiveDeliveryRules(Session session) {
    return _storage.getActiveDeliveryRules(session);
  }

  static Future<List<DeliveryRule>> getInactiveDeliveryRules(
    Session session,
  ) {
    return _storage.getInactiveDeliveryRules(session);
  }

  static Future<List<DeliveryRule>> getAllDeliveryRules(Session session) {
    return _storage.getAllDeliveryRules(session);
  }

  static Future<List<DeliveryRule>> getAllDeliveryRulesIncludingInactive(Session session) {
    return _storage.getAllDeliveryRulesIncludingInactive(session);
  }

  static Future<bool> upsertDeliveryRule(
    Session session,
    DeliveryRule rule,
  ) {
    return _storage.upsertDeliveryRule(session, rule);
  }

  static Future<String> deleteDeliveryRule(Session session, String ruleId) {
    return _storage.deleteDeliveryRule(session, ruleId);
  }

  static Future<bool> setDeliveryRuleActive(
    Session session,
    String ruleId,
    bool isActive,
  ) {
    return _storage.setDeliveryRuleActive(session, ruleId, isActive);
  }

  static Future<bool> moveDeliveryRuleUp(Session session, String ruleId) {
    return _storage.moveDeliveryRuleUp(session, ruleId);
  }

  static Future<bool> moveDeliveryRuleDown(Session session, String ruleId) {
    return _storage.moveDeliveryRuleDown(session, ruleId);
  }

  static DeliverySlab? _matchSlab(double cartTotal, List<DeliverySlab> slabs) {
    for (final slab in slabs) {
      if (cartTotal >= slab.minOrderAmount &&
          cartTotal <= slab.maxOrderAmount) {
        return slab;
      }
    }
    return null;
  }

  static Future<int> _getCompletedOrdersCount(
    Session session,
    String? userId,
  ) async {
    final normalizedUserId = userId?.trim();
    if (normalizedUserId == null || normalizedUserId.isEmpty) return 0;

    final user = await AppUserRow.db.findFirstRow(
      session,
      where: (t) =>
          t.firebaseUid.equals(normalizedUserId) & t.status.equals('active'),
    );
    if (user?.id == null) return 0;

    return CustomerOrderRow.db.count(
      session,
      where: (t) =>
          t.userId.equals(user!.id!) & t.orderStatus.equals('delivered'),
    );
  }

  static Future<bool> _isNewUser(Session session, String userId) async {
    final count = await _getCompletedOrdersCount(session, userId);
    return count <= 0;
  }

  static Future<bool> matchesUserAsync(
    Session session,
    DeliveryRule rule,
    String? userId,
  ) async {
    final target = rule.targetUserType?.trim().toLowerCase();
    if (target == null || target.isEmpty || target == 'all') {
      return true;
    }
    if (target == 'new_user') {
      return _isNewUser(session, userId ?? '');
    }
    if (target == 'specific_order') {
      if (rule.targetOrderCount == null || rule.targetOrderCount! <= 0) {
        return false;
      }
      final count = await _getCompletedOrdersCount(session, userId);
      return count == (rule.targetOrderCount! - 1);
    }
    return false;
  }

  static Future<DeliveryPricingResult> getUserDeliveryOffer(
    Session session,
    String userId,
  ) async {
    final config = await getDeliveryConfig(session);
    final rules = await getActiveDeliveryRules(session);

    final matchingRules = <DeliveryRule>[];
    for (final rule in rules) {
      if (!await matchesUserAsync(session, rule, userId)) continue;
      matchingRules.add(rule);
    }

    matchingRules.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (matchingRules.isNotEmpty) {
      final rule = matchingRules.first;
      final message = _buildOfferMessage(rule);
      final result = _buildResult(
        deliveryFee: rule.deliveryFee,
        cartTotal: 0,
        config: config,
        deliverySource: 'delivery_rule',
        appliedRuleId: rule.ruleId,
        appliedRuleType: 'delivery_rule',
        appliedRuleName: rule.name,
      );
      return DeliveryPricingResult(
        deliveryFee: result.deliveryFee,
        isFree: result.isFree,
        message: message,
        remainingAmount: result.remainingAmount,
        progressPercent: result.progressPercent,
        deliverySource: result.deliverySource,
        appliedRuleId: result.appliedRuleId,
        appliedRuleType: result.appliedRuleType,
        appliedRuleName: result.appliedRuleName,
        baseDeliveryFee: result.baseDeliveryFee,
      );
    }

    return DeliveryPricingResult(
      deliveryFee: config.baseDeliveryFee,
      isFree: false,
      message: null,
      deliverySource: 'base_fee',
      appliedRuleType: null,
      appliedRuleName: null,
      baseDeliveryFee: config.baseDeliveryFee,
    );
  }

  static String _buildOfferMessage(DeliveryRule rule) {
    final target = rule.targetUserType?.trim().toLowerCase();
    final isFree = rule.deliveryFee <= 0;

    if (target == 'new_user') {
      return isFree
          ? 'Free delivery on your 1st order!'
          : 'Special delivery pricing on your 1st order';
    }
    if (target == 'specific_order') {
      final n = rule.targetOrderCount ?? 0;
      return isFree
          ? 'Free delivery on your ${n}th order!'
          : 'Special pricing on your ${n}th order';
    }
    return isFree ? 'Free delivery on all orders!' : 'Special delivery pricing';
  }

  static DeliveryPricingResult _buildResult({
    required double deliveryFee,
    required double cartTotal,
    required DeliveryConfig config,
    required String deliverySource,
    String? appliedRuleId,
    required String appliedRuleType,
    required String appliedRuleName,
  }) {
    double? remainingAmount;
    double? progressPercent;
    String? message;

    if (deliveryFee <= 0) {
      message = 'FREE Delivery unlocked';
      progressPercent = 100;
      remainingAmount = 0;
    } else {
      double? freeThreshold;
      for (final s in config.slabs) {
        if (s.fee <= 0 && (freeThreshold == null || s.minOrderAmount < freeThreshold)) {
          freeThreshold = s.minOrderAmount;
        }
      }
      if (freeThreshold != null && freeThreshold > 0) {
        final diff = freeThreshold - cartTotal;
        if (diff > 0) {
          remainingAmount = diff;
          message = 'Add ₹${diff.toStringAsFixed(0)} more for free delivery';
          progressPercent =
              ((cartTotal / freeThreshold) * 100).clamp(0, 100).toDouble();
        }
      }
    }

    return DeliveryPricingResult(
      deliveryFee: deliveryFee < 0 ? 0 : deliveryFee,
      isFree: deliveryFee <= 0,
      message: message,
      remainingAmount: remainingAmount,
      progressPercent: progressPercent,
      deliverySource: deliverySource,
      appliedRuleId: appliedRuleId,
      appliedRuleType: appliedRuleType,
      appliedRuleName: appliedRuleName,
      baseDeliveryFee: deliveryFee < 0 ? 0 : deliveryFee,
    );
  }
}
