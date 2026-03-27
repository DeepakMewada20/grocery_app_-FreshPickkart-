import 'package:flutter/material.dart';

import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_coupons_tab.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_offers_tab.dart';
import 'bogo_offers_screen.dart';
import 'combo_offers_screen.dart';
import 'category_offers_screen.dart';
import 'free_delivery_screen.dart';
import 'banners_screen.dart';

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
      length: 7,
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
