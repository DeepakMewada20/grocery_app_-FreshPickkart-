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

abstract class ActiveUserStatistics
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ActiveUserStatistics._({
    required this.userId,
    this.name,
    required this.phoneNumber,
    this.email,
    required this.totalOrdersCount,
    required this.totalSpent,
    this.lastOrderDate,
    required this.status,
  });

  factory ActiveUserStatistics({
    required String userId,
    String? name,
    required String phoneNumber,
    String? email,
    required int totalOrdersCount,
    required double totalSpent,
    DateTime? lastOrderDate,
    required String status,
  }) = _ActiveUserStatisticsImpl;

  factory ActiveUserStatistics.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ActiveUserStatistics(
      userId: jsonSerialization['userId'] as String,
      name: jsonSerialization['name'] as String?,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      email: jsonSerialization['email'] as String?,
      totalOrdersCount: jsonSerialization['totalOrdersCount'] as int,
      totalSpent: (jsonSerialization['totalSpent'] as num).toDouble(),
      lastOrderDate: jsonSerialization['lastOrderDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastOrderDate'],
            ),
      status: jsonSerialization['status'] as String,
    );
  }

  String userId;

  String? name;

  String phoneNumber;

  String? email;

  int totalOrdersCount;

  double totalSpent;

  DateTime? lastOrderDate;

  String status;

  /// Returns a shallow copy of this [ActiveUserStatistics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActiveUserStatistics copyWith({
    String? userId,
    String? name,
    String? phoneNumber,
    String? email,
    int? totalOrdersCount,
    double? totalSpent,
    DateTime? lastOrderDate,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ActiveUserStatistics',
      'userId': userId,
      if (name != null) 'name': name,
      'phoneNumber': phoneNumber,
      if (email != null) 'email': email,
      'totalOrdersCount': totalOrdersCount,
      'totalSpent': totalSpent,
      if (lastOrderDate != null) 'lastOrderDate': lastOrderDate?.toJson(),
      'status': status,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ActiveUserStatistics',
      'userId': userId,
      if (name != null) 'name': name,
      'phoneNumber': phoneNumber,
      if (email != null) 'email': email,
      'totalOrdersCount': totalOrdersCount,
      'totalSpent': totalSpent,
      if (lastOrderDate != null) 'lastOrderDate': lastOrderDate?.toJson(),
      'status': status,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActiveUserStatisticsImpl extends ActiveUserStatistics {
  _ActiveUserStatisticsImpl({
    required String userId,
    String? name,
    required String phoneNumber,
    String? email,
    required int totalOrdersCount,
    required double totalSpent,
    DateTime? lastOrderDate,
    required String status,
  }) : super._(
         userId: userId,
         name: name,
         phoneNumber: phoneNumber,
         email: email,
         totalOrdersCount: totalOrdersCount,
         totalSpent: totalSpent,
         lastOrderDate: lastOrderDate,
         status: status,
       );

  /// Returns a shallow copy of this [ActiveUserStatistics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActiveUserStatistics copyWith({
    String? userId,
    Object? name = _Undefined,
    String? phoneNumber,
    Object? email = _Undefined,
    int? totalOrdersCount,
    double? totalSpent,
    Object? lastOrderDate = _Undefined,
    String? status,
  }) {
    return ActiveUserStatistics(
      userId: userId ?? this.userId,
      name: name is String? ? name : this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email is String? ? email : this.email,
      totalOrdersCount: totalOrdersCount ?? this.totalOrdersCount,
      totalSpent: totalSpent ?? this.totalSpent,
      lastOrderDate: lastOrderDate is DateTime?
          ? lastOrderDate
          : this.lastOrderDate,
      status: status ?? this.status,
    );
  }
}
