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

abstract class OrderItemRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  OrderItemRow._({
    this.id,
    required this.orderId,
    required this.productId,
    this.productVariantId,
    this.comboOfferId,
    this.bogoOfferId,
    this.triggerProductId,
    required this.productNameSnapshot,
    this.productImageUrlSnapshot,
    this.variantLabelSnapshot,
    this.mrpSnapshot,
    this.skuSnapshot,
    this.productSlugSnapshot,
    this.categoryNameSnapshot,
    this.productStatusSnapshot,
    this.appliedOfferSnapshot,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    bool? isFreeItem,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
    this.originalUnitPrice,
    this.rewardValue,
    this.rewardOfferId,
    this.rewardOfferName,
    this.rewardThreshold,
    this.rewardSource,
    bool? isFreeDelivery,
    DateTime? createdAt,
  }) : isFreeItem = isFreeItem ?? false,
       isRewardProduct = isRewardProduct ?? false,
       quantityEditable = quantityEditable ?? true,
       priceEditable = priceEditable ?? true,
       isFreeDelivery = isFreeDelivery ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory OrderItemRow({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required _i1.UuidValue productId,
    _i1.UuidValue? productVariantId,
    _i1.UuidValue? comboOfferId,
    _i1.UuidValue? bogoOfferId,
    _i1.UuidValue? triggerProductId,
    required String productNameSnapshot,
    String? productImageUrlSnapshot,
    String? variantLabelSnapshot,
    double? mrpSnapshot,
    String? skuSnapshot,
    String? productSlugSnapshot,
    String? categoryNameSnapshot,
    String? productStatusSnapshot,
    String? appliedOfferSnapshot,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    bool? isFreeItem,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
    double? originalUnitPrice,
    double? rewardValue,
    String? rewardOfferId,
    String? rewardOfferName,
    double? rewardThreshold,
    String? rewardSource,
    bool? isFreeDelivery,
    DateTime? createdAt,
  }) = _OrderItemRowImpl;

  factory OrderItemRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return OrderItemRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      orderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['orderId'],
      ),
      productId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      productVariantId: jsonSerialization['productVariantId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['productVariantId'],
            ),
      comboOfferId: jsonSerialization['comboOfferId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['comboOfferId'],
            ),
      bogoOfferId: jsonSerialization['bogoOfferId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['bogoOfferId'],
            ),
      triggerProductId: jsonSerialization['triggerProductId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['triggerProductId'],
            ),
      productNameSnapshot: jsonSerialization['productNameSnapshot'] as String,
      productImageUrlSnapshot:
          jsonSerialization['productImageUrlSnapshot'] as String?,
      variantLabelSnapshot:
          jsonSerialization['variantLabelSnapshot'] as String?,
      mrpSnapshot: (jsonSerialization['mrpSnapshot'] as num?)?.toDouble(),
      skuSnapshot: jsonSerialization['skuSnapshot'] as String?,
      productSlugSnapshot: jsonSerialization['productSlugSnapshot'] as String?,
      categoryNameSnapshot:
          jsonSerialization['categoryNameSnapshot'] as String?,
      productStatusSnapshot:
          jsonSerialization['productStatusSnapshot'] as String?,
      appliedOfferSnapshot:
          jsonSerialization['appliedOfferSnapshot'] as String?,
      quantity: jsonSerialization['quantity'] as int,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      totalPrice: (jsonSerialization['totalPrice'] as num).toDouble(),
      isFreeItem: jsonSerialization['isFreeItem'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isFreeItem']),
      isRewardProduct: jsonSerialization['isRewardProduct'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['isRewardProduct'],
            ),
      quantityEditable: jsonSerialization['quantityEditable'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['quantityEditable'],
            ),
      priceEditable: jsonSerialization['priceEditable'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['priceEditable']),
      originalUnitPrice: (jsonSerialization['originalUnitPrice'] as num?)
          ?.toDouble(),
      rewardValue: (jsonSerialization['rewardValue'] as num?)?.toDouble(),
      rewardOfferId: jsonSerialization['rewardOfferId'] as String?,
      rewardOfferName: jsonSerialization['rewardOfferName'] as String?,
      rewardThreshold: (jsonSerialization['rewardThreshold'] as num?)
          ?.toDouble(),
      rewardSource: jsonSerialization['rewardSource'] as String?,
      isFreeDelivery: jsonSerialization['isFreeDelivery'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isFreeDelivery']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = OrderItemRowTable();

  static const db = OrderItemRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue orderId;

  _i1.UuidValue productId;

  _i1.UuidValue? productVariantId;

  _i1.UuidValue? comboOfferId;

  _i1.UuidValue? bogoOfferId;

  _i1.UuidValue? triggerProductId;

  String productNameSnapshot;

  String? productImageUrlSnapshot;

  String? variantLabelSnapshot;

  double? mrpSnapshot;

  String? skuSnapshot;

  String? productSlugSnapshot;

  String? categoryNameSnapshot;

  String? productStatusSnapshot;

  String? appliedOfferSnapshot;

  int quantity;

  double unitPrice;

  double totalPrice;

  bool isFreeItem;

  bool isRewardProduct;

  bool quantityEditable;

  bool priceEditable;

  double? originalUnitPrice;

  double? rewardValue;

  String? rewardOfferId;

  String? rewardOfferName;

  double? rewardThreshold;

  String? rewardSource;

  bool isFreeDelivery;

  DateTime createdAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [OrderItemRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrderItemRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? orderId,
    _i1.UuidValue? productId,
    _i1.UuidValue? productVariantId,
    _i1.UuidValue? comboOfferId,
    _i1.UuidValue? bogoOfferId,
    _i1.UuidValue? triggerProductId,
    String? productNameSnapshot,
    String? productImageUrlSnapshot,
    String? variantLabelSnapshot,
    double? mrpSnapshot,
    String? skuSnapshot,
    String? productSlugSnapshot,
    String? categoryNameSnapshot,
    String? productStatusSnapshot,
    String? appliedOfferSnapshot,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    bool? isFreeItem,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
    double? originalUnitPrice,
    double? rewardValue,
    String? rewardOfferId,
    String? rewardOfferName,
    double? rewardThreshold,
    String? rewardSource,
    bool? isFreeDelivery,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrderItemRow',
      if (id != null) 'id': id?.toJson(),
      'orderId': orderId.toJson(),
      'productId': productId.toJson(),
      if (productVariantId != null)
        'productVariantId': productVariantId?.toJson(),
      if (comboOfferId != null) 'comboOfferId': comboOfferId?.toJson(),
      if (bogoOfferId != null) 'bogoOfferId': bogoOfferId?.toJson(),
      if (triggerProductId != null)
        'triggerProductId': triggerProductId?.toJson(),
      'productNameSnapshot': productNameSnapshot,
      if (productImageUrlSnapshot != null)
        'productImageUrlSnapshot': productImageUrlSnapshot,
      if (variantLabelSnapshot != null)
        'variantLabelSnapshot': variantLabelSnapshot,
      if (mrpSnapshot != null) 'mrpSnapshot': mrpSnapshot,
      if (skuSnapshot != null) 'skuSnapshot': skuSnapshot,
      if (productSlugSnapshot != null)
        'productSlugSnapshot': productSlugSnapshot,
      if (categoryNameSnapshot != null)
        'categoryNameSnapshot': categoryNameSnapshot,
      if (productStatusSnapshot != null)
        'productStatusSnapshot': productStatusSnapshot,
      if (appliedOfferSnapshot != null)
        'appliedOfferSnapshot': appliedOfferSnapshot,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'isFreeItem': isFreeItem,
      'isRewardProduct': isRewardProduct,
      'quantityEditable': quantityEditable,
      'priceEditable': priceEditable,
      if (originalUnitPrice != null) 'originalUnitPrice': originalUnitPrice,
      if (rewardValue != null) 'rewardValue': rewardValue,
      if (rewardOfferId != null) 'rewardOfferId': rewardOfferId,
      if (rewardOfferName != null) 'rewardOfferName': rewardOfferName,
      if (rewardThreshold != null) 'rewardThreshold': rewardThreshold,
      if (rewardSource != null) 'rewardSource': rewardSource,
      'isFreeDelivery': isFreeDelivery,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static OrderItemRowInclude include() {
    return OrderItemRowInclude._();
  }

  static OrderItemRowIncludeList includeList({
    _i1.WhereExpressionBuilder<OrderItemRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderItemRowTable>? orderByList,
    OrderItemRowInclude? include,
  }) {
    return OrderItemRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderItemRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OrderItemRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrderItemRowImpl extends OrderItemRow {
  _OrderItemRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue orderId,
    required _i1.UuidValue productId,
    _i1.UuidValue? productVariantId,
    _i1.UuidValue? comboOfferId,
    _i1.UuidValue? bogoOfferId,
    _i1.UuidValue? triggerProductId,
    required String productNameSnapshot,
    String? productImageUrlSnapshot,
    String? variantLabelSnapshot,
    double? mrpSnapshot,
    String? skuSnapshot,
    String? productSlugSnapshot,
    String? categoryNameSnapshot,
    String? productStatusSnapshot,
    String? appliedOfferSnapshot,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    bool? isFreeItem,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
    double? originalUnitPrice,
    double? rewardValue,
    String? rewardOfferId,
    String? rewardOfferName,
    double? rewardThreshold,
    String? rewardSource,
    bool? isFreeDelivery,
    DateTime? createdAt,
  }) : super._(
         id: id,
         orderId: orderId,
         productId: productId,
         productVariantId: productVariantId,
         comboOfferId: comboOfferId,
         bogoOfferId: bogoOfferId,
         triggerProductId: triggerProductId,
         productNameSnapshot: productNameSnapshot,
         productImageUrlSnapshot: productImageUrlSnapshot,
         variantLabelSnapshot: variantLabelSnapshot,
         mrpSnapshot: mrpSnapshot,
         skuSnapshot: skuSnapshot,
         productSlugSnapshot: productSlugSnapshot,
         categoryNameSnapshot: categoryNameSnapshot,
         productStatusSnapshot: productStatusSnapshot,
         appliedOfferSnapshot: appliedOfferSnapshot,
         quantity: quantity,
         unitPrice: unitPrice,
         totalPrice: totalPrice,
         isFreeItem: isFreeItem,
         isRewardProduct: isRewardProduct,
         quantityEditable: quantityEditable,
         priceEditable: priceEditable,
         originalUnitPrice: originalUnitPrice,
         rewardValue: rewardValue,
         rewardOfferId: rewardOfferId,
         rewardOfferName: rewardOfferName,
         rewardThreshold: rewardThreshold,
         rewardSource: rewardSource,
         isFreeDelivery: isFreeDelivery,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [OrderItemRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrderItemRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? orderId,
    _i1.UuidValue? productId,
    Object? productVariantId = _Undefined,
    Object? comboOfferId = _Undefined,
    Object? bogoOfferId = _Undefined,
    Object? triggerProductId = _Undefined,
    String? productNameSnapshot,
    Object? productImageUrlSnapshot = _Undefined,
    Object? variantLabelSnapshot = _Undefined,
    Object? mrpSnapshot = _Undefined,
    Object? skuSnapshot = _Undefined,
    Object? productSlugSnapshot = _Undefined,
    Object? categoryNameSnapshot = _Undefined,
    Object? productStatusSnapshot = _Undefined,
    Object? appliedOfferSnapshot = _Undefined,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    bool? isFreeItem,
    bool? isRewardProduct,
    bool? quantityEditable,
    bool? priceEditable,
    Object? originalUnitPrice = _Undefined,
    Object? rewardValue = _Undefined,
    Object? rewardOfferId = _Undefined,
    Object? rewardOfferName = _Undefined,
    Object? rewardThreshold = _Undefined,
    Object? rewardSource = _Undefined,
    bool? isFreeDelivery,
    DateTime? createdAt,
  }) {
    return OrderItemRow(
      id: id is _i1.UuidValue? ? id : this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      productVariantId: productVariantId is _i1.UuidValue?
          ? productVariantId
          : this.productVariantId,
      comboOfferId: comboOfferId is _i1.UuidValue?
          ? comboOfferId
          : this.comboOfferId,
      bogoOfferId: bogoOfferId is _i1.UuidValue?
          ? bogoOfferId
          : this.bogoOfferId,
      triggerProductId: triggerProductId is _i1.UuidValue?
          ? triggerProductId
          : this.triggerProductId,
      productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
      productImageUrlSnapshot: productImageUrlSnapshot is String?
          ? productImageUrlSnapshot
          : this.productImageUrlSnapshot,
      variantLabelSnapshot: variantLabelSnapshot is String?
          ? variantLabelSnapshot
          : this.variantLabelSnapshot,
      mrpSnapshot: mrpSnapshot is double? ? mrpSnapshot : this.mrpSnapshot,
      skuSnapshot: skuSnapshot is String? ? skuSnapshot : this.skuSnapshot,
      productSlugSnapshot: productSlugSnapshot is String?
          ? productSlugSnapshot
          : this.productSlugSnapshot,
      categoryNameSnapshot: categoryNameSnapshot is String?
          ? categoryNameSnapshot
          : this.categoryNameSnapshot,
      productStatusSnapshot: productStatusSnapshot is String?
          ? productStatusSnapshot
          : this.productStatusSnapshot,
      appliedOfferSnapshot: appliedOfferSnapshot is String?
          ? appliedOfferSnapshot
          : this.appliedOfferSnapshot,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      isFreeItem: isFreeItem ?? this.isFreeItem,
      isRewardProduct: isRewardProduct ?? this.isRewardProduct,
      quantityEditable: quantityEditable ?? this.quantityEditable,
      priceEditable: priceEditable ?? this.priceEditable,
      originalUnitPrice: originalUnitPrice is double?
          ? originalUnitPrice
          : this.originalUnitPrice,
      rewardValue: rewardValue is double? ? rewardValue : this.rewardValue,
      rewardOfferId: rewardOfferId is String?
          ? rewardOfferId
          : this.rewardOfferId,
      rewardOfferName: rewardOfferName is String?
          ? rewardOfferName
          : this.rewardOfferName,
      rewardThreshold: rewardThreshold is double?
          ? rewardThreshold
          : this.rewardThreshold,
      rewardSource: rewardSource is String? ? rewardSource : this.rewardSource,
      isFreeDelivery: isFreeDelivery ?? this.isFreeDelivery,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OrderItemRowUpdateTable extends _i1.UpdateTable<OrderItemRowTable> {
  OrderItemRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> orderId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.orderId,
        value,
      );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> productId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> productVariantId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.productVariantId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> comboOfferId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.comboOfferId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> bogoOfferId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.bogoOfferId,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> triggerProductId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.triggerProductId,
    value,
  );

  _i1.ColumnValue<String, String> productNameSnapshot(String value) =>
      _i1.ColumnValue(
        table.productNameSnapshot,
        value,
      );

  _i1.ColumnValue<String, String> productImageUrlSnapshot(String? value) =>
      _i1.ColumnValue(
        table.productImageUrlSnapshot,
        value,
      );

  _i1.ColumnValue<String, String> variantLabelSnapshot(String? value) =>
      _i1.ColumnValue(
        table.variantLabelSnapshot,
        value,
      );

  _i1.ColumnValue<double, double> mrpSnapshot(double? value) => _i1.ColumnValue(
    table.mrpSnapshot,
    value,
  );

  _i1.ColumnValue<String, String> skuSnapshot(String? value) => _i1.ColumnValue(
    table.skuSnapshot,
    value,
  );

  _i1.ColumnValue<String, String> productSlugSnapshot(String? value) =>
      _i1.ColumnValue(
        table.productSlugSnapshot,
        value,
      );

  _i1.ColumnValue<String, String> categoryNameSnapshot(String? value) =>
      _i1.ColumnValue(
        table.categoryNameSnapshot,
        value,
      );

  _i1.ColumnValue<String, String> productStatusSnapshot(String? value) =>
      _i1.ColumnValue(
        table.productStatusSnapshot,
        value,
      );

  _i1.ColumnValue<String, String> appliedOfferSnapshot(String? value) =>
      _i1.ColumnValue(
        table.appliedOfferSnapshot,
        value,
      );

  _i1.ColumnValue<int, int> quantity(int value) => _i1.ColumnValue(
    table.quantity,
    value,
  );

  _i1.ColumnValue<double, double> unitPrice(double value) => _i1.ColumnValue(
    table.unitPrice,
    value,
  );

  _i1.ColumnValue<double, double> totalPrice(double value) => _i1.ColumnValue(
    table.totalPrice,
    value,
  );

  _i1.ColumnValue<bool, bool> isFreeItem(bool value) => _i1.ColumnValue(
    table.isFreeItem,
    value,
  );

  _i1.ColumnValue<bool, bool> isRewardProduct(bool value) => _i1.ColumnValue(
    table.isRewardProduct,
    value,
  );

  _i1.ColumnValue<bool, bool> quantityEditable(bool value) => _i1.ColumnValue(
    table.quantityEditable,
    value,
  );

  _i1.ColumnValue<bool, bool> priceEditable(bool value) => _i1.ColumnValue(
    table.priceEditable,
    value,
  );

  _i1.ColumnValue<double, double> originalUnitPrice(double? value) =>
      _i1.ColumnValue(
        table.originalUnitPrice,
        value,
      );

  _i1.ColumnValue<double, double> rewardValue(double? value) => _i1.ColumnValue(
    table.rewardValue,
    value,
  );

  _i1.ColumnValue<String, String> rewardOfferId(String? value) =>
      _i1.ColumnValue(
        table.rewardOfferId,
        value,
      );

  _i1.ColumnValue<String, String> rewardOfferName(String? value) =>
      _i1.ColumnValue(
        table.rewardOfferName,
        value,
      );

  _i1.ColumnValue<double, double> rewardThreshold(double? value) =>
      _i1.ColumnValue(
        table.rewardThreshold,
        value,
      );

  _i1.ColumnValue<String, String> rewardSource(String? value) =>
      _i1.ColumnValue(
        table.rewardSource,
        value,
      );

  _i1.ColumnValue<bool, bool> isFreeDelivery(bool value) => _i1.ColumnValue(
    table.isFreeDelivery,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class OrderItemRowTable extends _i1.Table<_i1.UuidValue?> {
  OrderItemRowTable({super.tableRelation}) : super(tableName: 'order_item') {
    updateTable = OrderItemRowUpdateTable(this);
    orderId = _i1.ColumnUuid(
      'orderId',
      this,
    );
    productId = _i1.ColumnUuid(
      'productId',
      this,
    );
    productVariantId = _i1.ColumnUuid(
      'productVariantId',
      this,
    );
    comboOfferId = _i1.ColumnUuid(
      'comboOfferId',
      this,
    );
    bogoOfferId = _i1.ColumnUuid(
      'bogoOfferId',
      this,
    );
    triggerProductId = _i1.ColumnUuid(
      'triggerProductId',
      this,
    );
    productNameSnapshot = _i1.ColumnString(
      'productNameSnapshot',
      this,
    );
    productImageUrlSnapshot = _i1.ColumnString(
      'productImageUrlSnapshot',
      this,
    );
    variantLabelSnapshot = _i1.ColumnString(
      'variantLabelSnapshot',
      this,
    );
    mrpSnapshot = _i1.ColumnDouble(
      'mrpSnapshot',
      this,
    );
    skuSnapshot = _i1.ColumnString(
      'skuSnapshot',
      this,
    );
    productSlugSnapshot = _i1.ColumnString(
      'productSlugSnapshot',
      this,
    );
    categoryNameSnapshot = _i1.ColumnString(
      'categoryNameSnapshot',
      this,
    );
    productStatusSnapshot = _i1.ColumnString(
      'productStatusSnapshot',
      this,
    );
    appliedOfferSnapshot = _i1.ColumnString(
      'appliedOfferSnapshot',
      this,
    );
    quantity = _i1.ColumnInt(
      'quantity',
      this,
    );
    unitPrice = _i1.ColumnDouble(
      'unitPrice',
      this,
    );
    totalPrice = _i1.ColumnDouble(
      'totalPrice',
      this,
    );
    isFreeItem = _i1.ColumnBool(
      'isFreeItem',
      this,
      hasDefault: true,
    );
    isRewardProduct = _i1.ColumnBool(
      'isRewardProduct',
      this,
      hasDefault: true,
    );
    quantityEditable = _i1.ColumnBool(
      'quantityEditable',
      this,
      hasDefault: true,
    );
    priceEditable = _i1.ColumnBool(
      'priceEditable',
      this,
      hasDefault: true,
    );
    originalUnitPrice = _i1.ColumnDouble(
      'originalUnitPrice',
      this,
    );
    rewardValue = _i1.ColumnDouble(
      'rewardValue',
      this,
    );
    rewardOfferId = _i1.ColumnString(
      'rewardOfferId',
      this,
    );
    rewardOfferName = _i1.ColumnString(
      'rewardOfferName',
      this,
    );
    rewardThreshold = _i1.ColumnDouble(
      'rewardThreshold',
      this,
    );
    rewardSource = _i1.ColumnString(
      'rewardSource',
      this,
    );
    isFreeDelivery = _i1.ColumnBool(
      'isFreeDelivery',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final OrderItemRowUpdateTable updateTable;

  late final _i1.ColumnUuid orderId;

  late final _i1.ColumnUuid productId;

  late final _i1.ColumnUuid productVariantId;

  late final _i1.ColumnUuid comboOfferId;

  late final _i1.ColumnUuid bogoOfferId;

  late final _i1.ColumnUuid triggerProductId;

  late final _i1.ColumnString productNameSnapshot;

  late final _i1.ColumnString productImageUrlSnapshot;

  late final _i1.ColumnString variantLabelSnapshot;

  late final _i1.ColumnDouble mrpSnapshot;

  late final _i1.ColumnString skuSnapshot;

  late final _i1.ColumnString productSlugSnapshot;

  late final _i1.ColumnString categoryNameSnapshot;

  late final _i1.ColumnString productStatusSnapshot;

  late final _i1.ColumnString appliedOfferSnapshot;

  late final _i1.ColumnInt quantity;

  late final _i1.ColumnDouble unitPrice;

  late final _i1.ColumnDouble totalPrice;

  late final _i1.ColumnBool isFreeItem;

  late final _i1.ColumnBool isRewardProduct;

  late final _i1.ColumnBool quantityEditable;

  late final _i1.ColumnBool priceEditable;

  late final _i1.ColumnDouble originalUnitPrice;

  late final _i1.ColumnDouble rewardValue;

  late final _i1.ColumnString rewardOfferId;

  late final _i1.ColumnString rewardOfferName;

  late final _i1.ColumnDouble rewardThreshold;

  late final _i1.ColumnString rewardSource;

  late final _i1.ColumnBool isFreeDelivery;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    orderId,
    productId,
    productVariantId,
    comboOfferId,
    bogoOfferId,
    triggerProductId,
    productNameSnapshot,
    productImageUrlSnapshot,
    variantLabelSnapshot,
    mrpSnapshot,
    skuSnapshot,
    productSlugSnapshot,
    categoryNameSnapshot,
    productStatusSnapshot,
    appliedOfferSnapshot,
    quantity,
    unitPrice,
    totalPrice,
    isFreeItem,
    isRewardProduct,
    quantityEditable,
    priceEditable,
    originalUnitPrice,
    rewardValue,
    rewardOfferId,
    rewardOfferName,
    rewardThreshold,
    rewardSource,
    isFreeDelivery,
    createdAt,
  ];
}

class OrderItemRowInclude extends _i1.IncludeObject {
  OrderItemRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => OrderItemRow.t;
}

class OrderItemRowIncludeList extends _i1.IncludeList {
  OrderItemRowIncludeList._({
    _i1.WhereExpressionBuilder<OrderItemRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrderItemRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => OrderItemRow.t;
}

class OrderItemRowRepository {
  const OrderItemRowRepository._();

  /// Returns a list of [OrderItemRow]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<OrderItemRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderItemRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderItemRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrderItemRow>(
      where: where?.call(OrderItemRow.t),
      orderBy: orderBy?.call(OrderItemRow.t),
      orderByList: orderByList?.call(OrderItemRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrderItemRow] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<OrderItemRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderItemRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrderItemRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrderItemRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrderItemRow>(
      where: where?.call(OrderItemRow.t),
      orderBy: orderBy?.call(OrderItemRow.t),
      orderByList: orderByList?.call(OrderItemRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrderItemRow] by its [id] or null if no such row exists.
  Future<OrderItemRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrderItemRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrderItemRow]s in the list and returns the inserted rows.
  ///
  /// The returned [OrderItemRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<OrderItemRow>> insert(
    _i1.DatabaseSession session,
    List<OrderItemRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<OrderItemRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [OrderItemRow] and returns the inserted row.
  ///
  /// The returned [OrderItemRow] will have its `id` field set.
  Future<OrderItemRow> insertRow(
    _i1.DatabaseSession session,
    OrderItemRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrderItemRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OrderItemRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OrderItemRow>> update(
    _i1.DatabaseSession session,
    List<OrderItemRow> rows, {
    _i1.ColumnSelections<OrderItemRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OrderItemRow>(
      rows,
      columns: columns?.call(OrderItemRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderItemRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrderItemRow> updateRow(
    _i1.DatabaseSession session,
    OrderItemRow row, {
    _i1.ColumnSelections<OrderItemRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrderItemRow>(
      row,
      columns: columns?.call(OrderItemRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrderItemRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrderItemRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<OrderItemRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<OrderItemRow>(
      id,
      columnValues: columnValues(OrderItemRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrderItemRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<OrderItemRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<OrderItemRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<OrderItemRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrderItemRowTable>? orderBy,
    _i1.OrderByListBuilder<OrderItemRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<OrderItemRow>(
      columnValues: columnValues(OrderItemRow.t.updateTable),
      where: where(OrderItemRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrderItemRow.t),
      orderByList: orderByList?.call(OrderItemRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [OrderItemRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OrderItemRow>> delete(
    _i1.DatabaseSession session,
    List<OrderItemRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OrderItemRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OrderItemRow].
  Future<OrderItemRow> deleteRow(
    _i1.DatabaseSession session,
    OrderItemRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrderItemRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OrderItemRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderItemRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OrderItemRow>(
      where: where(OrderItemRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<OrderItemRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OrderItemRow>(
      where: where?.call(OrderItemRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrderItemRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<OrderItemRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrderItemRow>(
      where: where(OrderItemRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
