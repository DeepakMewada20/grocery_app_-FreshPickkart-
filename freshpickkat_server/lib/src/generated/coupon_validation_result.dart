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

abstract class CouponValidationResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CouponValidationResult._({
    required this.isValid,
    this.errorMessage,
    required this.discountAmount,
    required this.isDeliveryDiscount,
  });

  factory CouponValidationResult({
    required bool isValid,
    String? errorMessage,
    required double discountAmount,
    required bool isDeliveryDiscount,
  }) = _CouponValidationResultImpl;

  factory CouponValidationResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CouponValidationResult(
      isValid: jsonSerialization['isValid'] as bool,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      discountAmount: (jsonSerialization['discountAmount'] as num).toDouble(),
      isDeliveryDiscount: jsonSerialization['isDeliveryDiscount'] as bool,
    );
  }

  bool isValid;

  String? errorMessage;

  double discountAmount;

  bool isDeliveryDiscount;

  /// Returns a shallow copy of this [CouponValidationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CouponValidationResult copyWith({
    bool? isValid,
    String? errorMessage,
    double? discountAmount,
    bool? isDeliveryDiscount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CouponValidationResult',
      'isValid': isValid,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'discountAmount': discountAmount,
      'isDeliveryDiscount': isDeliveryDiscount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CouponValidationResult',
      'isValid': isValid,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'discountAmount': discountAmount,
      'isDeliveryDiscount': isDeliveryDiscount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CouponValidationResultImpl extends CouponValidationResult {
  _CouponValidationResultImpl({
    required bool isValid,
    String? errorMessage,
    required double discountAmount,
    required bool isDeliveryDiscount,
  }) : super._(
         isValid: isValid,
         errorMessage: errorMessage,
         discountAmount: discountAmount,
         isDeliveryDiscount: isDeliveryDiscount,
       );

  /// Returns a shallow copy of this [CouponValidationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CouponValidationResult copyWith({
    bool? isValid,
    Object? errorMessage = _Undefined,
    double? discountAmount,
    bool? isDeliveryDiscount,
  }) {
    return CouponValidationResult(
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      discountAmount: discountAmount ?? this.discountAmount,
      isDeliveryDiscount: isDeliveryDiscount ?? this.isDeliveryDiscount,
    );
  }
}
