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
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i2;

abstract class BroadcastRequest implements _i1.SerializableModel {
  BroadcastRequest._({
    required this.title,
    required this.body,
    this.imageUrl,
    required this.announcementType,
    required this.targetAudience,
    required this.priority,
    this.scheduledAt,
    this.couponCode,
    this.city,
    this.affectedArea,
    this.urgency,
    this.entityType,
    this.entityId,
    this.data,
  });

  factory BroadcastRequest({
    required String title,
    required String body,
    String? imageUrl,
    required String announcementType,
    required String targetAudience,
    required String priority,
    DateTime? scheduledAt,
    String? couponCode,
    String? city,
    String? affectedArea,
    String? urgency,
    String? entityType,
    String? entityId,
    Map<String, String>? data,
  }) = _BroadcastRequestImpl;

  factory BroadcastRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return BroadcastRequest(
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      announcementType: jsonSerialization['announcementType'] as String,
      targetAudience: jsonSerialization['targetAudience'] as String,
      priority: jsonSerialization['priority'] as String,
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
      couponCode: jsonSerialization['couponCode'] as String?,
      city: jsonSerialization['city'] as String?,
      affectedArea: jsonSerialization['affectedArea'] as String?,
      urgency: jsonSerialization['urgency'] as String?,
      entityType: jsonSerialization['entityType'] as String?,
      entityId: jsonSerialization['entityId'] as String?,
      data: jsonSerialization['data'] == null
          ? null
          : _i2.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['data'],
            ),
    );
  }

  String title;

  String body;

  String? imageUrl;

  String announcementType;

  String targetAudience;

  String priority;

  DateTime? scheduledAt;

  String? couponCode;

  String? city;

  String? affectedArea;

  String? urgency;

  String? entityType;

  String? entityId;

  Map<String, String>? data;

  /// Returns a shallow copy of this [BroadcastRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BroadcastRequest copyWith({
    String? title,
    String? body,
    String? imageUrl,
    String? announcementType,
    String? targetAudience,
    String? priority,
    DateTime? scheduledAt,
    String? couponCode,
    String? city,
    String? affectedArea,
    String? urgency,
    String? entityType,
    String? entityId,
    Map<String, String>? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BroadcastRequest',
      'title': title,
      'body': body,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'announcementType': announcementType,
      'targetAudience': targetAudience,
      'priority': priority,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (couponCode != null) 'couponCode': couponCode,
      if (city != null) 'city': city,
      if (affectedArea != null) 'affectedArea': affectedArea,
      if (urgency != null) 'urgency': urgency,
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

class _BroadcastRequestImpl extends BroadcastRequest {
  _BroadcastRequestImpl({
    required String title,
    required String body,
    String? imageUrl,
    required String announcementType,
    required String targetAudience,
    required String priority,
    DateTime? scheduledAt,
    String? couponCode,
    String? city,
    String? affectedArea,
    String? urgency,
    String? entityType,
    String? entityId,
    Map<String, String>? data,
  }) : super._(
         title: title,
         body: body,
         imageUrl: imageUrl,
         announcementType: announcementType,
         targetAudience: targetAudience,
         priority: priority,
         scheduledAt: scheduledAt,
         couponCode: couponCode,
         city: city,
         affectedArea: affectedArea,
         urgency: urgency,
         entityType: entityType,
         entityId: entityId,
         data: data,
       );

  /// Returns a shallow copy of this [BroadcastRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BroadcastRequest copyWith({
    String? title,
    String? body,
    Object? imageUrl = _Undefined,
    String? announcementType,
    String? targetAudience,
    String? priority,
    Object? scheduledAt = _Undefined,
    Object? couponCode = _Undefined,
    Object? city = _Undefined,
    Object? affectedArea = _Undefined,
    Object? urgency = _Undefined,
    Object? entityType = _Undefined,
    Object? entityId = _Undefined,
    Object? data = _Undefined,
  }) {
    return BroadcastRequest(
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      announcementType: announcementType ?? this.announcementType,
      targetAudience: targetAudience ?? this.targetAudience,
      priority: priority ?? this.priority,
      scheduledAt: scheduledAt is DateTime? ? scheduledAt : this.scheduledAt,
      couponCode: couponCode is String? ? couponCode : this.couponCode,
      city: city is String? ? city : this.city,
      affectedArea: affectedArea is String? ? affectedArea : this.affectedArea,
      urgency: urgency is String? ? urgency : this.urgency,
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
