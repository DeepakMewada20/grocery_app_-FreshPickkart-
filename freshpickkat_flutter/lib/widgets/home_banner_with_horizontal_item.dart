import 'package:flutter/material.dart';

class HomeBannerWithHorizontalItem extends StatefulWidget {
  final double height;
  const HomeBannerWithHorizontalItem({required this.height, super.key});

  @override
  State<HomeBannerWithHorizontalItem> createState() =>
      _HomeBannerWithHorizontalItemState();
}

class _HomeBannerWithHorizontalItemState
    extends State<HomeBannerWithHorizontalItem> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        height: widget.height * 0.37,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            /// 🖼️ BACKGROUND IMAGE
            Container(
              height: widget.height * 0.37,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/grocry_home_banner.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      
            /// 🧱 HORIZONTAL ITEMS (OVERLAP)
            Positioned(
              bottom: 7,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 110,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage("lib/assets/images/milk.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
