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
import 'basket_suggestion.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class BasketSuggestionResult implements _i1.SerializableModel {
  BasketSuggestionResult._({required this.suggestions});

  factory BasketSuggestionResult({
    required List<_i2.BasketSuggestion> suggestions,
  }) = _BasketSuggestionResultImpl;

  factory BasketSuggestionResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return BasketSuggestionResult(
      suggestions: _i3.Protocol().deserialize<List<_i2.BasketSuggestion>>(
        jsonSerialization['suggestions'],
      ),
    );
  }

  List<_i2.BasketSuggestion> suggestions;

  /// Returns a shallow copy of this [BasketSuggestionResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BasketSuggestionResult copyWith({List<_i2.BasketSuggestion>? suggestions});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BasketSuggestionResult',
      'suggestions': suggestions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _BasketSuggestionResultImpl extends BasketSuggestionResult {
  _BasketSuggestionResultImpl({required List<_i2.BasketSuggestion> suggestions})
    : super._(suggestions: suggestions);

  /// Returns a shallow copy of this [BasketSuggestionResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BasketSuggestionResult copyWith({List<_i2.BasketSuggestion>? suggestions}) {
    return BasketSuggestionResult(
      suggestions:
          suggestions ?? this.suggestions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
