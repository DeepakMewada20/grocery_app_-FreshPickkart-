import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../fraud_rule.dart';

/// Hard-reject if referrer == invitee (same user ID).
class SameUidRule extends FraudRule {
  @override
  String get name => 'same_user_id';
  @override
  int get weight => 0;

  @override
  Future<FraudRuleResult> evaluate(
    Session session,
    ReferralRow referral,
  ) async {
    final passed = referral.referrerUserId != referral.inviteeUserId;
    return FraudRuleResult(
      ruleName: name,
      weight: weight,
      score: passed ? 0 : 999,
      passed: passed,
      description: passed
          ? 'Referrer and invitee are different users'
          : 'Referrer and invitee are the same user',
    );
  }
}

/// Hard-reject if referrer and invitee have the same phone number.
class SamePhoneRule extends FraudRule {
  @override
  String get name => 'same_phone';
  @override
  int get weight => 0;

  @override
  Future<FraudRuleResult> evaluate(
    Session session,
    ReferralRow referral,
  ) async {
    final referrer = await AppUserRow.db.findById(
      session, referral.referrerUserId);
    if (referrer == null) {
      return FraudRuleResult(
        ruleName: name, weight: weight, score: 0, passed: true,
        description: 'Referrer not found — skipping',
      );
    }

    if (referral.inviteeUserId == null) {
      return FraudRuleResult(
        ruleName: name, weight: weight, score: 0, passed: true,
        description: 'Invitee not linked — skipping',
      );
    }

    final invitee = await AppUserRow.db.findById(
      session, referral.inviteeUserId!);
    if (invitee == null) {
      return FraudRuleResult(
        ruleName: name, weight: weight, score: 0, passed: true,
        description: 'Invitee not found — skipping',
      );
    }

    final samePhone = referrer.phoneNumber == invitee.phoneNumber;
    return FraudRuleResult(
      ruleName: name,
      weight: weight,
      score: samePhone ? 999 : 0,
      passed: !samePhone,
      description: samePhone
          ? 'Referrer and invitee have the same phone: ${referrer.phoneNumber}'
          : 'Different phone numbers',
    );
  }
}

/// Hard-reject if referral is already rewarded.
class AlreadyRewardedRule extends FraudRule {
  @override
  String get name => 'already_rewarded';
  @override
  int get weight => 0;

  @override
  Future<FraudRuleResult> evaluate(
    Session session,
    ReferralRow referral,
  ) async {
    final already = referral.status == 'REWARDED';
    return FraudRuleResult(
      ruleName: name,
      weight: weight,
      score: already ? 999 : 0,
      passed: !already,
      description: already
          ? 'Referral already rewarded'
          : 'Referral not yet rewarded',
    );
  }
}
