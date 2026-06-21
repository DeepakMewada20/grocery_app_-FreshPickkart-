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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ReferralSettings implements _i1.SerializableModel {
  ReferralSettings._({
    required this.isEnabled,
    required this.inviteeCouponEnabled,
    required this.inviteeCouponAmount,
    required this.inviteeCouponCodeTemplate,
    required this.referrerPointsEnabled,
    required this.referrerRewardPoints,
    required this.minimumQualifyingAmount,
    required this.rewardTriggerStatus,
    required this.maxRewardedPerMonth,
    required this.enableFraudProtection,
    required this.enableReferralExpiry,
    required this.referralExpiryDays,
    required this.shareMessageTemplate,
    required this.updatedAt,
  });

  factory ReferralSettings({
    required bool isEnabled,
    required bool inviteeCouponEnabled,
    required double inviteeCouponAmount,
    required String inviteeCouponCodeTemplate,
    required bool referrerPointsEnabled,
    required int referrerRewardPoints,
    required double minimumQualifyingAmount,
    required String rewardTriggerStatus,
    required int maxRewardedPerMonth,
    required bool enableFraudProtection,
    required bool enableReferralExpiry,
    required int referralExpiryDays,
    required String shareMessageTemplate,
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
      minimumQualifyingAmount:
          (jsonSerialization['minimumQualifyingAmount'] as num).toDouble(),
      rewardTriggerStatus: jsonSerialization['rewardTriggerStatus'] as String,
      maxRewardedPerMonth: jsonSerialization['maxRewardedPerMonth'] as int,
      enableFraudProtection: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['enableFraudProtection'],
      ),
      enableReferralExpiry: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['enableReferralExpiry'],
      ),
      referralExpiryDays: jsonSerialization['referralExpiryDays'] as int,
      shareMessageTemplate: jsonSerialization['shareMessageTemplate'] as String,
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

  double minimumQualifyingAmount;

  String rewardTriggerStatus;

  int maxRewardedPerMonth;

  bool enableFraudProtection;

  bool enableReferralExpiry;

  int referralExpiryDays;

  String shareMessageTemplate;

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
    double? minimumQualifyingAmount,
    String? rewardTriggerStatus,
    int? maxRewardedPerMonth,
    bool? enableFraudProtection,
    bool? enableReferralExpiry,
    int? referralExpiryDays,
    String? shareMessageTemplate,
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
      'minimumQualifyingAmount': minimumQualifyingAmount,
      'rewardTriggerStatus': rewardTriggerStatus,
      'maxRewardedPerMonth': maxRewardedPerMonth,
      'enableFraudProtection': enableFraudProtection,
      'enableReferralExpiry': enableReferralExpiry,
      'referralExpiryDays': referralExpiryDays,
      'shareMessageTemplate': shareMessageTemplate,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ReferralSettingsImpl extends ReferralSettings {
  _ReferralSettingsImpl({
    required bool isEnabled,
    required bool inviteeCouponEnabled,
    required double inviteeCouponAmount,
    required String inviteeCouponCodeTemplate,
    required bool referrerPointsEnabled,
    required int referrerRewardPoints,
    required double minimumQualifyingAmount,
    required String rewardTriggerStatus,
    required int maxRewardedPerMonth,
    required bool enableFraudProtection,
    required bool enableReferralExpiry,
    required int referralExpiryDays,
    required String shareMessageTemplate,
    required DateTime updatedAt,
  }) : super._(
         isEnabled: isEnabled,
         inviteeCouponEnabled: inviteeCouponEnabled,
         inviteeCouponAmount: inviteeCouponAmount,
         inviteeCouponCodeTemplate: inviteeCouponCodeTemplate,
         referrerPointsEnabled: referrerPointsEnabled,
         referrerRewardPoints: referrerRewardPoints,
         minimumQualifyingAmount: minimumQualifyingAmount,
         rewardTriggerStatus: rewardTriggerStatus,
         maxRewardedPerMonth: maxRewardedPerMonth,
         enableFraudProtection: enableFraudProtection,
         enableReferralExpiry: enableReferralExpiry,
         referralExpiryDays: referralExpiryDays,
         shareMessageTemplate: shareMessageTemplate,
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
    double? minimumQualifyingAmount,
    String? rewardTriggerStatus,
    int? maxRewardedPerMonth,
    bool? enableFraudProtection,
    bool? enableReferralExpiry,
    int? referralExpiryDays,
    String? shareMessageTemplate,
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
      minimumQualifyingAmount:
          minimumQualifyingAmount ?? this.minimumQualifyingAmount,
      rewardTriggerStatus: rewardTriggerStatus ?? this.rewardTriggerStatus,
      maxRewardedPerMonth: maxRewardedPerMonth ?? this.maxRewardedPerMonth,
      enableFraudProtection:
          enableFraudProtection ?? this.enableFraudProtection,
      enableReferralExpiry: enableReferralExpiry ?? this.enableReferralExpiry,
      referralExpiryDays: referralExpiryDays ?? this.referralExpiryDays,
      shareMessageTemplate: shareMessageTemplate ?? this.shareMessageTemplate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
