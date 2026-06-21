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

abstract class Referral
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Referral._({
    required this.id,
    required this.referrerUserId,
    this.inviteeUserId,
    required this.inviteePhone,
    required this.status,
    required this.qualifyingOrderAmount,
    required this.rewardPointsIssued,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Referral({
    required String id,
    required String referrerUserId,
    String? inviteeUserId,
    required String inviteePhone,
    required String status,
    required double qualifyingOrderAmount,
    required int rewardPointsIssued,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReferralImpl;

  factory Referral.fromJson(Map<String, dynamic> jsonSerialization) {
    return Referral(
      id: jsonSerialization['id'] as String,
      referrerUserId: jsonSerialization['referrerUserId'] as String,
      inviteeUserId: jsonSerialization['inviteeUserId'] as String?,
      inviteePhone: jsonSerialization['inviteePhone'] as String,
      status: jsonSerialization['status'] as String,
      qualifyingOrderAmount: (jsonSerialization['qualifyingOrderAmount'] as num)
          .toDouble(),
      rewardPointsIssued: jsonSerialization['rewardPointsIssued'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  String id;

  String referrerUserId;

  String? inviteeUserId;

  String inviteePhone;

  String status;

  double qualifyingOrderAmount;

  int rewardPointsIssued;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Referral]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Referral copyWith({
    String? id,
    String? referrerUserId,
    String? inviteeUserId,
    String? inviteePhone,
    String? status,
    double? qualifyingOrderAmount,
    int? rewardPointsIssued,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Referral',
      'id': id,
      'referrerUserId': referrerUserId,
      if (inviteeUserId != null) 'inviteeUserId': inviteeUserId,
      'inviteePhone': inviteePhone,
      'status': status,
      'qualifyingOrderAmount': qualifyingOrderAmount,
      'rewardPointsIssued': rewardPointsIssued,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Referral',
      'id': id,
      'referrerUserId': referrerUserId,
      if (inviteeUserId != null) 'inviteeUserId': inviteeUserId,
      'inviteePhone': inviteePhone,
      'status': status,
      'qualifyingOrderAmount': qualifyingOrderAmount,
      'rewardPointsIssued': rewardPointsIssued,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReferralImpl extends Referral {
  _ReferralImpl({
    required String id,
    required String referrerUserId,
    String? inviteeUserId,
    required String inviteePhone,
    required String status,
    required double qualifyingOrderAmount,
    required int rewardPointsIssued,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         referrerUserId: referrerUserId,
         inviteeUserId: inviteeUserId,
         inviteePhone: inviteePhone,
         status: status,
         qualifyingOrderAmount: qualifyingOrderAmount,
         rewardPointsIssued: rewardPointsIssued,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Referral]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Referral copyWith({
    String? id,
    String? referrerUserId,
    Object? inviteeUserId = _Undefined,
    String? inviteePhone,
    String? status,
    double? qualifyingOrderAmount,
    int? rewardPointsIssued,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Referral(
      id: id ?? this.id,
      referrerUserId: referrerUserId ?? this.referrerUserId,
      inviteeUserId: inviteeUserId is String?
          ? inviteeUserId
          : this.inviteeUserId,
      inviteePhone: inviteePhone ?? this.inviteePhone,
      status: status ?? this.status,
      qualifyingOrderAmount:
          qualifyingOrderAmount ?? this.qualifyingOrderAmount,
      rewardPointsIssued: rewardPointsIssued ?? this.rewardPointsIssued,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
