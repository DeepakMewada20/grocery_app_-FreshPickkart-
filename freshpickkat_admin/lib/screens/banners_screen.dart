import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_banner_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_combo_offer_controller.dart';
import 'package:freshpickkat_admin/services/admin_image_upload_service.dart';
import 'package:freshpickkat_admin/widgets/product_selection_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/network_error_widget.dart';

typedef AppBanner = client.Banner;

class BannersScreen extends StatefulWidget {
  const BannersScreen({super.key});

  @override
  State<BannersScreen> createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen>
    with AutomaticKeepAliveClientMixin {
  final AdminBannerController _controller = AdminBannerController.instance;
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  BannerMode _filterMode = BannerMode.normal;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
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
        title: const Text('Banners'),
        actions: [
          IconButton(
            onPressed: _controller.loadMore,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBannerDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Banner'),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<BannerMode>(
              segments: const [
                ButtonSegment(
                  value: BannerMode.normal,
                  label: Text('Standard'),
                  icon: Icon(Icons.dashboard_outlined),
                ),
                ButtonSegment(
                  value: BannerMode.homeTopImage,
                  label: Text('Home Top Image'),
                  icon: Icon(Icons.image_outlined),
                ),
              ],
              selected: {_filterMode},
              onSelectionChanged: (newSelection) {
                setState(() => _filterMode = newSelection.first);
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

              final banners = _controller.banners.where((b) {
                final matchesQuery = b.title.toLowerCase().contains(_searchQuery) ||
                    b.screenPlacements.toLowerCase().contains(_searchQuery);
                final isHero = b.screenPlacements.contains('home_top_image');
                final matchesMode =
                    _filterMode == BannerMode.homeTopImage ? isHero : !isHero;
                return matchesQuery && matchesMode;
              }).toList();

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

              return RefreshIndicator(
                onRefresh: () => _controller.loadBanners(force: true),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      banners.length + (_controller.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= banners.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
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
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showAddBannerDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _BannerSheet(
        onSave: (banner) async {
          await _controller.createBanner(banner);
        },
      ),
    );
  }

  void _showEditBannerDialog(client.Banner banner) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _BannerSheet(
        banner: banner,
        onSave: (updated) async {
          await _controller.updateBanner(updated);
        },
      ),
    );
  }

  void _showDeleteConfirmation(client.Banner banner) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        var isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Delete Banner'),
            content: banner.isBaseImage 
              ? const Text('This is a Base Image and cannot be deleted. You must make another banner the Base Image first.')
              : Text('Are you sure you want to delete "${banner.title}"?'),
            actions: [
              TextButton(
                onPressed: isDeleting ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              if (!banner.isBaseImage)
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
                    : const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BannerCard extends StatelessWidget {
  final client.Banner banner;
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
                Builder(builder: (context) {
                  final isHero = banner.screenPlacements.contains('home_top_image');
                  return Row(
                    children: [
                      if (!isHero) ...[
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
                      ],
                      if (isHero) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.indigo[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Products: ${banner.linkedProductIds?.length ?? 0}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[700],
                            ),
                          ),
                        ),
                      ],
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
                      if (banner.isBaseImage) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'BASE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[900],
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }),
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
                if (!banner.screenPlacements.contains('home_top_image'))
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
                if (banner.isBaseImage)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.purple[200]!),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, size: 12, color: Colors.purple),
                        SizedBox(width: 4),
                        Text(
                          'PERMANENT BASE IMAGE',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${_formatDate(banner.startDate)} - ${_formatDate(banner.endDate)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
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
          value: selectedPriority,
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
      'home_top_image': 'Home Top Image',
    };
    return labels[placement] ?? placement;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _BannerSheet extends StatefulWidget {
  final client.Banner? banner;
  final Function(client.Banner) onSave;

  const _BannerSheet({this.banner, required this.onSave,});

  @override
  State<_BannerSheet> createState() => _BannerSheetState();
}

enum BannerMode { normal, homeTopImage }

class _BannerSheetState extends State<_BannerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final productController = AdminProductController.instance;
  
  String? _imageUrl;
  String _type = 'offer';
  String? _offerId;
  String? _categoryId;
  String? _productId;
  String? _comboId;
  String? _couponCode;
  String? _externalUrl;

  List<String> _linkedProductIds = [];
  Set<String> _selectedPlacements = {'home_top'};
  int _priority = 1;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _active = true;
  bool _isBaseImage = false;
  bool _isUploading = false;
  bool _isSubmitting = false;
  String? _lastAutoTitle;

  BannerMode _mode = BannerMode.normal;
 
  bool get isEditing => widget.banner != null;

  @override
  void initState() {
    super.initState();
    if (widget.banner != null) {
      _titleController.text = widget.banner!.title;
      _imageUrl = widget.banner!.imageUrl;
      _type = widget.banner!.type;
      _offerId = widget.banner!.offerId;
      _categoryId = widget.banner!.categoryId;
      _productId = widget.banner!.productId;
      _comboId = widget.banner!.comboId;
      _couponCode = widget.banner!.couponCode;
      _externalUrl = widget.banner!.externalUrl;
      _priority = widget.banner!.priority;
      _startDate = widget.banner!.startDate;
      _endDate = widget.banner!.endDate;
      _active = widget.banner!.active;
      _isBaseImage = widget.banner!.isBaseImage;
      _linkedProductIds = widget.banner!.linkedProductIds ?? [];
      
      final placements = widget.banner!.screenPlacements
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      _selectedPlacements = placements.toSet();
      
      if (_selectedPlacements.contains('home_top_image') && _selectedPlacements.length == 1) {
        _mode = BannerMode.homeTopImage;
      } else {
        _mode = BannerMode.normal;
      }
    } else {
      _lastAutoTitle = _buildDefaultTitle();
      _titleController.text = _lastAutoTitle!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Banner' : 'Add Banner',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SegmentedButton<BannerMode>(
                      segments: const [
                        ButtonSegment(
                          value: BannerMode.normal,
                          label: Text('Standard Banner'),
                          icon: Icon(Icons.dashboard_outlined),
                        ),
                        ButtonSegment(
                          value: BannerMode.homeTopImage,
                          label: Text('Home Top Image'),
                          icon: Icon(Icons.image_outlined),
                        ),
                      ],
                      selected: {_mode},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _mode = newSelection.first;
                          if (_mode == BannerMode.homeTopImage) {
                            _selectedPlacements = {'home_top_image'};
                          } else if (_selectedPlacements.contains('home_top_image') && _selectedPlacements.length == 1) {
                            _selectedPlacements = {'home_top'};
                          }
                          _applyAutoTitleIfEmpty();
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Banner Title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Enter title' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(),
                    if (_mode == BannerMode.normal) ...[
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _type,
                        decoration: const InputDecoration(
                          labelText: 'Banner Type',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'offer', child: Text('Offer')),
                          DropdownMenuItem(value: 'category', child: Text('Category')),
                          DropdownMenuItem(value: 'product', child: Text('Product')),
                          DropdownMenuItem(value: 'combo', child: Text('Combo')),
                          DropdownMenuItem(value: 'coupon', child: Text('Coupon')),
                          DropdownMenuItem(value: 'external_link', child: Text('External Link')),
                        ],
                        onChanged: (v) => setState(() {
                          _type = v ?? 'offer';
                          _applyAutoTitleIfEmpty();
                        }),
                      ),
                      const SizedBox(height: 16),
                      _buildTargetField(),
                    ],
                    if (_mode == BannerMode.homeTopImage) ...[
                      const SizedBox(height: 16),
                      _buildLinkedProductsSection(),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Is Base Image'),
                        subtitle: const Text('Always visible if no festive banner is active'),
                        value: _isBaseImage,
                        onChanged: (v) => setState(() {
                          _isBaseImage = v;
                          if (_isBaseImage) _active = true;
                        }),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                    if (!_isBaseImage) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Scheduling & Status:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(true),
                              child: InputDecorator(
                                decoration:
                                    const InputDecoration(labelText: 'Start Date'),
                                child: Text(_formatDate(_startDate)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(false),
                              child: InputDecorator(
                                decoration:
                                    const InputDecoration(labelText: 'End Date'),
                                child: Text(_formatDate(_endDate)),
                              ),
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
                    if (_mode == BannerMode.normal) ...[
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
                          _buildPlacementChip('home_top', 'Home Top (Scroll)'),
                          _buildPlacementChip('home_middle', 'Home Middle'),
                          _buildPlacementChip('category_page', 'Category'),
                          _buildPlacementChip('product_page', 'Product'),
                          _buildPlacementChip('cart_page', 'Cart'),
                          _buildPlacementChip('checkout_page', 'Checkout'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _priority,
                        decoration: const InputDecoration(
                          labelText: 'Priority',
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(10, (i) => i + 1)
                            .map(
                              (p) =>
                                  DropdownMenuItem(value: p, child: Text('Priority $p')),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _priority = v ?? 1),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEditing ? 'Update Banner' : 'Create Banner',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildLinkedProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Linked Products', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _linkedProductIds.map((id) {
            final product = productController.products.firstWhereOrNull((p) => p.productId == id);
            return Chip(
              avatar: product != null 
                ? CircleAvatar(
                    backgroundImage: NetworkImage(product.imageUrl),
                  )
                : null,
              label: Text(product?.productName ?? id),
              onDeleted: () => setState(() => _linkedProductIds.remove(id)),
            );
          }).toList(),
        ),
        TextButton.icon(
          onPressed: () async {
            final results = await ProductSelectionDialog.showMultiSelectBottomSheet(
              context: context,
              title: 'Select Featured Products',
              initialSelections: _linkedProductIds.map((id) {
                final p = productController.products.firstWhereOrNull((p) => p.productId == id);
                return ProductSelectionResult(
                  product: p ?? Product(
                    productId: id,
                    productName: 'Loading...',
                    category: '',
                    imageUrl: '',
                    price: 0,
                    realPrice: 0,
                    discount: 0,
                    isAvailable: true,
                    addedAt: DateTime.now(),
                    subcategory: [],
                    quantity: '',
                    mostSearch: 0,
                    mostPurchases: 0,
                  ),
                );
              }).toList(),
            );
            if (results != null) {
              setState(() => _linkedProductIds = results.map((r) => r.productId).toList());
            }
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Products'),
        )
      ],
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
      case 'category':
        return _buildCategoryDropdown();
      case 'product':
        return _buildProductPicker();
      case 'combo':
        return _buildComboDropdown();
      case 'coupon':
        return _buildCouponPicker();
      case 'external_link':
        return TextFormField(
          initialValue: _externalUrl,
          decoration: const InputDecoration(labelText: 'External URL'),
          onChanged: (v) => _externalUrl = v,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Banner Image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _isUploading ? null : _uploadImage,
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _isUploading
                ? const Center(child: CircularProgressIndicator())
                : _imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          _imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              size: 40, color: Colors.grey[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to upload image',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
          ),
        ),
        if (_imageUrl != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _isUploading ? null : _uploadImage,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Change Image'),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final categoryController = AdminCategoryController.instance;
    return Obx(() {
      final categories = categoryController.categories;
      return DropdownButtonFormField<String>(
        value: _categoryId,
        decoration: const InputDecoration(labelText: 'Category'),
        items: categories
            .map((c) => DropdownMenuItem(value: c.categoryName, child: Text(c.categoryName)))
            .toList(),
        onChanged: (v) => setState(() => _categoryId = v),
      );
    });
  }

  Widget _buildProductPicker() {
    final product = productController.products.firstWhereOrNull((p) => p.productId == _productId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Target Product', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (product != null)
          Chip(
            avatar: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
            label: Text(product.productName),
            onDeleted: () => setState(() => _productId = null),
          ),
        TextButton.icon(
          onPressed: () async {
            final result = await ProductSelectionDialog.showBottomSheet(
              context: context,
              title: 'Select Target Product',
            );
            if (result != null) {
              setState(() => _productId = result.productId);
            }
          },
          icon: const Icon(Icons.add),
          label: Text(product == null ? 'Select Product' : 'Change Product'),
        ),
      ],
    );
  }

  Widget _buildCouponPicker() {
    final couponController = AdminCouponController.instance;
    return Obx(() {
      final coupons = couponController.coupons;
      final selectedCoupon = coupons.firstWhereOrNull((c) => c.code == _couponCode);
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Coupon', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _couponCode,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.local_offer_outlined),
            ),
            items: coupons.map((c) => DropdownMenuItem(
              value: c.code,
              child: Text('${c.code} (${c.description})'),
            )).toList(),
            onChanged: (v) => setState(() => _couponCode = v),
          ),
          if (selectedCoupon != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Min Amount: ₹${selectedCoupon.minOrderAmount} • Discount: ₹${selectedCoupon.discountValue ?? 0}',
                style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildComboDropdown() {
    final offerController = AdminComboOfferController.instance;
    return Obx(() {
      final combos = offerController.comboOffers;
      return DropdownButtonFormField<String>(
        value: _comboId,
        decoration: const InputDecoration(labelText: 'Combo'),
        items: combos
            .map((c) => DropdownMenuItem(value: c.comboId, child: Text(c.name)))
            .toList(),
        onChanged: (v) => setState(() => _comboId = v),
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

      final isHomeTopImage = _mode == BannerMode.homeTopImage;
      final aspectRatio = isHomeTopImage
          ? const CropAspectRatio(ratioX: 1.3, ratioY: 1)
          : const CropAspectRatio(ratioX: 16, ratioY: 9);

      final url = await AdminImageUploadService.pickCropAndUploadImage(
        source: source,
        folder: 'banners',
        aspectRatio: aspectRatio,
      );
      if (url != null && mounted) {
        setState(() => _imageUrl = url);
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
    if (!_formKey.currentState!.validate() || _imageUrl == null) return;

    if (_selectedPlacements.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one screen placement')),
      );
      return;
    }

    final banner = AppBanner(
      bannerId: widget.banner?.bannerId,
      title: _titleController.text.trim(),
      imageUrl: _imageUrl!,
      type: _type,
      offerId: _offerId,
      categoryId: _categoryId,
      productId: _productId,
      comboId: _comboId,
      couponCode: _couponCode,
      externalUrl: _externalUrl,
      screenPlacements: _selectedPlacements.join(','),
      priority: _priority,
      startDate: _startDate,
      endDate: _endDate,
      active: _active,
      isBaseImage: _isBaseImage,
      linkedProductIds: _linkedProductIds,
      createdAt: widget.banner?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
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
