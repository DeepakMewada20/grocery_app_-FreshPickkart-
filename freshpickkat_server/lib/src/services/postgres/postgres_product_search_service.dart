import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'postgres_support.dart';

class PostgresProductSearchService {
  static const int _defaultWorkerLimit = 20;
  static const int _maxWorkerLimit = 50;

  Future<void> enqueueRebuild(
    Session session, {
    required String productId,
    required String reason,
    DateTime? scheduledAt,
  }) async {
    final parsedProductId = parseUuid(
      productId,
      fieldName: 'productId',
    );
    final scheduled = scheduledAt ?? DateTime.now().toUtc();

    await session.db.unsafeExecute(
      '''
      INSERT INTO product_search_rebuild_job (
        "productId",
        reason,
        "jobStatus",
        "attemptCount",
        "scheduledAt",
        "createdAt",
        "updatedAt"
      )
      VALUES (
        @productId,
        @reason,
        'pending',
        0,
        @scheduledAt,
        NOW(),
        NOW()
      )
      ON CONFLICT DO NOTHING
      ''',
      parameters: QueryParameters.named({
        'productId': parsedProductId,
        'reason': reason.trim(),
        'scheduledAt': scheduled,
      }),
    );
  }

  Future<void> rebuildSearchDocument(
    Session session, {
    required UuidValue productId,
    Transaction? transaction,
  }) async {
    final product = await ProductRow.db.findById(
      session,
      productId,
      transaction: transaction,
    );

    if (product == null || product.status != 'active') {
      await ProductSearchDocumentRow.db.deleteWhere(
        session,
        where: (t) => t.productId.equals(productId),
        transaction: transaction,
      );
      return;
    }

    final category = await CategoryRow.db.findById(
      session,
      product.categoryId,
      transaction: transaction,
    );

    if (category == null || category.status != 'active') {
      await ProductSearchDocumentRow.db.deleteWhere(
        session,
        where: (t) => t.productId.equals(productId),
        transaction: transaction,
      );
      return;
    }

    final subCategoryIds =
        (product.subCategoryIds != null && product.subCategoryIds!.isNotEmpty)
        ? product.subCategoryIds!
              .split(',')
              .map((s) => tryParseUuid(s.trim()))
              .whereType<UuidValue>()
              .toSet()
        : <UuidValue>{};
    final subCategories = subCategoryIds.isEmpty
        ? <SubCategoryRow>[]
        : await SubCategoryRow.db.find(
            session,
            where: (t) =>
                t.id.inSet(subCategoryIds) & t.status.equals('active'),
            transaction: transaction,
          );

    final chunks = <String>[
      product.name,
      product.shortDescription ?? '',
      product.description ?? '',
      category.name,
      ...subCategories.map((subCategory) => subCategory.name),
    ];

    final searchText = chunks
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .join(' ');

    if (searchText.isEmpty) {
      await ProductSearchDocumentRow.db.deleteWhere(
        session,
        where: (t) => t.productId.equals(productId),
        transaction: transaction,
      );
      return;
    }

    final existing = await ProductSearchDocumentRow.db.findFirstRow(
      session,
      where: (t) => t.productId.equals(productId),
      transaction: transaction,
    );

    if (existing == null) {
      await ProductSearchDocumentRow.db.insertRow(
        session,
        ProductSearchDocumentRow(
          productId: productId,
          searchText: searchText,
          sourceCreatedAt: product.createdAt,
          sourceUpdatedAt: product.updatedAt,
        ),
        transaction: transaction,
      );
      return;
    }

    await ProductSearchDocumentRow.db.updateRow(
      session,
      existing.copyWith(
        searchText: searchText,
        builtAt: DateTime.now().toUtc(),
        sourceCreatedAt: product.createdAt,
        sourceUpdatedAt: product.updatedAt,
      ),
      transaction: transaction,
    );
  }

  Future<int> processPendingJobs(
    Session session, {
    int limit = _defaultWorkerLimit,
  }) async {
    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultWorkerLimit,
      maxLimit: _maxWorkerLimit,
    );

    final jobQuery = await session.db.unsafeQuery(
      '''
      SELECT id::text AS "jobId"
      FROM product_search_rebuild_job
      WHERE "jobStatus" = 'pending'
      ORDER BY "scheduledAt" ASC, id ASC
      LIMIT @limit
      ''',
      parameters: QueryParameters.named({'limit': pageSize}),
    );

    var processed = 0;
    for (final row in jobQuery) {
      final jobId = row.toColumnMap()['jobId']?.toString();
      if (jobId == null || jobId.isEmpty) continue;

      final didProcess = await _processSingleJob(
        session,
        jobId: parseUuid(jobId, fieldName: 'jobId'),
      );
      if (didProcess) processed++;
    }

    return processed;
  }

  Future<bool> _processSingleJob(
    Session session, {
    required UuidValue jobId,
  }) async {
    return session.db.transaction<bool>((transaction) async {
      final job = await ProductSearchRebuildJobRow.db.findById(
        session,
        jobId,
        transaction: transaction,
        lockMode: LockMode.forUpdate,
        lockBehavior: LockBehavior.skipLocked,
      );

      if (job == null || job.jobStatus != 'pending') {
        return false;
      }

      await ProductSearchRebuildJobRow.db.updateRow(
        session,
        job.copyWith(
          jobStatus: 'running',
          attemptCount: job.attemptCount + 1,
          startedAt: DateTime.now().toUtc(),
          finishedAt: null,
          lastError: null,
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );

      try {
        await rebuildSearchDocument(
          session,
          productId: job.productId,
          transaction: transaction,
        );

        await ProductSearchRebuildJobRow.db.updateById(
          session,
          jobId,
          columnValues: (t) => [
            t.jobStatus('succeeded'),
            t.finishedAt(DateTime.now().toUtc()),
            t.updatedAt(DateTime.now().toUtc()),
          ],
          transaction: transaction,
        );
      } catch (error) {
        await ProductSearchRebuildJobRow.db.updateById(
          session,
          jobId,
          columnValues: (t) => [
            t.jobStatus('failed'),
            t.finishedAt(DateTime.now().toUtc()),
            t.lastError(error.toString()),
            t.updatedAt(DateTime.now().toUtc()),
          ],
          transaction: transaction,
        );
      }

      return true;
    });
  }
}
