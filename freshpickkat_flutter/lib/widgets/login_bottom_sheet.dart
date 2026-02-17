import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginBottomSheet extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const LoginBottomSheet({
    super.key,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, color: Colors.white),
            ),
          ),
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/3081/3081986.png', // Placeholder shopping cart icon
            height: 120,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Hey Stranger!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Please Login/Signup before adding items to the cart.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onLoginPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Login/Signup',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
