import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_category_service.dart';

class CategoryEndpoint extends Endpoint {
  final PostgresCategoryService _categories = PostgresCategoryService();

  Future<List<Category>> getCategories(Session session) async {
    return _categories.getCategories(session);
  }

  Future<bool> uploadCategory(
    Session session,
    Category category,
    String firebaseUid,
    String idToken,
  ) async {
    return _categories.uploadCategory(
      session,
      category,
      firebaseUid,
      idToken,
    );
  }
}
