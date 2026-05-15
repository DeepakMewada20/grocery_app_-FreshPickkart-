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
import 'notification_history_item.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class NotificationHistoryPage implements _i1.SerializableModel {
  NotificationHistoryPage._({
    required this.items,
    this.nextPageToken,
    required this.unreadCount,
  });

  factory NotificationHistoryPage({
    required List<_i2.NotificationHistoryItem> items,
    String? nextPageToken,
    required int unreadCount,
  }) = _NotificationHistoryPageImpl;

  factory NotificationHistoryPage.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationHistoryPage(
      items: _i3.Protocol().deserialize<List<_i2.NotificationHistoryItem>>(
        jsonSerialization['items'],
      ),
      nextPageToken: jsonSerialization['nextPageToken'] as String?,
      unreadCount: jsonSerialization['unreadCount'] as int,
    );
  }

  List<_i2.NotificationHistoryItem> items;

  String? nextPageToken;

  int unreadCount;

  /// Returns a shallow copy of this [NotificationHistoryPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationHistoryPage copyWith({
    List<_i2.NotificationHistoryItem>? items,
    String? nextPageToken,
    int? unreadCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationHistoryPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      if (nextPageToken != null) 'nextPageToken': nextPageToken,
      'unreadCount': unreadCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationHistoryPageImpl extends NotificationHistoryPage {
  _NotificationHistoryPageImpl({
    required List<_i2.NotificationHistoryItem> items,
    String? nextPageToken,
    required int unreadCount,
  }) : super._(
         items: items,
         nextPageToken: nextPageToken,
         unreadCount: unreadCount,
       );

  /// Returns a shallow copy of this [NotificationHistoryPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationHistoryPage copyWith({
    List<_i2.NotificationHistoryItem>? items,
    Object? nextPageToken = _Undefined,
    int? unreadCount,
  }) {
    return NotificationHistoryPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      nextPageToken: nextPageToken is String?
          ? nextPageToken
          : this.nextPageToken,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
