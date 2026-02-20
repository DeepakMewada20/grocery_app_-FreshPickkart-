import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;
import 'dart:math';

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

    // Build filters
    List<firestore_api.Filter> filters = [];

    if (category != null && category.isNotEmpty) {
      final cat = category.trim();
      final catLower = cat.toLowerCase();

      // Use 'IN' to search for both cases
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
      // Expand list to include lowercase versions for case-insensitive(ish) matching
      // Note: Firestore ARRAY_CONTAINS_ANY allows up to 10 values.
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

      // Safeguard against too many filters (Firestore limit is 10)
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

    firestore_api.Filter? finalFilter;
    if (filters.isNotEmpty) {
      if (filters.length == 1) {
        finalFilter = filters.first;
      } else {
        finalFilter = firestore_api.Filter(
          compositeFilter: firestore_api.CompositeFilter(
            op: 'AND',
            filters: filters,
          ),
        );
      }
    }

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

            // Helper to safely extract double/int values from Firestore
            double getDoubleValue(
              Map<String, firestore_api.Value> fields,
              String key,
            ) {
              final value = fields[key];
              if (value == null) return 0.0;

              // Try doubleValue first
              if (value.doubleValue != null) {
                return value.doubleValue!;
              }

              // Try integerValue (as string)
              if (value.integerValue != null &&
                  value.integerValue!.isNotEmpty) {
                return double.tryParse(value.integerValue!) ?? 0.0;
              }

              return 0.0;
            }

            return Product(
              productId: res.document!.name!.split('/').last,
              productName: fields['productName']?.stringValue ?? '',
              category: fields['category']?.stringValue ?? '',
              imageUrl: fields['imageUrl']?.stringValue ?? '',
              price: getDoubleValue(fields, 'price'),
              realPrice: getDoubleValue(fields, 'realPrice'),
              discount: getDoubleValue(fields, 'discount'),
              isAvailable: fields['isAvailable']?.booleanValue ?? false,
              addedAt:
                  DateTime.tryParse(fields['addedAt']?.timestampValue ?? '') ??
                  DateTime.now(),
              subcategory: (fields['subcategory']?.arrayValue?.values ?? [])
                  .map((v) => v.stringValue ?? '')
                  .toList(),
              quantity: fields['quantity']?.stringValue ?? "",
              searchKeywords:
                  (fields['searchKeywords']?.arrayValue?.values ?? [])
                      .map((v) => v.stringValue ?? '')
                      .toList(),
              mostSearch:
                  int.tryParse(fields['mostSearch']?.integerValue ?? '0') ?? 0,
              mostPurchases:
                  int.tryParse(fields['mostPurchases']?.integerValue ?? '0') ??
                  0,
            );
          })
          .toList();
      return products;
    } catch (e) {
      rethrow;
    }
  }

  /// Upload a product to Firestore 'Products' collection
  Future<bool> uploadProduct(Session session, Product product) async {
    final firestore = await FirebaseService.getFirestoreClient();

    final String parent =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    // Convert Product to Firestore Document fields
    final document = firestore_api.Document(
      fields: {
        'productName': firestore_api.Value(stringValue: product.productName),
        'category': firestore_api.Value(stringValue: product.category),
        'imageUrl': firestore_api.Value(stringValue: product.imageUrl),
        'price': firestore_api.Value(
          doubleValue: product.price,
        ),
        'realPrice': firestore_api.Value(
          doubleValue: product.realPrice,
        ),
        'discount': firestore_api.Value(
          doubleValue: product.discount,
        ),
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
      },
    );

    try {
      await firestore.projects.databases.documents.createDocument(
        document,
        parent, // parent path = database/documents root
        'Products', // collection ID
      );
      session.log('Product uploaded: ${product.productName}');
      return true;
    } catch (e, stack) {
      session.log('Error uploading product: $e');
      session.log(stack.toString());
      rethrow;
    }
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
        return Product(
          productId: res.document!.name!.split('/').last,
          productName: fields['productName']?.stringValue ?? '',
          category: fields['category']?.stringValue ?? '',
          imageUrl: fields['imageUrl']?.stringValue ?? '',
          price:
              double.tryParse(
                fields['price']?.doubleValue?.toString() ??
                    fields['price']?.integerValue ??
                    '0',
              ) ??
              0.0,
          realPrice:
              double.tryParse(
                fields['realPrice']?.doubleValue?.toString() ??
                    fields['realPrice']?.integerValue ??
                    '0',
              ) ??
              0.0,
          discount:
              double.tryParse(
                fields['discount']?.doubleValue?.toString() ??
                    fields['discount']?.integerValue ??
                    '0',
              ) ??
              0.0,
          isAvailable: fields['isAvailable']?.booleanValue ?? false,
          addedAt:
              DateTime.tryParse(fields['addedAt']?.timestampValue ?? '') ??
              DateTime.now(),
          subcategory: (fields['subcategory']?.arrayValue?.values ?? [])
              .map((v) => v.stringValue ?? '')
              .toList(),
          quantity: fields['quantity']?.stringValue ?? "",
          searchKeywords: (fields['searchKeywords']?.arrayValue?.values ?? [])
              .map((v) => v.stringValue ?? '')
              .toList(),
          mostSearch:
              int.tryParse(fields['mostSearch']?.integerValue ?? '0') ?? 0,
          mostPurchases:
              int.tryParse(fields['mostPurchases']?.integerValue ?? '0') ?? 0,
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

              return Product(
                productId: id,
                productName: fields['productName']?.stringValue ?? '',
                category: fields['category']?.stringValue ?? '',
                imageUrl: fields['imageUrl']?.stringValue ?? '',
                price:
                    double.tryParse(
                      fields['price']?.doubleValue?.toString() ??
                          fields['price']?.integerValue ??
                          '0',
                    ) ??
                    0.0,
                realPrice:
                    double.tryParse(
                      fields['realPrice']?.doubleValue?.toString() ??
                          fields['realPrice']?.integerValue ??
                          '0',
                    ) ??
                    0.0,
                discount:
                    double.tryParse(
                      fields['discount']?.doubleValue?.toString() ??
                          fields['discount']?.integerValue ??
                          '0',
                    ) ??
                    0.0,
                isAvailable: fields['isAvailable']?.booleanValue ?? false,
                addedAt:
                    DateTime.tryParse(
                      fields['addedAt']?.timestampValue ?? '',
                    ) ??
                    DateTime.now(),
                subcategory: (fields['subcategory']?.arrayValue?.values ?? [])
                    .map((v) => v.stringValue ?? '')
                    .toList(),
                quantity: fields['quantity']?.stringValue ?? "",
                searchKeywords:
                    (fields['searchKeywords']?.arrayValue?.values ?? [])
                        .map((v) => v.stringValue ?? '')
                        .toList(),
                mostSearch:
                    int.tryParse(fields['mostSearch']?.integerValue ?? '0') ??
                    0,
                mostPurchases:
                    int.tryParse(
                      fields['mostPurchases']?.integerValue ?? '0',
                    ) ??
                    0,
              );
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
}
