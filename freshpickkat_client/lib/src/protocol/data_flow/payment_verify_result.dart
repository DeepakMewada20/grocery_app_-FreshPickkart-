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

abstract class PaymentVerifyResult implements _i1.SerializableModel {
  PaymentVerifyResult._({
    required this.success,
    required this.verified,
    this.message,
    this.error,
  });

  factory PaymentVerifyResult({
    required bool success,
    required bool verified,
    String? message,
    String? error,
  }) = _PaymentVerifyResultImpl;

  factory PaymentVerifyResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentVerifyResult(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      verified: _i1.BoolJsonExtension.fromJson(jsonSerialization['verified']),
      message: jsonSerialization['message'] as String?,
      error: jsonSerialization['error'] as String?,
    );
  }

  bool success;

  bool verified;

  String? message;

  String? error;

  /// Returns a shallow copy of this [PaymentVerifyResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentVerifyResult copyWith({
    bool? success,
    bool? verified,
    String? message,
    String? error,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentVerifyResult',
      'success': success,
      'verified': verified,
      if (message != null) 'message': message,
      if (error != null) 'error': error,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PaymentVerifyResultImpl extends PaymentVerifyResult {
  _PaymentVerifyResultImpl({
    required bool success,
    required bool verified,
    String? message,
    String? error,
  }) : super._(
         success: success,
         verified: verified,
         message: message,
         error: error,
       );

  /// Returns a shallow copy of this [PaymentVerifyResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentVerifyResult copyWith({
    bool? success,
    bool? verified,
    Object? message = _Undefined,
    Object? error = _Undefined,
  }) {
    return PaymentVerifyResult(
      success: success ?? this.success,
      verified: verified ?? this.verified,
      message: message is String? ? message : this.message,
      error: error is String? ? error : this.error,
    );
  }
}
