import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_bogo_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/screens/bogo_product_picker_screen.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/network_error_widget.dart';

class BogoOffersScreen extends StatefulWidget {
  const BogoOffersScreen({super.key});

  @override
  State<BogoOffersScreen> createState() => _BogoOffersScreenState();
}

class _BogoOffersScreenState extends State<BogoOffersScreen>
    with AutomaticKeepAliveClientMixin {
  final AdminBogoController _controller = AdminBogoController.instance;
  final AdminProductController _productController =
      AdminProductController.instance;
  final ScrollController _scrollController = ScrollController();
  final Map<String, Product> _resolvedTriggerProductsById = {};
  String _searchQuery = '';
  bool _isResolvingTriggerProducts = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_productController.products.isEmpty) {
        _productController.loadInitial();
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients || _searchQuery.isNotEmpty) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      _controller.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AdminAppBar(
        title: const Text('BOGO Offers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.loadBogoOffers(force: true),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: AdminResponsive.bottomInset(context)),
        child: FloatingActionButton.extended(
          onPressed: _showAddBogoScreen,
          icon: const Icon(Icons.add),
          label: Text(
            'Add BOGO Offer',
            overflow: TextOverflow.ellipsis,
            style: AdminTextStyles.button(context),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: AdminResponsive.pagePadding(context).copyWith(bottom: 6.h),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search BOGO offers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_controller.networkController.hasError.value) {
                return NetworkErrorWidget(
                  onRetry: () =>
                      _controller.networkController.retryLastRequest(),
                );
              }

              if (_controller.isLoading.value &&
                  _controller.bogoOffers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              _scheduleTriggerProductResolution(_controller.bogoOffers);

              final bogoOffers = _controller.bogoOffers
                  .where(
                    (o) =>
                        o.offerTitle.toLowerCase().contains(_searchQuery) ||
                        o.triggerProductId.toLowerCase().contains(_searchQuery),
                  )
                  .toList();
              final activeCount = bogoOffers
                  .where((offer) => offer.isActive)
                  .length;
              final totalBogoCount = bogoOffers.length;
              final inactiveCount = totalBogoCount - activeCount;
              final liveCount = bogoOffers.where((offer) {
                final now = DateTime.now();
                return offer.isActive &&
                    !offer.startDate.isAfter(now) &&
                    !offer.endDate.isBefore(now);
              }).length;

              if (bogoOffers.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AdminResponsive.pagePadding(context).copyWith(
                    bottom: AdminResponsive.bottomInset(context) + 96.h,
                  ),
                  children: [
                    SizedBox(height: 96.h),
                    Icon(
                      Icons.card_giftcard,
                      size: 56.r,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No BOGO offers found',
                      textAlign: TextAlign.center,
                      style: AdminTextStyles.sectionTitle(
                        context,
                      ).copyWith(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Tap + to create a new BOGO offer',
                      textAlign: TextAlign.center,
                      style: AdminTextStyles.body(
                        context,
                      ).copyWith(color: Colors.grey[600]),
                    ),
                  ],
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  final pagePadding = AdminResponsive.pagePadding(context);
                  return AdminResponsive.constrainContent(
                    context: context,
                    child: ListView(
                      controller: _scrollController,
                      padding: pagePadding.copyWith(
                        top: 4.h,
                        bottom: AdminResponsive.bottomInset(context) + 96.h,
                      ),
                      children: [
                        Wrap(
                          spacing: 10.w,
                          runSpacing: 10.h,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth < 520
                                  ? constraints.maxWidth
                                  : 260.w.clamp(220.0, 300.0).toDouble(),
                              child: CatalogStatCard(
                                title: 'All BOGO',
                                value: '$totalBogoCount',
                                icon: Icons.card_giftcard,
                                color: const Color(0xFFB45309),
                                breakdown: [
                                  CatalogStatBreakdown(
                                    label: 'Active',
                                    value: '$activeCount',
                                    color: Colors.green.shade700,
                                  ),
                                  CatalogStatBreakdown(
                                    label: 'Inactive',
                                    value: '$inactiveCount',
                                    color: Colors.redAccent.shade200,
                                  ),
                                ],
                                compact: true,
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth < 520
                                  ? constraints.maxWidth
                                  : 220.w.clamp(200.0, 280.0).toDouble(),
                              child: CatalogStatCard(
                                title: 'Live Now',
                                value: '$liveCount',
                                icon: Icons.bolt_rounded,
                                color: const Color(0xFF0F766E),
                                compact: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        ...bogoOffers.map((offer) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: _BogoOfferCard(
                              offer: offer,
                              resolvedTriggerProduct:
                                  _resolvedTriggerProductsById[offer
                                      .triggerProductId],
                              onToggle: (isActive) =>
                                  _toggleBogoOffer(offer, isActive),
                              onEdit: () => _showEditBogoScreen(offer),
                              onDelete: () => _showDeleteConfirmation(offer),
                            ),
                          );
                        }),
                        if (_controller.isLoadingMore.value)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _scheduleTriggerProductResolution(List<BogoOffer> offers) {
    if (_isResolvingTriggerProducts || offers.isEmpty) return;

    final knownIds = {
      for (final product in _productController.products)
        if (product.productId != null) product.productId!,
      ..._resolvedTriggerProductsById.keys,
    };
    final missingIds = offers
        .map((offer) => offer.triggerProductId.trim())
        .where((id) => id.isNotEmpty && !knownIds.contains(id))
        .toSet();

    if (missingIds.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _resolveMissingTriggerProducts(missingIds);
    });
  }

  Future<void> _resolveMissingTriggerProducts(Set<String> missingIds) async {
    if (_isResolvingTriggerProducts || missingIds.isEmpty) return;

    _isResolvingTriggerProducts = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: false,
      );

      final resolved = <String, Product>{};
      String? pageToken;

      do {
        final page = await ServerpodAdminClient().client.product
            .getProductsPage(
              firebaseUid: uid,
              idToken: idToken,
              sortBy: 'name',
              limit: 100,
              pageToken: pageToken,
            );

        for (final product in page.products) {
          final productId = product.productId;
          if (productId != null && missingIds.contains(productId)) {
            resolved[productId] = product;
          }
        }

        if (resolved.length == missingIds.length) break;
        pageToken = page.nextPageToken;
      } while (pageToken != null);

      if (!mounted || resolved.isEmpty) return;
      setState(() {
        _resolvedTriggerProductsById.addAll(resolved);
      });
    } catch (_) {
      // Keep the fallback ID display when product resolution fails.
    } finally {
      _isResolvingTriggerProducts = false;
    }
  }

  Future<void> _toggleBogoOffer(BogoOffer offer, bool isActive) async {
    final updatedOffer = offer.copyWith(isActive: isActive);
    final success = await _controller.upsertOffer(updatedOffer);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('BOGO offer ${isActive ? 'activated' : 'deactivated'}'),
        ),
      );
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error toggling BOGO offer')),
      );
    }
  }

  Future<void> _showAddBogoScreen() async {
    final saved = await BogoOfferEditorScreen.show(
      context: context,
      onSave: (offer) => _controller.upsertOffer(offer),
    );
    if (saved != true || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('BOGO offer created successfully')),
    );
  }

  Future<void> _showEditBogoScreen(BogoOffer offer) async {
    final saved = await BogoOfferEditorScreen.show(
      context: context,
      offer: offer,
      onSave: (updated) => _controller.upsertOffer(updated),
    );
    if (saved != true || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('BOGO offer updated successfully')),
    );
  }

  void _showDeleteConfirmation(BogoOffer offer) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        var isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Delete BOGO Offer'),
            content: ConstrainedBox(
              constraints: AdminResponsive.dialogConstraints(context),
              child: const SingleChildScrollView(
                child: Text('Are you sure you want to delete this BOGO offer?'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isDeleting ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: isDeleting
                    ? null
                    : () async {
                        setDialogState(() => isDeleting = true);
                        final success = await _controller.deleteOffer(
                          offer.triggerProductId,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        if (success && mounted) {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('BOGO offer deleted')),
                          );
                        } else if (!success && mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Error deleting BOGO offer'),
                            ),
                          );
                        }
                      },
                child: isDeleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BogoOfferCard extends StatelessWidget {
  final BogoOffer offer;
  final Product? resolvedTriggerProduct;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BogoOfferCard({
    required this.offer,
    this.resolvedTriggerProduct,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  String _variantLabel(ProductVariant variant) {
    final quantity =
        variant.quantityValue == variant.quantityValue.truncateToDouble()
        ? variant.quantityValue.toInt().toString()
        : variant.quantityValue.toString();
    return '$quantity ${variant.quantityUnit}';
  }

  String _fallbackTitle(BogoOffer offer, ProductVariant? triggerVariant) {
    final variantLabel = triggerVariant != null
        ? _variantLabel(triggerVariant)
        : (offer.triggerBaseQuantity != null && offer.triggerBaseUnit != null)
        ? '${offer.triggerBaseQuantity} ${offer.triggerBaseUnit}'
        : null;
    final buyLabel = variantLabel == null ? 'Buy 1' : 'Buy 1 of $variantLabel';
    return '$buyLabel, Get ${offer.freeProductIds.length} Free';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isValid = offer.startDate.isBefore(now) && offer.endDate.isAfter(now);

    Product? triggerProduct = resolvedTriggerProduct;
    try {
      triggerProduct ??= AdminProductController.instance.products.firstWhere(
        (p) => p.productId == offer.triggerProductId,
      );
    } catch (_) {}
    ProductVariant? triggerVariant;
    if (triggerProduct != null &&
        offer.triggerVariantId != null &&
        offer.triggerVariantId!.trim().isNotEmpty) {
      try {
        triggerVariant = (triggerProduct.variants ?? const <ProductVariant>[])
            .firstWhere(
              (variant) => variant.variantId == offer.triggerVariantId,
            );
      } catch (_) {}
    }

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: AdminResponsive.cardPadding(context),
        minLeadingWidth: 42.w,
        leading: CircleAvatar(
          radius: 20.r,
          backgroundColor: offer.isActive ? Colors.red[100] : Colors.grey[300],
          child: Icon(
            Icons.card_giftcard,
            size: 20.r,
            color: offer.isActive ? Colors.red : Colors.grey,
          ),
        ),
        title: Text(
          offer.offerTitle.trim().isNotEmpty
              ? offer.offerTitle
              : _fallbackTitle(offer, triggerVariant),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AdminTextStyles.cardTitle(context),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (triggerProduct != null)
              Text(
                'Trigger: ${triggerProduct.productName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AdminTextStyles.caption(context),
              )
            else
              Text(
                'Trigger Product ID: ${offer.triggerProductId}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AdminTextStyles.caption(context),
              ),
            SizedBox(height: 6.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'Buy 1 Get ${offer.freeProductIds.length} Free',
                    style: TextStyle(
                      fontSize: 12.sp.clamp(10.0, 13.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                ),
                if (triggerVariant != null ||
                    (offer.triggerBaseQuantity != null &&
                        offer.triggerBaseUnit != null))
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      triggerVariant != null
                          ? 'Variant: ${triggerVariant.quantityValue == triggerVariant.quantityValue.truncateToDouble() ? triggerVariant.quantityValue.toInt() : triggerVariant.quantityValue} ${triggerVariant.quantityUnit}'
                          : 'Variant: ${offer.triggerBaseQuantity} ${offer.triggerBaseUnit}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp.clamp(10.0, 13.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                if (isValid && offer.isActive)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 10.sp.clamp(9.0, 11.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(Icons.toggle_on),
                  SizedBox(width: 8),
                  Text('Toggle Active'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'toggle':
                onToggle(!offer.isActive);
                break;
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
        ),
        onTap: onEdit,
      ),
    );
  }
}
