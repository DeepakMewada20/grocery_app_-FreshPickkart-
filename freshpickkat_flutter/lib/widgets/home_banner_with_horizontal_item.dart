import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart';
import 'package:freshpickkat_flutter/widgets/product_offer_badge.dart';
import 'package:get/get.dart';

class HomeBannerWithHorizontalItem extends StatelessWidget {
  final double height;
  const HomeBannerWithHorizontalItem({required this.height, super.key});

  @override
  Widget build(BuildContext context) {
    final bannerController = BannerController.instance;
    final productController = ProductProviderController.instance;

    return SliverToBoxAdapter(
      child: Obx(() {
        // 🔍 Get the banner provided by server (already filtered Festive > Base)
        final banner = bannerController.homeTopImageBanners.firstOrNull;

        final bannerHeight = height * 0.4;

        return Container(
          margin: const EdgeInsets.only(top: 16),
          height: bannerHeight,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              /// 🖼️ BACKGROUND IMAGE (DYNAMIC)
              Positioned.fill(
                child: banner != null
                    ? Image.network(
                        banner.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const _ShimmerBox();
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey[200]),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'lib/assets/images/grocry_home_banner.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),

              /// 🧱 HORIZONTAL ITEMS (OVERLAP)
              Positioned(
                bottom: 7,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 130,
                  child: Builder(
                    builder: (context) {
                      if (banner == null) {
                        // Fallback to top 5 products if no dynamic banner
                        final products = productController.allProducts
                            .take(5)
                            .toList();
                        return _ProductList(products: products);
                      }

                      // Fetch linked products for the banner
                      final productIds = banner.linkedProductIds!;
                      productController.fetchProductsByIds(productIds);

                      final products = productController.allProducts
                          .where((p) => productIds.contains(p.productId))
                          .toList();

                      if (products.isEmpty && productController.isLoading.value) {
                        return _ShimmerProductList();
                      }

                      return _ProductList(products: products);
                    },
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

class _ProductList extends StatelessWidget {
  final List<Product> products;
  const _ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: 100,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
      onTap: () {
        Get.to(() => ProductDetailScreen(product: product));
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    fontSize: 9,
                    borderRadius: 6,
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
