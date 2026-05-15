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

abstract class RegisterFcmTokenRequest implements _i1.SerializableModel {
  RegisterFcmTokenRequest._({
    required this.firebaseUid,
    required this.fcmToken,
    required this.deviceId,
    required this.platform,
  });

  factory RegisterFcmTokenRequest({
    required String firebaseUid,
    required String fcmToken,
    required String deviceId,
    required String platform,
  }) = _RegisterFcmTokenRequestImpl;

  factory RegisterFcmTokenRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RegisterFcmTokenRequest(
      firebaseUid: jsonSerialization['firebaseUid'] as String,
      fcmToken: jsonSerialization['fcmToken'] as String,
      deviceId: jsonSerialization['deviceId'] as String,
      platform: jsonSerialization['platform'] as String,
    );
  }

  String firebaseUid;

  String fcmToken;

  String deviceId;

  String platform;

  /// Returns a shallow copy of this [RegisterFcmTokenRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RegisterFcmTokenRequest copyWith({
    String? firebaseUid,
    String? fcmToken,
    String? deviceId,
    String? platform,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RegisterFcmTokenRequest',
      'firebaseUid': firebaseUid,
      'fcmToken': fcmToken,
      'deviceId': deviceId,
      'platform': platform,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RegisterFcmTokenRequestImpl extends RegisterFcmTokenRequest {
  _RegisterFcmTokenRequestImpl({
    required String firebaseUid,
    required String fcmToken,
    required String deviceId,
    required String platform,
  }) : super._(
         firebaseUid: firebaseUid,
         fcmToken: fcmToken,
         deviceId: deviceId,
         platform: platform,
       );

  /// Returns a shallow copy of this [RegisterFcmTokenRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RegisterFcmTokenRequest copyWith({
    String? firebaseUid,
    String? fcmToken,
    String? deviceId,
    String? platform,
  }) {
    return RegisterFcmTokenRequest(
      firebaseUid: firebaseUid ?? this.firebaseUid,
      fcmToken: fcmToken ?? this.fcmToken,
      deviceId: deviceId ?? this.deviceId,
      platform: platform ?? this.platform,
    );
  }
}
