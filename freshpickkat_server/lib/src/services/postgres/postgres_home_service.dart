import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../analytics/product_ranking_service.dart';
import '../delivery/delivery_engine.dart';
import 'postgres_banner_service.dart';
import 'postgres_catalog_service.dart';
import 'postgres_category_service.dart';
import 'postgres_offer_service.dart';

class PostgresHomeService {
  final PostgresCatalogService _catalog = PostgresCatalogService();
  final PostgresBannerService _banner = PostgresBannerService();
  final PostgresCategoryService _category = PostgresCategoryService();
  final PostgresOfferService _offer = PostgresOfferService();
  final ProductRankingService _ranking = ProductRankingService();

  Future<HomePageHydratedData> getHomePageHydrated(
    Session session, {
    String? userId,
    int productLimit = 20,
    int rankingLimit = 10,
  }) async {
    // Each query wrapped with catchError so a single failure never crashes the whole response
    final bannerTopImageFuture = _banner
        .getBanners(session, screen: 'home_top_image', activeOnly: true)
        .catchError((_, _) => <Banner>[]);
    final bannerTopFuture = _banner
        .getBanners(session, screen: 'home_top', activeOnly: true)
        .catchError((_, _) => <Banner>[]);
    final bannerMiddleFuture = _banner
        .getBanners(session, screen: 'home_middle', activeOnly: true)
        .catchError((_, _) => <Banner>[]);
    final bogoFuture = _offer
        .getActiveBogoOffers(session)
        .catchError((_, _) => <BogoOffer>[]);
    final comboFuture = _offer
        .getActiveComboOffers(session)
        .catchError((_, _) => <ComboOffer>[]);
    final categoryFuture = _category
        .getCategories(session)
        .catchError((_, _) => <Category>[]);
    final subCategoryFuture = _category
        .getSubCategories(session)
        .catchError((_, _) => <SubCategory>[]);
    final deliveryFuture = _getDeliveryOffer(session, userId)
        .catchError((_, _) => null);
    final catalogIdsFuture = _catalog
        .getActiveProductIds(session, limit: productLimit)
        .catchError((_, _) => <String>[]);
    final trendingFuture = _ranking
        .getRankedProductIds(
          session,
          limit: rankingLimit,
          metricType: 'trending',
          metricColumn: 'trendingScore',
        )
        .catchError((_, _) => <RankingRow>[]);
    final sellingFuture = _ranking
        .getRankedProductIds(
          session,
          limit: rankingLimit,
          metricType: 'most_selling',
          metricColumn: 'mostPurchaseCount',
        )
        .catchError((_, _) => <RankingRow>[]);
    final viewedFuture = _ranking
        .getRankedProductIds(
          session,
          limit: rankingLimit,
          metricType: 'most_viewed',
          metricColumn: 'mostSearchCount',
        )
        .catchError((_, _) => <RankingRow>[]);
    final reorderFuture = _ranking
        .getRankedProductIds(
          session,
          limit: rankingLimit,
          metricType: 'frequently_reordered',
          metricColumn: 'reorderCount',
        )
        .catchError((_, _) => <RankingRow>[]);

    final phase1Results = await Future.wait([
      bannerTopImageFuture,
      bannerTopFuture,
      bannerMiddleFuture,
      bogoFuture,
      comboFuture,
      categoryFuture,
      subCategoryFuture,
      deliveryFuture,
      catalogIdsFuture,
      trendingFuture,
      sellingFuture,
      viewedFuture,
      reorderFuture,
    ]);

    final topImageBanners = phase1Results[0] as List<Banner>;
    final topBannersRaw = phase1Results[1] as List<Banner>;
    final middleBanners = phase1Results[2] as List<Banner>;
    final bogoOffers = phase1Results[3] as List<BogoOffer>;
    final comboOffers = phase1Results[4] as List<ComboOffer>;
    final categories = phase1Results[5] as List<Category>;
    final subCategories = phase1Results[6] as List<SubCategory>;
    final deliveryOffer = phase1Results[7] as DeliveryPricingResult?;
    final catalogProductIds = phase1Results[8] as List<String>;
    final trendingRows = phase1Results[9] as List<RankingRow>;
    final sellingRows = phase1Results[10] as List<RankingRow>;
    final viewedRows = phase1Results[11] as List<RankingRow>;
    final reorderRows = phase1Results[12] as List<RankingRow>;

    // Merge + deduplicate all product IDs
    final allIds = <String>{...catalogProductIds};
    for (final row in trendingRows) {
      allIds.add(row.productId);
    }
    for (final row in sellingRows) {
      allIds.add(row.productId);
    }
    for (final row in viewedRows) {
      allIds.add(row.productId);
    }
    for (final row in reorderRows) {
      allIds.add(row.productId);
    }

    // Hydrate all products in a single call
    final hydratedProducts = await _catalog.hydrateProductsByIds(
      session,
      allIds.toList(),
    );
    final flatProducts = _catalog.flattenToVariantProducts(
      hydratedProducts,
      useFeaturedVariant: true,
    );
    final productMap = {
      for (final product in flatProducts)
        if (product.productId != null) product.productId!: product,
    };

    // Build ranking items from rows + hydrated products
    final trendingItems = ProductRankingService.buildRankingItems(
      rows: trendingRows,
      productsById: productMap,
      metricType: 'trending',
    );
    final sellingItems = ProductRankingService.buildRankingItems(
      rows: sellingRows,
      productsById: productMap,
      metricType: 'most_selling',
    );
    final viewedItems = ProductRankingService.buildRankingItems(
      rows: viewedRows,
      productsById: productMap,
      metricType: 'most_viewed',
    );
    final reorderItems = ProductRankingService.buildRankingItems(
      rows: reorderRows,
      productsById: productMap,
      metricType: 'frequently_reordered',
    );

    // Map product IDs to section products
    final products = catalogProductIds
        .map((id) => productMap[id])
        .where((p) => p != null)
        .cast<Product>()
        .toList();

    return HomePageHydratedData(
      topImageBanners: topImageBanners,
      topBanners: topBannersRaw
          .where((b) => !b.screenPlacements.contains('home_top_image'))
          .toList(),
      middleBanners: middleBanners,
      products: products,
      trendingProducts:
          trendingItems.map((r) => r.product).toList(),
      bestSellersProducts:
          sellingItems.map((r) => r.product).toList(),
      mostViewedProducts:
          viewedItems.map((r) => r.product).toList(),
      frequentlyReorderedProducts:
          reorderItems.map((r) => r.product).toList(),
      activeBogoOffers: bogoOffers,
      activeComboOffers: comboOffers,
      categories: categories,
      subCategories: subCategories,
      deliveryOffer: deliveryOffer,
    );
  }

  Future<DeliveryPricingResult?> _getDeliveryOffer(
    Session session,
    String? userId,
  ) async {
    if (userId == null || userId.isEmpty) return null;
    try {
      return await DeliveryEngine.getUserDeliveryOffer(session, userId);
    } catch (_) {
      return null;
    }
  }
}
