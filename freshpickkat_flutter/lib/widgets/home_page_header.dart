import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/widgets/search_bar.dart';

class FreshPickKartSliverAppBar extends StatefulWidget {
  const FreshPickKartSliverAppBar({super.key});

  @override
  State<FreshPickKartSliverAppBar> createState() =>
      _FreshPickKartSliverAppBarState();
}

class _FreshPickKartSliverAppBarState extends State<FreshPickKartSliverAppBar> {
  double _collapseProgress({
    required double currentHeight,
    required double expandedHeight,
  }) {
    final double collapsedHeight = kToolbarHeight;
    final double totalRange = expandedHeight - collapsedHeight;
    final double collapsedAmount = expandedHeight - currentHeight;

    return (collapsedAmount / totalRange).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 130,
      // backgroundColor: Colors.transparent,
      // surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,

      // 🔹 FIXED SEARCH BAR (never shrinks)
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(5),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 2, 10, 12),
          child: SearchBarWidget(),
        ),
      ),

      // 🔹 EXPAND / COLLAPSE CONTENT
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final progress = _collapseProgress(
            currentHeight: constraints.biggest.height,
            expandedHeight: 130,
          );
          final backgroundColor = Color.lerp(
            Color(0xFF1B8A4C),
            const Color.fromARGB(233, 0, 0, 0),
            progress,
          )!;
          return Container(
            color: backgroundColor,
            child: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Align(
                    alignment: AlignmentGeometry.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/assets/images/name_logo.png",
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Order by Midnight',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Delivery by 7 AM',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
