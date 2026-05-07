import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    super.key,
    required this.imageUrl,
    this.height = 150,
    this.width,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = height.h.clamp(96.0, height);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: resolvedHeight,
        width: width ?? double.infinity,
        fit: fit,
        errorBuilder: (_, _, _) => Container(
          height: resolvedHeight,
          alignment: Alignment.center,
          color: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                size: 48.sp.clamp(32.0, 48.0),
                color: Colors.grey[400],
              ),
              SizedBox(height: 8.h),
              Text(
                'Image unavailable',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
