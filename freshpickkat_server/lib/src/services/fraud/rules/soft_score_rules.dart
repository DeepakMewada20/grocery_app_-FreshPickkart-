import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../fraud_rule.dart';

/// Escalating score for matching delivery addresses.
/// First match: +20, repeat: +40, frequent: +70.
class SameAddressRule extends FraudRule {
  @override
  String get name => 'same_address';
  @override
  int get weight => 20;

  @override
  Future<FraudRuleResult> evaluate(
    Session session,
    ReferralRow referral,
  ) async {
    if (referral.inviteeUserId == null) {
      return _skip('No invitee linked');
    }

    // Get invitee's orders with addresses
    final inviteeOrders = await CustomerOrderRow.db.find(
      session,
      where: (t) =>
          t.userId.equals(referral.inviteeUserId) &
          t.orderStatus.equals('delivered'),
      limit: 5,
    );
    if (inviteeOrders.isEmpty) {
      return _skip('Invitee has no delivered orders');
    }

    // Get referrer's delivered orders with addresses
    final referrerOrders = await CustomerOrderRow.db.find(
      session,
      where: (t) =>
          t.userId.equals(referral.referrerUserId) &
          t.orderStatus.equals('delivered'),
      limit: 5,
    );
    if (referrerOrders.isEmpty) {
      return _skip('Referrer has no delivered orders');
    }

    // Collect all addresses
    final inviteeAddresses = <String>{};
    for (final order in inviteeOrders) {
      if (order.id != null) {
        final addr = await OrderAddressRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(order.id!),
        );
        if (addr != null) {
          inviteeAddresses.add(_normalizeAddress(addr));
        }
      }
    }

    final referrerAddresses = <String>{};
    for (final order in referrerOrders) {
      if (order.id != null) {
        final addr = await OrderAddressRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(order.id!),
        );
        if (addr != null) {
          referrerAddresses.add(_normalizeAddress(addr));
        }
      }
    }

    if (inviteeAddresses.isEmpty || referrerAddresses.isEmpty) {
      return _skip('No addresses found');
    }

    // Count matches
    int matchCount = 0;
    for (final ia in inviteeAddresses) {
      if (referrerAddresses.contains(ia)) {
        matchCount++;
      }
    }

    int score = 0;
    String description;
    if (matchCount == 0) {
      description = 'No matching delivery addresses';
    } else if (matchCount == 1) {
      score = 20;
      description = 'One matching delivery address (+20)';
    } else if (matchCount <= 3) {
      score = 40;
      description = '$matchCount matching delivery addresses (+40)';
    } else {
      score = 70;
      description = '$matchCount matching delivery addresses — frequent (+70)';
    }

    return FraudRuleResult(
      ruleName: name,
      weight: weight,
      score: score,
      passed: score < 40,
      description: description,
    );
  }

  String _normalizeAddress(OrderAddressRow addr) {
    return '${addr.streetLine1.trim().toLowerCase()}|'
        '${addr.city.trim().toLowerCase()}|'
        '${addr.state.trim().toLowerCase()}|'
        '${addr.postalCode.trim()}';
  }

  FraudRuleResult _skip(String reason) => FraudRuleResult(
    ruleName: name, weight: weight, score: 0, passed: true,
    description: reason,
  );
}

/// Score for matching Razorpay contact phone (paidByName/paidByPhone).
class SamePaymentContactRule extends FraudRule {
  @override
  String get name => 'same_payment_contact';
  @override
  int get weight => 30;

  @override
  Future<FraudRuleResult> evaluate(
    Session session,
    ReferralRow referral,
  ) async {
    if (referral.inviteeUserId == null) {
      return _skip('No invitee linked');
    }

    final inviteeOrders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.userId.equals(referral.inviteeUserId),
      limit: 3,
    );
    if (inviteeOrders.isEmpty) return _skip('No invitee orders');

    final referrerOrders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.userId.equals(referral.referrerUserId),
      limit: 3,
    );
    if (referrerOrders.isEmpty) return _skip('No referrer orders');

    // Extract payment contacts
    final inviteeContacts = <String>{};
    for (final o in inviteeOrders) {
      if (o.paidByPhone != null && o.paidByPhone!.isNotEmpty) {
        inviteeContacts.add(o.paidByPhone!);
      }
    }

    final referrerContacts = <String>{};
    for (final o in referrerOrders) {
      if (o.paidByPhone != null && o.paidByPhone!.isNotEmpty) {
        referrerContacts.add(o.paidByPhone!);
      }
    }

    if (inviteeContacts.isEmpty || referrerContacts.isEmpty) {
      return _skip('No payment contacts found');
    }

    final matched = inviteeContacts.intersection(referrerContacts);
    if (matched.isEmpty) {
      return FraudRuleResult(
        ruleName: name, weight: weight, score: 0, passed: true,
        description: 'No matching payment contacts',
      );
    }

    return FraudRuleResult(
      ruleName: name,
      weight: weight,
      score: 30,
      passed: false,
      description: 'Matching Razorpay contact phone: ${matched.first} (+30)',
    );
  }

  FraudRuleResult _skip(String reason) => FraudRuleResult(
    ruleName: name, weight: weight, score: 0, passed: true,
    description: reason,
  );
}

/// Score for matching payer name (paidByName on orders).
class SamePayerNameRule extends FraudRule {
  @override
  String get name => 'same_payer_name';
  @override
  int get weight => 20;

