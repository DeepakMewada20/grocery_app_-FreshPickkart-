import 'package:flutter/material.dart';
import 'package:freshpickkat/screens/view_all_products_screen.dart';
import 'package:freshpickkat/widgets/home_banner_with_horizontal_item.dart';
import 'package:freshpickkat/widgets/home_page_header.dart';
import 'package:freshpickkat/widgets/offer_banner.dart';
import 'package:freshpickkat/widgets/offer_widget.dart';
import 'package:freshpickkat/widgets/product_card.dart';
import 'package:freshpickkat/widgets/view_all_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(233, 0, 0, 0),
      body: CustomScrollView(
        slivers: [
          // Header with app name, tagline, and search bar
          const MilkbasketSliverAppBar(),

          // 🎁 OFFER WIDGET
          OfferWidget(),

          // 🎪 BANNER WITH HORIZONTAL ITEMS
          HomeBannerWithHorizontalItem(height: height),

          // 📦 CATEGORIES SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 12,
                right: 12,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trending Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5 + 1, // Products + 1 for ViewAllCard
                itemBuilder: (context, index) {
                  // Show ViewAllCard as last item
                  if (index == 5) {
                    return SizedBox(
                      width: 160,

                      child: ViewAllCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ViewAllProductsScreen(),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  // Show regular ProductCard
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    child: ProductCard(
                      imageUrl: 'https://example.com/product${index + 1}.jpg',
                      title: 'Dabur Honey Squeezy',
                      quantity: '2 x 400 gm',
                      price: '₹235',
                      originalPrice: '₹420',
                      discount: '₹185\nOFF',
                      onAddPressed: () {},
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 12,
                right: 12,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Best Sellers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 5 + 1, // Products + 1 for ViewAllCard
                itemBuilder: (context, index) {
                  // Show ViewAllCard as last item
                  if (index == 5) {
                    return SizedBox(
                      width: 160,
                      // margin: const EdgeInsets.only(right: 1),
                      child: ViewAllCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ViewAllProductsScreen(),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  // Show regular ProductCard
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    child: ProductCard(
                      imageUrl: 'https://example.com/product${index + 1}.jpg',
                      title: 'Dabur Honey Squeezy',
                      quantity: '2 x 400 gm',
                      price: '₹235',
                      originalPrice: '₹420',
                      discount: '₹185\nOFF',
                      onAddPressed: () {},
                    ),
                  );
                },
              ),
            ),
          ),

          // In your CustomScrollView slivers list:
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: OfferBanner(
                height: 180,
                banners: [
                  OfferBannerItem(
                    imagePath: 'lib/assets/images/discount.jpg',
                    // showGradient: false,
                    onTap: () {
                      print('Banner 1 tapped');
                    },
                  ),
                  OfferBannerItem(
                    imagePath: 'lib/assets/images/discount.jpg',
                    // showGradient: false,
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 12,
                right: 12,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Other Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 12, right: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.457, // Adjust for card height
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ProductCard(
                    imageUrl: 'https://example.com/product${index + 1}.jpg',
                    title: 'Dabur Honey Squeezy',
                    quantity: '2 x 400 gm',
                    price: '₹235',
                    originalPrice: '₹420',
                    discount: '₹185\nOFF',
                    onAddPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added product ${index + 1}')),
                      );
                    },
                  );
                },
                childCount: 5, // Number of products
              ),
            ),
          ),
        ],
      ),
    );
  }
}
