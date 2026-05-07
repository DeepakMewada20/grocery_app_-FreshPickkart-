import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            padding: EdgeInsets.fromLTRB(10.w, 6.h, 10.w, 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEB3B),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AutoSizeText(
              discount,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              minFontSize: 8,
              maxLines: 2,
            ),
          ),
        ),
        // Optional label badge below
        if (label != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Color(0xFFFFEB3B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4.r),
                bottomRight: Radius.circular(4.r),
              ),
            ),
            child: AutoSizeText(
              label!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
              minFontSize: 7,
              maxLines: 1,
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
