import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_category_service.dart';

class SubCategoryEndpoint extends Endpoint {
  final PostgresCategoryService _categories = PostgresCategoryService();

  Future<List<SubCategory>> getSubCategories(Session session) async {
    return _categories.getSubCategories(session);
  }

  Future<bool> uploadSubCategory(
    Session session,
    SubCategory subCategory,
    String firebaseUid,
    String idToken,
  ) async {
    return _categories.uploadSubCategory(
      session,
      subCategory,
      firebaseUid,
      idToken,
    );
  }

  Future<bool> updateSubCategory(
    Session session,
    String categoryName,
    String oldSubName,
    SubCategory subCategory,
    String firebaseUid,
    String idToken,
  ) async {
    return _categories.updateSubCategory(
      session,
      categoryName,
      oldSubName,
      subCategory,
      firebaseUid,
      idToken,
    );
  }

  Future<bool> deleteSubCategory(
    Session session,
    String categoryName,
    String subCategoryName,
    String firebaseUid,
    String idToken,
  ) async {
    return _categories.deleteSubCategory(
      session,
      categoryName,
      subCategoryName,
      firebaseUid,
      idToken,
    );
  }
}
