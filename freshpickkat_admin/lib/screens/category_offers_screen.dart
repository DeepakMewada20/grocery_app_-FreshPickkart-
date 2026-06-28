import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_category_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/network_error_widget.dart';
import '../widgets/shared_dialogs.dart';

Future<void> showAddCategoryOfferDialog({
  required BuildContext context,
  required AdminCategoryOfferController controller,
}) {
  return showModalBottomSheet<void>(
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
      child: _CategoryOfferDialog(
        onSave: (offer) async {
          await controller.createCategoryOffer(offer);
        },
      ),
    ),
  );
}

Future<void> showEditCategoryOfferDialog({
  required BuildContext context,
  required AdminCategoryOfferController controller,
  required CategoryOffer offer,
}) {
  return showModalBottomSheet<void>(
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
      child: _CategoryOfferDialog(
        offer: offer,
        onSave: (updated) async {
          await controller.updateCategoryOffer(updated);
        },
      ),
    ),
  );
}

class _CategoryOffersScreen extends StatefulWidget {
  const _CategoryOffersScreen();

  @override
  State<_CategoryOffersScreen> createState() => _CategoryOffersScreenState();
}

class _CategoryOffersScreenState extends State<_CategoryOffersScreen>
    with AutomaticKeepAliveClientMixin {
  final AdminCategoryOfferController _controller =
      AdminCategoryOfferController.instance;
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
        title: Text('Category Offers'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _controller.loadCategoryOffers(force: true),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddOfferDialog,
        icon: Icon(Icons.add),
        label: Text('Add Category Offer'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search category offers...',
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
                  _controller.categoryOffers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final offers = _controller.categoryOffers
                  .where((o) => o.name.toLowerCase().contains(_searchQuery))
                  .toList();

              if (offers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 64,
                        color: AdminAppTheme.getMutedIconColor(context),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No category offers found',
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
                  return _CategoryOfferCard(
                    offer: offer,
                    onToggle: (isActive) => _controller.toggleCategoryOffer(
                      offer.offerId ?? '',
                      isActive,
                    ),
                    onEdit: () => _showEditOfferDialog(offer),
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

  void _showAddOfferDialog() {
    showAddCategoryOfferDialog(context: context, controller: _controller);
  }

  void _showEditOfferDialog(CategoryOffer offer) {
    showEditCategoryOfferDialog(
      context: context,
      controller: _controller,
      offer: offer,
    );
  }

  Future<void> _showDeleteConfirmation(CategoryOffer offer) async {
    try {
      final result = await _controller.deleteCategoryOffer(offer.offerId ?? '');
      if (!mounted) return;
      if (result == null) {
        showUndoSnackBar(
          context,
          message: 'Category offer permanently deleted',
          onUndo: () {},
        );
      } else if (result == true) {
        showUndoSnackBar(
          context,
          message: 'Category offer deactivated',
          onUndo: () {
            _controller.toggleCategoryOffer(offer.offerId ?? '', true);
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
      }
    }
  }
}

class _CategoryOfferCard extends StatelessWidget {
  final CategoryOffer offer;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryOfferCard({
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
              ? AdminAppTheme.getStatusContainerColor(
                  context,
                  AdminThemeTokens.tonePurple,
                )
              : AdminAppTheme.getBorderColor(context),
          child: Icon(
            Icons.category,
            color: offer.isActive
                ? AdminAppTheme.getPurpleColor(context)
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
            Text('Category: ${offer.categoryName ?? offer.categoryId}'),
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
                        ? '${offer.discountValue.toStringAsFixed(0)}% OFF'
                        : '₹${offer.discountValue.toStringAsFixed(2)} OFF',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: offer.discountType == 'percentage'
                          ? AdminAppTheme.getInfoColor(context)
                          : AdminAppTheme.getWarningColor(context),
                    ),
                  ),
                ),
                if (offer.maxDiscount != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    'Max ₹${offer.maxDiscount!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 10,
                      color: AdminAppTheme.getNeutralColor(context),
                    ),
                  ),
                ],
                if (isValid) ...[
                  const SizedBox(width: 8),
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

class _CategoryOfferDialog extends StatefulWidget {
  final CategoryOffer? offer;
  final Function(CategoryOffer) onSave;

  const _CategoryOfferDialog({this.offer, required this.onSave});

  @override
  State<_CategoryOfferDialog> createState() => _CategoryOfferDialogState();
}

class _CategoryOfferDialogState extends State<_CategoryOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _discountValueController = TextEditingController();
  final _maxDiscountController = TextEditingController();
  final _minOrderController = TextEditingController();

  String _discountType = 'percentage';
  String? _selectedCategoryId;
  int _priority = 0;
  bool _hasExpiry = false;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

  bool get isEditing => widget.offer != null;

  @override
  void initState() {
    super.initState();
    if (widget.offer != null) {
      _descriptionController.text = widget.offer!.description ?? '';
      _discountValueController.text = widget.offer!.discountValue.toString();
      _discountType = widget.offer!.discountType;
      _selectedCategoryId = widget.offer!.categoryId;
      _priority = widget.offer!.priority;
      if (widget.offer!.startDate != null && widget.offer!.endDate != null) {
        _hasExpiry = true;
        _startDate = widget.offer!.startDate;
        _endDate = widget.offer!.endDate;
      }
      if (widget.offer!.maxDiscount != null) {
        _maxDiscountController.text = widget.offer!.maxDiscount.toString();
      }
      if (widget.offer!.minOrderAmount != null) {
        _minOrderController.text = widget.offer!.minOrderAmount.toString();
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _discountValueController.dispose();
    _maxDiscountController.dispose();
    _minOrderController.dispose();
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
                isEditing ? 'Edit Category Offer' : 'Add Category Offer',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Apply a percentage or flat discount to a category.',
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
    final category = _selectedCategoryId?.trim();
    final discountValue = double.tryParse(_discountValueController.text.trim());
    final categoryLabel = (category == null || category.isEmpty)
        ? 'Category'
        : category;
    if (discountValue == null || discountValue <= 0) {
      return '$categoryLabel Offer';
    }
    final discountLabel = _discountType == 'percentage'
        ? '${discountValue.toInt()}% OFF'
        : '\u20b9${discountValue.toInt()} OFF';
    return '$categoryLabel $discountLabel';
  }

  @override
  Widget build(BuildContext context) {
    final categories = AdminCategoryController.instance.categories;

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
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategoryId,
                        isExpanded: true,
                        decoration: InputDecoration(labelText: 'Category'),
                        items: categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c.categoryName,
                                child: Text(
                                  c.categoryName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedCategoryId = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _discountValueController,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                labelText: _discountType == 'percentage'
                                    ? 'Discount %'
                                    : 'Discount (₹)',
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
                                  value: 'percentage',
                                  child: Text('Percentage'),
                                ),
                                DropdownMenuItem(
                                  value: 'flat',
                                  child: Text('Flat'),
                                ),
                              ],
                              onChanged: (v) => setState(
                                () => _discountType = v ?? 'percentage',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _maxDiscountController,
                              decoration: InputDecoration(
                                labelText: 'Max Discount (₹)',
                                hintText: 'Optional',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _minOrderController,
                              decoration: InputDecoration(
                                labelText: 'Min Order (₹)',
                                hintText: 'Optional',
                              ),
                              keyboardType: TextInputType.number,
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

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    final offer = CategoryOffer(
      offerId: widget.offer?.offerId,
      name: _buildOfferName(),
      description: widget.offer?.description,
      categoryId: _selectedCategoryId!,
      categoryName: _selectedCategoryId,
      discountType: _discountType,
      discountValue: double.parse(_discountValueController.text),
      maxDiscount: _maxDiscountController.text.isNotEmpty
          ? double.parse(_maxDiscountController.text)
          : null,
      minOrderAmount: _minOrderController.text.isNotEmpty
          ? double.parse(_minOrderController.text)
          : null,
      startDate: _hasExpiry ? _startDate : null,
      endDate: _hasExpiry ? _endDate : null,
      isActive: widget.offer?.isActive ?? true,
      priority: _priority,
      createdAt: widget.offer?.createdAt ?? DateTime.now(),
    );

    setState(() => _isSubmitting = true);
    try {
      await widget.onSave(offer);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
