import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/widgets/cetegories_selection_listview.dart';
import 'package:freshpickkat_flutter/widgets/home_banner_with_horizontal_item.dart';
import 'package:freshpickkat_flutter/widgets/home_page_header.dart';
import 'package:freshpickkat_flutter/widgets/item_selection_girdviwe.dart';
import 'package:freshpickkat_flutter/widgets/offer_banner.dart';
import 'package:freshpickkat_flutter/widgets/offer_widget.dart';

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
            child: CetegoriesSelectionListview(titalWord: "Trending Products"),
          ),
          SliverToBoxAdapter(
            child: CetegoriesSelectionListview(titalWord: "Best Sellers"),
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
            child: ItemSelectionGirdviwe(titalWord: "Other Products"),
          ),
        ],
      ),
    );
  }
}
