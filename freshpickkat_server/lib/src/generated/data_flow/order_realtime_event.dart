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

abstract class OrderRealtimeEvent
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  OrderRealtimeEvent._({
    required this.eventType,
    required this.orderId,
    this.status,
    this.userId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory OrderRealtimeEvent({
    required String eventType,
    required String orderId,
    String? status,
    String? userId,
    DateTime? createdAt,
  }) = _OrderRealtimeEventImpl;

  factory OrderRealtimeEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderRealtimeEvent(
      eventType: jsonSerialization['eventType'] as String,
      orderId: jsonSerialization['orderId'] as String,
      status: jsonSerialization['status'] as String?,
      userId: jsonSerialization['userId'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  String eventType;

  String orderId;

  String? status;

  String? userId;

  DateTime createdAt;

  /// Returns a shallow copy of this [OrderRealtimeEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderRealtimeEvent copyWith({
    String? eventType,
    String? orderId,
    String? status,
    String? userId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderRealtimeEvent',
      'eventType': eventType,
      'orderId': orderId,
      if (status != null) 'status': status,
      if (userId != null) 'userId': userId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OrderRealtimeEvent',
      'eventType': eventType,
      'orderId': orderId,
      if (status != null) 'status': status,
      if (userId != null) 'userId': userId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderRealtimeEventImpl extends OrderRealtimeEvent {
  _OrderRealtimeEventImpl({
    required String eventType,
    required String orderId,
    String? status,
    String? userId,
    DateTime? createdAt,
  }) : super._(
         eventType: eventType,
         orderId: orderId,
         status: status,
         userId: userId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [OrderRealtimeEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderRealtimeEvent copyWith({
    String? eventType,
    String? orderId,
    Object? status = _Undefined,
    Object? userId = _Undefined,
    DateTime? createdAt,
  }) {
    return OrderRealtimeEvent(
      eventType: eventType ?? this.eventType,
      orderId: orderId ?? this.orderId,
      status: status is String? ? status : this.status,
      userId: userId is String? ? userId : this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
