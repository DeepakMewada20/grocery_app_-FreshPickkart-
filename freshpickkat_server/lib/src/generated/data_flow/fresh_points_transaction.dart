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

abstract class FreshPointsTransaction
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FreshPointsTransaction._({
    required this.id,
    required this.userId,
    required this.transactionType,
    required this.points,
    required this.balanceBefore,
    required this.balanceAfter,
    this.referenceType,
    this.referenceId,
    this.description,
    this.createdBy,
    required this.createdAt,
  });

  factory FreshPointsTransaction({
    required String id,
    required String userId,
    required String transactionType,
    required int points,
    required int balanceBefore,
    required int balanceAfter,
    String? referenceType,
    String? referenceId,
    String? description,
    String? createdBy,
    required DateTime createdAt,
  }) = _FreshPointsTransactionImpl;

  factory FreshPointsTransaction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FreshPointsTransaction(
      id: jsonSerialization['id'] as String,
      userId: jsonSerialization['userId'] as String,
      transactionType: jsonSerialization['transactionType'] as String,
      points: jsonSerialization['points'] as int,
      balanceBefore: jsonSerialization['balanceBefore'] as int,
      balanceAfter: jsonSerialization['balanceAfter'] as int,
      referenceType: jsonSerialization['referenceType'] as String?,
      referenceId: jsonSerialization['referenceId'] as String?,
      description: jsonSerialization['description'] as String?,
      createdBy: jsonSerialization['createdBy'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String id;

  String userId;

  String transactionType;

  int points;

  int balanceBefore;

  int balanceAfter;

  String? referenceType;

  String? referenceId;

  String? description;

  String? createdBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [FreshPointsTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FreshPointsTransaction copyWith({
    String? id,
    String? userId,
    String? transactionType,
    int? points,
    int? balanceBefore,
    int? balanceAfter,
    String? referenceType,
    String? referenceId,
    String? description,
    String? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FreshPointsTransaction',
      'id': id,
      'userId': userId,
      'transactionType': transactionType,
      'points': points,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      if (referenceType != null) 'referenceType': referenceType,
      if (referenceId != null) 'referenceId': referenceId,
      if (description != null) 'description': description,
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FreshPointsTransaction',
      'id': id,
      'userId': userId,
      'transactionType': transactionType,
      'points': points,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      if (referenceType != null) 'referenceType': referenceType,
      if (referenceId != null) 'referenceId': referenceId,
      if (description != null) 'description': description,
      if (createdBy != null) 'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FreshPointsTransactionImpl extends FreshPointsTransaction {
  _FreshPointsTransactionImpl({
    required String id,
    required String userId,
    required String transactionType,
    required int points,
    required int balanceBefore,
    required int balanceAfter,
    String? referenceType,
    String? referenceId,
    String? description,
    String? createdBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         transactionType: transactionType,
         points: points,
         balanceBefore: balanceBefore,
         balanceAfter: balanceAfter,
         referenceType: referenceType,
         referenceId: referenceId,
         description: description,
         createdBy: createdBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FreshPointsTransaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FreshPointsTransaction copyWith({
    String? id,
    String? userId,
    String? transactionType,
    int? points,
    int? balanceBefore,
    int? balanceAfter,
    Object? referenceType = _Undefined,
    Object? referenceId = _Undefined,
    Object? description = _Undefined,
    Object? createdBy = _Undefined,
    DateTime? createdAt,
  }) {
    return FreshPointsTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      transactionType: transactionType ?? this.transactionType,
      points: points ?? this.points,
      balanceBefore: balanceBefore ?? this.balanceBefore,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      referenceType: referenceType is String?
          ? referenceType
          : this.referenceType,
      referenceId: referenceId is String? ? referenceId : this.referenceId,
      description: description is String? ? description : this.description,
      createdBy: createdBy is String? ? createdBy : this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
