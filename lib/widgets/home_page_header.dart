import 'package:flutter/material.dart';

class MilkbasketSliverAppBar extends StatefulWidget {
  const MilkbasketSliverAppBar({Key? key}) : super(key: key);

  @override
  State<MilkbasketSliverAppBar> createState() => _MilkbasketSliverAppBarState();
}

class _MilkbasketSliverAppBarState extends State<MilkbasketSliverAppBar> {
  late PageController _pageController;
  final List<String> hints = [
    'Search for "Vegetable"',
    'Search for "Fruits"',
    'Search for "Dairy"',
    'Search for "Snacks"',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= hints.length) nextPage = 0;

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
          child: _buildSearchBar(context),
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
            const Color(0xFF3498DB),
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

  Widget _buildSearchBar(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        );
      },
      child: Container(
        height: 45, // Fixed height - same in both states
        width: double.infinity, // Full width - same in both states
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRect(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hints.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        hints[index],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

// Placeholder SearchScreen
class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text('Search Screen')),
    );
  }
}
