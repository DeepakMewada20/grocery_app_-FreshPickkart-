import 'package:flutter/rendering.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class ProductProvider {
  final Client client;
  ProductProvider(this.client);

  List<Product> allProducts = [];
  bool isMoreDataAvailable = true;

  Future<void> loadProducts() async {
    if (!isMoreDataAvailable) return;

    try {
      // Use the correct getter from the Client
      var newProducts = await client.product.getProducts(
        limit: 10,
        // Pehli baar null jayega, uske baad last product ka naam
        lastProductName: allProducts.isEmpty
            ? null
            : allProducts.last.productName,
      );

      if (newProducts.length < 10) {
        isMoreDataAvailable = false;
      }

      allProducts.addAll(newProducts);
      print(newProducts);
    } catch (e) {
      print("Flutter Error: $e");
    }
  }
}
