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
import 'combo_offer.dart' as _i2;
import 'bogo_offer.dart' as _i3;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i4;

abstract class OfferConflictResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  OfferConflictResponse._({
    required this.hasConflict,
    this.conflictType,
    this.message,
    required this.productIds,
    required this.productNames,
    this.comboOffer,
    this.bogoOffer,
  });

  factory OfferConflictResponse({
    required bool hasConflict,
    String? conflictType,
    String? message,
    required List<String> productIds,
    required List<String> productNames,
    _i2.ComboOffer? comboOffer,
    _i3.BogoOffer? bogoOffer,
  }) = _OfferConflictResponseImpl;

  factory OfferConflictResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return OfferConflictResponse(
      hasConflict: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['hasConflict'],
      ),
      conflictType: jsonSerialization['conflictType'] as String?,
      message: jsonSerialization['message'] as String?,
      productIds: _i4.Protocol().deserialize<List<String>>(
        jsonSerialization['productIds'],
      ),
      productNames: _i4.Protocol().deserialize<List<String>>(
        jsonSerialization['productNames'],
      ),
      comboOffer: jsonSerialization['comboOffer'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.ComboOffer>(
              jsonSerialization['comboOffer'],
            ),
      bogoOffer: jsonSerialization['bogoOffer'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.BogoOffer>(
              jsonSerialization['bogoOffer'],
            ),
    );
  }

  bool hasConflict;

  String? conflictType;

  String? message;

  List<String> productIds;

  List<String> productNames;

  _i2.ComboOffer? comboOffer;

  _i3.BogoOffer? bogoOffer;

  /// Returns a shallow copy of this [OfferConflictResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OfferConflictResponse copyWith({
    bool? hasConflict,
    String? conflictType,
    String? message,
    List<String>? productIds,
    List<String>? productNames,
    _i2.ComboOffer? comboOffer,
    _i3.BogoOffer? bogoOffer,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OfferConflictResponse',
      'hasConflict': hasConflict,
      if (conflictType != null) 'conflictType': conflictType,
      if (message != null) 'message': message,
      'productIds': productIds.toJson(),
      'productNames': productNames.toJson(),
      if (comboOffer != null) 'comboOffer': comboOffer?.toJson(),
      if (bogoOffer != null) 'bogoOffer': bogoOffer?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OfferConflictResponse',
      'hasConflict': hasConflict,
      if (conflictType != null) 'conflictType': conflictType,
      if (message != null) 'message': message,
      'productIds': productIds.toJson(),
      'productNames': productNames.toJson(),
      if (comboOffer != null) 'comboOffer': comboOffer?.toJsonForProtocol(),
      if (bogoOffer != null) 'bogoOffer': bogoOffer?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OfferConflictResponseImpl extends OfferConflictResponse {
  _OfferConflictResponseImpl({
    required bool hasConflict,
    String? conflictType,
    String? message,
    required List<String> productIds,
    required List<String> productNames,
    _i2.ComboOffer? comboOffer,
    _i3.BogoOffer? bogoOffer,
  }) : super._(
         hasConflict: hasConflict,
         conflictType: conflictType,
         message: message,
         productIds: productIds,
         productNames: productNames,
         comboOffer: comboOffer,
         bogoOffer: bogoOffer,
       );

  /// Returns a shallow copy of this [OfferConflictResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OfferConflictResponse copyWith({
    bool? hasConflict,
    Object? conflictType = _Undefined,
    Object? message = _Undefined,
    List<String>? productIds,
    List<String>? productNames,
    Object? comboOffer = _Undefined,
    Object? bogoOffer = _Undefined,
  }) {
    return OfferConflictResponse(
      hasConflict: hasConflict ?? this.hasConflict,
      conflictType: conflictType is String? ? conflictType : this.conflictType,
      message: message is String? ? message : this.message,
      productIds: productIds ?? this.productIds.map((e0) => e0).toList(),
      productNames: productNames ?? this.productNames.map((e0) => e0).toList(),
      comboOffer: comboOffer is _i2.ComboOffer?
          ? comboOffer
          : this.comboOffer?.copyWith(),
      bogoOffer: bogoOffer is _i3.BogoOffer?
          ? bogoOffer
          : this.bogoOffer?.copyWith(),
    );
  }
}
