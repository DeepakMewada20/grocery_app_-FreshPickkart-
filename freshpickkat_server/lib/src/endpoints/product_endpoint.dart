import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import '../services/role_guard_service.dart';
import '../services/business/product_business_service.dart';
import '../services/business/audit_log_service.dart';
import '../services/business/validation_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class ProductEndpoint extends Endpoint {
  Future<List<Product>> getProducts(
    Session session, {
    int limit = 10,
    String? lastProductName,
    String? category,
    List<String>? subcategories,
    String sortBy = 'name', // 'name', 'trending', 'best_sellers'
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();

    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    final finalFilter = _buildProductFilter(
      category: category,
      subcategories: subcategories,
    );

    // Build orderBy based on sortBy parameter
    List<firestore_api.Order> orderByList = [];

    if (sortBy == 'trending') {
      orderByList.add(
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'mostSearch'),
          direction: 'DESCENDING',
        ),
      );
    } else if (sortBy == 'best_sellers') {
      orderByList.add(
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'mostPurchases'),
          direction: 'DESCENDING',
        ),
      );
    } else {
      orderByList.add(
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'productName'),
          direction: 'ASCENDING',
        ),
      );
    }

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Products')],
      where: finalFilter,
      limit: limit,
      orderBy: orderByList,
      // Pagination: startAfter logic
      startAt: lastProductName != null
          ? firestore_api.Cursor(
              values: [firestore_api.Value(stringValue: lastProductName)],
              before: false, // false matlab start AFTER this name
            )
          : null,
    );

    try {
      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      final products = response
          .where(
            (res) => res.document != null,
          ) // Filter out empty heartbeat responses
          .map((res) {
            final fields = res.document!.fields!;

            return _productFromFirestore(
              res.document!.name!.split('/').last,
              fields,
            );
          })
          .toList();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductPage> getProductsPage(
    Session session, {
    required String firebaseUid,
    required String idToken,
    int limit = 20,
    String? pageToken,
    String? category,
    List<String>? subcategories,
    String sortBy = 'name',
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final page = await _fetchProductsPage(
      session,
      limit: limit,
      pageToken: pageToken,
      category: category,
      subcategories: subcategories,
      sortBy: sortBy,
    );
    final totalCount = await _countProducts(
      session,
      category: category,
      subcategories: subcategories,
    );

    return ProductPage(
      products: page.products,
      nextPageToken: page.nextPageToken,
      totalCount: totalCount,
    );
  }

  Future<int> getProductsCount(
    Session session, {
    required String firebaseUid,
    required String idToken,
    String? category,
    List<String>? subcategories,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _countProducts(
      session,
      category: category,
      subcategories: subcategories,
    );
  }

  /// Upload a product to Firestore 'Products' collection
  Future<String?> uploadProduct(
    Session session,
    Product product,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final normalized = ProductBusinessService.normalizeForSave(product);
    ValidationService.validateProduct(normalized);

    final String parent =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    // Convert Product to Firestore Document fields
    final document = firestore_api.Document(
      fields: _productFieldsToFirestore(normalized),
    );

    try {
      final createdDoc = await firestore.projects.databases.documents
          .createDocument(
            document,
            parent, // parent path = database/documents root
            'Products', // collection ID
          );
      final newId = createdDoc.name!.split('/').last;
      await _syncBogoOffer(session, firestore, newId, normalized);
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'create',
        entityType: 'product',
        entityId: newId,
        metadata: {'category': normalized.category},
      );
      session.log('Product uploaded: ${product.productName} (ID: $newId)');
      return newId;
    } catch (e, stack) {
      session.log('Error uploading product: $e');
      session.log(stack.toString());
      rethrow;
    }
  }

  Future<bool> updateProduct(
    Session session,
    Product product,
    String firebaseUid,
    String idToken,
  ) async {
    if (product.productId == null || product.productId!.trim().isEmpty) {
      throw Exception('productId is required for update');
    }

    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final normalized = ProductBusinessService.normalizeForSave(product);
    ValidationService.validateProduct(normalized);

    final database =
        'projects/freshpickkart-a6824/databases/(default)/documents';
    final docPath = '$database/Products/${product.productId}';

    final fields = _productFieldsToFirestore(normalized);

    await firestore.projects.databases.documents.patch(
      firestore_api.Document(fields: fields),
      docPath,
      updateMask_fieldPaths: fields.keys.toList(),
    );
    await _syncBogoOffer(session, firestore, product.productId!, normalized);
    await AuditLogService.write(
      firestore: firestore,
      actorUid: firebaseUid,
      action: 'update',
      entityType: 'product',
      entityId: product.productId!,
      metadata: {'name': normalized.productName},
    );
    return true;
  }

  Future<bool> deleteProduct(
    Session session,
    String productId,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final database =
        'projects/freshpickkart-a6824/databases/(default)/documents';
    final docPath = '$database/Products/$productId';
    await firestore.projects.databases.documents.delete(docPath);

    // Also delete BOGO offer if it exists
    final bogoDocPath = '$database/bogo_offers/$productId';
    try {
      await firestore.projects.databases.documents.delete(bogoDocPath);
    } catch (_) {}

    await AuditLogService.write(
      firestore: firestore,
      actorUid: firebaseUid,
      action: 'delete',
      entityType: 'product',
      entityId: productId,
    );
    return true;
  }

  Future<List<String>> getProductSuggestions(
    Session session,
    String query,
  ) async {
    if (query.isEmpty) return [];

    final firestore = await FirebaseService.getFirestoreClient();
    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    // Search using lowercase keywords for case-insensitive matching
    final lowercaseQuery = query.toLowerCase();

    final structuredQuery = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Products')],
      select: firestore_api.Projection(
        fields: [
          firestore_api.FieldReference(fieldPath: 'productName'),
        ],
      ),
      where: firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'searchKeywords'),
          op: 'ARRAY_CONTAINS',
          value: firestore_api.Value(stringValue: lowercaseQuery),
        ),
      ),
      limit: 10,
    );

    try {
      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: structuredQuery),
        database,
      );

      return response
          .where((res) => res.document != null)
          .map((res) => res.document!.fields!['productName']?.stringValue ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (e) {
      session.log('Error fetching suggestions: $e');
      return [];
    }
  }

  Future<List<Product>> searchProducts(Session session, String query) async {
    if (query.isEmpty) return [];

    final firestore = await FirebaseService.getFirestoreClient();
    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    final lowercaseQuery = query.toLowerCase();

    final structuredQuery = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Products')],
      where: firestore_api.Filter(
        fieldFilter: firestore_api.FieldFilter(
          field: firestore_api.FieldReference(fieldPath: 'searchKeywords'),
          op: 'ARRAY_CONTAINS',
          value: firestore_api.Value(stringValue: lowercaseQuery),
        ),
      ),
      limit: 20,
    );

    try {
      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: structuredQuery),
        database,
      );

      final products = response.where((res) => res.document != null).map((res) {
        final fields = res.document!.fields!;
        return _productFromFirestore(
          res.document!.name!.split('/').last,
          fields,
        );
      }).toList();

      // If we found products, also fetch some related products from the same category (optional but requested)
      if (products.isNotEmpty) {
        final category = products.first.category;
        final relatedQuery = firestore_api.StructuredQuery(
          from: [firestore_api.CollectionSelector(collectionId: 'Products')],
          where: firestore_api.Filter(
            fieldFilter: firestore_api.FieldFilter(
              field: firestore_api.FieldReference(fieldPath: 'category'),
              op: 'EQUAL',
              value: firestore_api.Value(stringValue: category),
            ),
          ),
          limit: 10,
        );

        final relatedResponse = await firestore.projects.databases.documents
            .runQuery(
              firestore_api.RunQueryRequest(structuredQuery: relatedQuery),
              database,
            );

        final relatedProducts = relatedResponse
            .where((res) => res.document != null)
            .map((res) {
              final fields = res.document!.fields!;
              final id = res.document!.name!.split('/').last;
              // Avoid duplicates
              if (products.any((p) => p.productId == id)) return null;

              return _productFromFirestore(id, fields);
            })
            .whereType<Product>()
            .toList();

        products.addAll(relatedProducts);
      }

      return products;
    } catch (e) {
      session.log('Error searching products: $e');
      return [];
    }
  }

  Future<int> migrateProducts(Session session) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    // 1. Fetch all products
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Products')],
    );

    try {
      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      int updatedCount = 0;
      for (var res in response) {
        if (res.document == null) continue;

        final doc = res.document!;
        final name = doc.name!;
        final fields = doc.fields!;

        final productName = fields['productName']?.stringValue ?? '';
        final category = fields['category']?.stringValue ?? '';
        final subcategory = (fields['subcategory']?.arrayValue?.values ?? [])
            .map((v) => v.stringValue ?? '')
            .toList();

        final keywords = _generateSearchKeywords(
          productName,
          category,
          subcategory,
        );

        // 2. Update the document with new keywords
        final updatedDoc = firestore_api.Document(
          fields: {
            ...fields,
            'searchKeywords': firestore_api.Value(
              arrayValue: firestore_api.ArrayValue(
                values: keywords
                    .map((k) => firestore_api.Value(stringValue: k))
                    .toList(),
              ),
            ),
          },
        );

        await firestore.projects.databases.documents.patch(
          updatedDoc,
          name,
          updateMask_fieldPaths: ['searchKeywords'],
        );
        updatedCount++;
        session.log('Migrated product: $productName');
      }

      return updatedCount;
    } catch (e) {
      session.log('Error migrating products: $e');
      return 0;
    }
  }

  /// Initialize mostSearch and mostPurchases fields for all products
  Future<int> initializeProductMetrics(Session session) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    // 1. Fetch all products
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Products')],
    );

    try {
      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      int updatedCount = 0;
      for (var res in response) {
        if (res.document == null) continue;

        final doc = res.document!;
        final name = doc.name!;
        final fields = doc.fields!;

        final productName = fields['productName']?.stringValue ?? '';

        // 2. Update the document with metrics fields if they don't exist
        final updatedDoc = firestore_api.Document(
          fields: {
            ...fields,
            'mostSearch': firestore_api.Value(
              integerValue: (fields['mostSearch']?.integerValue ?? '0'),
            ),
            'mostPurchases': firestore_api.Value(
              integerValue: (fields['mostPurchases']?.integerValue ?? '0'),
            ),
          },
        );

        await firestore.projects.databases.documents.patch(
          updatedDoc,
          name,
          updateMask_fieldPaths: ['mostSearch', 'mostPurchases'],
        );
        updatedCount++;
        session.log('Initialized metrics for product: $productName');
      }

      return updatedCount;
    } catch (e) {
      session.log('Error initializing product metrics: $e');
      return 0;
    }
  }

  /// Increment the search count for a product
  Future<bool> incrementProductSearch(Session session, String productId) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    try {
      // Get the product document
      final docPath = '$database/Products/$productId';
      final doc = await firestore.projects.databases.documents.get(docPath);

      if (doc.fields == null) return false;

      final currentSearch =
          int.tryParse(doc.fields!['mostSearch']?.integerValue ?? '0') ?? 0;

      // Update with incremented value
      final updatedDoc = firestore_api.Document(
        fields: {
          ...doc.fields!,
          'mostSearch': firestore_api.Value(
            integerValue: (currentSearch + 1).toString(),
          ),
        },
      );

      await firestore.projects.databases.documents.patch(
        updatedDoc,
        doc.name!,
        updateMask_fieldPaths: ['mostSearch'],
      );

      return true;
    } catch (e) {
      session.log('Error incrementing product search: $e');
      return false;
    }
  }

  /// Increment the purchase count for a product
  Future<bool> incrementProductPurchase(
    Session session,
    String productId,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    try {
      // Get the product document
      final docPath = '$database/Products/$productId';
      final doc = await firestore.projects.databases.documents.get(docPath);

      if (doc.fields == null) return false;

      final currentPurchases =
          int.tryParse(doc.fields!['mostPurchases']?.integerValue ?? '0') ?? 0;

      // Update with incremented value
      final updatedDoc = firestore_api.Document(
        fields: {
          ...doc.fields!,
          'mostPurchases': firestore_api.Value(
            integerValue: (currentPurchases + 1).toString(),
          ),
        },
      );

      await firestore.projects.databases.documents.patch(
        updatedDoc,
        doc.name!,
        updateMask_fieldPaths: ['mostPurchases'],
      );

      return true;
    } catch (e) {
      session.log('Error incrementing product purchase: $e');
      return false;
    }
  }

  Future<void> _syncBogoOffer(
    Session session,
    firestore_api.FirestoreApi firestore,
    String triggerProductId,
    Product product,
  ) async {
    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';
    final String bogoCollection = 'bogo_offers';

    if (product.discountType == 'bogo' &&
        product.bogoFreeProductIds != null &&
        product.bogoFreeProductIds!.isNotEmpty) {
      // Upsert BOGO offer document
      final docPath = '$database/$bogoCollection/$triggerProductId';
      final normalizedFreeProductIds = product.bogoFreeProductIds!
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();
      final existingFreeProductQuantities = <String, String?>{};

      try {
        final existingDoc = await firestore.projects.databases.documents.get(
          docPath,
        );
        if (existingDoc.fields != null) {
          for (final freeProduct in _parseBogoFreeProducts(
            existingDoc.fields!,
          )) {
            existingFreeProductQuantities[freeProduct.productId] =
                freeProduct.quantity;
          }
        }
      } catch (_) {
        // Ignore missing BOGO document; this path also creates new offers.
      }

      final freeProducts = normalizedFreeProductIds
          .map(
            (freeProductId) => BogoFreeProduct(
              productId: freeProductId,
              quantity: existingFreeProductQuantities[freeProductId],
            ),
          )
          .toList();
      final fields = {
        'offerId': firestore_api.Value(stringValue: triggerProductId),
        'triggerProductId': firestore_api.Value(stringValue: triggerProductId),
        'freeProductIds': firestore_api.Value(
          arrayValue: firestore_api.ArrayValue(
            values: normalizedFreeProductIds
                .map((id) => firestore_api.Value(stringValue: id))
                .toList(),
          ),
        ),
        'freeProducts': firestore_api.Value(
          arrayValue: firestore_api.ArrayValue(
            values: freeProducts
                .map(
                  (freeProduct) => firestore_api.Value(
                    mapValue: firestore_api.MapValue(
                      fields: {
                        'productId': firestore_api.Value(
                          stringValue: freeProduct.productId,
                        ),
                        if (freeProduct.quantity != null &&
                            freeProduct.quantity!.trim().isNotEmpty)
                          'quantity': firestore_api.Value(
                            stringValue: freeProduct.quantity!.trim(),
                          ),
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        'offerTitle': firestore_api.Value(stringValue: 'Buy 1 Get 1 Free'),
        'isActive': firestore_api.Value(booleanValue: true),
        'createdAt': firestore_api.Value(
          timestampValue: DateTime.now().toUtc().toIso8601String(),
        ),
      };

      await firestore.projects.databases.documents.patch(
        firestore_api.Document(fields: fields),
        docPath,
        updateMask_fieldPaths: fields.keys.toList(),
      );
    } else {
      // Delete BOGO offer document if it exists but type is no longer bogo
      final docPath = '$database/$bogoCollection/$triggerProductId';
      try {
        await firestore.projects.databases.documents.delete(docPath);
      } catch (_) {
        // Ignore if document not found
      }
    }
  }

  List<BogoFreeProduct> _parseBogoFreeProducts(
    Map<String, firestore_api.Value> fields,
  ) {
    return fields['freeProducts']?.arrayValue?.values
            ?.map((value) => value.mapValue?.fields ?? const {})
            .map(
              (itemFields) => BogoFreeProduct(
                productId: itemFields['productId']?.stringValue ?? '',
                quantity: itemFields['quantity']?.stringValue,
              ),
            )
            .where((freeProduct) => freeProduct.productId.trim().isNotEmpty)
            .toList() ??
        const <BogoFreeProduct>[];
  }

  /// Seed all products with random test data (mostSearch & mostPurchases)
  /// Call this from wallet_screen to fill all products with random values (1-30)
  /// for testing that Trending and Best Sellers sections display correctly
  Future<int> seedProductMetricsForTesting(Session session) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';
    final random = Random();

    // 1. Fetch all products
    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Products')],
    );

    try {
      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      int updatedCount = 0;
      for (var res in response) {
        if (res.document == null) continue;

        final doc = res.document!;
        final name = doc.name!;
        final fields = doc.fields!;

        final productName = fields['productName']?.stringValue ?? '';

        // Generate random values between 1-30 for both fields
        final randomSearch = 1 + random.nextInt(30); // 1-30
        final randomPurchases = 1 + random.nextInt(30); // 1-30

        // 2. Update the document with random test metrics
        final updatedDoc = firestore_api.Document(
          fields: {
            ...fields,
            'mostSearch': firestore_api.Value(
              integerValue: randomSearch.toString(),
            ),
            'mostPurchases': firestore_api.Value(
              integerValue: randomPurchases.toString(),
            ),
          },
        );

        await firestore.projects.databases.documents.patch(
          updatedDoc,
          name,
          updateMask_fieldPaths: ['mostSearch', 'mostPurchases'],
        );
        updatedCount++;
        session.log(
          'Seeded test metrics for product: $productName '
          '(searches: $randomSearch, purchases: $randomPurchases)',
        );
      }

      session.log('Successfully seeded test data for $updatedCount products');
      return updatedCount;
    } catch (e) {
      session.log('Error seeding product metrics for testing: $e');
      return 0;
    }
  }

  List<String> _generateSearchKeywords(
    String productName,
    String category,
    List<String> subcategories,
  ) {
    final Set<String> keywords = {};

    void addKeywordsForText(String text) {
      if (text.isEmpty) return;
      final t = text.toLowerCase();
      final words = t.split(RegExp(r'[\s&,]+'));

      // Add full text
      keywords.add(t);

      // Add individual words and their prefixes
      for (var word in words) {
        if (word.isNotEmpty) {
          keywords.add(word);
          for (int i = 1; i <= word.length; i++) {
            keywords.add(word.substring(0, i));
          }
        }
      }
    }

    // Generate for product name
    addKeywordsForText(productName);

    // Generate for category
    addKeywordsForText(category);

    // Generate for each subcategory
    for (var sub in subcategories) {
      addKeywordsForText(sub);
    }

    return keywords.toList();
  }

  double _getDoubleValue(
    Map<String, firestore_api.Value> fields,
    String key,
  ) {
    final value = fields[key];
    if (value == null) return 0.0;
    if (value.doubleValue != null) return value.doubleValue!;
    if (value.integerValue != null && value.integerValue!.isNotEmpty) {
      return double.tryParse(value.integerValue!) ?? 0.0;
    }
    return 0.0;
  }

  Product _productFromFirestore(
    String productId,
    Map<String, firestore_api.Value> fields,
  ) {
    final variants = _readVariants(fields);
    final primaryVariant = variants.first;

    return Product(
      productId: productId,
      productName: fields['productName']?.stringValue ?? '',
      category: fields['category']?.stringValue ?? '',
      imageUrl: fields['imageUrl']?.stringValue ?? '',
      price: _getDoubleValue(fields, 'price'),
      realPrice: _getDoubleValue(fields, 'realPrice'),
      discount: _getDoubleValue(fields, 'discount'),
      isAvailable: fields['isAvailable']?.booleanValue ?? false,
      addedAt:
          DateTime.tryParse(fields['addedAt']?.timestampValue ?? '') ??
          DateTime.now(),
      subcategory: _stringListField(fields['subcategory']),
      quantity: fields['quantity']?.stringValue ?? primaryVariant.quantity,
      countryOfOrigin: fields['countryOfOrigin']?.stringValue,
      searchKeywords: _stringListField(fields['searchKeywords']),
      mostSearch: int.tryParse(fields['mostSearch']?.integerValue ?? '0') ?? 0,
      mostPurchases:
          int.tryParse(fields['mostPurchases']?.integerValue ?? '0') ?? 0,
      discountType: fields['discountType']?.stringValue,
      discountValue: _getDoubleValue(fields, 'discountValue'),
      bogoFreeProductIds: _stringListField(fields['bogoFreeProductIds']),
      variants: variants,
    );
  }

  List<ProductVariant> _readVariants(Map<String, firestore_api.Value> fields) {
    final rawVariants = fields['variants']?.arrayValue?.values ?? const [];
    if (rawVariants.isNotEmpty) {
      return rawVariants.asMap().entries.map((entry) {
        final index = entry.key;
        final itemFields = entry.value.mapValue?.fields ?? const {};
        return ProductVariant(
          variantId:
              itemFields['variantId']?.stringValue?.trim().isNotEmpty == true
              ? itemFields['variantId']!.stringValue!
              : 'variant_$index',
          quantity: itemFields['quantity']?.stringValue ?? '',
          price: _getValueAsDouble(itemFields['price']),
          realPrice: _getValueAsDouble(itemFields['realPrice']),
          isAvailable: itemFields['isAvailable']?.booleanValue ?? true,
          sortOrder: int.tryParse(itemFields['sortOrder']?.integerValue ?? ''),
        );
      }).toList()..sort(
        (a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0),
      );
    }

    return [
      ProductVariant(
        variantId: 'default',
        quantity: fields['quantity']?.stringValue ?? '',
        price: _getDoubleValue(fields, 'price'),
        realPrice: _getDoubleValue(fields, 'realPrice'),
        isAvailable: fields['isAvailable']?.booleanValue ?? false,
        sortOrder: 0,
      ),
    ];
  }

  Map<String, firestore_api.Value> _productFieldsToFirestore(Product product) {
    return {
      'productName': firestore_api.Value(stringValue: product.productName),
      'category': firestore_api.Value(stringValue: product.category),
      'imageUrl': firestore_api.Value(stringValue: product.imageUrl),
      'price': firestore_api.Value(doubleValue: product.price),
      'realPrice': firestore_api.Value(doubleValue: product.realPrice),
      'discount': firestore_api.Value(doubleValue: product.discount),
      'isAvailable': firestore_api.Value(booleanValue: product.isAvailable),
      'addedAt': firestore_api.Value(
        timestampValue: product.addedAt.toUtc().toIso8601String(),
      ),
      'subcategory': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: product.subcategory
              .map((s) => firestore_api.Value(stringValue: s))
              .toList(),
        ),
      ),
      'quantity': firestore_api.Value(stringValue: product.quantity),
      'countryOfOrigin': product.countryOfOrigin != null
          ? firestore_api.Value(stringValue: product.countryOfOrigin)
          : firestore_api.Value(nullValue: 'NULL_VALUE'),
      'searchKeywords': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: _generateSearchKeywords(
            product.productName,
            product.category,
            product.subcategory,
          ).map((s) => firestore_api.Value(stringValue: s)).toList(),
        ),
      ),
      'mostSearch': firestore_api.Value(
        integerValue: product.mostSearch.toString(),
      ),
      'mostPurchases': firestore_api.Value(
        integerValue: product.mostPurchases.toString(),
      ),
      'discountType': firestore_api.Value(stringValue: product.discountType),
      'discountValue': firestore_api.Value(doubleValue: product.discountValue),
      'bogoFreeProductIds': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: (product.bogoFreeProductIds ?? [])
              .map((id) => firestore_api.Value(stringValue: id))
              .toList(),
        ),
      ),
      'variants': firestore_api.Value(
        arrayValue: firestore_api.ArrayValue(
          values: (product.variants ?? const <ProductVariant>[])
              .map(
                (variant) => firestore_api.Value(
                  mapValue: firestore_api.MapValue(
                    fields: {
                      'variantId': firestore_api.Value(
                        stringValue: variant.variantId,
                      ),
                      'quantity': firestore_api.Value(
                        stringValue: variant.quantity,
                      ),
                      'price': firestore_api.Value(doubleValue: variant.price),
                      'realPrice': firestore_api.Value(
                        doubleValue: variant.realPrice,
                      ),
                      'isAvailable': firestore_api.Value(
                        booleanValue: variant.isAvailable,
                      ),
                      if (variant.sortOrder != null)
                        'sortOrder': firestore_api.Value(
                          integerValue: variant.sortOrder.toString(),
                        ),
                    },
                  ),
                ),
              )
              .toList(),
        ),
      ),
    };
  }

  double _getValueAsDouble(firestore_api.Value? value) {
    if (value == null) return 0.0;
    if (value.doubleValue != null) return value.doubleValue!;
    if (value.integerValue != null && value.integerValue!.isNotEmpty) {
      return double.tryParse(value.integerValue!) ?? 0.0;
    }
    return 0.0;
  }

  List<String> _stringListField(firestore_api.Value? value) {
    return (value?.arrayValue?.values ?? const [])
        .map((v) => v.stringValue ?? '')
        .where((v) => v.isNotEmpty)
        .toList();
  }

  Future<ProductPage> _fetchProductsPage(
    Session session, {
    required int limit,
    String? pageToken,
    String? category,
    List<String>? subcategories,
    String sortBy = 'name',
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    final finalFilter = _buildProductFilter(
      category: category,
      subcategories: subcategories,
    );

    final orderByList = <firestore_api.Order>[];
    final isDescending = sortBy == 'trending' || sortBy == 'best_sellers';
    if (sortBy == 'trending') {
      orderByList.add(
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'mostSearch'),
          direction: 'DESCENDING',
        ),
      );
    } else if (sortBy == 'best_sellers') {
      orderByList.add(
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'mostPurchases'),
          direction: 'DESCENDING',
        ),
      );
    } else {
      orderByList.add(
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'productName'),
          direction: 'ASCENDING',
        ),
      );
    }
    orderByList.add(
      firestore_api.Order(
        field: firestore_api.FieldReference(fieldPath: '__name__'),
        direction: isDescending ? 'DESCENDING' : 'ASCENDING',
      ),
    );

    firestore_api.Cursor? cursor;
    final decoded = _decodePageToken(pageToken);
    if (decoded != null) {
      final sortValue = decoded['sort'];
      final docName = decoded['doc'];
      if (sortValue != null && docName != null && docName.isNotEmpty) {
        cursor = firestore_api.Cursor(
          values: [
            _cursorSortValue(sortBy, sortValue),
            firestore_api.Value(referenceValue: docName),
          ],
          before: false,
        );
      }
    }

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Products')],
      where: finalFilter,
      limit: limit,
      orderBy: orderByList,
      startAt: cursor,
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    final products = <Product>[];
    String? lastSortValue;
    String? lastDocName;
    for (final res in response) {
      if (res.document?.fields == null) continue;
      final fields = res.document!.fields!;
      products.add(
        _productFromFirestore(
          res.document!.name!.split('/').last,
          fields,
        ),
      );
      lastSortValue = _extractSortValue(sortBy, fields);
      lastDocName = res.document!.name;
    }

    String? nextPageToken;
    if (products.length == limit &&
        lastSortValue != null &&
        lastDocName != null) {
      nextPageToken = _encodePageToken({
        'sort': lastSortValue,
        'doc': lastDocName,
      });
    }

    return ProductPage(
      products: products,
      nextPageToken: nextPageToken,
      totalCount: products.length,
    );
  }

  Future<int> _countProducts(
    Session session, {
    String? category,
    List<String>? subcategories,
  }) async {
    final firestore = await FirebaseService.getFirestoreClient();
    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    final finalFilter = _buildProductFilter(
      category: category,
      subcategories: subcategories,
    );

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Products')],
      where: finalFilter,
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    var count = 0;
    for (final res in response) {
      if (res.document != null) count++;
    }
    return count;
  }

  firestore_api.Filter? _buildProductFilter({
    String? category,
    List<String>? subcategories,
  }) {
    final filters = <firestore_api.Filter>[];

    if (category != null && category.isNotEmpty) {
      final cat = category.trim();
      final catLower = cat.toLowerCase();

      final List<String> catList = [cat];
      if (catLower != cat) catList.add(catLower);

      filters.add(
        firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'category'),
            op: 'IN',
            value: firestore_api.Value(
              arrayValue: firestore_api.ArrayValue(
                values: catList
                    .map((s) => firestore_api.Value(stringValue: s))
                    .toList(),
              ),
            ),
          ),
        ),
      );
    }

    if (subcategories != null && subcategories.isNotEmpty) {
      final List<String> expandedSubs = [];
      for (var sub in subcategories) {
        final trimmed = sub.trim();
        if (trimmed.isNotEmpty && !expandedSubs.contains(trimmed)) {
          expandedSubs.add(trimmed);
        }

        final lowered = trimmed.toLowerCase();
        if (lowered.isNotEmpty && !expandedSubs.contains(lowered)) {
          expandedSubs.add(lowered);
        }
      }

      final filterList = expandedSubs.take(10).toList();

      filters.add(
        firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'subcategory'),
            op: 'ARRAY_CONTAINS_ANY',
            value: firestore_api.Value(
              arrayValue: firestore_api.ArrayValue(
                values: filterList
                    .map((s) => firestore_api.Value(stringValue: s))
                    .toList(),
              ),
            ),
          ),
        ),
      );
    }

    if (filters.isEmpty) return null;
    if (filters.length == 1) return filters.first;
    return firestore_api.Filter(
      compositeFilter: firestore_api.CompositeFilter(
        op: 'AND',
        filters: filters,
      ),
    );
  }

  firestore_api.Value _cursorSortValue(String sortBy, String raw) {
    if (sortBy == 'trending' || sortBy == 'best_sellers') {
      return firestore_api.Value(integerValue: raw);
    }
    return firestore_api.Value(stringValue: raw);
  }

  String _extractSortValue(
    String sortBy,
    Map<String, firestore_api.Value> fields,
  ) {
    if (sortBy == 'trending') {
      return fields['mostSearch']?.integerValue ?? '0';
    }
    if (sortBy == 'best_sellers') {
      return fields['mostPurchases']?.integerValue ?? '0';
    }
    return fields['productName']?.stringValue ?? '';
  }

  String _encodePageToken(Map<String, String> payload) {
    return base64Url.encode(utf8.encode(jsonEncode(payload)));
  }

  Map<String, String>? _decodePageToken(String? token) {
    if (token == null || token.trim().isEmpty) return null;
    try {
      final decoded = utf8.decode(base64Url.decode(token));
      final map = jsonDecode(decoded);
      if (map is Map<String, dynamic>) {
        return map.map(
          (key, value) => MapEntry(key, value?.toString() ?? ''),
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
