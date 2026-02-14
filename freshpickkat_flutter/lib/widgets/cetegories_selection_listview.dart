import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/view_all_products_screen.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/widgets/view_all_card.dart';
import 'package:get/get.dart';

class CetegoriesSelectionListview extends StatelessWidget {
  final String titalWord;
  const CetegoriesSelectionListview({super.key, required this.titalWord});

  @override
  Widget build(BuildContext context) {
    final productController = ProductProviderController.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titalWord,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 289,
          child: Obx(() {
            final products = productController.allProducts;
            final itemCount = (products.length > 5 ? 5 : products.length) + 1;

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // Show ViewAllCard as last item
                if (index == itemCount - 1) {
                  return SizedBox(
                    width: 160,
                    child: ViewAllCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViewAllProductsScreen(),
                          ),
                        );
                      },
                    ),
                  );
                }

                final p = products[index];
                // Show regular ProductCard
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: ProductCard(
                    imageUrl: p.imageUrl,
                    title: p.productName,
                    quantity: p.quantity,
                    price: '₹${p.price}',
                    originalPrice: '₹${p.realPrice}',
                    discount: '₹${p.discount}\nOFF',
                    onAddPressed: () {},
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
