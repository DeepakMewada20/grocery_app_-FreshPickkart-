import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as protocol;
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
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
  final _loadedTabs = <int>{};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadTabData(0);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _loadTabData(_tabController.index);
    }
  }

  void _loadTabData(int index) {
    if (!_loadedTabs.add(index)) return;
    switch (index) {
      case 0:
        AdminCategoryController.instance.loadInactiveCategories();
      case 1:
        AdminProductController.instance.loadInactiveProducts();
      case 2:
        AdminComboOfferController.instance.loadInactiveComboOffers();
      case 3:
        AdminBogoController.instance.loadInactiveBogoOffers();
      case 4:
        AdminCategoryOfferController.instance.loadInactiveCategoryOffers();
      case 5:
        AdminCouponController.instance.loadInactiveCoupons();
      case 6:
        AdminBannerController.instance.loadInactiveBanners();
      case 7:
        AdminFreeDeliveryController.instance.loadInactiveDeliveryRules();
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
          unselectedLabelColor: AdminThemeTokens.white.withValues(alpha: 0.7),
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
            sourceList: AdminCategoryController.instance.inactiveCategories,
            displayName: (c) => c.categoryName,
            leadingIcon: (c) => const Icon(Icons.category_outlined),
            onReactivate: (c) async {
              await AdminCategoryController.instance.setCategoryActive(
                c.categoryName,
                true,
              );
            },
            emptyMessage: 'No deactivated categories',
            isLoading: AdminCategoryController.instance.isLoadingInactive,
            onRefresh: () =>
                AdminCategoryController.instance.loadInactiveCategories(),
          ),
          _DeactivatedTab<protocol.Product>(
            sourceList: AdminProductController.instance.inactiveProducts,
            displayName: (p) => p.productName,
            leadingIcon: (p) => const Icon(Icons.shopping_bag_outlined),
            onReactivate: (p) async {
              await AdminProductController.instance.deactivateProduct(
                p.productId!,
                true,
              );
            },
            emptyMessage: 'No deactivated products',
            isLoading: AdminProductController.instance.isLoadingInactive,
            onRefresh: () =>
                AdminProductController.instance.loadInactiveProducts(),
          ),
          _DeactivatedTab<protocol.ComboOffer>(
            sourceList: AdminComboOfferController.instance.inactiveComboOffers,
            displayName: (o) => o.name,
            leadingIcon: (o) => const Icon(Icons.local_offer_outlined),
            onReactivate: (o) async {
              await AdminComboOfferController.instance.toggleComboOffer(
                o.comboId!,
                true,
              );
            },
            emptyMessage: 'No deactivated combo offers',
            isLoading: AdminComboOfferController.instance.isLoadingInactive,
            onRefresh: () =>
                AdminComboOfferController.instance.loadInactiveComboOffers(),
          ),
          _DeactivatedTab<protocol.BogoOffer>(
            sourceList: AdminBogoController.instance.inactiveBogoOffers,
            displayName: (o) => o.offerTitle,
            leadingIcon: (o) =>
                const Icon(Icons.production_quantity_limits_outlined),
            onReactivate: (o) async {
              await AdminBogoController.instance.setBogoOfferActive(
                o.triggerProductId,
                true,
              );
            },
            emptyMessage: 'No deactivated BOGO offers',
            isLoading: AdminBogoController.instance.isLoadingInactive,
            onRefresh: () =>
                AdminBogoController.instance.loadInactiveBogoOffers(),
          ),
          _DeactivatedTab<protocol.CategoryOffer>(
            sourceList:
                AdminCategoryOfferController.instance.inactiveCategoryOffers,
            displayName: (o) => o.name,
            leadingIcon: (o) => const Icon(Icons.category_outlined),
            onReactivate: (o) async {
              await AdminCategoryOfferController.instance.toggleCategoryOffer(
                o.offerId!,
                true,
              );
            },
            emptyMessage: 'No deactivated category offers',
            isLoading: AdminCategoryOfferController.instance.isLoadingInactive,
            onRefresh: () => AdminCategoryOfferController.instance
                .loadInactiveCategoryOffers(),
          ),
          _DeactivatedTab<protocol.Coupon>(
            sourceList: AdminCouponController.instance.inactiveCoupons,
            displayName: (c) => c.code,
            leadingIcon: (c) => const Icon(Icons.card_giftcard_outlined),
            onReactivate: (c) async {
              await AdminCouponController.instance.setCouponActive(
                c.code,
                true,
              );
            },
            emptyMessage: 'No deactivated coupons',
            isLoading: AdminCouponController.instance.isLoadingInactive,
            onRefresh: () =>
                AdminCouponController.instance.loadInactiveCoupons(),
          ),
          _DeactivatedTab<protocol.Banner>(
            sourceList: AdminBannerController.instance.inactiveBanners,
            displayName: (b) => b.title,
            leadingIcon: (b) => const Icon(Icons.campaign_outlined),
            onReactivate: (b) async {
              await AdminBannerController.instance.toggleBannerActive(
                b.bannerId!,
                true,
              );
            },
            emptyMessage: 'No deactivated banners',
            isLoading: AdminBannerController.instance.isLoadingInactive,
            onRefresh: () =>
                AdminBannerController.instance.loadInactiveBanners(),
          ),
          _DeactivatedTab<protocol.DeliveryRule>(
            sourceList:
                AdminFreeDeliveryController.instance.inactiveDeliveryRules,
            displayName: (r) => r.name,
            leadingIcon: (r) => const Icon(Icons.local_shipping_outlined),
            onReactivate: (r) async {
              await AdminFreeDeliveryController.instance.toggleDeliveryRule(
                r.ruleId!,
                true,
              );
            },
            emptyMessage: 'No deactivated delivery rules',
            isLoading: AdminFreeDeliveryController.instance.isLoadingInactive,
            onRefresh: () => AdminFreeDeliveryController.instance
                .loadInactiveDeliveryRules(),
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
  final Future<void> Function() onRefresh;

  const _DeactivatedTab({
    required this.sourceList,
    required this.displayName,
    required this.leadingIcon,
    required this.onReactivate,
    required this.emptyMessage,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value && sourceList.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (sourceList.isEmpty) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      emptyMessage,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          padding: EdgeInsets.only(
            left: 14,
            right: 14,
            top: 14,
            bottom: AdminResponsive.bottomInset(context),
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
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Reactivate'),
                ),
              ),
            );
          },
        ),
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
          SnackBar(content: Text('${displayName(item)} reactivated')),
        );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(SnackBar(content: Text('Failed: $e')));
    }
  }
}
