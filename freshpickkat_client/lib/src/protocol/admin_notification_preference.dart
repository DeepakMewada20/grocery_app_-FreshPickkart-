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

abstract class AdminNotificationPreference implements _i1.SerializableModel {
  AdminNotificationPreference._({
    required this.key,
    required this.title,
    required this.group,
    required this.pushEnabled,
    required this.soundEnabled,
    required this.critical,
    this.updatedAt,
  });

  factory AdminNotificationPreference({
    required String key,
    required String title,
    required String group,
    required bool pushEnabled,
    required bool soundEnabled,
    required bool critical,
    DateTime? updatedAt,
  }) = _AdminNotificationPreferenceImpl;

  factory AdminNotificationPreference.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminNotificationPreference(
      key: jsonSerialization['key'] as String,
      title: jsonSerialization['title'] as String,
      group: jsonSerialization['group'] as String,
      pushEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['pushEnabled'],
      ),
      soundEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['soundEnabled'],
      ),
      critical: _i1.BoolJsonExtension.fromJson(jsonSerialization['critical']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  String key;

  String title;

  String group;

  bool pushEnabled;

  bool soundEnabled;

  bool critical;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [AdminNotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminNotificationPreference copyWith({
    String? key,
    String? title,
    String? group,
    bool? pushEnabled,
    bool? soundEnabled,
    bool? critical,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminNotificationPreference',
      'key': key,
      'title': title,
      'group': group,
      'pushEnabled': pushEnabled,
      'soundEnabled': soundEnabled,
      'critical': critical,
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminNotificationPreferenceImpl extends AdminNotificationPreference {
  _AdminNotificationPreferenceImpl({
    required String key,
    required String title,
    required String group,
    required bool pushEnabled,
    required bool soundEnabled,
    required bool critical,
    DateTime? updatedAt,
  }) : super._(
         key: key,
         title: title,
         group: group,
         pushEnabled: pushEnabled,
         soundEnabled: soundEnabled,
         critical: critical,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [AdminNotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminNotificationPreference copyWith({
    String? key,
    String? title,
    String? group,
    bool? pushEnabled,
    bool? soundEnabled,
    bool? critical,
    Object? updatedAt = _Undefined,
  }) {
    return AdminNotificationPreference(
      key: key ?? this.key,
      title: title ?? this.title,
      group: group ?? this.group,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      critical: critical ?? this.critical,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
