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

abstract class DeliverySettings
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DeliverySettings._({
    required this.defaultVerificationMethod,
    required this.cameraOnlyCapture,
    required this.gpsRequired,
    required this.strictDistanceValidation,
    required this.maxAllowedRadiusMeters,
    required this.updatedAt,
  });

  factory DeliverySettings({
    required String defaultVerificationMethod,
    required bool cameraOnlyCapture,
    required bool gpsRequired,
    required bool strictDistanceValidation,
    required int maxAllowedRadiusMeters,
    required DateTime updatedAt,
  }) = _DeliverySettingsImpl;

  factory DeliverySettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliverySettings(
      defaultVerificationMethod:
          jsonSerialization['defaultVerificationMethod'] as String,
      cameraOnlyCapture: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['cameraOnlyCapture'],
      ),
      gpsRequired: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['gpsRequired'],
      ),
      strictDistanceValidation: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['strictDistanceValidation'],
      ),
      maxAllowedRadiusMeters:
          jsonSerialization['maxAllowedRadiusMeters'] as int,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  String defaultVerificationMethod;

  bool cameraOnlyCapture;

  bool gpsRequired;

  bool strictDistanceValidation;

  int maxAllowedRadiusMeters;

  DateTime updatedAt;

  /// Returns a shallow copy of this [DeliverySettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliverySettings copyWith({
    String? defaultVerificationMethod,
    bool? cameraOnlyCapture,
    bool? gpsRequired,
    bool? strictDistanceValidation,
    int? maxAllowedRadiusMeters,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliverySettings',
      'defaultVerificationMethod': defaultVerificationMethod,
      'cameraOnlyCapture': cameraOnlyCapture,
      'gpsRequired': gpsRequired,
      'strictDistanceValidation': strictDistanceValidation,
      'maxAllowedRadiusMeters': maxAllowedRadiusMeters,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeliverySettings',
      'defaultVerificationMethod': defaultVerificationMethod,
      'cameraOnlyCapture': cameraOnlyCapture,
      'gpsRequired': gpsRequired,
      'strictDistanceValidation': strictDistanceValidation,
      'maxAllowedRadiusMeters': maxAllowedRadiusMeters,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DeliverySettingsImpl extends DeliverySettings {
  _DeliverySettingsImpl({
    required String defaultVerificationMethod,
    required bool cameraOnlyCapture,
    required bool gpsRequired,
    required bool strictDistanceValidation,
    required int maxAllowedRadiusMeters,
    required DateTime updatedAt,
  }) : super._(
         defaultVerificationMethod: defaultVerificationMethod,
         cameraOnlyCapture: cameraOnlyCapture,
         gpsRequired: gpsRequired,
         strictDistanceValidation: strictDistanceValidation,
         maxAllowedRadiusMeters: maxAllowedRadiusMeters,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeliverySettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliverySettings copyWith({
    String? defaultVerificationMethod,
    bool? cameraOnlyCapture,
    bool? gpsRequired,
    bool? strictDistanceValidation,
    int? maxAllowedRadiusMeters,
    DateTime? updatedAt,
  }) {
    return DeliverySettings(
      defaultVerificationMethod:
          defaultVerificationMethod ?? this.defaultVerificationMethod,
      cameraOnlyCapture: cameraOnlyCapture ?? this.cameraOnlyCapture,
      gpsRequired: gpsRequired ?? this.gpsRequired,
      strictDistanceValidation:
          strictDistanceValidation ?? this.strictDistanceValidation,
      maxAllowedRadiusMeters:
          maxAllowedRadiusMeters ?? this.maxAllowedRadiusMeters,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
