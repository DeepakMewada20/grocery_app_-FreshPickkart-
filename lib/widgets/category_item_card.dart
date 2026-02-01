import 'package:flutter/material.dart';

class CategoryItemCard extends StatelessWidget {
  final String itemName;
  final String imagePath;
  final VoidCallback? onTap;

  const CategoryItemCard({
    super.key,
    required this.itemName,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Container - Fixed Height
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[800],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
            ),
            // Item Name - Fixed Area at Bottom
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    itemName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
