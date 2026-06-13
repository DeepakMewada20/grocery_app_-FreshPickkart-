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

abstract class SupportIssue implements _i1.SerializableModel {
  SupportIssue._({
    required this.issueId,
    required this.userId,
    required this.issueType,
    required this.title,
    required this.description,
    this.screenshotUrl,
    required this.appVersion,
    required this.buildNumber,
    required this.deviceInfo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportIssue({
    required String issueId,
    required String userId,
    required String issueType,
    required String title,
    required String description,
    String? screenshotUrl,
    required String appVersion,
    required String buildNumber,
    required String deviceInfo,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SupportIssueImpl;

  factory SupportIssue.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportIssue(
      issueId: jsonSerialization['issueId'] as String,
      userId: jsonSerialization['userId'] as String,
      issueType: jsonSerialization['issueType'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      screenshotUrl: jsonSerialization['screenshotUrl'] as String?,
      appVersion: jsonSerialization['appVersion'] as String,
      buildNumber: jsonSerialization['buildNumber'] as String,
      deviceInfo: jsonSerialization['deviceInfo'] as String,
      status: jsonSerialization['status'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  String issueId;

  String userId;

  String issueType;

  String title;

  String description;

  String? screenshotUrl;

  String appVersion;

  String buildNumber;

  String deviceInfo;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [SupportIssue]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SupportIssue copyWith({
    String? issueId,
    String? userId,
    String? issueType,
    String? title,
    String? description,
    String? screenshotUrl,
    String? appVersion,
    String? buildNumber,
    String? deviceInfo,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportIssue',
      'issueId': issueId,
      'userId': userId,
      'issueType': issueType,
      'title': title,
      'description': description,
      if (screenshotUrl != null) 'screenshotUrl': screenshotUrl,
      'appVersion': appVersion,
      'buildNumber': buildNumber,
      'deviceInfo': deviceInfo,
      'status': status,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SupportIssueImpl extends SupportIssue {
  _SupportIssueImpl({
    required String issueId,
    required String userId,
    required String issueType,
    required String title,
    required String description,
    String? screenshotUrl,
    required String appVersion,
    required String buildNumber,
    required String deviceInfo,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         issueId: issueId,
         userId: userId,
         issueType: issueType,
         title: title,
         description: description,
         screenshotUrl: screenshotUrl,
         appVersion: appVersion,
         buildNumber: buildNumber,
         deviceInfo: deviceInfo,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [SupportIssue]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SupportIssue copyWith({
    String? issueId,
    String? userId,
    String? issueType,
    String? title,
    String? description,
    Object? screenshotUrl = _Undefined,
    String? appVersion,
    String? buildNumber,
    String? deviceInfo,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupportIssue(
      issueId: issueId ?? this.issueId,
      userId: userId ?? this.userId,
      issueType: issueType ?? this.issueType,
      title: title ?? this.title,
      description: description ?? this.description,
      screenshotUrl: screenshotUrl is String?
          ? screenshotUrl
          : this.screenshotUrl,
      appVersion: appVersion ?? this.appVersion,
      buildNumber: buildNumber ?? this.buildNumber,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
