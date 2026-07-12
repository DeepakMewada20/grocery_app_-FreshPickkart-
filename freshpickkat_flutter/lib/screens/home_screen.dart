import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/controller/auth_controller.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/services/home_data_service.dart';
import 'package:freshpickkat_flutter/utils/app_logger.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';
import 'package:freshpickkat_flutter/widgets/categories_selection_listview.dart';
import 'package:freshpickkat_flutter/widgets/home_banner_with_horizontal_item.dart';
import 'package:freshpickkat_flutter/widgets/home_page_header.dart';
import 'package:freshpickkat_flutter/widgets/initial_loading_screen.dart';
import 'package:freshpickkat_flutter/widgets/item_selection_girdviwe.dart';
import 'package:freshpickkat_flutter/widgets/network_banner_widget.dart';
import 'package:freshpickkat_flutter/widgets/offer_widget.dart';
import 'package:freshpickkat_flutter/widgets/referral_onboarding_dialog.dart';
import 'package:freshpickkat_flutter/widgets/referral_reminder_card.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class _LazyMiddleBanner extends StatefulWidget {
  const _LazyMiddleBanner();

  @override
  State<_LazyMiddleBanner> createState() => _LazyMiddleBannerState();
}

class _LazyMiddleBannerState extends State<_LazyMiddleBanner> {
  ScrollPosition? _scrollPosition;
  bool _hasTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasTriggered) {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        BannerController.instance.loadHomeMiddleBannersIfEmpty();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final middleBanners = BannerController.instance.homeMiddleBanners;
      if (middleBanners.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: NetworkBannerWidget(
          height: AppResponsive.bannerHeight(
            context,
            ratio: 0.42,
            min: 130,
            max: 190,
          ),
          banners: middleBanners,
          autoScrollInterval: const Duration(seconds: 4),
          autoScrollDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }
}

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
  final offerWidgetKey = GlobalKey<OfferWidgetState>();
  bool _hasRestoredScrollOffset = false;
  bool _showReferralReminder = false;
  final _storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_storeScrollOffset);
    _checkReferralReminder();
    _showPendingReferralOnboarding();

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

  Future<void> _checkReferralReminder() async {
    try {
      final uid = AuthController.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) return;
      final client = ServerpodClient().client;
      final status = await client.referral.getReferralOnboardingStatus(uid);
      if (mounted && status.showReminder) {
        setState(() => _showReferralReminder = true);
      }
    } catch (e) {
      AppLogger.error('HomeScreen', 'Referral reminder: $e');
    }
  }

  Future<void> _showPendingReferralOnboarding() async {
    final pending = _storage.read<bool>('pending_referral_onboarding');
    if (pending != true) return;

    _storage.remove('pending_referral_onboarding');

    try {
      final uid = AuthController.instance.currentUser?.uid;
      if (uid == null || uid.isEmpty) return;
      final client = ServerpodClient().client;
      final status = await client.referral.getReferralOnboardingStatus(uid);
      if (!mounted || !status.isEligible) return;

      await showDialog(
        context: Get.context!,
        builder: (_) => const ReferralOnboardingDialog(),
      );
    } catch (e) {
      AppLogger.error('HomeScreen', 'Pending referral: $e');
    }
  }

  Future<void> _onRefresh() async {
    _savedScrollOffset = 0;
    _hasRestoredScrollOffset = false;
    _showReferralReminder = false;
    await HomeDataService().fetchHomePageData();
    BannerController.instance.ensureHomeBannersLoaded();
    await _checkReferralReminder();
  }

  void _storeScrollOffset() {
    if (_scrollController.hasClients) {
      _savedScrollOffset = _scrollController.offset;
      final pos = _scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 200 &&
          !productController.isLoading.value &&
          productController.isMoreDataAvailable.value &&
          mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) productController.loadMore();
        });
      }
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      productController.loadMore();
                    });
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
                        onRetry: () async {
                          await Future.wait([
                            productController.fetchProducts(),
                            BannerController.instance.ensureHomeBannersLoaded(),
                          ]);
                        },
                      )
                    else ...[
                      // 🎁 OFFER WIDGET
                      OfferWidget(key: offerWidgetKey),

                      if (_showReferralReminder)
                        const SliverToBoxAdapter(
                          child: ReferralReminderCard(),
                        ),

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
                        child: ItemSelectionGirdviwe(
                          titalWord: "Other Products",
                          insertions: [
                            GridInsertion(
                              afterCount: 20,
                              widgets: [
                                CategoriesSelectionListview(
                                  key: const ValueKey('most_viewed'),
                                  titalWord: "Most Viewed",
                                  sortBy: "most_viewed",
                                  lazyLoad: true,
                                ),
                                const _LazyMiddleBanner(),
                              ],
                            ),
                            GridInsertion(
                              afterCount: 30,
                              widgets: [
                                CategoriesSelectionListview(
                                  key: const ValueKey('frequently_reordered'),
                                  titalWord: "Frequently Reordered",
                                  sortBy: "frequently_reordered",
                                  lazyLoad: true,
                                ),
                              ],
                            ),
                          ],
                        ),
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
                            padding: EdgeInsets.all(20.w),
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
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).padding.bottom,
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
