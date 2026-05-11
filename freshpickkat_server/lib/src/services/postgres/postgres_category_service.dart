import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'postgres_admin_guard_service.dart';
import 'postgres_audit_log_service.dart';
import 'postgres_support.dart';

class PostgresCategoryService {
  PostgresCategoryService({
    PostgresAdminGuardService? guard,
    PostgresAuditLogService? audit,
  }) : _guard = guard ?? PostgresAdminGuardService(),
       _audit = audit ?? PostgresAuditLogService();

  final PostgresAdminGuardService _guard;
  final PostgresAuditLogService _audit;

  Future<List<Category>> getCategories(Session session) async {
    final categories = await CategoryRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
    );
    categories.sort(_sortCategoryRows);

    if (categories.isEmpty) return const [];

    final categoryIds = categories
        .map((row) => row.id)
        .whereType<UuidValue>()
        .toSet();
    final subCategories = await SubCategoryRow.db.find(
      session,
      where: (t) =>
          t.categoryId.inSet(categoryIds) & t.status.equals('active'),
    );
    subCategories.sort(_sortSubCategoryRows);

    final subCategoryMap = <String, Map<String, String>>{};
    for (final row in subCategories) {
      subCategoryMap.putIfAbsent(row.categoryId.toString(), () => {});
      subCategoryMap[row.categoryId.toString()]![row.name] = row.imageUrl ?? '';
    }

