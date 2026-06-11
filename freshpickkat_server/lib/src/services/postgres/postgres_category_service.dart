import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../dependency_checker.dart';
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
            isActive: row.status == 'active',
          ),
        )
        .toList();
  }

  Future<List<Category>> getInactiveCategories(Session session) async {
    final categories = await CategoryRow.db.find(
      session,
      where: (t) => t.status.equals('inactive'),
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
            isActive: false,
          ),
        )
        .toList();
  }

  Future<List<Category>> getAllCategories(Session session) async {
    final categories = await CategoryRow.db.find(session);
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
            isActive: row.status == 'active',
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

    final groupedMap = <String, Map<String, dynamic>>{};
    for (final row in subCategories) {
      final category = categoryById[row.categoryId.toString()];
      if (category == null) continue;

      final secondsSinceEpoch = row.createdAt.millisecondsSinceEpoch ~/ 1000;
      final key = '${row.categoryId.toString()}|${row.imageUrl ?? ''}|$secondsSinceEpoch';

      groupedMap.putIfAbsent(key, () => {
        'categoryId': category.name,
        'names': <String>[],
        'imageUrl': row.imageUrl ?? '',
      });
      (groupedMap[key]!['names'] as List<String>).add(row.name);
    }

    return groupedMap.values.map((group) {
      return SubCategory(
        categoryId: group['categoryId'] as String,
        subCategoriesName: group['names'] as List<String>,
        subCategoriesUrl: group['imageUrl'] as String,
      );
    }).toList();
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
        throw Exception('Category already exists: "${existing.name}" (Status: ${existing.status})');
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

  Future<String> deleteCategory(
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
    if (category == null) return 'Category not found';

    final refs = await DependencyChecker.checkCategory(session, category.id!);
    if (refs.isNotEmpty) {
      return DependencyChecker.formatRefs(refs);
    }

    final now = DateTime.now().toUtc();
    await CategoryRow.db.updateRow(
      session,
      category.copyWith(
        status: 'inactive',
        deactivatedAt: now,
        updatedAt: now,
      ),
    );

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'delete',
      entityType: 'category',
      entityId: category.id.toString(),
      metadata: {'name': categoryName},
    );
    return '';
  }

  Future<bool> setCategoryActive(
    Session session,
    String categoryName,
    bool isActive, {
    Transaction? transaction,
  }) async {
    final category = await _resolveCategory(session, categoryName);
    if (category == null) return false;

    final now = DateTime.now().toUtc();
    await CategoryRow.db.updateRow(
      session,
      category.copyWith(
        status: isActive ? 'active' : 'inactive',
        deactivatedAt: isActive ? null : now,
        updatedAt: now,
      ),
      transaction: transaction,
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
  Future<String> deleteSubCategory(
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
    if (category == null) return 'Parent category not found';

    final subSlug = _slugify(subCategoryName);
    final subCategory = await SubCategoryRow.db.findFirstRow(
      session,
      where: (t) => t.categoryId.equals(category.id!) & t.slug.equals(subSlug),
    );

    if (subCategory == null) return 'Subcategory not found';

    final refs = await DependencyChecker.checkSubCategory(
      session,
      subCategory.id!,
    );
    if (refs.isNotEmpty) {
      return DependencyChecker.formatRefs(refs);
    }

    final secondsSinceEpoch = subCategory.createdAt.millisecondsSinceEpoch ~/ 1000;
    final allGroupCandidates = await SubCategoryRow.db.find(
      session,
      where: (t) => t.categoryId.equals(category.id!),
    );
    final targetGroupRows = allGroupCandidates.where((row) {
      final sameImage = row.imageUrl == subCategory.imageUrl;
      final sameSecond = row.createdAt.millisecondsSinceEpoch ~/ 1000 == secondsSinceEpoch;
      return sameImage && sameSecond;
    }).toList();

    final now = DateTime.now().toUtc();
    for (final row in targetGroupRows) {
      await SubCategoryRow.db.updateRow(
        session,
        row.copyWith(
          status: 'inactive',
          deactivatedAt: now,
          updatedAt: now,
        ),
      );
    }

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'delete',
      entityType: 'sub_category',
      entityId: subCategory.id.toString(),
      metadata: {
        'name': subCategoryName,
        'category': categoryName,
        'deleted_names': targetGroupRows.map((r) => r.name).join(', '),
      },
    );
    return '';
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

    // Resolve OLD parent category
    final oldCategory = await _resolveCategory(session, categoryName);
    if (oldCategory == null) throw Exception('Parent category not found');

    final oldSlug = _slugify(oldSubName);
    final targetRow = await SubCategoryRow.db.findFirstRow(
      session,
      where: (t) =>
          t.categoryId.equals(oldCategory.id!) & t.slug.equals(oldSlug),
    );
    if (targetRow == null) throw Exception('Subcategory not found');

    final secondsSinceEpoch = targetRow.createdAt.millisecondsSinceEpoch ~/ 1000;
    final allUpdateCandidates = await SubCategoryRow.db.find(
      session,
      where: (t) => t.categoryId.equals(oldCategory.id!),
    );
    final oldGroupRows = allUpdateCandidates.where((row) {
      final sameImage = row.imageUrl == targetRow.imageUrl;
      final sameSecond = row.createdAt.millisecondsSinceEpoch ~/ 1000 == secondsSinceEpoch;
      return sameImage && sameSecond;
    }).toList();

    // Resolve NEW parent category
    final newCategoryName = subCategory.categoryId;
    final newCategory = await _resolveCategory(session, newCategoryName);
    if (newCategory == null) throw Exception('New parent category not found');

    final newImageUrl = cleanNullableString(subCategory.subCategoriesUrl);
    final newNames = subCategory.subCategoriesName
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toSet();

    if (newNames.isEmpty) {
      throw Exception('Subcategory name list cannot be empty.');
    }

    final oldNamesSet = oldGroupRows.map((r) => r.name.toLowerCase()).toSet();
    for (final name in newNames) {
      if (oldNamesSet.contains(name.toLowerCase()) && newCategory.id == oldCategory.id) {
        continue;
      }
      final newSlug = _slugify(name);
      final conflict = await SubCategoryRow.db.findFirstRow(
        session,
        where: (t) =>
            t.categoryId.equals(newCategory.id!) & t.slug.equals(newSlug),
      );
      if (conflict != null) {
        throw Exception('Subcategory "$name" already exists in the selected category');
      }
    }

    await session.db.transaction((transaction) async {
      for (final oldRow in oldGroupRows) {
        if (!newNames.any((n) => n.toLowerCase() == oldRow.name.toLowerCase())) {
          await ProductSubCategoryRow.db.deleteWhere(
            session,
            where: (t) => t.subCategoryId.equals(oldRow.id!),
            transaction: transaction,
          );
          await SubCategoryRow.db.deleteRow(
            session,
            oldRow,
            transaction: transaction,
          );
        }
      }

      final oldNamesMap = {for (final r in oldGroupRows) r.name.toLowerCase(): r};
      final now = DateTime.now().toUtc();
      final groupCreatedAt = targetRow.createdAt;

      for (final name in newNames) {
        final slug = _slugify(name);
        final oldRow = oldNamesMap[name.toLowerCase()];
        if (oldRow != null) {
          await SubCategoryRow.db.updateRow(
            session,
            oldRow.copyWith(
              categoryId: newCategory.id!,
              name: name,
              slug: slug,
              imageUrl: newImageUrl,
              updatedAt: now,
            ),
            transaction: transaction,
          );
        } else {
          await SubCategoryRow.db.insertRow(
            session,
            SubCategoryRow(
              categoryId: newCategory.id!,
              name: name,
              slug: slug,
              imageUrl: newImageUrl,
              status: 'active',
              createdAt: groupCreatedAt,
              updatedAt: now,
            ),
            transaction: transaction,
          );
        }
      }
    });

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'update',
      entityType: 'sub_category',
      entityId: targetRow.id.toString(),
      metadata: {
        'old_category': categoryName,
        'new_category': newCategoryName,
        'old_name': oldSubName,
        'new_names': newNames.join(', '),
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
      where: (t) => t.slug.equals(slug),
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
