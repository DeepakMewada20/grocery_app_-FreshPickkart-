import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/services/product_service.dart';
import 'package:freshpickkat_flutter/widgets/basket_loading_animation.dart';
import 'package:freshpickkat_flutter/widgets/cetegories_selection_listview.dart';
import 'package:freshpickkat_flutter/widgets/home_banner_with_horizontal_item.dart';
import 'package:freshpickkat_flutter/widgets/home_page_header.dart';
import 'package:freshpickkat_flutter/widgets/item_selection_girdviwe.dart';
import 'package:freshpickkat_flutter/widgets/offer_banner.dart';
import 'package:freshpickkat_flutter/widgets/offer_widget.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Client client;
  late final ProductProvider provider;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // Use 10.0.2.2 for Android emulator to reach host machine's localhost.
    client = Client('http://10.0.2.2:8080/')
      ..connectivityMonitor = FlutterConnectivityMonitor();
    provider = ProductProvider(client);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => loading = true);
    try {
      await provider.loadProducts();
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(233, 0, 0, 0),
      body: CustomScrollView(
        slivers: [
          // Header with app name, tagline, and search bar
          const MilkbasketSliverAppBar(),

          // Loading indicator ya content
          if (loading)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: GroceryLoadingAnimation()),
            )
          else ...[
            // 🎁 OFFER WIDGET
            OfferWidget(),

            // 🎪 BANNER WITH HORIZONTAL ITEMS
            HomeBannerWithHorizontalItem(height: height),

            // 📦 CATEGORIES SECTION
            SliverToBoxAdapter(
              child: CetegoriesSelectionListview(
                titalWord: "Trending Products",
                provider: provider,
              ),
            ),
            SliverToBoxAdapter(
              child: CetegoriesSelectionListview(
                titalWord: "Best Sellers",
                provider: provider,
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
            SliverToBoxAdapter(
              child: ItemSelectionGirdviwe(titalWord: "Other Products"),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }
}
