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
    this.id,
    required this.code,
    required this.description,
    this.type,
    required this.couponCategory,
    required this.minOrderAmount,
    this.maxDiscount,
    this.maxDiscountAmount,
    this.discountValue,
    this.discountType,
    required this.isDeliveryDiscount,
    required this.isApplicable,
    this.status,
    this.reason,
    this.discountAmount,
    required this.isBest,
  });

  factory CouponDisplay({
    String? id,
    required String code,
    required String description,
    String? type,
    required String couponCategory,
    required double minOrderAmount,
    double? maxDiscount,
    double? maxDiscountAmount,
    double? discountValue,
    String? discountType,
    required bool isDeliveryDiscount,
    required bool isApplicable,
    String? status,
    String? reason,
    double? discountAmount,
    required bool isBest,
  }) = _CouponDisplayImpl;

  factory CouponDisplay.fromJson(Map<String, dynamic> jsonSerialization) {
    return CouponDisplay(
      id: jsonSerialization['id'] as String?,
      code: jsonSerialization['code'] as String,
      description: jsonSerialization['description'] as String,
      type: jsonSerialization['type'] as String?,
      couponCategory: jsonSerialization['couponCategory'] as String,
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num).toDouble(),
      maxDiscount: (jsonSerialization['maxDiscount'] as num?)?.toDouble(),
      maxDiscountAmount: (jsonSerialization['maxDiscountAmount'] as num?)
          ?.toDouble(),
      discountValue: (jsonSerialization['discountValue'] as num?)?.toDouble(),
      discountType: jsonSerialization['discountType'] as String?,
      isDeliveryDiscount: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isDeliveryDiscount'],
      ),
      isApplicable: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isApplicable'],
      ),
      status: jsonSerialization['status'] as String?,
      reason: jsonSerialization['reason'] as String?,
      discountAmount: (jsonSerialization['discountAmount'] as num?)?.toDouble(),
      isBest: _i1.BoolJsonExtension.fromJson(jsonSerialization['isBest']),
    );
  }

  String? id;

  String code;

  String description;

  String? type;

  String couponCategory;

  double minOrderAmount;

  double? maxDiscount;

  double? maxDiscountAmount;

  double? discountValue;

  String? discountType;

  bool isDeliveryDiscount;

  bool isApplicable;

  String? status;

  String? reason;

  double? discountAmount;

  bool isBest;

  /// Returns a shallow copy of this [CouponDisplay]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CouponDisplay copyWith({
    String? id,
    String? code,
    String? description,
    String? type,
    String? couponCategory,
    double? minOrderAmount,
    double? maxDiscount,
    double? maxDiscountAmount,
    double? discountValue,
    String? discountType,
    bool? isDeliveryDiscount,
    bool? isApplicable,
    String? status,
    String? reason,
    double? discountAmount,
    bool? isBest,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CouponDisplay',
      if (id != null) 'id': id,
      'code': code,
      'description': description,
      if (type != null) 'type': type,
      'couponCategory': couponCategory,
      'minOrderAmount': minOrderAmount,
      if (maxDiscount != null) 'maxDiscount': maxDiscount,
      if (maxDiscountAmount != null) 'maxDiscountAmount': maxDiscountAmount,
      if (discountValue != null) 'discountValue': discountValue,
      if (discountType != null) 'discountType': discountType,
      'isDeliveryDiscount': isDeliveryDiscount,
      'isApplicable': isApplicable,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (discountAmount != null) 'discountAmount': discountAmount,
      'isBest': isBest,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CouponDisplay',
      if (id != null) 'id': id,
      'code': code,
      'description': description,
      if (type != null) 'type': type,
      'couponCategory': couponCategory,
      'minOrderAmount': minOrderAmount,
      if (maxDiscount != null) 'maxDiscount': maxDiscount,
      if (maxDiscountAmount != null) 'maxDiscountAmount': maxDiscountAmount,
      if (discountValue != null) 'discountValue': discountValue,
      if (discountType != null) 'discountType': discountType,
      'isDeliveryDiscount': isDeliveryDiscount,
      'isApplicable': isApplicable,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (discountAmount != null) 'discountAmount': discountAmount,
      'isBest': isBest,
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
    String? id,
    required String code,
    required String description,
    String? type,
    required String couponCategory,
    required double minOrderAmount,
    double? maxDiscount,
    double? maxDiscountAmount,
    double? discountValue,
    String? discountType,
    required bool isDeliveryDiscount,
    required bool isApplicable,
    String? status,
    String? reason,
    double? discountAmount,
    required bool isBest,
  }) : super._(
         id: id,
         code: code,
         description: description,
         type: type,
         couponCategory: couponCategory,
         minOrderAmount: minOrderAmount,
         maxDiscount: maxDiscount,
         maxDiscountAmount: maxDiscountAmount,
         discountValue: discountValue,
         discountType: discountType,
         isDeliveryDiscount: isDeliveryDiscount,
         isApplicable: isApplicable,
         status: status,
         reason: reason,
         discountAmount: discountAmount,
         isBest: isBest,
       );

  /// Returns a shallow copy of this [CouponDisplay]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CouponDisplay copyWith({
    Object? id = _Undefined,
    String? code,
    String? description,
    Object? type = _Undefined,
    String? couponCategory,
    double? minOrderAmount,
    Object? maxDiscount = _Undefined,
    Object? maxDiscountAmount = _Undefined,
    Object? discountValue = _Undefined,
    Object? discountType = _Undefined,
    bool? isDeliveryDiscount,
    bool? isApplicable,
    Object? status = _Undefined,
    Object? reason = _Undefined,
    Object? discountAmount = _Undefined,
    bool? isBest,
  }) {
    return CouponDisplay(
      id: id is String? ? id : this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      type: type is String? ? type : this.type,
      couponCategory: couponCategory ?? this.couponCategory,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxDiscount: maxDiscount is double? ? maxDiscount : this.maxDiscount,
      maxDiscountAmount: maxDiscountAmount is double?
          ? maxDiscountAmount
          : this.maxDiscountAmount,
      discountValue: discountValue is double?
          ? discountValue
          : this.discountValue,
      discountType: discountType is String? ? discountType : this.discountType,
      isDeliveryDiscount: isDeliveryDiscount ?? this.isDeliveryDiscount,
      isApplicable: isApplicable ?? this.isApplicable,
      status: status is String? ? status : this.status,
      reason: reason is String? ? reason : this.reason,
      discountAmount: discountAmount is double?
          ? discountAmount
          : this.discountAmount,
      isBest: isBest ?? this.isBest,
    );
  }
}
