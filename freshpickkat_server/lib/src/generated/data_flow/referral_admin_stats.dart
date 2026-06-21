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
import '../data_flow/top_referrer_entry.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class ReferralAdminStats
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReferralAdminStats._({
    required this.totalReferrals,
    required this.qualifiedReferrals,
    required this.rewardedReferrals,
    required this.pendingReferrals,
    required this.rejectedReferrals,
    required this.expiredReferrals,
    required this.totalPointsIssued,
    required this.totalCouponsIssued,
    required this.funnelShared,
    required this.funnelSignedUp,
    required this.funnelQualified,
    required this.funnelRewarded,
    required this.topReferrers,
  });

  factory ReferralAdminStats({
    required int totalReferrals,
    required int qualifiedReferrals,
    required int rewardedReferrals,
    required int pendingReferrals,
    required int rejectedReferrals,
    required int expiredReferrals,
    required int totalPointsIssued,
    required int totalCouponsIssued,
    required int funnelShared,
    required int funnelSignedUp,
    required int funnelQualified,
    required int funnelRewarded,
    required List<_i2.TopReferrerEntry> topReferrers,
  }) = _ReferralAdminStatsImpl;

  factory ReferralAdminStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferralAdminStats(
      totalReferrals: jsonSerialization['totalReferrals'] as int,
      qualifiedReferrals: jsonSerialization['qualifiedReferrals'] as int,
      rewardedReferrals: jsonSerialization['rewardedReferrals'] as int,
      pendingReferrals: jsonSerialization['pendingReferrals'] as int,
      rejectedReferrals: jsonSerialization['rejectedReferrals'] as int,
      expiredReferrals: jsonSerialization['expiredReferrals'] as int,
      totalPointsIssued: jsonSerialization['totalPointsIssued'] as int,
      totalCouponsIssued: jsonSerialization['totalCouponsIssued'] as int,
      funnelShared: jsonSerialization['funnelShared'] as int,
      funnelSignedUp: jsonSerialization['funnelSignedUp'] as int,
      funnelQualified: jsonSerialization['funnelQualified'] as int,
      funnelRewarded: jsonSerialization['funnelRewarded'] as int,
      topReferrers: _i3.Protocol().deserialize<List<_i2.TopReferrerEntry>>(
        jsonSerialization['topReferrers'],
      ),
    );
  }

  int totalReferrals;

  int qualifiedReferrals;

  int rewardedReferrals;

  int pendingReferrals;

  int rejectedReferrals;

  int expiredReferrals;

  int totalPointsIssued;

  int totalCouponsIssued;

  int funnelShared;

  int funnelSignedUp;

  int funnelQualified;

  int funnelRewarded;

  List<_i2.TopReferrerEntry> topReferrers;

  /// Returns a shallow copy of this [ReferralAdminStats]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferralAdminStats copyWith({
    int? totalReferrals,
    int? qualifiedReferrals,
    int? rewardedReferrals,
    int? pendingReferrals,
    int? rejectedReferrals,
    int? expiredReferrals,
    int? totalPointsIssued,
    int? totalCouponsIssued,
    int? funnelShared,
    int? funnelSignedUp,
    int? funnelQualified,
    int? funnelRewarded,
    List<_i2.TopReferrerEntry>? topReferrers,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReferralAdminStats',
      'totalReferrals': totalReferrals,
      'qualifiedReferrals': qualifiedReferrals,
      'rewardedReferrals': rewardedReferrals,
      'pendingReferrals': pendingReferrals,
      'rejectedReferrals': rejectedReferrals,
      'expiredReferrals': expiredReferrals,
      'totalPointsIssued': totalPointsIssued,
      'totalCouponsIssued': totalCouponsIssued,
      'funnelShared': funnelShared,
      'funnelSignedUp': funnelSignedUp,
      'funnelQualified': funnelQualified,
      'funnelRewarded': funnelRewarded,
      'topReferrers': topReferrers.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReferralAdminStats',
      'totalReferrals': totalReferrals,
      'qualifiedReferrals': qualifiedReferrals,
      'rewardedReferrals': rewardedReferrals,
      'pendingReferrals': pendingReferrals,
      'rejectedReferrals': rejectedReferrals,
      'expiredReferrals': expiredReferrals,
      'totalPointsIssued': totalPointsIssued,
      'totalCouponsIssued': totalCouponsIssued,
      'funnelShared': funnelShared,
      'funnelSignedUp': funnelSignedUp,
      'funnelQualified': funnelQualified,
      'funnelRewarded': funnelRewarded,
      'topReferrers': topReferrers.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ReferralAdminStatsImpl extends ReferralAdminStats {
  _ReferralAdminStatsImpl({
    required int totalReferrals,
    required int qualifiedReferrals,
    required int rewardedReferrals,
    required int pendingReferrals,
    required int rejectedReferrals,
    required int expiredReferrals,
    required int totalPointsIssued,
    required int totalCouponsIssued,
    required int funnelShared,
    required int funnelSignedUp,
    required int funnelQualified,
    required int funnelRewarded,
    required List<_i2.TopReferrerEntry> topReferrers,
  }) : super._(
         totalReferrals: totalReferrals,
         qualifiedReferrals: qualifiedReferrals,
         rewardedReferrals: rewardedReferrals,
         pendingReferrals: pendingReferrals,
         rejectedReferrals: rejectedReferrals,
         expiredReferrals: expiredReferrals,
         totalPointsIssued: totalPointsIssued,
         totalCouponsIssued: totalCouponsIssued,
         funnelShared: funnelShared,
         funnelSignedUp: funnelSignedUp,
         funnelQualified: funnelQualified,
         funnelRewarded: funnelRewarded,
         topReferrers: topReferrers,
       );

  /// Returns a shallow copy of this [ReferralAdminStats]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferralAdminStats copyWith({
    int? totalReferrals,
    int? qualifiedReferrals,
    int? rewardedReferrals,
    int? pendingReferrals,
    int? rejectedReferrals,
    int? expiredReferrals,
    int? totalPointsIssued,
    int? totalCouponsIssued,
    int? funnelShared,
    int? funnelSignedUp,
    int? funnelQualified,
    int? funnelRewarded,
    List<_i2.TopReferrerEntry>? topReferrers,
  }) {
    return ReferralAdminStats(
      totalReferrals: totalReferrals ?? this.totalReferrals,
      qualifiedReferrals: qualifiedReferrals ?? this.qualifiedReferrals,
      rewardedReferrals: rewardedReferrals ?? this.rewardedReferrals,
      pendingReferrals: pendingReferrals ?? this.pendingReferrals,
      rejectedReferrals: rejectedReferrals ?? this.rejectedReferrals,
      expiredReferrals: expiredReferrals ?? this.expiredReferrals,
      totalPointsIssued: totalPointsIssued ?? this.totalPointsIssued,
      totalCouponsIssued: totalCouponsIssued ?? this.totalCouponsIssued,
      funnelShared: funnelShared ?? this.funnelShared,
      funnelSignedUp: funnelSignedUp ?? this.funnelSignedUp,
      funnelQualified: funnelQualified ?? this.funnelQualified,
      funnelRewarded: funnelRewarded ?? this.funnelRewarded,
      topReferrers:
          topReferrers ?? this.topReferrers.map((e0) => e0.copyWith()).toList(),
    );
  }
}
