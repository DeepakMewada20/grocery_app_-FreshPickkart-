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

abstract class DeleteImpactReference
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DeleteImpactReference._({
    required this.type,
    required this.count,
  });

  factory DeleteImpactReference({
    required String type,
    required int count,
  }) = _DeleteImpactReferenceImpl;

  factory DeleteImpactReference.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DeleteImpactReference(
      type: jsonSerialization['type'] as String,
      count: jsonSerialization['count'] as int,
    );
  }

  String type;

  int count;

  /// Returns a shallow copy of this [DeleteImpactReference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeleteImpactReference copyWith({
    String? type,
    int? count,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeleteImpactReference',
      'type': type,
      'count': count,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeleteImpactReference',
      'type': type,
      'count': count,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DeleteImpactReferenceImpl extends DeleteImpactReference {
  _DeleteImpactReferenceImpl({
    required String type,
    required int count,
  }) : super._(
         type: type,
         count: count,
       );

  /// Returns a shallow copy of this [DeleteImpactReference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeleteImpactReference copyWith({
    String? type,
    int? count,
  }) {
    return DeleteImpactReference(
      type: type ?? this.type,
      count: count ?? this.count,
    );
  }
}
