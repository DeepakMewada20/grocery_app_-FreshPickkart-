import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
import 'package:freshpickkat_flutter/core/design_system/app_spacing.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GridInsertion {
  final int afterCount;
  final List<Widget> widgets;
  const GridInsertion({required this.afterCount, required this.widgets});
}

class ItemSelectionGirdviwe extends StatelessWidget {
  final String titalWord;
  final int crossAxisCount;
  final double childAspectRatio;
  final bool adaptiveLayout;
  final List<GridInsertion>? insertions;

  const ItemSelectionGirdviwe({
    this.childAspectRatio = 0.44,
    this.crossAxisCount = 3,
    this.adaptiveLayout = true,
    this.insertions,
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
      padding: AppSpacing.symmetric(vertical: 12),
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
      padding: AppSpacing.only(left: 12, right: 12, top: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : AppResponsive.layoutWidth(context) - 24.w;
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
                      style: AppText.sectionTitle(context),
                    ),
                  ),
                ],
              ),
              Obx(() {
                final products = productController.allProducts;
                final sortedInsertions = insertions != null
                    ? (List<GridInsertion>.from(insertions!)
                        ..sort((a, b) => a.afterCount.compareTo(b.afterCount)))
                    : <GridInsertion>[];

                if (sortedInsertions.isEmpty) {
                  return _buildGridSection(
                    context,
                    products,
                    effectiveColumns,
                    effectiveAspectRatio,
                  );
                }

                final segments = <Widget>[];
                int startIndex = 0;

                for (final insertion in sortedInsertions) {
                  final normalized = insertion.afterCount <= 0
                      ? 0
                      : ((insertion.afterCount + effectiveColumns - 1) ~/
                                effectiveColumns) *
                            effectiveColumns;
                  final splitAt = normalized.clamp(startIndex, products.length);

                  if (splitAt > startIndex) {
                    segments.add(
                      _buildGridSection(
                        context,
                        products.sublist(startIndex, splitAt),
                        effectiveColumns,
                        effectiveAspectRatio,
                      ),
                    );
                  }

                  if (splitAt < products.length) {
                    for (final w in insertion.widgets) {
                      segments.add(
                        Padding(
                          padding: AppSpacing.only(bottom: 12),
                          child: w,
                        ),
                      );
                    }
                  }

                  startIndex = splitAt;
                }

                if (startIndex < products.length) {
                  segments.add(
                    _buildGridSection(
                      context,
                      products.sublist(startIndex),
                      effectiveColumns,
                      effectiveAspectRatio,
                    ),
                  );
                }

                return Column(children: segments);
              }),
            ],
          );
        },
      ),
    );
  }
}
