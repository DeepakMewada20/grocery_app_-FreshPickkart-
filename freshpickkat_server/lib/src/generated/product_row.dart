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

abstract class ProductRow
    implements _i1.TableRow<_i1.UuidValue?>, _i1.ProtocolSerialization {
  ProductRow._({
    this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    this.shortDescription,
    this.description,
    this.primaryImageUrl,
    this.countryOfOrigin,
    this.baseUnit,
    this.baseQuantity,
    this.quantityDescription,
    this.stock,
    this.stockUnit,
    this.discountType,
    bool? isFreeDelivery,
    int? mostSearchCount,
    int? mostPurchaseCount,
    int? last7DaysSold,
    int? last7DaysViews,
    int? reorderCount,
    double? trendingScore,
    String? status,
    this.deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : isFreeDelivery = isFreeDelivery ?? false,
       mostSearchCount = mostSearchCount ?? 0,
       mostPurchaseCount = mostPurchaseCount ?? 0,
       last7DaysSold = last7DaysSold ?? 0,
       last7DaysViews = last7DaysViews ?? 0,
       reorderCount = reorderCount ?? 0,
       trendingScore = trendingScore ?? 0.0,
       status = status ?? 'active',
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory ProductRow({
    _i1.UuidValue? id,
    required _i1.UuidValue categoryId,
    required String name,
    required String slug,
    String? shortDescription,
    String? description,
    String? primaryImageUrl,
    String? countryOfOrigin,
    String? baseUnit,
    double? baseQuantity,
    String? quantityDescription,
    double? stock,
    String? stockUnit,
    String? discountType,
    bool? isFreeDelivery,
    int? mostSearchCount,
    int? mostPurchaseCount,
    int? last7DaysSold,
    int? last7DaysViews,
    int? reorderCount,
    double? trendingScore,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductRowImpl;

  factory ProductRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductRow(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      categoryId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['categoryId'],
      ),
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      shortDescription: jsonSerialization['shortDescription'] as String?,
      description: jsonSerialization['description'] as String?,
      primaryImageUrl: jsonSerialization['primaryImageUrl'] as String?,
      countryOfOrigin: jsonSerialization['countryOfOrigin'] as String?,
      baseUnit: jsonSerialization['baseUnit'] as String?,
      baseQuantity: (jsonSerialization['baseQuantity'] as num?)?.toDouble(),
      quantityDescription: jsonSerialization['quantityDescription'] as String?,
      stock: (jsonSerialization['stock'] as num?)?.toDouble(),
      stockUnit: jsonSerialization['stockUnit'] as String?,
      discountType: jsonSerialization['discountType'] as String?,
      isFreeDelivery: jsonSerialization['isFreeDelivery'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isFreeDelivery']),
      mostSearchCount: jsonSerialization['mostSearchCount'] as int?,
      mostPurchaseCount: jsonSerialization['mostPurchaseCount'] as int?,
      last7DaysSold: jsonSerialization['last7DaysSold'] as int?,
      last7DaysViews: jsonSerialization['last7DaysViews'] as int?,
      reorderCount: jsonSerialization['reorderCount'] as int?,
      trendingScore: (jsonSerialization['trendingScore'] as num?)?.toDouble(),
      status: jsonSerialization['status'] as String?,
      deactivatedAt: jsonSerialization['deactivatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['deactivatedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ProductRowTable();

  static const db = ProductRowRepository._();

  @override
  _i1.UuidValue? id;

  _i1.UuidValue categoryId;

  String name;

  String slug;

  String? shortDescription;

  String? description;

  String? primaryImageUrl;

  String? countryOfOrigin;

  String? baseUnit;

  double? baseQuantity;

  String? quantityDescription;

  double? stock;

  String? stockUnit;

  String? discountType;

  bool isFreeDelivery;

  int mostSearchCount;

  int mostPurchaseCount;

  int last7DaysSold;

  int last7DaysViews;

  int reorderCount;

  double trendingScore;

  String status;

  DateTime? deactivatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<_i1.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProductRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProductRow copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? categoryId,
    String? name,
    String? slug,
    String? shortDescription,
    String? description,
    String? primaryImageUrl,
    String? countryOfOrigin,
    String? baseUnit,
    double? baseQuantity,
    String? quantityDescription,
    double? stock,
    String? stockUnit,
    String? discountType,
    bool? isFreeDelivery,
    int? mostSearchCount,
    int? mostPurchaseCount,
    int? last7DaysSold,
    int? last7DaysViews,
    int? reorderCount,
    double? trendingScore,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductRow',
      if (id != null) 'id': id?.toJson(),
      'categoryId': categoryId.toJson(),
      'name': name,
      'slug': slug,
      if (shortDescription != null) 'shortDescription': shortDescription,
      if (description != null) 'description': description,
      if (primaryImageUrl != null) 'primaryImageUrl': primaryImageUrl,
      if (countryOfOrigin != null) 'countryOfOrigin': countryOfOrigin,
      if (baseUnit != null) 'baseUnit': baseUnit,
      if (baseQuantity != null) 'baseQuantity': baseQuantity,
      if (quantityDescription != null)
        'quantityDescription': quantityDescription,
      if (stock != null) 'stock': stock,
      if (stockUnit != null) 'stockUnit': stockUnit,
      if (discountType != null) 'discountType': discountType,
      'isFreeDelivery': isFreeDelivery,
      'mostSearchCount': mostSearchCount,
      'mostPurchaseCount': mostPurchaseCount,
      'last7DaysSold': last7DaysSold,
      'last7DaysViews': last7DaysViews,
      'reorderCount': reorderCount,
      'trendingScore': trendingScore,
      'status': status,
      if (deactivatedAt != null) 'deactivatedAt': deactivatedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static ProductRowInclude include() {
    return ProductRowInclude._();
  }

  static ProductRowIncludeList includeList({
    _i1.WhereExpressionBuilder<ProductRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductRowTable>? orderByList,
    ProductRowInclude? include,
  }) {
    return ProductRowIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductRow.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ProductRow.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductRowImpl extends ProductRow {
  _ProductRowImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue categoryId,
    required String name,
    required String slug,
    String? shortDescription,
    String? description,
    String? primaryImageUrl,
    String? countryOfOrigin,
    String? baseUnit,
    double? baseQuantity,
    String? quantityDescription,
    double? stock,
    String? stockUnit,
    String? discountType,
    bool? isFreeDelivery,
    int? mostSearchCount,
    int? mostPurchaseCount,
    int? last7DaysSold,
    int? last7DaysViews,
    int? reorderCount,
    double? trendingScore,
    String? status,
    DateTime? deactivatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         categoryId: categoryId,
         name: name,
         slug: slug,
         shortDescription: shortDescription,
         description: description,
         primaryImageUrl: primaryImageUrl,
         countryOfOrigin: countryOfOrigin,
         baseUnit: baseUnit,
         baseQuantity: baseQuantity,
         quantityDescription: quantityDescription,
         stock: stock,
         stockUnit: stockUnit,
         discountType: discountType,
         isFreeDelivery: isFreeDelivery,
         mostSearchCount: mostSearchCount,
         mostPurchaseCount: mostPurchaseCount,
         last7DaysSold: last7DaysSold,
         last7DaysViews: last7DaysViews,
         reorderCount: reorderCount,
         trendingScore: trendingScore,
         status: status,
         deactivatedAt: deactivatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ProductRow]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProductRow copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? categoryId,
    String? name,
    String? slug,
    Object? shortDescription = _Undefined,
    Object? description = _Undefined,
    Object? primaryImageUrl = _Undefined,
    Object? countryOfOrigin = _Undefined,
    Object? baseUnit = _Undefined,
    Object? baseQuantity = _Undefined,
    Object? quantityDescription = _Undefined,
    Object? stock = _Undefined,
    Object? stockUnit = _Undefined,
    Object? discountType = _Undefined,
    bool? isFreeDelivery,
    int? mostSearchCount,
    int? mostPurchaseCount,
    int? last7DaysSold,
    int? last7DaysViews,
    int? reorderCount,
    double? trendingScore,
    String? status,
    Object? deactivatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductRow(
      id: id is _i1.UuidValue? ? id : this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      shortDescription: shortDescription is String?
          ? shortDescription
          : this.shortDescription,
      description: description is String? ? description : this.description,
      primaryImageUrl: primaryImageUrl is String?
          ? primaryImageUrl
          : this.primaryImageUrl,
      countryOfOrigin: countryOfOrigin is String?
          ? countryOfOrigin
          : this.countryOfOrigin,
      baseUnit: baseUnit is String? ? baseUnit : this.baseUnit,
      baseQuantity: baseQuantity is double? ? baseQuantity : this.baseQuantity,
      quantityDescription: quantityDescription is String?
          ? quantityDescription
          : this.quantityDescription,
      stock: stock is double? ? stock : this.stock,
      stockUnit: stockUnit is String? ? stockUnit : this.stockUnit,
      discountType: discountType is String? ? discountType : this.discountType,
      isFreeDelivery: isFreeDelivery ?? this.isFreeDelivery,
      mostSearchCount: mostSearchCount ?? this.mostSearchCount,
      mostPurchaseCount: mostPurchaseCount ?? this.mostPurchaseCount,
      last7DaysSold: last7DaysSold ?? this.last7DaysSold,
      last7DaysViews: last7DaysViews ?? this.last7DaysViews,
      reorderCount: reorderCount ?? this.reorderCount,
      trendingScore: trendingScore ?? this.trendingScore,
      status: status ?? this.status,
      deactivatedAt: deactivatedAt is DateTime?
          ? deactivatedAt
          : this.deactivatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProductRowUpdateTable extends _i1.UpdateTable<ProductRowTable> {
  ProductRowUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> categoryId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.categoryId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> slug(String value) => _i1.ColumnValue(
    table.slug,
    value,
  );

  _i1.ColumnValue<String, String> shortDescription(String? value) =>
      _i1.ColumnValue(
        table.shortDescription,
        value,
      );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> primaryImageUrl(String? value) =>
      _i1.ColumnValue(
        table.primaryImageUrl,
        value,
      );

  _i1.ColumnValue<String, String> countryOfOrigin(String? value) =>
      _i1.ColumnValue(
        table.countryOfOrigin,
        value,
      );

  _i1.ColumnValue<String, String> baseUnit(String? value) => _i1.ColumnValue(
    table.baseUnit,
    value,
  );

  _i1.ColumnValue<double, double> baseQuantity(double? value) =>
      _i1.ColumnValue(
        table.baseQuantity,
        value,
      );

  _i1.ColumnValue<String, String> quantityDescription(String? value) =>
      _i1.ColumnValue(
        table.quantityDescription,
        value,
      );

  _i1.ColumnValue<double, double> stock(double? value) => _i1.ColumnValue(
    table.stock,
    value,
  );

  _i1.ColumnValue<String, String> stockUnit(String? value) => _i1.ColumnValue(
    table.stockUnit,
    value,
  );

  _i1.ColumnValue<String, String> discountType(String? value) =>
      _i1.ColumnValue(
        table.discountType,
        value,
      );

  _i1.ColumnValue<bool, bool> isFreeDelivery(bool value) => _i1.ColumnValue(
    table.isFreeDelivery,
    value,
  );

  _i1.ColumnValue<int, int> mostSearchCount(int value) => _i1.ColumnValue(
    table.mostSearchCount,
    value,
  );

  _i1.ColumnValue<int, int> mostPurchaseCount(int value) => _i1.ColumnValue(
    table.mostPurchaseCount,
    value,
  );

  _i1.ColumnValue<int, int> last7DaysSold(int value) => _i1.ColumnValue(
    table.last7DaysSold,
    value,
  );

  _i1.ColumnValue<int, int> last7DaysViews(int value) => _i1.ColumnValue(
    table.last7DaysViews,
    value,
  );

  _i1.ColumnValue<int, int> reorderCount(int value) => _i1.ColumnValue(
    table.reorderCount,
    value,
  );

  _i1.ColumnValue<double, double> trendingScore(double value) =>
      _i1.ColumnValue(
        table.trendingScore,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> deactivatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.deactivatedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ProductRowTable extends _i1.Table<_i1.UuidValue?> {
  ProductRowTable({super.tableRelation}) : super(tableName: 'product') {
    updateTable = ProductRowUpdateTable(this);
    categoryId = _i1.ColumnUuid(
      'categoryId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    slug = _i1.ColumnString(
      'slug',
      this,
    );
    shortDescription = _i1.ColumnString(
      'shortDescription',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    primaryImageUrl = _i1.ColumnString(
      'primaryImageUrl',
      this,
    );
    countryOfOrigin = _i1.ColumnString(
      'countryOfOrigin',
      this,
    );
    baseUnit = _i1.ColumnString(
      'baseUnit',
      this,
    );
    baseQuantity = _i1.ColumnDouble(
      'baseQuantity',
      this,
    );
    quantityDescription = _i1.ColumnString(
      'quantityDescription',
      this,
    );
    stock = _i1.ColumnDouble(
      'stock',
      this,
    );
    stockUnit = _i1.ColumnString(
      'stockUnit',
      this,
    );
    discountType = _i1.ColumnString(
      'discountType',
      this,
    );
    isFreeDelivery = _i1.ColumnBool(
      'isFreeDelivery',
      this,
      hasDefault: true,
    );
    mostSearchCount = _i1.ColumnInt(
      'mostSearchCount',
      this,
      hasDefault: true,
    );
    mostPurchaseCount = _i1.ColumnInt(
      'mostPurchaseCount',
      this,
      hasDefault: true,
    );
    last7DaysSold = _i1.ColumnInt(
      'last7DaysSold',
      this,
      hasDefault: true,
    );
    last7DaysViews = _i1.ColumnInt(
      'last7DaysViews',
      this,
      hasDefault: true,
    );
    reorderCount = _i1.ColumnInt(
      'reorderCount',
      this,
      hasDefault: true,
    );
    trendingScore = _i1.ColumnDouble(
      'trendingScore',
      this,
      hasDefault: true,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    deactivatedAt = _i1.ColumnDateTime(
      'deactivatedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final ProductRowUpdateTable updateTable;

  late final _i1.ColumnUuid categoryId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString slug;

  late final _i1.ColumnString shortDescription;

  late final _i1.ColumnString description;

  late final _i1.ColumnString primaryImageUrl;

  late final _i1.ColumnString countryOfOrigin;

  late final _i1.ColumnString baseUnit;

  late final _i1.ColumnDouble baseQuantity;

  late final _i1.ColumnString quantityDescription;

  late final _i1.ColumnDouble stock;

  late final _i1.ColumnString stockUnit;

  late final _i1.ColumnString discountType;

  late final _i1.ColumnBool isFreeDelivery;

  late final _i1.ColumnInt mostSearchCount;

  late final _i1.ColumnInt mostPurchaseCount;

  late final _i1.ColumnInt last7DaysSold;

  late final _i1.ColumnInt last7DaysViews;

  late final _i1.ColumnInt reorderCount;

  late final _i1.ColumnDouble trendingScore;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime deactivatedAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    categoryId,
    name,
    slug,
    shortDescription,
    description,
    primaryImageUrl,
    countryOfOrigin,
    baseUnit,
    baseQuantity,
    quantityDescription,
    stock,
    stockUnit,
    discountType,
    isFreeDelivery,
    mostSearchCount,
    mostPurchaseCount,
    last7DaysSold,
    last7DaysViews,
    reorderCount,
    trendingScore,
    status,
    deactivatedAt,
    createdAt,
    updatedAt,
  ];
}

class ProductRowInclude extends _i1.IncludeObject {
  ProductRowInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ProductRow.t;
}

class ProductRowIncludeList extends _i1.IncludeList {
  ProductRowIncludeList._({
    _i1.WhereExpressionBuilder<ProductRowTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProductRow.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue?> get table => ProductRow.t;
}

class ProductRowRepository {
  const ProductRowRepository._();

  /// Returns a list of [ProductRow]s matching the given query parameters.
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
  Future<List<ProductRow>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductRowTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProductRow>(
      where: where?.call(ProductRow.t),
      orderBy: orderBy?.call(ProductRow.t),
      orderByList: orderByList?.call(ProductRow.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProductRow] matching the given query parameters.
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
  Future<ProductRow?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductRowTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProductRowTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProductRowTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProductRow>(
      where: where?.call(ProductRow.t),
      orderBy: orderBy?.call(ProductRow.t),
      orderByList: orderByList?.call(ProductRow.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProductRow] by its [id] or null if no such row exists.
  Future<ProductRow?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProductRow>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProductRow]s in the list and returns the inserted rows.
  ///
  /// The returned [ProductRow]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ProductRow>> insert(
    _i1.DatabaseSession session,
    List<ProductRow> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ProductRow>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ProductRow] and returns the inserted row.
  ///
  /// The returned [ProductRow] will have its `id` field set.
  Future<ProductRow> insertRow(
    _i1.DatabaseSession session,
    ProductRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProductRow>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ProductRow]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ProductRow>> update(
    _i1.DatabaseSession session,
    List<ProductRow> rows, {
    _i1.ColumnSelections<ProductRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ProductRow>(
      rows,
      columns: columns?.call(ProductRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductRow]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProductRow> updateRow(
    _i1.DatabaseSession session,
    ProductRow row, {
    _i1.ColumnSelections<ProductRowTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProductRow>(
      row,
      columns: columns?.call(ProductRow.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductRow] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProductRow?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<ProductRowUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProductRow>(
      id,
      columnValues: columnValues(ProductRow.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProductRow]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ProductRow>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProductRowUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ProductRowTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProductRowTable>? orderBy,
    _i1.OrderByListBuilder<ProductRowTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ProductRow>(
      columnValues: columnValues(ProductRow.t.updateTable),
      where: where(ProductRow.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductRow.t),
      orderByList: orderByList?.call(ProductRow.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ProductRow]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ProductRow>> delete(
    _i1.DatabaseSession session,
    List<ProductRow> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ProductRow>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ProductRow].
  Future<ProductRow> deleteRow(
    _i1.DatabaseSession session,
    ProductRow row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProductRow>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ProductRow>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductRowTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ProductRow>(
      where: where(ProductRow.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProductRowTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProductRow>(
      where: where?.call(ProductRow.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProductRow] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProductRowTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProductRow>(
      where: where(ProductRow.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
