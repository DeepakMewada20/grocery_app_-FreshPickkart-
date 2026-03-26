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

abstract class CategoryOffer
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CategoryOffer._({
    this.offerId,
    required this.name,
    this.description,
    required this.categoryId,
    this.categoryName,
    required this.discountType,
    required this.discountValue,
    this.maxDiscount,
    this.minOrderAmount,
    this.productIds,
    this.excludeProductIds,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.priority,
    required this.createdAt,
  });

  factory CategoryOffer({
    String? offerId,
    required String name,
    String? description,
    required String categoryId,
    String? categoryName,
    required String discountType,
    required double discountValue,
    double? maxDiscount,
    double? minOrderAmount,
    List<String>? productIds,
    List<String>? excludeProductIds,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    required int priority,
    required DateTime createdAt,
  }) = _CategoryOfferImpl;

  factory CategoryOffer.fromJson(Map<String, dynamic> jsonSerialization) {
    return CategoryOffer(
      offerId: jsonSerialization['offerId'] as String?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      categoryId: jsonSerialization['categoryId'] as String,
      categoryName: jsonSerialization['categoryName'] as String?,
      discountType: jsonSerialization['discountType'] as String,
      discountValue: (jsonSerialization['discountValue'] as num).toDouble(),
      maxDiscount: (jsonSerialization['maxDiscount'] as num?)?.toDouble(),
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num?)?.toDouble(),
      productIds: jsonSerialization['productIds'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['productIds'],
            ),
      excludeProductIds: jsonSerialization['excludeProductIds'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['excludeProductIds'],
            ),
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      priority: jsonSerialization['priority'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String? offerId;

  String name;

  String? description;

  String categoryId;

  String? categoryName;

  String discountType;

  double discountValue;

  double? maxDiscount;

  double? minOrderAmount;

  List<String>? productIds;

  List<String>? excludeProductIds;

  DateTime startDate;

  DateTime endDate;

  bool isActive;

  int priority;

  DateTime createdAt;

  /// Returns a shallow copy of this [CategoryOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CategoryOffer copyWith({
    String? offerId,
    String? name,
    String? description,
    String? categoryId,
    String? categoryName,
    String? discountType,
    double? discountValue,
    double? maxDiscount,
    double? minOrderAmount,
    List<String>? productIds,
    List<String>? excludeProductIds,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    int? priority,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CategoryOffer',
      if (offerId != null) 'offerId': offerId,
      'name': name,
      if (description != null) 'description': description,
      'categoryId': categoryId,
      if (categoryName != null) 'categoryName': categoryName,
      'discountType': discountType,
      'discountValue': discountValue,
      if (maxDiscount != null) 'maxDiscount': maxDiscount,
      if (minOrderAmount != null) 'minOrderAmount': minOrderAmount,
      if (productIds != null) 'productIds': productIds?.toJson(),
      if (excludeProductIds != null)
        'excludeProductIds': excludeProductIds?.toJson(),
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'isActive': isActive,
      'priority': priority,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CategoryOffer',
      if (offerId != null) 'offerId': offerId,
      'name': name,
      if (description != null) 'description': description,
      'categoryId': categoryId,
      if (categoryName != null) 'categoryName': categoryName,
      'discountType': discountType,
      'discountValue': discountValue,
      if (maxDiscount != null) 'maxDiscount': maxDiscount,
      if (minOrderAmount != null) 'minOrderAmount': minOrderAmount,
      if (productIds != null) 'productIds': productIds?.toJson(),
      if (excludeProductIds != null)
        'excludeProductIds': excludeProductIds?.toJson(),
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'isActive': isActive,
      'priority': priority,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CategoryOfferImpl extends CategoryOffer {
  _CategoryOfferImpl({
    String? offerId,
    required String name,
    String? description,
    required String categoryId,
    String? categoryName,
    required String discountType,
    required double discountValue,
    double? maxDiscount,
    double? minOrderAmount,
    List<String>? productIds,
    List<String>? excludeProductIds,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    required int priority,
    required DateTime createdAt,
  }) : super._(
         offerId: offerId,
         name: name,
         description: description,
         categoryId: categoryId,
         categoryName: categoryName,
         discountType: discountType,
         discountValue: discountValue,
         maxDiscount: maxDiscount,
         minOrderAmount: minOrderAmount,
         productIds: productIds,
         excludeProductIds: excludeProductIds,
         startDate: startDate,
         endDate: endDate,
         isActive: isActive,
         priority: priority,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CategoryOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CategoryOffer copyWith({
    Object? offerId = _Undefined,
    String? name,
    Object? description = _Undefined,
    String? categoryId,
    Object? categoryName = _Undefined,
    String? discountType,
    double? discountValue,
    Object? maxDiscount = _Undefined,
    Object? minOrderAmount = _Undefined,
    Object? productIds = _Undefined,
    Object? excludeProductIds = _Undefined,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    int? priority,
    DateTime? createdAt,
  }) {
    return CategoryOffer(
      offerId: offerId is String? ? offerId : this.offerId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName is String? ? categoryName : this.categoryName,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      maxDiscount: maxDiscount is double? ? maxDiscount : this.maxDiscount,
      minOrderAmount: minOrderAmount is double?
          ? minOrderAmount
          : this.minOrderAmount,
      productIds: productIds is List<String>?
          ? productIds
          : this.productIds?.map((e0) => e0).toList(),
      excludeProductIds: excludeProductIds is List<String>?
          ? excludeProductIds
          : this.excludeProductIds?.map((e0) => e0).toList(),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
