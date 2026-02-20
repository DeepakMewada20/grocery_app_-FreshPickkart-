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
      price: 35,
      realPrice: 40,
      discount: 14,
      isAvailable: true,
      addedAt: DateTime.now(),
      subcategory: ['Root Vegetables', 'Raw Banana'],
      quantity: '500 gm',
      mostPurchases: 1,
      mostSearch: 5,
    );
  }

  /// 👇 CHANGE THIS DATA MANUALLY BEFORE PRESSING THE BUTTON
  SubCategory _buildSubCategory() {
    return SubCategory(
      categoryId: 'Fruits',
      subCategoriesName: ['Stone Fruits'],
      subCategoriesUrl:
          'https://file.milkbasket.com/subcategories/Stone+Fruits_1727184884.png',
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

  Future<void> _uploadSubCategory(BuildContext context) async {
    try {
      final subCategory = _buildSubCategory();
      final result = await _client.subCategory.uploadSubCategory(subCategory);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ SubCategory "${subCategory.categoryId}" uploaded!',
            ),
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

  /// Seed all products with random test data for metrics testing
  /// mostSearch: 1-30 (random)
  /// mostPurchases: 1-30 (random)
  /// This helps verify that Trending and Best Sellers sections display correctly
  Future<void> _seedTestData(BuildContext context) async {
    try {
      final count = await _client.product.seedProductMetricsForTesting();

      if (count > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Test data seeded for $count products!\n'
              'Each product now has random mostSearch (1-30)\n'
              'and random mostPurchases (1-30) values.\n'
              'Check Trending Products and Best Sellers sections!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error seeding test data: $e'),
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
                'Upload Product',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _uploadSubCategory(context),
              child: Text(
                'Upload SubCategory',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _seedTestData(context),
              child: Text(
                'Seed Test Data (Random Metrics)',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
