import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_dashboard_controller.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_state_view.dart';
import '../widgets/network_error_widget.dart';
import 'broadcasts_screen.dart';
import 'address_change_requests_screen.dart';
import 'complaint_management_screen.dart';
import 'support_issue_management_screen.dart';
import 'payment_monitoring_screen.dart';
import 'referral_dashboard_screen.dart';
import 'cancellation_requests_screen.dart';
import 'customers_screen.dart';
import 'live_delivery_screen.dart';
import 'deactivated_items_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AdminDashboardController _controller =
      AdminDashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AdminAppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: _controller.loadDashboard,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.networkController.hasError.value) {
          return NetworkErrorWidget(
            onRetry: () => _controller.networkController.retryLastRequest(),
          );
        }

        final stats = _controller.stats.value;
        final analytics = _controller.analytics.value;
        final isLoading = _controller.isLoading.value;
        final error = _controller.error.value;

        if (isLoading && stats == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null && stats == null) {
          return AdminStateView.error(
            message: error,
            onRetry: _controller.loadDashboard,
          );
        }

        if (stats == null || analytics == null) {
          return AdminStateView.empty(
            title: 'No dashboard data yet',
            message: 'Orders and products will appear here once data is added.',
            onRefresh: _controller.loadDashboard,
          );
        }

        final topProducts = analytics.topProducts;
        final smgm = _controller.smgmAnalytics.value;

        return RefreshIndicator(
          onRefresh: _controller.loadDashboard,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cards = [
                _statCard(
                  title: 'Today Orders',
                  value: '${stats.todayOrders}',
                  icon: Icons.shopping_bag_outlined,
                  color: AdminAppTheme.getInfoColor(context),
                ),
                _statCard(
                  title: 'Today Revenue',
                  value: _asCurrency(stats.todayRevenue),
                  icon: Icons.currency_rupee_outlined,
                  color: AdminAppTheme.getSuccessColor(context),
                ),
                _statCard(
                  title: 'Pending',
                  value: '${stats.pendingOrders}',
                  icon: Icons.schedule_outlined,
                  color: AdminAppTheme.getWarningColor(context),
                ),
                _statCard(
                  title: 'Delivered',
                  value: '${stats.deliveredOrders}',
                  icon: Icons.check_circle_outline,
                  color: AdminAppTheme.getTealColor(context),
                ),
                _statCard(
                  title: 'Total Orders',
                  value: '${stats.totalOrders}',
                  icon: Icons.receipt_long_outlined,
                  color: AdminAppTheme.getIndigoColor(context),
                ),
                _statCard(
                  title: 'Total Revenue',
                  value: _asCurrency(stats.totalRevenue),
                  icon: Icons.savings_outlined,
                  color: AdminAppTheme.getPinkColor(context),
                ),
                _statCard(
                  title: 'Referral',
                  value: 'View',
                  icon: Icons.group_add_outlined,
                  color: AdminAppTheme.getTealColor(context),
                ),
              ];

              return ListView(
                padding: AdminResponsive.pagePadding(context),
                children: [
                  AdminResponsive.constrainContent(
                    context: context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seller Overview',
                          style: AdminTextStyles.screenTitle(context),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Today and overall order performance',
                          style: AdminTextStyles.caption(context),
                        ),
                        SizedBox(height: 18.h),
                        LayoutBuilder(
                          builder: (context, gridConstraints) {
                            final columns = AdminResponsive.statColumnsForWidth(
                              gridConstraints.maxWidth,
                            );
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cards.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    mainAxisSpacing: 12.h,
                                    crossAxisSpacing: 12.w,
                                    childAspectRatio: columns == 2
                                        ? 1.12
                                        : 1.42,
                                  ),
                              itemBuilder: (context, index) => cards[index],
                            );
                          },
                        ),
                        if (smgm != null) ...[
                          SizedBox(height: 16.h),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Padding(
                              padding: AdminResponsive.cardPadding(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shop More, Get More',
                                    style: AdminTextStyles.sectionTitle(context),
                                  ),
                                  SizedBox(height: 16.h),
                                  _analyticsRow(
                                    'Total Offers',
                                    '${smgm.totalOffers}',
                                    Icons.card_giftcard_outlined,
                                    AdminAppTheme.getPurpleColor(context),
                                  ),
                                  const Divider(height: 24),
                                  _analyticsRow(
                                    'Active Offers',
                                    '${smgm.activeOffers}',
                                    Icons.check_circle_outline,
                                    AdminAppTheme.getSuccessColor(context),
                                  ),
                                  const Divider(height: 24),
                                  _analyticsRow(
                                    'Rewards Given',
                                    '${smgm.totalRewardsGiven}',
                                    Icons.celebration_outlined,
                                    AdminAppTheme.getInfoColor(context),
                                  ),
                                  const Divider(height: 24),
                                  _analyticsRow(
                                    'Reward Value',
                                    _asCurrency(smgm.totalRewardValue),
                                    Icons.currency_rupee_outlined,
                                    AdminAppTheme.getWarningColor(context),
                                  ),
                                  const Divider(height: 24),
                                  _analyticsRow(
                                    'Orders with SMGM',
                                    '${smgm.totalOrdersWithSmgm}',
                                    Icons.shopping_bag_outlined,
                                    AdminAppTheme.getIndigoColor(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 16.h),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Padding(
                            padding: AdminResponsive.cardPadding(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Analytics & Insights',
                                  style: AdminTextStyles.sectionTitle(context),
                                ),
                                SizedBox(height: 16.h),
                                _analyticsRow(
                                  'Cancellation Rate',
                                  '${analytics.cancellationRate.toStringAsFixed(1)}%',
                                  Icons.cancel_outlined,
                                  AdminAppTheme.getErrorColor(context),
                                ),
                                const Divider(height: 24),
                                _analyticsRow(
                                  'Low Stock Items (<=5)',
                                  '${analytics.lowStockCount}',
                                  Icons.inventory_2_outlined,
                                  AdminAppTheme.getWarningColor(context),
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  'Top Products',
                                  style: AdminTextStyles.cardTitle(context),
                                ),
                                SizedBox(height: 12.h),
                                if (topProducts.isEmpty)
                                  Text('No data available')
                                else
                                  ...topProducts.take(5).map((e) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: AdminAppTheme.getInfoColor(
                                                context,
                                              ).withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.star_outline,
                                              color: AdminAppTheme.getInfoColor(
                                                context,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.name,
                                                  style:
                                                      AdminTextStyles.cardTitle(
                                                        context,
                                                      ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Sold ${e.mostPurchases} times',
                                                  style:
                                                      AdminTextStyles.caption(
                                                        context,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  String _asCurrency(dynamic value) {
    final amount = (value is num) ? value.toDouble() : 0.0;
    if (amount == amount.truncateToDouble()) {
      return '₹${amount.toStringAsFixed(0)}';
    }
    return '₹${amount.toStringAsFixed(2)}';
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: AdminResponsive.cardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22.r),
            ),
            const Spacer(),
            AutoSizeText(
              value,
              style: AdminTextStyles.statValue(context),
              maxLines: 1,
              minFontSize: 14,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AdminAppTheme.getTextSecondaryColor(context)
                    : AdminAppTheme.getTextSecondaryColor(context),
                fontSize: 12.sp.clamp(10.0, 14.0),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: cs.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.store, color: cs.onPrimary, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    'FreshPickKart',
                    style: TextStyle(
                      color: cs.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: cs.onPrimary.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Operations',
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.delivery_dining_outlined),
              title: Text('Live Delivery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LiveDeliveryScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.report_problem_outlined),
              title: Text('Complaints'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ComplaintManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bug_report_outlined),
              title: Text('Support Issues'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SupportIssueManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.payment_outlined),
              title: Text('Payment Monitoring'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentMonitoringScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.group_add_outlined),
              title: Text('Referral Dashboard'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReferralDashboardScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel_outlined),
              title: Text('Cancellation Requests'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CancellationRequestsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('Address Change Requests'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddressChangeRequestsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people_outline),
              title: Text('Active Users'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomersScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.campaign_outlined),
              title: Text('Broadcasts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BroadcastsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_flipped),
              title: const Text('Deactivated Items'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DeactivatedItemsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _analyticsRow(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20.r),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            title,
            style: AdminTextStyles.body(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8.w),
        Flexible(
          flex: 0,
          child: Text(
            value,
            style: AdminTextStyles.cardTitle(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
