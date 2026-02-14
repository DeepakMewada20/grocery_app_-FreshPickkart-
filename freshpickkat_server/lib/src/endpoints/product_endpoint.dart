import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class ProductEndpoint extends Endpoint {
  Future<List<Product>> getProducts(
    Session session, {
    int limit = 10,
    String? lastProductName,
    String? category,
    List<String>? subcategories,
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

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Products')],
      where: finalFilter,
      limit: limit,
      orderBy: [
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'productName'),
          direction: 'ASCENDING',
        ),
      ],
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

            return Product(
              productId: res.document!.name!.split('/').last,
              productName: fields['productName']?.stringValue ?? '',
              category: fields['category']?.stringValue ?? '',
              imageUrl: fields['imageUrl']?.stringValue ?? '',
              price: int.tryParse(fields['price']?.integerValue ?? '0') ?? 0,
              realPrice:
                  int.tryParse(fields['realPrice']?.integerValue ?? '0') ?? 0,
              discount:
                  int.tryParse(fields['discount']?.integerValue ?? '0') ?? 0,
              isAvailable: fields['isAvailable']?.booleanValue ?? false,
              addedAt:
                  DateTime.tryParse(fields['addedAt']?.timestampValue ?? '') ??
                  DateTime.now(),
              subcategory: (fields['subcategory']?.arrayValue?.values ?? [])
                  .map((v) => v.stringValue ?? '')
                  .toList(),
              quantity: fields['quantity']?.stringValue ?? "",
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
          integerValue: product.price.toString(),
        ),
        'realPrice': firestore_api.Value(
          integerValue: product.realPrice.toString(),
        ),
        'discount': firestore_api.Value(
          integerValue: product.discount.toString(),
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
}
