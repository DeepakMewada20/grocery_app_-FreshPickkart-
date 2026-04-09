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

abstract class CouponValidationResult implements _i1.SerializableModel {
  CouponValidationResult._({
    required this.isValid,
    this.couponCode,
    this.couponId,
    this.couponType,
    this.errorMessage,
    required this.discountAmount,
    required this.isDeliveryDiscount,
  });

  factory CouponValidationResult({
    required bool isValid,
    String? couponCode,
    String? couponId,
    String? couponType,
    String? errorMessage,
    required double discountAmount,
    required bool isDeliveryDiscount,
  }) = _CouponValidationResultImpl;

  factory CouponValidationResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CouponValidationResult(
      isValid: _i1.BoolJsonExtension.fromJson(jsonSerialization['isValid']),
      couponCode: jsonSerialization['couponCode'] as String?,
      couponId: jsonSerialization['couponId'] as String?,
      couponType: jsonSerialization['couponType'] as String?,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      discountAmount: (jsonSerialization['discountAmount'] as num).toDouble(),
      isDeliveryDiscount: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isDeliveryDiscount'],
      ),
    );
  }

  bool isValid;

  String? couponCode;

  String? couponId;

  String? couponType;

  String? errorMessage;

  double discountAmount;

  bool isDeliveryDiscount;

  /// Returns a shallow copy of this [CouponValidationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CouponValidationResult copyWith({
    bool? isValid,
    String? couponCode,
    String? couponId,
    String? couponType,
    String? errorMessage,
    double? discountAmount,
    bool? isDeliveryDiscount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CouponValidationResult',
      'isValid': isValid,
      if (couponCode != null) 'couponCode': couponCode,
      if (couponId != null) 'couponId': couponId,
      if (couponType != null) 'couponType': couponType,
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
    String? couponCode,
    String? couponId,
    String? couponType,
    String? errorMessage,
    required double discountAmount,
    required bool isDeliveryDiscount,
  }) : super._(
         isValid: isValid,
         couponCode: couponCode,
         couponId: couponId,
         couponType: couponType,
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
    Object? couponCode = _Undefined,
    Object? couponId = _Undefined,
    Object? couponType = _Undefined,
    Object? errorMessage = _Undefined,
    double? discountAmount,
    bool? isDeliveryDiscount,
  }) {
    return CouponValidationResult(
      isValid: isValid ?? this.isValid,
      couponCode: couponCode is String? ? couponCode : this.couponCode,
      couponId: couponId is String? ? couponId : this.couponId,
      couponType: couponType is String? ? couponType : this.couponType,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      discountAmount: discountAmount ?? this.discountAmount,
      isDeliveryDiscount: isDeliveryDiscount ?? this.isDeliveryDiscount,
    );
  }
}
