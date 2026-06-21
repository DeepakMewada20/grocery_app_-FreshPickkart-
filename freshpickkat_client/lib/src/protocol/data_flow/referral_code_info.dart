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

abstract class ReferralCodeInfo implements _i1.SerializableModel {
  ReferralCodeInfo._({
    required this.referralCode,
    required this.shareLink,
    required this.shareMessage,
    required this.totalReferred,
    required this.totalQualified,
    required this.totalRewardsEarned,
  });

  factory ReferralCodeInfo({
    required String referralCode,
    required String shareLink,
    required String shareMessage,
    required int totalReferred,
    required int totalQualified,
    required int totalRewardsEarned,
  }) = _ReferralCodeInfoImpl;

  factory ReferralCodeInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferralCodeInfo(
      referralCode: jsonSerialization['referralCode'] as String,
      shareLink: jsonSerialization['shareLink'] as String,
      shareMessage: jsonSerialization['shareMessage'] as String,
      totalReferred: jsonSerialization['totalReferred'] as int,
      totalQualified: jsonSerialization['totalQualified'] as int,
      totalRewardsEarned: jsonSerialization['totalRewardsEarned'] as int,
    );
  }

  String referralCode;

  String shareLink;

  String shareMessage;

  int totalReferred;

  int totalQualified;

  int totalRewardsEarned;

  /// Returns a shallow copy of this [ReferralCodeInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferralCodeInfo copyWith({
    String? referralCode,
    String? shareLink,
    String? shareMessage,
    int? totalReferred,
    int? totalQualified,
    int? totalRewardsEarned,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReferralCodeInfo',
      'referralCode': referralCode,
      'shareLink': shareLink,
      'shareMessage': shareMessage,
      'totalReferred': totalReferred,
      'totalQualified': totalQualified,
      'totalRewardsEarned': totalRewardsEarned,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ReferralCodeInfoImpl extends ReferralCodeInfo {
  _ReferralCodeInfoImpl({
    required String referralCode,
    required String shareLink,
    required String shareMessage,
    required int totalReferred,
    required int totalQualified,
    required int totalRewardsEarned,
  }) : super._(
         referralCode: referralCode,
         shareLink: shareLink,
         shareMessage: shareMessage,
         totalReferred: totalReferred,
         totalQualified: totalQualified,
         totalRewardsEarned: totalRewardsEarned,
       );

  /// Returns a shallow copy of this [ReferralCodeInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferralCodeInfo copyWith({
    String? referralCode,
    String? shareLink,
    String? shareMessage,
    int? totalReferred,
    int? totalQualified,
    int? totalRewardsEarned,
  }) {
    return ReferralCodeInfo(
      referralCode: referralCode ?? this.referralCode,
      shareLink: shareLink ?? this.shareLink,
      shareMessage: shareMessage ?? this.shareMessage,
      totalReferred: totalReferred ?? this.totalReferred,
      totalQualified: totalQualified ?? this.totalQualified,
      totalRewardsEarned: totalRewardsEarned ?? this.totalRewardsEarned,
    );
  }
}
