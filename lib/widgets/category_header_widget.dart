import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categoryName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: onViewMorePressed,
            child: const Text(
              'View More',
              style: TextStyle(
                color: Color(0xFF2ECC71),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
