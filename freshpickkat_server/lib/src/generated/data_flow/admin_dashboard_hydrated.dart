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
import '../data_flow/admin_dashboard_stats.dart' as _i2;
import '../data_flow/admin_analytics.dart' as _i3;
import '../data_flow/smgm_analytics.dart' as _i4;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i5;

abstract class AdminDashboardHydrated
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  AdminDashboardHydrated._({
    required this.stats,
    required this.analytics,
    required this.smgmAnalytics,
  });

  factory AdminDashboardHydrated({
    required _i2.AdminDashboardStats stats,
    required _i3.AdminAnalytics analytics,
    required _i4.SmgmAnalytics smgmAnalytics,
  }) = _AdminDashboardHydratedImpl;

  factory AdminDashboardHydrated.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AdminDashboardHydrated(
      stats: _i5.Protocol().deserialize<_i2.AdminDashboardStats>(
        jsonSerialization['stats'],
      ),
      analytics: _i5.Protocol().deserialize<_i3.AdminAnalytics>(
        jsonSerialization['analytics'],
      ),
      smgmAnalytics: _i5.Protocol().deserialize<_i4.SmgmAnalytics>(
        jsonSerialization['smgmAnalytics'],
      ),
    );
  }

  _i2.AdminDashboardStats stats;

  _i3.AdminAnalytics analytics;

  _i4.SmgmAnalytics smgmAnalytics;

  /// Returns a shallow copy of this [AdminDashboardHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminDashboardHydrated copyWith({
    _i2.AdminDashboardStats? stats,
    _i3.AdminAnalytics? analytics,
    _i4.SmgmAnalytics? smgmAnalytics,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminDashboardHydrated',
      'stats': stats.toJson(),
      'analytics': analytics.toJson(),
      'smgmAnalytics': smgmAnalytics.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AdminDashboardHydrated',
      'stats': stats.toJsonForProtocol(),
      'analytics': analytics.toJsonForProtocol(),
      'smgmAnalytics': smgmAnalytics.toJsonForProtocol(),
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
    required _i4.SmgmAnalytics smgmAnalytics,
  }) : super._(
         stats: stats,
         analytics: analytics,
         smgmAnalytics: smgmAnalytics,
       );

  /// Returns a shallow copy of this [AdminDashboardHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminDashboardHydrated copyWith({
    _i2.AdminDashboardStats? stats,
    _i3.AdminAnalytics? analytics,
    _i4.SmgmAnalytics? smgmAnalytics,
  }) {
    return AdminDashboardHydrated(
      stats: stats ?? this.stats.copyWith(),
      analytics: analytics ?? this.analytics.copyWith(),
      smgmAnalytics: smgmAnalytics ?? this.smgmAnalytics.copyWith(),
    );
  }
}
