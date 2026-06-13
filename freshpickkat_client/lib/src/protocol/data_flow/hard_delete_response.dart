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

abstract class HardDeleteResponse implements _i1.SerializableModel {
  HardDeleteResponse._({
    required this.success,
    required this.action,
    required this.message,
  });

  factory HardDeleteResponse({
    required bool success,
    required String action,
    required String message,
  }) = _HardDeleteResponseImpl;

  factory HardDeleteResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return HardDeleteResponse(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      action: jsonSerialization['action'] as String,
      message: jsonSerialization['message'] as String,
    );
  }

  bool success;

  String action;

  String message;

  /// Returns a shallow copy of this [HardDeleteResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HardDeleteResponse copyWith({
    bool? success,
    String? action,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HardDeleteResponse',
      'success': success,
      'action': action,
      'message': message,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _HardDeleteResponseImpl extends HardDeleteResponse {
  _HardDeleteResponseImpl({
    required bool success,
    required String action,
    required String message,
  }) : super._(
         success: success,
         action: action,
         message: message,
       );

  /// Returns a shallow copy of this [HardDeleteResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HardDeleteResponse copyWith({
    bool? success,
    String? action,
    String? message,
  }) {
    return HardDeleteResponse(
      success: success ?? this.success,
      action: action ?? this.action,
      message: message ?? this.message,
    );
  }
}
