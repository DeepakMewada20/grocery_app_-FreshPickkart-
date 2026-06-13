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

abstract class AdminAuditLogEntry implements _i1.SerializableModel {
  AdminAuditLogEntry._({
    required this.id,
    required this.actorUid,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.createdAt,
  });

  factory AdminAuditLogEntry({
    required String id,
    required String actorUid,
    required String action,
    required String entityType,
    required String entityId,
    required String createdAt,
  }) = _AdminAuditLogEntryImpl;

  factory AdminAuditLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAuditLogEntry(
      id: jsonSerialization['id'] as String,
      actorUid: jsonSerialization['actorUid'] as String,
      action: jsonSerialization['action'] as String,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as String,
      createdAt: jsonSerialization['createdAt'] as String,
    );
  }

  String id;

  String actorUid;

  String action;

  String entityType;

  String entityId;

  String createdAt;

  /// Returns a shallow copy of this [AdminAuditLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminAuditLogEntry copyWith({
    String? id,
    String? actorUid,
    String? action,
    String? entityType,
    String? entityId,
    String? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAuditLogEntry',
      'id': id,
      'actorUid': actorUid,
      'action': action,
      'entityType': entityType,
      'entityId': entityId,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AdminAuditLogEntryImpl extends AdminAuditLogEntry {
  _AdminAuditLogEntryImpl({
    required String id,
    required String actorUid,
    required String action,
    required String entityType,
    required String entityId,
    required String createdAt,
  }) : super._(
         id: id,
         actorUid: actorUid,
         action: action,
         entityType: entityType,
         entityId: entityId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AdminAuditLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminAuditLogEntry copyWith({
    String? id,
    String? actorUid,
    String? action,
    String? entityType,
    String? entityId,
    String? createdAt,
  }) {
    return AdminAuditLogEntry(
      id: id ?? this.id,
      actorUid: actorUid ?? this.actorUid,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
