import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/modal/home_category_modal.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/category_header_widget.dart';
import 'package:freshpickkat_flutter/widgets/category_item_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: AppResponsive.categoryGridDelegate(
                  context,
                  constraints.maxWidth,
                ),
                itemCount: category.homePageCategoryItem.length,
                itemBuilder: (context, index) {
                  final item = category.homePageCategoryItem[index];
                  return CategoryItemCard(
                    itemName: item['name'] ?? 'Item',
                    imagePath:
                        item['image'],
                    onTap: () {
                      // Handle item tap
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item['name']} tapped!')),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
