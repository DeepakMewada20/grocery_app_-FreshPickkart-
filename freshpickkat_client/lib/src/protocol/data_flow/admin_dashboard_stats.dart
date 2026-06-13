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

abstract class AdminDashboardStats implements _i1.SerializableModel {
  AdminDashboardStats._({
    required this.todayOrders,
    required this.todayRevenue,
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalUsers,
    required this.pendingOrders,
    required this.confirmedOrders,
    required this.outForDeliveryOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
  });

  factory AdminDashboardStats({
    required int todayOrders,
    required double todayRevenue,
    required int totalOrders,
    required double totalRevenue,
    required int totalUsers,
    required int pendingOrders,
    required int confirmedOrders,
    required int outForDeliveryOrders,
    required int deliveredOrders,
    required int cancelledOrders,
  }) = _AdminDashboardStatsImpl;

  factory AdminDashboardStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return AdminDashboardStats(
      todayOrders: jsonSerialization['todayOrders'] as int,
      todayRevenue: (jsonSerialization['todayRevenue'] as num).toDouble(),
      totalOrders: jsonSerialization['totalOrders'] as int,
      totalRevenue: (jsonSerialization['totalRevenue'] as num).toDouble(),
      totalUsers: jsonSerialization['totalUsers'] as int,
      pendingOrders: jsonSerialization['pendingOrders'] as int,
      confirmedOrders: jsonSerialization['confirmedOrders'] as int,
      outForDeliveryOrders: jsonSerialization['outForDeliveryOrders'] as int,
      deliveredOrders: jsonSerialization['deliveredOrders'] as int,
      cancelledOrders: jsonSerialization['cancelledOrders'] as int,
    );
  }

  int todayOrders;

  double todayRevenue;

  int totalOrders;

  double totalRevenue;

  int totalUsers;

  int pendingOrders;

  int confirmedOrders;

  int outForDeliveryOrders;

  int deliveredOrders;

  int cancelledOrders;

  /// Returns a shallow copy of this [AdminDashboardStats]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AdminDashboardStats copyWith({
    int? todayOrders,
    double? todayRevenue,
    int? totalOrders,
    double? totalRevenue,
    int? totalUsers,
    int? pendingOrders,
    int? confirmedOrders,
    int? outForDeliveryOrders,
    int? deliveredOrders,
    int? cancelledOrders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AdminDashboardStats',
      'todayOrders': todayOrders,
      'todayRevenue': todayRevenue,
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'totalUsers': totalUsers,
      'pendingOrders': pendingOrders,
      'confirmedOrders': confirmedOrders,
      'outForDeliveryOrders': outForDeliveryOrders,
      'deliveredOrders': deliveredOrders,
      'cancelledOrders': cancelledOrders,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AdminDashboardStatsImpl extends AdminDashboardStats {
  _AdminDashboardStatsImpl({
    required int todayOrders,
    required double todayRevenue,
    required int totalOrders,
    required double totalRevenue,
    required int totalUsers,
    required int pendingOrders,
    required int confirmedOrders,
    required int outForDeliveryOrders,
    required int deliveredOrders,
    required int cancelledOrders,
  }) : super._(
         todayOrders: todayOrders,
         todayRevenue: todayRevenue,
         totalOrders: totalOrders,
         totalRevenue: totalRevenue,
         totalUsers: totalUsers,
         pendingOrders: pendingOrders,
         confirmedOrders: confirmedOrders,
         outForDeliveryOrders: outForDeliveryOrders,
         deliveredOrders: deliveredOrders,
         cancelledOrders: cancelledOrders,
       );

  /// Returns a shallow copy of this [AdminDashboardStats]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AdminDashboardStats copyWith({
    int? todayOrders,
    double? todayRevenue,
    int? totalOrders,
    double? totalRevenue,
    int? totalUsers,
    int? pendingOrders,
    int? confirmedOrders,
    int? outForDeliveryOrders,
    int? deliveredOrders,
    int? cancelledOrders,
  }) {
    return AdminDashboardStats(
      todayOrders: todayOrders ?? this.todayOrders,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      totalOrders: totalOrders ?? this.totalOrders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalUsers: totalUsers ?? this.totalUsers,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      confirmedOrders: confirmedOrders ?? this.confirmedOrders,
      outForDeliveryOrders: outForDeliveryOrders ?? this.outForDeliveryOrders,
      deliveredOrders: deliveredOrders ?? this.deliveredOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
    );
  }
}
