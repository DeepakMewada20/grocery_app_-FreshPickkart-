import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';

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
      width: MediaQuery.of(context).size.width * 0.82,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: suggestionTheme?.cardBackground ?? cs.surface,
        borderRadius: BorderRadius.circular(16),
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
              const _ShimmerWidget(width: 36, height: 36, borderRadius: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerWidget(
                      width: double.infinity,
                      height: 14,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: 6),
                    _ShimmerWidget(
                      width: 120,
                      height: 14,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ShimmerWidget(
            width: double.infinity,
            height: 6,
            borderRadius: 3,
          ),
          const SizedBox(height: 6),
          _ShimmerWidget(
            width: 100,
            height: 10,
            borderRadius: 4,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ShimmerWidget(
                width: 80,
                height: 36,
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
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  size: 60,
                  color: Colors.green,
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: const Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Opacity(
                    opacity: 1 - _fadeAnimation.value,
                    child: const Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: const Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.green,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 8),
          const Text(
            "Loading products...",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
