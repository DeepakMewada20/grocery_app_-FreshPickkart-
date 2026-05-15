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
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i2;

abstract class NotificationDraft
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  NotificationDraft._({
    required this.enabled,
    required this.title,
    required this.body,
    required this.type,
    required this.topic,
    this.imageUrl,
    required this.targetAudience,
    this.entityType,
    this.entityId,
    this.data,
  });

  factory NotificationDraft({
    required bool enabled,
    required String title,
    required String body,
    required String type,
    required String topic,
    String? imageUrl,
    required String targetAudience,
    String? entityType,
    String? entityId,
    Map<String, String>? data,
  }) = _NotificationDraftImpl;

  factory NotificationDraft.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotificationDraft(
      enabled: _i1.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      type: jsonSerialization['type'] as String,
      topic: jsonSerialization['topic'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      targetAudience: jsonSerialization['targetAudience'] as String,
      entityType: jsonSerialization['entityType'] as String?,
      entityId: jsonSerialization['entityId'] as String?,
      data: jsonSerialization['data'] == null
          ? null
          : _i2.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['data'],
            ),
    );
  }

  bool enabled;

  String title;

  String body;

  String type;

  String topic;

  String? imageUrl;

  String targetAudience;

  String? entityType;

  String? entityId;

  Map<String, String>? data;

  /// Returns a shallow copy of this [NotificationDraft]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationDraft copyWith({
    bool? enabled,
    String? title,
    String? body,
    String? type,
    String? topic,
    String? imageUrl,
    String? targetAudience,
    String? entityType,
    String? entityId,
    Map<String, String>? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationDraft',
      'enabled': enabled,
      'title': title,
      'body': body,
      'type': type,
      'topic': topic,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'targetAudience': targetAudience,
      if (entityType != null) 'entityType': entityType,
      if (entityId != null) 'entityId': entityId,
      if (data != null) 'data': data?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationDraft',
      'enabled': enabled,
      'title': title,
      'body': body,
      'type': type,
      'topic': topic,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'targetAudience': targetAudience,
      if (entityType != null) 'entityType': entityType,
      if (entityId != null) 'entityId': entityId,
      if (data != null) 'data': data?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationDraftImpl extends NotificationDraft {
  _NotificationDraftImpl({
    required bool enabled,
    required String title,
    required String body,
    required String type,
    required String topic,
    String? imageUrl,
    required String targetAudience,
    String? entityType,
    String? entityId,
    Map<String, String>? data,
  }) : super._(
         enabled: enabled,
         title: title,
         body: body,
         type: type,
         topic: topic,
         imageUrl: imageUrl,
         targetAudience: targetAudience,
         entityType: entityType,
         entityId: entityId,
         data: data,
       );

  /// Returns a shallow copy of this [NotificationDraft]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationDraft copyWith({
    bool? enabled,
    String? title,
    String? body,
    String? type,
    String? topic,
    Object? imageUrl = _Undefined,
    String? targetAudience,
    Object? entityType = _Undefined,
    Object? entityId = _Undefined,
    Object? data = _Undefined,
  }) {
    return NotificationDraft(
      enabled: enabled ?? this.enabled,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      topic: topic ?? this.topic,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      targetAudience: targetAudience ?? this.targetAudience,
      entityType: entityType is String? ? entityType : this.entityType,
      entityId: entityId is String? ? entityId : this.entityId,
      data: data is Map<String, String>?
          ? data
          : this.data?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
    );
  }
}
