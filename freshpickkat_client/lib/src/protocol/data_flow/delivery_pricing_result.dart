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

abstract class DeliveryPricingResult implements _i1.SerializableModel {
  DeliveryPricingResult._({
    required this.deliveryFee,
    required this.isFree,
    this.message,
    this.remainingAmount,
    this.progressPercent,
    this.deliverySource,
    this.appliedRuleId,
    this.appliedRuleType,
    this.appliedRuleName,
    this.freeDeliveryProductId,
    this.freeDeliveryProductName,
    required this.baseDeliveryFee,
  });

  factory DeliveryPricingResult({
    required double deliveryFee,
    required bool isFree,
    String? message,
    double? remainingAmount,
    double? progressPercent,
    String? deliverySource,
    String? appliedRuleId,
    String? appliedRuleType,
    String? appliedRuleName,
    String? freeDeliveryProductId,
    String? freeDeliveryProductName,
    required double baseDeliveryFee,
  }) = _DeliveryPricingResultImpl;

  factory DeliveryPricingResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeliveryPricingResult(
      deliveryFee: (jsonSerialization['deliveryFee'] as num).toDouble(),
      isFree: _i1.BoolJsonExtension.fromJson(jsonSerialization['isFree']),
      message: jsonSerialization['message'] as String?,
      remainingAmount: (jsonSerialization['remainingAmount'] as num?)
          ?.toDouble(),
      progressPercent: (jsonSerialization['progressPercent'] as num?)
          ?.toDouble(),
      deliverySource: jsonSerialization['deliverySource'] as String?,
      appliedRuleId: jsonSerialization['appliedRuleId'] as String?,
      appliedRuleType: jsonSerialization['appliedRuleType'] as String?,
      appliedRuleName: jsonSerialization['appliedRuleName'] as String?,
      freeDeliveryProductId:
          jsonSerialization['freeDeliveryProductId'] as String?,
      freeDeliveryProductName:
          jsonSerialization['freeDeliveryProductName'] as String?,
      baseDeliveryFee: (jsonSerialization['baseDeliveryFee'] as num).toDouble(),
    );
  }

  double deliveryFee;

  bool isFree;

  String? message;

  double? remainingAmount;

  double? progressPercent;

  String? deliverySource;

  String? appliedRuleId;

  String? appliedRuleType;

  String? appliedRuleName;

  String? freeDeliveryProductId;

  String? freeDeliveryProductName;

  double baseDeliveryFee;

  /// Returns a shallow copy of this [DeliveryPricingResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliveryPricingResult copyWith({
    double? deliveryFee,
    bool? isFree,
    String? message,
    double? remainingAmount,
    double? progressPercent,
    String? deliverySource,
    String? appliedRuleId,
    String? appliedRuleType,
    String? appliedRuleName,
    String? freeDeliveryProductId,
    String? freeDeliveryProductName,
    double? baseDeliveryFee,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliveryPricingResult',
      'deliveryFee': deliveryFee,
      'isFree': isFree,
      if (message != null) 'message': message,
      if (remainingAmount != null) 'remainingAmount': remainingAmount,
      if (progressPercent != null) 'progressPercent': progressPercent,
      if (deliverySource != null) 'deliverySource': deliverySource,
      if (appliedRuleId != null) 'appliedRuleId': appliedRuleId,
      if (appliedRuleType != null) 'appliedRuleType': appliedRuleType,
      if (appliedRuleName != null) 'appliedRuleName': appliedRuleName,
      if (freeDeliveryProductId != null)
        'freeDeliveryProductId': freeDeliveryProductId,
      if (freeDeliveryProductName != null)
        'freeDeliveryProductName': freeDeliveryProductName,
      'baseDeliveryFee': baseDeliveryFee,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeliveryPricingResultImpl extends DeliveryPricingResult {
  _DeliveryPricingResultImpl({
    required double deliveryFee,
    required bool isFree,
    String? message,
    double? remainingAmount,
    double? progressPercent,
    String? deliverySource,
    String? appliedRuleId,
    String? appliedRuleType,
    String? appliedRuleName,
    String? freeDeliveryProductId,
    String? freeDeliveryProductName,
    required double baseDeliveryFee,
  }) : super._(
         deliveryFee: deliveryFee,
         isFree: isFree,
         message: message,
         remainingAmount: remainingAmount,
         progressPercent: progressPercent,
         deliverySource: deliverySource,
         appliedRuleId: appliedRuleId,
         appliedRuleType: appliedRuleType,
         appliedRuleName: appliedRuleName,
         freeDeliveryProductId: freeDeliveryProductId,
         freeDeliveryProductName: freeDeliveryProductName,
         baseDeliveryFee: baseDeliveryFee,
       );

  /// Returns a shallow copy of this [DeliveryPricingResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliveryPricingResult copyWith({
    double? deliveryFee,
    bool? isFree,
    Object? message = _Undefined,
    Object? remainingAmount = _Undefined,
    Object? progressPercent = _Undefined,
    Object? deliverySource = _Undefined,
    Object? appliedRuleId = _Undefined,
    Object? appliedRuleType = _Undefined,
    Object? appliedRuleName = _Undefined,
    Object? freeDeliveryProductId = _Undefined,
    Object? freeDeliveryProductName = _Undefined,
    double? baseDeliveryFee,
  }) {
    return DeliveryPricingResult(
      deliveryFee: deliveryFee ?? this.deliveryFee,
      isFree: isFree ?? this.isFree,
      message: message is String? ? message : this.message,
      remainingAmount: remainingAmount is double?
          ? remainingAmount
          : this.remainingAmount,
      progressPercent: progressPercent is double?
          ? progressPercent
          : this.progressPercent,
      deliverySource: deliverySource is String?
          ? deliverySource
          : this.deliverySource,
      appliedRuleId: appliedRuleId is String?
          ? appliedRuleId
          : this.appliedRuleId,
      appliedRuleType: appliedRuleType is String?
          ? appliedRuleType
          : this.appliedRuleType,
      appliedRuleName: appliedRuleName is String?
          ? appliedRuleName
          : this.appliedRuleName,
      freeDeliveryProductId: freeDeliveryProductId is String?
          ? freeDeliveryProductId
          : this.freeDeliveryProductId,
      freeDeliveryProductName: freeDeliveryProductName is String?
          ? freeDeliveryProductName
          : this.freeDeliveryProductName,
      baseDeliveryFee: baseDeliveryFee ?? this.baseDeliveryFee,
    );
  }
}
