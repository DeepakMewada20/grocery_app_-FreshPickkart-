import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:get/get.dart';

class ItemSelectionGirdviwe extends StatelessWidget {
  final String titalWord;
  final int crossAxisCount;
  final double childAspectRatio;
  final Widget? midContent;
  final int midContentAfterCount;
  const ItemSelectionGirdviwe({
    this.childAspectRatio = 0.458,
    this.crossAxisCount = 3,
    this.midContent,
    this.midContentAfterCount = 20,
    super.key,
    required this.titalWord,
  });

  Widget _buildGridSection(
    BuildContext context,
    List products,
  ) {
    if (products.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return ProductCard(
          product: p,
          onAddPressed: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productController = ProductProviderController.instance;

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titalWord,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Obx(() {
            final products = productController.allProducts;
            final normalizedSplitIndex = midContentAfterCount <= 0
                ? 0
                : ((midContentAfterCount + crossAxisCount - 1) ~/
                          crossAxisCount) *
                      crossAxisCount;
            final splitIndex = normalizedSplitIndex.clamp(0, products.length);
            final beforeMidContent = products.take(splitIndex).toList();
            final afterMidContent = products.skip(splitIndex).toList();

            return Column(
              children: [
                _buildGridSection(context, beforeMidContent),
                if (midContent != null && products.length > splitIndex)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: midContent!,
                  ),
                _buildGridSection(context, afterMidContent),
              ],
            );
          }),
        ],
      ),
    );
  }
}
