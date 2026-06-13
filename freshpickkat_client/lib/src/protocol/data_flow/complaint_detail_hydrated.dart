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
import '../data_flow/complaint.dart' as _i2;
import '../data_flow/refund_record.dart' as _i3;
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i4;

abstract class ComplaintDetailHydrated implements _i1.SerializableModel {
  ComplaintDetailHydrated._({
    required this.complaint,
    this.refund,
  });

  factory ComplaintDetailHydrated({
    required _i2.Complaint complaint,
    _i3.RefundRecord? refund,
  }) = _ComplaintDetailHydratedImpl;

  factory ComplaintDetailHydrated.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ComplaintDetailHydrated(
      complaint: _i4.Protocol().deserialize<_i2.Complaint>(
        jsonSerialization['complaint'],
      ),
      refund: jsonSerialization['refund'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.RefundRecord>(
              jsonSerialization['refund'],
            ),
    );
  }

  _i2.Complaint complaint;

  _i3.RefundRecord? refund;

  /// Returns a shallow copy of this [ComplaintDetailHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ComplaintDetailHydrated copyWith({
    _i2.Complaint? complaint,
    _i3.RefundRecord? refund,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ComplaintDetailHydrated',
      'complaint': complaint.toJson(),
      if (refund != null) 'refund': refund?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComplaintDetailHydratedImpl extends ComplaintDetailHydrated {
  _ComplaintDetailHydratedImpl({
    required _i2.Complaint complaint,
    _i3.RefundRecord? refund,
  }) : super._(
         complaint: complaint,
         refund: refund,
       );

  /// Returns a shallow copy of this [ComplaintDetailHydrated]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ComplaintDetailHydrated copyWith({
    _i2.Complaint? complaint,
    Object? refund = _Undefined,
  }) {
    return ComplaintDetailHydrated(
      complaint: complaint ?? this.complaint.copyWith(),
      refund: refund is _i3.RefundRecord? ? refund : this.refund?.copyWith(),
    );
  }
}
