import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/core/design_system/app_radius.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

/// A utility shimmer box that adapts its colors to the current theme.
/// In light mode: uses light gray shades. In dark mode: uses dark gray shades.
class _ShimmerBox extends StatelessWidget {
  final Animation<double> animation;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const _ShimmerBox({
    required this.animation,
    this.width,
    this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? const Color(0xFF2A2A2A)
        : const Color(0xFFDEE8D9);
    final highlightColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF0F5EE);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: borderRadius,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(animation.value - 1, 0),
                  end: Alignment(animation.value + 1, 0),
                  colors: [baseColor, highlightColor, baseColor],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Container(color: baseColor),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Product Grid Shimmer
// ─────────────────────────────────────────────────────────────────────────────
class ProductGridShimmer extends StatefulWidget {
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final bool adaptiveLayout;

  const ProductGridShimmer({
    super.key,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio = 0.59,
    this.itemCount = 6,
    this.padding,
    this.adaptiveLayout = true,
  });

  @override
  State<ProductGridShimmer> createState() => _ProductGridShimmerState();
}

class _ProductGridShimmerState extends State<ProductGridShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final gridDelegate = widget.adaptiveLayout
            ? AppResponsive.productGridDelegate(
                context,
                availableWidth,
                spacing: widget.crossAxisSpacing,
              )
            : SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                crossAxisSpacing: widget.crossAxisSpacing.w,
                mainAxisSpacing: widget.mainAxisSpacing.h,
                childAspectRatio: widget.childAspectRatio,
              );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding:
              widget.padding ??
              AppSpacing.symmetric(horizontal: 12, vertical: 8),
          gridDelegate: gridDelegate,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) =>
              _ProductCardShimmer(animation: _animation),
        );
      },
    );
  }
}

class _ProductCardShimmer extends StatelessWidget {
  final Animation<double> animation;

  const _ProductCardShimmer({required this.animation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFEFF5EC);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFD5E5CE);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: _ShimmerBox(
              animation: animation,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.extraLarge),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: AppSpacing.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(
                    animation: animation,
                    height: ScreenScale.h(12),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  SizedBox(height: ScreenScale.h(4)),
                  _ShimmerBox(
                    animation: animation,
                    height: ScreenScale.h(8),
                    width: ScreenScale.w(60),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  const Spacer(),
                  _ShimmerBox(
                    animation: animation,
                    height: ScreenScale.h(14),
                    width: ScreenScale.w(50),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  SizedBox(height: ScreenScale.h(8)),
                  _ShimmerBox(
                    animation: animation,
                    height: ScreenScale.h(32),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Horizontal Product List Shimmer
// ─────────────────────────────────────────────────────────────────────────────
class HorizontalProductListShimmer extends StatefulWidget {
  final double height;
  final int itemCount;
  final double itemWidth;

  const HorizontalProductListShimmer({
    super.key,
    this.height = 260,
    this.itemCount = 5,
    this.itemWidth = 160,
  });

  @override
  State<HorizontalProductListShimmer> createState() =>
      _HorizontalProductListShimmerState();
}

class _HorizontalProductListShimmerState
    extends State<HorizontalProductListShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.symmetric(horizontal: 16),
        itemCount: widget.itemCount,
        itemBuilder: (context, index) => _HorizontalProductCardShimmer(
          animation: _animation,
          width: widget.itemWidth,
          height: widget.height,
        ),
      ),
    );
  }
}

class _HorizontalProductCardShimmer extends StatelessWidget {
  final Animation<double> animation;
  final double width;
  final double height;

  const _HorizontalProductCardShimmer({
    required this.animation,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFEFF5EC);
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFD5E5CE);

    return Container(
      width: width,
      height: height,
      margin: AppSpacing.only(right: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.extraLarge),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: _ShimmerBox(
              animation: animation,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.extraLarge),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: AppSpacing.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(
                    animation: animation,
                    height: ScreenScale.h(10),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  SizedBox(height: ScreenScale.h(4)),
                  _ShimmerBox(
                    animation: animation,
                    height: ScreenScale.h(6),
                    width: ScreenScale.w(50),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  const Spacer(),
                  _ShimmerBox(
                    animation: animation,
                    height: ScreenScale.h(12),
                    width: ScreenScale.w(40),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  SizedBox(height: ScreenScale.h(6)),
                  _ShimmerBox(
                    animation: animation,
                    height: ScreenScale.h(28),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Item Grid Shimmer
// ─────────────────────────────────────────────────────────────────────────────
class CategoryItemGridShimmer extends StatefulWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int itemCount;
  final bool adaptiveLayout;

  const CategoryItemGridShimmer({
    super.key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.74,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.itemCount = 6,
    this.adaptiveLayout = true,
  });

  @override
  State<CategoryItemGridShimmer> createState() =>
      _CategoryItemGridShimmerState();
}

class _CategoryItemGridShimmerState extends State<CategoryItemGridShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final delegate = widget.adaptiveLayout
            ? AppResponsive.categoryGridDelegate(
                context,
                availableWidth,
                spacing: widget.crossAxisSpacing,
              )
            : SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                childAspectRatio: widget.childAspectRatio,
                crossAxisSpacing: widget.crossAxisSpacing.w,
                mainAxisSpacing: widget.mainAxisSpacing.h,
              );
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: delegate,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) =>
              _CategoryItemCardShimmer(animation: _animation),
        );
      },
    );
  }
}

class _CategoryItemCardShimmer extends StatelessWidget {
  final Animation<double> animation;

  const _CategoryItemCardShimmer({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: _ShimmerBox(
              animation: animation,
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
          ),
          SizedBox(height: ScreenScale.h(4)),
          _ShimmerBox(
            animation: animation,
            height: ScreenScale.h(10),
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          SizedBox(height: ScreenScale.h(2)),
          _ShimmerBox(
            animation: animation,
            height: ScreenScale.h(8),
            width: ScreenScale.w(40),
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
        ],
      ),
    );
  }
}
