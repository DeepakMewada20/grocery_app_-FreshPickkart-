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
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i2;

abstract class BasketSuggestion implements _i1.SerializableModel {
  BasketSuggestion._({
    required this.message,
    required this.type,
    required this.priority,
    this.metadata,
    this.progressCurrent,
    this.progressTarget,
    this.progressRemaining,
    this.ctaLabel,
    this.productId,
    this.variantId,
    this.comboId,
    this.savingAmount,
    this.thumbnailUrl,
  });

  factory BasketSuggestion({
    required String message,
    required String type,
    required int priority,
    Map<String, String>? metadata,
    double? progressCurrent,
    double? progressTarget,
    double? progressRemaining,
    String? ctaLabel,
    String? productId,
    String? variantId,
    String? comboId,
    double? savingAmount,
    String? thumbnailUrl,
  }) = _BasketSuggestionImpl;

  factory BasketSuggestion.fromJson(Map<String, dynamic> jsonSerialization) {
    return BasketSuggestion(
      message: jsonSerialization['message'] as String,
      type: jsonSerialization['type'] as String,
      priority: jsonSerialization['priority'] as int,
      metadata: jsonSerialization['metadata'] == null
          ? null
          : _i2.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['metadata'],
            ),
      progressCurrent: (jsonSerialization['progressCurrent'] as num?)
          ?.toDouble(),
      progressTarget: (jsonSerialization['progressTarget'] as num?)?.toDouble(),
      progressRemaining: (jsonSerialization['progressRemaining'] as num?)
          ?.toDouble(),
      ctaLabel: jsonSerialization['ctaLabel'] as String?,
      productId: jsonSerialization['productId'] as String?,
      variantId: jsonSerialization['variantId'] as String?,
      comboId: jsonSerialization['comboId'] as String?,
      savingAmount: (jsonSerialization['savingAmount'] as num?)?.toDouble(),
      thumbnailUrl: jsonSerialization['thumbnailUrl'] as String?,
    );
  }

  String message;

  String type;

  int priority;

  Map<String, String>? metadata;

  double? progressCurrent;

  double? progressTarget;

  double? progressRemaining;

  String? ctaLabel;

  String? productId;

  String? variantId;

  String? comboId;

  double? savingAmount;

  String? thumbnailUrl;

  /// Returns a shallow copy of this [BasketSuggestion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BasketSuggestion copyWith({
    String? message,
    String? type,
    int? priority,
    Map<String, String>? metadata,
    double? progressCurrent,
    double? progressTarget,
    double? progressRemaining,
    String? ctaLabel,
    String? productId,
    String? variantId,
    String? comboId,
    double? savingAmount,
    String? thumbnailUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BasketSuggestion',
      'message': message,
      'type': type,
      'priority': priority,
      if (metadata != null) 'metadata': metadata?.toJson(),
      if (progressCurrent != null) 'progressCurrent': progressCurrent,
      if (progressTarget != null) 'progressTarget': progressTarget,
      if (progressRemaining != null) 'progressRemaining': progressRemaining,
      if (ctaLabel != null) 'ctaLabel': ctaLabel,
      if (productId != null) 'productId': productId,
      if (variantId != null) 'variantId': variantId,
      if (comboId != null) 'comboId': comboId,
      if (savingAmount != null) 'savingAmount': savingAmount,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BasketSuggestionImpl extends BasketSuggestion {
  _BasketSuggestionImpl({
    required String message,
    required String type,
    required int priority,
    Map<String, String>? metadata,
    double? progressCurrent,
    double? progressTarget,
    double? progressRemaining,
    String? ctaLabel,
    String? productId,
    String? variantId,
    String? comboId,
    double? savingAmount,
    String? thumbnailUrl,
  }) : super._(
         message: message,
         type: type,
         priority: priority,
         metadata: metadata,
         progressCurrent: progressCurrent,
         progressTarget: progressTarget,
         progressRemaining: progressRemaining,
         ctaLabel: ctaLabel,
         productId: productId,
         variantId: variantId,
         comboId: comboId,
         savingAmount: savingAmount,
         thumbnailUrl: thumbnailUrl,
       );

  /// Returns a shallow copy of this [BasketSuggestion]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BasketSuggestion copyWith({
    String? message,
    String? type,
    int? priority,
    Object? metadata = _Undefined,
    Object? progressCurrent = _Undefined,
    Object? progressTarget = _Undefined,
    Object? progressRemaining = _Undefined,
    Object? ctaLabel = _Undefined,
    Object? productId = _Undefined,
    Object? variantId = _Undefined,
    Object? comboId = _Undefined,
    Object? savingAmount = _Undefined,
    Object? thumbnailUrl = _Undefined,
  }) {
    return BasketSuggestion(
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      metadata: metadata is Map<String, String>?
          ? metadata
          : this.metadata?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      progressCurrent: progressCurrent is double?
          ? progressCurrent
          : this.progressCurrent,
      progressTarget: progressTarget is double?
          ? progressTarget
          : this.progressTarget,
      progressRemaining: progressRemaining is double?
          ? progressRemaining
          : this.progressRemaining,
      ctaLabel: ctaLabel is String? ? ctaLabel : this.ctaLabel,
      productId: productId is String? ? productId : this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      comboId: comboId is String? ? comboId : this.comboId,
      savingAmount: savingAmount is double? ? savingAmount : this.savingAmount,
      thumbnailUrl: thumbnailUrl is String? ? thumbnailUrl : this.thumbnailUrl,
    );
  }
}
