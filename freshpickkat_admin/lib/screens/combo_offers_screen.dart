import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_combo_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/services/admin_snackbar_service.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/widgets/product_selection_dialog.dart';
import 'package:freshpickkat_admin/widgets/offer_conflict_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/network_error_widget.dart';
import '../widgets/shared_dialogs.dart';

Future<bool?> showAddComboOfferDialog({
  required BuildContext context,
  required AdminComboOfferController controller,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    constraints: AdminResponsive.bottomSheetConstraints(context),
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(
        AdminResponsive.pageHorizontalPadding(context),
        0,
        AdminResponsive.pageHorizontalPadding(context),
        MediaQuery.viewInsetsOf(context).bottom + 12.h,
      ),
      child: _ComboOfferDialog(
        onSave: (offer) async {
          return controller.upsertComboOfferWithConflicts(offer);
        },
      ),
    ),
  );
}

Future<bool?> showEditComboOfferDialog({
  required BuildContext context,
  required AdminComboOfferController controller,
  required ComboOffer offer,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    constraints: AdminResponsive.bottomSheetConstraints(context),
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(
        AdminResponsive.pageHorizontalPadding(context),
        0,
        AdminResponsive.pageHorizontalPadding(context),
        MediaQuery.viewInsetsOf(context).bottom + 12.h,
      ),
      child: _ComboOfferDialog(
        offer: offer,
        onSave: (updated) async {
          return controller.upsertComboOfferWithConflicts(updated);
        },
      ),
    ),
  );
}

class _ComboOffersScreen extends StatefulWidget {
  const _ComboOffersScreen();

  @override
  State<_ComboOffersScreen> createState() => _ComboOffersScreenState();
}

