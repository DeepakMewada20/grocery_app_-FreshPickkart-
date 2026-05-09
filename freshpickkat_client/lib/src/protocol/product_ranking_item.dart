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
import 'product.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class ProductRankingItem implements _i1.SerializableModel {
  ProductRankingItem._({
    required this.product,
    required this.rank,
    required this.metricType,
    required this.metricValue,
    required this.last7DaysSold,
    required this.last7DaysViews,
    required this.reorderCount,
    required this.trendingScore,
  });

  factory ProductRankingItem({
    required _i2.Product product,
    required int rank,
    required String metricType,
    required double metricValue,
    required int last7DaysSold,
    required int last7DaysViews,
    required int reorderCount,
    required double trendingScore,
  }) = _ProductRankingItemImpl;

  factory ProductRankingItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductRankingItem(
      product: _i3.Protocol().deserialize<_i2.Product>(
        jsonSerialization['product'],
      ),
      rank: jsonSerialization['rank'] as int,
      metricType: jsonSerialization['metricType'] as String,
      metricValue: (jsonSerialization['metricValue'] as num).toDouble(),
      last7DaysSold: jsonSerialization['last7DaysSold'] as int,
      last7DaysViews: jsonSerialization['last7DaysViews'] as int,
      reorderCount: jsonSerialization['reorderCount'] as int,
      trendingScore: (jsonSerialization['trendingScore'] as num).toDouble(),
    );
  }

  _i2.Product product;

  int rank;

  String metricType;

  double metricValue;

  int last7DaysSold;

  int last7DaysViews;

  int reorderCount;

  double trendingScore;

  /// Returns a shallow copy of this [ProductRankingItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProductRankingItem copyWith({
    _i2.Product? product,
    int? rank,
    String? metricType,
    double? metricValue,
    int? last7DaysSold,
    int? last7DaysViews,
    int? reorderCount,
    double? trendingScore,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductRankingItem',
      'product': product.toJson(),
      'rank': rank,
      'metricType': metricType,
      'metricValue': metricValue,
      'last7DaysSold': last7DaysSold,
      'last7DaysViews': last7DaysViews,
      'reorderCount': reorderCount,
      'trendingScore': trendingScore,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ProductRankingItemImpl extends ProductRankingItem {
  _ProductRankingItemImpl({
    required _i2.Product product,
    required int rank,
    required String metricType,
    required double metricValue,
    required int last7DaysSold,
    required int last7DaysViews,
    required int reorderCount,
    required double trendingScore,
  }) : super._(
         product: product,
         rank: rank,
         metricType: metricType,
         metricValue: metricValue,
         last7DaysSold: last7DaysSold,
         last7DaysViews: last7DaysViews,
         reorderCount: reorderCount,
         trendingScore: trendingScore,
       );

  /// Returns a shallow copy of this [ProductRankingItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProductRankingItem copyWith({
    _i2.Product? product,
    int? rank,
    String? metricType,
    double? metricValue,
    int? last7DaysSold,
    int? last7DaysViews,
    int? reorderCount,
    double? trendingScore,
  }) {
    return ProductRankingItem(
      product: product ?? this.product.copyWith(),
      rank: rank ?? this.rank,
      metricType: metricType ?? this.metricType,
      metricValue: metricValue ?? this.metricValue,
      last7DaysSold: last7DaysSold ?? this.last7DaysSold,
      last7DaysViews: last7DaysViews ?? this.last7DaysViews,
      reorderCount: reorderCount ?? this.reorderCount,
      trendingScore: trendingScore ?? this.trendingScore,
    );
  }
}
