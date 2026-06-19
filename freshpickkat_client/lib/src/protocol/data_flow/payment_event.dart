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

abstract class PaymentEvent implements _i1.SerializableModel {
  PaymentEvent._({
    required this.eventType,
    required this.orderId,
    required this.paymentStatus,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PaymentEvent({
    required String eventType,
    required String orderId,
    required String paymentStatus,
    DateTime? createdAt,
  }) = _PaymentEventImpl;

  factory PaymentEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentEvent(
      eventType: jsonSerialization['eventType'] as String,
      orderId: jsonSerialization['orderId'] as String,
      paymentStatus: jsonSerialization['paymentStatus'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  String eventType;

  String orderId;

  String paymentStatus;

  DateTime createdAt;

  /// Returns a shallow copy of this [PaymentEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentEvent copyWith({
    String? eventType,
    String? orderId,
    String? paymentStatus,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaymentEvent',
      'eventType': eventType,
      'orderId': orderId,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PaymentEventImpl extends PaymentEvent {
  _PaymentEventImpl({
    required String eventType,
    required String orderId,
    required String paymentStatus,
    DateTime? createdAt,
  }) : super._(
         eventType: eventType,
         orderId: orderId,
         paymentStatus: paymentStatus,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PaymentEvent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaymentEvent copyWith({
    String? eventType,
    String? orderId,
    String? paymentStatus,
    DateTime? createdAt,
  }) {
    return PaymentEvent(
      eventType: eventType ?? this.eventType,
      orderId: orderId ?? this.orderId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
