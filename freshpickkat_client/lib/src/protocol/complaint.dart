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
import 'package:freshpickkat_client/src/protocol/protocol.dart' as _i2;

abstract class Complaint implements _i1.SerializableModel {
  Complaint._({
    required this.complaintId,
    required this.userId,
    required this.orderId,
    required this.orderNumber,
    required this.orderItemId,
    required this.productId,
    this.variantId,
    required this.productName,
    required this.productImage,
    this.variantLabel,
    required this.quantity,
    required this.issueType,
    required this.description,
    required this.imageUrls,
    required this.status,
    this.adminReply,
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
  });

  factory Complaint({
    required String complaintId,
    required String userId,
    required String orderId,
    required String orderNumber,
    required String orderItemId,
    required String productId,
    String? variantId,
    required String productName,
    required String productImage,
    String? variantLabel,
    required int quantity,
    required String issueType,
    required String description,
    required List<String> imageUrls,
    required String status,
    String? adminReply,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deliveredAt,
  }) = _ComplaintImpl;

  factory Complaint.fromJson(Map<String, dynamic> jsonSerialization) {
    return Complaint(
      complaintId: jsonSerialization['complaintId'] as String,
      userId: jsonSerialization['userId'] as String,
      orderId: jsonSerialization['orderId'] as String,
      orderNumber: jsonSerialization['orderNumber'] as String,
      orderItemId: jsonSerialization['orderItemId'] as String,
      productId: jsonSerialization['productId'] as String,
      variantId: jsonSerialization['variantId'] as String?,
      productName: jsonSerialization['productName'] as String,
      productImage: jsonSerialization['productImage'] as String,
      variantLabel: jsonSerialization['variantLabel'] as String?,
      quantity: jsonSerialization['quantity'] as int,
      issueType: jsonSerialization['issueType'] as String,
      description: jsonSerialization['description'] as String,
      imageUrls: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['imageUrls'],
      ),
      status: jsonSerialization['status'] as String,
      adminReply: jsonSerialization['adminReply'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt'],
            ),
    );
  }

  String complaintId;

  String userId;

  String orderId;

  String orderNumber;

  String orderItemId;

  String productId;

  String? variantId;

  String productName;

  String productImage;

  String? variantLabel;

  int quantity;

  String issueType;

  String description;

  List<String> imageUrls;

  String status;

  String? adminReply;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deliveredAt;

  /// Returns a shallow copy of this [Complaint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Complaint copyWith({
    String? complaintId,
    String? userId,
    String? orderId,
    String? orderNumber,
    String? orderItemId,
    String? productId,
    String? variantId,
    String? productName,
    String? productImage,
    String? variantLabel,
    int? quantity,
    String? issueType,
    String? description,
    List<String>? imageUrls,
    String? status,
    String? adminReply,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Complaint',
      'complaintId': complaintId,
      'userId': userId,
      'orderId': orderId,
      'orderNumber': orderNumber,
      'orderItemId': orderItemId,
      'productId': productId,
      if (variantId != null) 'variantId': variantId,
      'productName': productName,
      'productImage': productImage,
      if (variantLabel != null) 'variantLabel': variantLabel,
      'quantity': quantity,
      'issueType': issueType,
      'description': description,
      'imageUrls': imageUrls.toJson(),
      'status': status,
      if (adminReply != null) 'adminReply': adminReply,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ComplaintImpl extends Complaint {
  _ComplaintImpl({
    required String complaintId,
    required String userId,
    required String orderId,
    required String orderNumber,
    required String orderItemId,
    required String productId,
    String? variantId,
    required String productName,
    required String productImage,
    String? variantLabel,
    required int quantity,
    required String issueType,
    required String description,
    required List<String> imageUrls,
    required String status,
    String? adminReply,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deliveredAt,
  }) : super._(
         complaintId: complaintId,
         userId: userId,
         orderId: orderId,
         orderNumber: orderNumber,
         orderItemId: orderItemId,
         productId: productId,
         variantId: variantId,
         productName: productName,
         productImage: productImage,
         variantLabel: variantLabel,
         quantity: quantity,
         issueType: issueType,
         description: description,
         imageUrls: imageUrls,
         status: status,
         adminReply: adminReply,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deliveredAt: deliveredAt,
       );

  /// Returns a shallow copy of this [Complaint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Complaint copyWith({
    String? complaintId,
    String? userId,
    String? orderId,
    String? orderNumber,
    String? orderItemId,
    String? productId,
    Object? variantId = _Undefined,
    String? productName,
    String? productImage,
    Object? variantLabel = _Undefined,
    int? quantity,
    String? issueType,
    String? description,
    List<String>? imageUrls,
    String? status,
    Object? adminReply = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deliveredAt = _Undefined,
  }) {
    return Complaint(
      complaintId: complaintId ?? this.complaintId,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      orderItemId: orderItemId ?? this.orderItemId,
      productId: productId ?? this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      variantLabel: variantLabel is String? ? variantLabel : this.variantLabel,
      quantity: quantity ?? this.quantity,
      issueType: issueType ?? this.issueType,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls.map((e0) => e0).toList(),
      status: status ?? this.status,
      adminReply: adminReply is String? ? adminReply : this.adminReply,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
    );
  }
}
