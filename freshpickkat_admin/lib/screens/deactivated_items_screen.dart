import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as protocol;
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_combo_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_bogo_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_category_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_banner_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_free_delivery_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/widgets/admin_app_bar.dart';

class DeactivatedItemsScreen extends StatefulWidget {
  const DeactivatedItemsScreen({super.key});

  @override
  State<DeactivatedItemsScreen> createState() => _DeactivatedItemsScreenState();
}

class _DeactivatedItemsScreenState extends State<DeactivatedItemsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _loadAllData();
  }

  void _loadAllData() {
    final catCtrl = AdminCategoryController.instance;
    if (catCtrl.inactiveCategories.isEmpty && !catCtrl.isLoadingInactive.value) {
      catCtrl.loadInactiveCategories();
    }
    final productCtrl = AdminProductController.instance;
    if (productCtrl.inactiveProducts.isEmpty && !productCtrl.isLoadingInactive.value) {
      productCtrl.loadInactiveProducts();
    }
    final comboCtrl = AdminComboOfferController.instance;
    if (comboCtrl.inactiveComboOffers.isEmpty && !comboCtrl.isLoadingInactive.value) {
      comboCtrl.loadInactiveComboOffers();
    }
    final bogoCtrl = AdminBogoController.instance;
    if (bogoCtrl.inactiveBogoOffers.isEmpty && !bogoCtrl.isLoadingInactive.value) {
      bogoCtrl.loadInactiveBogoOffers();
    }
    final catOfferCtrl = AdminCategoryOfferController.instance;
    if (catOfferCtrl.inactiveCategoryOffers.isEmpty &&
        !catOfferCtrl.isLoadingInactive.value) {
      catOfferCtrl.loadInactiveCategoryOffers();
    }
    final couponCtrl = AdminCouponController.instance;
    if (couponCtrl.inactiveCoupons.isEmpty && !couponCtrl.isLoadingInactive.value) {
      couponCtrl.loadInactiveCoupons();
    }
    final bannerCtrl = AdminBannerController.instance;
    if (bannerCtrl.inactiveBanners.isEmpty && !bannerCtrl.isLoadingInactive.value) {
      bannerCtrl.loadInactiveBanners();
    }
    final deliveryCtrl = AdminFreeDeliveryController.instance;
    if (deliveryCtrl.inactiveDeliveryRules.isEmpty &&
        !deliveryCtrl.isLoadingInactive.value) {
      deliveryCtrl.loadInactiveDeliveryRules();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('Deactivated Items'),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          labelColor: AdminThemeTokens.white,
          unselectedLabelColor:
              AdminThemeTokens.white.withValues(alpha: 0.7),
          tabs: const [
            Tab(text: 'Categories'),
            Tab(text: 'Products'),
            Tab(text: 'Combo Offers'),
            Tab(text: 'BOGO Offers'),
            Tab(text: 'Category Offers'),
            Tab(text: 'Coupons'),
            Tab(text: 'Banners'),
            Tab(text: 'Delivery'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DeactivatedTab<protocol.Category>(
            sourceList:
                AdminCategoryController.instance.inactiveCategories,
            displayName: (c) => c.categoryName,
            leadingIcon: (c) =>
                const Icon(Icons.category_outlined),
            onReactivate: (c) async {
              await AdminCategoryController.instance
                  .setCategoryActive(c.categoryName, true);
            },
            emptyMessage: 'No deactivated categories',
            isLoading: AdminCategoryController.instance.isLoadingInactive,
          ),
          _DeactivatedTab<protocol.Product>(
            sourceList:
                AdminProductController.instance.inactiveProducts,
            displayName: (p) => p.productName,
            leadingIcon: (p) =>
                const Icon(Icons.shopping_bag_outlined),
            onReactivate: (p) async {
              await AdminProductController.instance
                  .deactivateProduct(p.productId!, true);
            },
            emptyMessage: 'No deactivated products',
            isLoading: AdminProductController.instance.isLoadingInactive,
          ),
          _DeactivatedTab<protocol.ComboOffer>(
            sourceList:
                AdminComboOfferController.instance.inactiveComboOffers,
            displayName: (o) => o.name,
            leadingIcon: (o) =>
                const Icon(Icons.local_offer_outlined),
            onReactivate: (o) async {
              await AdminComboOfferController.instance
                  .toggleComboOffer(o.comboId!, true);
            },
            emptyMessage: 'No deactivated combo offers',
            isLoading:
                AdminComboOfferController.instance.isLoadingInactive,
          ),
          _DeactivatedTab<protocol.BogoOffer>(
            sourceList:
                AdminBogoController.instance.inactiveBogoOffers,
            displayName: (o) => o.offerTitle,
            leadingIcon: (o) =>
                const Icon(Icons.production_quantity_limits_outlined),
            onReactivate: (o) async {
              await AdminBogoController.instance
                  .setBogoOfferActive(o.triggerProductId, true);
            },
            emptyMessage: 'No deactivated BOGO offers',
            isLoading: AdminBogoController.instance.isLoadingInactive,
          ),
          _DeactivatedTab<protocol.CategoryOffer>(
            sourceList:
                AdminCategoryOfferController.instance.inactiveCategoryOffers,
            displayName: (o) => o.name,
            leadingIcon: (o) =>
                const Icon(Icons.category_outlined),
            onReactivate: (o) async {
              await AdminCategoryOfferController.instance
                  .toggleCategoryOffer(o.offerId!, true);
            },
            emptyMessage: 'No deactivated category offers',
            isLoading:
                AdminCategoryOfferController.instance.isLoadingInactive,
          ),
          _DeactivatedTab<protocol.Coupon>(
            sourceList:
                AdminCouponController.instance.inactiveCoupons,
            displayName: (c) => c.code,
            leadingIcon: (c) =>
                const Icon(Icons.card_giftcard_outlined),
            onReactivate: (c) async {
              await AdminCouponController.instance
                  .setCouponActive(c.code, true);
            },
            emptyMessage: 'No deactivated coupons',
            isLoading:
                AdminCouponController.instance.isLoadingInactive,
          ),
          _DeactivatedTab<protocol.Banner>(
            sourceList:
                AdminBannerController.instance.inactiveBanners,
            displayName: (b) => b.title,
            leadingIcon: (b) =>
                const Icon(Icons.campaign_outlined),
            onReactivate: (b) async {
              await AdminBannerController.instance
                  .toggleBannerActive(b.bannerId!, true);
            },
            emptyMessage: 'No deactivated banners',
            isLoading:
                AdminBannerController.instance.isLoadingInactive,
          ),
          _DeactivatedTab<protocol.DeliveryRule>(
            sourceList:
                AdminFreeDeliveryController.instance.inactiveDeliveryRules,
            displayName: (r) => r.name,
            leadingIcon: (r) =>
                const Icon(Icons.local_shipping_outlined),
            onReactivate: (r) async {
              await AdminFreeDeliveryController.instance
                  .toggleDeliveryRule(r.ruleId!, true);
            },
            emptyMessage: 'No deactivated delivery rules',
            isLoading:
                AdminFreeDeliveryController.instance.isLoadingInactive,
          ),
        ],
      ),
    );
  }
}

class _DeactivatedTab<T> extends StatelessWidget {
  final RxList<T> sourceList;
  final String Function(T) displayName;
  final Widget Function(T) leadingIcon;
  final Future<void> Function(T) onReactivate;
  final String emptyMessage;
  final RxBool isLoading;

  const _DeactivatedTab({
    required this.sourceList,
    required this.displayName,
    required this.leadingIcon,
    required this.onReactivate,
    required this.emptyMessage,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value && sourceList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (sourceList.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              emptyMessage,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
                fontSize: 15,
              ),
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        itemCount: sourceList.length,
        itemBuilder: (context, index) {
          final item = sourceList[index];
          return Card(
            child: ListTile(
              leading: leadingIcon(item),
              title: Text(displayName(item)),
              trailing: TextButton.icon(
                onPressed: () => _reactivate(context, item),
                icon: const Icon(Icons.check_circle_outline,
                    size: 18),
                label: const Text('Reactivate'),
              ),
            ),
          );
        },
      );
    });
  }

  Future<void> _reactivate(BuildContext context, T item) async {
    try {
      await onReactivate(item);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('${displayName(item)} reactivated'),
          ),
        );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('Failed: $e'),
          ),
        );
    }
  }
}
