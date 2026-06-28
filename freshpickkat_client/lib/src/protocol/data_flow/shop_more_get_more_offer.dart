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

abstract class ShopMoreGetMoreOffer implements _i1.SerializableModel {
  ShopMoreGetMoreOffer._({
    this.offerId,
    required this.name,
    required this.minimumOrderAmount,
    required this.freeProductId,
    this.freeVariantId,
    required this.freeQuantity,
    required this.priority,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.createdBy,
    this.updatedBy,
    this.activatedBy,
    this.deactivatedBy,
    required this.createdAt,
  });

  factory ShopMoreGetMoreOffer({
    String? offerId,
    required String name,
    required double minimumOrderAmount,
    required String freeProductId,
    String? freeVariantId,
    required int freeQuantity,
    required int priority,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    String? createdBy,
    String? updatedBy,
    String? activatedBy,
    String? deactivatedBy,
    required DateTime createdAt,
  }) = _ShopMoreGetMoreOfferImpl;

  factory ShopMoreGetMoreOffer.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShopMoreGetMoreOffer(
      offerId: jsonSerialization['offerId'] as String?,
      name: jsonSerialization['name'] as String,
      minimumOrderAmount: (jsonSerialization['minimumOrderAmount'] as num)
          .toDouble(),
      freeProductId: jsonSerialization['freeProductId'] as String,
      freeVariantId: jsonSerialization['freeVariantId'] as String?,
      freeQuantity: jsonSerialization['freeQuantity'] as int,
      priority: jsonSerialization['priority'] as int,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdBy: jsonSerialization['createdBy'] as String?,
      updatedBy: jsonSerialization['updatedBy'] as String?,
      activatedBy: jsonSerialization['activatedBy'] as String?,
      deactivatedBy: jsonSerialization['deactivatedBy'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String? offerId;

  String name;

  double minimumOrderAmount;

  String freeProductId;

  String? freeVariantId;

  int freeQuantity;

  int priority;

  DateTime startDate;

  DateTime endDate;

  bool isActive;

  String? createdBy;

  String? updatedBy;

  String? activatedBy;

  String? deactivatedBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [ShopMoreGetMoreOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShopMoreGetMoreOffer copyWith({
    String? offerId,
    String? name,
    double? minimumOrderAmount,
    String? freeProductId,
    String? freeVariantId,
    int? freeQuantity,
    int? priority,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? createdBy,
    String? updatedBy,
    String? activatedBy,
    String? deactivatedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopMoreGetMoreOffer',
      if (offerId != null) 'offerId': offerId,
      'name': name,
      'minimumOrderAmount': minimumOrderAmount,
      'freeProductId': freeProductId,
      if (freeVariantId != null) 'freeVariantId': freeVariantId,
      'freeQuantity': freeQuantity,
      'priority': priority,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'isActive': isActive,
      if (createdBy != null) 'createdBy': createdBy,
      if (updatedBy != null) 'updatedBy': updatedBy,
      if (activatedBy != null) 'activatedBy': activatedBy,
      if (deactivatedBy != null) 'deactivatedBy': deactivatedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShopMoreGetMoreOfferImpl extends ShopMoreGetMoreOffer {
  _ShopMoreGetMoreOfferImpl({
    String? offerId,
    required String name,
    required double minimumOrderAmount,
    required String freeProductId,
    String? freeVariantId,
    required int freeQuantity,
    required int priority,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    String? createdBy,
    String? updatedBy,
    String? activatedBy,
    String? deactivatedBy,
    required DateTime createdAt,
  }) : super._(
         offerId: offerId,
         name: name,
         minimumOrderAmount: minimumOrderAmount,
         freeProductId: freeProductId,
         freeVariantId: freeVariantId,
         freeQuantity: freeQuantity,
         priority: priority,
         startDate: startDate,
         endDate: endDate,
         isActive: isActive,
         createdBy: createdBy,
         updatedBy: updatedBy,
         activatedBy: activatedBy,
         deactivatedBy: deactivatedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ShopMoreGetMoreOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShopMoreGetMoreOffer copyWith({
    Object? offerId = _Undefined,
    String? name,
    double? minimumOrderAmount,
    String? freeProductId,
    Object? freeVariantId = _Undefined,
    int? freeQuantity,
    int? priority,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    Object? createdBy = _Undefined,
    Object? updatedBy = _Undefined,
    Object? activatedBy = _Undefined,
    Object? deactivatedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return ShopMoreGetMoreOffer(
      offerId: offerId is String? ? offerId : this.offerId,
      name: name ?? this.name,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      freeProductId: freeProductId ?? this.freeProductId,
      freeVariantId: freeVariantId is String?
          ? freeVariantId
          : this.freeVariantId,
      freeQuantity: freeQuantity ?? this.freeQuantity,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy is String? ? createdBy : this.createdBy,
      updatedBy: updatedBy is String? ? updatedBy : this.updatedBy,
      activatedBy: activatedBy is String? ? activatedBy : this.activatedBy,
      deactivatedBy: deactivatedBy is String?
          ? deactivatedBy
          : this.deactivatedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
