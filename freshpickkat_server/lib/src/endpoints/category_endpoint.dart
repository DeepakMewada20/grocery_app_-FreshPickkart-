import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_category_service.dart';

class CategoryEndpoint extends Endpoint {
  final PostgresCategoryService _categories = PostgresCategoryService();
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();

  Future<List<Category>> getCategories(Session session) async {
    return _categories.getCategories(session);
  }

  Future<List<Category>> getAllCategories(Session session) async {
    return _categories.getAllCategories(session);
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

  Future<bool> updateCategory(
    Session session,
    String oldName,
    Category category,
    String firebaseUid,
    String idToken,
  ) async {
    return _categories.updateCategory(
      session,
      oldName,
      category,
      firebaseUid,
      idToken,
    );
  }

  Future<String> deleteCategory(
    Session session,
    String categoryName,
    String firebaseUid,
    String idToken,
  ) async {
    return _categories.deleteCategory(
      session,
      categoryName,
      firebaseUid,
      idToken,
    );
  }

  Future<bool> setCategoryActive(
    Session session,
    String categoryName,
    bool isActive,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final result = await _categories.setCategoryActive(
      session,
      categoryName,
      isActive,
    );
    if (result) {
      await _audit.write(
        session,
        actorUserId: actor.id,
        action: isActive ? 'enable' : 'disable',
        entityType: 'category',
        entityId: categoryName,
        metadata: {'name': categoryName},
      );
    }
    return result;
  }
}
