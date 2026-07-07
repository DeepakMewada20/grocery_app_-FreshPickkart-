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
import '../data_flow/delivery_slab.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class DeliveryConfig
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DeliveryConfig._({
    this.configId,
    required this.baseDeliveryFee,
    required this.slabs,
    required this.isActive,
    required this.updatedAt,
  });

  factory DeliveryConfig({
    String? configId,
    required double baseDeliveryFee,
    required List<_i2.DeliverySlab> slabs,
    required bool isActive,
    required DateTime updatedAt,
  }) = _DeliveryConfigImpl;

  factory DeliveryConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliveryConfig(
      configId: jsonSerialization['configId'] as String?,
      baseDeliveryFee: (jsonSerialization['baseDeliveryFee'] as num).toDouble(),
      slabs: _i3.Protocol().deserialize<List<_i2.DeliverySlab>>(
        jsonSerialization['slabs'],
      ),
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  String? configId;

  double baseDeliveryFee;

  List<_i2.DeliverySlab> slabs;

  bool isActive;

  DateTime updatedAt;

  /// Returns a shallow copy of this [DeliveryConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliveryConfig copyWith({
    String? configId,
    double? baseDeliveryFee,
    List<_i2.DeliverySlab>? slabs,
    bool? isActive,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliveryConfig',
      if (configId != null) 'configId': configId,
      'baseDeliveryFee': baseDeliveryFee,
      'slabs': slabs.toJson(valueToJson: (v) => v.toJson()),
      'isActive': isActive,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeliveryConfig',
      if (configId != null) 'configId': configId,
      'baseDeliveryFee': baseDeliveryFee,
      'slabs': slabs.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'isActive': isActive,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeliveryConfigImpl extends DeliveryConfig {
  _DeliveryConfigImpl({
    String? configId,
    required double baseDeliveryFee,
    required List<_i2.DeliverySlab> slabs,
    required bool isActive,
    required DateTime updatedAt,
  }) : super._(
         configId: configId,
         baseDeliveryFee: baseDeliveryFee,
         slabs: slabs,
         isActive: isActive,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [DeliveryConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliveryConfig copyWith({
    Object? configId = _Undefined,
    double? baseDeliveryFee,
    List<_i2.DeliverySlab>? slabs,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return DeliveryConfig(
      configId: configId is String? ? configId : this.configId,
      baseDeliveryFee: baseDeliveryFee ?? this.baseDeliveryFee,
      slabs: slabs ?? this.slabs.map((e0) => e0.copyWith()).toList(),
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
