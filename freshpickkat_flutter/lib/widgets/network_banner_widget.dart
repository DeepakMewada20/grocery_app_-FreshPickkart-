import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/utils/banner_navigation_helper.dart';

class NetworkBannerWidget extends StatefulWidget {
  final List<client.Banner> banners;
  final double height;
  final Duration autoScrollDuration;
  final Duration autoScrollInterval;
  /// Optional override. If null, BannerNavigationHelper.navigate is used.
  final Function(client.Banner)? onBannerTap;

  const NetworkBannerWidget({
    super.key,
    required this.banners,
    this.height = 180,
    this.autoScrollDuration = const Duration(milliseconds: 800),
    this.autoScrollInterval = const Duration(seconds: 3),
    this.onBannerTap,
  });

  @override
  State<NetworkBannerWidget> createState() => _NetworkBannerWidgetState();
}

class _NetworkBannerWidgetState extends State<NetworkBannerWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.banners.isEmpty) return;

    _currentPage = 10000;
    _pageController = PageController(
      viewportFraction: 0.92,
      initialPage: _currentPage,
    );
    _startAutoScroll();
  }

  @override
  void didUpdateWidget(NetworkBannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.banners.isEmpty != oldWidget.banners.isEmpty) {
      _currentPage = 10000;
      _pageController = PageController(
        viewportFraction: 0.92,
        initialPage: _currentPage,
      );
      if (widget.banners.isNotEmpty) _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    if (widget.banners.isEmpty) return;

    _timer?.cancel();
    _timer = Timer.periodic(widget.autoScrollInterval, (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: widget.autoScrollDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (widget.banners.isNotEmpty) _pageController.dispose();
    super.dispose();
  }

  void _handleTap(client.Banner banner) {
    if (widget.onBannerTap != null) {
      widget.onBannerTap!(banner);
    } else {
      BannerNavigationHelper.navigate(banner);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final bannerIndex = index % widget.banners.length;
              final banner = widget.banners[bannerIndex];

              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = (_pageController.page ?? 0) - index;
                    value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * widget.height,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildBannerCard(banner),
                ),
              );
            },
          ),
        ),
        // Dot indicators
        if (widget.banners.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.banners.length, (index) {
              final isActive = (_currentPage % widget.banners.length) == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildBannerCard(client.Banner banner) {
    return GestureDetector(
      onTap: () => _handleTap(banner),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade700, Colors.green.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.white30,
                          ),
                          if (banner.title.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              banner.title,
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
              // Tap ripple hint (subtle overlay)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tap to explore',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
