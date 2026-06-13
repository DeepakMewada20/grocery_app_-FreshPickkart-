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

abstract class AdminAuthResult implements _i1.SerializableModel {
  AdminAuthResult._({
    required this.ok,
    this.message,
  });

  factory AdminAuthResult({
    required bool ok,
    String? message,
  }) = _AdminAuthResultImpl;

  factory AdminAuthResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAuthResult(
      ok: _i1.BoolJsonExtension.fromJson(jsonSerialization['ok']),
      message: jsonSerialization['message'] as String?,
    );
  }

  bool ok;

  String? message;

  /// Returns a shallow copy of this [AdminAuthResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminAuthResult copyWith({
    bool? ok,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuthResult',
      'ok': ok,
      if (message != null) 'message': message,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAuthResultImpl extends AdminAuthResult {
  _AdminAuthResultImpl({
    required bool ok,
    String? message,
  }) : super._(
         ok: ok,
         message: message,
       );

  /// Returns a shallow copy of this [AdminAuthResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminAuthResult copyWith({
    bool? ok,
    Object? message = _Undefined,
  }) {
    return AdminAuthResult(
      ok: ok ?? this.ok,
      message: message is String? ? message : this.message,
    );
  }
}
