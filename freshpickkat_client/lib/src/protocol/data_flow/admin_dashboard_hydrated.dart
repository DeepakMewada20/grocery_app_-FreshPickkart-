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
import '../data_flow/admin_dashboard_stats.dart' as _i2;
import '../data_flow/admin_analytics.dart' as _i3;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i4;

abstract class AdminDashboardHydrated implements _i1.SerializableModel {
  AdminDashboardHydrated._({
    required this.stats,
    required this.analytics,
  });

  factory AdminDashboardHydrated({
    required _i2.AdminDashboardStats stats,
    required _i3.AdminAnalytics analytics,
  }) = _AdminDashboardHydratedImpl;

  factory AdminDashboardHydrated.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminDashboardHydrated(
      stats: _i4.Protocol().deserialize<_i2.AdminDashboardStats>(
        jsonSerialization['stats'],
      ),
      analytics: _i4.Protocol().deserialize<_i3.AdminAnalytics>(
        jsonSerialization['analytics'],
      ),
    );
  }

  _i2.AdminDashboardStats stats;

  _i3.AdminAnalytics analytics;

  /// Returns a shallow copy of this [AdminDashboardHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminDashboardHydrated copyWith({
    _i2.AdminDashboardStats? stats,
    _i3.AdminAnalytics? analytics,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminDashboardHydrated',
      'stats': stats.toJson(),
      'analytics': analytics.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AdminDashboardHydratedImpl extends AdminDashboardHydrated {
  _AdminDashboardHydratedImpl({
    required _i2.AdminDashboardStats stats,
    required _i3.AdminAnalytics analytics,
  }) : super._(
         stats: stats,
         analytics: analytics,
       );

  /// Returns a shallow copy of this [AdminDashboardHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminDashboardHydrated copyWith({
    _i2.AdminDashboardStats? stats,
    _i3.AdminAnalytics? analytics,
  }) {
    return AdminDashboardHydrated(
      stats: stats ?? this.stats.copyWith(),
      analytics: analytics ?? this.analytics.copyWith(),
    );
  }
}
