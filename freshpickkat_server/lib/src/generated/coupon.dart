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

abstract class Coupon
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Coupon._({
    required this.code,
    required this.description,
    this.discountType,
    this.discountValue,
    required this.minOrderAmount,
    this.maxDiscount,
    required this.startDate,
    required this.endDate,
    this.usageLimit,
    required this.usedCount,
    required this.isActive,
    required this.couponCategory,
  });

  factory Coupon({
    required String code,
    required String description,
    String? discountType,
    double? discountValue,
    required double minOrderAmount,
    double? maxDiscount,
    required DateTime startDate,
    required DateTime endDate,
    int? usageLimit,
    required int usedCount,
    required bool isActive,
    required String couponCategory,
  }) = _CouponImpl;

  factory Coupon.fromJson(Map<String, dynamic> jsonSerialization) {
    return Coupon(
      code: jsonSerialization['code'] as String,
      description: jsonSerialization['description'] as String,
      discountType: jsonSerialization['discountType'] as String?,
      discountValue: (jsonSerialization['discountValue'] as num?)?.toDouble(),
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num).toDouble(),
      maxDiscount: (jsonSerialization['maxDiscount'] as num?)?.toDouble(),
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      usageLimit: jsonSerialization['usageLimit'] as int?,
      usedCount: jsonSerialization['usedCount'] as int,
      isActive: jsonSerialization['isActive'] as bool,
      couponCategory: jsonSerialization['couponCategory'] as String,
    );
  }

  String code;

  String description;

  String? discountType;

  double? discountValue;

  double minOrderAmount;

  double? maxDiscount;

  DateTime startDate;

  DateTime endDate;

  int? usageLimit;

  int usedCount;

  bool isActive;

  String couponCategory;

  /// Returns a shallow copy of this [Coupon]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Coupon copyWith({
    String? code,
    String? description,
    String? discountType,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscount,
    DateTime? startDate,
    DateTime? endDate,
    int? usageLimit,
    int? usedCount,
    bool? isActive,
    String? couponCategory,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Coupon',
      'code': code,
      'description': description,
      if (discountType != null) 'discountType': discountType,
      if (discountValue != null) 'discountValue': discountValue,
      'minOrderAmount': minOrderAmount,
      if (maxDiscount != null) 'maxDiscount': maxDiscount,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      if (usageLimit != null) 'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
      'couponCategory': couponCategory,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Coupon',
      'code': code,
      'description': description,
      if (discountType != null) 'discountType': discountType,
      if (discountValue != null) 'discountValue': discountValue,
      'minOrderAmount': minOrderAmount,
      if (maxDiscount != null) 'maxDiscount': maxDiscount,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      if (usageLimit != null) 'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
      'couponCategory': couponCategory,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CouponImpl extends Coupon {
  _CouponImpl({
    required String code,
    required String description,
    String? discountType,
    double? discountValue,
    required double minOrderAmount,
    double? maxDiscount,
    required DateTime startDate,
    required DateTime endDate,
    int? usageLimit,
    required int usedCount,
    required bool isActive,
    required String couponCategory,
  }) : super._(
         code: code,
         description: description,
         discountType: discountType,
         discountValue: discountValue,
         minOrderAmount: minOrderAmount,
         maxDiscount: maxDiscount,
         startDate: startDate,
         endDate: endDate,
         usageLimit: usageLimit,
         usedCount: usedCount,
         isActive: isActive,
         couponCategory: couponCategory,
       );

  /// Returns a shallow copy of this [Coupon]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Coupon copyWith({
    String? code,
    String? description,
    Object? discountType = _Undefined,
    Object? discountValue = _Undefined,
    double? minOrderAmount,
    Object? maxDiscount = _Undefined,
    DateTime? startDate,
    DateTime? endDate,
    Object? usageLimit = _Undefined,
    int? usedCount,
    bool? isActive,
    String? couponCategory,
  }) {
    return Coupon(
      code: code ?? this.code,
      description: description ?? this.description,
      discountType: discountType is String? ? discountType : this.discountType,
      discountValue: discountValue is double?
          ? discountValue
          : this.discountValue,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxDiscount: maxDiscount is double? ? maxDiscount : this.maxDiscount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      usageLimit: usageLimit is int? ? usageLimit : this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      isActive: isActive ?? this.isActive,
      couponCategory: couponCategory ?? this.couponCategory,
    );
  }
}
