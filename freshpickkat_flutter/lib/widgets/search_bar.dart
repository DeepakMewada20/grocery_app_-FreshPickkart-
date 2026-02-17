import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/widgets/product_search_delegate.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<String> hints = [
    'Search for "Vegetable"',
    'Search for "Fruits"',
    'Search for "Dairy"',
    'Search for "Snacks"',
  ];

  @override
  void initState() {
    super.initState();
    // Start at a high number for infinite scrolling
    _currentPage = 10000;
    _pageController = PageController(initialPage: _currentPage);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showSearch(
          context: context,
          delegate: ProductSearchDelegate(),
        );
      },
      child: Container(
        height: 45,
        width: double.infinity,
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
                  itemBuilder: (context, index) {
                    // Loop through hints infinitely
                    final hintIndex = index % hints.length;

                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        hints[hintIndex],
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
