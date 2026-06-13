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
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i2;

abstract class BasketSuggestionAction
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BasketSuggestionAction._({
    required this.type,
    required this.label,
    required this.ctaLabel,
    this.payload,
    this.productId,
    this.variantId,
    this.comboId,
    this.couponCode,
    this.benefit,
    this.extraSpend,
  });

  factory BasketSuggestionAction({
    required String type,
    required String label,
    required String ctaLabel,
    Map<String, String>? payload,
    String? productId,
    String? variantId,
    String? comboId,
    String? couponCode,
    double? benefit,
    double? extraSpend,
  }) = _BasketSuggestionActionImpl;

  factory BasketSuggestionAction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return BasketSuggestionAction(
      type: jsonSerialization['type'] as String,
      label: jsonSerialization['label'] as String,
      ctaLabel: jsonSerialization['ctaLabel'] as String,
      payload: jsonSerialization['payload'] == null
          ? null
          : _i2.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['payload'],
            ),
      productId: jsonSerialization['productId'] as String?,
      variantId: jsonSerialization['variantId'] as String?,
      comboId: jsonSerialization['comboId'] as String?,
      couponCode: jsonSerialization['couponCode'] as String?,
      benefit: (jsonSerialization['benefit'] as num?)?.toDouble(),
      extraSpend: (jsonSerialization['extraSpend'] as num?)?.toDouble(),
    );
  }

  String type;

  String label;

  String ctaLabel;

  Map<String, String>? payload;

  String? productId;

  String? variantId;

  String? comboId;

  String? couponCode;

  double? benefit;

  double? extraSpend;

  /// Returns a shallow copy of this [BasketSuggestionAction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BasketSuggestionAction copyWith({
    String? type,
    String? label,
    String? ctaLabel,
    Map<String, String>? payload,
    String? productId,
    String? variantId,
    String? comboId,
    String? couponCode,
    double? benefit,
    double? extraSpend,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BasketSuggestionAction',
      'type': type,
      'label': label,
      'ctaLabel': ctaLabel,
      if (payload != null) 'payload': payload?.toJson(),
      if (productId != null) 'productId': productId,
      if (variantId != null) 'variantId': variantId,
      if (comboId != null) 'comboId': comboId,
      if (couponCode != null) 'couponCode': couponCode,
      if (benefit != null) 'benefit': benefit,
      if (extraSpend != null) 'extraSpend': extraSpend,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BasketSuggestionAction',
      'type': type,
      'label': label,
      'ctaLabel': ctaLabel,
      if (payload != null) 'payload': payload?.toJson(),
      if (productId != null) 'productId': productId,
      if (variantId != null) 'variantId': variantId,
      if (comboId != null) 'comboId': comboId,
      if (couponCode != null) 'couponCode': couponCode,
      if (benefit != null) 'benefit': benefit,
      if (extraSpend != null) 'extraSpend': extraSpend,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BasketSuggestionActionImpl extends BasketSuggestionAction {
  _BasketSuggestionActionImpl({
    required String type,
    required String label,
    required String ctaLabel,
    Map<String, String>? payload,
    String? productId,
    String? variantId,
    String? comboId,
    String? couponCode,
    double? benefit,
    double? extraSpend,
  }) : super._(
         type: type,
         label: label,
         ctaLabel: ctaLabel,
         payload: payload,
         productId: productId,
         variantId: variantId,
         comboId: comboId,
         couponCode: couponCode,
         benefit: benefit,
         extraSpend: extraSpend,
       );

  /// Returns a shallow copy of this [BasketSuggestionAction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BasketSuggestionAction copyWith({
    String? type,
    String? label,
    String? ctaLabel,
    Object? payload = _Undefined,
    Object? productId = _Undefined,
    Object? variantId = _Undefined,
    Object? comboId = _Undefined,
    Object? couponCode = _Undefined,
    Object? benefit = _Undefined,
    Object? extraSpend = _Undefined,
  }) {
    return BasketSuggestionAction(
      type: type ?? this.type,
      label: label ?? this.label,
      ctaLabel: ctaLabel ?? this.ctaLabel,
      payload: payload is Map<String, String>?
          ? payload
          : this.payload?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      productId: productId is String? ? productId : this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      comboId: comboId is String? ? comboId : this.comboId,
      couponCode: couponCode is String? ? couponCode : this.couponCode,
      benefit: benefit is double? ? benefit : this.benefit,
      extraSpend: extraSpend is double? ? extraSpend : this.extraSpend,
    );
  }
}
