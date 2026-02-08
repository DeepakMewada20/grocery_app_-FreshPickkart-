import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';

class ItemSelectionGirdviwe extends StatefulWidget {
  final String titalWord;
  final int crossAxisCount;
  final double childAspectRatio;
  const ItemSelectionGirdviwe({
    this.childAspectRatio = 0.47,
    this.crossAxisCount = 3,
    super.key,
    required this.titalWord,
  });

  @override
  State<ItemSelectionGirdviwe> createState() => _ItemSelectionGirdviweState();
}

class _ItemSelectionGirdviweState extends State<ItemSelectionGirdviwe> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
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
          itemCount: 5, // Number of products
          itemBuilder: (context, index) {
            return ProductCard(
              imageUrl: 'https://example.com/product${index + 1}.jpg',
              title: 'Dabur Honey Squeezy',
              quantity: '2 x 400 gm',
              price: '₹235',
              originalPrice: '₹420',
              discount: '₹185\nOFF',
              onAddPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added product ${index + 1}')),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
