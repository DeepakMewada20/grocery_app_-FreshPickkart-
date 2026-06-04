import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/analytics/redis_analytics_service.dart';
import '../services/business/product_business_service.dart';
import '../services/business/validation_service.dart';
import '../services/postgres/postgres_admin_guard_service.dart';
import '../services/postgres/postgres_audit_log_service.dart';
import '../services/postgres/postgres_offer_search_service.dart';
import '../services/postgres/postgres_product_compat_service.dart';

class ProductEndpoint extends Endpoint {
  final PostgresProductCompatService _pgProducts =
      PostgresProductCompatService();
  final RedisAnalyticsService _analytics = RedisAnalyticsService.instance;
  final PostgresAdminGuardService _adminGuard = PostgresAdminGuardService();
  final PostgresAuditLogService _audit = PostgresAuditLogService();
  final PostgresOfferSearchService _offerSearch = PostgresOfferSearchService();

  Future<List<Product>> getProductsByIds(
    Session session,
    List<String> productIds,
  ) {
    return _pgProducts.getProductsByIds(session, productIds);
  }

  Future<List<Product>> getProducts(
    Session session, {
    int limit = 10,
    String? lastProductName,
    String? lastProductId,
    String? category,
    List<String>? subcategories,
    String sortBy = 'name',
    bool? freeDelivery,
  }) {
    return _pgProducts.getProducts(
      session,
      limit: limit,
      lastProductName: lastProductName,
      lastProductId: lastProductId,
      category: category,
      subcategories: subcategories,
      sortBy: sortBy,
      freeDelivery: freeDelivery,
    );
  }

  Future<ProductPage> getProductsPage(
    Session session, {
    required String firebaseUid,
    required String idToken,
    int limit = 20,
    String? pageToken,
    String? category,
    List<String>? subcategories,
    String sortBy = 'name',
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgProducts.getProductsPage(
      session,
      limit: limit,
      pageToken: pageToken,
      category: category,
      subcategories: subcategories,
      sortBy: sortBy,
    );
  }

  Future<int> getProductsCount(
    Session session, {
    required String firebaseUid,
    required String idToken,
    String? category,
    List<String>? subcategories,
  }) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgProducts.getProductsCount(
      session,
      category: category,
      subcategories: subcategories,
    );
  }

  Future<String?> uploadProduct(
    Session session,
    Product product,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final normalized = ProductBusinessService.normalizeForSave(product);
    ValidationService.validateProduct(normalized);

    final newId = await _pgProducts.uploadProduct(session, normalized);
    if (newId == null) {
      throw Exception('Failed to create product.');
    }

    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'create',
      entityType: 'product',
      entityId: newId,
      metadata: {'category': normalized.category},
    );
    return newId;
  }

  Future<bool> updateProduct(
    Session session,
    Product product,
    String firebaseUid,
    String idToken,
  ) async {
    if (product.productId == null || product.productId!.trim().isEmpty) {
      throw Exception('productId is required for update');
    }

    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final normalized = ProductBusinessService.normalizeForSave(product);
    ValidationService.validateProduct(normalized);

    await _pgProducts.updateProduct(session, normalized);
    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'update',
      entityType: 'product',
      entityId: product.productId!,
      metadata: {'name': normalized.productName},
    );
    return true;
  }

  Future<String> deleteProduct(
    Session session,
    String productId,
    String firebaseUid,
    String idToken,
  ) async {
    final actor = await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    final message = await _pgProducts.deleteProduct(session, productId);
    await _audit.write(
      session,
      actorUserId: actor.id,
      action: 'delete',
      entityType: 'product',
      entityId: productId,
    );
    return message;
  }

  Future<List<String>> getProductSuggestions(
    Session session,
    String query,
  ) {
    return _pgProducts.getProductSuggestions(session, query);
  }

  Future<ProductPage> searchProducts(
    Session session,
    String query, {
    int limit = 20,
    String? pageToken,
  }) async {
    final result = await _pgProducts.searchProductsPage(
      session,
      query: query,
      limit: limit,
      pageToken: pageToken,
    );
    return result;
  }

  Future<OfferSearchPage> getProductsByOffer(
    Session session, {
    required String offerType,
    String query = '',
    int limit = 20,
    String? pageToken,
  }) {
    return _offerSearch.getProductsByOffer(
      session,
      offerType: offerType,
      query: query,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<OfferSearchPage> getComboProducts(
    Session session, {
    String query = '',
    int limit = 20,
    String? pageToken,
  }) {
    return _offerSearch.getComboProducts(
      session,
      query: query,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<OfferSearchPage> getBogoProducts(
    Session session, {
    String query = '',
    int limit = 20,
    String? pageToken,
  }) {
    return _offerSearch.getBogoProducts(
      session,
      query: query,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<OfferSearchPage> searchProductsWithOfferFilters(
    Session session, {
    required String query,
    required String offerFilter,
    int limit = 20,
    String? pageToken,
  }) {
    return _offerSearch.searchProductsWithOfferFilters(
      session,
      query: query,
      offerFilter: offerFilter,
      limit: limit,
      pageToken: pageToken,
    );
  }

  Future<int> migrateProducts(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgProducts.migrateProducts(session);
  }

  Future<int> initializeProductMetrics(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgProducts.initializeProductMetrics(session);
  }

  Future<bool> incrementProductSearch(Session session, String productId) {
    return _analytics.recordProductView(session, productId);
  }

  Future<bool> incrementProductPurchase(Session session, String productId) {
    return _analytics.recordProductSoldQuantity(session, productId, 1);
  }

  Future<int> seedProductMetricsForTesting(
    Session session,
    String firebaseUid,
    String idToken,
  ) async {
    await _adminGuard.ensureAdminSeller(
      session,
      firebaseUid: firebaseUid,
      idToken: idToken,
    );
    return _pgProducts.seedProductMetricsForTesting(session);
  }
}