    return categories
        .map(
          (row) => Category(
            categoryName: row.name,
            categoryImageUrl: row.imageUrl ?? '',
            subCategory: subCategoryMap[row.id.toString()] ?? const {},
          ),
        )
        .toList();
  }

  Future<List<SubCategory>> getSubCategories(Session session) async {
    final categories = await CategoryRow.db.find(
      session,
      where: (t) => t.status.equals('active'),
    );
    final categoryById = {
      for (final row in categories)
        if (row.id != null) row.id!.toString(): row,
    };
    if (categoryById.isEmpty) return const [];

    final categoryIds = categoryById.values.map((row) => row.id!).toSet();
    final subCategories = await SubCategoryRow.db.find(
      session,
      where: (t) =>
          t.categoryId.inSet(categoryIds) & t.status.equals('active'),
    );
    subCategories.sort(_sortSubCategoryRows);

    return subCategories.map((row) {
      final category = categoryById[row.categoryId.toString()];
      if (category == null) {
        return null;
      }

      return SubCategory(
        categoryId: category.name,
        subCategoriesName: [row.name],
        subCategoriesUrl: row.imageUrl ?? '',
      );
    }).whereType<SubCategory>().toList();
  }

  Future<bool> uploadCategory(
    Session session,
    Category category,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _guard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final createdCategoryId = await session.db.transaction<UuidValue>((
      transaction,
    ) async {
      final categoryName = _requireName(
        category.categoryName,
        fieldName: 'categoryName',
      );
      final slug = _slugify(categoryName);

      final existing = await _findCategoryBySlug(
        session,
        slug,
        transaction: transaction,
      );
      if (existing != null) {
        throw Exception('Category already exists');
      }

      final inserted = await CategoryRow.db.insertRow(
        session,
        CategoryRow(
          name: categoryName,
          slug: slug,
          imageUrl: cleanNullableString(category.categoryImageUrl),
          status: 'active',
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );

      final insertedCategoryId = inserted.id;
      if (insertedCategoryId == null) {
        throw Exception('Failed to create category.');
      }

      final seenSubCategorySlugs = <String>{};
      for (final entry in category.subCategory.entries) {
        final subCategoryName = cleanNullableString(entry.key);
        if (subCategoryName == null) continue;

        final subSlug = _slugify(subCategoryName);
        if (!seenSubCategorySlugs.add(subSlug)) {
          throw Exception('Duplicate subcategory name: $subCategoryName');
        }

        await SubCategoryRow.db.insertRow(
          session,
          SubCategoryRow(
            categoryId: insertedCategoryId,
            name: subCategoryName,
            slug: subSlug,
            imageUrl: cleanNullableString(entry.value),
            status: 'active',
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
          transaction: transaction,
        );
      }

      return insertedCategoryId;
    });

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'create',
      entityType: 'category',
      entityId: createdCategoryId.toString(),
      metadata: {'name': category.categoryName},
    );
    return true;
  }

  Future<bool> deleteCategory(
    Session session,
    String categoryName,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _guard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final category = await _resolveCategory(session, categoryName);
    if (category == null) throw Exception('Category not found');

    category.status = 'deleted';
    category.updatedAt = DateTime.now().toUtc();
    await CategoryRow.db.updateRow(session, category);

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'delete',
      entityType: 'category',
      entityId: category.id.toString(),
      metadata: {'name': categoryName},
    );
    return true;
  }

  Future<bool> updateCategory(
    Session session,
    String oldName,
    Category category,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _guard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final existing = await _resolveCategory(session, oldName);
    if (existing == null) throw Exception('Category not found');

    final newName = _requireName(category.categoryName, fieldName: 'categoryName');
    final newSlug = _slugify(newName);

    if (newSlug != existing.slug) {
      final conflict = await _findCategoryBySlug(session, newSlug);
      if (conflict != null) throw Exception('New category name already exists');
    }

    existing.name = newName;
    existing.slug = newSlug;
    existing.imageUrl = cleanNullableString(category.categoryImageUrl);
    existing.updatedAt = DateTime.now().toUtc();

    await CategoryRow.db.updateRow(session, existing);

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'update',
      entityType: 'category',
      entityId: existing.id.toString(),
      metadata: {'old_name': oldName, 'new_name': newName},
    );
    return true;
  }

  Future<bool> uploadSubCategory(
    Session session,
    SubCategory subCategory,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _guard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final createdSubCategoryIds = await session.db.transaction<List<UuidValue>>((
      transaction,
    ) async {
      final category = await _resolveCategory(
        session,
        subCategory.categoryId,
        transaction: transaction,
      );
      final categoryId = category?.id;
      if (categoryId == null) {
        throw Exception('Category not found');
      }

      final imageUrl = cleanNullableString(subCategory.subCategoriesUrl);
      final created = <UuidValue>[];
      final seenSubCategorySlugs = <String>{};
      for (final rawName in subCategory.subCategoriesName) {
        final subCategoryName = cleanNullableString(rawName);
        if (subCategoryName == null) continue;

        final slug = _slugify(subCategoryName);
        if (!seenSubCategorySlugs.add(slug)) {
          throw Exception('Duplicate subcategory name: $subCategoryName');
        }

        final existing = await SubCategoryRow.db.findFirstRow(
          session,
          where: (t) =>
              t.categoryId.equals(categoryId) & t.slug.equals(slug),
          transaction: transaction,
        );
        if (existing != null) {
          throw Exception('Subcategory already exists: $subCategoryName');
        }

        final inserted = await SubCategoryRow.db.insertRow(
          session,
          SubCategoryRow(
            categoryId: categoryId,
            name: subCategoryName,
            slug: slug,
            imageUrl: imageUrl,
            status: 'active',
            createdAt: DateTime.now().toUtc(),
            updatedAt: DateTime.now().toUtc(),
          ),
          transaction: transaction,
        );

        if (inserted.id != null) {
          created.add(inserted.id!);
        }
      }

      return created;
    });

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'create',
      entityType: 'sub_category',
      entityId: createdSubCategoryIds.isEmpty
          ? null
          : createdSubCategoryIds.first.toString(),
      metadata: {'category': subCategory.categoryId},
    );
    return true;
  }

  Future<bool> deleteSubCategory(
    Session session,
    String categoryName,
    String subCategoryName,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _guard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    final category = await _resolveCategory(session, categoryName);
    if (category == null) throw Exception('Parent category not found');

    final subSlug = _slugify(subCategoryName);
    final subCategory = await SubCategoryRow.db.findFirstRow(
      session,
      where: (t) => t.categoryId.equals(category.id!) & t.slug.equals(subSlug),
    );

    if (subCategory == null) throw Exception('Subcategory not found');

    subCategory.status = 'deleted';
    subCategory.updatedAt = DateTime.now().toUtc();
    await SubCategoryRow.db.updateRow(session, subCategory);

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'delete',
      entityType: 'sub_category',
      entityId: subCategory.id.toString(),
      metadata: {'name': subCategoryName, 'category': categoryName},
    );
    return true;
  }

  Future<bool> updateSubCategory(
    Session session,
    String categoryName,
    String oldSubName,
    SubCategory subCategory,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _guard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );

    // Resolve OLD parent category (used to find the existing row)
    final oldCategory = await _resolveCategory(session, categoryName);
    if (oldCategory == null) throw Exception('Parent category not found');

    final oldSlug = _slugify(oldSubName);
    final existing = await SubCategoryRow.db.findFirstRow(
      session,
      where: (t) =>
          t.categoryId.equals(oldCategory.id!) & t.slug.equals(oldSlug),
    );
    if (existing == null) throw Exception('Subcategory not found');

    // Resolve NEW parent category (may be different if user changed it)
    final newCategoryName = subCategory.categoryId;
    final newCategory = await _resolveCategory(session, newCategoryName);
    if (newCategory == null) throw Exception('New parent category not found');

    final newName = _requireName(
      subCategory.subCategoriesName.first,
      fieldName: 'subCategoryName',
    );
    final newSlug = _slugify(newName);

    // Duplicate check: does newSlug already exist in the NEW parent?
    final isSameCategory = newCategory.id == oldCategory.id;
    final isNameUnchanged = newSlug == oldSlug;
    if (!(isSameCategory && isNameUnchanged)) {
      final conflict = await SubCategoryRow.db.findFirstRow(
        session,
        where: (t) =>
            t.categoryId.equals(newCategory.id!) & t.slug.equals(newSlug),
      );
      if (conflict != null) {
        throw Exception(
          'Subcategory "$newName" already exists in the selected category',
        );
      }
    }

    // Apply all changes including new parent categoryId
    existing.categoryId = newCategory.id!;
    existing.name = newName;
    existing.slug = newSlug;
    existing.imageUrl = cleanNullableString(subCategory.subCategoriesUrl);
    existing.updatedAt = DateTime.now().toUtc();

    await SubCategoryRow.db.updateRow(session, existing);

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'update',
      entityType: 'sub_category',
      entityId: existing.id.toString(),
      metadata: {
        'old_category': categoryName,
        'new_category': newCategoryName,
        'old_name': oldSubName,
        'new_name': newName,
      },
    );
    return true;
  }

  Future<CategoryRow?> _findCategoryBySlug(
    Session session,
    String slug, {
    Transaction? transaction,
  }) {
    return CategoryRow.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug) & t.status.equals('active'),
      transaction: transaction,
    );
  }

  Future<CategoryRow?> _resolveCategory(
    Session session,
    String rawCategory, {
    Transaction? transaction,
  }) async {
    final normalized = cleanNullableString(rawCategory);
    if (normalized == null) return null;

    final parsedId = tryParseUuid(normalized);
    if (parsedId != null) {
      final byId = await CategoryRow.db.findById(
        session,
        parsedId,
        transaction: transaction,
      );
      if (byId != null) return byId;
    }

    final slug = _slugify(normalized);
    return _findCategoryBySlug(
      session,
      slug,
      transaction: transaction,
    );
  }

  int _sortCategoryRows(CategoryRow a, CategoryRow b) {
    final displayOrder = a.displayOrder.compareTo(b.displayOrder);
    if (displayOrder != 0) return displayOrder;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  }

  int _sortSubCategoryRows(SubCategoryRow a, SubCategoryRow b) {
    final categoryOrder = a.categoryId
        .toString()
        .compareTo(b.categoryId.toString());
    if (categoryOrder != 0) return categoryOrder;

    final displayOrder = a.displayOrder.compareTo(b.displayOrder);
    if (displayOrder != 0) return displayOrder;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  }

  String _requireName(
    String value, {
    required String fieldName,
  }) {
    final normalized = cleanNullableString(value);
    if (normalized == null) {
      throw Exception('$fieldName is required.');
    }
    return normalized;
  }

  String _slugify(String value) {
    final normalized = value.trim().toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '_',
    );
    return normalized.replaceAll(RegExp(r'^_+|_+$'), '');
  }
}
