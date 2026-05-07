import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/utils/app_route_observer.dart';
import 'package:freshpickkat_flutter/widgets/product_search_delegate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with RouteAware, WidgetsBindingObserver {
  static int _savedHintIndex = 0;
  int _currentHintIndex = 0;
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
    _currentHintIndex = _savedHintIndex % hints.length;
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
    if (!mounted) return;
    setState(() {
      _currentHintIndex = (_currentHintIndex + 1) % hints.length;
    });
  }

  void _startAutoScroll() {
    if (!_shouldAutoScroll) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted) return;
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
    _savedHintIndex = _currentHintIndex % hints.length;
    _timer?.cancel();
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
        height: 45.h.clamp(40.0, 50.0),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: isDark ? Colors.white : Colors.black54,
              size: 22.r,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    final isIncoming =
                        child.key == ValueKey<int>(_currentHintIndex);
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: isIncoming
                                ? const Offset(0, 1.2)
                                : const Offset(0, -1.2),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic,
                            ),
                          ),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Align(
                    key: ValueKey<int>(_currentHintIndex),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      hints[_currentHintIndex],
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 15.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
