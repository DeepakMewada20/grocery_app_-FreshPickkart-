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
import '../data_flow/delete_impact_reference.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class DeleteImpactResponse implements _i1.SerializableModel {
  DeleteImpactResponse._({
    required this.canHardDelete,
    required this.references,
  });

  factory DeleteImpactResponse({
    required bool canHardDelete,
    required List<_i2.DeleteImpactReference> references,
  }) = _DeleteImpactResponseImpl;

  factory DeleteImpactResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeleteImpactResponse(
      canHardDelete: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['canHardDelete'],
      ),
      references: _i3.Protocol().deserialize<List<_i2.DeleteImpactReference>>(
        jsonSerialization['references'],
      ),
    );
  }

  bool canHardDelete;

  List<_i2.DeleteImpactReference> references;

  /// Returns a shallow copy of this [DeleteImpactResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeleteImpactResponse copyWith({
    bool? canHardDelete,
    List<_i2.DeleteImpactReference>? references,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeleteImpactResponse',
      'canHardDelete': canHardDelete,
      'references': references.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DeleteImpactResponseImpl extends DeleteImpactResponse {
  _DeleteImpactResponseImpl({
    required bool canHardDelete,
    required List<_i2.DeleteImpactReference> references,
  }) : super._(
         canHardDelete: canHardDelete,
         references: references,
       );

  /// Returns a shallow copy of this [DeleteImpactResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeleteImpactResponse copyWith({
    bool? canHardDelete,
    List<_i2.DeleteImpactReference>? references,
  }) {
    return DeleteImpactResponse(
      canHardDelete: canHardDelete ?? this.canHardDelete,
      references:
          references ?? this.references.map((e0) => e0.copyWith()).toList(),
    );
  }
}
