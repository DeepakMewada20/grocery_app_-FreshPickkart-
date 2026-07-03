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
    int? codOrdersPlaced,
    int? codOrdersDelivered,
    int? codOrdersRejected,
    double? codCollectedAmount,
    double? codUnpaidAmount,
    double? cashCollectionAmount,
    double? upiCollectionAmount,
  }) : codOrdersPlaced = codOrdersPlaced ?? 0,
       codOrdersDelivered = codOrdersDelivered ?? 0,
       codOrdersRejected = codOrdersRejected ?? 0,
       codCollectedAmount = codCollectedAmount ?? 0.0,
       codUnpaidAmount = codUnpaidAmount ?? 0.0,
       cashCollectionAmount = cashCollectionAmount ?? 0.0,
       upiCollectionAmount = upiCollectionAmount ?? 0.0;

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
    int? codOrdersPlaced,
    int? codOrdersDelivered,
    int? codOrdersRejected,
    double? codCollectedAmount,
    double? codUnpaidAmount,
    double? cashCollectionAmount,
    double? upiCollectionAmount,
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
      codOrdersPlaced: jsonSerialization['codOrdersPlaced'] as int?,
      codOrdersDelivered: jsonSerialization['codOrdersDelivered'] as int?,
      codOrdersRejected: jsonSerialization['codOrdersRejected'] as int?,
      codCollectedAmount: (jsonSerialization['codCollectedAmount'] as num?)
          ?.toDouble(),
      codUnpaidAmount: (jsonSerialization['codUnpaidAmount'] as num?)
          ?.toDouble(),
      cashCollectionAmount: (jsonSerialization['cashCollectionAmount'] as num?)
          ?.toDouble(),
      upiCollectionAmount: (jsonSerialization['upiCollectionAmount'] as num?)
          ?.toDouble(),
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

  int codOrdersPlaced;

  int codOrdersDelivered;

  int codOrdersRejected;

  double codCollectedAmount;

  double codUnpaidAmount;

  double cashCollectionAmount;

  double upiCollectionAmount;

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
    int? codOrdersPlaced,
    int? codOrdersDelivered,
    int? codOrdersRejected,
    double? codCollectedAmount,
    double? codUnpaidAmount,
    double? cashCollectionAmount,
    double? upiCollectionAmount,
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
      'codOrdersPlaced': codOrdersPlaced,
      'codOrdersDelivered': codOrdersDelivered,
      'codOrdersRejected': codOrdersRejected,
      'codCollectedAmount': codCollectedAmount,
      'codUnpaidAmount': codUnpaidAmount,
      'cashCollectionAmount': cashCollectionAmount,
      'upiCollectionAmount': upiCollectionAmount,
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
    int? codOrdersPlaced,
    int? codOrdersDelivered,
    int? codOrdersRejected,
    double? codCollectedAmount,
    double? codUnpaidAmount,
    double? cashCollectionAmount,
    double? upiCollectionAmount,
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
         codOrdersPlaced: codOrdersPlaced,
         codOrdersDelivered: codOrdersDelivered,
         codOrdersRejected: codOrdersRejected,
         codCollectedAmount: codCollectedAmount,
         codUnpaidAmount: codUnpaidAmount,
         cashCollectionAmount: cashCollectionAmount,
         upiCollectionAmount: upiCollectionAmount,
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
    int? codOrdersPlaced,
    int? codOrdersDelivered,
    int? codOrdersRejected,
    double? codCollectedAmount,
    double? codUnpaidAmount,
    double? cashCollectionAmount,
    double? upiCollectionAmount,
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
      codOrdersPlaced: codOrdersPlaced ?? this.codOrdersPlaced,
      codOrdersDelivered: codOrdersDelivered ?? this.codOrdersDelivered,
      codOrdersRejected: codOrdersRejected ?? this.codOrdersRejected,
      codCollectedAmount: codCollectedAmount ?? this.codCollectedAmount,
      codUnpaidAmount: codUnpaidAmount ?? this.codUnpaidAmount,
      cashCollectionAmount: cashCollectionAmount ?? this.cashCollectionAmount,
      upiCollectionAmount: upiCollectionAmount ?? this.upiCollectionAmount,
    );
  }
}
