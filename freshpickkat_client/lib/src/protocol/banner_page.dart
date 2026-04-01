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
import 'banner.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class BannerPage implements _i1.SerializableModel {
  BannerPage._({
    required this.banners,
    this.nextPageToken,
    required this.totalCount,
  });

  factory BannerPage({
    required List<_i2.Banner> banners,
    String? nextPageToken,
    required int totalCount,
  }) = _BannerPageImpl;

  factory BannerPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return BannerPage(
      banners: _i3.Protocol().deserialize<List<_i2.Banner>>(
        jsonSerialization['banners'],
      ),
      nextPageToken: jsonSerialization['nextPageToken'] as String?,
      totalCount: jsonSerialization['totalCount'] as int,
    );
  }

  List<_i2.Banner> banners;

  String? nextPageToken;

  int totalCount;

  /// Returns a shallow copy of this [BannerPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BannerPage copyWith({
    List<_i2.Banner>? banners,
    String? nextPageToken,
    int? totalCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BannerPage',
      'banners': banners.toJson(valueToJson: (v) => v.toJson()),
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

class _BannerPageImpl extends BannerPage {
  _BannerPageImpl({
    required List<_i2.Banner> banners,
    String? nextPageToken,
    required int totalCount,
  }) : super._(
         banners: banners,
         nextPageToken: nextPageToken,
         totalCount: totalCount,
       );

  /// Returns a shallow copy of this [BannerPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BannerPage copyWith({
    List<_i2.Banner>? banners,
    Object? nextPageToken = _Undefined,
    int? totalCount,
  }) {
    return BannerPage(
      banners: banners ?? this.banners.map((e0) => e0.copyWith()).toList(),
      nextPageToken: nextPageToken is String?
          ? nextPageToken
          : this.nextPageToken,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
