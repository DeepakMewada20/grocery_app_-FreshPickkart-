import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/controller/active_users_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_state_view.dart';
import '../widgets/network_error_widget.dart';
import '../widgets/user_search_filter_widget.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

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
          child: Column(
            children: [
              Padding(
                padding: AdminResponsive.pagePadding(
                  context,
                ).copyWith(bottom: 0),
                child: AdminResponsive.constrainContent(
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
                              color:
                                  AdminAppTheme.getInfoContainerColor(context),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '${users.length} total',
                              style: AdminTextStyles.body(context).copyWith(
                                color: AdminAppTheme.getInfoColor(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AdminResponsive.pageHorizontalPadding(context),
                    right: AdminResponsive.pageHorizontalPadding(context),
                    bottom: AdminResponsive.bottomInset(context),
                  ),
                  child: AdminResponsive.constrainContent(
                    context: context,
                    child: UserSearchFilterWidget(
                      allUsers: users.cast<ActiveUserStatistics>(),
                      enableSelection: false,
                      isMobileLayout: !AdminResponsive.isTablet(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
