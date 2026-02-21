import 'package:flutter/material.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(color: Color(0xFF0C5A2A)),
        child: const Row(
          children: [
            Icon(Icons.card_giftcard, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You're eligible for a free membership trial!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Enjoy free deliveries from your 1st order",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
