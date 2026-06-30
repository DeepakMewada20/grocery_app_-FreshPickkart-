/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ReferralSettings
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReferralSettings._({
    required this.isEnabled,
    required this.inviteeCouponEnabled,
    required this.inviteeCouponAmount,
    required this.inviteeCouponCodeTemplate,
    required this.referrerPointsEnabled,
    required this.referrerRewardPoints,
    required this.rewardTriggerStatus,
    required this.maxRewardedPerMonth,
    required this.inviteeCouponMinOrderAmount,
    required this.inviteeCouponValidityDays,
    required this.enableFraudProtection,
    required this.enableReferralExpiry,
    required this.referralExpiryDays,
    required this.shareMessageTemplate,
    required this.enableFraudScoring,
    required this.autoApproveThreshold,
    required this.manualReviewThreshold,
    required this.autoRejectThreshold,
    required this.enableRewardHold,
    required this.holdDurationHours,
    required this.enableAutoReject,
    required this.minimumActualPaymentForQualification,
    required this.maxRewardedPerDay,
    required this.maxPendingReferrals,
    required this.maxSharesPerDay,
    required this.maxSharesPerMonth,
    required this.referralVelocityScore,
    required this.velocityTimeWindowHours,
    required this.velocityThreshold,
    required this.autoReversalWindowDays,
    this.termsText,
    required this.updatedAt,
  });

  factory ReferralSettings({
    required bool isEnabled,
    required bool inviteeCouponEnabled,
    required double inviteeCouponAmount,
    required String inviteeCouponCodeTemplate,
    required bool referrerPointsEnabled,
    required int referrerRewardPoints,
    required String rewardTriggerStatus,
    required int maxRewardedPerMonth,
    required double inviteeCouponMinOrderAmount,
    required int inviteeCouponValidityDays,
    required bool enableFraudProtection,
    required bool enableReferralExpiry,
    required int referralExpiryDays,
    required String shareMessageTemplate,
    required bool enableFraudScoring,
    required int autoApproveThreshold,
    required int manualReviewThreshold,
    required int autoRejectThreshold,
    required bool enableRewardHold,
    required int holdDurationHours,
    required bool enableAutoReject,
    required double minimumActualPaymentForQualification,
    required int maxRewardedPerDay,
    required int maxPendingReferrals,
    required int maxSharesPerDay,
    required int maxSharesPerMonth,
    required int referralVelocityScore,
    required int velocityTimeWindowHours,
    required int velocityThreshold,
    required int autoReversalWindowDays,
    String? termsText,
    required DateTime updatedAt,
  }) = _ReferralSettingsImpl;

  factory ReferralSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferralSettings(
      isEnabled: _i1.BoolJsonExtension.fromJson(jsonSerialization['isEnabled']),
      inviteeCouponEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['inviteeCouponEnabled'],
      ),
      inviteeCouponAmount: (jsonSerialization['inviteeCouponAmount'] as num)
          .toDouble(),
      inviteeCouponCodeTemplate:
          jsonSerialization['inviteeCouponCodeTemplate'] as String,
      referrerPointsEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['referrerPointsEnabled'],
      ),
      referrerRewardPoints: jsonSerialization['referrerRewardPoints'] as int,
      rewardTriggerStatus: jsonSerialization['rewardTriggerStatus'] as String,
      maxRewardedPerMonth: jsonSerialization['maxRewardedPerMonth'] as int,
      inviteeCouponMinOrderAmount:
          (jsonSerialization['inviteeCouponMinOrderAmount'] as num).toDouble(),
      inviteeCouponValidityDays:
          jsonSerialization['inviteeCouponValidityDays'] as int,
      enableFraudProtection: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['enableFraudProtection'],
      ),
      enableReferralExpiry: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['enableReferralExpiry'],
      ),
      referralExpiryDays: jsonSerialization['referralExpiryDays'] as int,
      shareMessageTemplate: jsonSerialization['shareMessageTemplate'] as String,
      enableFraudScoring: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['enableFraudScoring'],
      ),
      autoApproveThreshold: jsonSerialization['autoApproveThreshold'] as int,
      manualReviewThreshold: jsonSerialization['manualReviewThreshold'] as int,
      autoRejectThreshold: jsonSerialization['autoRejectThreshold'] as int,
      enableRewardHold: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['enableRewardHold'],
      ),
      holdDurationHours: jsonSerialization['holdDurationHours'] as int,
      enableAutoReject: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['enableAutoReject'],
      ),
      minimumActualPaymentForQualification:
          (jsonSerialization['minimumActualPaymentForQualification'] as num)
              .toDouble(),
      maxRewardedPerDay: jsonSerialization['maxRewardedPerDay'] as int,
      maxPendingReferrals: jsonSerialization['maxPendingReferrals'] as int,
      maxSharesPerDay: jsonSerialization['maxSharesPerDay'] as int,
      maxSharesPerMonth: jsonSerialization['maxSharesPerMonth'] as int,
      referralVelocityScore: jsonSerialization['referralVelocityScore'] as int,
      velocityTimeWindowHours:
          jsonSerialization['velocityTimeWindowHours'] as int,
      velocityThreshold: jsonSerialization['velocityThreshold'] as int,
      autoReversalWindowDays:
          jsonSerialization['autoReversalWindowDays'] as int,
      termsText: jsonSerialization['termsText'] as String?,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  bool isEnabled;

  bool inviteeCouponEnabled;

  double inviteeCouponAmount;

  String inviteeCouponCodeTemplate;

  bool referrerPointsEnabled;

  int referrerRewardPoints;

  String rewardTriggerStatus;

  int maxRewardedPerMonth;

  double inviteeCouponMinOrderAmount;

  int inviteeCouponValidityDays;

  bool enableFraudProtection;

  bool enableReferralExpiry;

  int referralExpiryDays;

  String shareMessageTemplate;

  bool enableFraudScoring;

  int autoApproveThreshold;

  int manualReviewThreshold;

  int autoRejectThreshold;

  bool enableRewardHold;

  int holdDurationHours;

  bool enableAutoReject;

  double minimumActualPaymentForQualification;

  int maxRewardedPerDay;

  int maxPendingReferrals;

  int maxSharesPerDay;

  int maxSharesPerMonth;

  int referralVelocityScore;

  int velocityTimeWindowHours;

  int velocityThreshold;

  int autoReversalWindowDays;

  String? termsText;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ReferralSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferralSettings copyWith({
    bool? isEnabled,
    bool? inviteeCouponEnabled,
    double? inviteeCouponAmount,
    String? inviteeCouponCodeTemplate,
    bool? referrerPointsEnabled,
    int? referrerRewardPoints,
    String? rewardTriggerStatus,
    int? maxRewardedPerMonth,
    double? inviteeCouponMinOrderAmount,
    int? inviteeCouponValidityDays,
    bool? enableFraudProtection,
    bool? enableReferralExpiry,
    int? referralExpiryDays,
    String? shareMessageTemplate,
    bool? enableFraudScoring,
    int? autoApproveThreshold,
    int? manualReviewThreshold,
    int? autoRejectThreshold,
    bool? enableRewardHold,
    int? holdDurationHours,
    bool? enableAutoReject,
    double? minimumActualPaymentForQualification,
    int? maxRewardedPerDay,
    int? maxPendingReferrals,
    int? maxSharesPerDay,
    int? maxSharesPerMonth,
    int? referralVelocityScore,
    int? velocityTimeWindowHours,
    int? velocityThreshold,
    int? autoReversalWindowDays,
    String? termsText,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReferralSettings',
      'isEnabled': isEnabled,
      'inviteeCouponEnabled': inviteeCouponEnabled,
      'inviteeCouponAmount': inviteeCouponAmount,
      'inviteeCouponCodeTemplate': inviteeCouponCodeTemplate,
      'referrerPointsEnabled': referrerPointsEnabled,
      'referrerRewardPoints': referrerRewardPoints,
      'rewardTriggerStatus': rewardTriggerStatus,
      'maxRewardedPerMonth': maxRewardedPerMonth,
      'inviteeCouponMinOrderAmount': inviteeCouponMinOrderAmount,
      'inviteeCouponValidityDays': inviteeCouponValidityDays,
      'enableFraudProtection': enableFraudProtection,
      'enableReferralExpiry': enableReferralExpiry,
      'referralExpiryDays': referralExpiryDays,
      'shareMessageTemplate': shareMessageTemplate,
      'enableFraudScoring': enableFraudScoring,
      'autoApproveThreshold': autoApproveThreshold,
      'manualReviewThreshold': manualReviewThreshold,
      'autoRejectThreshold': autoRejectThreshold,
      'enableRewardHold': enableRewardHold,
      'holdDurationHours': holdDurationHours,
      'enableAutoReject': enableAutoReject,
      'minimumActualPaymentForQualification':
          minimumActualPaymentForQualification,
      'maxRewardedPerDay': maxRewardedPerDay,
      'maxPendingReferrals': maxPendingReferrals,
      'maxSharesPerDay': maxSharesPerDay,
      'maxSharesPerMonth': maxSharesPerMonth,
      'referralVelocityScore': referralVelocityScore,
      'velocityTimeWindowHours': velocityTimeWindowHours,
      'velocityThreshold': velocityThreshold,
      'autoReversalWindowDays': autoReversalWindowDays,
      if (termsText != null) 'termsText': termsText,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReferralSettings',
      'isEnabled': isEnabled,
      'inviteeCouponEnabled': inviteeCouponEnabled,
      'inviteeCouponAmount': inviteeCouponAmount,
      'inviteeCouponCodeTemplate': inviteeCouponCodeTemplate,
      'referrerPointsEnabled': referrerPointsEnabled,
      'referrerRewardPoints': referrerRewardPoints,
      'rewardTriggerStatus': rewardTriggerStatus,
      'maxRewardedPerMonth': maxRewardedPerMonth,
      'inviteeCouponMinOrderAmount': inviteeCouponMinOrderAmount,
      'inviteeCouponValidityDays': inviteeCouponValidityDays,
      'enableFraudProtection': enableFraudProtection,
      'enableReferralExpiry': enableReferralExpiry,
      'referralExpiryDays': referralExpiryDays,
      'shareMessageTemplate': shareMessageTemplate,
      'enableFraudScoring': enableFraudScoring,
      'autoApproveThreshold': autoApproveThreshold,
      'manualReviewThreshold': manualReviewThreshold,
      'autoRejectThreshold': autoRejectThreshold,
      'enableRewardHold': enableRewardHold,
      'holdDurationHours': holdDurationHours,
      'enableAutoReject': enableAutoReject,
      'minimumActualPaymentForQualification':
          minimumActualPaymentForQualification,
      'maxRewardedPerDay': maxRewardedPerDay,
      'maxPendingReferrals': maxPendingReferrals,
      'maxSharesPerDay': maxSharesPerDay,
      'maxSharesPerMonth': maxSharesPerMonth,
      'referralVelocityScore': referralVelocityScore,
      'velocityTimeWindowHours': velocityTimeWindowHours,
      'velocityThreshold': velocityThreshold,
      'autoReversalWindowDays': autoReversalWindowDays,
      if (termsText != null) 'termsText': termsText,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReferralSettingsImpl extends ReferralSettings {
  _ReferralSettingsImpl({
    required bool isEnabled,
    required bool inviteeCouponEnabled,
    required double inviteeCouponAmount,
    required String inviteeCouponCodeTemplate,
    required bool referrerPointsEnabled,
    required int referrerRewardPoints,
    required String rewardTriggerStatus,
    required int maxRewardedPerMonth,
    required double inviteeCouponMinOrderAmount,
    required int inviteeCouponValidityDays,
    required bool enableFraudProtection,
    required bool enableReferralExpiry,
    required int referralExpiryDays,
    required String shareMessageTemplate,
    required bool enableFraudScoring,
    required int autoApproveThreshold,
    required int manualReviewThreshold,
    required int autoRejectThreshold,
    required bool enableRewardHold,
    required int holdDurationHours,
    required bool enableAutoReject,
    required double minimumActualPaymentForQualification,
    required int maxRewardedPerDay,
    required int maxPendingReferrals,
    required int maxSharesPerDay,
    required int maxSharesPerMonth,
    required int referralVelocityScore,
    required int velocityTimeWindowHours,
    required int velocityThreshold,
    required int autoReversalWindowDays,
    String? termsText,
    required DateTime updatedAt,
  }) : super._(
         isEnabled: isEnabled,
         inviteeCouponEnabled: inviteeCouponEnabled,
         inviteeCouponAmount: inviteeCouponAmount,
         inviteeCouponCodeTemplate: inviteeCouponCodeTemplate,
         referrerPointsEnabled: referrerPointsEnabled,
         referrerRewardPoints: referrerRewardPoints,
         rewardTriggerStatus: rewardTriggerStatus,
         maxRewardedPerMonth: maxRewardedPerMonth,
         inviteeCouponMinOrderAmount: inviteeCouponMinOrderAmount,
         inviteeCouponValidityDays: inviteeCouponValidityDays,
         enableFraudProtection: enableFraudProtection,
         enableReferralExpiry: enableReferralExpiry,
         referralExpiryDays: referralExpiryDays,
         shareMessageTemplate: shareMessageTemplate,
         enableFraudScoring: enableFraudScoring,
         autoApproveThreshold: autoApproveThreshold,
         manualReviewThreshold: manualReviewThreshold,
         autoRejectThreshold: autoRejectThreshold,
         enableRewardHold: enableRewardHold,
         holdDurationHours: holdDurationHours,
         enableAutoReject: enableAutoReject,
         minimumActualPaymentForQualification:
             minimumActualPaymentForQualification,
         maxRewardedPerDay: maxRewardedPerDay,
         maxPendingReferrals: maxPendingReferrals,
         maxSharesPerDay: maxSharesPerDay,
         maxSharesPerMonth: maxSharesPerMonth,
         referralVelocityScore: referralVelocityScore,
         velocityTimeWindowHours: velocityTimeWindowHours,
         velocityThreshold: velocityThreshold,
         autoReversalWindowDays: autoReversalWindowDays,
         termsText: termsText,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ReferralSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferralSettings copyWith({
    bool? isEnabled,
    bool? inviteeCouponEnabled,
    double? inviteeCouponAmount,
    String? inviteeCouponCodeTemplate,
    bool? referrerPointsEnabled,
    int? referrerRewardPoints,
    String? rewardTriggerStatus,
    int? maxRewardedPerMonth,
    double? inviteeCouponMinOrderAmount,
    int? inviteeCouponValidityDays,
    bool? enableFraudProtection,
    bool? enableReferralExpiry,
    int? referralExpiryDays,
    String? shareMessageTemplate,
    bool? enableFraudScoring,
    int? autoApproveThreshold,
    int? manualReviewThreshold,
    int? autoRejectThreshold,
    bool? enableRewardHold,
    int? holdDurationHours,
    bool? enableAutoReject,
    double? minimumActualPaymentForQualification,
    int? maxRewardedPerDay,
    int? maxPendingReferrals,
    int? maxSharesPerDay,
    int? maxSharesPerMonth,
    int? referralVelocityScore,
    int? velocityTimeWindowHours,
    int? velocityThreshold,
    int? autoReversalWindowDays,
    Object? termsText = _Undefined,
    DateTime? updatedAt,
  }) {
    return ReferralSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      inviteeCouponEnabled: inviteeCouponEnabled ?? this.inviteeCouponEnabled,
      inviteeCouponAmount: inviteeCouponAmount ?? this.inviteeCouponAmount,
      inviteeCouponCodeTemplate:
          inviteeCouponCodeTemplate ?? this.inviteeCouponCodeTemplate,
      referrerPointsEnabled:
          referrerPointsEnabled ?? this.referrerPointsEnabled,
      referrerRewardPoints: referrerRewardPoints ?? this.referrerRewardPoints,
      rewardTriggerStatus: rewardTriggerStatus ?? this.rewardTriggerStatus,
      maxRewardedPerMonth: maxRewardedPerMonth ?? this.maxRewardedPerMonth,
      inviteeCouponMinOrderAmount:
          inviteeCouponMinOrderAmount ?? this.inviteeCouponMinOrderAmount,
      inviteeCouponValidityDays:
          inviteeCouponValidityDays ?? this.inviteeCouponValidityDays,
      enableFraudProtection:
          enableFraudProtection ?? this.enableFraudProtection,
      enableReferralExpiry: enableReferralExpiry ?? this.enableReferralExpiry,
      referralExpiryDays: referralExpiryDays ?? this.referralExpiryDays,
      shareMessageTemplate: shareMessageTemplate ?? this.shareMessageTemplate,
      enableFraudScoring: enableFraudScoring ?? this.enableFraudScoring,
      autoApproveThreshold: autoApproveThreshold ?? this.autoApproveThreshold,
      manualReviewThreshold:
          manualReviewThreshold ?? this.manualReviewThreshold,
      autoRejectThreshold: autoRejectThreshold ?? this.autoRejectThreshold,
      enableRewardHold: enableRewardHold ?? this.enableRewardHold,
      holdDurationHours: holdDurationHours ?? this.holdDurationHours,
      enableAutoReject: enableAutoReject ?? this.enableAutoReject,
      minimumActualPaymentForQualification:
          minimumActualPaymentForQualification ??
          this.minimumActualPaymentForQualification,
      maxRewardedPerDay: maxRewardedPerDay ?? this.maxRewardedPerDay,
      maxPendingReferrals: maxPendingReferrals ?? this.maxPendingReferrals,
      maxSharesPerDay: maxSharesPerDay ?? this.maxSharesPerDay,
      maxSharesPerMonth: maxSharesPerMonth ?? this.maxSharesPerMonth,
      referralVelocityScore:
          referralVelocityScore ?? this.referralVelocityScore,
      velocityTimeWindowHours:
          velocityTimeWindowHours ?? this.velocityTimeWindowHours,
      velocityThreshold: velocityThreshold ?? this.velocityThreshold,
      autoReversalWindowDays:
          autoReversalWindowDays ?? this.autoReversalWindowDays,
      termsText: termsText is String? ? termsText : this.termsText,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
