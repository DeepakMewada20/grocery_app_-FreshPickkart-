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

abstract class ReferralValidationResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReferralValidationResult._({
    required this.referrerUserId,
    required this.referrerName,
  });

  factory ReferralValidationResult({
    required String referrerUserId,
    required String referrerName,
  }) = _ReferralValidationResultImpl;

  factory ReferralValidationResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReferralValidationResult(
      referrerUserId: jsonSerialization['referrerUserId'] as String,
      referrerName: jsonSerialization['referrerName'] as String,
    );
  }

  String referrerUserId;

  String referrerName;

  /// Returns a shallow copy of this [ReferralValidationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferralValidationResult copyWith({
    String? referrerUserId,
    String? referrerName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReferralValidationResult',
      'referrerUserId': referrerUserId,
      'referrerName': referrerName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReferralValidationResult',
      'referrerUserId': referrerUserId,
      'referrerName': referrerName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ReferralValidationResultImpl extends ReferralValidationResult {
  _ReferralValidationResultImpl({
    required String referrerUserId,
    required String referrerName,
  }) : super._(
         referrerUserId: referrerUserId,
         referrerName: referrerName,
       );

  /// Returns a shallow copy of this [ReferralValidationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferralValidationResult copyWith({
    String? referrerUserId,
    String? referrerName,
  }) {
    return ReferralValidationResult(
      referrerUserId: referrerUserId ?? this.referrerUserId,
      referrerName: referrerName ?? this.referrerName,
    );
  }
}
