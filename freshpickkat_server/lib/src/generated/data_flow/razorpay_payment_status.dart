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

abstract class RazorpayPaymentStatus
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RazorpayPaymentStatus._({
    this.id,
    this.status,
    this.amount,
    this.currency,
    this.orderId,
    this.method,
    this.captured,
    this.refundStatus,
    this.amountRefunded,
    this.fee,
    this.tax,
    this.bank,
    this.wallet,
    this.vpa,
    this.email,
    this.contact,
    this.cardId,
    this.acquirerData,
    this.description,
    this.notes,
    this.errorCode,
    this.errorDescription,
    this.createdAt,
    this.error,
    this.statusCode,
    this.body,
  });

  factory RazorpayPaymentStatus({
    String? id,
    String? status,
    int? amount,
    String? currency,
    String? orderId,
    String? method,
    bool? captured,
    String? refundStatus,
    int? amountRefunded,
    int? fee,
    int? tax,
    String? bank,
    String? wallet,
    String? vpa,
    String? email,
    String? contact,
    String? cardId,
    String? acquirerData,
    String? description,
    String? notes,
    String? errorCode,
    String? errorDescription,
    int? createdAt,
    String? error,
    int? statusCode,
    String? body,
  }) = _RazorpayPaymentStatusImpl;

  factory RazorpayPaymentStatus.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RazorpayPaymentStatus(
      id: jsonSerialization['id'] as String?,
      status: jsonSerialization['status'] as String?,
      amount: jsonSerialization['amount'] as int?,
      currency: jsonSerialization['currency'] as String?,
      orderId: jsonSerialization['orderId'] as String?,
      method: jsonSerialization['method'] as String?,
      captured: jsonSerialization['captured'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['captured']),
      refundStatus: jsonSerialization['refundStatus'] as String?,
      amountRefunded: jsonSerialization['amountRefunded'] as int?,
      fee: jsonSerialization['fee'] as int?,
      tax: jsonSerialization['tax'] as int?,
      bank: jsonSerialization['bank'] as String?,
      wallet: jsonSerialization['wallet'] as String?,
      vpa: jsonSerialization['vpa'] as String?,
      email: jsonSerialization['email'] as String?,
      contact: jsonSerialization['contact'] as String?,
      cardId: jsonSerialization['cardId'] as String?,
      acquirerData: jsonSerialization['acquirerData'] as String?,
      description: jsonSerialization['description'] as String?,
      notes: jsonSerialization['notes'] as String?,
      errorCode: jsonSerialization['errorCode'] as String?,
      errorDescription: jsonSerialization['errorDescription'] as String?,
      createdAt: jsonSerialization['createdAt'] as int?,
      error: jsonSerialization['error'] as String?,
      statusCode: jsonSerialization['statusCode'] as int?,
      body: jsonSerialization['body'] as String?,
    );
  }

  String? id;

  String? status;

  int? amount;

  String? currency;

  String? orderId;

  String? method;

  bool? captured;

  String? refundStatus;

  int? amountRefunded;

  int? fee;

  int? tax;

  String? bank;

  String? wallet;

  String? vpa;

  String? email;

  String? contact;

  String? cardId;

  String? acquirerData;

  String? description;

  String? notes;

  String? errorCode;

  String? errorDescription;

  int? createdAt;

  String? error;

  int? statusCode;

  String? body;

  /// Returns a shallow copy of this [RazorpayPaymentStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RazorpayPaymentStatus copyWith({
    String? id,
    String? status,
    int? amount,
    String? currency,
    String? orderId,
    String? method,
    bool? captured,
    String? refundStatus,
    int? amountRefunded,
    int? fee,
    int? tax,
    String? bank,
    String? wallet,
    String? vpa,
    String? email,
    String? contact,
    String? cardId,
    String? acquirerData,
    String? description,
    String? notes,
    String? errorCode,
    String? errorDescription,
    int? createdAt,
    String? error,
    int? statusCode,
    String? body,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RazorpayPaymentStatus',
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (orderId != null) 'orderId': orderId,
      if (method != null) 'method': method,
      if (captured != null) 'captured': captured,
      if (refundStatus != null) 'refundStatus': refundStatus,
      if (amountRefunded != null) 'amountRefunded': amountRefunded,
      if (fee != null) 'fee': fee,
      if (tax != null) 'tax': tax,
      if (bank != null) 'bank': bank,
      if (wallet != null) 'wallet': wallet,
      if (vpa != null) 'vpa': vpa,
      if (email != null) 'email': email,
      if (contact != null) 'contact': contact,
      if (cardId != null) 'cardId': cardId,
      if (acquirerData != null) 'acquirerData': acquirerData,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (errorCode != null) 'errorCode': errorCode,
      if (errorDescription != null) 'errorDescription': errorDescription,
      if (createdAt != null) 'createdAt': createdAt,
      if (error != null) 'error': error,
      if (statusCode != null) 'statusCode': statusCode,
      if (body != null) 'body': body,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RazorpayPaymentStatus',
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (orderId != null) 'orderId': orderId,
      if (method != null) 'method': method,
      if (captured != null) 'captured': captured,
      if (refundStatus != null) 'refundStatus': refundStatus,
      if (amountRefunded != null) 'amountRefunded': amountRefunded,
      if (fee != null) 'fee': fee,
      if (tax != null) 'tax': tax,
      if (bank != null) 'bank': bank,
      if (wallet != null) 'wallet': wallet,
      if (vpa != null) 'vpa': vpa,
      if (email != null) 'email': email,
      if (contact != null) 'contact': contact,
      if (cardId != null) 'cardId': cardId,
      if (acquirerData != null) 'acquirerData': acquirerData,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (errorCode != null) 'errorCode': errorCode,
      if (errorDescription != null) 'errorDescription': errorDescription,
      if (createdAt != null) 'createdAt': createdAt,
      if (error != null) 'error': error,
      if (statusCode != null) 'statusCode': statusCode,
      if (body != null) 'body': body,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RazorpayPaymentStatusImpl extends RazorpayPaymentStatus {
  _RazorpayPaymentStatusImpl({
    String? id,
    String? status,
    int? amount,
    String? currency,
    String? orderId,
    String? method,
    bool? captured,
    String? refundStatus,
    int? amountRefunded,
    int? fee,
    int? tax,
    String? bank,
    String? wallet,
    String? vpa,
    String? email,
    String? contact,
    String? cardId,
    String? acquirerData,
    String? description,
    String? notes,
    String? errorCode,
    String? errorDescription,
    int? createdAt,
    String? error,
    int? statusCode,
    String? body,
  }) : super._(
         id: id,
         status: status,
         amount: amount,
         currency: currency,
         orderId: orderId,
         method: method,
         captured: captured,
         refundStatus: refundStatus,
         amountRefunded: amountRefunded,
         fee: fee,
         tax: tax,
         bank: bank,
         wallet: wallet,
         vpa: vpa,
         email: email,
         contact: contact,
         cardId: cardId,
         acquirerData: acquirerData,
         description: description,
         notes: notes,
         errorCode: errorCode,
         errorDescription: errorDescription,
         createdAt: createdAt,
         error: error,
         statusCode: statusCode,
         body: body,
       );

  /// Returns a shallow copy of this [RazorpayPaymentStatus]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RazorpayPaymentStatus copyWith({
    Object? id = _Undefined,
    Object? status = _Undefined,
    Object? amount = _Undefined,
    Object? currency = _Undefined,
    Object? orderId = _Undefined,
    Object? method = _Undefined,
    Object? captured = _Undefined,
    Object? refundStatus = _Undefined,
    Object? amountRefunded = _Undefined,
    Object? fee = _Undefined,
    Object? tax = _Undefined,
    Object? bank = _Undefined,
    Object? wallet = _Undefined,
    Object? vpa = _Undefined,
    Object? email = _Undefined,
    Object? contact = _Undefined,
    Object? cardId = _Undefined,
    Object? acquirerData = _Undefined,
    Object? description = _Undefined,
    Object? notes = _Undefined,
    Object? errorCode = _Undefined,
    Object? errorDescription = _Undefined,
    Object? createdAt = _Undefined,
    Object? error = _Undefined,
    Object? statusCode = _Undefined,
    Object? body = _Undefined,
  }) {
    return RazorpayPaymentStatus(
      id: id is String? ? id : this.id,
      status: status is String? ? status : this.status,
      amount: amount is int? ? amount : this.amount,
      currency: currency is String? ? currency : this.currency,
      orderId: orderId is String? ? orderId : this.orderId,
      method: method is String? ? method : this.method,
      captured: captured is bool? ? captured : this.captured,
      refundStatus: refundStatus is String? ? refundStatus : this.refundStatus,
      amountRefunded: amountRefunded is int?
          ? amountRefunded
          : this.amountRefunded,
      fee: fee is int? ? fee : this.fee,
      tax: tax is int? ? tax : this.tax,
      bank: bank is String? ? bank : this.bank,
      wallet: wallet is String? ? wallet : this.wallet,
      vpa: vpa is String? ? vpa : this.vpa,
      email: email is String? ? email : this.email,
      contact: contact is String? ? contact : this.contact,
      cardId: cardId is String? ? cardId : this.cardId,
      acquirerData: acquirerData is String? ? acquirerData : this.acquirerData,
      description: description is String? ? description : this.description,
      notes: notes is String? ? notes : this.notes,
      errorCode: errorCode is String? ? errorCode : this.errorCode,
      errorDescription: errorDescription is String?
          ? errorDescription
          : this.errorDescription,
      createdAt: createdAt is int? ? createdAt : this.createdAt,
      error: error is String? ? error : this.error,
      statusCode: statusCode is int? ? statusCode : this.statusCode,
      body: body is String? ? body : this.body,
    );
  }
}
