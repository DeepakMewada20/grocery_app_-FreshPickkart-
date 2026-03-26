import 'dart:async';
import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;

class NetworkBannerWidget extends StatefulWidget {
  final List<client.Banner> banners;
  final double height;
  final Duration autoScrollDuration;
  final Duration autoScrollInterval;
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
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
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
    );
  }

  Widget _buildBannerCard(client.Banner banner) {
    return GestureDetector(
      onTap: () => widget.onBannerTap?.call(banner),
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
          child: Image.network(
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
                      const Icon(Icons.image, size: 40, color: Colors.white30),
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
        ),
      ),
    );
  }
}
