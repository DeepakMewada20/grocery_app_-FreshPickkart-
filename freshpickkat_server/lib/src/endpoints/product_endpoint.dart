import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class ProductEndpoint extends Endpoint {
  Future<List<Product>> getProducts(Session session, {int limit = 10, String? lastProductName}) async {
    final firestore = await FirebaseService.getFirestoreClient();
    
    // Aapke project ki database path
    // freshpickkart-a6824 aapka Project ID hai
    final String database = 'projects/freshpickkart-a6824/databases/(default)/documents';

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'products')],
      limit: limit,
      orderBy: [
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'productName'),
          direction: 'ASCENDING',
        )
      ],
      // Pagination: startAfter logic
      startAt: lastProductName != null 
          ? firestore_api.Cursor(
              values: [firestore_api.Value(stringValue: lastProductName)],
              before: false, // false matlab start AFTER this name
            ) 
          : null,
    );

    final response = await firestore.projects.databases.documents.runQuery(
      firestore_api.RunQueryRequest(structuredQuery: query),
      database,
    );

    return response.map((res) {
      final fields = res.document!.fields!;
      
      return Product(
        productId: res.document!.name!.split('/').last,
        productName: fields['productName']?.stringValue ?? '',
        category: fields['category']?.stringValue ?? '',
        imageUrl: fields['imageUrl']?.stringValue ?? '',
        price: int.tryParse(fields['price']?.integerValue ?? '0') ?? 0,
        realPrice: int.tryParse(fields['realPrice']?.integerValue ?? '0') ?? 0,
        discount: int.tryParse(fields['discount']?.integerValue ?? '0') ?? 0,
        isAvailable: fields['isAvailable']?.booleanValue ?? false,
        addedAt: DateTime.tryParse(fields['addedAt']?.timestampValue ?? '') ?? DateTime.now(),
        subcategory: (fields['subcategory']?.arrayValue?.values ?? [])
            .map((v) => v.stringValue ?? '')
            .toList(),
      );
    }).toList();
  }
}