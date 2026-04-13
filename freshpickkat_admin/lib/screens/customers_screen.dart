import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: Text('Customers')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No Customers Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Customers will appear here',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
