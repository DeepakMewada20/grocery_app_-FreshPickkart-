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

abstract class Banner
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Banner._({
    this.bannerId,
    required this.title,
    required this.imageUrl,
    required this.type,
    this.offerId,
    this.categoryId,
    this.productId,
    this.comboId,
    this.couponCode,
    this.externalUrl,
    required this.screenPlacements,
    required this.priority,
    this.startDate,
    this.endDate,
    required this.active,
    required this.isBaseImage,
    this.linkedProductIds,
    required this.createdAt,
    this.updatedAt,
  });

  factory Banner({
    String? bannerId,
    required String title,
    required String imageUrl,
    required String type,
    String? offerId,
    String? categoryId,
    String? productId,
    String? comboId,
    String? couponCode,
    String? externalUrl,
    required String screenPlacements,
    required int priority,
    DateTime? startDate,
    DateTime? endDate,
    required bool active,
    required bool isBaseImage,
    List<String>? linkedProductIds,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _BannerImpl;

  factory Banner.fromJson(Map<String, dynamic> jsonSerialization) {
    return Banner(
      bannerId: jsonSerialization['bannerId'] as String?,
      title: jsonSerialization['title'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String,
      type: jsonSerialization['type'] as String,
      offerId: jsonSerialization['offerId'] as String?,
      categoryId: jsonSerialization['categoryId'] as String?,
      productId: jsonSerialization['productId'] as String?,
      comboId: jsonSerialization['comboId'] as String?,
      couponCode: jsonSerialization['couponCode'] as String?,
      externalUrl: jsonSerialization['externalUrl'] as String?,
      screenPlacements: jsonSerialization['screenPlacements'] as String,
      priority: jsonSerialization['priority'] as int,
      startDate: jsonSerialization['startDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      active: _i1.BoolJsonExtension.fromJson(jsonSerialization['active']),
      isBaseImage: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isBaseImage'],
      ),
      linkedProductIds: jsonSerialization['linkedProductIds'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['linkedProductIds'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  String? bannerId;

  String title;

  String imageUrl;

  String type;

  String? offerId;

  String? categoryId;

  String? productId;

  String? comboId;

  String? couponCode;

  String? externalUrl;

  String screenPlacements;

  int priority;

  DateTime? startDate;

  DateTime? endDate;

  bool active;

  bool isBaseImage;

  List<String>? linkedProductIds;

  DateTime createdAt;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [Banner]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Banner copyWith({
    String? bannerId,
    String? title,
    String? imageUrl,
    String? type,
    String? offerId,
    String? categoryId,
    String? productId,
    String? comboId,
    String? couponCode,
    String? externalUrl,
    String? screenPlacements,
    int? priority,
    DateTime? startDate,
    DateTime? endDate,
    bool? active,
    bool? isBaseImage,
    List<String>? linkedProductIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Banner',
      if (bannerId != null) 'bannerId': bannerId,
      'title': title,
      'imageUrl': imageUrl,
      'type': type,
      if (offerId != null) 'offerId': offerId,
      if (categoryId != null) 'categoryId': categoryId,
      if (productId != null) 'productId': productId,
      if (comboId != null) 'comboId': comboId,
      if (couponCode != null) 'couponCode': couponCode,
      if (externalUrl != null) 'externalUrl': externalUrl,
      'screenPlacements': screenPlacements,
      'priority': priority,
      if (startDate != null) 'startDate': startDate?.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'active': active,
      'isBaseImage': isBaseImage,
      if (linkedProductIds != null)
        'linkedProductIds': linkedProductIds?.toJson(),
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Banner',
      if (bannerId != null) 'bannerId': bannerId,
      'title': title,
      'imageUrl': imageUrl,
      'type': type,
      if (offerId != null) 'offerId': offerId,
      if (categoryId != null) 'categoryId': categoryId,
      if (productId != null) 'productId': productId,
      if (comboId != null) 'comboId': comboId,
      if (couponCode != null) 'couponCode': couponCode,
      if (externalUrl != null) 'externalUrl': externalUrl,
      'screenPlacements': screenPlacements,
      'priority': priority,
      if (startDate != null) 'startDate': startDate?.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
      'active': active,
      'isBaseImage': isBaseImage,
      if (linkedProductIds != null)
        'linkedProductIds': linkedProductIds?.toJson(),
      'createdAt': createdAt.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BannerImpl extends Banner {
  _BannerImpl({
    String? bannerId,
    required String title,
    required String imageUrl,
    required String type,
    String? offerId,
    String? categoryId,
    String? productId,
    String? comboId,
    String? couponCode,
    String? externalUrl,
    required String screenPlacements,
    required int priority,
    DateTime? startDate,
    DateTime? endDate,
    required bool active,
    required bool isBaseImage,
    List<String>? linkedProductIds,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super._(
         bannerId: bannerId,
         title: title,
         imageUrl: imageUrl,
         type: type,
         offerId: offerId,
         categoryId: categoryId,
         productId: productId,
         comboId: comboId,
         couponCode: couponCode,
         externalUrl: externalUrl,
         screenPlacements: screenPlacements,
         priority: priority,
         startDate: startDate,
         endDate: endDate,
         active: active,
         isBaseImage: isBaseImage,
         linkedProductIds: linkedProductIds,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Banner]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Banner copyWith({
    Object? bannerId = _Undefined,
    String? title,
    String? imageUrl,
    String? type,
    Object? offerId = _Undefined,
    Object? categoryId = _Undefined,
    Object? productId = _Undefined,
    Object? comboId = _Undefined,
    Object? couponCode = _Undefined,
    Object? externalUrl = _Undefined,
    String? screenPlacements,
    int? priority,
    Object? startDate = _Undefined,
    Object? endDate = _Undefined,
    bool? active,
    bool? isBaseImage,
    Object? linkedProductIds = _Undefined,
    DateTime? createdAt,
    Object? updatedAt = _Undefined,
  }) {
    return Banner(
      bannerId: bannerId is String? ? bannerId : this.bannerId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      offerId: offerId is String? ? offerId : this.offerId,
      categoryId: categoryId is String? ? categoryId : this.categoryId,
      productId: productId is String? ? productId : this.productId,
      comboId: comboId is String? ? comboId : this.comboId,
      couponCode: couponCode is String? ? couponCode : this.couponCode,
      externalUrl: externalUrl is String? ? externalUrl : this.externalUrl,
      screenPlacements: screenPlacements ?? this.screenPlacements,
      priority: priority ?? this.priority,
      startDate: startDate is DateTime? ? startDate : this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
      active: active ?? this.active,
      isBaseImage: isBaseImage ?? this.isBaseImage,
      linkedProductIds: linkedProductIds is List<String>?
          ? linkedProductIds
          : this.linkedProductIds?.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
