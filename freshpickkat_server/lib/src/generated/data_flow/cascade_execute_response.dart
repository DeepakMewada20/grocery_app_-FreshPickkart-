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

abstract class CascadeExecuteResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CascadeExecuteResponse._({
    required this.success,
    required this.action,
    required this.deactivatedCount,
    required this.protectedCount,
    required this.message,
  });

  factory CascadeExecuteResponse({
    required bool success,
    required String action,
    required int deactivatedCount,
    required int protectedCount,
    required String message,
  }) = _CascadeExecuteResponseImpl;

  factory CascadeExecuteResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CascadeExecuteResponse(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      action: jsonSerialization['action'] as String,
      deactivatedCount: jsonSerialization['deactivatedCount'] as int,
      protectedCount: jsonSerialization['protectedCount'] as int,
      message: jsonSerialization['message'] as String,
    );
  }

  bool success;

  String action;

  int deactivatedCount;

  int protectedCount;

  String message;

  /// Returns a shallow copy of this [CascadeExecuteResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CascadeExecuteResponse copyWith({
    bool? success,
    String? action,
    int? deactivatedCount,
    int? protectedCount,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CascadeExecuteResponse',
      'success': success,
      'action': action,
      'deactivatedCount': deactivatedCount,
      'protectedCount': protectedCount,
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CascadeExecuteResponse',
      'success': success,
      'action': action,
      'deactivatedCount': deactivatedCount,
      'protectedCount': protectedCount,
      'message': message,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CascadeExecuteResponseImpl extends CascadeExecuteResponse {
  _CascadeExecuteResponseImpl({
    required bool success,
    required String action,
    required int deactivatedCount,
    required int protectedCount,
    required String message,
  }) : super._(
         success: success,
         action: action,
         deactivatedCount: deactivatedCount,
         protectedCount: protectedCount,
         message: message,
       );

  /// Returns a shallow copy of this [CascadeExecuteResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CascadeExecuteResponse copyWith({
    bool? success,
    String? action,
    int? deactivatedCount,
    int? protectedCount,
    String? message,
  }) {
    return CascadeExecuteResponse(
      success: success ?? this.success,
      action: action ?? this.action,
      deactivatedCount: deactivatedCount ?? this.deactivatedCount,
      protectedCount: protectedCount ?? this.protectedCount,
      message: message ?? this.message,
    );
  }
}
