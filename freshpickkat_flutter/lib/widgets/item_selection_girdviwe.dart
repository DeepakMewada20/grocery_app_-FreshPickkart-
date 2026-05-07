import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemSelectionGirdviwe extends StatelessWidget {
  final String titalWord;
  final int crossAxisCount;
  final double childAspectRatio;
  final Widget? midContent;
  final int midContentAfterCount;
  final bool adaptiveLayout;
  const ItemSelectionGirdviwe({
    this.childAspectRatio = 0.44,
    this.crossAxisCount = 3,
    this.midContent,
    this.midContentAfterCount = 20,
    this.adaptiveLayout = true,
    super.key,
    required this.titalWord,
  });

  Widget _buildGridSection(
    BuildContext context,
    List products,
    int effectiveColumns,
    double effectiveAspectRatio,
  ) {
    if (products.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: effectiveColumns,
        childAspectRatio: effectiveAspectRatio,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return ProductCard(
          product: p,
          heroTagSuffix: '_grid',
          onAddPressed: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productController = ProductProviderController.instance;

    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 16.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width - 24.w;
          final effectiveColumns = adaptiveLayout
              ? AppResponsive.productGridColumnsForWidth(availableWidth)
              : crossAxisCount;
          final effectiveAspectRatio = adaptiveLayout
              ? AppResponsive.productCardAspectRatioForWidth(
                  availableWidth,
                  effectiveColumns,
                  spacing: 12.w,
                )
              : childAspectRatio;

          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      titalWord,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle(context),
                    ),
                  ),
                ],
              ),
              Obx(() {
                final products = productController.allProducts;
                final normalizedSplitIndex = midContentAfterCount <= 0
                    ? 0
                    : ((midContentAfterCount + effectiveColumns - 1) ~/
                              effectiveColumns) *
                          effectiveColumns;
                final splitIndex = normalizedSplitIndex.clamp(
                  0,
                  products.length,
                );
                final beforeMidContent = products.take(splitIndex).toList();
                final afterMidContent = products.skip(splitIndex).toList();

                return Column(
                  children: [
                    _buildGridSection(
                      context,
                      beforeMidContent,
                      effectiveColumns,
                      effectiveAspectRatio,
                    ),
                    if (midContent != null && products.length > splitIndex)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: midContent!,
                      ),
                    _buildGridSection(
                      context,
                      afterMidContent,
                      effectiveColumns,
                      effectiveAspectRatio,
                    ),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
