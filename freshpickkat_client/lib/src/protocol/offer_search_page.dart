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
import 'offer_search_item.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class OfferSearchPage implements _i1.SerializableModel {
  OfferSearchPage._({
    required this.items,
    this.nextPageToken,
    required this.totalCount,
  });

  factory OfferSearchPage({
    required List<_i2.OfferSearchItem> items,
    String? nextPageToken,
    required int totalCount,
  }) = _OfferSearchPageImpl;

  factory OfferSearchPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return OfferSearchPage(
      items: _i3.Protocol().deserialize<List<_i2.OfferSearchItem>>(
        jsonSerialization['items'],
      ),
      nextPageToken: jsonSerialization['nextPageToken'] as String?,
      totalCount: jsonSerialization['totalCount'] as int,
    );
  }

  List<_i2.OfferSearchItem> items;

  String? nextPageToken;

  int totalCount;

  /// Returns a shallow copy of this [OfferSearchPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OfferSearchPage copyWith({
    List<_i2.OfferSearchItem>? items,
    String? nextPageToken,
    int? totalCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OfferSearchPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
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

class _OfferSearchPageImpl extends OfferSearchPage {
  _OfferSearchPageImpl({
    required List<_i2.OfferSearchItem> items,
    String? nextPageToken,
    required int totalCount,
  }) : super._(
         items: items,
         nextPageToken: nextPageToken,
         totalCount: totalCount,
       );

  /// Returns a shallow copy of this [OfferSearchPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OfferSearchPage copyWith({
    List<_i2.OfferSearchItem>? items,
    Object? nextPageToken = _Undefined,
    int? totalCount,
  }) {
    return OfferSearchPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      nextPageToken: nextPageToken is String?
          ? nextPageToken
          : this.nextPageToken,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
