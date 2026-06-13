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
import '../data_flow/bogo_free_product.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class BogoOffer implements _i1.SerializableModel {
  BogoOffer._({
    this.offerId,
    required this.triggerProductId,
    this.triggerVariantId,
    this.minTriggerQuantity,
    this.triggerBaseQuantity,
    this.triggerBaseUnit,
    required this.freeProductIds,
    this.freeProducts,
    required this.offerTitle,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  factory BogoOffer({
    String? offerId,
    required String triggerProductId,
    String? triggerVariantId,
    int? minTriggerQuantity,
    double? triggerBaseQuantity,
    String? triggerBaseUnit,
    required List<String> freeProductIds,
    List<_i2.BogoFreeProduct>? freeProducts,
    required String offerTitle,
    required bool isActive,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime createdAt,
  }) = _BogoOfferImpl;

  factory BogoOffer.fromJson(Map<String, dynamic> jsonSerialization) {
    return BogoOffer(
      offerId: jsonSerialization['offerId'] as String?,
      triggerProductId: jsonSerialization['triggerProductId'] as String,
      triggerVariantId: jsonSerialization['triggerVariantId'] as String?,
      minTriggerQuantity: jsonSerialization['minTriggerQuantity'] as int?,
      triggerBaseQuantity: (jsonSerialization['triggerBaseQuantity'] as num?)
          ?.toDouble(),
      triggerBaseUnit: jsonSerialization['triggerBaseUnit'] as String?,
      freeProductIds: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['freeProductIds'],
      ),
      freeProducts: jsonSerialization['freeProducts'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.BogoFreeProduct>>(
              jsonSerialization['freeProducts'],
            ),
      offerTitle: jsonSerialization['offerTitle'] as String,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String? offerId;

  String triggerProductId;

  String? triggerVariantId;

  int? minTriggerQuantity;

  double? triggerBaseQuantity;

  String? triggerBaseUnit;

  List<String> freeProductIds;

  List<_i2.BogoFreeProduct>? freeProducts;

  String offerTitle;

  bool isActive;

  DateTime startDate;

  DateTime endDate;

  DateTime createdAt;

  /// Returns a shallow copy of this [BogoOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BogoOffer copyWith({
    String? offerId,
    String? triggerProductId,
    String? triggerVariantId,
    int? minTriggerQuantity,
    double? triggerBaseQuantity,
    String? triggerBaseUnit,
    List<String>? freeProductIds,
    List<_i2.BogoFreeProduct>? freeProducts,
    String? offerTitle,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BogoOffer',
      if (offerId != null) 'offerId': offerId,
      'triggerProductId': triggerProductId,
      if (triggerVariantId != null) 'triggerVariantId': triggerVariantId,
      if (minTriggerQuantity != null) 'minTriggerQuantity': minTriggerQuantity,
      if (triggerBaseQuantity != null)
        'triggerBaseQuantity': triggerBaseQuantity,
      if (triggerBaseUnit != null) 'triggerBaseUnit': triggerBaseUnit,
      'freeProductIds': freeProductIds.toJson(),
      if (freeProducts != null)
        'freeProducts': freeProducts?.toJson(valueToJson: (v) => v.toJson()),
      'offerTitle': offerTitle,
      'isActive': isActive,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BogoOfferImpl extends BogoOffer {
  _BogoOfferImpl({
    String? offerId,
    required String triggerProductId,
    String? triggerVariantId,
    int? minTriggerQuantity,
    double? triggerBaseQuantity,
    String? triggerBaseUnit,
    required List<String> freeProductIds,
    List<_i2.BogoFreeProduct>? freeProducts,
    required String offerTitle,
    required bool isActive,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime createdAt,
  }) : super._(
         offerId: offerId,
         triggerProductId: triggerProductId,
         triggerVariantId: triggerVariantId,
         minTriggerQuantity: minTriggerQuantity,
         triggerBaseQuantity: triggerBaseQuantity,
         triggerBaseUnit: triggerBaseUnit,
         freeProductIds: freeProductIds,
         freeProducts: freeProducts,
         offerTitle: offerTitle,
         isActive: isActive,
         startDate: startDate,
         endDate: endDate,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [BogoOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BogoOffer copyWith({
    Object? offerId = _Undefined,
    String? triggerProductId,
    Object? triggerVariantId = _Undefined,
    Object? minTriggerQuantity = _Undefined,
    Object? triggerBaseQuantity = _Undefined,
    Object? triggerBaseUnit = _Undefined,
    List<String>? freeProductIds,
    Object? freeProducts = _Undefined,
    String? offerTitle,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
  }) {
    return BogoOffer(
      offerId: offerId is String? ? offerId : this.offerId,
      triggerProductId: triggerProductId ?? this.triggerProductId,
      triggerVariantId: triggerVariantId is String?
          ? triggerVariantId
          : this.triggerVariantId,
      minTriggerQuantity: minTriggerQuantity is int?
          ? minTriggerQuantity
          : this.minTriggerQuantity,
      triggerBaseQuantity: triggerBaseQuantity is double?
          ? triggerBaseQuantity
          : this.triggerBaseQuantity,
      triggerBaseUnit: triggerBaseUnit is String?
          ? triggerBaseUnit
          : this.triggerBaseUnit,
      freeProductIds:
          freeProductIds ?? this.freeProductIds.map((e0) => e0).toList(),
      freeProducts: freeProducts is List<_i2.BogoFreeProduct>?
          ? freeProducts
          : this.freeProducts?.map((e0) => e0.copyWith()).toList(),
      offerTitle: offerTitle ?? this.offerTitle,
      isActive: isActive ?? this.isActive,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
