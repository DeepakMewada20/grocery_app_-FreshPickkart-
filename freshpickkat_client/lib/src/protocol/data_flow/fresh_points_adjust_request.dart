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

abstract class FreshPointsAdjustRequest implements _i1.SerializableModel {
  FreshPointsAdjustRequest._({
    required this.userId,
    required this.points,
    required this.transactionType,
    required this.description,
  });

  factory FreshPointsAdjustRequest({
    required String userId,
    required int points,
    required String transactionType,
    required String description,
  }) = _FreshPointsAdjustRequestImpl;

  factory FreshPointsAdjustRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FreshPointsAdjustRequest(
      userId: jsonSerialization['userId'] as String,
      points: jsonSerialization['points'] as int,
      transactionType: jsonSerialization['transactionType'] as String,
      description: jsonSerialization['description'] as String,
    );
  }

  String userId;

  int points;

  String transactionType;

  String description;

  /// Returns a shallow copy of this [FreshPointsAdjustRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FreshPointsAdjustRequest copyWith({
    String? userId,
    int? points,
    String? transactionType,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FreshPointsAdjustRequest',
      'userId': userId,
      'points': points,
      'transactionType': transactionType,
      'description': description,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FreshPointsAdjustRequestImpl extends FreshPointsAdjustRequest {
  _FreshPointsAdjustRequestImpl({
    required String userId,
    required int points,
    required String transactionType,
    required String description,
  }) : super._(
         userId: userId,
         points: points,
         transactionType: transactionType,
         description: description,
       );

  /// Returns a shallow copy of this [FreshPointsAdjustRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FreshPointsAdjustRequest copyWith({
    String? userId,
    int? points,
    String? transactionType,
    String? description,
  }) {
    return FreshPointsAdjustRequest(
      userId: userId ?? this.userId,
      points: points ?? this.points,
      transactionType: transactionType ?? this.transactionType,
      description: description ?? this.description,
    );
  }
}
