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
import 'basket_suggestion.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class BasketSuggestionResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  BasketSuggestionResult._({
    this.bestSuggestion,
    this.otherSuggestions,
    required this.suggestions,
  });

  factory BasketSuggestionResult({
    _i2.BasketSuggestion? bestSuggestion,
    List<_i2.BasketSuggestion>? otherSuggestions,
    required List<_i2.BasketSuggestion> suggestions,
  }) = _BasketSuggestionResultImpl;

  factory BasketSuggestionResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return BasketSuggestionResult(
      bestSuggestion: jsonSerialization['bestSuggestion'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.BasketSuggestion>(
              jsonSerialization['bestSuggestion'],
            ),
      otherSuggestions: jsonSerialization['otherSuggestions'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.BasketSuggestion>>(
              jsonSerialization['otherSuggestions'],
            ),
      suggestions: _i3.Protocol().deserialize<List<_i2.BasketSuggestion>>(
        jsonSerialization['suggestions'],
      ),
    );
  }

  _i2.BasketSuggestion? bestSuggestion;

  List<_i2.BasketSuggestion>? otherSuggestions;

  List<_i2.BasketSuggestion> suggestions;

  /// Returns a shallow copy of this [BasketSuggestionResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BasketSuggestionResult copyWith({
    _i2.BasketSuggestion? bestSuggestion,
    List<_i2.BasketSuggestion>? otherSuggestions,
    List<_i2.BasketSuggestion>? suggestions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BasketSuggestionResult',
      if (bestSuggestion != null) 'bestSuggestion': bestSuggestion?.toJson(),
      if (otherSuggestions != null)
        'otherSuggestions': otherSuggestions?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'suggestions': suggestions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BasketSuggestionResult',
      if (bestSuggestion != null)
        'bestSuggestion': bestSuggestion?.toJsonForProtocol(),
      if (otherSuggestions != null)
        'otherSuggestions': otherSuggestions?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'suggestions': suggestions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BasketSuggestionResultImpl extends BasketSuggestionResult {
  _BasketSuggestionResultImpl({
    _i2.BasketSuggestion? bestSuggestion,
    List<_i2.BasketSuggestion>? otherSuggestions,
    required List<_i2.BasketSuggestion> suggestions,
  }) : super._(
         bestSuggestion: bestSuggestion,
         otherSuggestions: otherSuggestions,
         suggestions: suggestions,
       );

  /// Returns a shallow copy of this [BasketSuggestionResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BasketSuggestionResult copyWith({
    Object? bestSuggestion = _Undefined,
    Object? otherSuggestions = _Undefined,
    List<_i2.BasketSuggestion>? suggestions,
  }) {
    return BasketSuggestionResult(
      bestSuggestion: bestSuggestion is _i2.BasketSuggestion?
          ? bestSuggestion
          : this.bestSuggestion?.copyWith(),
      otherSuggestions: otherSuggestions is List<_i2.BasketSuggestion>?
          ? otherSuggestions
          : this.otherSuggestions?.map((e0) => e0.copyWith()).toList(),
      suggestions:
          suggestions ?? this.suggestions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
