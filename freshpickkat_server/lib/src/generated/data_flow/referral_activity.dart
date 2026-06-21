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

abstract class ReferralActivity
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReferralActivity._({
    required this.type,
    required this.inviteePhone,
    required this.description,
    this.pointsEarned,
    required this.createdAt,
  });

  factory ReferralActivity({
    required String type,
    required String inviteePhone,
    required String description,
    int? pointsEarned,
    required DateTime createdAt,
  }) = _ReferralActivityImpl;

  factory ReferralActivity.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferralActivity(
      type: jsonSerialization['type'] as String,
      inviteePhone: jsonSerialization['inviteePhone'] as String,
      description: jsonSerialization['description'] as String,
      pointsEarned: jsonSerialization['pointsEarned'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String type;

  String inviteePhone;

  String description;

  int? pointsEarned;

  DateTime createdAt;

  /// Returns a shallow copy of this [ReferralActivity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferralActivity copyWith({
    String? type,
    String? inviteePhone,
    String? description,
    int? pointsEarned,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReferralActivity',
      'type': type,
      'inviteePhone': inviteePhone,
      'description': description,
      if (pointsEarned != null) 'pointsEarned': pointsEarned,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReferralActivity',
      'type': type,
      'inviteePhone': inviteePhone,
      'description': description,
      if (pointsEarned != null) 'pointsEarned': pointsEarned,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReferralActivityImpl extends ReferralActivity {
  _ReferralActivityImpl({
    required String type,
    required String inviteePhone,
    required String description,
    int? pointsEarned,
    required DateTime createdAt,
  }) : super._(
         type: type,
         inviteePhone: inviteePhone,
         description: description,
         pointsEarned: pointsEarned,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReferralActivity]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferralActivity copyWith({
    String? type,
    String? inviteePhone,
    String? description,
    Object? pointsEarned = _Undefined,
    DateTime? createdAt,
  }) {
    return ReferralActivity(
      type: type ?? this.type,
      inviteePhone: inviteePhone ?? this.inviteePhone,
      description: description ?? this.description,
      pointsEarned: pointsEarned is int? ? pointsEarned : this.pointsEarned,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
