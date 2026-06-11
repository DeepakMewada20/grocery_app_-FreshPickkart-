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
import 'bogo_offer.dart' as _i2;
import 'combo_offer.dart' as _i3;
import 'category_offer.dart' as _i4;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i5;

abstract class ProductFormReferenceData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ProductFormReferenceData._({
    required this.bogoOffers,
    required this.comboOffers,
    required this.categoryOffers,
  });

  factory ProductFormReferenceData({
    required List<_i2.BogoOffer> bogoOffers,
    required List<_i3.ComboOffer> comboOffers,
    required List<_i4.CategoryOffer> categoryOffers,
  }) = _ProductFormReferenceDataImpl;

  factory ProductFormReferenceData.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProductFormReferenceData(
      bogoOffers: _i5.Protocol().deserialize<List<_i2.BogoOffer>>(
        jsonSerialization['bogoOffers'],
      ),
      comboOffers: _i5.Protocol().deserialize<List<_i3.ComboOffer>>(
        jsonSerialization['comboOffers'],
      ),
      categoryOffers: _i5.Protocol().deserialize<List<_i4.CategoryOffer>>(
        jsonSerialization['categoryOffers'],
      ),
    );
  }

  List<_i2.BogoOffer> bogoOffers;

  List<_i3.ComboOffer> comboOffers;

  List<_i4.CategoryOffer> categoryOffers;

  /// Returns a shallow copy of this [ProductFormReferenceData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProductFormReferenceData copyWith({
    List<_i2.BogoOffer>? bogoOffers,
    List<_i3.ComboOffer>? comboOffers,
    List<_i4.CategoryOffer>? categoryOffers,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductFormReferenceData',
      'bogoOffers': bogoOffers.toJson(valueToJson: (v) => v.toJson()),
      'comboOffers': comboOffers.toJson(valueToJson: (v) => v.toJson()),
      'categoryOffers': categoryOffers.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductFormReferenceData',
      'bogoOffers': bogoOffers.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'comboOffers': comboOffers.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'categoryOffers': categoryOffers.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ProductFormReferenceDataImpl extends ProductFormReferenceData {
  _ProductFormReferenceDataImpl({
    required List<_i2.BogoOffer> bogoOffers,
    required List<_i3.ComboOffer> comboOffers,
    required List<_i4.CategoryOffer> categoryOffers,
  }) : super._(
         bogoOffers: bogoOffers,
         comboOffers: comboOffers,
         categoryOffers: categoryOffers,
       );

  /// Returns a shallow copy of this [ProductFormReferenceData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProductFormReferenceData copyWith({
    List<_i2.BogoOffer>? bogoOffers,
    List<_i3.ComboOffer>? comboOffers,
    List<_i4.CategoryOffer>? categoryOffers,
  }) {
    return ProductFormReferenceData(
      bogoOffers:
          bogoOffers ?? this.bogoOffers.map((e0) => e0.copyWith()).toList(),
      comboOffers:
          comboOffers ?? this.comboOffers.map((e0) => e0.copyWith()).toList(),
      categoryOffers:
          categoryOffers ??
          this.categoryOffers.map((e0) => e0.copyWith()).toList(),
    );
  }
}
