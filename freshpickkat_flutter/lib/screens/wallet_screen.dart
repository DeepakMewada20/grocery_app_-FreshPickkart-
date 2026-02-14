import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/serverpod_client.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final Client _client = ServerpodClient().client;

  /// 👇 CHANGE THIS DATA MANUALLY BEFORE PRESSING THE BUTTON
  Product _buildProduct() {
    return Product(
      productName: 'Raw Banana',
      category: 'Vagetables',
      imageUrl: 'https://file.milkbasket.com/products/43255_0_1746614619.png',
      price:35,
      realPrice: 40,
      discount: 14,
      isAvailable: true,
      addedAt: DateTime.now(),
      subcategory: ['Root Vegetables','Raw Banana'],
      quantity: '500 gm',
    );
  }

  Future<void> _uploadProduct(BuildContext context) async {
    try {
      final product = _buildProduct();
      final result = await _client.product.uploadProduct(product);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Product "${product.productName}" uploaded!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),

          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Wallet Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _uploadProduct(context),
              child: Text(
                'Upload Data',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
