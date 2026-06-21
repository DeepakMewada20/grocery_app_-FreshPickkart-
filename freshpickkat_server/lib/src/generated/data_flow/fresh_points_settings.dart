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

abstract class FreshPointsSettings
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  FreshPointsSettings._({
    required this.isEnabled,
    required this.redemptionPercentageLimit,
    required this.allowRedemptionOnCOD,
    required this.minimumOrderForRedemption,
    required this.enablePointExpiry,
    required this.pointExpiryDays,
    required this.enableAdminAdjustments,
    required this.updatedAt,
  });

  factory FreshPointsSettings({
    required bool isEnabled,
    required double redemptionPercentageLimit,
    required bool allowRedemptionOnCOD,
    required double minimumOrderForRedemption,
    required bool enablePointExpiry,
    required int pointExpiryDays,
    required bool enableAdminAdjustments,
    required DateTime updatedAt,
  }) = _FreshPointsSettingsImpl;

  factory FreshPointsSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return FreshPointsSettings(
      isEnabled: _i1.BoolJsonExtension.fromJson(jsonSerialization['isEnabled']),
      redemptionPercentageLimit:
          (jsonSerialization['redemptionPercentageLimit'] as num).toDouble(),
      allowRedemptionOnCOD: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['allowRedemptionOnCOD'],
      ),
      minimumOrderForRedemption:
          (jsonSerialization['minimumOrderForRedemption'] as num).toDouble(),
      enablePointExpiry: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['enablePointExpiry'],
      ),
      pointExpiryDays: jsonSerialization['pointExpiryDays'] as int,
      enableAdminAdjustments: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['enableAdminAdjustments'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  bool isEnabled;

  double redemptionPercentageLimit;

  bool allowRedemptionOnCOD;

  double minimumOrderForRedemption;

  bool enablePointExpiry;

  int pointExpiryDays;

  bool enableAdminAdjustments;

  DateTime updatedAt;

  /// Returns a shallow copy of this [FreshPointsSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FreshPointsSettings copyWith({
    bool? isEnabled,
    double? redemptionPercentageLimit,
    bool? allowRedemptionOnCOD,
    double? minimumOrderForRedemption,
    bool? enablePointExpiry,
    int? pointExpiryDays,
    bool? enableAdminAdjustments,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FreshPointsSettings',
      'isEnabled': isEnabled,
      'redemptionPercentageLimit': redemptionPercentageLimit,
      'allowRedemptionOnCOD': allowRedemptionOnCOD,
      'minimumOrderForRedemption': minimumOrderForRedemption,
      'enablePointExpiry': enablePointExpiry,
      'pointExpiryDays': pointExpiryDays,
      'enableAdminAdjustments': enableAdminAdjustments,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FreshPointsSettings',
      'isEnabled': isEnabled,
      'redemptionPercentageLimit': redemptionPercentageLimit,
      'allowRedemptionOnCOD': allowRedemptionOnCOD,
      'minimumOrderForRedemption': minimumOrderForRedemption,
      'enablePointExpiry': enablePointExpiry,
      'pointExpiryDays': pointExpiryDays,
      'enableAdminAdjustments': enableAdminAdjustments,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _FreshPointsSettingsImpl extends FreshPointsSettings {
  _FreshPointsSettingsImpl({
    required bool isEnabled,
    required double redemptionPercentageLimit,
    required bool allowRedemptionOnCOD,
    required double minimumOrderForRedemption,
    required bool enablePointExpiry,
    required int pointExpiryDays,
    required bool enableAdminAdjustments,
    required DateTime updatedAt,
  }) : super._(
         isEnabled: isEnabled,
         redemptionPercentageLimit: redemptionPercentageLimit,
         allowRedemptionOnCOD: allowRedemptionOnCOD,
         minimumOrderForRedemption: minimumOrderForRedemption,
         enablePointExpiry: enablePointExpiry,
         pointExpiryDays: pointExpiryDays,
         enableAdminAdjustments: enableAdminAdjustments,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [FreshPointsSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FreshPointsSettings copyWith({
    bool? isEnabled,
    double? redemptionPercentageLimit,
    bool? allowRedemptionOnCOD,
    double? minimumOrderForRedemption,
    bool? enablePointExpiry,
    int? pointExpiryDays,
    bool? enableAdminAdjustments,
    DateTime? updatedAt,
  }) {
    return FreshPointsSettings(
      isEnabled: isEnabled ?? this.isEnabled,
      redemptionPercentageLimit:
          redemptionPercentageLimit ?? this.redemptionPercentageLimit,
      allowRedemptionOnCOD: allowRedemptionOnCOD ?? this.allowRedemptionOnCOD,
      minimumOrderForRedemption:
          minimumOrderForRedemption ?? this.minimumOrderForRedemption,
      enablePointExpiry: enablePointExpiry ?? this.enablePointExpiry,
      pointExpiryDays: pointExpiryDays ?? this.pointExpiryDays,
      enableAdminAdjustments:
          enableAdminAdjustments ?? this.enableAdminAdjustments,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
