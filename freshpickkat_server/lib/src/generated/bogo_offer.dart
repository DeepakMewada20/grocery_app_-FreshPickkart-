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

abstract class BogoOffer
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BogoOffer._({
    this.offerId,
    required this.triggerProductId,
    required this.freeProductIds,
    required this.offerTitle,
    required this.isActive,
    required this.createdAt,
  });

  factory BogoOffer({
    String? offerId,
    required String triggerProductId,
    required List<String> freeProductIds,
    required String offerTitle,
    required bool isActive,
    required DateTime createdAt,
  }) = _BogoOfferImpl;

  factory BogoOffer.fromJson(Map<String, dynamic> jsonSerialization) {
    return BogoOffer(
      offerId: jsonSerialization['offerId'] as String?,
      triggerProductId: jsonSerialization['triggerProductId'] as String,
      freeProductIds: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['freeProductIds'],
      ),
      offerTitle: jsonSerialization['offerTitle'] as String,
      isActive: jsonSerialization['isActive'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String? offerId;

  String triggerProductId;

  List<String> freeProductIds;

  String offerTitle;

  bool isActive;

  DateTime createdAt;

  /// Returns a shallow copy of this [BogoOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BogoOffer copyWith({
    String? offerId,
    String? triggerProductId,
    List<String>? freeProductIds,
    String? offerTitle,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BogoOffer',
      if (offerId != null) 'offerId': offerId,
      'triggerProductId': triggerProductId,
      'freeProductIds': freeProductIds.toJson(),
      'offerTitle': offerTitle,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BogoOffer',
      if (offerId != null) 'offerId': offerId,
      'triggerProductId': triggerProductId,
      'freeProductIds': freeProductIds.toJson(),
      'offerTitle': offerTitle,
      'isActive': isActive,
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
    required List<String> freeProductIds,
    required String offerTitle,
    required bool isActive,
    required DateTime createdAt,
  }) : super._(
         offerId: offerId,
         triggerProductId: triggerProductId,
         freeProductIds: freeProductIds,
         offerTitle: offerTitle,
         isActive: isActive,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [BogoOffer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BogoOffer copyWith({
    Object? offerId = _Undefined,
    String? triggerProductId,
    List<String>? freeProductIds,
    String? offerTitle,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return BogoOffer(
      offerId: offerId is String? ? offerId : this.offerId,
      triggerProductId: triggerProductId ?? this.triggerProductId,
      freeProductIds:
          freeProductIds ?? this.freeProductIds.map((e0) => e0).toList(),
      offerTitle: offerTitle ?? this.offerTitle,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
