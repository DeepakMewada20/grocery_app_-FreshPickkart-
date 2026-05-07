import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: const BoxDecoration(color: Color(0xFF0C5A2A)),
        child: Row(
          children: [
            Icon(Icons.card_giftcard, color: Colors.white, size: 24.r),
            SizedBox(width: 10.w),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You're eligible for a free membership trial!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Enjoy free deliveries from your 1st order",
                          style: TextStyle(color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15.r,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
