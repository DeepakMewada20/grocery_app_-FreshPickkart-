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

abstract class DeliverySlab
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DeliverySlab._({
    required this.minOrderAmount,
    required this.maxOrderAmount,
    required this.fee,
  });

  factory DeliverySlab({
    required double minOrderAmount,
    required double maxOrderAmount,
    required double fee,
  }) = _DeliverySlabImpl;

  factory DeliverySlab.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliverySlab(
      minOrderAmount: (jsonSerialization['minOrderAmount'] as num).toDouble(),
      maxOrderAmount: (jsonSerialization['maxOrderAmount'] as num).toDouble(),
      fee: (jsonSerialization['fee'] as num).toDouble(),
    );
  }

  double minOrderAmount;

  double maxOrderAmount;

  double fee;

  /// Returns a shallow copy of this [DeliverySlab]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DeliverySlab copyWith({
    double? minOrderAmount,
    double? maxOrderAmount,
    double? fee,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliverySlab',
      'minOrderAmount': minOrderAmount,
      'maxOrderAmount': maxOrderAmount,
      'fee': fee,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeliverySlab',
      'minOrderAmount': minOrderAmount,
      'maxOrderAmount': maxOrderAmount,
      'fee': fee,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DeliverySlabImpl extends DeliverySlab {
  _DeliverySlabImpl({
    required double minOrderAmount,
    required double maxOrderAmount,
    required double fee,
  }) : super._(
         minOrderAmount: minOrderAmount,
         maxOrderAmount: maxOrderAmount,
         fee: fee,
       );

  /// Returns a shallow copy of this [DeliverySlab]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DeliverySlab copyWith({
    double? minOrderAmount,
    double? maxOrderAmount,
    double? fee,
  }) {
    return DeliverySlab(
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxOrderAmount: maxOrderAmount ?? this.maxOrderAmount,
      fee: fee ?? this.fee,
    );
  }
}
