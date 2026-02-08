import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/modal/home_category_modal.dart';
import 'package:freshpickkat_flutter/widgets/category_header_widget.dart';
import 'package:freshpickkat_flutter/widgets/category_item_card.dart';

class CategoryGridSection extends StatelessWidget {
  final HomeCategoryModal category;
  final VoidCallback? onViewMorePressed;

  const CategoryGridSection({
    super.key,
    required this.category,
    this.onViewMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Header
        CategoryHeaderWidget(
          categoryName: category.homePageCategoryName,
          onViewMorePressed: onViewMorePressed,
        ),
        // Grid View
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: category.homePageCategoryItem.length,
            itemBuilder: (context, index) {
              final item = category.homePageCategoryItem[index];
              return CategoryItemCard(
                itemName: item['name'] ?? 'Item',
                imagePath: item['image'] ?? 'lib/assets/images/Fruits_.avif',
                onTap: () {
                  // Handle item tap
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item['name']} tapped!')),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
