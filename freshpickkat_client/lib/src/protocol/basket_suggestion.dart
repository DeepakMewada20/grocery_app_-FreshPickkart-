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
import 'basket_suggestion_action.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class BasketSuggestion implements _i1.SerializableModel {
  BasketSuggestion._({
    this.id,
    this.title,
    this.subtitle,
    required this.message,
    required this.type,
    required this.priority,
    this.score,
    this.metadata,
    this.action,
    this.actions,
    this.netProfit,
    this.extraSpend,
    this.profitEfficiency,
    this.rank,
    this.isBest,
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
    String? id,
    String? title,
    String? subtitle,
    required String message,
    required String type,
    required int priority,
    double? score,
    Map<String, String>? metadata,
    _i2.BasketSuggestionAction? action,
    List<_i2.BasketSuggestionAction>? actions,
    double? netProfit,
    double? extraSpend,
    double? profitEfficiency,
    int? rank,
    bool? isBest,
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
      id: jsonSerialization['id'] as String?,
      title: jsonSerialization['title'] as String?,
      subtitle: jsonSerialization['subtitle'] as String?,
      message: jsonSerialization['message'] as String,
      type: jsonSerialization['type'] as String,
      priority: jsonSerialization['priority'] as int,
      score: (jsonSerialization['score'] as num?)?.toDouble(),
      metadata: jsonSerialization['metadata'] == null
          ? null
          : _i3.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['metadata'],
            ),
      action: jsonSerialization['action'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.BasketSuggestionAction>(
              jsonSerialization['action'],
            ),
      actions: jsonSerialization['actions'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.BasketSuggestionAction>>(
              jsonSerialization['actions'],
            ),
      netProfit: (jsonSerialization['netProfit'] as num?)?.toDouble(),
      extraSpend: (jsonSerialization['extraSpend'] as num?)?.toDouble(),
      profitEfficiency: (jsonSerialization['profitEfficiency'] as num?)
          ?.toDouble(),
      rank: jsonSerialization['rank'] as int?,
      isBest: jsonSerialization['isBest'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isBest']),
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

  String? id;

  String? title;

  String? subtitle;

  String message;

  String type;

  int priority;

  double? score;

  Map<String, String>? metadata;

  _i2.BasketSuggestionAction? action;

  List<_i2.BasketSuggestionAction>? actions;

  double? netProfit;

  double? extraSpend;

  double? profitEfficiency;

  int? rank;

  bool? isBest;

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
    String? id,
    String? title,
    String? subtitle,
    String? message,
    String? type,
    int? priority,
    double? score,
    Map<String, String>? metadata,
    _i2.BasketSuggestionAction? action,
    List<_i2.BasketSuggestionAction>? actions,
    double? netProfit,
    double? extraSpend,
    double? profitEfficiency,
    int? rank,
    bool? isBest,
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
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      'message': message,
      'type': type,
      'priority': priority,
      if (score != null) 'score': score,
      if (metadata != null) 'metadata': metadata?.toJson(),
      if (action != null) 'action': action?.toJson(),
      if (actions != null)
        'actions': actions?.toJson(valueToJson: (v) => v.toJson()),
      if (netProfit != null) 'netProfit': netProfit,
      if (extraSpend != null) 'extraSpend': extraSpend,
      if (profitEfficiency != null) 'profitEfficiency': profitEfficiency,
      if (rank != null) 'rank': rank,
      if (isBest != null) 'isBest': isBest,
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
    String? id,
    String? title,
    String? subtitle,
    required String message,
    required String type,
    required int priority,
    double? score,
    Map<String, String>? metadata,
    _i2.BasketSuggestionAction? action,
    List<_i2.BasketSuggestionAction>? actions,
    double? netProfit,
    double? extraSpend,
    double? profitEfficiency,
    int? rank,
    bool? isBest,
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
         id: id,
         title: title,
         subtitle: subtitle,
         message: message,
         type: type,
         priority: priority,
         score: score,
         metadata: metadata,
         action: action,
         actions: actions,
         netProfit: netProfit,
         extraSpend: extraSpend,
         profitEfficiency: profitEfficiency,
         rank: rank,
         isBest: isBest,
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
    Object? id = _Undefined,
    Object? title = _Undefined,
    Object? subtitle = _Undefined,
    String? message,
    String? type,
    int? priority,
    Object? score = _Undefined,
    Object? metadata = _Undefined,
    Object? action = _Undefined,
    Object? actions = _Undefined,
    Object? netProfit = _Undefined,
    Object? extraSpend = _Undefined,
    Object? profitEfficiency = _Undefined,
    Object? rank = _Undefined,
    Object? isBest = _Undefined,
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
      id: id is String? ? id : this.id,
      title: title is String? ? title : this.title,
      subtitle: subtitle is String? ? subtitle : this.subtitle,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      score: score is double? ? score : this.score,
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
      action: action is _i2.BasketSuggestionAction?
          ? action
          : this.action?.copyWith(),
      actions: actions is List<_i2.BasketSuggestionAction>?
          ? actions
          : this.actions?.map((e0) => e0.copyWith()).toList(),
      netProfit: netProfit is double? ? netProfit : this.netProfit,
      extraSpend: extraSpend is double? ? extraSpend : this.extraSpend,
      profitEfficiency: profitEfficiency is double?
          ? profitEfficiency
          : this.profitEfficiency,
      rank: rank is int? ? rank : this.rank,
      isBest: isBest is bool? ? isBest : this.isBest,
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
