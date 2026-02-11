import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class CategoryEndpoint extends Endpoint {
  Future<List<Category>> getCategories(Session session) async {
    final firestore = await FirebaseService.getFirestoreClient();

    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    final query = firestore_api.StructuredQuery(
      from: [firestore_api.CollectionSelector(collectionId: 'Categorys')],
      orderBy: [
        firestore_api.Order(
          field: firestore_api.FieldReference(fieldPath: 'categoryName'),
          direction: 'ASCENDING',
        ),
      ],
    );

    try {
      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      final categories = response.map((res) {
        final fields = res.document!.fields!;

        // Accept either 'subCategory' or 'subcategory' (some docs use different casing)
        final subField = fields['subCategory'] ?? fields['subcategory'];

        // Debug logging to help troubleshoot missing subcategories
        try {
          session.log('Category doc: ${res.document!.name}');
          session.log(
            '  categoryName: ${fields['categoryName']?.stringValue ?? ''}',
          );
          session.log('  found subField key: ${subField != null}');
          session.log(
            '  subField entries: ${subField?.mapValue?.fields?.length ?? 0}',
          );
          if (subField?.mapValue?.fields != null) {
            subField!.mapValue!.fields?.forEach((k, v) {
              session.log('    subkey: $k -> ${v.stringValue ?? '<null>'}');
            });
          }
        } catch (e) {
          session.log('Error logging subField details: $e');
        }

        return Category(
          categoryName: fields['categoryName']?.stringValue ?? '',
          categoryImageUrl: fields['categoryImageUrl']?.stringValue ?? '',
          subCategory: Map<String, String>.from(
            (subField?.mapValue?.fields ?? {}).map(
              (key, value) => MapEntry(
                key,
                value.stringValue ?? '',
              ),
            ),
          ),
        );
      }).toList();

      return categories;
    } catch (e, stack) {
      session.log('Error fetching categories: $e');
      session.log(stack.toString());
      rethrow;
    }
  }
}
