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
import '../data_flow/offer_conflict_response.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class OfferMutationResult implements _i1.SerializableModel {
  OfferMutationResult._({
    required this.success,
    this.message,
    this.conflict,
    this.offerId,
  });

  factory OfferMutationResult({
    required bool success,
    String? message,
    _i2.OfferConflictResponse? conflict,
    String? offerId,
  }) = _OfferMutationResultImpl;

  factory OfferMutationResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return OfferMutationResult(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      message: jsonSerialization['message'] as String?,
      conflict: jsonSerialization['conflict'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.OfferConflictResponse>(
              jsonSerialization['conflict'],
            ),
      offerId: jsonSerialization['offerId'] as String?,
    );
  }

  bool success;

  String? message;

  _i2.OfferConflictResponse? conflict;

  String? offerId;

  /// Returns a shallow copy of this [OfferMutationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OfferMutationResult copyWith({
    bool? success,
    String? message,
    _i2.OfferConflictResponse? conflict,
    String? offerId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OfferMutationResult',
      'success': success,
      if (message != null) 'message': message,
      if (conflict != null) 'conflict': conflict?.toJson(),
      if (offerId != null) 'offerId': offerId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OfferMutationResultImpl extends OfferMutationResult {
  _OfferMutationResultImpl({
    required bool success,
    String? message,
    _i2.OfferConflictResponse? conflict,
    String? offerId,
  }) : super._(
         success: success,
         message: message,
         conflict: conflict,
         offerId: offerId,
       );

  /// Returns a shallow copy of this [OfferMutationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OfferMutationResult copyWith({
    bool? success,
    Object? message = _Undefined,
    Object? conflict = _Undefined,
    Object? offerId = _Undefined,
  }) {
    return OfferMutationResult(
      success: success ?? this.success,
      message: message is String? ? message : this.message,
      conflict: conflict is _i2.OfferConflictResponse?
          ? conflict
          : this.conflict?.copyWith(),
      offerId: offerId is String? ? offerId : this.offerId,
    );
  }
}
