import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/screens/main_screen.dart';
import 'dart:math' as math;


class ModernSplashScreen extends StatefulWidget {
  const ModernSplashScreen({super.key});

  @override
  State<ModernSplashScreen> createState() => _ModernSplashScreenState();
}

class _ModernSplashScreenState extends State<ModernSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late AnimationController _textController;
  late AnimationController _vehicleController;
  late AnimationController _bounceController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _pulseAnimation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _vehiclePosition;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Logo controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Pulse controller for subtle glow effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    // Text controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Vehicle movement controller
    _vehicleController = AnimationController(
      duration: const Duration(milliseconds: 4500),
      vsync: this,
    );

    // Bounce controller for wheel effect
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    )..repeat(reverse: true);

    // Logo animations
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Subtle pulse animation
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Text animations
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    // Vehicle position animation - moves from left to right
    _vehiclePosition = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _vehicleController, curve: Curves.easeInOut),
    );

    // Bounce animation for realistic movement
    _bounceAnimation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Start animations sequence
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Start vehicle animation after text
    await Future.delayed(const Duration(milliseconds: 500));
    _vehicleController.forward();

    // Navigate after splash
    await Future.delayed(const Duration(milliseconds: 3500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _textController.dispose();
    _vehicleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Simple, clean gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B8A4C), // Rich green
              Color(0xFF0D5C2F), // Deep forest green
            ],
          ),
        ),
        child: Stack(
          children: [
            // City skyline background - positioned above loading area
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: _buildCitySkyline(size),
            ),

            // Main content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Centered logo with subtle pulse
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 40,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            'lib/assets/images/name_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Simple text animation
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [
                          // App name
                          const Text(
                            'FreshPickKart',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Tagline
                          Text(
                            'Fresh Groceries, Delivered Fast',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.85),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Loading text - at the very bottom
                  FadeTransition(
                    opacity: _textOpacity,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Delivering freshness...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCitySkyline(Size size) {
    return SizedBox(
      height: 200,
      width: size.width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background buildings (far)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBuilding(50, 70, const Color(0xFF0A4A25)),
                _buildBuilding(40, 55, const Color(0xFF0B5028)),
                _buildBuilding(55, 85, const Color(0xFF0A4A25)),
                _buildBuilding(45, 60, const Color(0xFF0B5028)),
                _buildBuilding(50, 75, const Color(0xFF0A4A25)),
                _buildBuilding(40, 50, const Color(0xFF0B5028)),
                _buildBuilding(55, 80, const Color(0xFF0A4A25)),
              ],
            ),
          ),

          // Foreground buildings with more detail
          Positioned(
            bottom: 40,
            left: 20,
            child: _buildDetailedBuilding(55, 90, const Color(0xFF063D1E)),
          ),
          Positioned(bottom: 40, left: 90, child: _buildGroceryStore()),
          Positioned(
            bottom: 40,
            left: 180,
            child: _buildDetailedBuilding(50, 75, const Color(0xFF074422)),
          ),
          Positioned(
            bottom: 40,
            right: 100,
            child: _buildDetailedBuilding(45, 85, const Color(0xFF063D1E)),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: _buildDetailedBuilding(55, 70, const Color(0xFF074422)),
          ),

          // Trees
          Positioned(bottom: 35, left: 160, child: _buildTree(35)),
          Positioned(bottom: 35, right: 160, child: _buildTree(30)),

          // Ground
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFF053318), const Color(0xFF042810)],
                ),
              ),
            ),
          ),

          // Animated delivery scooter
          AnimatedBuilder(
            animation: Listenable.merge([
              _vehicleController,
              _bounceController,
            ]),
            builder: (context, child) {
              return Positioned(
                bottom: 20,
                left:
                    size.width * 0.5 +
                    (_vehiclePosition.value * size.width * 0.45) -
                    28,
                child: Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: _buildDeliveryScooter(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBuilding(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Windows
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 4,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  6,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.3 + (index % 3) * 0.2),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedBuilding(double width, double height, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          const SizedBox(height: 6),
          // Windows grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 3,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  8,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: index % 3 == 0
                          ? Colors.yellow.withOpacity(0.6)
                          : Colors.lightBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroceryStore() {
    return Container(
      width: 70,
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC71),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          // Awning
          Container(
            height: 16,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.4),
                  Colors.white.withOpacity(0.2),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: const Center(
              child: Text(
                'FRESH',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Store window
          Container(
            width: 50,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_basket,
                  size: 18,
                  color: Colors.green.shade700,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.apple, size: 10, color: Colors.red.shade400),
                    const SizedBox(width: 4),
                    Icon(Icons.eco, size: 10, color: Colors.green.shade400),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTree(double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Foliage
        Container(
          height: height * 0.6,
          width: height * 0.55,
          decoration: BoxDecoration(
            color: const Color(0xFF1B8A4C),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        // Trunk
        Container(
          height: height * 0.35,
          width: height * 0.18,
          decoration: BoxDecoration(
            color: const Color(0xFF5D4037),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryScooter() {
    return SizedBox(
      width: 85,
      height: 65,
      child: Image.asset(
        'lib/assets/images/delivery_scooter.png',
        width: 85,
        height: 65,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return _buildCustomScooter();
        },
      ),
    );
  }

  Widget _buildCustomScooter() {
    return SizedBox(
      width: 85,
      height: 65,
      child: Stack(
        children: [
          // Delivery box
          Positioned(
            left: 4,
            top: 0,
            child: Container(
              width: 24,
              height: 21,
              decoration: BoxDecoration(
                color: const Color(0xFF2ECC71),
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(
                Icons.shopping_basket,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),

          // Scooter body
          Positioned(
            left: 10,
            top: 16,
            child: Container(
              width: 40,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFFE74C3C),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),

          // Handlebar
          Positioned(
            right: 6,
            top: 9,
            child: Container(
              width: 3,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),

          // Front wheel
          Positioned(right: 4, bottom: 4, child: _buildWheel(14)),

          // Back wheel
          Positioned(left: 8, bottom: 4, child: _buildWheel(14)),

          // Rider helmet
          Positioned(
            right: 10,
            top: 2,
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: Colors.yellow.shade700,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheel(double size) {
    return AnimatedBuilder(
      animation: _vehicleController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _vehicleController.value * 4 * math.pi,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 0, 0, 0),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
