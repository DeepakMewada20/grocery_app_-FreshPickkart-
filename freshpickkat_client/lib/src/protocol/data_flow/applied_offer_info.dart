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

abstract class AppliedOfferInfo implements _i1.SerializableModel {
  AppliedOfferInfo._({
    required this.offerId,
    required this.offerName,
    required this.offerType,
    required this.discountAmount,
  });

  factory AppliedOfferInfo({
    required String offerId,
    required String offerName,
    required String offerType,
    required double discountAmount,
  }) = _AppliedOfferInfoImpl;

  factory AppliedOfferInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppliedOfferInfo(
      offerId: jsonSerialization['offerId'] as String,
      offerName: jsonSerialization['offerName'] as String,
      offerType: jsonSerialization['offerType'] as String,
      discountAmount: (jsonSerialization['discountAmount'] as num).toDouble(),
    );
  }

  String offerId;

  String offerName;

  String offerType;

  double discountAmount;

  /// Returns a shallow copy of this [AppliedOfferInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppliedOfferInfo copyWith({
    String? offerId,
    String? offerName,
    String? offerType,
    double? discountAmount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppliedOfferInfo',
      'offerId': offerId,
      'offerName': offerName,
      'offerType': offerType,
      'discountAmount': discountAmount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AppliedOfferInfoImpl extends AppliedOfferInfo {
  _AppliedOfferInfoImpl({
    required String offerId,
    required String offerName,
    required String offerType,
    required double discountAmount,
  }) : super._(
         offerId: offerId,
         offerName: offerName,
         offerType: offerType,
         discountAmount: discountAmount,
       );

  /// Returns a shallow copy of this [AppliedOfferInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppliedOfferInfo copyWith({
    String? offerId,
    String? offerName,
    String? offerType,
    double? discountAmount,
  }) {
    return AppliedOfferInfo(
      offerId: offerId ?? this.offerId,
      offerName: offerName ?? this.offerName,
      offerType: offerType ?? this.offerType,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}
