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
import '../data_flow/complaint_product_item.dart' as _i2;
import 'package:freshpickkat_server/src/generated/protocol.dart' as _i3;

abstract class Complaint
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Complaint._({
    required this.complaintId,
    required this.userId,
    required this.orderId,
    required this.orderNumber,
    required this.complaintType,
    required this.title,
    this.orderItemId,
    this.productId,
    this.variantId,
    this.productName,
    this.productImage,
    this.variantLabel,
    this.quantity,
    required this.selectedProducts,
    required this.issueType,
    this.selectedField,
    this.extraData,
    required this.userPhone,
    required this.description,
    required this.imageUrls,
    required this.status,
    this.adminReply,
    this.adminNote,
    this.resolutionType,
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
    this.orderedAt,
    this.totalAmount,
    this.discountAmount,
    this.couponApplied,
    this.mrpTotal,
    this.productDiscountAmount,
    this.comboDiscountAmount,
    this.bogoDiscountAmount,
    this.deliveryFee,
    this.originalDeliveryFee,
    this.deliveryDiscountAmount,
    this.freeDeliveryApplied,
    this.finalAmount,
    required this.orderItems,
  });

  factory Complaint({
    required String complaintId,
    required String userId,
    required String orderId,
    required String orderNumber,
    required String complaintType,
    required String title,
    String? orderItemId,
    String? productId,
    String? variantId,
    String? productName,
    String? productImage,
    String? variantLabel,
    int? quantity,
    required List<_i2.ComplaintProductItem> selectedProducts,
    required String issueType,
    String? selectedField,
    Map<String, String>? extraData,
    required String userPhone,
    required String description,
    required List<String> imageUrls,
    required String status,
    String? adminReply,
    String? adminNote,
    String? resolutionType,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deliveredAt,
    DateTime? orderedAt,
    double? totalAmount,
    double? discountAmount,
    String? couponApplied,
    double? mrpTotal,
    double? productDiscountAmount,
    double? comboDiscountAmount,
    double? bogoDiscountAmount,
    double? deliveryFee,
    double? originalDeliveryFee,
    double? deliveryDiscountAmount,
    bool? freeDeliveryApplied,
    double? finalAmount,
    required List<_i2.ComplaintProductItem> orderItems,
  }) = _ComplaintImpl;

  factory Complaint.fromJson(Map<String, dynamic> jsonSerialization) {
    return Complaint(
      complaintId: jsonSerialization['complaintId'] as String,
      userId: jsonSerialization['userId'] as String,
      orderId: jsonSerialization['orderId'] as String,
      orderNumber: jsonSerialization['orderNumber'] as String,
      complaintType: jsonSerialization['complaintType'] as String,
      title: jsonSerialization['title'] as String,
      orderItemId: jsonSerialization['orderItemId'] as String?,
      productId: jsonSerialization['productId'] as String?,
      variantId: jsonSerialization['variantId'] as String?,
      productName: jsonSerialization['productName'] as String?,
      productImage: jsonSerialization['productImage'] as String?,
      variantLabel: jsonSerialization['variantLabel'] as String?,
      quantity: jsonSerialization['quantity'] as int?,
      selectedProducts: _i3.Protocol()
          .deserialize<List<_i2.ComplaintProductItem>>(
            jsonSerialization['selectedProducts'],
          ),
      issueType: jsonSerialization['issueType'] as String,
      selectedField: jsonSerialization['selectedField'] as String?,
      extraData: jsonSerialization['extraData'] == null
          ? null
          : _i3.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['extraData'],
            ),
      userPhone: jsonSerialization['userPhone'] as String,
      description: jsonSerialization['description'] as String,
      imageUrls: _i3.Protocol().deserialize<List<String>>(
        jsonSerialization['imageUrls'],
      ),
      status: jsonSerialization['status'] as String,
      adminReply: jsonSerialization['adminReply'] as String?,
      adminNote: jsonSerialization['adminNote'] as String?,
      resolutionType: jsonSerialization['resolutionType'] as String?,
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
      orderedAt: jsonSerialization['orderedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['orderedAt']),
      totalAmount: (jsonSerialization['totalAmount'] as num?)?.toDouble(),
      discountAmount: (jsonSerialization['discountAmount'] as num?)?.toDouble(),
      couponApplied: jsonSerialization['couponApplied'] as String?,
      mrpTotal: (jsonSerialization['mrpTotal'] as num?)?.toDouble(),
      productDiscountAmount:
          (jsonSerialization['productDiscountAmount'] as num?)?.toDouble(),
      comboDiscountAmount: (jsonSerialization['comboDiscountAmount'] as num?)
          ?.toDouble(),
      bogoDiscountAmount: (jsonSerialization['bogoDiscountAmount'] as num?)
          ?.toDouble(),
      deliveryFee: (jsonSerialization['deliveryFee'] as num?)?.toDouble(),
      originalDeliveryFee: (jsonSerialization['originalDeliveryFee'] as num?)
          ?.toDouble(),
      deliveryDiscountAmount:
          (jsonSerialization['deliveryDiscountAmount'] as num?)?.toDouble(),
      freeDeliveryApplied: jsonSerialization['freeDeliveryApplied'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['freeDeliveryApplied'],
            ),
      finalAmount: (jsonSerialization['finalAmount'] as num?)?.toDouble(),
      orderItems: _i3.Protocol().deserialize<List<_i2.ComplaintProductItem>>(
        jsonSerialization['orderItems'],
      ),
    );
  }

  String complaintId;

  String userId;

  String orderId;

  String orderNumber;

  String complaintType;

  String title;

  String? orderItemId;

  String? productId;

  String? variantId;

  String? productName;

  String? productImage;

  String? variantLabel;

  int? quantity;

  List<_i2.ComplaintProductItem> selectedProducts;

  String issueType;

  String? selectedField;

  Map<String, String>? extraData;

  String userPhone;

  String description;

  List<String> imageUrls;

  String status;

  String? adminReply;

  String? adminNote;

  String? resolutionType;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? deliveredAt;

  DateTime? orderedAt;

  double? totalAmount;

  double? discountAmount;

  String? couponApplied;

  double? mrpTotal;

  double? productDiscountAmount;

  double? comboDiscountAmount;

  double? bogoDiscountAmount;

  double? deliveryFee;

  double? originalDeliveryFee;

  double? deliveryDiscountAmount;

  bool? freeDeliveryApplied;

  double? finalAmount;

  List<_i2.ComplaintProductItem> orderItems;

  /// Returns a shallow copy of this [Complaint]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Complaint copyWith({
    String? complaintId,
    String? userId,
    String? orderId,
    String? orderNumber,
    String? complaintType,
    String? title,
    String? orderItemId,
    String? productId,
    String? variantId,
    String? productName,
    String? productImage,
    String? variantLabel,
    int? quantity,
    List<_i2.ComplaintProductItem>? selectedProducts,
    String? issueType,
    String? selectedField,
    Map<String, String>? extraData,
    String? userPhone,
    String? description,
    List<String>? imageUrls,
    String? status,
    String? adminReply,
    String? adminNote,
    String? resolutionType,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deliveredAt,
    DateTime? orderedAt,
    double? totalAmount,
    double? discountAmount,
    String? couponApplied,
    double? mrpTotal,
    double? productDiscountAmount,
    double? comboDiscountAmount,
    double? bogoDiscountAmount,
    double? deliveryFee,
    double? originalDeliveryFee,
    double? deliveryDiscountAmount,
    bool? freeDeliveryApplied,
    double? finalAmount,
    List<_i2.ComplaintProductItem>? orderItems,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Complaint',
      'complaintId': complaintId,
      'userId': userId,
      'orderId': orderId,
      'orderNumber': orderNumber,
      'complaintType': complaintType,
      'title': title,
      if (orderItemId != null) 'orderItemId': orderItemId,
      if (productId != null) 'productId': productId,
      if (variantId != null) 'variantId': variantId,
      if (productName != null) 'productName': productName,
      if (productImage != null) 'productImage': productImage,
      if (variantLabel != null) 'variantLabel': variantLabel,
      if (quantity != null) 'quantity': quantity,
      'selectedProducts': selectedProducts.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'issueType': issueType,
      if (selectedField != null) 'selectedField': selectedField,
      if (extraData != null) 'extraData': extraData?.toJson(),
      'userPhone': userPhone,
      'description': description,
      'imageUrls': imageUrls.toJson(),
      'status': status,
      if (adminReply != null) 'adminReply': adminReply,
      if (adminNote != null) 'adminNote': adminNote,
      if (resolutionType != null) 'resolutionType': resolutionType,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (orderedAt != null) 'orderedAt': orderedAt?.toJson(),
      if (totalAmount != null) 'totalAmount': totalAmount,
      if (discountAmount != null) 'discountAmount': discountAmount,
      if (couponApplied != null) 'couponApplied': couponApplied,
      if (mrpTotal != null) 'mrpTotal': mrpTotal,
      if (productDiscountAmount != null)
        'productDiscountAmount': productDiscountAmount,
      if (comboDiscountAmount != null)
        'comboDiscountAmount': comboDiscountAmount,
      if (bogoDiscountAmount != null) 'bogoDiscountAmount': bogoDiscountAmount,
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
      if (originalDeliveryFee != null)
        'originalDeliveryFee': originalDeliveryFee,
      if (deliveryDiscountAmount != null)
        'deliveryDiscountAmount': deliveryDiscountAmount,
      if (freeDeliveryApplied != null)
        'freeDeliveryApplied': freeDeliveryApplied,
      if (finalAmount != null) 'finalAmount': finalAmount,
      'orderItems': orderItems.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Complaint',
      'complaintId': complaintId,
      'userId': userId,
      'orderId': orderId,
      'orderNumber': orderNumber,
      'complaintType': complaintType,
      'title': title,
      if (orderItemId != null) 'orderItemId': orderItemId,
      if (productId != null) 'productId': productId,
      if (variantId != null) 'variantId': variantId,
      if (productName != null) 'productName': productName,
      if (productImage != null) 'productImage': productImage,
      if (variantLabel != null) 'variantLabel': variantLabel,
      if (quantity != null) 'quantity': quantity,
      'selectedProducts': selectedProducts.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'issueType': issueType,
      if (selectedField != null) 'selectedField': selectedField,
      if (extraData != null) 'extraData': extraData?.toJson(),
      'userPhone': userPhone,
      'description': description,
      'imageUrls': imageUrls.toJson(),
      'status': status,
      if (adminReply != null) 'adminReply': adminReply,
      if (adminNote != null) 'adminNote': adminNote,
      if (resolutionType != null) 'resolutionType': resolutionType,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
      if (orderedAt != null) 'orderedAt': orderedAt?.toJson(),
      if (totalAmount != null) 'totalAmount': totalAmount,
      if (discountAmount != null) 'discountAmount': discountAmount,
      if (couponApplied != null) 'couponApplied': couponApplied,
      if (mrpTotal != null) 'mrpTotal': mrpTotal,
      if (productDiscountAmount != null)
        'productDiscountAmount': productDiscountAmount,
      if (comboDiscountAmount != null)
        'comboDiscountAmount': comboDiscountAmount,
      if (bogoDiscountAmount != null) 'bogoDiscountAmount': bogoDiscountAmount,
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
      if (originalDeliveryFee != null)
        'originalDeliveryFee': originalDeliveryFee,
      if (deliveryDiscountAmount != null)
        'deliveryDiscountAmount': deliveryDiscountAmount,
      if (freeDeliveryApplied != null)
        'freeDeliveryApplied': freeDeliveryApplied,
      if (finalAmount != null) 'finalAmount': finalAmount,
      'orderItems': orderItems.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
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
    required String complaintType,
    required String title,
    String? orderItemId,
    String? productId,
    String? variantId,
    String? productName,
    String? productImage,
    String? variantLabel,
    int? quantity,
    required List<_i2.ComplaintProductItem> selectedProducts,
    required String issueType,
    String? selectedField,
    Map<String, String>? extraData,
    required String userPhone,
    required String description,
    required List<String> imageUrls,
    required String status,
    String? adminReply,
    String? adminNote,
    String? resolutionType,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deliveredAt,
    DateTime? orderedAt,
    double? totalAmount,
    double? discountAmount,
    String? couponApplied,
    double? mrpTotal,
    double? productDiscountAmount,
    double? comboDiscountAmount,
    double? bogoDiscountAmount,
    double? deliveryFee,
    double? originalDeliveryFee,
    double? deliveryDiscountAmount,
    bool? freeDeliveryApplied,
    double? finalAmount,
    required List<_i2.ComplaintProductItem> orderItems,
  }) : super._(
         complaintId: complaintId,
         userId: userId,
         orderId: orderId,
         orderNumber: orderNumber,
         complaintType: complaintType,
         title: title,
         orderItemId: orderItemId,
         productId: productId,
         variantId: variantId,
         productName: productName,
         productImage: productImage,
         variantLabel: variantLabel,
         quantity: quantity,
         selectedProducts: selectedProducts,
         issueType: issueType,
         selectedField: selectedField,
         extraData: extraData,
         userPhone: userPhone,
         description: description,
         imageUrls: imageUrls,
         status: status,
         adminReply: adminReply,
         adminNote: adminNote,
         resolutionType: resolutionType,
         createdAt: createdAt,
         updatedAt: updatedAt,
         deliveredAt: deliveredAt,
         orderedAt: orderedAt,
         totalAmount: totalAmount,
         discountAmount: discountAmount,
         couponApplied: couponApplied,
         mrpTotal: mrpTotal,
         productDiscountAmount: productDiscountAmount,
         comboDiscountAmount: comboDiscountAmount,
         bogoDiscountAmount: bogoDiscountAmount,
         deliveryFee: deliveryFee,
         originalDeliveryFee: originalDeliveryFee,
         deliveryDiscountAmount: deliveryDiscountAmount,
         freeDeliveryApplied: freeDeliveryApplied,
         finalAmount: finalAmount,
         orderItems: orderItems,
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
    String? complaintType,
    String? title,
    Object? orderItemId = _Undefined,
    Object? productId = _Undefined,
    Object? variantId = _Undefined,
    Object? productName = _Undefined,
    Object? productImage = _Undefined,
    Object? variantLabel = _Undefined,
    Object? quantity = _Undefined,
    List<_i2.ComplaintProductItem>? selectedProducts,
    String? issueType,
    Object? selectedField = _Undefined,
    Object? extraData = _Undefined,
    String? userPhone,
    String? description,
    List<String>? imageUrls,
    String? status,
    Object? adminReply = _Undefined,
    Object? adminNote = _Undefined,
    Object? resolutionType = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deliveredAt = _Undefined,
    Object? orderedAt = _Undefined,
    Object? totalAmount = _Undefined,
    Object? discountAmount = _Undefined,
    Object? couponApplied = _Undefined,
    Object? mrpTotal = _Undefined,
    Object? productDiscountAmount = _Undefined,
    Object? comboDiscountAmount = _Undefined,
    Object? bogoDiscountAmount = _Undefined,
    Object? deliveryFee = _Undefined,
    Object? originalDeliveryFee = _Undefined,
    Object? deliveryDiscountAmount = _Undefined,
    Object? freeDeliveryApplied = _Undefined,
    Object? finalAmount = _Undefined,
    List<_i2.ComplaintProductItem>? orderItems,
  }) {
    return Complaint(
      complaintId: complaintId ?? this.complaintId,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      complaintType: complaintType ?? this.complaintType,
      title: title ?? this.title,
      orderItemId: orderItemId is String? ? orderItemId : this.orderItemId,
      productId: productId is String? ? productId : this.productId,
      variantId: variantId is String? ? variantId : this.variantId,
      productName: productName is String? ? productName : this.productName,
      productImage: productImage is String? ? productImage : this.productImage,
      variantLabel: variantLabel is String? ? variantLabel : this.variantLabel,
      quantity: quantity is int? ? quantity : this.quantity,
      selectedProducts:
          selectedProducts ??
          this.selectedProducts.map((e0) => e0.copyWith()).toList(),
      issueType: issueType ?? this.issueType,
      selectedField: selectedField is String?
          ? selectedField
          : this.selectedField,
      extraData: extraData is Map<String, String>?
          ? extraData
          : this.extraData?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      userPhone: userPhone ?? this.userPhone,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls.map((e0) => e0).toList(),
      status: status ?? this.status,
      adminReply: adminReply is String? ? adminReply : this.adminReply,
      adminNote: adminNote is String? ? adminNote : this.adminNote,
      resolutionType: resolutionType is String?
          ? resolutionType
          : this.resolutionType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
      orderedAt: orderedAt is DateTime? ? orderedAt : this.orderedAt,
      totalAmount: totalAmount is double? ? totalAmount : this.totalAmount,
      discountAmount: discountAmount is double?
          ? discountAmount
          : this.discountAmount,
      couponApplied: couponApplied is String?
          ? couponApplied
          : this.couponApplied,
      mrpTotal: mrpTotal is double? ? mrpTotal : this.mrpTotal,
      productDiscountAmount: productDiscountAmount is double?
          ? productDiscountAmount
          : this.productDiscountAmount,
      comboDiscountAmount: comboDiscountAmount is double?
          ? comboDiscountAmount
          : this.comboDiscountAmount,
      bogoDiscountAmount: bogoDiscountAmount is double?
          ? bogoDiscountAmount
          : this.bogoDiscountAmount,
      deliveryFee: deliveryFee is double? ? deliveryFee : this.deliveryFee,
      originalDeliveryFee: originalDeliveryFee is double?
          ? originalDeliveryFee
          : this.originalDeliveryFee,
      deliveryDiscountAmount: deliveryDiscountAmount is double?
          ? deliveryDiscountAmount
          : this.deliveryDiscountAmount,
      freeDeliveryApplied: freeDeliveryApplied is bool?
          ? freeDeliveryApplied
          : this.freeDeliveryApplied,
      finalAmount: finalAmount is double? ? finalAmount : this.finalAmount,
      orderItems:
          orderItems ?? this.orderItems.map((e0) => e0.copyWith()).toList(),
    );
  }
}
