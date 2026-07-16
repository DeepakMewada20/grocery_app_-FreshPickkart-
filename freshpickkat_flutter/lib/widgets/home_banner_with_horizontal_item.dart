import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart'
    deferred as product_detail_screen;
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/product_offer_badge.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeBannerWithHorizontalItem extends StatefulWidget {
  final double height;
  const HomeBannerWithHorizontalItem({required this.height, super.key});

  @override
  State<HomeBannerWithHorizontalItem> createState() =>
      _HomeBannerWithHorizontalItemState();
}

class _HomeBannerWithHorizontalItemState
    extends State<HomeBannerWithHorizontalItem> {
  List<Product> _displayProducts = [];
  bool _isFetchingProducts = false;
  List<String> _lastProductIds = [];

  @override
  void initState() {
    super.initState();

    ever(
      BannerController.instance.homeTopImageBanners,
      (_) => _handleBannerChange(),
    );

    if (BannerController.instance.homeTopImageBanners.isNotEmpty) {
      _handleBannerChange();
    } else {
      BannerController.instance.ensureHomeBannersLoaded();
    }
  }

  void _handleBannerChange() {
    final banner = BannerController.instance.homeTopImageBanners.firstOrNull;

    if (banner == null) {
      return;
    }

    // No need to manually cache image provider, ImageCache handles it
    // Removed precacheImage logic to prevent rebuilding during first frame

    final productIds = banner.linkedProductIds ?? const <String>[];

    if (productIds.isEmpty) {
      setState(() {
        _displayProducts = [];
        _isFetchingProducts = false;
      });
      return;
    }

    final alreadyFetched =
        productIds.length == _lastProductIds.length &&
        productIds.every((id) => _lastProductIds.contains(id));

    if (!alreadyFetched && !_isFetchingProducts) {
      _lastProductIds = productIds;
      _fetchBannerProducts(productIds);
    } else {
      _updateDisplayProducts(productIds);
    }
  }

  Future<void> _fetchBannerProducts(List<String> productIds) async {
    if (!mounted) return;
    setState(() => _isFetchingProducts = true);

    await ProductProviderController.instance.fetchProductsByIds(productIds);

    if (!mounted) return;
    _updateDisplayProducts(productIds);
    setState(() => _isFetchingProducts = false);
  }

  void _updateDisplayProducts(List<String> productIds) {
    final allProducts = ProductProviderController.instance.allProducts;
    final products = allProducts
        .where((p) => productIds.contains(p.productId) && p.productId != null)
        .toList()
        .cast<Product>();

    final seen = <String>{};
    final uniqueProducts = <Product>[];
    for (final p in products) {
      final id = p.productId;
      if (id != null && seen.add(id)) {
        uniqueProducts.add(p);
      }
    }

    if (mounted) {
      setState(() {
        _displayProducts = uniqueProducts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerController = BannerController.instance;

    return SliverToBoxAdapter(
      child: Obx(() {
        final banner = bannerController.homeTopImageBanners.firstOrNull;
        final width = MediaQuery.sizeOf(context).width;
        final productStripHeight = AppResponsive.isLandscape(context)
            ? 80.h
            : 100.h;
        final bannerHeight = AppResponsive.isWideWeb(context)
            ? width / 1.2
            : (width / 1.2)
                  .clamp(
                    productStripHeight + 34.h,
                    AppResponsive.isLandscape(context) ? 280.h : 450.h,
                  )
                  .toDouble();

        return SizedBox(
          height: bannerHeight,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: banner != null
                    ? Image(
                        image: bannerController.getImageProvider(
                          banner.imageUrl,
                        ),
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildFallbackBanner(),
                      )
                    : _buildFallbackBanner(),
              ),

              Positioned(
                bottom: 7.h,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: productStripHeight,
                  child: banner == null
                      ? _buildFallbackProducts()
                      : _buildProductSection(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFallbackBanner() {
    return Image.asset(
      'lib/assets/images/grocry_home_banner.png',
      fit: BoxFit.cover,
    );
  }

  Widget _buildFallbackProducts() {
    final productController = ProductProviderController.instance;
    return Obx(() {
      final products = productController.allProducts.take(5).toList();
      return _ProductList(products: products);
    });
  }

  Widget _buildProductSection() {
    if (_isFetchingProducts && _displayProducts.isEmpty) {
      return _ShimmerProductList();
    }

    if (_displayProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return _ProductList(products: _displayProducts);
  }
}

double _topBannerProductTileSize(BuildContext context) {
  return AppResponsive.isLandscape(context) ? 80.h : 100.h;
}

class _ProductList extends StatelessWidget {
  final List<Product> products;
  const _ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductBannerCard(product: products[index]);
      },
    );
  }
}

class _ShimmerProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: _topBannerProductTileSize(context),
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.grey[300],
          ),
          child: const _ShimmerBox(),
        );
      },
    );
  }
}

class _ProductBannerCard extends StatelessWidget {
  final Product product;

  const _ProductBannerCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await navigateDeferred(
          loadLibrary: product_detail_screen.loadLibrary,
          pageBuilder: () =>
              product_detail_screen.ProductDetailScreen(product: product),
        );
      },
      child: Container(
        width: _topBannerProductTileSize(context),
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF2A2A2A),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white54,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
              if (product.discount > 0)
                Positioned(
                  top: 6,
                  left: 6,
                  child: ProductOfferBadge(
                    product: product,
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 3.h,
                    ),
                    fontSize: 9,
                    borderRadius: 6.r,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatefulWidget {
  const _ShimmerBox();

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: const [
                Color(0xFF2A2A2A),
                Color(0xFF3A3A3A),
                Color(0xFF2A2A2A),
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Container(color: const Color(0xFF2A2A2A)),
        );
      },
    );
  }
}
