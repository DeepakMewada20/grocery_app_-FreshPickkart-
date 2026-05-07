// lib/widgets/offer_banner.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferBanner extends StatefulWidget {
  final List<OfferBannerItem> banners;
  final double height;
  final Duration autoScrollDuration;
  final Duration autoScrollInterval;

  const OfferBanner({
    super.key,
    required this.banners,
    this.height = 200,
    this.autoScrollDuration = const Duration(milliseconds: 800),
    this.autoScrollInterval = const Duration(seconds: 3),
  });

  @override
  State<OfferBanner> createState() => _OfferBannerState();
}

class _OfferBannerState extends State<OfferBanner> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start at a high number to allow infinite scrolling
    _currentPage = 10000;
    _pageController = PageController(
      viewportFraction: 0.92, // Shows parts of adjacent banners
      initialPage: _currentPage,
    );
    _startAutoScroll();
  }

  void _startAutoScroll() {
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
          // Loop through banners infinitely
          final bannerIndex = index % widget.banners.length;

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
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: _buildBannerCard(widget.banners[bannerIndex]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBannerCard(OfferBannerItem banner) {
    return GestureDetector(
      onTap: banner.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.asset(
            banner.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B8A4C), Color(0xFF1B8A4C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.image, size: 60.r, color: Colors.white30),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class OfferBannerItem {
  final String imagePath;
  final VoidCallback? onTap;

  const OfferBannerItem({required this.imagePath, this.onTap});
}
