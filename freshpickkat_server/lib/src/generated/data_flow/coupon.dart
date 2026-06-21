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
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i2;

abstract class Coupon
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Coupon._({
    this.id,
    required this.code,
    required this.description,
    this.type,
    this.discountValue,
    required this.minOrderAmount,
    this.maxDiscount,
    this.maxDiscountAmount,
    this.productIds,
    this.loyaltyRequiredOrders,
    required this.startDate,
    required this.endDate,
    this.expiryDate,
    this.usageLimit,
    required this.usedCount,
    required this.isActive,
    required this.couponCategory,
    this.assignedUserId,
    this.assignedPhone,
  });

  factory Coupon({
    String? id,
    required String code,
    required String description,
    String? type,
    double? discountValue,
    required double minOrderAmount,
    double? maxDiscount,
    double? maxDiscountAmount,
    List<String>? productIds,
    int? loyaltyRequiredOrders,
    required DateTime startDate,
    required DateTime endDate,
    DateTime? expiryDate,
    int? usageLimit,
    required int usedCount,
    required bool isActive,
    required String couponCategory,
    String? assignedUserId,
    String? assignedPhone,
  }) = _CouponImpl;

  factory Coupon.fromJson(Map<String, dynamic> jsonSerialization) {
    return Coupon(
      id: jsonSerialization['id'] as String?,
      code: jsonSerialization['code'] as String,
      description: jsonSerialization['description'] as String,
      type: jsonSerialization['type'] as String?,
      discountValue: (jsonSerialization['discountValue'] as num?)?.toDouble(),
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num).toDouble(),
      maxDiscount: (jsonSerialization['maxDiscount'] as num?)?.toDouble(),
      maxDiscountAmount: (jsonSerialization['maxDiscountAmount'] as num?)
          ?.toDouble(),
      productIds: jsonSerialization['productIds'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['productIds'],
            ),
      loyaltyRequiredOrders: jsonSerialization['loyaltyRequiredOrders'] as int?,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      expiryDate: jsonSerialization['expiryDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiryDate']),
      usageLimit: jsonSerialization['usageLimit'] as int?,
      usedCount: jsonSerialization['usedCount'] as int,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      couponCategory: jsonSerialization['couponCategory'] as String,
      assignedUserId: jsonSerialization['assignedUserId'] as String?,
      assignedPhone: jsonSerialization['assignedPhone'] as String?,
    );
  }

  String? id;

  String code;

  String description;

  String? type;

  double? discountValue;

  double minOrderAmount;

  double? maxDiscount;

  double? maxDiscountAmount;

  List<String>? productIds;

  int? loyaltyRequiredOrders;

  DateTime startDate;

  DateTime endDate;

  DateTime? expiryDate;

  int? usageLimit;

  int usedCount;

  bool isActive;

  String couponCategory;

  String? assignedUserId;

  String? assignedPhone;

  /// Returns a shallow copy of this [Coupon]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Coupon copyWith({
    String? id,
    String? code,
    String? description,
    String? type,
    double? discountValue,
    double? minOrderAmount,
    double? maxDiscount,
    double? maxDiscountAmount,
    List<String>? productIds,
    int? loyaltyRequiredOrders,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? expiryDate,
    int? usageLimit,
    int? usedCount,
    bool? isActive,
    String? couponCategory,
    String? assignedUserId,
    String? assignedPhone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Coupon',
      if (id != null) 'id': id,
      'code': code,
      'description': description,
      if (type != null) 'type': type,
      if (discountValue != null) 'discountValue': discountValue,
      'minOrderAmount': minOrderAmount,
      if (maxDiscount != null) 'maxDiscount': maxDiscount,
      if (maxDiscountAmount != null) 'maxDiscountAmount': maxDiscountAmount,
      if (productIds != null) 'productIds': productIds?.toJson(),
      if (loyaltyRequiredOrders != null)
        'loyaltyRequiredOrders': loyaltyRequiredOrders,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      if (expiryDate != null) 'expiryDate': expiryDate?.toJson(),
      if (usageLimit != null) 'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
      'couponCategory': couponCategory,
      if (assignedUserId != null) 'assignedUserId': assignedUserId,
      if (assignedPhone != null) 'assignedPhone': assignedPhone,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Coupon',
      if (id != null) 'id': id,
      'code': code,
      'description': description,
      if (type != null) 'type': type,
      if (discountValue != null) 'discountValue': discountValue,
      'minOrderAmount': minOrderAmount,
      if (maxDiscount != null) 'maxDiscount': maxDiscount,
      if (maxDiscountAmount != null) 'maxDiscountAmount': maxDiscountAmount,
      if (productIds != null) 'productIds': productIds?.toJson(),
      if (loyaltyRequiredOrders != null)
        'loyaltyRequiredOrders': loyaltyRequiredOrders,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      if (expiryDate != null) 'expiryDate': expiryDate?.toJson(),
      if (usageLimit != null) 'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
      'couponCategory': couponCategory,
      if (assignedUserId != null) 'assignedUserId': assignedUserId,
      if (assignedPhone != null) 'assignedPhone': assignedPhone,
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
    String? id,
    required String code,
    required String description,
    String? type,
    double? discountValue,
    required double minOrderAmount,
    double? maxDiscount,
    double? maxDiscountAmount,
    List<String>? productIds,
    int? loyaltyRequiredOrders,
    required DateTime startDate,
    required DateTime endDate,
    DateTime? expiryDate,
    int? usageLimit,
    required int usedCount,
    required bool isActive,
    required String couponCategory,
    String? assignedUserId,
    String? assignedPhone,
  }) : super._(
         id: id,
         code: code,
         description: description,
         type: type,
         discountValue: discountValue,
         minOrderAmount: minOrderAmount,
         maxDiscount: maxDiscount,
         maxDiscountAmount: maxDiscountAmount,
         productIds: productIds,
         loyaltyRequiredOrders: loyaltyRequiredOrders,
         startDate: startDate,
         endDate: endDate,
         expiryDate: expiryDate,
         usageLimit: usageLimit,
         usedCount: usedCount,
         isActive: isActive,
         couponCategory: couponCategory,
         assignedUserId: assignedUserId,
         assignedPhone: assignedPhone,
       );

  /// Returns a shallow copy of this [Coupon]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Coupon copyWith({
    Object? id = _Undefined,
    String? code,
    String? description,
    Object? type = _Undefined,
    Object? discountValue = _Undefined,
    double? minOrderAmount,
    Object? maxDiscount = _Undefined,
    Object? maxDiscountAmount = _Undefined,
    Object? productIds = _Undefined,
    Object? loyaltyRequiredOrders = _Undefined,
    DateTime? startDate,
    DateTime? endDate,
    Object? expiryDate = _Undefined,
    Object? usageLimit = _Undefined,
    int? usedCount,
    bool? isActive,
    String? couponCategory,
    Object? assignedUserId = _Undefined,
    Object? assignedPhone = _Undefined,
  }) {
    return Coupon(
      id: id is String? ? id : this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      type: type is String? ? type : this.type,
      discountValue: discountValue is double?
          ? discountValue
          : this.discountValue,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxDiscount: maxDiscount is double? ? maxDiscount : this.maxDiscount,
      maxDiscountAmount: maxDiscountAmount is double?
          ? maxDiscountAmount
          : this.maxDiscountAmount,
      productIds: productIds is List<String>?
          ? productIds
          : this.productIds?.map((e0) => e0).toList(),
      loyaltyRequiredOrders: loyaltyRequiredOrders is int?
          ? loyaltyRequiredOrders
          : this.loyaltyRequiredOrders,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      expiryDate: expiryDate is DateTime? ? expiryDate : this.expiryDate,
      usageLimit: usageLimit is int? ? usageLimit : this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      isActive: isActive ?? this.isActive,
      couponCategory: couponCategory ?? this.couponCategory,
      assignedUserId: assignedUserId is String?
          ? assignedUserId
          : this.assignedUserId,
      assignedPhone: assignedPhone is String?
          ? assignedPhone
          : this.assignedPhone,
    );
  }
}
