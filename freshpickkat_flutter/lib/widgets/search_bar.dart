import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/utils/app_route_observer.dart';
import 'package:freshpickkat_flutter/widgets/product_search_delegate.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with RouteAware, WidgetsBindingObserver {
  static int _savedHintIndex = 0;
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;
  ModalRoute<dynamic>? _route;
  bool _isRouteVisible = true;
  bool _isAppResumed = true;
  final List<String> hints = [
    'Search for "Vegetable"',
    'Search for "Fruits"',
    'Search for "Dairy"',
    'Search for "Snacks"',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final basePage = 10000 - (10000 % hints.length);
    _currentPage = basePage + _savedHintIndex;
    _pageController = PageController(initialPage: _currentPage);
    _syncAutoScrollState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (_route == route) return;

    if (_route is ModalRoute<void>) {
      appRouteObserver.unsubscribe(this);
    }

    _route = route;
    if (route is ModalRoute<void>) {
      appRouteObserver.subscribe(this, route);
    }
  }

  void _advancePage() {
    _currentPage++;
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _startAutoScroll() {
    if (!_shouldAutoScroll) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted || !_pageController.hasClients) return;
      _advancePage();
    });
  }

  bool get _shouldAutoScroll => _isRouteVisible && _isAppResumed;

  void _syncAutoScrollState() {
    if (_shouldAutoScroll) {
      _startAutoScroll();
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void didPush() {
    _isRouteVisible = true;
    _syncAutoScrollState();
  }

  @override
  void didPopNext() {
    _isRouteVisible = true;
    _syncAutoScrollState();
  }

  @override
  void didPushNext() {
    _isRouteVisible = false;
    _syncAutoScrollState();
  }

  @override
  void didPop() {
    _isRouteVisible = false;
    _syncAutoScrollState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppResumed = state == AppLifecycleState.resumed;
    _syncAutoScrollState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_route is ModalRoute<void>) {
      appRouteObserver.unsubscribe(this);
    }
    _savedHintIndex = _currentPage % hints.length;
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          color: isDark ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: isDark ? Colors.white : Colors.black54,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRect(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final hintIndex = index % hints.length;

                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        hints[hintIndex],
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
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
