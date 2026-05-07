import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryHeaderWidget extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onViewMorePressed;

  const CategoryHeaderWidget({
    super.key,
    required this.categoryName,
    this.onViewMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoSizeText(
              categoryName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              minFontSize: 12,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: onViewMorePressed,
            child: AutoSizeText(
              'View More',
              style: TextStyle(
                color: Color(0xFF2ECC71),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              minFontSize: 10,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
