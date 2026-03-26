import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_order_controller.dart';
import 'package:freshpickkat_admin/controller/admin_dashboard_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'dashboard_screen.dart';
import 'orders_screen.dart';
import 'products_screen.dart';
import 'bogo_offers_screen.dart';
import 'combo_offers_screen.dart';
import 'category_offers_screen.dart';
import 'free_delivery_screen.dart';
import 'settings_screen.dart';
import 'banners_screen.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_categories_tab.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_coupons_tab.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_offers_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const OrdersScreen(),
    const ProductsScreen(),
    const OffersScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    Get.put(AdminCategoryController());
    Get.put(AdminProductController());
    Get.put(AdminOrderController());
    Get.put(AdminDashboardController());
    Get.put(AdminCouponController());
    Get.put(AdminOfferController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
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
        ],
      ),
    );
  }
}

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final AdminCategoryController _categoryController =
      AdminCategoryController.instance;
  final AdminCouponController _couponController =
      AdminCouponController.instance;
  final AdminProductController _productController =
      AdminProductController.instance;

  String _couponSearchQuery = '';
  String _offerSearchQuery = '';
  String _offerTypeFilter = 'live';
  String _offerCategoryFilter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureDataLoaded();
    });
  }

  Future<void> _ensureDataLoaded() async {
    final futures = <Future<void>>[];
    if (_categoryController.categories.isEmpty &&
        !_categoryController.isLoading.value) {
      futures.add(_categoryController.loadCategories());
    }
    if (_couponController.coupons.isEmpty &&
        !_couponController.isLoading.value) {
      futures.add(_couponController.loadCoupons());
    }
    if (_productController.products.isEmpty &&
        !_productController.isLoading.value) {
      futures.add(_productController.loadInitial());
    }
    if (futures.isEmpty) return;
    await Future.wait(futures);
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _categoryController.loadCategories(),
      _couponController.loadCoupons(),
      _productController.loadInitial(),
    ]);
  }

  Future<void> _openAddCategoryDialog() {
    return showAddCategoryDialog(
      context: context,
      controller: _categoryController,
    );
  }

  Future<void> _openAddSubcategoryDialog() {
    return showAddSubcategoryDialog(
      context: context,
      controller: _categoryController,
    );
  }

  Future<void> _openAddCouponDialog() {
    return showAddCouponDialog(context: context, controller: _couponController);
  }

  Future<void> _openEditCouponDialog(Coupon coupon) {
    return showEditCouponDialog(
      context: context,
      controller: _couponController,
      coupon: coupon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Offers & Promotions'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          actions: [
            IconButton(onPressed: _refreshAll, icon: const Icon(Icons.refresh)),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Categories'),
              Tab(text: 'Coupons'),
              Tab(text: 'Offers'),
              Tab(text: 'BOGO'),
              Tab(text: 'Combos'),
              Tab(text: 'Category Offer'),
              Tab(text: 'Delivery'),
              Tab(text: 'Banners'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CatalogCategoriesTab(
              controller: _categoryController,
              onAddCategory: _openAddCategoryDialog,
              onAddSubcategory: _openAddSubcategoryDialog,
            ),
            CatalogCouponsTab(
              controller: _couponController,
              searchQuery: _couponSearchQuery,
              onSearchChanged: (value) {
                setState(() {
                  _couponSearchQuery = value;
                });
              },
              onCreateCoupon: _openAddCouponDialog,
              onEditCoupon: _openEditCouponDialog,
            ),
            CatalogOffersTab(
              productController: _productController,
              categoryController: _categoryController,
              couponController: _couponController,
              offerSearchQuery: _offerSearchQuery,
              offerTypeFilter: _offerTypeFilter,
              offerCategoryFilter: _offerCategoryFilter,
              onOfferSearchChanged: (value) {
                setState(() {
                  _offerSearchQuery = value;
                });
              },
              onOfferCategoryChanged: (value) {
                setState(() {
                  _offerCategoryFilter = value;
                });
              },
              onOfferTypeChanged: (value) {
                setState(() {
                  _offerTypeFilter = value;
                });
              },
              onRefresh: _refreshAll,
            ),
            const BogoOffersScreen(),
            const ComboOffersScreen(),
            const CategoryOffersScreen(),
            const FreeDeliveryScreen(),
            const BannersScreen(),
          ],
        ),
      ),
    );
  }
}
