import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/services/product_service.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// A minimal test screen that fetches products from the server and shows them.
class ProductListTestScreen extends StatefulWidget {
  const ProductListTestScreen({super.key});

  @override
  State<ProductListTestScreen> createState() => _ProductListTestScreenState();
}

class _ProductListTestScreenState extends State<ProductListTestScreen> {
  late final Client client;
  late final ProductProvider provider;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // Use 10.0.2.2 for Android emulator to reach host machine's localhost.
    client = Client('http://10.0.2.2:8080/')
      ..connectivityMonitor = FlutterConnectivityMonitor();
    provider = ProductProvider(client);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => loading = true);
    try {
      await provider.loadProducts();
      // provider prints products to console already; we update UI below
      setState(() {});
    } catch (e) {
      // show simple error scaffold
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List Test')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : provider.allProducts.isEmpty
          ? Center(
              child: ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Load products'),
              ),
            )
          : ListView.separated(
              itemCount: provider.allProducts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final p = provider.allProducts[index];
                return ListTile(
                  title: Text(p.productName),
                  subtitle: Text(p.category ?? ''),
                  trailing: Text('₹${p.price}'),
                );
              },
            ),
    );
  }
}
