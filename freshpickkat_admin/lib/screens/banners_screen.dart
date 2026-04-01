import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_client/src/protocol/banner.dart' as banner_pkg;
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_banner_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_combo_offer_controller.dart';
import 'package:freshpickkat_admin/services/admin_image_upload_service.dart';
import '../widgets/network_error_widget.dart';

typedef AppBanner = banner_pkg.Banner;

class BannersScreen extends StatefulWidget {
  const BannersScreen({super.key});

  @override
  State<BannersScreen> createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen>
    with AutomaticKeepAliveClientMixin {
  final AdminBannerController _controller = AdminBannerController.instance;
  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBannerDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Banner'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search banners...',
                prefixIcon: const Icon(Icons.search),
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

              if (_controller.isLoading.value && _controller.banners.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final banners = _controller.banners
                  .where(
                    (banner_pkg.Banner b) =>
                        b.title.toLowerCase().contains(_searchQuery),
                  )
                  .toList();

              if (banners.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No banners found',
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return _BannerCard(
                    banner: banner,
                    onToggle: (isActive) => _controller.toggleBannerActive(
                      banner.bannerId ?? '',
                      isActive,
                    ),
                    onEdit: () => _showEditBannerDialog(banner),
                    onDelete: () => _showDeleteConfirmation(banner),
                    onPriorityChange: (priority) => _controller
                        .updateBannerPriority(banner.bannerId ?? '', priority),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddBannerDialog() {
    showDialog(
      context: context,
      builder: (context) => _BannerDialog(
        onSave: (banner) async {
          await _controller.createBanner(banner);
        },
      ),
    );
  }

  void _showEditBannerDialog(banner_pkg.Banner banner) {
    showDialog(
      context: context,
      builder: (context) => _BannerDialog(
        banner: banner,
        onSave: (updated) async {
          await _controller.updateBanner(updated);
        },
      ),
    );
  }

  void _showDeleteConfirmation(banner_pkg.Banner banner) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        var isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Delete Banner'),
            content: Text('Are you sure you want to delete "${banner.title}"?'),
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
                        await _controller.deleteBanner(banner.bannerId ?? '');
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Banner deleted')),
                        );
                      },
                child: isDeleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BannerCard extends StatelessWidget {
  final banner_pkg.Banner banner;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(int) onPriorityChange;

  const _BannerCard({
    required this.banner,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onPriorityChange,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isValid =
        banner.startDate.isBefore(now) && banner.endDate.isAfter(now);
    final placements = banner.screenPlacements
        .split(',')
        .map((s) => s.trim())
        .toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: banner.imageUrl.isNotEmpty
                    ? Image.network(
                        banner.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.image_outlined),
                      )
                    : const Icon(Icons.image_outlined),
              ),
            ),
            title: Text(
              banner.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getTypeLabel(banner.type),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Priority: ${banner.priority}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                    if (isValid && banner.active) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: placements.map((p) {
                    return Chip(
                      label: Text(
                        _getPlacementLabel(p),
                        style: const TextStyle(fontSize: 10),
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'toggle',
                  child: Row(
                    children: [
                      Icon(banner.active ? Icons.toggle_off : Icons.toggle_on),
                      const SizedBox(width: 8),
                      Text(banner.active ? 'Deactivate' : 'Activate'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'priority',
                  child: Row(
                    children: [
                      Icon(Icons.sort),
                      SizedBox(width: 8),
                      Text('Change Priority'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
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
                    onToggle(!banner.active);
                    break;
                  case 'priority':
                    _showPriorityDialog(context);
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${_formatDate(banner.startDate)} - ${_formatDate(banner.endDate)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPriorityDialog(BuildContext context) {
    int selectedPriority = banner.priority;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Priority'),
        content: DropdownButtonFormField<int>(
          initialValue: selectedPriority,
          items: List.generate(10, (i) => i + 1)
              .map(
                (p) => DropdownMenuItem(value: p, child: Text('Priority $p')),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              selectedPriority = value;
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onPriorityChange(selectedPriority);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  String _getTypeLabel(String type) {
    const labels = {
      'offer': 'Offer',
      'category': 'Category',
      'product': 'Product',
      'combo': 'Combo',
      'coupon': 'Coupon',
      'external_link': 'External Link',
    };
    return labels[type] ?? type;
  }

  String _getPlacementLabel(String placement) {
    const labels = {
      'home_top': 'Home Top',
      'home_middle': 'Home Middle',
      'category_page': 'Category',
      'product_page': 'Product',
      'cart_page': 'Cart',
      'checkout_page': 'Checkout',
    };
    return labels[placement] ?? placement;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _BannerDialog extends StatefulWidget {
  final banner_pkg.Banner? banner;
  final Function(banner_pkg.Banner) onSave;

  const _BannerDialog({this.banner, required this.onSave});

  @override
  State<_BannerDialog> createState() => _BannerDialogState();
}

class _BannerDialogState extends State<_BannerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _offerIdController = TextEditingController();
  final _categoryIdController = TextEditingController();
  final _productIdController = TextEditingController();
  final _comboIdController = TextEditingController();
  final _couponCodeController = TextEditingController();
  final _externalUrlController = TextEditingController();

  String _type = 'offer';
  Set<String> _selectedPlacements = {'home_top'};
  int _priority = 1;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _active = true;
  bool _isUploading = false;
  bool _isSubmitting = false;
  String? _lastAutoTitle;

  bool get isEditing => widget.banner != null;

  @override
  void initState() {
    super.initState();
    if (widget.banner != null) {
      _titleController.text = widget.banner!.title;
      _imageUrlController.text = widget.banner!.imageUrl;
      _type = widget.banner!.type;
      _offerIdController.text = widget.banner!.offerId ?? '';
      _categoryIdController.text = widget.banner!.categoryId ?? '';
      _productIdController.text = widget.banner!.productId ?? '';
      _comboIdController.text = widget.banner!.comboId ?? '';
      _couponCodeController.text = widget.banner!.couponCode ?? '';
      _externalUrlController.text = widget.banner!.externalUrl ?? '';
      _selectedPlacements = widget.banner!.screenPlacements
          .split(',')
          .map((s) => s.trim())
          .toSet();
      _priority = widget.banner!.priority;
      _startDate = widget.banner!.startDate;
      _endDate = widget.banner!.endDate;
      _active = widget.banner!.active;
    } else {
      _lastAutoTitle = _buildDefaultTitle();
      _titleController.text = _lastAutoTitle!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _offerIdController.dispose();
    _categoryIdController.dispose();
    _productIdController.dispose();
    _comboIdController.dispose();
    _couponCodeController.dispose();
    _externalUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Banner' : 'Add Banner'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) =>
                      v?.trim().isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                        ),
                        validator: (v) =>
                            v?.trim().isEmpty == true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isUploading ? null : _uploadImage,
                      child: _isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Upload'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _type,
                  decoration: const InputDecoration(labelText: 'Banner Type'),
                  items: const [
                    DropdownMenuItem(value: 'offer', child: Text('Offer')),
                    DropdownMenuItem(
                      value: 'category',
                      child: Text('Category'),
                    ),
                    DropdownMenuItem(value: 'product', child: Text('Product')),
                    DropdownMenuItem(value: 'combo', child: Text('Combo')),
                    DropdownMenuItem(value: 'coupon', child: Text('Coupon')),
                    DropdownMenuItem(
                      value: 'external_link',
                      child: Text('External Link'),
                    ),
                  ],
                  onChanged: (v) => setState(() {
                    _type = v ?? 'offer';
                    _applyAutoTitleIfEmpty();
                  }),
                ),
                const SizedBox(height: 16),
                _buildTargetField(),
                const SizedBox(height: 16),
                const Text(
                  'Screen Placements:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPlacementChip('home_top', 'Home Top'),
                    _buildPlacementChip('home_middle', 'Home Middle'),
                    _buildPlacementChip('category_page', 'Category'),
                    _buildPlacementChip('product_page', 'Product'),
                    _buildPlacementChip('cart_page', 'Cart'),
                    _buildPlacementChip('checkout_page', 'Checkout'),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: List.generate(10, (i) => i + 1)
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text('Priority $p'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _priority = v ?? 1),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectDate(true),
                        icon: const Icon(Icons.calendar_today),
                        label: Text('Start: ${_formatDate(_startDate)}'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectDate(false),
                        icon: const Icon(Icons.calendar_today),
                        label: Text('End: ${_formatDate(_endDate)}'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active'),
                  value: _active,
                  onChanged: (v) => setState(() => _active = v),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _save,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  Widget _buildPlacementChip(String value, String label) {
    return FilterChip(
      label: Text(label),
      selected: _selectedPlacements.contains(value),
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedPlacements.add(value);
          } else {
            _selectedPlacements.remove(value);
          }
          _applyAutoTitleIfEmpty();
        });
      },
    );
  }

  void _applyAutoTitleIfEmpty() {
    if (isEditing) return;
    final currentTitle = _titleController.text.trim();
    if (currentTitle.isNotEmpty &&
        _lastAutoTitle != null &&
        currentTitle != _lastAutoTitle) {
      return;
    }
    final nextTitle = _buildDefaultTitle();
    _lastAutoTitle = nextTitle;
    _titleController.text = nextTitle;
  }

  String _buildDefaultTitle() {
    final typeLabel = switch (_type) {
      'category' => 'Category',
      'product' => 'Product',
      'combo' => 'Combo',
      'coupon' => 'Coupon',
      'external_link' => 'Promo',
      _ => 'Offer',
    };
    final placement = _selectedPlacements.isEmpty
        ? 'Home'
        : _selectedPlacements.first
              .split('_')
              .map(
                (part) => part.isEmpty
                    ? part
                    : '${part[0].toUpperCase()}${part.substring(1)}',
              )
              .join(' ');
    return '$placement $typeLabel Banner';
  }

  Widget _buildTargetField() {
    switch (_type) {
      case 'offer':
        return const SizedBox.shrink();
      case 'category':
        return _buildCategoryDropdown();
      case 'product':
        return _buildProductDropdown();
      case 'combo':
        return _buildComboDropdown();
      case 'coupon':
        return TextFormField(
          controller: _couponCodeController,
          decoration: const InputDecoration(labelText: 'Coupon Code'),
        );
      case 'external_link':
        return TextFormField(
          controller: _externalUrlController,
          decoration: const InputDecoration(labelText: 'External URL'),
          validator: (v) {
            if (_type == 'external_link' && (v?.trim().isEmpty ?? true)) {
              return 'Required';
            }
            return null;
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCategoryDropdown() {
    final categoryController = AdminCategoryController.instance;
    return Obx(() {
      final categories = categoryController.categories;
      return DropdownButtonFormField<String>(
        initialValue: _categoryIdController.text.isNotEmpty
            ? _categoryIdController.text
            : null,
        decoration: const InputDecoration(labelText: 'Category'),
        items: categories
            .map(
              (c) => DropdownMenuItem(
                value: c.categoryName,
                child: Text(c.categoryName),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _categoryIdController.text = v ?? ''),
      );
    });
  }

  Widget _buildProductDropdown() {
    final productController = AdminProductController.instance;
    return Obx(() {
      final products = productController.products.take(50).toList();
      return DropdownButtonFormField<String>(
        initialValue: _productIdController.text.isNotEmpty
            ? _productIdController.text
            : null,
        decoration: const InputDecoration(labelText: 'Product'),
        items: products
            .map(
              (p) => DropdownMenuItem(
                value: p.productId,
                child: Text(p.productName, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _productIdController.text = v ?? ''),
      );
    });
  }

  Widget _buildComboDropdown() {
    final offerController = AdminComboOfferController.instance;
    return Obx(() {
      final combos = offerController.comboOffers;
      return DropdownButtonFormField<String>(
        initialValue: _comboIdController.text.isNotEmpty
            ? _comboIdController.text
            : null,
        decoration: const InputDecoration(labelText: 'Combo'),
        items: combos
            .map(
              (c) => DropdownMenuItem(
                value: c.comboId,
                child: Text(c.name, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _comboIdController.text = v ?? ''),
      );
    });
  }

  Future<void> _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
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

  Future<void> _uploadImage() async {
    setState(() => _isUploading = true);
    try {
      final source = await AdminImageUploadService.pickImageSource(context);
      if (source == null) return;

      final url = await AdminImageUploadService.pickCropAndUploadImage(
        source: source,
        folder: 'banners',
      );
      if (url != null && mounted) {
        setState(() => _imageUrlController.text = url);
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPlacements.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one screen placement')),
      );
      return;
    }

    final banner = banner_pkg.Banner(
      bannerId: widget.banner?.bannerId,
      title: _titleController.text.trim().isEmpty
          ? _buildDefaultTitle()
          : _titleController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      type: _type,
      offerId: _type == 'offer' && _offerIdController.text.isNotEmpty
          ? _offerIdController.text.trim()
          : null,
      categoryId: _type == 'category' && _categoryIdController.text.isNotEmpty
          ? _categoryIdController.text.trim()
          : null,
      productId: _type == 'product' && _productIdController.text.isNotEmpty
          ? _productIdController.text.trim()
          : null,
      comboId: _type == 'combo' && _comboIdController.text.isNotEmpty
          ? _comboIdController.text.trim()
          : null,
      couponCode: _type == 'coupon' && _couponCodeController.text.isNotEmpty
          ? _couponCodeController.text.trim()
          : null,
      externalUrl:
          _type == 'external_link' && _externalUrlController.text.isNotEmpty
          ? _externalUrlController.text.trim()
          : null,
      screenPlacements: _selectedPlacements.join(','),
      priority: _priority,
      startDate: _startDate,
      endDate: _endDate,
      active: _active,
      createdAt: widget.banner?.createdAt ?? DateTime.now(),
    );

    setState(() => _isSubmitting = true);
    try {
      await widget.onSave(banner);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
