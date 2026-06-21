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

abstract class TopReferrerEntry implements _i1.SerializableModel {
  TopReferrerEntry._({
    required this.userId,
    required this.name,
    required this.phone,
    required this.referralCount,
    required this.rewardPointsIssued,
    required this.qualificationRate,
    this.lastActivity,
  });

  factory TopReferrerEntry({
    required String userId,
    required String name,
    required String phone,
    required int referralCount,
    required int rewardPointsIssued,
    required double qualificationRate,
    DateTime? lastActivity,
  }) = _TopReferrerEntryImpl;

  factory TopReferrerEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return TopReferrerEntry(
      userId: jsonSerialization['userId'] as String,
      name: jsonSerialization['name'] as String,
      phone: jsonSerialization['phone'] as String,
      referralCount: jsonSerialization['referralCount'] as int,
      rewardPointsIssued: jsonSerialization['rewardPointsIssued'] as int,
      qualificationRate: (jsonSerialization['qualificationRate'] as num)
          .toDouble(),
      lastActivity: jsonSerialization['lastActivity'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastActivity'],
            ),
    );
  }

  String userId;

  String name;

  String phone;

  int referralCount;

  int rewardPointsIssued;

  double qualificationRate;

  DateTime? lastActivity;

  /// Returns a shallow copy of this [TopReferrerEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TopReferrerEntry copyWith({
    String? userId,
    String? name,
    String? phone,
    int? referralCount,
    int? rewardPointsIssued,
    double? qualificationRate,
    DateTime? lastActivity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TopReferrerEntry',
      'userId': userId,
      'name': name,
      'phone': phone,
      'referralCount': referralCount,
      'rewardPointsIssued': rewardPointsIssued,
      'qualificationRate': qualificationRate,
      if (lastActivity != null) 'lastActivity': lastActivity?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TopReferrerEntryImpl extends TopReferrerEntry {
  _TopReferrerEntryImpl({
    required String userId,
    required String name,
    required String phone,
    required int referralCount,
    required int rewardPointsIssued,
    required double qualificationRate,
    DateTime? lastActivity,
  }) : super._(
         userId: userId,
         name: name,
         phone: phone,
         referralCount: referralCount,
         rewardPointsIssued: rewardPointsIssued,
         qualificationRate: qualificationRate,
         lastActivity: lastActivity,
       );

  /// Returns a shallow copy of this [TopReferrerEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TopReferrerEntry copyWith({
    String? userId,
    String? name,
    String? phone,
    int? referralCount,
    int? rewardPointsIssued,
    double? qualificationRate,
    Object? lastActivity = _Undefined,
  }) {
    return TopReferrerEntry(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      referralCount: referralCount ?? this.referralCount,
      rewardPointsIssued: rewardPointsIssued ?? this.rewardPointsIssued,
      qualificationRate: qualificationRate ?? this.qualificationRate,
      lastActivity: lastActivity is DateTime?
          ? lastActivity
          : this.lastActivity,
    );
  }
}
