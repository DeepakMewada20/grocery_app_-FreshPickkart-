import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:get/get.dart';

class ItemSelectionGirdviwe extends StatelessWidget {
  final String titalWord;
  final int crossAxisCount;
  final double childAspectRatio;
  const ItemSelectionGirdviwe({
    this.childAspectRatio = 0.458,
    this.crossAxisCount = 3,
    super.key,
    required this.titalWord,
  });

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
            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
                  imageUrl: p.imageUrl,
                  title: p.productName,
                  quantity: p.quantity,
                  price: '₹${p.price}',
                  originalPrice: '₹${p.realPrice}',
                  discount: '₹${p.discount}\nOFF',
                  onAddPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added product ${index + 1}')),
                    );
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
