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

abstract class NotificationPreference implements _i1.SerializableModel {
  NotificationPreference._({
    required this.trackOrderNotifications,
    required this.couponNotifications,
    required this.offerNotifications,
    required this.announcementNotifications,
    required this.importantAlerts,
    this.updatedAt,
  });

  factory NotificationPreference({
    required bool trackOrderNotifications,
    required bool couponNotifications,
    required bool offerNotifications,
    required bool announcementNotifications,
    required bool importantAlerts,
    DateTime? updatedAt,
  }) = _NotificationPreferenceImpl;

  factory NotificationPreference.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationPreference(
      trackOrderNotifications: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['trackOrderNotifications'],
      ),
      couponNotifications: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['couponNotifications'],
      ),
      offerNotifications: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['offerNotifications'],
      ),
      announcementNotifications: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['announcementNotifications'],
      ),
      importantAlerts: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['importantAlerts'],
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  bool trackOrderNotifications;

  bool couponNotifications;

  bool offerNotifications;

  bool announcementNotifications;

  bool importantAlerts;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationPreference copyWith({
    bool? trackOrderNotifications,
    bool? couponNotifications,
    bool? offerNotifications,
    bool? announcementNotifications,
    bool? importantAlerts,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationPreference',
      'trackOrderNotifications': trackOrderNotifications,
      'couponNotifications': couponNotifications,
      'offerNotifications': offerNotifications,
      'announcementNotifications': announcementNotifications,
      'importantAlerts': importantAlerts,
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationPreferenceImpl extends NotificationPreference {
  _NotificationPreferenceImpl({
    required bool trackOrderNotifications,
    required bool couponNotifications,
    required bool offerNotifications,
    required bool announcementNotifications,
    required bool importantAlerts,
    DateTime? updatedAt,
  }) : super._(
         trackOrderNotifications: trackOrderNotifications,
         couponNotifications: couponNotifications,
         offerNotifications: offerNotifications,
         announcementNotifications: announcementNotifications,
         importantAlerts: importantAlerts,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationPreference copyWith({
    bool? trackOrderNotifications,
    bool? couponNotifications,
    bool? offerNotifications,
    bool? announcementNotifications,
    bool? importantAlerts,
    Object? updatedAt = _Undefined,
  }) {
    return NotificationPreference(
      trackOrderNotifications:
          trackOrderNotifications ?? this.trackOrderNotifications,
      couponNotifications: couponNotifications ?? this.couponNotifications,
      offerNotifications: offerNotifications ?? this.offerNotifications,
      announcementNotifications:
          announcementNotifications ?? this.announcementNotifications,
      importantAlerts: importantAlerts ?? this.importantAlerts,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
