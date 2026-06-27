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
import '../data_flow/shop_more_get_more_offer.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class ShopMoreGetMoreOfferPage implements _i1.SerializableModel {
  ShopMoreGetMoreOfferPage._({
    required this.offers,
    this.nextPageToken,
    required this.totalCount,
  });

  factory ShopMoreGetMoreOfferPage({
    required List<_i2.ShopMoreGetMoreOffer> offers,
    String? nextPageToken,
    required int totalCount,
  }) = _ShopMoreGetMoreOfferPageImpl;

  factory ShopMoreGetMoreOfferPage.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ShopMoreGetMoreOfferPage(
      offers: _i3.Protocol().deserialize<List<_i2.ShopMoreGetMoreOffer>>(
        jsonSerialization['offers'],
      ),
      nextPageToken: jsonSerialization['nextPageToken'] as String?,
      totalCount: jsonSerialization['totalCount'] as int,
    );
  }

  List<_i2.ShopMoreGetMoreOffer> offers;

  String? nextPageToken;

  int totalCount;

  /// Returns a shallow copy of this [ShopMoreGetMoreOfferPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShopMoreGetMoreOfferPage copyWith({
    List<_i2.ShopMoreGetMoreOffer>? offers,
    String? nextPageToken,
    int? totalCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopMoreGetMoreOfferPage',
      'offers': offers.toJson(valueToJson: (v) => v.toJson()),
      if (nextPageToken != null) 'nextPageToken': nextPageToken,
      'totalCount': totalCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShopMoreGetMoreOfferPageImpl extends ShopMoreGetMoreOfferPage {
  _ShopMoreGetMoreOfferPageImpl({
    required List<_i2.ShopMoreGetMoreOffer> offers,
    String? nextPageToken,
    required int totalCount,
  }) : super._(
         offers: offers,
         nextPageToken: nextPageToken,
         totalCount: totalCount,
       );

  /// Returns a shallow copy of this [ShopMoreGetMoreOfferPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShopMoreGetMoreOfferPage copyWith({
    List<_i2.ShopMoreGetMoreOffer>? offers,
    Object? nextPageToken = _Undefined,
    int? totalCount,
  }) {
    return ShopMoreGetMoreOfferPage(
      offers: offers ?? this.offers.map((e0) => e0.copyWith()).toList(),
      nextPageToken: nextPageToken is String?
          ? nextPageToken
          : this.nextPageToken,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
