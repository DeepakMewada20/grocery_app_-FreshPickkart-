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

abstract class DeliveryRule
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DeliveryRule._({
    this.ruleId,
    required this.name,
    this.description,
    required this.deliveryFee,
    required this.sortOrder,
    this.targetUserType,
    this.targetOrderCount,
    required this.isActive,
    this.startDate,
    this.endDate,
    required this.createdAt,
  });

  factory DeliveryRule({
    String? ruleId,
    required String name,
    String? description,
    required double deliveryFee,
    required int sortOrder,
    String? targetUserType,
    int? targetOrderCount,
    required bool isActive,
    DateTime? startDate,
    DateTime? endDate,
    required DateTime createdAt,
  }) = _DeliveryRuleImpl;

  factory DeliveryRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliveryRule(
      ruleId: jsonSerialization['ruleId'] as String?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      deliveryFee: (jsonSerialization['deliveryFee'] as num).toDouble(),
      sortOrder: jsonSerialization['sortOrder'] as int,
      targetUserType: jsonSerialization['targetUserType'] as String?,
      targetOrderCount: jsonSerialization['targetOrderCount'] as int?,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      startDate: jsonSerialization['startDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String? ruleId;

  String name;

  String? description;

  double deliveryFee;

  int sortOrder;

  String? targetUserType;

  int? targetOrderCount;

  bool isActive;

  DateTime? startDate;

  DateTime? endDate;

  DateTime createdAt;

  /// Returns a shallow copy of this [DeliveryRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliveryRule copyWith({
    String? ruleId,
    String? name,
    String? description,
    double? deliveryFee,
    int? sortOrder,
    String? targetUserType,
    int? targetOrderCount,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliveryRule',
      if (ruleId != null) 'ruleId': ruleId,
      'name': name,
      if (description != null) 'description': description,
      'deliveryFee': deliveryFee,
      'sortOrder': sortOrder,
      if (targetUserType != null) 'targetUserType': targetUserType,
      if (targetOrderCount != null) 'targetOrderCount': targetOrderCount,
      'isActive': isActive,
      if (startDate != null) 'startDate': startDate?.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeliveryRule',
      if (ruleId != null) 'ruleId': ruleId,
      'name': name,
      if (description != null) 'description': description,
      'deliveryFee': deliveryFee,
      'sortOrder': sortOrder,
      if (targetUserType != null) 'targetUserType': targetUserType,
      if (targetOrderCount != null) 'targetOrderCount': targetOrderCount,
      'isActive': isActive,
      if (startDate != null) 'startDate': startDate?.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeliveryRuleImpl extends DeliveryRule {
  _DeliveryRuleImpl({
    String? ruleId,
    required String name,
    String? description,
    required double deliveryFee,
    required int sortOrder,
    String? targetUserType,
    int? targetOrderCount,
    required bool isActive,
    DateTime? startDate,
    DateTime? endDate,
    required DateTime createdAt,
  }) : super._(
         ruleId: ruleId,
         name: name,
         description: description,
         deliveryFee: deliveryFee,
         sortOrder: sortOrder,
         targetUserType: targetUserType,
         targetOrderCount: targetOrderCount,
         isActive: isActive,
         startDate: startDate,
         endDate: endDate,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [DeliveryRule]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliveryRule copyWith({
    Object? ruleId = _Undefined,
    String? name,
    Object? description = _Undefined,
    double? deliveryFee,
    int? sortOrder,
    Object? targetUserType = _Undefined,
    Object? targetOrderCount = _Undefined,
    bool? isActive,
    Object? startDate = _Undefined,
    Object? endDate = _Undefined,
    DateTime? createdAt,
  }) {
    return DeliveryRule(
      ruleId: ruleId is String? ? ruleId : this.ruleId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      sortOrder: sortOrder ?? this.sortOrder,
      targetUserType: targetUserType is String?
          ? targetUserType
          : this.targetUserType,
      targetOrderCount: targetOrderCount is int?
          ? targetOrderCount
          : this.targetOrderCount,
      isActive: isActive ?? this.isActive,
      startDate: startDate is DateTime? ? startDate : this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
