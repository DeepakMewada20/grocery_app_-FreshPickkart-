import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/controller/active_users_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_state_view.dart';
import '../widgets/network_error_widget.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  late ActiveUsersController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ActiveUsersController(), tag: 'CustomersScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('Active Users'),
        actions: [
          IconButton(
            onPressed: _controller.loadActiveUsers,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.networkController.hasError.value) {
          return NetworkErrorWidget(
            onRetry: () => _controller.networkController.retryLastRequest(),
          );
        }

        final users = _controller.activeUsers.value;
        final isLoading = _controller.isLoading.value;
        final error = _controller.error.value;

        if (isLoading && users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null && users.isEmpty) {
          return AdminStateView.error(
            message: error,
            onRetry: _controller.loadActiveUsers,
          );
        }

        if (users.isEmpty) {
          return AdminStateView.empty(
            title: 'No Active Users',
            message: 'Active users will appear here once orders are placed.',
            onRefresh: _controller.loadActiveUsers,
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.loadActiveUsers,
          child: ListView(
            padding: AdminResponsive.pagePadding(context),
            children: [
              AdminResponsive.constrainContent(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Users',
                              style: AdminTextStyles.screenTitle(context),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Total: ${_controller.totalUsers.value} users',
                              style: AdminTextStyles.caption(context),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '${users.length} loaded',
                            style: AdminTextStyles.body(context).copyWith(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    _buildUsersTable(context, users),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildUsersTable(BuildContext context, List<dynamic> users) {
    final isDesktop = AdminResponsive.isDesktopLike(context);
    final isTablet = AdminResponsive.isTablet(context);

    if (!isTablet) {
      return _buildMobileList(users);
    } else if (!isDesktop) {
      return _buildTabletTable(users);
    } else {
      return _buildDesktopTable(users);
    }
  }

  Widget _buildMobileList(List<dynamic> users) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
          (_) => Colors.grey.shade100,
        ),
        columns: [
          DataColumn(
            label: Text('Name', style: AdminTextStyles.cardTitle(context)),
          ),
          DataColumn(
            label: Text('Phone', style: AdminTextStyles.cardTitle(context)),
          ),
          DataColumn(
            label: Text('Orders', style: AdminTextStyles.cardTitle(context)),
          ),
          DataColumn(
            label: Text(
              'Total Spent',
              style: AdminTextStyles.cardTitle(context),
            ),
          ),
        ],
        rows: users.map((user) {
          return DataRow(
            cells: [
              DataCell(
                Text(user.name ?? 'N/A', style: AdminTextStyles.body(context)),
              ),
              DataCell(
                Text(user.phoneNumber, style: AdminTextStyles.caption(context)),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${user.totalOrdersCount}',
                    style: AdminTextStyles.caption(
                      context,
                    ).copyWith(color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              DataCell(
                Text(
                  _controller.formatCurrency(user.totalSpent),
                  style: AdminTextStyles.body(
                    context,
                  ).copyWith(color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabletTable(List<dynamic> users) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
          (_) => Colors.grey.shade100,
        ),
        columnSpacing: 16,
        columns: [
          DataColumn(
            label: Text('User Name', style: AdminTextStyles.cardTitle(context)),
          ),
          DataColumn(
            label: Text('Phone', style: AdminTextStyles.cardTitle(context)),
          ),
          DataColumn(
            label: Text('Email', style: AdminTextStyles.cardTitle(context)),
          ),
          DataColumn(
            label: Text('Orders', style: AdminTextStyles.cardTitle(context)),
          ),
          DataColumn(
            label: Text(
              'Total Spent',
              style: AdminTextStyles.cardTitle(context),
            ),
          ),
          DataColumn(
            label: Text(
              'Last Order',
              style: AdminTextStyles.cardTitle(context),
            ),
          ),
        ],
        rows: users.map((user) {
          return DataRow(
            cells: [
              DataCell(
                Text(user.name ?? 'N/A', style: AdminTextStyles.body(context)),
              ),
              DataCell(
                Text(user.phoneNumber, style: AdminTextStyles.caption(context)),
              ),
              DataCell(
                Text(
                  user.email ?? 'N/A',
                  style: AdminTextStyles.caption(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${user.totalOrdersCount}',
                    style: AdminTextStyles.cardTitle(
                      context,
                    ).copyWith(color: Colors.blue),
                  ),
                ),
              ),
              DataCell(
                Text(
                  _controller.formatCurrency(user.totalSpent),
                  style: AdminTextStyles.body(
                    context,
                  ).copyWith(color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ),
              DataCell(
                Text(
                  _controller.formatDate(user.lastOrderDate),
                  style: AdminTextStyles.caption(context),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopTable(List<dynamic> users) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith(
          (_) => Colors.grey.shade100,
        ),
        columnSpacing: 24,
        columns: [
          DataColumn(
            label: Text('User Name', style: AdminTextStyles.cardTitle(context)),
          ),
          DataColumn(
            label: Text(
              'Phone Number',
              style: AdminTextStyles.cardTitle(context),
            ),
          ),
          DataColumn(
            label: Text(
              'Email Address',
              style: AdminTextStyles.cardTitle(context),
            ),
          ),
          DataColumn(
            label: Text(
              'Orders Count',
              style: AdminTextStyles.cardTitle(context),
            ),
          ),
          DataColumn(
            label: Text(
              'Total Amount Spent',
              style: AdminTextStyles.cardTitle(context),
            ),
          ),
          DataColumn(
            label: Text(
              'Last Order Date',
              style: AdminTextStyles.cardTitle(context),
            ),
          ),
          DataColumn(
            label: Text('Status', style: AdminTextStyles.cardTitle(context)),
          ),
        ],
        rows: users.map((user) {
          return DataRow(
            cells: [
              DataCell(
                Tooltip(
                  message: user.name ?? 'Unknown',
                  child: Text(
                    user.name ?? 'N/A',
                    style: AdminTextStyles.body(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Text(user.phoneNumber, style: AdminTextStyles.body(context)),
              ),
              DataCell(
                Tooltip(
                  message: user.email ?? 'Not provided',
                  child: Text(
                    user.email ?? 'N/A',
                    style: AdminTextStyles.caption(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${user.totalOrdersCount}',
                    style: AdminTextStyles.cardTitle(
                      context,
                    ).copyWith(color: Colors.blue, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              DataCell(
                Text(
                  _controller.formatCurrency(user.totalSpent),
                  style: AdminTextStyles.body(context).copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              DataCell(
                Text(
                  _controller.formatDate(user.lastOrderDate),
                  style: AdminTextStyles.body(context),
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: user.status == 'active'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    user.status?.toUpperCase() ?? 'UNKNOWN',
                    style: AdminTextStyles.caption(context).copyWith(
                      color: user.status == 'active'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
