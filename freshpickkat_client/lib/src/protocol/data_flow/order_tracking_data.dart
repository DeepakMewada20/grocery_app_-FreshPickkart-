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

abstract class OrderTrackingData implements _i1.SerializableModel {
  OrderTrackingData._({
    required this.orderId,
    required this.status,
    required this.trackingEnabled,
    this.userLatitude,
    this.userLongitude,
    this.userAddress,
    this.userLocationType,
    this.riderLatitude,
    this.riderLongitude,
    this.updatedAt,
  });

  factory OrderTrackingData({
    required String orderId,
    required String status,
    required bool trackingEnabled,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
    double? riderLatitude,
    double? riderLongitude,
    DateTime? updatedAt,
  }) = _OrderTrackingDataImpl;

  factory OrderTrackingData.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderTrackingData(
      orderId: jsonSerialization['orderId'] as String,
      status: jsonSerialization['status'] as String,
      trackingEnabled: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['trackingEnabled'],
      ),
      userLatitude: (jsonSerialization['userLatitude'] as num?)?.toDouble(),
      userLongitude: (jsonSerialization['userLongitude'] as num?)?.toDouble(),
      userAddress: jsonSerialization['userAddress'] as String?,
      userLocationType: jsonSerialization['userLocationType'] as String?,
      riderLatitude: (jsonSerialization['riderLatitude'] as num?)?.toDouble(),
      riderLongitude: (jsonSerialization['riderLongitude'] as num?)?.toDouble(),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  String orderId;

  String status;

  bool trackingEnabled;

  double? userLatitude;

  double? userLongitude;

  String? userAddress;

  String? userLocationType;

  double? riderLatitude;

  double? riderLongitude;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [OrderTrackingData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderTrackingData copyWith({
    String? orderId,
    String? status,
    bool? trackingEnabled,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
    double? riderLatitude,
    double? riderLongitude,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderTrackingData',
      'orderId': orderId,
      'status': status,
      'trackingEnabled': trackingEnabled,
      if (userLatitude != null) 'userLatitude': userLatitude,
      if (userLongitude != null) 'userLongitude': userLongitude,
      if (userAddress != null) 'userAddress': userAddress,
      if (userLocationType != null) 'userLocationType': userLocationType,
      if (riderLatitude != null) 'riderLatitude': riderLatitude,
      if (riderLongitude != null) 'riderLongitude': riderLongitude,
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderTrackingDataImpl extends OrderTrackingData {
  _OrderTrackingDataImpl({
    required String orderId,
    required String status,
    required bool trackingEnabled,
    double? userLatitude,
    double? userLongitude,
    String? userAddress,
    String? userLocationType,
    double? riderLatitude,
    double? riderLongitude,
    DateTime? updatedAt,
  }) : super._(
         orderId: orderId,
         status: status,
         trackingEnabled: trackingEnabled,
         userLatitude: userLatitude,
         userLongitude: userLongitude,
         userAddress: userAddress,
         userLocationType: userLocationType,
         riderLatitude: riderLatitude,
         riderLongitude: riderLongitude,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [OrderTrackingData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderTrackingData copyWith({
    String? orderId,
    String? status,
    bool? trackingEnabled,
    Object? userLatitude = _Undefined,
    Object? userLongitude = _Undefined,
    Object? userAddress = _Undefined,
    Object? userLocationType = _Undefined,
    Object? riderLatitude = _Undefined,
    Object? riderLongitude = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return OrderTrackingData(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      trackingEnabled: trackingEnabled ?? this.trackingEnabled,
      userLatitude: userLatitude is double? ? userLatitude : this.userLatitude,
      userLongitude: userLongitude is double?
          ? userLongitude
          : this.userLongitude,
      userAddress: userAddress is String? ? userAddress : this.userAddress,
      userLocationType: userLocationType is String?
          ? userLocationType
          : this.userLocationType,
      riderLatitude: riderLatitude is double?
          ? riderLatitude
          : this.riderLatitude,
      riderLongitude: riderLongitude is double?
          ? riderLongitude
          : this.riderLongitude,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
