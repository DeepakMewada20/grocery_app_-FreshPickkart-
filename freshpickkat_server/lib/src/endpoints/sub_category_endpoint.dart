import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import '../services/role_guard_service.dart';
import '../services/business/audit_log_service.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class SubCategoryEndpoint extends Endpoint {
  /// Fetch all subcategories from Firestore 'subCategories' collection
  Future<List<SubCategory>> getSubCategories(Session session) async {
    final firestore = await FirebaseService.getFirestoreClient();

    final String database =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    final query = firestore_api.StructuredQuery(
      from: [
        firestore_api.CollectionSelector(collectionId: 'subCategories'),
      ],
    );

    try {
      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      final subCategories = response.where((res) => res.document != null).map((
        res,
      ) {
        final fields = res.document!.fields!;

        return SubCategory(
          categoryId: fields['categoryId']?.stringValue ?? '',
          subCategoriesName:
              (fields['subCategoriesName']?.arrayValue?.values ?? [])
                  .map((v) => v.stringValue ?? '')
                  .toList(),
          subCategoriesUrl: fields['subCategoriesUrl']?.stringValue ?? '',
        );
      }).toList();

      return subCategories;
    } catch (e, stack) {
      session.log('Error fetching subCategories: $e');
      session.log(stack.toString());
      rethrow;
    }
  }

  /// Upload a subcategory to Firestore 'subCategories' collection
  Future<bool> uploadSubCategory(
    Session session,
    SubCategory subCategory,
    String firebaseUid,
    String idToken,
  ) async {
    final firestore = await FirebaseService.getFirestoreClient();
    await RoleGuardService.ensureAdminSeller(
      firestore: firestore,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final String parent =
        'projects/freshpickkart-a6824/databases/(default)/documents';

    final document = firestore_api.Document(
      fields: {
        'categoryId': firestore_api.Value(
          stringValue: subCategory.categoryId,
        ),
        'subCategoriesName': firestore_api.Value(
          arrayValue: firestore_api.ArrayValue(
            values: subCategory.subCategoriesName
                .map((s) => firestore_api.Value(stringValue: s))
                .toList(),
          ),
        ),
        'subCategoriesUrl': firestore_api.Value(
          stringValue: subCategory.subCategoriesUrl,
        ),
      },
    );

    try {
      await firestore.projects.databases.documents.createDocument(
        document,
        parent,
        'subCategories',
      );
      await AuditLogService.write(
        firestore: firestore,
        actorUid: firebaseUid,
        action: 'create',
        entityType: 'sub_category',
        entityId: subCategory.subCategoriesName.join(','),
        metadata: {'categoryId': subCategory.categoryId},
      );
      session.log(
        'SubCategory uploaded for categoryId: ${subCategory.categoryId}',
      );
      return true;
    } catch (e, stack) {
      session.log('Error uploading subCategory: $e');
      session.log(stack.toString());
      rethrow;
    }
  }
}
