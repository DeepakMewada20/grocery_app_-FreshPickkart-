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

abstract class ReferralOnboardingStatus
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReferralOnboardingStatus._({
    required this.isEligible,
    required this.showReminder,
    this.pendingReferralCode,
    this.windowExpiresAt,
  });

  factory ReferralOnboardingStatus({
    required bool isEligible,
    required bool showReminder,
    String? pendingReferralCode,
    DateTime? windowExpiresAt,
  }) = _ReferralOnboardingStatusImpl;

  factory ReferralOnboardingStatus.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReferralOnboardingStatus(
      isEligible: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isEligible'],
      ),
      showReminder: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['showReminder'],
      ),
      pendingReferralCode: jsonSerialization['pendingReferralCode'] as String?,
      windowExpiresAt: jsonSerialization['windowExpiresAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['windowExpiresAt'],
            ),
    );
  }

  bool isEligible;

  bool showReminder;

  String? pendingReferralCode;

  DateTime? windowExpiresAt;

  /// Returns a shallow copy of this [ReferralOnboardingStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferralOnboardingStatus copyWith({
    bool? isEligible,
    bool? showReminder,
    String? pendingReferralCode,
    DateTime? windowExpiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReferralOnboardingStatus',
      'isEligible': isEligible,
      'showReminder': showReminder,
      if (pendingReferralCode != null)
        'pendingReferralCode': pendingReferralCode,
      if (windowExpiresAt != null) 'windowExpiresAt': windowExpiresAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReferralOnboardingStatus',
      'isEligible': isEligible,
      'showReminder': showReminder,
      if (pendingReferralCode != null)
        'pendingReferralCode': pendingReferralCode,
      if (windowExpiresAt != null) 'windowExpiresAt': windowExpiresAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReferralOnboardingStatusImpl extends ReferralOnboardingStatus {
  _ReferralOnboardingStatusImpl({
    required bool isEligible,
    required bool showReminder,
    String? pendingReferralCode,
    DateTime? windowExpiresAt,
  }) : super._(
         isEligible: isEligible,
         showReminder: showReminder,
         pendingReferralCode: pendingReferralCode,
         windowExpiresAt: windowExpiresAt,
       );

  /// Returns a shallow copy of this [ReferralOnboardingStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferralOnboardingStatus copyWith({
    bool? isEligible,
    bool? showReminder,
    Object? pendingReferralCode = _Undefined,
    Object? windowExpiresAt = _Undefined,
  }) {
    return ReferralOnboardingStatus(
      isEligible: isEligible ?? this.isEligible,
      showReminder: showReminder ?? this.showReminder,
      pendingReferralCode: pendingReferralCode is String?
          ? pendingReferralCode
          : this.pendingReferralCode,
      windowExpiresAt: windowExpiresAt is DateTime?
          ? windowExpiresAt
          : this.windowExpiresAt,
    );
  }
}
