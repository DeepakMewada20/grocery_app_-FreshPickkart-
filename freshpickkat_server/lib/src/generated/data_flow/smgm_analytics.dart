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

abstract class SmgmAnalytics
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SmgmAnalytics._({
    required this.totalOffers,
    required this.activeOffers,
    required this.totalRewardsGiven,
    required this.totalRewardValue,
    required this.totalOrdersWithSmgm,
  });

  factory SmgmAnalytics({
    required int totalOffers,
    required int activeOffers,
    required int totalRewardsGiven,
    required double totalRewardValue,
    required int totalOrdersWithSmgm,
  }) = _SmgmAnalyticsImpl;

  factory SmgmAnalytics.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmgmAnalytics(
      totalOffers: jsonSerialization['totalOffers'] as int,
      activeOffers: jsonSerialization['activeOffers'] as int,
      totalRewardsGiven: jsonSerialization['totalRewardsGiven'] as int,
      totalRewardValue: (jsonSerialization['totalRewardValue'] as num)
          .toDouble(),
      totalOrdersWithSmgm: jsonSerialization['totalOrdersWithSmgm'] as int,
    );
  }

  int totalOffers;

  int activeOffers;

  int totalRewardsGiven;

  double totalRewardValue;

  int totalOrdersWithSmgm;

  /// Returns a shallow copy of this [SmgmAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SmgmAnalytics copyWith({
    int? totalOffers,
    int? activeOffers,
    int? totalRewardsGiven,
    double? totalRewardValue,
    int? totalOrdersWithSmgm,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SmgmAnalytics',
      'totalOffers': totalOffers,
      'activeOffers': activeOffers,
      'totalRewardsGiven': totalRewardsGiven,
      'totalRewardValue': totalRewardValue,
      'totalOrdersWithSmgm': totalOrdersWithSmgm,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SmgmAnalytics',
      'totalOffers': totalOffers,
      'activeOffers': activeOffers,
      'totalRewardsGiven': totalRewardsGiven,
      'totalRewardValue': totalRewardValue,
      'totalOrdersWithSmgm': totalOrdersWithSmgm,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SmgmAnalyticsImpl extends SmgmAnalytics {
  _SmgmAnalyticsImpl({
    required int totalOffers,
    required int activeOffers,
    required int totalRewardsGiven,
    required double totalRewardValue,
    required int totalOrdersWithSmgm,
  }) : super._(
         totalOffers: totalOffers,
         activeOffers: activeOffers,
         totalRewardsGiven: totalRewardsGiven,
         totalRewardValue: totalRewardValue,
         totalOrdersWithSmgm: totalOrdersWithSmgm,
       );

  /// Returns a shallow copy of this [SmgmAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SmgmAnalytics copyWith({
    int? totalOffers,
    int? activeOffers,
    int? totalRewardsGiven,
    double? totalRewardValue,
    int? totalOrdersWithSmgm,
  }) {
    return SmgmAnalytics(
      totalOffers: totalOffers ?? this.totalOffers,
      activeOffers: activeOffers ?? this.activeOffers,
      totalRewardsGiven: totalRewardsGiven ?? this.totalRewardsGiven,
      totalRewardValue: totalRewardValue ?? this.totalRewardValue,
      totalOrdersWithSmgm: totalOrdersWithSmgm ?? this.totalOrdersWithSmgm,
    );
  }
}
