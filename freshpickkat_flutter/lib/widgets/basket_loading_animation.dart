import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

class GroceryLoadingAnimation extends StatefulWidget {
  const GroceryLoadingAnimation({super.key});

  @override
  State<GroceryLoadingAnimation> createState() =>
      _GroceryLoadingAnimationState();
}

class _ShimmerWidget extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerWidget({
    required this.width,
    required this.height,
    this.borderRadius = 4,
  });

  @override
  State<_ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<_ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final baseColor = brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.grey.shade300;
    final highlightColor = brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                _controller.value,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

class SuggestionSkeletonCard extends StatelessWidget {
  const SuggestionSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final suggestionTheme = Theme.of(context).extension<AppSuggestionTheme>();

    return Container(
      width: (MediaQuery.sizeOf(context).width * 0.82)
          .clamp(280.0, 340.0)
          .toDouble(),
      margin: EdgeInsets.symmetric(horizontal: ScreenScale.w(6), vertical: ScreenScale.h(8)),
      padding: EdgeInsets.all(ScreenScale.w(14)),
      decoration: BoxDecoration(
        color: suggestionTheme?.cardBackground ?? cs.surface,
        borderRadius: BorderRadius.circular(ScreenScale.r(16)),
        border: Border.all(
          color: suggestionTheme?.cardBorder ?? cs.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ShimmerWidget(width: ScreenScale.r(36), height: ScreenScale.r(36), borderRadius: ScreenScale.r(18)),
              SizedBox(width: ScreenScale.w(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerWidget(
                      width: double.infinity,
                      height: ScreenScale.h(14),
                      borderRadius: 4,
                    ),
                    SizedBox(height: ScreenScale.h(6)),
                    _ShimmerWidget(
                      width: ScreenScale.w(120),
                      height: ScreenScale.h(14),
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenScale.h(12)),
          _ShimmerWidget(
            width: double.infinity,
            height: ScreenScale.h(6),
            borderRadius: 3,
          ),
          SizedBox(height: ScreenScale.h(6)),
          _ShimmerWidget(
            width: ScreenScale.w(100),
            height: ScreenScale.h(10),
            borderRadius: 4,
          ),
          SizedBox(height: ScreenScale.h(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ShimmerWidget(
                width: ScreenScale.w(80),
                height: ScreenScale.h(36),
                borderRadius: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SuggestionSkeletonSection extends StatelessWidget {
  const SuggestionSkeletonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenScale.h(180).clamp(166.0, 210.0).toDouble(),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: ScreenScale.w(8)),
        itemCount: 3,
        itemBuilder: (context, index) {
          return const SuggestionSkeletonCard();
        },
      ),
    );
  }
}

class _GroceryLoadingAnimationState extends State<GroceryLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _moveAnimation = Tween<double>(begin: -20, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_moveAnimation.value, 0),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: ScreenScale.r(60),
                  color: Colors.green,
                ),
              );
            },
          ),

          SizedBox(height: ScreenScale.h(12)),

          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: Icon(
                      Icons.circle,
                      size: ScreenScale.r(8),
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: ScreenScale.w(6)),
                  Opacity(
                    opacity: 1 - _fadeAnimation.value,
                    child: Icon(
                      Icons.circle,
                      size: ScreenScale.r(8),
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: ScreenScale.w(6)),
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: Icon(
                      Icons.circle,
                      size: ScreenScale.r(8),
                      color: Colors.green,
                    ),
                  ),
                ],
              );
            },
          ),

          SizedBox(height: ScreenScale.h(8)),
          Text(
            "Loading products...",
            style: TextStyle(fontSize: ScreenScale.sp(14), color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
