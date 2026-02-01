import 'package:flutter/material.dart';

class ViewAllProductsScreen extends StatelessWidget {
  const ViewAllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      body: const Center(
        child: Text('View All Products Screen'),
      ),
    );
  }
}