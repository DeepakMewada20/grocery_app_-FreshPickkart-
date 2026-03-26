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

abstract class AppliedCouponInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AppliedCouponInfo._({
    required this.couponId,
    required this.couponCode,
    required this.discountAmount,
    required this.isAutoApplied,
  });

  factory AppliedCouponInfo({
    required String couponId,
    required String couponCode,
    required double discountAmount,
    required bool isAutoApplied,
  }) = _AppliedCouponInfoImpl;

  factory AppliedCouponInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppliedCouponInfo(
      couponId: jsonSerialization['couponId'] as String,
      couponCode: jsonSerialization['couponCode'] as String,
      discountAmount: (jsonSerialization['discountAmount'] as num).toDouble(),
      isAutoApplied: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isAutoApplied'],
      ),
    );
  }

  String couponId;

  String couponCode;

  double discountAmount;

  bool isAutoApplied;

  /// Returns a shallow copy of this [AppliedCouponInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppliedCouponInfo copyWith({
    String? couponId,
    String? couponCode,
    double? discountAmount,
    bool? isAutoApplied,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppliedCouponInfo',
      'couponId': couponId,
      'couponCode': couponCode,
      'discountAmount': discountAmount,
      'isAutoApplied': isAutoApplied,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppliedCouponInfo',
      'couponId': couponId,
      'couponCode': couponCode,
      'discountAmount': discountAmount,
      'isAutoApplied': isAutoApplied,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AppliedCouponInfoImpl extends AppliedCouponInfo {
  _AppliedCouponInfoImpl({
    required String couponId,
    required String couponCode,
    required double discountAmount,
    required bool isAutoApplied,
  }) : super._(
         couponId: couponId,
         couponCode: couponCode,
         discountAmount: discountAmount,
         isAutoApplied: isAutoApplied,
       );

  /// Returns a shallow copy of this [AppliedCouponInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppliedCouponInfo copyWith({
    String? couponId,
    String? couponCode,
    double? discountAmount,
    bool? isAutoApplied,
  }) {
    return AppliedCouponInfo(
      couponId: couponId ?? this.couponId,
      couponCode: couponCode ?? this.couponCode,
      discountAmount: discountAmount ?? this.discountAmount,
      isAutoApplied: isAutoApplied ?? this.isAutoApplied,
    );
  }
}
