import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/screens/view_all_products_screen.dart';
import 'package:freshpickkat_flutter/services/product_service.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/widgets/view_all_card.dart';

class CetegoriesSelectionListview extends StatefulWidget {
  final String titalWord;
  final ProductProvider provider;
  const CetegoriesSelectionListview({super.key, required this.titalWord,required this.provider});

  @override
  State<CetegoriesSelectionListview> createState() =>
      _CetegoriesSelectionListviewState();
}

class _CetegoriesSelectionListviewState
    extends State<CetegoriesSelectionListview> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.titalWord,
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
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5 + 1, // Products + 1 for ViewAllCard
            itemBuilder: (context, index) {
              final p = widget.provider.allProducts[index];
              // Show ViewAllCard as last item
              if (index == 5) {
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
          ),
        ),
      ],
    );
  }
}
