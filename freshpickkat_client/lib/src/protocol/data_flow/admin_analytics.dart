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
import '../data_flow/admin_top_product.dart' as _i2;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i3;

abstract class AdminAnalytics implements _i1.SerializableModel {
  AdminAnalytics._({
    required this.cancellationRate,
    required this.lowStockCount,
    required this.topProducts,
    double? codSuccessRate,
    this.codRejectionReasonDistribution,
  }) : codSuccessRate = codSuccessRate ?? 0.0;

  factory AdminAnalytics({
    required double cancellationRate,
    required int lowStockCount,
    required List<_i2.AdminTopProduct> topProducts,
    double? codSuccessRate,
    String? codRejectionReasonDistribution,
  }) = _AdminAnalyticsImpl;

  factory AdminAnalytics.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminAnalytics(
      cancellationRate: (jsonSerialization['cancellationRate'] as num)
          .toDouble(),
      lowStockCount: jsonSerialization['lowStockCount'] as int,
      topProducts: _i3.Protocol().deserialize<List<_i2.AdminTopProduct>>(
        jsonSerialization['topProducts'],
      ),
      codSuccessRate: (jsonSerialization['codSuccessRate'] as num?)?.toDouble(),
      codRejectionReasonDistribution:
          jsonSerialization['codRejectionReasonDistribution'] as String?,
    );
  }

  double cancellationRate;

  int lowStockCount;

  List<_i2.AdminTopProduct> topProducts;

  double codSuccessRate;

  String? codRejectionReasonDistribution;

  /// Returns a shallow copy of this [AdminAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminAnalytics copyWith({
    double? cancellationRate,
    int? lowStockCount,
    List<_i2.AdminTopProduct>? topProducts,
    double? codSuccessRate,
    String? codRejectionReasonDistribution,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminAnalytics',
      'cancellationRate': cancellationRate,
      'lowStockCount': lowStockCount,
      'topProducts': topProducts.toJson(valueToJson: (v) => v.toJson()),
      'codSuccessRate': codSuccessRate,
      if (codRejectionReasonDistribution != null)
        'codRejectionReasonDistribution': codRejectionReasonDistribution,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdminAnalyticsImpl extends AdminAnalytics {
  _AdminAnalyticsImpl({
    required double cancellationRate,
    required int lowStockCount,
    required List<_i2.AdminTopProduct> topProducts,
    double? codSuccessRate,
    String? codRejectionReasonDistribution,
  }) : super._(
         cancellationRate: cancellationRate,
         lowStockCount: lowStockCount,
         topProducts: topProducts,
         codSuccessRate: codSuccessRate,
         codRejectionReasonDistribution: codRejectionReasonDistribution,
       );

  /// Returns a shallow copy of this [AdminAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminAnalytics copyWith({
    double? cancellationRate,
    int? lowStockCount,
    List<_i2.AdminTopProduct>? topProducts,
    double? codSuccessRate,
    Object? codRejectionReasonDistribution = _Undefined,
  }) {
    return AdminAnalytics(
      cancellationRate: cancellationRate ?? this.cancellationRate,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      topProducts:
          topProducts ?? this.topProducts.map((e0) => e0.copyWith()).toList(),
      codSuccessRate: codSuccessRate ?? this.codSuccessRate,
      codRejectionReasonDistribution: codRejectionReasonDistribution is String?
          ? codRejectionReasonDistribution
          : this.codRejectionReasonDistribution,
    );
  }
}
