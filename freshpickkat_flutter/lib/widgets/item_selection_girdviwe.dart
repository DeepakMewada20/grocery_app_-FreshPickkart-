import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/services/product_service.dart';

class ItemSelectionGirdviwe extends StatefulWidget {
  final ProductProvider provider;
  final String titalWord;
  final int crossAxisCount;
  final double childAspectRatio;
  const ItemSelectionGirdviwe({
    this.childAspectRatio = 0.458,
    this.crossAxisCount = 3,
    super.key,
    required this.titalWord,
    required this.provider,
  });

  @override
  State<ItemSelectionGirdviwe> createState() => _ItemSelectionGirdviweState();
}

class _ItemSelectionGirdviweState extends State<ItemSelectionGirdviwe> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.titalWord,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              childAspectRatio: widget.childAspectRatio, // same as before
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: widget.provider.allProducts.length, // Number of products
            itemBuilder: (context, index) {
              final p = widget.provider.allProducts[index];
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
          ),
        ],
      ),
    );
  }
}
