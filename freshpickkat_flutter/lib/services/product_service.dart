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
      // Show error in UI
      /*
      if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
      */
      // Since we don't have context here easily, we rely on console or UI state.
      // But we can rethrow or set a state variable if this was a provider.
      // Actually, ProductProvider is just a class, not a ChangeNotifier in this file?
      // Wait, let's check if it's a proxy.
      rethrow;
    }
  }
}
