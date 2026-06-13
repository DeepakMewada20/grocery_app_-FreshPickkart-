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

abstract class BroadcastSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BroadcastSummary._({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.announcementType,
    required this.targetAudience,
    required this.priority,
    required this.status,
    this.scheduledAt,
    required this.createdAt,
    this.sentAt,
    required this.recipientCount,
    required this.successCount,
    required this.failureCount,
    this.lastError,
  });

  factory BroadcastSummary({
    required String id,
    required String title,
    required String body,
    String? imageUrl,
    required String announcementType,
    required String targetAudience,
    required String priority,
    required String status,
    DateTime? scheduledAt,
    required DateTime createdAt,
    DateTime? sentAt,
    required int recipientCount,
    required int successCount,
    required int failureCount,
    String? lastError,
  }) = _BroadcastSummaryImpl;

  factory BroadcastSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return BroadcastSummary(
      id: jsonSerialization['id'] as String,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      announcementType: jsonSerialization['announcementType'] as String,
      targetAudience: jsonSerialization['targetAudience'] as String,
      priority: jsonSerialization['priority'] as String,
      status: jsonSerialization['status'] as String,
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      recipientCount: jsonSerialization['recipientCount'] as int,
      successCount: jsonSerialization['successCount'] as int,
      failureCount: jsonSerialization['failureCount'] as int,
      lastError: jsonSerialization['lastError'] as String?,
    );
  }

  String id;

  String title;

  String body;

  String? imageUrl;

  String announcementType;

  String targetAudience;

  String priority;

  String status;

  DateTime? scheduledAt;

  DateTime createdAt;

  DateTime? sentAt;

  int recipientCount;

  int successCount;

  int failureCount;

  String? lastError;

  /// Returns a shallow copy of this [BroadcastSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BroadcastSummary copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    String? announcementType,
    String? targetAudience,
    String? priority,
    String? status,
    DateTime? scheduledAt,
    DateTime? createdAt,
    DateTime? sentAt,
    int? recipientCount,
    int? successCount,
    int? failureCount,
    String? lastError,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BroadcastSummary',
      'id': id,
      'title': title,
      'body': body,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'announcementType': announcementType,
      'targetAudience': targetAudience,
      'priority': priority,
      'status': status,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      'recipientCount': recipientCount,
      'successCount': successCount,
      'failureCount': failureCount,
      if (lastError != null) 'lastError': lastError,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BroadcastSummary',
      'id': id,
      'title': title,
      'body': body,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'announcementType': announcementType,
      'targetAudience': targetAudience,
      'priority': priority,
      'status': status,
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      'recipientCount': recipientCount,
      'successCount': successCount,
      'failureCount': failureCount,
      if (lastError != null) 'lastError': lastError,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BroadcastSummaryImpl extends BroadcastSummary {
  _BroadcastSummaryImpl({
    required String id,
    required String title,
    required String body,
    String? imageUrl,
    required String announcementType,
    required String targetAudience,
    required String priority,
    required String status,
    DateTime? scheduledAt,
    required DateTime createdAt,
    DateTime? sentAt,
    required int recipientCount,
    required int successCount,
    required int failureCount,
    String? lastError,
  }) : super._(
         id: id,
         title: title,
         body: body,
         imageUrl: imageUrl,
         announcementType: announcementType,
         targetAudience: targetAudience,
         priority: priority,
         status: status,
         scheduledAt: scheduledAt,
         createdAt: createdAt,
         sentAt: sentAt,
         recipientCount: recipientCount,
         successCount: successCount,
         failureCount: failureCount,
         lastError: lastError,
       );

  /// Returns a shallow copy of this [BroadcastSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BroadcastSummary copyWith({
    String? id,
    String? title,
    String? body,
    Object? imageUrl = _Undefined,
    String? announcementType,
    String? targetAudience,
    String? priority,
    String? status,
    Object? scheduledAt = _Undefined,
    DateTime? createdAt,
    Object? sentAt = _Undefined,
    int? recipientCount,
    int? successCount,
    int? failureCount,
    Object? lastError = _Undefined,
  }) {
    return BroadcastSummary(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      announcementType: announcementType ?? this.announcementType,
      targetAudience: targetAudience ?? this.targetAudience,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      scheduledAt: scheduledAt is DateTime? ? scheduledAt : this.scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt is DateTime? ? sentAt : this.sentAt,
      recipientCount: recipientCount ?? this.recipientCount,
      successCount: successCount ?? this.successCount,
      failureCount: failureCount ?? this.failureCount,
      lastError: lastError is String? ? lastError : this.lastError,
    );
  }
}
