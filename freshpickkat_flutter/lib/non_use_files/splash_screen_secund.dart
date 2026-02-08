import 'package:flutter/material.dart';
import 'dart:async';

import 'package:freshpickkat_flutter/screens/main_screen.dart';

class AnimatedSplashScreen extends StatefulWidget {
  // You can choose which vehicle to show: 'truck' or 'scooter'
  final String vehicleType;
  
  const AnimatedSplashScreen({
    super.key,
    this.vehicleType = 'scooter', // default is scooter
  });

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _vehicleController;
  late AnimationController _textController;
  late AnimationController _fadeController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _vehicleSlide;
  late Animation<double> _textSlide;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Vehicle animation controller (smooth delivery motion)
    _vehicleController = AnimationController(
      duration: const Duration(milliseconds: 3500), // Slower for better viewing
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Fade controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo animations
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Vehicle animation - moves LEFT TO RIGHT (correct delivery direction!)
    _vehicleSlide = Tween<Offset>(
      begin: const Offset(-1.5, 0), // Start from left side
      end: const Offset(1.5, 0),    // End at right side
    ).animate(
      CurvedAnimation(
        parent: _vehicleController,
        curve: Curves.easeInOut,
      ),
    );

    // Text animation
    _textSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOut,
      ),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeIn,
      ),
    );

    // Start animation sequence
    _startAnimationSequence();

    // Navigate after splash
    Timer(const Duration(milliseconds: 9000), () {
      // TODO: Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    });
  }

  void _startAnimationSequence() async {
    // Start logo animation
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    // Start vehicle animation after logo is visible
    await Future.delayed(const Duration(milliseconds: 1000));
    _vehicleController.forward();

    // Start text animation while vehicle is moving
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Start fade animation
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _vehicleController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade50,
              Colors.white,
              Colors.green.shade50,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Animated Logo
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Container(
                        width: 220,
                        height: 220,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'lib/assets/images/logo123.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Street scene with vehicle animation
                  Container(
                    height: 200,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Street background with buildings, trees, and stores
                          Positioned.fill(
                            child: _buildStreetScene(),
                          ),
                          
                          // Vehicle animation on top of street
                          Positioned(
                            bottom: 25,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              height: 90,
                              width: size.width,
                              child: ClipRect(
                                child: OverflowBox(
                                  maxWidth: size.width * 2,
                                  child: SlideTransition(
                                    position: _vehicleSlide,
                                    child: _buildVehicle(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Animated text
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _textSlide.value),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                'FreshPickKart',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart,
                                    color: Colors.green.shade600,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Fresh Groceries, Fast Delivery',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 2),

                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green.shade600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Loading fresh products...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
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

  Widget _buildVehicle() {
    final String imagePath = widget.vehicleType == 'truck'
        ? 'lib/assets/images/delivery_truck.png'
        : 'lib/assets/images/delivery_scooter.png';

    final IconData fallbackIcon = widget.vehicleType == 'truck'
        ? Icons.local_shipping
        : Icons.electric_scooter;

    return Image.asset(
      imagePath,
      width: 100,
      height: 100,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          fallbackIcon,
          size: 90,
          color: Colors.green.shade600,
        );
      },
    );
  }

  Widget _buildStreetScene() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE3F2FD), // Light blue sky
            Color(0xFFBBDEFB),
            Colors.grey.shade300,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Sky with clouds
          Positioned(
            top: 15,
            left: 40,
            child: _buildCloud(35),
          ),
          Positioned(
            top: 25,
            right: 60,
            child: _buildCloud(30),
          ),
          Positioned(
            top: 10,
            left: 150,
            child: _buildCloud(28),
          ),
          
          // Buildings in background - more colorful
          Positioned(
            bottom: 95,
            left: 15,
            child: _buildBuilding(65, 52, Color(0xFFFFB74D)), // Orange
          ),
          Positioned(
            bottom: 95,
            left: 75,
            child: _buildBuilding(75, 48, Color(0xFF64B5F6)), // Blue
          ),
          
          // Grocery Store - centered and prominent
          Positioned(
            bottom: 95,
            left: 130,
            child: _buildStore(),
          ),
          
          // More buildings
          Positioned(
            bottom: 95,
            right: 90,
            child: _buildBuilding(70, 50, Color(0xFFBA68C8)), // Purple
          ),
          Positioned(
            bottom: 95,
            right: 15,
            child: _buildBuilding(60, 55, Color(0xFFEF5350)), // Red
          ),
          
          // Trees
          Positioned(
            bottom: 90,
            left: 200,
            child: _buildTree(45),
          ),
          Positioned(
            bottom: 90,
            right: 150,
            child: _buildTree(42),
          ),
          
          // Road/Ground with better styling
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 95,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade400,
                    Colors.grey.shade600,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Road markings (dashed lines)
                  Positioned(
                    top: 35,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        10,
                        (index) => Container(
                          width: 25,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuilding(double height, double width, Color color) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        border: Border.all(color: Colors.grey.shade600, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 6),
          // Windows
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              padding: EdgeInsets.all(6),
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(
                4,
                (index) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.lightBlue.shade100,
                        Colors.lightBlue.shade200,
                      ],
                    ),
                    border: Border.all(color: Colors.grey.shade700, width: 1.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStore() {
    return Container(
      height: 80,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.green.shade400,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        border: Border.all(color: Colors.green.shade800, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Awning
          Container(
            height: 18,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade500, Colors.red.shade700],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'STORE',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 6),
          // Store window/display
          Container(
            width: 55,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade700, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_basket,
                  size: 22,
                  color: Colors.green.shade700,
                ),
                SizedBox(height: 2),
                Icon(
                  Icons.apple,
                  size: 14,
                  color: Colors.red.shade600,
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
        // Tree top (foliage) - layered for depth
        Stack(
          alignment: Alignment.center,
          children: [
            // Back layer
            Container(
              height: height * 0.75,
              width: height * 0.75,
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                shape: BoxShape.circle,
              ),
            ),
            // Front layer
            Container(
              height: height * 0.6,
              width: height * 0.6,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.green.shade500,
                    Colors.green.shade700,
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        // Tree trunk
        Container(
          height: height * 0.35,
          width: height * 0.22,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.brown.shade600,
                Colors.brown.shade800,
              ],
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCloud(double size) {
    return Opacity(
      opacity: 0.8,
      child: SizedBox(
        height: size,
        width: size * 1.8,
        child: Stack(
          children: [
            // Left puff
            Positioned(
              left: 0,
              top: size * 0.35,
              child: Container(
                height: size * 0.5,
                width: size * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
            // Center puff (largest)
            Positioned(
              left: size * 0.35,
              top: 0,
              child: Container(
                height: size * 0.75,
                width: size * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
            // Center-right puff
            Positioned(
              left: size * 0.85,
              top: size * 0.2,
              child: Container(
                height: size * 0.6,
                width: size * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
            // Right puff
            Positioned(
              right: 0,
              top: size * 0.35,
              child: Container(
                height: size * 0.5,
                width: size * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}