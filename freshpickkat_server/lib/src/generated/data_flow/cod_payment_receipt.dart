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

abstract class CodPaymentReceipt
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CodPaymentReceipt._({
    required this.orderNumber,
    required this.paymentMethod,
    required this.collectionMethod,
    required this.amountCollected,
    this.collectionTime,
    this.collectedBy,
    required this.paymentStatus,
    this.gatewayTransactionReference,
  });

  factory CodPaymentReceipt({
    required String orderNumber,
    required String paymentMethod,
    required String collectionMethod,
    required double amountCollected,
    DateTime? collectionTime,
    String? collectedBy,
    required String paymentStatus,
    String? gatewayTransactionReference,
  }) = _CodPaymentReceiptImpl;

  factory CodPaymentReceipt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CodPaymentReceipt(
      orderNumber: jsonSerialization['orderNumber'] as String,
      paymentMethod: jsonSerialization['paymentMethod'] as String,
      collectionMethod: jsonSerialization['collectionMethod'] as String,
      amountCollected: (jsonSerialization['amountCollected'] as num).toDouble(),
      collectionTime: jsonSerialization['collectionTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['collectionTime'],
            ),
      collectedBy: jsonSerialization['collectedBy'] as String?,
      paymentStatus: jsonSerialization['paymentStatus'] as String,
      gatewayTransactionReference:
          jsonSerialization['gatewayTransactionReference'] as String?,
    );
  }

  String orderNumber;

  String paymentMethod;

  String collectionMethod;

  double amountCollected;

  DateTime? collectionTime;

  String? collectedBy;

  String paymentStatus;

  String? gatewayTransactionReference;

  /// Returns a shallow copy of this [CodPaymentReceipt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CodPaymentReceipt copyWith({
    String? orderNumber,
    String? paymentMethod,
    String? collectionMethod,
    double? amountCollected,
    DateTime? collectionTime,
    String? collectedBy,
    String? paymentStatus,
    String? gatewayTransactionReference,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CodPaymentReceipt',
      'orderNumber': orderNumber,
      'paymentMethod': paymentMethod,
      'collectionMethod': collectionMethod,
      'amountCollected': amountCollected,
      if (collectionTime != null) 'collectionTime': collectionTime?.toJson(),
      if (collectedBy != null) 'collectedBy': collectedBy,
      'paymentStatus': paymentStatus,
      if (gatewayTransactionReference != null)
        'gatewayTransactionReference': gatewayTransactionReference,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CodPaymentReceipt',
      'orderNumber': orderNumber,
      'paymentMethod': paymentMethod,
      'collectionMethod': collectionMethod,
      'amountCollected': amountCollected,
      if (collectionTime != null) 'collectionTime': collectionTime?.toJson(),
      if (collectedBy != null) 'collectedBy': collectedBy,
      'paymentStatus': paymentStatus,
      if (gatewayTransactionReference != null)
        'gatewayTransactionReference': gatewayTransactionReference,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CodPaymentReceiptImpl extends CodPaymentReceipt {
  _CodPaymentReceiptImpl({
    required String orderNumber,
    required String paymentMethod,
    required String collectionMethod,
    required double amountCollected,
    DateTime? collectionTime,
    String? collectedBy,
    required String paymentStatus,
    String? gatewayTransactionReference,
  }) : super._(
         orderNumber: orderNumber,
         paymentMethod: paymentMethod,
         collectionMethod: collectionMethod,
         amountCollected: amountCollected,
         collectionTime: collectionTime,
         collectedBy: collectedBy,
         paymentStatus: paymentStatus,
         gatewayTransactionReference: gatewayTransactionReference,
       );

  /// Returns a shallow copy of this [CodPaymentReceipt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CodPaymentReceipt copyWith({
    String? orderNumber,
    String? paymentMethod,
    String? collectionMethod,
    double? amountCollected,
    Object? collectionTime = _Undefined,
    Object? collectedBy = _Undefined,
    String? paymentStatus,
    Object? gatewayTransactionReference = _Undefined,
  }) {
    return CodPaymentReceipt(
      orderNumber: orderNumber ?? this.orderNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      collectionMethod: collectionMethod ?? this.collectionMethod,
      amountCollected: amountCollected ?? this.amountCollected,
      collectionTime: collectionTime is DateTime?
          ? collectionTime
          : this.collectionTime,
      collectedBy: collectedBy is String? ? collectedBy : this.collectedBy,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      gatewayTransactionReference: gatewayTransactionReference is String?
          ? gatewayTransactionReference
          : this.gatewayTransactionReference,
    );
  }
}
