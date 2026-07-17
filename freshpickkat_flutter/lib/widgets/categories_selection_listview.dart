import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/view_all_products_screen.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:freshpickkat_flutter/widgets/view_all_card.dart';
import 'package:get/get.dart';

class CategoriesSelectionListview extends StatefulWidget {
  final String titalWord;
  final String? sortBy;
  final bool lazyLoad;

  const CategoriesSelectionListview({
    super.key,
    required this.titalWord,
    this.sortBy,
    this.lazyLoad = false,
  });

  @override
  State<CategoriesSelectionListview> createState() =>
      _CategoriesSelectionListviewState();
}

class _CategoriesSelectionListviewState
    extends State<CategoriesSelectionListview> {
  ScrollPosition? _scrollPosition;
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    if (!widget.lazyLoad) {
      _triggerFetch();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.lazyLoad && !_hasTriggered) {
      _scrollPosition?.removeListener(_onScroll);
      _scrollPosition = Scrollable.maybeOf(context)?.position;
      _scrollPosition?.addListener(_onScroll);
      WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
    }
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_hasTriggered) return;
    final position = _scrollPosition;
    if (position == null) return;

    final renderObject = context.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;

    final viewport = RenderAbstractViewport.maybeOf(renderObject);
    if (viewport == null) return;

    final reveal = viewport.getOffsetToReveal(renderObject, 0.0);
    const lookahead = 500.0;

    if (reveal.offset <=
        position.pixels + position.viewportDimension + lookahead) {
      _hasTriggered = true;
      _scrollPosition?.removeListener(_onScroll);
      _triggerFetch();
    }
  }

  void _triggerFetch() {
    final productController = ProductProviderController.instance;
    if (widget.sortBy == 'trending') {
      productController.fetchTrendingIfEmpty();
    } else if (widget.sortBy == 'best_sellers') {
      productController.fetchBestSellersIfEmpty();
    } else if (widget.sortBy == 'most_viewed') {
      productController.fetchMostViewedIfEmpty();
    } else if (widget.sortBy == 'frequently_reordered') {
      productController.fetchFrequentlyReorderedIfEmpty();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productController = ProductProviderController.instance;

    return Obx(() {
      List<Product> products;
      bool isLoading;

      if (widget.sortBy == 'trending') {
        products = productController.trendingProducts;
        isLoading = productController.isLoading.value && products.isEmpty;
      } else if (widget.sortBy == 'best_sellers') {
        products = productController.bestSellersProducts;
        isLoading = productController.isLoading.value && products.isEmpty;
      } else if (widget.sortBy == 'most_viewed') {
        products = productController.mostViewedProducts;
        isLoading = productController.isLoading.value && products.isEmpty;
      } else if (widget.sortBy == 'frequently_reordered') {
        products = productController.frequentlyReorderedProducts;
        isLoading = productController.isLoading.value && products.isEmpty;
      } else {
        products = productController.allProducts;
        isLoading = productController.isLoading.value && products.isEmpty;
      }

      if (isLoading) {
        return Padding(
          padding: AppSpacing.symmetric(vertical: 28),
          child: SizedBox(
            height: AppResponsive.horizontalProductListHeight(context),
            child: HorizontalProductListShimmer(
              height: AppResponsive.horizontalProductListHeight(context),
              itemCount: 5,
              itemWidth: AppResponsive.horizontalCardWidth(context),
            ),
          ),
        );
      }

      if (products.isEmpty) return const SizedBox.shrink();

      final itemCount = (products.length > 8 ? 8 : products.length) + 1;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.only(top: 16, left: 12, right: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.titalWord,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sectionTitle(context),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: '/ViewAllProductsScreen'),
                        builder: (_) => ViewAllProductsScreen(
                          sortBy: widget.sortBy,
                          title: widget.titalWord,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Color(0xFF1B8A4C)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: AppResponsive.horizontalProductListHeight(context),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: AppSpacing.symmetric(horizontal: 16),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // Show ViewAllCard as last item
                if (index == itemCount - 1) {
                  return SizedBox(
                    width: AppResponsive.horizontalCardWidth(context),
                    child: ViewAllCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(name: '/ViewAllProductsScreen'),
                            builder: (_) => ViewAllProductsScreen(
                              sortBy: widget.sortBy,
                              title: widget.titalWord,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                final p = products[index];
                final uniqueKey = '${p.productId}_trending_$index';
                final cardWidth = AppResponsive.horizontalCardWidth(context);
                final cardHeight = AppResponsive.horizontalProductListHeight(
                  context,
                );
                final productCard = ProductCard(
                  product: p,
                  enableHero: false,
                  heroTagSuffix: '_trending',
                  onAddPressed: () {},
                );
                return Container(
                  width: cardWidth,
                  margin: AppSpacing.only(right: 12),
                  child: KeyedSubtree(
                    key: ValueKey(uniqueKey),
                    child: kIsWeb
                        ? SizedBox(
                            width: cardWidth,
                            height: cardHeight,
                            child: productCard,
                          )
                        : productCard,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
