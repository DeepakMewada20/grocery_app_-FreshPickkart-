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
import 'combo_product_item.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class ComboOffer implements _i1.SerializableModel {
  ComboOffer._({
    this.comboId,
    required this.name,
    this.description,
    required this.comboProducts,
    required this.discountType,
    required this.discountValue,
    required this.minQuantityPerProduct,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.priority,
    required this.maxUsagePerUser,
    required this.usageCount,
    this.maxTotalUsage,
    required this.createdAt,
  });

  factory ComboOffer({
    String? comboId,
    required String name,
    String? description,
    required List<_i2.ComboProductItem> comboProducts,
    required String discountType,
    required double discountValue,
    required int minQuantityPerProduct,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    required int priority,
    required int maxUsagePerUser,
    required int usageCount,
    int? maxTotalUsage,
    required DateTime createdAt,
  }) = _ComboOfferImpl;

  factory ComboOffer.fromJson(Map<String, dynamic> jsonSerialization) {
    return ComboOffer(
      comboId: jsonSerialization['comboId'] as String?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      comboProducts: _i3.Protocol().deserialize<List<_i2.ComboProductItem>>(
        jsonSerialization['comboProducts'],
      ),
      discountType: jsonSerialization['discountType'] as String,
      discountValue: (jsonSerialization['discountValue'] as num).toDouble(),
      minQuantityPerProduct: jsonSerialization['minQuantityPerProduct'] as int,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      priority: jsonSerialization['priority'] as int,
      maxUsagePerUser: jsonSerialization['maxUsagePerUser'] as int,
      usageCount: jsonSerialization['usageCount'] as int,
      maxTotalUsage: jsonSerialization['maxTotalUsage'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String? comboId;

  String name;

  String? description;

  List<_i2.ComboProductItem> comboProducts;

  String discountType;

  double discountValue;

  int minQuantityPerProduct;

  DateTime startDate;

  DateTime endDate;

  bool isActive;

  int priority;

  int maxUsagePerUser;

  int usageCount;

  int? maxTotalUsage;

  DateTime createdAt;

  /// Returns a shallow copy of this [ComboOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ComboOffer copyWith({
    String? comboId,
    String? name,
    String? description,
    List<_i2.ComboProductItem>? comboProducts,
    String? discountType,
    double? discountValue,
    int? minQuantityPerProduct,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    int? priority,
    int? maxUsagePerUser,
    int? usageCount,
    int? maxTotalUsage,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ComboOffer',
      if (comboId != null) 'comboId': comboId,
      'name': name,
      if (description != null) 'description': description,
      'comboProducts': comboProducts.toJson(valueToJson: (v) => v.toJson()),
      'discountType': discountType,
      'discountValue': discountValue,
      'minQuantityPerProduct': minQuantityPerProduct,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'isActive': isActive,
      'priority': priority,
      'maxUsagePerUser': maxUsagePerUser,
      'usageCount': usageCount,
      if (maxTotalUsage != null) 'maxTotalUsage': maxTotalUsage,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComboOfferImpl extends ComboOffer {
  _ComboOfferImpl({
    String? comboId,
    required String name,
    String? description,
    required List<_i2.ComboProductItem> comboProducts,
    required String discountType,
    required double discountValue,
    required int minQuantityPerProduct,
    required DateTime startDate,
    required DateTime endDate,
    required bool isActive,
    required int priority,
    required int maxUsagePerUser,
    required int usageCount,
    int? maxTotalUsage,
    required DateTime createdAt,
  }) : super._(
         comboId: comboId,
         name: name,
         description: description,
         comboProducts: comboProducts,
         discountType: discountType,
         discountValue: discountValue,
         minQuantityPerProduct: minQuantityPerProduct,
         startDate: startDate,
         endDate: endDate,
         isActive: isActive,
         priority: priority,
         maxUsagePerUser: maxUsagePerUser,
         usageCount: usageCount,
         maxTotalUsage: maxTotalUsage,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ComboOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ComboOffer copyWith({
    Object? comboId = _Undefined,
    String? name,
    Object? description = _Undefined,
    List<_i2.ComboProductItem>? comboProducts,
    String? discountType,
    double? discountValue,
    int? minQuantityPerProduct,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    int? priority,
    int? maxUsagePerUser,
    int? usageCount,
    Object? maxTotalUsage = _Undefined,
    DateTime? createdAt,
  }) {
    return ComboOffer(
      comboId: comboId is String? ? comboId : this.comboId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      comboProducts:
          comboProducts ??
          this.comboProducts.map((e0) => e0.copyWith()).toList(),
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      minQuantityPerProduct:
          minQuantityPerProduct ?? this.minQuantityPerProduct,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      priority: priority ?? this.priority,
      maxUsagePerUser: maxUsagePerUser ?? this.maxUsagePerUser,
      usageCount: usageCount ?? this.usageCount,
      maxTotalUsage: maxTotalUsage is int? ? maxTotalUsage : this.maxTotalUsage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
