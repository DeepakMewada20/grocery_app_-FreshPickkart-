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

abstract class ApiResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ApiResponse._({
    required this.success,
    required this.message,
  });

  factory ApiResponse({
    required bool success,
    required String message,
  }) = _ApiResponseImpl;

  factory ApiResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiResponse(
      success: _i1.BoolJsonExtension.fromJson(jsonSerialization['success']),
      message: jsonSerialization['message'] as String,
    );
  }

  bool success;

  String message;

  /// Returns a shallow copy of this [ApiResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiResponse copyWith({
    bool? success,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiResponse',
      'success': success,
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiResponse',
      'success': success,
      'message': message,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ApiResponseImpl extends ApiResponse {
  _ApiResponseImpl({
    required bool success,
    required String message,
  }) : super._(
         success: success,
         message: message,
       );

  /// Returns a shallow copy of this [ApiResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiResponse copyWith({
    bool? success,
    String? message,
  }) {
    return ApiResponse(
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }
}
