import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/categories_selection_listview.dart';
import 'package:freshpickkat_flutter/widgets/home_banner_with_horizontal_item.dart';
import 'package:freshpickkat_flutter/widgets/home_page_header.dart';
import 'package:freshpickkat_flutter/widgets/initial_loading_screen.dart';
import 'package:freshpickkat_flutter/widgets/item_selection_girdviwe.dart';
import 'package:freshpickkat_flutter/widgets/network_banner_widget.dart';
import 'package:freshpickkat_flutter/widgets/offer_widget.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  static double _savedScrollOffset = 0;
  final ScrollController _scrollController = ScrollController();
  bool _hasRestoredScrollOffset = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_storeScrollOffset);
  }

  void _storeScrollOffset() {
    if (_scrollController.hasClients) {
      _savedScrollOffset = _scrollController.offset;
    }
  }

  void _restoreScrollOffsetIfNeeded() {
    if (_hasRestoredScrollOffset || !_scrollController.hasClients) return;

    final maxExtent = _scrollController.position.maxScrollExtent;
    final targetOffset = _savedScrollOffset.clamp(0.0, maxExtent);
    if (targetOffset > 0) {
      _scrollController.jumpTo(targetOffset);
    }
    _hasRestoredScrollOffset = true;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _storeScrollOffset();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final productController = ProductProviderController.instance;
    final networkController = NetworkController.instance;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final isConnected = networkController.isConnected.value;
        final isLoading = productController.isLoading.value;
        final hasData = productController.hasData;

        final hasError =
            !isConnected || productController.errorMessage.value.isNotEmpty;

        if (hasData && !_hasRestoredScrollOffset) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _restoreScrollOffsetIfNeeded();
          });
        }

        if (hasError || (isLoading && !hasData)) {
          return InitialLoadingScreen(
            hasError: hasError,
            errorMessage: !isConnected
                ? 'No internet connection'
                : productController.errorMessage.value,
            onRetry: () async {
              final connected = await networkController.checkConnection();
              if (connected) {
                productController.fetchProducts();
              }
            },
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200 &&
                !productController.isLoading.value &&
                productController.isMoreDataAvailable.value) {
              productController.loadMore();
            }
            return false;
          },
          child: CustomScrollView(
            key: const PageStorageKey<String>('home-scroll-view'),
            controller: _scrollController,
            slivers: [
              FreshPickKartSliverAppBar(scrollController: _scrollController),

              // 🎁 OFFER WIDGET
              OfferWidget(),

              // 🎪 BANNER WITH HORIZONTAL ITEMS
              HomeBannerWithHorizontalItem(height: height),

              // 📦 CATEGORIES SECTION
              SliverToBoxAdapter(
                child: CategoriesSelectionListview(
                  titalWord: "Trending Products",
                  sortBy: "trending",
                ),
              ),
              SliverToBoxAdapter(
                child: CategoriesSelectionListview(
                  titalWord: "Best Sellers",
                  sortBy: "best_sellers",
                ),
              ),

              // OFFER BANNER (home_top)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Obx(() {
                    final bannerController = BannerController.instance;
                    final banners = bannerController.homeTopBanners;

                    if (banners.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return NetworkBannerWidget(
                      height: 180,
                      banners: banners,
                      autoScrollInterval: const Duration(seconds: 3),
                      autoScrollDuration: const Duration(milliseconds: 500),
                    );
                  }),
                ),
              ),

              // 📦 ALL PRODUCTS GRID (infinite scroll)
              SliverToBoxAdapter(
                child: Obx(() {
                  final bannerController = BannerController.instance;
                  final middleBanners = bannerController.homeMiddleBanners;

                  return ItemSelectionGirdviwe(
                    titalWord: "Other Products",
                    midContent: middleBanners.isEmpty
                        ? null
                        : NetworkBannerWidget(
                            height: 180,
                            banners: middleBanners,
                            autoScrollInterval: const Duration(seconds: 4),
                            autoScrollDuration: const Duration(
                              milliseconds: 500,
                            ),
                          ),
                  );
                }),
              ),

              // Loading indicator at bottom when fetching more
              if (productController.isLoading.value &&
                  productController.hasData)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 400,
                    child: ProductGridShimmer(
                      itemCount: 6,
                      crossAxisCount: 3,
                      childAspectRatio: 0.458,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),

              // "No more products" message
              if (!productController.isMoreDataAvailable.value &&
                  productController.hasData)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Builder(
                        builder: (context) => Text(
                          'All products loaded ✅',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.4),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
