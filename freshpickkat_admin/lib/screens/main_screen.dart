import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_order_controller.dart';
import 'package:freshpickkat_admin/controller/admin_dashboard_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/controller/live_delivery_controller.dart';
import 'package:freshpickkat_admin/services/admin_realtime_service.dart';
import 'package:freshpickkat_admin/services/admin_notification_navigation_service.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';

import 'dashboard_screen.dart';
import 'orders_screen.dart';
import 'products_screen.dart';
import 'offers_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Worker? _orderFocusWorker;

  List<Widget> get _screens => const [
    DashboardScreen(),
    OrdersScreen(),
    ProductsScreen(),
    OffersScreen(),
    SettingsScreen(),
  ];

  late final List<bool> _builtScreens = List.generate(
    _screens.length,
    (index) => index == 0,
  );

  @override
  void initState() {
    super.initState();
    // Initialize controllers lazily so data is only fetched when screens are visited
    Get.lazyPut(() => AdminCategoryController());
    Get.lazyPut(() => AdminProductController());
    Get.lazyPut(() => AdminOrderController());
    Get.lazyPut(() => AdminDashboardController());
    Get.lazyPut(() => AdminCouponController());
    Get.lazyPut(() => LiveDeliveryController());
    final pendingOrderId =
        AdminNotificationNavigationService.instance.focusedOrderId.value;
    if (pendingOrderId != null && pendingOrderId.isNotEmpty) {
      _selectedIndex = 1;
      _builtScreens[1] = true;
    }
    _orderFocusWorker = ever<String?>(
      AdminNotificationNavigationService.instance.focusedOrderId,
      (orderId) {
        if (orderId == null || orderId.isEmpty) return;
        _selectTab(1);
      },
    );
    unawaited(_startRealtime());
  }

  Future<void> _startRealtime() async {
    try {
      await AdminRealtimeService.instance.start();
    } catch (_) {}
  }

  @override
  void dispose() {
    _orderFocusWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useRail =
        AdminResponsive.isTablet(context) ||
        (AdminResponsive.isLandscape(context) &&
            MediaQuery.sizeOf(context).width >= 700);
    final content = IndexedStack(
      index: _selectedIndex,
      children: List.generate(_screens.length, (index) {
        if (index == _selectedIndex) {
          _builtScreens[index] = true;
        }
        return _builtScreens[index] ? _screens[index] : const SizedBox.shrink();
      }),
    );

    if (useRail) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                labelType: NavigationRailLabelType.all,
                minWidth: AdminResponsive.isDesktopLike(context) ? 96 : 78,
                groupAlignment: -0.85,
                onDestinationSelected: _selectTab,
                destinations: _railDestinations,
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: _selectTab,
          destinations: _barDestinations,
        ),
      ),
    );
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const _barDestinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: 'Orders',
    ),
    NavigationDestination(
      icon: Icon(Icons.inventory_2_outlined),
      selectedIcon: Icon(Icons.inventory_2),
      label: 'Products',
    ),
    NavigationDestination(
      icon: Icon(Icons.local_offer_outlined),
      selectedIcon: Icon(Icons.local_offer),
      label: 'Offers',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  static const _railDestinations = [
    NavigationRailDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: Text('Dashboard'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: Text('Orders'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.inventory_2_outlined),
      selectedIcon: Icon(Icons.inventory_2),
      label: Text('Products'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.local_offer_outlined),
      selectedIcon: Icon(Icons.local_offer),
      label: Text('Offers'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: Text('Settings'),
    ),
  ];
}
