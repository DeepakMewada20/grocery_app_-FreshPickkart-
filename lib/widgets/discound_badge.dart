import 'package:flutter/material.dart';

class DiscountBadge extends StatelessWidget {
  final String discount;
  final String? label;

  const DiscountBadge({super.key, required this.discount, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Discount percentage badge with zigzag
        ClipPath(
          clipper: ZigzagClipper(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEB3B),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              discount,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        // Optional label badge below
        if (label != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFFFFEB3B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              label!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}

// Zigzag clipper for the bottom edge
class ZigzagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Top left corner
    path.lineTo(0, 0);

    // Top right corner
    path.lineTo(size.width, 0);

    // Right edge
    path.lineTo(size.width, size.height - 6);

    // Bottom zigzag pattern
    double zigzagWidth = 6;
    double zigzagHeight = 6;
    int zigzagCount = (size.width / zigzagWidth).floor();

    for (int i = zigzagCount; i >= 0; i--) {
      double x = i * zigzagWidth;
      if (i % 2 == 0) {
        path.lineTo(x, size.height);
      } else {
        path.lineTo(x, size.height - zigzagHeight);
      }
    }

    // Left edge
    path.lineTo(0, size.height - 6);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
