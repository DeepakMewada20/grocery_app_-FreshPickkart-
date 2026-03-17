import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _client = ServerpodAdminClient().client;
  late Future<_DashboardPayload> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _loadDashboard();
  }

  Future<void> _reload() async {
    setState(() {
      _dashboardFuture = _loadDashboard();
    });
  }

  Future<_DashboardPayload> _loadDashboard() async {
    final uid = AdminSessionService.requireUid();
    final idToken = await AdminSessionService.requireIdToken(
      forceRefresh: true,
    );
    final stats = await _client.admin.getDashboardStats(uid, idToken);
    final analytics = await _client.admin.getAnalytics(uid, idToken);
    return _DashboardPayload(stats: stats, analytics: analytics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: _reload, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder<_DashboardPayload>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to load dashboard stats'),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _reload,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final payload = snapshot.data;
          if (payload == null) {
            return const Center(child: Text('No data'));
          }
          final stats = payload.stats;
          final analytics = payload.analytics;
          final topProducts = analytics.topProducts;

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Seller Overview',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Today and overall order performance',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.15,
                  children: [
                    _statCard(
                      title: 'Today Orders',
                      value: '${stats.todayOrders}',
                      icon: Icons.shopping_bag,
                      color: Colors.blue,
                    ),
                    _statCard(
                      title: 'Today Revenue',
                      value: _asCurrency(stats.todayRevenue),
                      icon: Icons.currency_rupee,
                      color: Colors.green,
                    ),
                    _statCard(
                      title: 'Pending',
                      value: '${stats.pendingOrders}',
                      icon: Icons.pending_actions,
                      color: Colors.orange,
                    ),
                    _statCard(
                      title: 'Delivered',
                      value: '${stats.deliveredOrders}',
                      icon: Icons.check_circle,
                      color: Colors.teal,
                    ),
                    _statCard(
                      title: 'Total Orders',
                      value: '${stats.totalOrders}',
                      icon: Icons.receipt_long,
                      color: Colors.indigo,
                    ),
                    _statCard(
                      title: 'Total Revenue',
                      value: _asCurrency(stats.totalRevenue),
                      icon: Icons.savings,
                      color: Colors.pink,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Analytics',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cancellation Rate: ${analytics.cancellationRate.toStringAsFixed(1)}%',
                        ),
                        Text(
                          'Low Stock Items (<=5): ${analytics.lowStockCount}',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Top Products',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        if (topProducts.isEmpty)
                          const Text('No data')
                        else
                          ...topProducts.take(5).map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                '${e.name} • Sold ${e.mostPurchases}',
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _asCurrency(dynamic value) {
    final amount = (value is num) ? value.toDouble() : 0.0;
    return '₹${amount.toStringAsFixed(0)}';
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(title, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }
}

class _DashboardPayload {
  const _DashboardPayload({required this.stats, required this.analytics});

  final AdminDashboardStats stats;
  final AdminAnalytics analytics;
}