class _ComboOffersScreenState extends State<_ComboOffersScreen>
    with AutomaticKeepAliveClientMixin {
  final AdminComboOfferController _controller =
      AdminComboOfferController.instance;
  final AdminProductController _productController =
      AdminProductController.instance;
  final AdminCategoryController _categoryController =
      AdminCategoryController.instance;
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

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
      if (_categoryController.categories.isEmpty) {
        _categoryController.loadCategories();
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
        title: Text('Combo Offers'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _controller.loadComboOffers(force: true),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddComboDialog,
        icon: Icon(Icons.add),
        label: Text('Add Combo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search combo offers...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
                  _controller.comboOffers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final offers = _controller.comboOffers
                  .where((o) => o.name.toLowerCase().contains(_searchQuery))
                  .toList();

              if (offers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        size: 64,
                        color: AdminAppTheme.getMutedIconColor(context),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No combo offers found',
                        style: TextStyle(
                          color: AdminAppTheme.getTextSecondaryColor(context),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(
                  bottom: AdminResponsive.bottomInset(context),
                ),
                itemCount:
                    offers.length + (_controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= offers.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final offer = offers[index];
                  return _ComboOfferCard(
                    offer: offer,
                    onToggle: (isActive) => _controller.toggleComboOffer(
                      offer.comboId ?? '',
                      isActive,
                    ),
                    onEdit: () => _showEditComboDialog(offer),
                    onDelete: () => _showDeleteConfirmation(offer),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddComboDialog() {
    showAddComboOfferDialog(context: context, controller: _controller);
  }

  void _showEditComboDialog(ComboOffer offer) {
    showEditComboOfferDialog(
      context: context,
      controller: _controller,
      offer: offer,
    );
  }

  Future<void> _showDeleteConfirmation(ComboOffer offer) async {
    try {
      final result = await _controller.deleteComboOffer(offer.comboId ?? '');
      if (!mounted) return;
      if (result == null) {
        AdminSnackbarService.showUndo(
          context,
          'Combo offer permanently deleted',
          onUndo: () {},
        );
      } else if (result == true) {
        AdminSnackbarService.showUndo(
          context,
          'Combo offer deactivated',
          onUndo: () {
            _controller.toggleComboOffer(offer.comboId ?? '', true);
          },
        );
      }
    } catch (e) {
      if (mounted) {
        AdminSnackbarService.show(context, 'Failed to delete: $e');
      }
    }
  }
}

class _ComboOfferCard extends StatelessWidget {
  final ComboOffer offer;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ComboOfferCard({
    required this.offer,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isValid = offer.startDate != null && offer.endDate != null
        ? offer.startDate!.isBefore(now) && offer.endDate!.isAfter(now)
        : true;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: offer.isActive
              ? AdminAppTheme.getSuccessContainerColor(context)
              : AdminAppTheme.getBorderColor(context),
          child: Icon(
            Icons.local_offer,
            color: offer.isActive
                ? AdminAppTheme.getSuccessColor(context)
                : AdminAppTheme.getNeutralColor(context),
          ),
        ),
        title: Text(
          offer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer.comboProducts
                  .map((p) => p.productName ?? p.productId)
                  .join(' + '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: offer.discountType == 'percentage'
                        ? AdminAppTheme.getInfoContainerColor(context)
                        : AdminAppTheme.getWarningContainerColor(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    offer.discountType == 'percentage'
                        ? 'MORE ${offer.discountValue.toStringAsFixed(0)}% OFF'
                        : 'MORE ₹${offer.discountValue.toStringAsFixed(2)} OFF',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: offer.discountType == 'percentage'
                          ? AdminAppTheme.getInfoColor(context)
                          : AdminAppTheme.getWarningColor(context),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (isValid)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AdminAppTheme.getSuccessContainerColor(context),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AdminAppTheme.getSuccessColor(context),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(
                    offer.isActive
                        ? Icons.toggle_on
                        : Icons.toggle_off_outlined,
                    color: offer.isActive
                        ? AdminAppTheme.getSuccessColor(context)
                        : AdminAppTheme.getErrorColor(context),
                  ),
                  SizedBox(width: 8),
                  Text(offer.isActive ? 'Active' : 'Inactive'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: AdminAppTheme.getErrorColor(context),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: AdminAppTheme.getErrorColor(context),
                    ),
                  ),
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

class _ComboOfferDialog extends StatefulWidget {
  final ComboOffer? offer;
  final Future<OfferMutationResult> Function(ComboOffer) onSave;

  const _ComboOfferDialog({this.offer, required this.onSave});

  @override
  State<_ComboOfferDialog> createState() => _ComboOfferDialogState();
}

class _ComboOfferDialogState extends State<_ComboOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _discountValueController = TextEditingController();
  final Map<String, ImageProvider> _imageProviders = {};

  String _discountType = 'flat';
  int _priority = 0;
  bool _hasExpiry = false;
  DateTime? _startDate;
  DateTime? _endDate;
  final List<_SelectedProduct> _products = [];
  bool _isSubmitting = false;

  bool get isEditing => widget.offer != null;

  @override
  void initState() {
    super.initState();
    if (widget.offer != null) {
      _descriptionController.text = widget.offer!.description ?? '';
      _discountValueController.text = widget.offer!.discountValue.toString();
      _discountType = widget.offer!.discountType;
      _priority = widget.offer!.priority;
      if (widget.offer!.startDate != null && widget.offer!.endDate != null) {
        _hasExpiry = true;
        _startDate = widget.offer!.startDate;
        _endDate = widget.offer!.endDate;
      }
      _products.addAll(
        widget.offer!.comboProducts.map(
          (p) => _SelectedProduct(
            productId: p.productId,
            productName: p.productName,
            variantId: p.variantId,
            quantity: p.quantity,
          ),
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _hydrateSelectedProducts();
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _discountValueController.dispose();
    super.dispose();
  }

  Widget _buildSheetHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Combo Offer' : 'Add Combo Offer',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Bundle products together and apply a single discount.',
                style: TextStyle(
                  color: AdminAppTheme.getTextSecondaryColor(context),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildDateCard({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: _isSubmitting ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AdminThemeTokens.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AdminAppTheme.getBorderColor(context)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AdminAppTheme.getSuccessColor(
                  context,
                ).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_today,
                size: 18,
                color: AdminAppTheme.getSuccessColor(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AdminAppTheme.getTextSecondaryColor(context),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatDate(value),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildOfferName() {
    final names = _products
        .map((product) => product.productName?.trim() ?? '')
        .where((name) => name.isNotEmpty)
        .take(3)
        .toList();
    final baseLabel = switch (names.length) {
      >= 2 => '${names.join(' + ')} Combo',
      1 => '${names.first} Combo',
      _ => 'Combo Offer',
    };
    final discountValue = double.tryParse(_discountValueController.text.trim());
    if (discountValue == null || discountValue <= 0) {
      return baseLabel;
    }
    final discountLabel = _discountType == 'percentage'
        ? 'more ${discountValue.toInt()}% OFF'
        : 'more \u20b9${discountValue.toInt()} OFF';
    return '$baseLabel • $discountLabel';
  }

  String _formatMoney(double value) =>
      '₹${value == value.truncateToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(2)}';

  String _formatVariantLabel(ProductVariant variant) {
    final quantity = variant.quantityValue % 1 == 0
        ? variant.quantityValue.toInt().toString()
        : variant.quantityValue.toString();
    final description = variant.quantityDescription?.trim();
    if (description == null || description.isEmpty) {
      return '$quantity ${variant.quantityUnit}';
    }
    return '$quantity ${variant.quantityUnit} ($description)';
  }

  String? _buildTotalQuantityLabel(_SelectedProduct product) {
    final variantId = product.variantId;
    if (variantId == null || variantId.isEmpty) {
      return null;
    }

    final selectionProduct = _buildSelectionProduct(product);
    final variant = _resolveVariant(selectionProduct, variantId);
    if (variant == null) return null;

    final totalValue = variant.quantityValue * product.quantity;
    final normalized = _normalizeQuantity(totalValue, variant.quantityUnit);
    final singleLabel = _formatQuantityValue(
      variant.quantityValue,
      variant.quantityUnit,
    );
    final totalLabel = _formatQuantityValue(normalized.value, normalized.unit);
    return '$singleLabel × ${product.quantity} = $totalLabel';
  }

  ({double value, String unit}) _normalizeQuantity(double value, String unit) {
    final normalizedUnit = unit.trim().toLowerCase();
    if (normalizedUnit == 'gm' && value >= 1000) {
      return (value: value / 1000, unit: 'kg');
    }
    if (normalizedUnit == 'ml' && value >= 1000) {
      return (value: value / 1000, unit: 'ltr');
    }
    return (value: value, unit: unit);
  }

  String _formatQuantityValue(double value, String unit) {
    final formatted = value % 1 == 0
        ? value.toInt().toString()
        : value.toString();
    return '$formatted $unit';
  }

  ProductVariant? _resolveVariant(Product product, String? variantId) {
    final variants = product.variants ?? const <ProductVariant>[];
    if (variantId == null || variantId.isEmpty) {
      return variants.isEmpty ? null : variants.first;
    }
    for (final variant in variants) {
      if (variant.variantId == variantId) return variant;
    }
    return null;
  }

  ImageProvider? _imageProviderFor(String? imageUrl) {
    if (imageUrl == null || imageUrl.trim().isEmpty) return null;
    return _imageProviders.putIfAbsent(
      imageUrl,
      () => ResizeImage(NetworkImage(imageUrl), width: 160, height: 160),
    );
  }

  Future<void> _cacheImageIfNeeded(String? imageUrl) async {
    final provider = _imageProviderFor(imageUrl);
    if (provider == null || !mounted) return;
    await precacheImage(provider, context);
  }

  Product _buildSelectionProduct(_SelectedProduct selected) {
    final productController = AdminProductController.instance;
    final cached = productController.products.firstWhereOrNull(
      (item) => item.productId == selected.productId,
    );
    if (cached != null) return cached;
    return Product(
      productId: selected.productId,
      productName: selected.productName ?? '',
      category: '',
      imageUrl: selected.imageUrl ?? '',
      price: selected.unitPrice,
      realPrice: selected.unitMrp,
      discount: 0,
      isAvailable: true,
      addedAt: DateTime.now(),
      subcategory: const [],
      quantity: selected.variantLabel ?? '',
      mostSearch: 0,
      mostPurchases: 0,
      variants: selected.variantId == null
          ? null
          : [
              ProductVariant(
                variantId: selected.variantId!,
                quantityValue: 1,
                quantityUnit: '',
                quantityDescription: selected.variantLabel,
                price: selected.unitPrice,
                realPrice: selected.unitMrp,
                isAvailable: true,
              ),
            ],
    );
  }

  Future<void> _hydrateSelectedProducts() async {
    final productController = AdminProductController.instance;
    if (productController.products.isEmpty) {
      await productController.loadInitial();
    }
    if (!mounted) return;

    setState(() {
      for (var index = 0; index < _products.length; index++) {
        final selected = _products[index];
        final product = productController.products.firstWhereOrNull(
          (item) => item.productId == selected.productId,
        );
        if (product == null) continue;
        final variant = _resolveVariant(product, selected.variantId);
        _cacheImageIfNeeded(product.imageUrl);
        _products[index] = _SelectedProduct(
          productId: selected.productId,
          productName: product.productName,
          imageUrl: product.imageUrl,
          variantId: variant?.variantId ?? selected.variantId,
          variantLabel: variant == null
              ? product.quantity
              : _formatVariantLabel(variant),
          unitPrice: variant?.price ?? product.price,
          unitMrp: variant?.realPrice ?? product.realPrice,
          quantity: selected.quantity,
        );
      }
    });
  }

  double get _productsCurrentTotal => _products.fold(
    0,
    (sum, product) => sum + (product.unitPrice * product.quantity),
  );

  double get _productsMrpTotal => _products.fold(
    0,
    (sum, product) => sum + (product.unitMrp * product.quantity),
  );

  double get _comboFinalTotal {
    final baseTotal = _productsCurrentTotal;
    final discountValue =
        double.tryParse(_discountValueController.text.trim()) ?? 0;
    if (discountValue <= 0) return baseTotal;
    if (_discountType == 'percentage') {
      return (baseTotal * (1 - (discountValue / 100))).clamp(
        0,
        double.infinity,
      );
    }
    return (baseTotal - discountValue).clamp(0, double.infinity);
  }

  Widget _buildPricingSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AdminAppTheme.getInputSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AdminAppTheme.getBorderColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Combo Pricing',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          _buildPriceRow('Products MRP Total', _formatMoney(_productsMrpTotal)),
          const SizedBox(height: 6),
          _buildPriceRow(
            'Products Selling Total',
            _formatMoney(_productsCurrentTotal),
          ),
          const SizedBox(height: 6),
          _buildPriceRow(
            'Combo Final Price',
            _formatMoney(_comboFinalTotal),
            emphasize: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool emphasize = false}) {
    final style = TextStyle(
      fontSize: emphasize ? 15 : 13,
      fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
      color: emphasize
          ? AdminAppTheme.getSuccessColor(context)
          : AdminAppTheme.getTextPrimaryColor(context),
    );
    return Row(
      children: [
        Expanded(child: Text(label, style: style)),
        Text(value, style: style),
      ],
    );
  }

  Widget _buildQuantityStepper(_SelectedProduct product) {
    return Container(
      decoration: BoxDecoration(
        color: AdminAppTheme.getSubtleSurfaceColor(context),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AdminAppTheme.getBorderColor(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _isSubmitting
                ? null
                : () {
                    if (product.quantity <= 1) return;
                    setState(() {
                      product.quantity -= 1;
                    });
                  },
            icon: Icon(Icons.remove, size: 18),
          ),
          Text(
            '${product.quantity}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: _isSubmitting
                ? null
                : () {
                    setState(() {
                      product.quantity += 1;
                    });
                  },
            icon: Icon(Icons.add, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedProductCard(_SelectedProduct product, int index) {
    final totalQuantityLabel = _buildTotalQuantityLabel(product);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AdminThemeTokens.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AdminAppTheme.getBorderColor(context)),
        boxShadow: [
          BoxShadow(
            color: AdminAppTheme.getScrimShadowColor(context, alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 58,
                    height: 58,
                    child: _imageProviderFor(product.imageUrl) != null
                        ? Image(
                            image: _imageProviderFor(product.imageUrl)!,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: AdminAppTheme.getSubtleBorderColor(
                                    context,
                                  ),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: AdminAppTheme.getNeutralColor(
                                      context,
                                    ),
                                  ),
                                ),
                          )
                        : Container(
                            color: AdminAppTheme.getSubtleBorderColor(context),
                            child: Icon(
                              Icons.image,
                              color: AdminAppTheme.getNeutralColor(context),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName ?? product.productId,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (product.variantLabel != null &&
                          product.variantLabel!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          product.variantLabel!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AdminAppTheme.getTextSecondaryColor(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (totalQuantityLabel != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          totalQuantityLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AdminAppTheme.getSuccessColor(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: _isSubmitting
                      ? null
                      : () => setState(() => _products.removeAt(index)),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AdminAppTheme.getErrorContainerColor(context),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: AdminAppTheme.getErrorColor(context),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: AdminAppTheme.getInputSurfaceColor(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AdminAppTheme.getSubtleBorderColor(context),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Each Price',
                          style: TextStyle(
                            fontSize: 11,
                            color: AdminAppTheme.getTextSecondaryColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatMoney(product.unitPrice),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price',
                          style: TextStyle(
                            fontSize: 11,
                            color: AdminAppTheme.getTextSecondaryColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatMoney(product.unitPrice * product.quantity),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  _buildQuantityStepper(product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight =
        MediaQuery.sizeOf(context).height *
        (AdminResponsive.isLandscape(context) ? 0.92 : 0.82);
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: sheetHeight,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                child: _buildSheetHeader(),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AdminAppTheme.getSuccessContainerColor(
                            context,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AdminAppTheme.getSuccessContainerColor(
                              context,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Offer Name',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AdminAppTheme.getSuccessColor(context),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _buildOfferName(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Products in Combo',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: _isSubmitting ? null : _addProduct,
                            icon: Icon(Icons.add),
                            label: Text('Add Product'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_products.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AdminAppTheme.getInputSurfaceColor(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AdminAppTheme.getBorderColor(context),
                            ),
                          ),
                          child: Text('No products added yet.'),
                        )
                      else
                        ..._products.asMap().entries.map((entry) {
                          final index = entry.key;
                          final product = entry.value;
                          return _buildSelectedProductCard(product, index);
                        }),
                      if (_products.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        _buildPricingSummaryCard(),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _discountValueController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: 'Discount Value',
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v?.trim().isEmpty == true) {
                                  return 'Required';
                                }
                                if (double.tryParse(v!) == null) {
                                  return 'Invalid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _discountType,
                              isExpanded: true,
                              decoration: InputDecoration(labelText: 'Type'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'flat',
                                  child: Text('Flat'),
                                ),
                                DropdownMenuItem(
                                  value: 'percentage',
                                  child: Text('Percentage'),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _discountType = v ?? 'flat'),
                            ),
                          ),
                        ],
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Set Expiry Dates'),
                        subtitle: Text(
                          _hasExpiry && _startDate != null && _endDate != null
                              ? 'Offer runs from ${_formatDate(_startDate!)} to ${_formatDate(_endDate!)}'
                              : 'Offer never expires until manually deactivated',
                          style: const TextStyle(fontSize: 12),
                        ),
                        value: _hasExpiry,
                        onChanged: _isSubmitting
                            ? null
                            : (v) {
                                setState(() {
                                  _hasExpiry = v;
                                  if (v) {
                                    _startDate ??= DateTime.now();
                                    _endDate ??= DateTime.now().add(const Duration(days: 30));
                                  }
                                });
                              },
                      ),
                      if (_hasExpiry) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateCard(
                                label: 'Start Date',
                                value: _startDate,
                                onTap: () => _selectDate(true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDateCard(
                                label: 'End Date',
                                value: _endDate,
                                onTap: () => _selectDate(false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _isSubmitting ? null : _save,
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(isEditing ? 'Update' : 'Create'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProduct() async {
    final productController = AdminProductController.instance;
    if (productController.products.isEmpty) {
      await productController.loadInitial();
    }

    if (!mounted) return;

    final selectedProducts =
        await ProductSelectionDialog.showMultiSelectBottomSheet(
          context: context,
          title: 'Select Products',
          initialSelections: _products
              .map(
                (selected) => ProductSelectionResult(
                  product: _buildSelectionProduct(selected),
                  variant: _buildSelectionProduct(
                    selected,
                  ).variants?.firstOrNull,
                ),
              )
              .toList(),
        );

    if (selectedProducts != null) {
      for (final selection in selectedProducts) {
        await _cacheImageIfNeeded(selection.product.imageUrl);
      }
      final existingByKey = {
        for (final product in _products)
          '${product.productId}::${product.variantId ?? 'default'}': product,
      };
      setState(() {
        _products
          ..clear()
          ..addAll(
            selectedProducts.map((selection) {
              final variant =
                  selection.variant ?? _resolveVariant(selection.product, null);
              final key =
                  '${selection.product.productId ?? ''}::${variant?.variantId ?? 'default'}';
              final existing = existingByKey[key];
              return _SelectedProduct(
                productId: selection.product.productId ?? '',
                productName: selection.product.productName,
                imageUrl: selection.product.imageUrl,
                variantId: variant?.variantId,
                variantLabel: variant == null
                    ? selection.product.quantity
                    : _formatVariantLabel(variant),
                unitPrice: variant?.price ?? selection.product.price,
                unitMrp: variant?.realPrice ?? selection.product.realPrice,
                quantity: existing?.quantity ?? 1,
              );
            }),
          );
      });
    }
  }

  Future<void> _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? _endDate ?? DateTime.now())
          : (_endDate ?? _startDate ?? DateTime.now().add(const Duration(days: 30))),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No expiry';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_products.length < 2) {
      AdminSnackbarService.show(
        context,
        'At least 2 products are required for a combo offer',
      );
      return;
    }

    final offer = ComboOffer(
      comboId: widget.offer?.comboId,
      name: _buildOfferName(),
      description: widget.offer?.description,
      comboProducts: _products
          .map(
            (p) => ComboProductItem(
              productId: p.productId,
              productName: p.productName,
              quantity: p.quantity,
              variantId: p.variantId,
            ),
          )
          .toList(),
      discountType: _discountType,
      discountValue: double.parse(_discountValueController.text),
      minQuantityPerProduct: 1,
      startDate: _hasExpiry ? _startDate : null,
      endDate: _hasExpiry ? _endDate : null,
      isActive: widget.offer?.isActive ?? true,
      priority: _priority,
      maxUsagePerUser: 0,
      usageCount: 0,
      createdAt: widget.offer?.createdAt ?? DateTime.now(),
    );

    setState(() => _isSubmitting = true);
    try {
      final result = await widget.onSave(offer);
      if (!mounted) return;
      if (result.success) {
        Navigator.pop(context, true);
        return;
      }

      final conflict = result.conflict;
      if (conflict != null && conflict.hasConflict && mounted) {
        final shouldSelectNew = await showOfferConflictDialog(
          context: context,
          conflict: conflict,
        );
        if (!mounted) return;
        if (shouldSelectNew == true) {
          Navigator.pop(context, false);
        }
        return;
      }

      AdminSnackbarService.show(
        context,
        result.message ?? 'Error saving combo offer',
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _SelectedProduct {
  final String productId;
  final String? productName;
  final String? imageUrl;
  final String? variantId;
  final String? variantLabel;
  final double unitPrice;
  final double unitMrp;
  int quantity;

  _SelectedProduct({
    required this.productId,
    this.productName,
    this.imageUrl,
    this.variantId,
    this.variantLabel,
    this.unitPrice = 0,
    this.unitMrp = 0,
    this.quantity = 1,
  });
}
