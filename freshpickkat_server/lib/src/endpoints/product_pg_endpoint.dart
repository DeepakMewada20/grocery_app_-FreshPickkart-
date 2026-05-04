import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_catalog_service.dart';
import '../services/postgres/postgres_product_search_service.dart';

class ProductPgEndpoint extends Endpoint {
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
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
    double similarityThreshold = 0.05,
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
    required String firebaseUid,
    required String idToken,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _searchService.enqueueRebuild(
      session,
      productId: productId,
      reason: reason,
    );
  }

  Future<int> processPendingSearchRebuildJobs(
    Session session, {
    required String firebaseUid,
    required String idToken,
    int limit = 20,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _searchService.processPendingJobs(
      session,
      limit: limit,
    );
  }
}
