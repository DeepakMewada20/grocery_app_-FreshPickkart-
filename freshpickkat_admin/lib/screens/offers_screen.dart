import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_bogo_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_category_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_combo_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_free_delivery_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_banner_controller.dart';

import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_coupons_tab.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_offers_tab.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import '../widgets/admin_app_bar.dart';
import 'bogo_product_picker_screen.dart';
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
  final AdminBogoController _bogoController = AdminBogoController.instance;
  final AdminProductController _productController =
      AdminProductController.instance;
  final AdminCategoryOfferController _categoryOfferController =
      AdminCategoryOfferController.instance;
  final AdminComboOfferController _comboOfferController =
      AdminComboOfferController.instance;
  final AdminFreeDeliveryController _freeDeliveryController =
      AdminFreeDeliveryController.instance;
  final AdminBannerController _bannerController =
      AdminBannerController.instance;

  String _couponSearchQuery = '';
  String _offerSearchQuery = '';
  String _offerTypeFilter = 'live';
  String _offerCategoryFilter = 'All';
  bool _isOfferFabExpanded = false;
  final GlobalKey _offersTabFabKey = GlobalKey();

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
    if (_bogoController.bogoOffers.isEmpty &&
        !_bogoController.isLoading.value) {
      futures.add(_bogoController.loadBogoOffers(loadAll: true));
    }
    if (_categoryOfferController.categoryOffers.isEmpty &&
        !_categoryOfferController.isLoading.value) {
      futures.add(_categoryOfferController.loadCategoryOffers(loadAll: true));
    }
    if (_comboOfferController.comboOffers.isEmpty &&
        !_comboOfferController.isLoading.value) {
      futures.add(_comboOfferController.loadComboOffers(loadAll: true));
    }
    if (_freeDeliveryController.deliveryRules.isEmpty &&
        !_freeDeliveryController.isLoading.value) {
      futures.add(_freeDeliveryController.loadDeliveryData(loadAll: true));
    }
    if (_bannerController.banners.isEmpty &&
        !_bannerController.isLoading.value) {
      futures.add(_bannerController.loadBanners(loadAll: true));
    }
    if (futures.isEmpty) return;
    await Future.wait(futures);
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _categoryController.loadCategories(),
      _couponController.loadCoupons(),
      _productController.loadInitial(),
      _bogoController.loadBogoOffers(force: true, loadAll: true),
      _categoryOfferController.loadCategoryOffers(force: true, loadAll: true),
      _comboOfferController.loadComboOffers(force: true, loadAll: true),
      _freeDeliveryController.loadDeliveryData(force: true, loadAll: true),
      _bannerController.loadBanners(force: true, loadAll: true),
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

  Future<void> _openDeleteCouponDialog(Coupon coupon) {
    return showDeleteCouponDialog(
      context: context,
      controller: _couponController,
      coupon: coupon,
    );
  }

  Future<void> _handleOfferCreationAction(String action) async {
    setState(() {
      _isOfferFabExpanded = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final overlayContext = _offersTabFabKey.currentContext ?? context;

      switch (action) {
        case 'bogo':
          final saved = await BogoOfferEditorScreen.show(
            context: overlayContext,
            onSave: (offer) => _bogoController.upsertOffer(offer),
          );
          if (saved == true && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('BOGO offer created successfully')),
            );
          }
          break;
        case 'combo':
          await showAddComboOfferDialog(
            context: overlayContext,
            controller: _comboOfferController,
          );
          break;
        case 'category':
          await showAddCategoryOfferDialog(
            context: overlayContext,
            controller: _categoryOfferController,
          );
          break;
      }
    });
  }

  void _toggleOfferFab() {
    setState(() {
      _isOfferFabExpanded = !_isOfferFabExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          return AnimatedBuilder(
            animation: tabController,
            builder: (context, _) {
              return Scaffold(
                appBar: AdminAppBar(
                  title: TabBar(
                    isScrollable: true,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    tabs: const [
                      Tab(text: 'Dashboard'),
                      Tab(text: 'Offers'),
                      Tab(text: 'Coupons'),
                      Tab(text: 'Delivery'),
                      Tab(text: 'Banners'),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    _OffersDashboardTab(
                      couponController: _couponController,
                      bogoController: _bogoController,
                      categoryOfferController: _categoryOfferController,
                      comboOfferController: _comboOfferController,
                      freeDeliveryController: _freeDeliveryController,
                      bannerController: _bannerController,
                    ),
                    Scaffold(
                      key: _offersTabFabKey,
                      backgroundColor: Colors.transparent,
                      body: Stack(
                        children: [
                          CatalogOffersTab(
                            productController: _productController,
                            categoryController: _categoryController,
                            couponController: _couponController,
                            categoryOfferController: _categoryOfferController,
                            comboOfferController: _comboOfferController,
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
                          if (_isOfferFabExpanded)
                            Positioned.fill(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _toggleOfferFab,
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.02),
                                ),
                              ),
                            ),
                          Positioned(
                            right: 16,
                            bottom: 16,
                            child: _OfferFabMenu(
                              isExpanded: _isOfferFabExpanded,
                              onToggle: _toggleOfferFab,
                              onSelected: _handleOfferCreationAction,
                            ),
                          ),
                        ],
                      ),
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
                      onDeleteCoupon: _openDeleteCouponDialog,
                    ),
                    const FreeDeliveryScreen(),
                    const BannersScreen(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _OffersDashboardTab extends StatelessWidget {
  const _OffersDashboardTab({
    required this.couponController,
    required this.bogoController,
    required this.categoryOfferController,
    required this.comboOfferController,
    required this.freeDeliveryController,
    required this.bannerController,
  });

  final AdminCouponController couponController;
  final AdminBogoController bogoController;
  final AdminCategoryOfferController categoryOfferController;
  final AdminComboOfferController comboOfferController;
  final AdminFreeDeliveryController freeDeliveryController;
  final AdminBannerController bannerController;

  bool _isLive(DateTime startDate, DateTime endDate, bool isActive) {
    final now = DateTime.now();
    return isActive && !startDate.isAfter(now) && !endDate.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final coupons = couponController.coupons;
      final bogoOffers = bogoController.bogoOffers;
      final categoryOffers = categoryOfferController.categoryOffers;
      final comboOffers = comboOfferController.comboOffers;
      final freeDeliveryRules = freeDeliveryController.deliveryRules;
      final banners = bannerController.banners;
      final totalBogo = bogoController.totalCount.value;
      final totalCategoryOffers = categoryOfferController.totalCount.value;
      final totalComboOffers = comboOfferController.totalCount.value;
      final totalDeliveryRules = freeDeliveryController.totalCount.value;
      final totalBanners = bannerController.totalCount.value;

      final liveCoupons = coupons.where((coupon) {
        return _isLive(coupon.startDate, coupon.endDate, coupon.isActive);
      }).length;
      final liveBogo = bogoOffers.where((offer) {
        return _isLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final liveCategory = categoryOffers.where((offer) {
        return _isLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final liveCombo = comboOffers.where((offer) {
        return _isLive(offer.startDate, offer.endDate, offer.isActive);
      }).length;
      final liveDelivery = freeDeliveryRules.where((rule) {
        return _isLive(rule.startDate, rule.endDate, rule.isActive);
      }).length;
      final activeBanners = banners.where((banner) => banner.active).length;
      final liveOfferPrograms = liveBogo + liveCategory + liveCombo;

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const Text(
            'Offers Dashboard',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Offers, banners, and delivery rules ka quick summary',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
          ),
          const SizedBox(height: 16),
          _DashboardCardGrid(
            cards: [
              CatalogStatCard(
                title: 'Coupons',
                value: '${coupons.length}',
                icon: Icons.sell_outlined,
                color: const Color(0xFF315C73),
                breakdown: [
                  CatalogStatBreakdown(
                    label: 'Live',
                    value: '$liveCoupons',
                    color: Colors.green.shade700,
                  ),
                ],
              ),
              CatalogStatCard(
                title: 'Offers',
                value: '${totalBogo + totalCategoryOffers + totalComboOffers}',
                icon: Icons.local_offer_outlined,
                color: const Color(0xFF2F6F4F),
                breakdown: [
                  CatalogStatBreakdown(
                    label: 'Live',
                    value: '$liveOfferPrograms',
                    color: Colors.green.shade700,
                  ),
                ],
              ),
              CatalogStatCard(
                title: 'Delivery Rules',
                value: '$totalDeliveryRules',
                icon: Icons.local_shipping_outlined,
                color: const Color(0xFF7C4D12),
                breakdown: [
                  CatalogStatBreakdown(
                    label: 'Live',
                    value: '$liveDelivery',
                    color: Colors.green.shade700,
                  ),
                ],
              ),
              CatalogStatCard(
                title: 'Banners',
                value: '$totalBanners',
                icon: Icons.image_outlined,
                color: const Color(0xFF6A4C93),
                breakdown: [
                  CatalogStatBreakdown(
                    label: 'Active',
                    value: '$activeBanners',
                    color: Colors.green.shade700,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _DashboardSection(
            title: 'Offer Programs',
            subtitle: 'BOGO, category, aur combo offers ka breakdown',
            cards: [
              CatalogStatCard(
                title: 'BOGO',
                value: '$totalBogo',
                icon: Icons.card_giftcard,
                color: const Color(0xFF2B7A78),
                breakdown: [
                  CatalogStatBreakdown(
                    label: 'Live',
                    value: '$liveBogo',
                    color: Colors.green.shade700,
                  ),
                ],
              ),
              CatalogStatCard(
                title: 'Category',
                value: '$totalCategoryOffers',
                icon: Icons.category_outlined,
                color: const Color(0xFF3A5F6F),
                breakdown: [
                  CatalogStatBreakdown(
                    label: 'Live',
                    value: '$liveCategory',
                    color: Colors.green.shade700,
                  ),
                ],
              ),
              CatalogStatCard(
                title: 'Combo',
                value: '$totalComboOffers',
                icon: Icons.widgets_outlined,
                color: const Color(0xFF4F7D63),
                breakdown: [
                  CatalogStatBreakdown(
                    label: 'Live',
                    value: '$liveCombo',
                    color: Colors.green.shade700,
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _DashboardSection extends StatelessWidget {
  const _DashboardSection({
    required this.title,
    required this.subtitle,
    required this.cards,
  });

  final String title;
  final String subtitle;
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
        const SizedBox(height: 12),
        _DashboardCardGrid(cards: cards),
      ],
    );
  }
}

class _DashboardCardGrid extends StatelessWidget {
  const _DashboardCardGrid({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisCount = 2;
        final itemWidth =
            (constraints.maxWidth - ((crossAxisCount - 1) * 12)) /
            crossAxisCount;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards
              .map((card) => SizedBox(width: itemWidth, child: card))
              .toList(),
        );
      },
    );
  }
}

class _OfferFabMenu extends StatefulWidget {
  const _OfferFabMenu({
    required this.isExpanded,
    required this.onToggle,
    required this.onSelected,
  });

  final bool isExpanded;
  final VoidCallback onToggle;
  final ValueChanged<String> onSelected;

  @override
  State<_OfferFabMenu> createState() => _OfferFabMenuState();
}

class _OfferFabMenuState extends State<_OfferFabMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 180),
      value: widget.isExpanded ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant _OfferFabMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded == oldWidget.isExpanded) return;
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<double> _segment(int index, int total) {
    const segment = 0.56;
    const overlap = 0.24;
    final start = (total - 1 - index) * overlap;
    final end = (start + segment).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
      reverseCurve: Interval(start, end, curve: Curves.easeInCubic),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryAnimation = _segment(2, 3);
    final comboAnimation = _segment(1, 3);
    final bogoAnimation = _segment(0, 3);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IgnorePointer(
          ignoring: _controller.value == 0,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _OfferFabAnimatedAction(
                  animation: categoryAnimation,
                  child: _OfferFabAction(
                    icon: Icons.category_outlined,
                    label: 'Category Offer',
                    color: const Color(0xFF3A5F6F),
                    onTap: () => widget.onSelected('category'),
                  ),
                ),
                SizedBox(height: _controller.value == 0 ? 0 : 10),
                _OfferFabAnimatedAction(
                  animation: comboAnimation,
                  child: _OfferFabAction(
                    icon: Icons.widgets_outlined,
                    label: 'Combo Offer',
                    color: const Color(0xFF4F7D63),
                    onTap: () => widget.onSelected('combo'),
                  ),
                ),
                SizedBox(height: _controller.value == 0 ? 0 : 10),
                _OfferFabAnimatedAction(
                  animation: bogoAnimation,
                  child: _OfferFabAction(
                    icon: Icons.card_giftcard,
                    label: 'BOGO Offer',
                    color: const Color(0xFF2B7A78),
                    onTap: () => widget.onSelected('bogo'),
                  ),
                ),
                SizedBox(height: _controller.value == 0 ? 0 : 12),
              ],
            ),
          ),
        ),
        FloatingActionButton.extended(
          heroTag: 'offers_add_fab',
          onPressed: widget.onToggle,
          backgroundColor: Theme.of(context).colorScheme.primary,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 160),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.86, end: 1).animate(animation),
                  child: child,
                ),
              );
            },
            child: Icon(
              widget.isExpanded ? Icons.close : Icons.add,
              key: ValueKey(widget.isExpanded),
            ),
          ),
          label: Text(widget.isExpanded ? 'Close' : 'Add Offer'),
        ),
      ],
    );
  }
}

class _OfferFabAnimatedAction extends StatelessWidget {
  const _OfferFabAnimatedAction({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.12, 0.18),
          end: Offset.zero,
        ).animate(animation),
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1,
          child: Align(alignment: Alignment.centerRight, child: child),
        ),
      ),
    );
  }
}

class _OfferFabAction extends StatelessWidget {
  const _OfferFabAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Material(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: color.withValues(alpha: 0.12),
                foregroundColor: color,
                child: Icon(icon, size: 18),
              ),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
