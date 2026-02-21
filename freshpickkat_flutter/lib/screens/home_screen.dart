import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/categories_selection_listview.dart';
import 'package:freshpickkat_flutter/widgets/home_banner_with_horizontal_item.dart';
import 'package:freshpickkat_flutter/widgets/home_page_header.dart';
import 'package:freshpickkat_flutter/widgets/initial_loading_screen.dart';
import 'package:freshpickkat_flutter/widgets/item_selection_girdviwe.dart';
import 'package:freshpickkat_flutter/widgets/offer_banner.dart';
import 'package:freshpickkat_flutter/widgets/offer_widget.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = ProductProviderController.instance;
    final networkController = NetworkController.instance;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Obx(() {
        final isConnected = networkController.isConnected.value;
        final isLoading = productController.isLoading.value;
        final hasData = productController.hasData;

        if (!isConnected || (isLoading && !hasData)) {
          return InitialLoadingScreen(
            hasError: !isConnected,
            errorMessage: !isConnected ? 'No internet connection' : '',
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
            // Jab user bottom ke near aaye (200px pehle) toh next page load kare
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 200 &&
                !productController.isLoading.value &&
                productController.isMoreDataAvailable.value) {
              productController.loadMore();
            }
            return false;
          },
          child: CustomScrollView(
            slivers: [
              // Header with app name, tagline, and search bar
              const MilkbasketSliverAppBar(),

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

              // OFFER BANNER
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: OfferBanner(
                    height: 180,
                    banners: [
                      OfferBannerItem(
                        imagePath: 'lib/assets/images/discount.jpg',
                        onTap: () {
                          print('Banner 1 tapped');
                        },
                      ),
                      OfferBannerItem(
                        imagePath: 'lib/assets/images/discount.jpg',
                        onTap: () {
                          print('Banner 2 tapped');
                        },
                      ),
                      OfferBannerItem(
                        imagePath: 'lib/assets/images/discount.jpg',
                        onTap: () {
                          print('Banner 3 tapped');
                        },
                      ),
                    ],
                    autoScrollInterval: const Duration(seconds: 3),
                    autoScrollDuration: const Duration(milliseconds: 500),
                  ),
                ),
              ),

              // 📦 ALL PRODUCTS GRID (infinite scroll)
              SliverToBoxAdapter(
                child: ItemSelectionGirdviwe(titalWord: "Other Products"),
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
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'All products loaded ✅',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
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
