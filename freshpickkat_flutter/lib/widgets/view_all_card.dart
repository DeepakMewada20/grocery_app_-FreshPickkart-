// lib/widgets/view_all_card.dart

import 'package:flutter/material.dart';

class ViewAllCard extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const ViewAllCard({
    super.key,
    required this.onTap,
    this.text = 'VIEW ALL',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF1B8A4C),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              const Icon(
                Icons.arrow_forward,
                color: Color(0xFF1B8A4C),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
