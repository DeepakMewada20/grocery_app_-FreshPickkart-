import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/widgets/discound_badge.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String quantity;
  final String price;
  final String? originalPrice;
  final String? discount;
  final VoidCallback? onAddPressed;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.quantity,
    required this.price,
    this.originalPrice,
    this.discount,
    this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with 1:1 aspect ratio and discount badge
          AspectRatio(
            aspectRatio: 1, // Perfect square 1:1 ratio
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Discount badge
                if (discount != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: DiscountBadge(discount: '32%\nOFF'),
                  ),
              ],
            ),
          ),
          // Product details section
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Quantity
                Text(
                  quantity,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
                const SizedBox(height: 8),
                // Price section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (originalPrice != null) ...[
                      const SizedBox(width: 5),
                      Text(
                        originalPrice!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                // Add button
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: OutlinedButton(
                    onPressed: onAddPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2196F3),
                      side: const BorderSide(
                        color: Color(0xFF2196F3),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      '+ Add',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
