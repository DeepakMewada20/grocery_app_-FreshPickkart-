import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class CategoryEndpoint extends Endpoint {
  /// Helper: find a field by name case-insensitively and trimmed.
  firestore_api.Value? _findField(
    Map<String, firestore_api.Value> fields,
    String target,
  ) {
    // 1. Exact match first
    if (fields.containsKey(target)) return fields[target];

    // 2. Case-insensitive + trimmed match
    final lower = target.toLowerCase().trim();
    for (final entry in fields.entries) {
      if (entry.key.toLowerCase().trim() == lower) {
        return entry.value;
      }
    }
    return null;
  }

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

        // Case-insensitive lookup for subCategory field
        final subField = _findField(fields, 'subCategory');

        // Debug: log ALL field keys so we can see exactly what Firestore returns
        try {
          final docName = res.document!.name ?? 'unknown';
          final catName = fields['categoryName']?.stringValue ?? '';
          session.log('=== Category doc: $docName ===');
          session.log('  categoryName: $catName');
          session.log('  ALL field keys: ${fields.keys.toList()}');
          session.log('  subField found: ${subField != null}');

          if (subField != null) {
            final mapFields = subField.mapValue?.fields;
            session.log(
              '  subField.mapValue.fields count: ${mapFields?.length ?? 0}',
            );
            if (mapFields != null) {
              for (final entry in mapFields.entries) {
                final val =
                    entry.value.stringValue ??
                    entry.value.integerValue ??
                    entry.value.doubleValue?.toString() ??
                    '<non-string>';
                session.log('    sub: "${entry.key}" -> "$val"');
              }
            } else {
              // Maybe not a mapValue — log what type it is
              session.log(
                '  subField is NOT a mapValue. '
                'stringValue=${subField.stringValue}, '
                'arrayValue=${subField.arrayValue}, '
                'nullValue=${subField.nullValue}',
              );
            }
          }
        } catch (e) {
          session.log('Error logging subField details: $e');
        }

        // Build the subCategory map, handling non-string values gracefully
        final rawMap = subField?.mapValue?.fields ?? {};
        final subCategoryMap = <String, String>{};
        for (final entry in rawMap.entries) {
          final value =
              entry.value.stringValue ??
              entry.value.integerValue ??
              entry.value.doubleValue?.toString() ??
              '';
          subCategoryMap[entry.key] = value;
        }

        return Category(
          categoryName: fields['categoryName']?.stringValue ?? '',
          categoryImageUrl: fields['categoryImageUrl']?.stringValue ?? '',
          subCategory: subCategoryMap,
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
