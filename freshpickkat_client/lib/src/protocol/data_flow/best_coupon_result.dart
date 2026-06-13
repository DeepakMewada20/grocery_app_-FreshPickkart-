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

abstract class BestCouponResult implements _i1.SerializableModel {
  BestCouponResult._({
    this.bestCouponCode,
    required this.discountAmount,
  });

  factory BestCouponResult({
    String? bestCouponCode,
    required double discountAmount,
  }) = _BestCouponResultImpl;

  factory BestCouponResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return BestCouponResult(
      bestCouponCode: jsonSerialization['bestCouponCode'] as String?,
      discountAmount: (jsonSerialization['discountAmount'] as num).toDouble(),
    );
  }

  String? bestCouponCode;

  double discountAmount;

  /// Returns a shallow copy of this [BestCouponResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BestCouponResult copyWith({
    String? bestCouponCode,
    double? discountAmount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BestCouponResult',
      if (bestCouponCode != null) 'bestCouponCode': bestCouponCode,
      'discountAmount': discountAmount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BestCouponResultImpl extends BestCouponResult {
  _BestCouponResultImpl({
    String? bestCouponCode,
    required double discountAmount,
  }) : super._(
         bestCouponCode: bestCouponCode,
         discountAmount: discountAmount,
       );

  /// Returns a shallow copy of this [BestCouponResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BestCouponResult copyWith({
    Object? bestCouponCode = _Undefined,
    double? discountAmount,
  }) {
    return BestCouponResult(
      bestCouponCode: bestCouponCode is String?
          ? bestCouponCode
          : this.bestCouponCode,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}
