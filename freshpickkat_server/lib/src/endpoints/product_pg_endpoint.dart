import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_catalog_service.dart';
import '../services/postgres/postgres_product_search_service.dart';

class ProductPgEndpoint extends Endpoint {
  final PostgresCatalogService _catalogService = PostgresCatalogService();
  final PostgresProductSearchService _searchService =
      PostgresProductSearchService();

  Future<ProductPage> getActiveProductsPage(
    Session session, {
    int limit = 20,
    String? pageToken,
    String? categoryId,
    String? subCategoryId,
  }) {
    return _catalogService.getActiveProductsPage(
      session,
      limit: limit,
      pageToken: pageToken,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
    );
  }

  Future<ProductPage> searchActiveProducts(
    Session session, {
    required String query,
    int limit = 20,
    String? pageToken,
    String? categoryId,
    String? subCategoryId,
    double similarityThreshold = 0.2,
  }) {
    return _catalogService.searchActiveProducts(
      session,
      query: query,
      limit: limit,
      pageToken: pageToken,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      similarityThreshold: similarityThreshold,
    );
  }

  Future<void> enqueueSearchRebuild(
    Session session, {
    required String productId,
    required String reason,
  }) {
    return _searchService.enqueueRebuild(
      session,
      productId: productId,
      reason: reason,
    );
  }

  Future<int> processPendingSearchRebuildJobs(
    Session session, {
    int limit = 20,
  }) {
    return _searchService.processPendingJobs(
      session,
      limit: limit,
    );
  }
}
