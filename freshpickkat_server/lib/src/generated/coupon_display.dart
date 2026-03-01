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

abstract class CouponDisplay
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CouponDisplay._({
    required this.code,
    required this.description,
    required this.couponCategory,
    required this.minOrderAmount,
    this.maxDiscount,
    this.discountValue,
    this.discountType,
    required this.isDeliveryDiscount,
    required this.isApplicable,
  });

  factory CouponDisplay({
    required String code,
    required String description,
    required String couponCategory,
    required double minOrderAmount,
    double? maxDiscount,
    double? discountValue,
    String? discountType,
    required bool isDeliveryDiscount,
    required bool isApplicable,
  }) = _CouponDisplayImpl;

  factory CouponDisplay.fromJson(Map<String, dynamic> jsonSerialization) {
    return CouponDisplay(
      code: jsonSerialization['code'] as String,
      description: jsonSerialization['description'] as String,
      couponCategory: jsonSerialization['couponCategory'] as String,
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num).toDouble(),
      maxDiscount: (jsonSerialization['maxDiscount'] as num?)?.toDouble(),
      discountValue: (jsonSerialization['discountValue'] as num?)?.toDouble(),
      discountType: jsonSerialization['discountType'] as String?,
      isDeliveryDiscount: jsonSerialization['isDeliveryDiscount'] as bool,
      isApplicable: jsonSerialization['isApplicable'] as bool,
    );
  }

  String code;

  String description;

  String couponCategory;

  double minOrderAmount;

  double? maxDiscount;

  double? discountValue;

  String? discountType;

  bool isDeliveryDiscount;

  bool isApplicable;

  /// Returns a shallow copy of this [CouponDisplay]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CouponDisplay copyWith({
    String? code,
    String? description,
    String? couponCategory,
    double? minOrderAmount,
    double? maxDiscount,
    double? discountValue,
    String? discountType,
    bool? isDeliveryDiscount,
    bool? isApplicable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CouponDisplay',
      'code': code,
      'description': description,
      'couponCategory': couponCategory,
      'minOrderAmount': minOrderAmount,
      if (maxDiscount != null) 'maxDiscount': maxDiscount,
      if (discountValue != null) 'discountValue': discountValue,
      if (discountType != null) 'discountType': discountType,
      'isDeliveryDiscount': isDeliveryDiscount,
      'isApplicable': isApplicable,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CouponDisplay',
      'code': code,
      'description': description,
      'couponCategory': couponCategory,
      'minOrderAmount': minOrderAmount,
      if (maxDiscount != null) 'maxDiscount': maxDiscount,
      if (discountValue != null) 'discountValue': discountValue,
      if (discountType != null) 'discountType': discountType,
      'isDeliveryDiscount': isDeliveryDiscount,
      'isApplicable': isApplicable,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CouponDisplayImpl extends CouponDisplay {
  _CouponDisplayImpl({
    required String code,
    required String description,
    required String couponCategory,
    required double minOrderAmount,
    double? maxDiscount,
    double? discountValue,
    String? discountType,
    required bool isDeliveryDiscount,
    required bool isApplicable,
  }) : super._(
         code: code,
         description: description,
         couponCategory: couponCategory,
         minOrderAmount: minOrderAmount,
         maxDiscount: maxDiscount,
         discountValue: discountValue,
         discountType: discountType,
         isDeliveryDiscount: isDeliveryDiscount,
         isApplicable: isApplicable,
       );

  /// Returns a shallow copy of this [CouponDisplay]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CouponDisplay copyWith({
    String? code,
    String? description,
    String? couponCategory,
    double? minOrderAmount,
    Object? maxDiscount = _Undefined,
    Object? discountValue = _Undefined,
    Object? discountType = _Undefined,
    bool? isDeliveryDiscount,
    bool? isApplicable,
  }) {
    return CouponDisplay(
      code: code ?? this.code,
      description: description ?? this.description,
      couponCategory: couponCategory ?? this.couponCategory,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxDiscount: maxDiscount is double? ? maxDiscount : this.maxDiscount,
      discountValue: discountValue is double?
          ? discountValue
          : this.discountValue,
      discountType: discountType is String? ? discountType : this.discountType,
      isDeliveryDiscount: isDeliveryDiscount ?? this.isDeliveryDiscount,
      isApplicable: isApplicable ?? this.isApplicable,
    );
  }
}
