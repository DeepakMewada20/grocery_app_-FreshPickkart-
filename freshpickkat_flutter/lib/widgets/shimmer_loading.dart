import 'package:flutter/material.dart';

class ProductGridShimmer extends StatefulWidget {
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const ProductGridShimmer({
    super.key,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio = 0.59,
    this.itemCount = 6,
    this.padding,
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
    return GridView.builder(
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) =>
          _ProductCardShimmer(animation: _animation),
    );
  }
}

class _ProductCardShimmer extends StatelessWidget {
  final Animation<double> animation;

  const _ProductCardShimmer({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: _ShimmerBox(
                animation: animation,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(
                    animation: animation,
                    height: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  _ShimmerBox(
                    animation: animation,
                    height: 8,
                    width: 60,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const Spacer(),
                  _ShimmerBox(
                    animation: animation,
                    height: 14,
                    width: 50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  _ShimmerBox(
                    animation: animation,
                    height: 32,
                    borderRadius: BorderRadius.circular(8),
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: _ShimmerBox(
                animation: animation,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ShimmerBox(
                    animation: animation,
                    height: 10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  _ShimmerBox(
                    animation: animation,
                    height: 6,
                    width: 50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const Spacer(),
                  _ShimmerBox(
                    animation: animation,
                    height: 12,
                    width: 40,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  _ShimmerBox(
                    animation: animation,
                    height: 28,
                    borderRadius: BorderRadius.circular(6),
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

class CategoryItemGridShimmer extends StatefulWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int itemCount;

  const CategoryItemGridShimmer({
    super.key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.74,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.itemCount = 6,
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) =>
          _CategoryItemCardShimmer(animation: _animation),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF2A2A2A),
              ),
              child: _ShimmerBox(
                animation: animation,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 4),
          _ShimmerBox(
            animation: animation,
            height: 10,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 2),
          _ShimmerBox(
            animation: animation,
            height: 8,
            width: 40,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

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
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: borderRadius,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment(animation.value - 1, 0),
                  end: Alignment(animation.value + 1, 0),
                  colors: const [
                    Color(0xFF2A2A2A),
                    Color(0xFF3A3A3A),
                    Color(0xFF2A2A2A),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Container(color: const Color(0xFF2A2A2A)),
            ),
          ),
        );
      },
    );
  }
}
