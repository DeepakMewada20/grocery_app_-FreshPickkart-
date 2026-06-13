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
import '../data_flow/order.dart' as _i2;
import '../data_flow/refund_record.dart' as _i3;
import '../data_flow/complaint.dart' as _i4;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i5;

abstract class OrderDetailHydrated implements _i1.SerializableModel {
  OrderDetailHydrated._({
    this.order,
    this.refund,
    this.activeProductComplaint,
    this.activeDeliveryComplaint,
  });

  factory OrderDetailHydrated({
    _i2.Order? order,
    _i3.RefundRecord? refund,
    _i4.Complaint? activeProductComplaint,
    _i4.Complaint? activeDeliveryComplaint,
  }) = _OrderDetailHydratedImpl;

  factory OrderDetailHydrated.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderDetailHydrated(
      order: jsonSerialization['order'] == null
          ? null
          : _i5.Protocol().deserialize<_i2.Order>(jsonSerialization['order']),
      refund: jsonSerialization['refund'] == null
          ? null
          : _i5.Protocol().deserialize<_i3.RefundRecord>(
              jsonSerialization['refund'],
            ),
      activeProductComplaint:
          jsonSerialization['activeProductComplaint'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.Complaint>(
              jsonSerialization['activeProductComplaint'],
            ),
      activeDeliveryComplaint:
          jsonSerialization['activeDeliveryComplaint'] == null
          ? null
          : _i5.Protocol().deserialize<_i4.Complaint>(
              jsonSerialization['activeDeliveryComplaint'],
            ),
    );
  }

  _i2.Order? order;

  _i3.RefundRecord? refund;

  _i4.Complaint? activeProductComplaint;

  _i4.Complaint? activeDeliveryComplaint;

  /// Returns a shallow copy of this [OrderDetailHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderDetailHydrated copyWith({
    _i2.Order? order,
    _i3.RefundRecord? refund,
    _i4.Complaint? activeProductComplaint,
    _i4.Complaint? activeDeliveryComplaint,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderDetailHydrated',
      if (order != null) 'order': order?.toJson(),
      if (refund != null) 'refund': refund?.toJson(),
      if (activeProductComplaint != null)
        'activeProductComplaint': activeProductComplaint?.toJson(),
      if (activeDeliveryComplaint != null)
        'activeDeliveryComplaint': activeDeliveryComplaint?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderDetailHydratedImpl extends OrderDetailHydrated {
  _OrderDetailHydratedImpl({
    _i2.Order? order,
    _i3.RefundRecord? refund,
    _i4.Complaint? activeProductComplaint,
    _i4.Complaint? activeDeliveryComplaint,
  }) : super._(
         order: order,
         refund: refund,
         activeProductComplaint: activeProductComplaint,
         activeDeliveryComplaint: activeDeliveryComplaint,
       );

  /// Returns a shallow copy of this [OrderDetailHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderDetailHydrated copyWith({
    Object? order = _Undefined,
    Object? refund = _Undefined,
    Object? activeProductComplaint = _Undefined,
    Object? activeDeliveryComplaint = _Undefined,
  }) {
    return OrderDetailHydrated(
      order: order is _i2.Order? ? order : this.order?.copyWith(),
      refund: refund is _i3.RefundRecord? ? refund : this.refund?.copyWith(),
      activeProductComplaint: activeProductComplaint is _i4.Complaint?
          ? activeProductComplaint
          : this.activeProductComplaint?.copyWith(),
      activeDeliveryComplaint: activeDeliveryComplaint is _i4.Complaint?
          ? activeDeliveryComplaint
          : this.activeDeliveryComplaint?.copyWith(),
    );
  }
}