  @override
  Future<FraudRuleResult> evaluate(
    Session session,
    ReferralRow referral,
  ) async {
    if (referral.inviteeUserId == null) {
      return _skip('No invitee linked');
    }

    final inviteeOrders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.userId.equals(referral.inviteeUserId),
      limit: 3,
    );
    final referrerOrders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.userId.equals(referral.referrerUserId),
      limit: 3,
    );

    final inviteeNames = <String>{};
    for (final o in inviteeOrders) {
      if (o.paidByName != null && o.paidByName!.trim().isNotEmpty) {
        inviteeNames.add(o.paidByName!.trim().toLowerCase());
      }
    }

    final referrerNames = <String>{};
    for (final o in referrerOrders) {
      if (o.paidByName != null && o.paidByName!.trim().isNotEmpty) {
        referrerNames.add(o.paidByName!.trim().toLowerCase());
      }
    }

    if (inviteeNames.isEmpty || referrerNames.isEmpty) {
      return _skip('No payer names found');
    }

    final matched = inviteeNames.intersection(referrerNames);
    if (matched.isEmpty) {
      return FraudRuleResult(
        ruleName: name, weight: weight, score: 0, passed: true,
        description: 'No matching payer names',
      );
    }

    return FraudRuleResult(
      ruleName: name,
      weight: weight,
      score: 20,
      passed: false,
      description: 'Matching payer name: ${matched.first} (+20)',
    );
  }

  FraudRuleResult _skip(String reason) => FraudRuleResult(
    ruleName: name, weight: weight, score: 0, passed: true,
    description: reason,
  );
}

/// Score for referral velocity (too many in short time).
class ReferralVelocityRule extends FraudRule {
  @override
  String get name => 'referral_velocity';
  @override
  int get weight => 30;

  @override
  Future<FraudRuleResult> evaluate(
    Session session,
    ReferralRow referral,
  ) async {
    final settings = await ReferralSettingsRow.db.findFirstRow(session);
    if (settings == null || !settings.enableFraudScoring) {
      return _skip('Fraud scoring disabled');
    }

    final windowHours = settings.velocityTimeWindowHours;
    final threshold = settings.velocityThreshold;
    final scoreAmount = settings.referralVelocityScore;
    final now = DateTime.now().toUtc();
    final windowStart = now.subtract(Duration(hours: windowHours));

    final recent = await ReferralRow.db.find(
      session,
      where: (t) =>
          t.referrerUserId.equals(referral.referrerUserId) &
          (t.createdAt >= windowStart),
    );

    if (recent.length <= threshold) {
      return FraudRuleResult(
        ruleName: name, weight: weight, score: 0, passed: true,
        description: '${recent.length} referrals in $windowHours hours (threshold: $threshold)',
      );
    }

    final extra = recent.length - threshold;
    final totalScore = scoreAmount * extra;
    return FraudRuleResult(
      ruleName: name,
      weight: weight,
      score: totalScore,
      passed: false,
      description: '${recent.length} referrals in $windowHours hours ($extra above $threshold threshold, +$totalScore)',
    );
  }

  FraudRuleResult _skip(String reason) => FraudRuleResult(
    ruleName: name, weight: weight, score: 0, passed: true,
    description: reason,
  );
}

/// Score for very new accounts (invitee or referrer created recently).
class NewAccountRule extends FraudRule {
  @override
  String get name => 'new_account';
  @override
  int get weight => 20;

  @override
  Future<FraudRuleResult> evaluate(
    Session session,
    ReferralRow referral,
  ) async {
    final settings = await ReferralSettingsRow.db.findFirstRow(session);
    if (settings == null || !settings.enableFraudScoring) {
      return _skip('Fraud scoring disabled');
    }

    final accountAgeHours = settings.newAccountHours;
    final scoreAmount = settings.newAccountScore;
    final now = DateTime.now().toUtc();
    final cutoff = now.subtract(Duration(hours: accountAgeHours));

    int totalScore = 0;
    final reasons = <String>[];

    final referrer = await AppUserRow.db.findById(
      session, referral.referrerUserId);
    if (referrer != null && referrer.createdAt.isAfter(cutoff)) {
      totalScore += scoreAmount;
      final ageHours = now.difference(referrer.createdAt).inHours;
      reasons.add('Referrer account age: ${ageHours}h (+$scoreAmount)');
    }

    if (referral.inviteeUserId != null) {
      final invitee = await AppUserRow.db.findById(
        session, referral.inviteeUserId!);
      if (invitee != null && invitee.createdAt.isAfter(cutoff)) {
        totalScore += scoreAmount;
        final ageHours = now.difference(invitee.createdAt).inHours;
        reasons.add('Invitee account age: ${ageHours}h (+$scoreAmount)');
      }
    }

    if (totalScore == 0) {
      return FraudRuleResult(
        ruleName: name, weight: weight, score: 0, passed: true,
        description: 'Both accounts older than $accountAgeHours hours',
      );
    }

    return FraudRuleResult(
      ruleName: name,
      weight: weight,
      score: totalScore,
      passed: false,
      description: '${reasons.join('; ')} (+$totalScore)',
    );
  }

  FraudRuleResult _skip(String reason) => FraudRuleResult(
    ruleName: name, weight: weight, score: 0, passed: true,
    description: reason,
  );
}
