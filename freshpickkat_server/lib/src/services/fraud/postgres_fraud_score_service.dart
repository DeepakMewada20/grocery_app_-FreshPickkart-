import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'fraud_rule.dart';
import 'rules/hard_reject_rules.dart';
import 'rules/soft_score_rules.dart';

/// Outcome of fraud scoring for a referral.
class FraudOutcome {
  final ReferralFraudResult result;
  final String newStatus;
  final DateTime? holdExpiresAt;
  final List<FraudRuleResult> ruleResults;

  const FraudOutcome({
    required this.result,
    required this.newStatus,
    this.holdExpiresAt,
    required this.ruleResults,
  });
}

class PostgresFraudScoreService {
  PostgresFraudScoreService._();
  static final instance = PostgresFraudScoreService._();

  final List<FraudRule> _hardRejectRules = [
    SameUidRule(),
    SamePhoneRule(),
    AlreadyRewardedRule(),
  ];

  final List<FraudRule> _softRules = [
    SameAddressRule(),
    SamePaymentContactRule(),
    SamePayerNameRule(),
    ReferralVelocityRule(),
    NewAccountRule(),
  ];

  /// Evaluate a referral for fraud and return outcome with status decision.
  Future<FraudOutcome> evaluateReferral(
    Session session,
    ReferralRow referral,
  ) async {
    final settings = await ReferralSettingsRow.db.findFirstRow(session);
    final scoringEnabled = settings?.enableFraudScoring ?? true;
    final enableAutoReject = settings?.enableAutoReject ?? true;
    final enableRewardHold = settings?.enableRewardHold ?? true;
    final autoApproveThreshold = settings?.autoApproveThreshold ?? 40;
    final manualReviewThreshold = settings?.manualReviewThreshold ?? 69;
    final autoRejectThreshold = settings?.autoRejectThreshold ?? 90;
    final holdDurationHours = settings?.holdDurationHours ?? 72;

    final frrList = <FraudRuleResult>[];
    final ruleResults = <ReferralFraudRuleResult>[];

    // Phase 1: Hard reject rules
    int totalScore = 0;
    String? hardRejectReason;

    for (final rule in _hardRejectRules) {
      final frr = await rule.evaluate(session, referral);
      frrList.add(frr);
      ruleResults.add(_toProtocol(frr));
      if (!frr.passed) {
        hardRejectReason = frr.description;
        totalScore += frr.score;
        break;
      }
    }

    // If hard reject triggered
    if (hardRejectReason != null && enableAutoReject) {
      return FraudOutcome(
        result: ReferralFraudResult(
          totalScore: totalScore,
          outcome: 'AUTO_REJECT',
          rules: ruleResults,
          hardReject: true,
          hardRejectReason: hardRejectReason,
        ),
        newStatus: 'REJECTED',
        ruleResults: frrList,
      );
    }

    // Phase 2: Soft score rules (skip if scoring disabled)
    if (scoringEnabled) {
      for (final rule in _softRules) {
        final frr = await rule.evaluate(session, referral);
        frrList.add(frr);
        ruleResults.add(_toProtocol(frr));
        totalScore += frr.score;
      }
    } else {
      // Mark remaining as skipped
      for (final rule in _softRules) {
        final skipped = FraudRuleResult(
          ruleName: rule.name,
          weight: rule.weight,
          score: 0,
          passed: true,
          description: 'Fraud scoring disabled — skipped',
        );
        frrList.add(skipped);
        ruleResults.add(_toProtocol(skipped));
      }
    }

    // Determine outcome
    String outcome;
    String newStatus;
    DateTime? holdExpiresAt;

    if (!enableAutoReject && totalScore >= autoRejectThreshold) {
      // Auto-reject disabled => fall through to hold
      outcome = 'AUTO_HOLD';
      newStatus = 'REWARD_HELD';
      holdExpiresAt = DateTime.now().toUtc().add(
        Duration(hours: holdDurationHours),
      );
    } else if (totalScore >= autoRejectThreshold) {
      outcome = 'AUTO_REJECT';
      newStatus = 'REJECTED';
    } else if (totalScore > manualReviewThreshold) {
      if (enableRewardHold) {
        outcome = 'AUTO_HOLD';
        newStatus = 'REWARD_HELD';
        holdExpiresAt = DateTime.now().toUtc().add(
          Duration(hours: holdDurationHours),
        );
      } else {
        outcome = 'MANUAL_REVIEW';
        newStatus = 'PENDING_REVIEW';
      }
    } else if (totalScore >= autoApproveThreshold) {
      outcome = 'MANUAL_REVIEW';
      newStatus = 'PENDING_REVIEW';
    } else {
      outcome = 'AUTO_APPROVE';
      newStatus = 'SIGNED_UP';
    }

    return FraudOutcome(
      result: ReferralFraudResult(
        totalScore: totalScore,
        outcome: outcome,
        rules: ruleResults,
        hardReject: false,
        hardRejectReason: null,
      ),
      newStatus: newStatus,
      holdExpiresAt: holdExpiresAt,
      ruleResults: frrList,
    );
  }

  ReferralFraudRuleResult _toProtocol(FraudRuleResult frr) =>
      ReferralFraudRuleResult(
        ruleName: frr.ruleName,
        weight: frr.weight,
        score: frr.score,
        passed: frr.passed,
        description: frr.description,
      );
}
