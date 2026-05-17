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
import 'broadcast_summary.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class BroadcastPage implements _i1.SerializableModel {
  BroadcastPage._({
    required this.items,
    this.nextPageToken,
    required this.totalCount,
  });

  factory BroadcastPage({
    required List<_i2.BroadcastSummary> items,
    String? nextPageToken,
    required int totalCount,
  }) = _BroadcastPageImpl;

  factory BroadcastPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return BroadcastPage(
      items: _i3.Protocol().deserialize<List<_i2.BroadcastSummary>>(
        jsonSerialization['items'],
      ),
      nextPageToken: jsonSerialization['nextPageToken'] as String?,
      totalCount: jsonSerialization['totalCount'] as int,
    );
  }

  List<_i2.BroadcastSummary> items;

  String? nextPageToken;

  int totalCount;

  /// Returns a shallow copy of this [BroadcastPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BroadcastPage copyWith({
    List<_i2.BroadcastSummary>? items,
    String? nextPageToken,
    int? totalCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BroadcastPage',
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

class _BroadcastPageImpl extends BroadcastPage {
  _BroadcastPageImpl({
    required List<_i2.BroadcastSummary> items,
    String? nextPageToken,
    required int totalCount,
  }) : super._(
         items: items,
         nextPageToken: nextPageToken,
         totalCount: totalCount,
       );

  /// Returns a shallow copy of this [BroadcastPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BroadcastPage copyWith({
    List<_i2.BroadcastSummary>? items,
    Object? nextPageToken = _Undefined,
    int? totalCount,
  }) {
    return BroadcastPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      nextPageToken: nextPageToken is String?
          ? nextPageToken
          : this.nextPageToken,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
