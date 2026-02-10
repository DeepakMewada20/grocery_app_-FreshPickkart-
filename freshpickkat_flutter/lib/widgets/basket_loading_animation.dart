import 'package:flutter/material.dart';

class GroceryLoadingAnimation extends StatefulWidget {
  const GroceryLoadingAnimation({Key? key}) : super(key: key);

  @override
  State<GroceryLoadingAnimation> createState() =>
      _GroceryLoadingAnimationState();
}

class _GroceryLoadingAnimationState extends State<GroceryLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

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
                    child: const Icon(Icons.circle, size: 8, color: Colors.green),
                  ),
                  const SizedBox(width: 6),
                  Opacity(
                    opacity: 1 - _fadeAnimation.value,
                    child: const Icon(Icons.circle, size: 8, color: Colors.green),
                  ),
                  const SizedBox(width: 6),
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: const Icon(Icons.circle, size: 8, color: Colors.green),
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
