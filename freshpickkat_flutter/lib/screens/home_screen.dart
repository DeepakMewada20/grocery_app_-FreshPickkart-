import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
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
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final networkController = NetworkController.instance;
  final productController = ProductProviderController.instance;
  final bannerController = BannerController.instance;
  final bogoController = BogoController.instance;
  final offerWidgetKey = GlobalKey<OfferWidgetState>();
  bool _hasRestoredScrollOffset = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_storeScrollOffset);

    bannerController.loadHomeTopImageBannersIfEmpty();

    ever(networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute == '/home' || currentRoute == '/') {
          productController.fetchProductsIfEmpty();
        }
      }
    });
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      productController.forceFetchProducts(),
      bannerController.forceLoadAllBanners(),
      bogoController.forceFetchActiveOffers(),
      offerWidgetKey.currentState?.fetchOffer() ?? Future.value(),
    ]);
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
    final height = MediaQuery.sizeOf(context).height;
    final headerSpacer = AppResponsive.isLandscape(context) ? 126.h : 170.h;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _onRefresh,
            edgeOffset: headerSpacer,
            displacement: 40.h,
            child: Obx(() {
              final hasData = productController.hasData;

              if (hasData && !_hasRestoredScrollOffset) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  _restoreScrollOffsetIfNeeded();
                });
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
                    // Space for fixed header
                    SliverToBoxAdapter(
                      child: SizedBox(height: headerSpacer),
                    ),

                    if (!hasData)
                      InitialLoadingScreen(
                        onRetry: () {
                          productController.fetchProducts();
                        },
                      )
                    else ...[
                      // 🎁 OFFER WIDGET
                      OfferWidget(key: offerWidgetKey),

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
                      SliverToBoxAdapter(
                        child: CategoriesSelectionListview(
                          titalWord: "Most Viewed",
                          sortBy: "most_viewed",
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: CategoriesSelectionListview(
                          titalWord: "Frequently Reordered",
                          sortBy: "frequently_reordered",
                        ),
                      ),

                      // OFFER BANNER (home_top)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: Obx(() {
                            final bannerController = BannerController.instance;
                            final banners = bannerController.homeTopBanners;

                            if (banners.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return NetworkBannerWidget(
                              height: AppResponsive.bannerHeight(
                                context,
                                ratio: 0.42,
                                min: 130,
                                max: 190,
                              ),
                              banners: banners,
                              autoScrollInterval: const Duration(seconds: 3),
                              autoScrollDuration: const Duration(
                                milliseconds: 500,
                              ),
                            );
                          }),
                        ),
                      ),

                      // 📦 ALL PRODUCTS GRID (infinite scroll)
                      SliverToBoxAdapter(
                        child: Obx(() {
                          final bannerController = BannerController.instance;
                          final middleBanners =
                              bannerController.homeMiddleBanners;

                          return ItemSelectionGirdviwe(
                            titalWord: "Other Products",
                            midContent: middleBanners.isEmpty
                                ? null
                                : NetworkBannerWidget(
                                    height: AppResponsive.bannerHeight(
                                      context,
                                      ratio: 0.42,
                                      min: 130,
                                      max: 190,
                                    ),
                                    banners: middleBanners,
                                    autoScrollInterval: const Duration(
                                      seconds: 4,
                                    ),
                                    autoScrollDuration: const Duration(
                                      milliseconds: 500,
                                    ),
                                  ),
                          );
                        }),
                      ),

                      // Loading indicator at bottom when fetching more
                      if (productController.isLoading.value)
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 400.h,
                            child: ProductGridShimmer(
                              itemCount: 6,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                            ),
                          ),
                        ),

                      // "No more products" message
                      if (!productController.isMoreDataAvailable.value)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(20.r),
                            child: Center(
                              child: Builder(
                                builder: (context) => Text(
                                  'All products loaded ✅',
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withValues(
                                          alpha: 0.4,
                                        ),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              );
            }),
          ),

          // 🏛️ FIXED HEADER
          AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              return FreshPickKartHeader(
                expandedHeight: headerSpacer,
                collapsedHeight: AppResponsive.isLandscape(context)
                    ? kToolbarHeight + 42.h
                    : kToolbarHeight + 60.h,
                scrollOffset: _scrollController.hasClients
                    ? _scrollController.positions.first.pixels
                    : 0,
              );
            },
          ),
        ],
      ),
    );
  }
}
