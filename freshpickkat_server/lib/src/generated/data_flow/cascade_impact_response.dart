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
import '../data_flow/cascade_entity_info.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class CascadeImpactResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CascadeImpactResponse._({
    required this.primaryEntity,
    required this.affectedEntities,
    required this.protectedEntities,
  });

  factory CascadeImpactResponse({
    required _i2.CascadeEntityInfo primaryEntity,
    required List<_i2.CascadeEntityInfo> affectedEntities,
    required List<_i2.CascadeEntityInfo> protectedEntities,
  }) = _CascadeImpactResponseImpl;

  factory CascadeImpactResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CascadeImpactResponse(
      primaryEntity: _i3.Protocol().deserialize<_i2.CascadeEntityInfo>(
        jsonSerialization['primaryEntity'],
      ),
      affectedEntities: _i3.Protocol().deserialize<List<_i2.CascadeEntityInfo>>(
        jsonSerialization['affectedEntities'],
      ),
      protectedEntities: _i3.Protocol()
          .deserialize<List<_i2.CascadeEntityInfo>>(
            jsonSerialization['protectedEntities'],
          ),
    );
  }

  _i2.CascadeEntityInfo primaryEntity;

  List<_i2.CascadeEntityInfo> affectedEntities;

  List<_i2.CascadeEntityInfo> protectedEntities;

  /// Returns a shallow copy of this [CascadeImpactResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CascadeImpactResponse copyWith({
    _i2.CascadeEntityInfo? primaryEntity,
    List<_i2.CascadeEntityInfo>? affectedEntities,
    List<_i2.CascadeEntityInfo>? protectedEntities,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CascadeImpactResponse',
      'primaryEntity': primaryEntity.toJson(),
      'affectedEntities': affectedEntities.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'protectedEntities': protectedEntities.toJson(
        valueToJson: (v) => v.toJson(),
      ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CascadeImpactResponse',
      'primaryEntity': primaryEntity.toJsonForProtocol(),
      'affectedEntities': affectedEntities.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'protectedEntities': protectedEntities.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CascadeImpactResponseImpl extends CascadeImpactResponse {
  _CascadeImpactResponseImpl({
    required _i2.CascadeEntityInfo primaryEntity,
    required List<_i2.CascadeEntityInfo> affectedEntities,
    required List<_i2.CascadeEntityInfo> protectedEntities,
  }) : super._(
         primaryEntity: primaryEntity,
         affectedEntities: affectedEntities,
         protectedEntities: protectedEntities,
       );

  /// Returns a shallow copy of this [CascadeImpactResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CascadeImpactResponse copyWith({
    _i2.CascadeEntityInfo? primaryEntity,
    List<_i2.CascadeEntityInfo>? affectedEntities,
    List<_i2.CascadeEntityInfo>? protectedEntities,
  }) {
    return CascadeImpactResponse(
      primaryEntity: primaryEntity ?? this.primaryEntity.copyWith(),
      affectedEntities:
          affectedEntities ??
          this.affectedEntities.map((e0) => e0.copyWith()).toList(),
      protectedEntities:
          protectedEntities ??
          this.protectedEntities.map((e0) => e0.copyWith()).toList(),
    );
  }
}
