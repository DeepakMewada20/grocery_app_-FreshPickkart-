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

abstract class PaymentLinkRow
    implements _i1.TableRow, _i1.ProtocolSerialization {
  PaymentLinkRow._({
    this.id,
    required this.orderId,
    required this.token,
    required this.expiresAt,
    this.isUsed = false,
    this.usedAt,
    this.paidByName,
    this.paidByPhone,
    this.paidByEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentLinkRow({
    UuidValue? id,
    required UuidValue orderId,
    required String token,
    required DateTime expiresAt,
    bool isUsed = false,
    DateTime? usedAt,
    String? paidByName,
    String? paidByPhone,
    String? paidByEmail,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PaymentLinkRowImpl;

  factory PaymentLinkRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaymentLinkRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidJsonExtension.fromJson(jsonSerialization['orderId']),
      token: jsonSerialization['token'] as String,
      expiresAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      isUsed: jsonSerialization['isUsed'] as bool? ?? false,
      usedAt: jsonSerialization['usedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['usedAt']),
      paidByName: jsonSerialization['paidByName'] as String?,
      paidByPhone: jsonSerialization['paidByPhone'] as String?,
      paidByEmail: jsonSerialization['paidByEmail'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static const _i1.TableDefinition t = _i1.TableDefinition(
    alias: 'PaymentLinkRow',
    tableName: 'payment_link',
    columns: [
      'id',
      'orderId',
      'token',
      'expiresAt',
      'isUsed',
      'usedAt',
      'paidByName',
      'paidByPhone',
      'paidByEmail',
      'createdAt',
      'updatedAt',
    ],
    primaryKeyColumns: {'id'},
  );

  UuidValue? id;

  UuidValue orderId;

  String token;

  DateTime expiresAt;

  bool isUsed;

  DateTime? usedAt;

  String? paidByName;

  String? paidByPhone;

  String? paidByEmail;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [PaymentLinkRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaymentLinkRow copyWith({
    UuidValue? id,
    UuidValue? orderId,
    String? token,
    DateTime? expiresAt,
    bool? isUsed,
    Object? usedAt = _Undefined,
    Object? paidByName = _Undefined,
    Object? paidByPhone = _Undefined,
    Object? paidByEmail = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'token': token,
      'expiresAt': expiresAt.toUtc().toIso8601String(),
      'isUsed': isUsed,
      if (usedAt != null) 'usedAt': usedAt?.toUtc().toIso8601String(),
      if (paidByName != null) 'paidByName': paidByName,
      if (paidByPhone != null) 'paidByPhone': paidByPhone,
      if (paidByEmail != null) 'paidByEmail': paidByEmail,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'token': token,
      'expiresAt': expiresAt.toUtc().toIso8601String(),
      'isUsed': isUsed,
      if (usedAt != null) 'usedAt': usedAt?.toUtc().toIso8601String(),
      if (paidByName != null) 'paidByName': paidByName,
      if (paidByPhone != null) 'paidByPhone': paidByPhone,
      if (paidByEmail != null) 'paidByEmail': paidByEmail,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }

  @override
  Map<String, dynamic> get columnValues => toJson();
}

class _Undefined {}

class _PaymentLinkRowImpl extends PaymentLinkRow {
  _PaymentLinkRowImpl({
    UuidValue? id,
    required UuidValue orderId,
    required String token,
    required DateTime expiresAt,
    bool isUsed = false,
    DateTime? usedAt,
    String? paidByName,
    String? paidByPhone,
    String? paidByEmail,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         orderId: orderId,
         token: token,
         expiresAt: expiresAt,
         isUsed: isUsed,
         usedAt: usedAt,
         paidByName: paidByName,
         paidByPhone: paidByPhone,
         paidByEmail: paidByEmail,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  @_i1.useResult
  @override
  PaymentLinkRow copyWith({
    Object? id = _Undefined,
    UuidValue? orderId,
    String? token,
    DateTime? expiresAt,
    bool? isUsed,
    Object? usedAt = _Undefined,
    Object? paidByName = _Undefined,
    Object? paidByPhone = _Undefined,
    Object? paidByEmail = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentLinkRow(
      id: id is UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      isUsed: isUsed ?? this.isUsed,
      usedAt: usedAt is DateTime? ? usedAt : this.usedAt,
      paidByName: paidByName is String? ? paidByName : this.paidByName,
      paidByPhone: paidByPhone is String? ? paidByPhone : this.paidByPhone,
      paidByEmail: paidByEmail is String? ? paidByEmail : this.paidByEmail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
