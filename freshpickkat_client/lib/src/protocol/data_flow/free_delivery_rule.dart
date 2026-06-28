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

abstract class FreeDeliveryRule implements _i1.SerializableModel {
  FreeDeliveryRule._({
    this.ruleId,
    required this.name,
    this.description,
    required this.ruleType,
    this.minOrderAmount,
    this.minItemsCount,
    this.couponCode,
    this.userId,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.deliveryFeeWaived,
    required this.createdAt,
  });

  factory FreeDeliveryRule({
    String? ruleId,
    required String name,
    String? description,
    required String ruleType,
    double? minOrderAmount,
    int? minItemsCount,
    String? couponCode,
    String? userId,
    required bool isActive,
    DateTime? startDate,
    DateTime? endDate,
    required double deliveryFeeWaived,
    required DateTime createdAt,
  }) = _FreeDeliveryRuleImpl;

  factory FreeDeliveryRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return FreeDeliveryRule(
      ruleId: jsonSerialization['ruleId'] as String?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      ruleType: jsonSerialization['ruleType'] as String,
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num?)?.toDouble(),
      minItemsCount: jsonSerialization['minItemsCount'] as int?,
      couponCode: jsonSerialization['couponCode'] as String?,
      userId: jsonSerialization['userId'] as String?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      startDate: jsonSerialization['startDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      deliveryFeeWaived: (jsonSerialization['deliveryFeeWaived'] as num)
          .toDouble(),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String? ruleId;

  String name;

  String? description;

  String ruleType;

  double? minOrderAmount;

  int? minItemsCount;

  String? couponCode;

  String? userId;

  bool isActive;

  DateTime? startDate;

  DateTime? endDate;

  double deliveryFeeWaived;

  DateTime createdAt;

  /// Returns a shallow copy of this [FreeDeliveryRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FreeDeliveryRule copyWith({
    String? ruleId,
    String? name,
    String? description,
    String? ruleType,
    double? minOrderAmount,
    int? minItemsCount,
    String? couponCode,
    String? userId,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    double? deliveryFeeWaived,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FreeDeliveryRule',
      if (ruleId != null) 'ruleId': ruleId,
      'name': name,
      if (description != null) 'description': description,
      'ruleType': ruleType,
      if (minOrderAmount != null) 'minOrderAmount': minOrderAmount,
      if (minItemsCount != null) 'minItemsCount': minItemsCount,
      if (couponCode != null) 'couponCode': couponCode,
      if (userId != null) 'userId': userId,
      'isActive': isActive,
      if (startDate != null) 'startDate': startDate?.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'deliveryFeeWaived': deliveryFeeWaived,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FreeDeliveryRuleImpl extends FreeDeliveryRule {
  _FreeDeliveryRuleImpl({
    String? ruleId,
    required String name,
    String? description,
    required String ruleType,
    double? minOrderAmount,
    int? minItemsCount,
    String? couponCode,
    String? userId,
    required bool isActive,
    DateTime? startDate,
    DateTime? endDate,
    required double deliveryFeeWaived,
    required DateTime createdAt,
  }) : super._(
         ruleId: ruleId,
         name: name,
         description: description,
         ruleType: ruleType,
         minOrderAmount: minOrderAmount,
         minItemsCount: minItemsCount,
         couponCode: couponCode,
         userId: userId,
         isActive: isActive,
         startDate: startDate,
         endDate: endDate,
         deliveryFeeWaived: deliveryFeeWaived,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [FreeDeliveryRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FreeDeliveryRule copyWith({
    Object? ruleId = _Undefined,
    String? name,
    Object? description = _Undefined,
    String? ruleType,
    Object? minOrderAmount = _Undefined,
    Object? minItemsCount = _Undefined,
    Object? couponCode = _Undefined,
    Object? userId = _Undefined,
    bool? isActive,
    Object? startDate = _Undefined,
    Object? endDate = _Undefined,
    double? deliveryFeeWaived,
    DateTime? createdAt,
  }) {
    return FreeDeliveryRule(
      ruleId: ruleId is String? ? ruleId : this.ruleId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      ruleType: ruleType ?? this.ruleType,
      minOrderAmount: minOrderAmount is double?
          ? minOrderAmount
          : this.minOrderAmount,
      minItemsCount: minItemsCount is int? ? minItemsCount : this.minItemsCount,
      couponCode: couponCode is String? ? couponCode : this.couponCode,
      userId: userId is String? ? userId : this.userId,
      isActive: isActive ?? this.isActive,
      startDate: startDate is DateTime? ? startDate : this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      deliveryFeeWaived: deliveryFeeWaived ?? this.deliveryFeeWaived,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
