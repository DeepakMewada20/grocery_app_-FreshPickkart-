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
import 'product.dart' as _i2;
import 'combo_offer.dart' as _i3;
import 'bogo_offer.dart' as _i4;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i5;

abstract class OfferSearchItem
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  OfferSearchItem._({
    required this.offerType,
    this.product,
    this.comboOffer,
    this.bogoOffer,
    this.relatedProducts,
  });

  factory OfferSearchItem({
    required String offerType,
    _i2.Product? product,
    _i3.ComboOffer? comboOffer,
    _i4.BogoOffer? bogoOffer,
    List<_i2.Product>? relatedProducts,
  }) = _OfferSearchItemImpl;

  factory OfferSearchItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return OfferSearchItem(
      offerType: jsonSerialization['offerType'] as String,
      product: jsonSerialization['product'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.Product>(
              jsonSerialization['product'],
            ),
      comboOffer: jsonSerialization['comboOffer'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.ComboOffer>(
              jsonSerialization['comboOffer'],
            ),
      bogoOffer: jsonSerialization['bogoOffer'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.BogoOffer>(
              jsonSerialization['bogoOffer'],
            ),
      relatedProducts: jsonSerialization['relatedProducts'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i2.Product>>(
              jsonSerialization['relatedProducts'],
            ),
    );
  }

  String offerType;

  _i2.Product? product;

  _i3.ComboOffer? comboOffer;

  _i4.BogoOffer? bogoOffer;

  List<_i2.Product>? relatedProducts;

  /// Returns a shallow copy of this [OfferSearchItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OfferSearchItem copyWith({
    String? offerType,
    _i2.Product? product,
    _i3.ComboOffer? comboOffer,
    _i4.BogoOffer? bogoOffer,
    List<_i2.Product>? relatedProducts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OfferSearchItem',
      'offerType': offerType,
      if (product != null) 'product': product?.toJson(),
      if (comboOffer != null) 'comboOffer': comboOffer?.toJson(),
      if (bogoOffer != null) 'bogoOffer': bogoOffer?.toJson(),
      if (relatedProducts != null)
        'relatedProducts': relatedProducts?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OfferSearchItem',
      'offerType': offerType,
      if (product != null) 'product': product?.toJsonForProtocol(),
      if (comboOffer != null) 'comboOffer': comboOffer?.toJsonForProtocol(),
      if (bogoOffer != null) 'bogoOffer': bogoOffer?.toJsonForProtocol(),
      if (relatedProducts != null)
        'relatedProducts': relatedProducts?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OfferSearchItemImpl extends OfferSearchItem {
  _OfferSearchItemImpl({
    required String offerType,
    _i2.Product? product,
    _i3.ComboOffer? comboOffer,
    _i4.BogoOffer? bogoOffer,
    List<_i2.Product>? relatedProducts,
  }) : super._(
         offerType: offerType,
         product: product,
         comboOffer: comboOffer,
         bogoOffer: bogoOffer,
         relatedProducts: relatedProducts,
       );

  /// Returns a shallow copy of this [OfferSearchItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OfferSearchItem copyWith({
    String? offerType,
    Object? product = _Undefined,
    Object? comboOffer = _Undefined,
    Object? bogoOffer = _Undefined,
    Object? relatedProducts = _Undefined,
  }) {
    return OfferSearchItem(
      offerType: offerType ?? this.offerType,
      product: product is _i2.Product? ? product : this.product?.copyWith(),
      comboOffer: comboOffer is _i3.ComboOffer?
          ? comboOffer
          : this.comboOffer?.copyWith(),
      bogoOffer: bogoOffer is _i4.BogoOffer?
          ? bogoOffer
          : this.bogoOffer?.copyWith(),
      relatedProducts: relatedProducts is List<_i2.Product>?
          ? relatedProducts
          : this.relatedProducts?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
