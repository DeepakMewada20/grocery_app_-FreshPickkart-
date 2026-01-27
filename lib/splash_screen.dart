import 'package:flutter/material.dart';
import 'package:freshpickkat/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  
  // Phase 1: Logo Pulse
  late Animation<double> _logoScaleAnimation;

  // Phase 2: Logo Shrink & Move
  late Animation<double> _logoShrinkAnimation;
  late Animation<Offset> _logoMoveAnimation;
  
  // Phase 3: Scooter & Background
  late Animation<Offset> _scooterSlideInAnimation;
  late Animation<double> _backgroundScrollAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // 1. Initial Logo State (Matches Native Splash)
    // Stays still for 0.5s, then maybe pulses slightly
    _logoScaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.2, curve: Curves.linear),
      ),
    );

    // 2. Logo Shrinks and Moves to Scooter Box Position (0.2 - 1.0s)
    _logoShrinkAnimation = Tween<double>(begin: 140.0, end: 40.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOutBack),
      ),
    );

    // We need to move from Center to the Scooter Box position.
    // This is tricky with pure relative offsets without knowing exact pixels,
    // so we'll use a Stack and Alignments or fractional offsets.
    // Let's assume the scooter ends up centered.
    // The box on the scooter (delivery_scooter.png) is roughly at the back top.
    
    // 3. Scooter slides in (0.2s - 1.0s)
    // Starts off-screen left, ends centered
    _scooterSlideInAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );
    
    // Background parallax/scroll effect (Starts after scooter arrives or during)
    _backgroundScrollAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
       CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _mainController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Street - Scrolling
          AnimatedBuilder(
            animation: _mainController,
             builder: (context, child) {
               // Simple parallax or just static for now as per "street background" request
               // Let's make it slide slightly to give "driving" effect
               return Positioned(
                 left: -100 + (_mainController.value * -50), // Subtle move
                 right: -100,
                 bottom: 0,
                 height: 300, 
                 child: Image.asset(
                   'lib/assets/images/street_background.png',
                   fit: BoxFit.cover,
                   alignment: Alignment.bottomCenter,
                 ),
               );
             },
          ),
          
          // Scooter
          Center(
            child: SlideTransition(
              position: _scooterSlideInAnimation,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/delivery_scooter.png',
                    width: 300,
                  ),
                  // Logo fixed on the box
                  // We use a specific position for the logo based on the scooter image
                  Positioned(
                    left: 20, // Adjust based on image
                    top: 15, // Adjust based on image box position
                    child: AnimatedBuilder(
                      animation: _mainController,
                      builder: (context, child) {
                        // Logic:
                        // Before 0.8s: The logo is independent (shrinking/moving).
                        // After 0.8s: The logo is "attached" to the bike.
                        
                        // Actually, simpler approach:
                        // Have TWO logos. 
                        // 1. One that starts big and shrinks/moves to the bike position.
                        // 2. Once it "hits" the bike (0.8s), hide 1 and show 2 (fixed on bike).
                        // BUT, user wants smooth transition.
                        
                        // Let's try sticking it to the bike and animating the bike + logo together?
                        // No, logo starts at screen center, bike starts off screen.
                        
                        // Complex Overlay Approach:
                        return const SizedBox.shrink(); 
                      },
                    ),
                  )
                ],
              ),
            ),
          ),

          // The Flying Logo Re-impl
          AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
               // 0.0 -> 0.2: Wait
               if (_mainController.value < 0.2) {
                 return Center(
                   child: Image.asset(
                      'lib/assets/images/logo123.png',
                      width: 140, // Match start
                   ),
                 );
               } 
               
               // 0.2 -> 0.8: Fly to position
               // We need to lerp from Center Screen to (Screen Center + Offset to box)
               // Scooter Center is Screen Center.
               // Box Position relative to Scooter Center: 
               // Scooter width: 300. Box is roughly at -50 horizontal, -60 vertical? matches image.
               
               if (_mainController.value <= 0.8) {
                 // Calculate progress 0.0 to 1.0 for this phase
                 final double t = (_mainController.value - 0.2) / 0.6;
                 final curveT = Curves.easeInOutBack.transform(t);
                 
                 // Start Size: 140, End Size: 50
                 final currentSize = 140.0 + (50.0 - 140.0) * curveT;
                 
                 // Start Offset: (0,0), End Offset: (-70, -60) (Guessing box position)
                 final currentDx = 0 + (-75.0 * curveT);
                 final currentDy = 0 + (-55.0 * curveT);
                 
                 return Center(
                   child: Transform.translate(
                     offset: Offset(currentDx, currentDy),
                     child: Image.asset(
                        'lib/assets/images/logo123.png',
                        width: currentSize,
                     ),
                   ),
                 );
               }
               
               // > 0.8: Attached to scooter!
               // Now it must move WITH the scooter if the scooter moves.
               // Currently scooter stops at center at 0.8.
               // So we just hold position.
               return Center(
                   child: Transform.translate(
                     offset: const Offset(-75, -55),
                     child: Image.asset(
                        'lib/assets/images/logo123.png',
                        width: 50,
                     ),
                   ),
                 );
            },
          ),
          
          // Tagline
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _mainController.value > 0.8 ? 1.0 : 0.0,
              child: Column(
                children: [
                  const Text(
                    "On the way!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
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
}
