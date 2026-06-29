import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/theme/admin_app_theme.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_banner_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_coupon_controller.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_combo_offer_controller.dart';
import 'package:freshpickkat_admin/services/admin_image_upload_service.dart';
import 'package:freshpickkat_admin/services/admin_snackbar_service.dart';
import 'package:freshpickkat_admin/widgets/product_selection_dialog.dart';
import 'package:freshpickkat_admin/utils/admin_responsive.dart';
import 'package:freshpickkat_admin/utils/admin_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import '../widgets/network_error_widget.dart';
import '../widgets/catalog_widgets/catalog_shared_widgets.dart';
import '../widgets/shared_dialogs.dart';

typedef _AppBanner = client.Banner;

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
  _BannerMode? _filterMode;

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBannerDialog,
        icon: Icon(Icons.add),
        label: Text('Add Banner'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AdminResponsive.pageHorizontalPadding(context),
              12.h,
              AdminResponsive.pageHorizontalPadding(context),
              8.h,
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search banners...',
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AdminAppTheme.getBorderColor(context),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AdminAppTheme.getBorderColor(context),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: AdminAppTheme.getSuccessColor(context),
                      ),
                    ),
                    filled: true,
                    fillColor: AdminAppTheme.getInputSurfaceColor(context),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 36.h.clamp(34.0, 42.0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip('All', null),
                      SizedBox(width: 8.w),
                      _buildFilterChip('Standard', _BannerMode.normal),

                      _buildFilterChip('Home Top', _BannerMode.homeTopImage),
                    ],
                  ),
                ),
              ],
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
                final matchesQuery =
                    b.title.toLowerCase().contains(_searchQuery) ||
                    b.screenPlacements.toLowerCase().contains(_searchQuery);

                // Filter by mode if selected
                bool matchesMode = true;
                final isHero = b.screenPlacements.contains('home_top_image');

                if (_filterMode == _BannerMode.homeTopImage) {
                  matchesMode = isHero;
                } else if (_filterMode == _BannerMode.normal) {
                  matchesMode = !isHero;
                }

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
                        color: AdminAppTheme.getMutedIconColor(context),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No banners found',
                        style: TextStyle(
                          color: AdminAppTheme.getTextSecondaryColor(context),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => _controller.loadBanners(force: true),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: AdminResponsive.pagePadding(context).copyWith(
                    bottom: AdminResponsive.bottomInset(context) + 78.h,
                  ),
                  itemCount:
                      banners.length +
                      (_controller.isLoadingMore.value ? 1 : 0),
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
                      onPriorityChange: (priority) =>
                          _controller.updateBannerPriority(
                            banner.bannerId ?? '',
                            priority,
                          ),
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

  void _showAddBannerDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: AdminResponsive.bottomSheetConstraints(context),
      builder: (context) => _BannerSheet(
        onSave: (banner) async {
          await _controller.createBanner(banner);
        },
      ),
    );
  }

  void _showEditBannerDialog(client.Banner banner) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: AdminResponsive.bottomSheetConstraints(context),
      builder: (context) => _BannerSheet(
        banner: banner,
        onSave: (updated) async {
          await _controller.updateBanner(updated);
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmation(client.Banner banner) async {
    if (banner.isBaseImage) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Banner'),
          content: const Text(
            'This is a Base Image and cannot be deleted. You must make another banner the Base Image first.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    try {
      final result = await _controller.deleteBanner(banner.bannerId ?? '');
      if (!mounted) return;
      if (result == null) {
        AdminSnackbarService.showUndo(
          context,
          'Banner permanently deleted',
          onUndo: () {},
        );
      } else if (result == true) {
        AdminSnackbarService.showUndo(
          context,
          'Banner deactivated',
          onUndo: () {
            _controller.toggleBannerActive(banner.bannerId ?? '', true);
          },
        );
      }
    } catch (e) {
      if (mounted) {
        AdminSnackbarService.show(context, 'Failed to delete banner: $e');
      }
    }
  }

  Widget _buildFilterChip(String label, _BannerMode? mode) {
    final isSelected = _filterMode == mode;
    return Theme(
      data: Theme.of(context).copyWith(
        chipTheme: Theme.of(context).chipTheme.copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          side: BorderSide(
            color: isSelected
                ? AdminAppTheme.getSuccessColor(context)
                : AdminAppTheme.getBorderColor(context),
          ),
          backgroundColor: AdminAppTheme.getSurfaceColor(context),
          selectedColor: AdminAppTheme.getSuccessColor(
            context,
          ).withValues(alpha: 0.12),
          labelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? AdminAppTheme.getSuccessColor(context)
                : AdminAppTheme.getTextPrimaryColor(context),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
      ),
      child: CatalogOfferFilterChip(
        label: label,
        selected: isSelected,
        onSelected: () => setState(() => _filterMode = mode),
      ),
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
    final isValid = banner.startDate != null && banner.endDate != null
        ? banner.startDate!.isBefore(now) && banner.endDate!.isAfter(now)
        : true;
    final placements = banner.screenPlacements
        .split(',')
        .map((s) => s.trim())
        .toList();

    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        children: [
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60.r.clamp(52.0, 70.0),
                height: 60.r.clamp(52.0, 70.0),
                color: AdminAppTheme.getSubtleBorderColor(context),
                child: banner.imageUrl.isNotEmpty
                    ? Image.network(
                        banner.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(Icons.image_outlined),
                      )
                    : Icon(Icons.image_outlined),
              ),
            ),
            title: Text(
              banner.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    final isHero = banner.screenPlacements.contains(
                      'home_top_image',
                    );
                    return Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: [
                        if (!isHero) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AdminAppTheme.getInfoContainerColor(
                                context,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getTypeLabel(banner.type),
                              style: TextStyle(
                                fontSize: 12.sp.clamp(10.0, 13.0),
                                fontWeight: FontWeight.bold,
                                color: AdminAppTheme.getInfoColor(context),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AdminAppTheme.getWarningContainerColor(
                                context,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Priority: ${banner.priority}',
                              style: TextStyle(
                                fontSize: 12.sp.clamp(10.0, 13.0),
                                fontWeight: FontWeight.bold,
                                color: AdminAppTheme.getWarningColor(context),
                              ),
                            ),
                          ),
                        ],
                        if (isHero) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AdminAppTheme.getStatusContainerColor(
                                context,
                                AdminThemeTokens.toneIndigo,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Products: ${banner.linkedProductIds?.length ?? 0}',
                              style: TextStyle(
                                fontSize: 12.sp.clamp(10.0, 13.0),
                                fontWeight: FontWeight.bold,
                                color: AdminAppTheme.getIndigoColor(context),
                              ),
                            ),
                          ),
                        ],
                        if (isValid && banner.active) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AdminAppTheme.getSuccessContainerColor(
                                context,
                              ),
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
                        if (banner.isBaseImage) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AdminAppTheme.getStatusContainerColor(
                                context,
                                AdminThemeTokens.tonePurple,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'BASE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AdminAppTheme.getPurpleColor(context),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                SizedBox(height: 4.h),
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
                  PopupMenuItem(
                    value: 'priority',
                    child: Row(
                      children: [
                        Icon(Icons.sort),
                        SizedBox(width: 8),
                        Text('Change Priority'),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
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
            child: Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: [
                if (banner.isBaseImage)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AdminAppTheme.getStatusContainerColor(
                        context,
                        AdminThemeTokens.tonePurple,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AdminAppTheme.getPurpleColor(context),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock,
                          size: 12,
                          color: AdminAppTheme.getPurpleColor(context),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'PERMANENT BASE IMAGE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AdminAppTheme.getPurpleColor(context),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Icon(
                    Icons.calendar_today,
                    size: 14.sp.clamp(12.0, 16.0),
                    color: AdminAppTheme.getTextSecondaryColor(context),
                  ),
                  Text(
                    banner.startDate != null && banner.endDate != null
                        ? '${_formatDate(banner.startDate)} - ${_formatDate(banner.endDate)}'
                        : 'No expiry',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp.clamp(10.0, 13.0),
                      color: AdminAppTheme.getTextSecondaryColor(context),
                    ),
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
        title: Text('Change Priority'),
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
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onPriorityChange(selectedPriority);
            },
            child: Text('Update'),
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'No expiry';
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _BannerSheet extends StatefulWidget {
  final client.Banner? banner;
  final Function(client.Banner) onSave;

  const _BannerSheet({this.banner, required this.onSave});

  @override
  State<_BannerSheet> createState() => _BannerSheetState();
}

enum _BannerMode { normal, homeTopImage }

class _BannerSheetState extends State<_BannerSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
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
  bool _hasExpiry = false;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _active = true;
  bool _isBaseImage = false;
  bool _isUploading = false;
  bool _isSubmitting = false;
  bool _isSaved = false;
  bool _isClosing = false;
  final List<String> _uploadedUrlsInSession = [];
  String? _lastAutoTitle;

  _BannerMode _mode = _BannerMode.normal;

  bool get isEditing => widget.banner != null;

  @override
  void initState() {
    super.initState();
    if (widget.banner != null) {
      _titleController.text = widget.banner!.title;
      _imageUrl = widget.banner!.imageUrl;
      _imageUrlController.text = widget.banner!.imageUrl;
      _type = widget.banner!.type;
      _offerId = widget.banner!.offerId;
      _categoryId = widget.banner!.categoryId;
      _productId = widget.banner!.productId;
      _comboId = widget.banner!.comboId;
      _couponCode = widget.banner!.couponCode;
      _externalUrl = widget.banner!.externalUrl;
      _priority = widget.banner!.priority;
      if (widget.banner!.startDate != null && widget.banner!.endDate != null) {
        _hasExpiry = true;
        _startDate = widget.banner!.startDate;
        _endDate = widget.banner!.endDate;
      }
      _active = widget.banner!.active;
      _isBaseImage = widget.banner!.isBaseImage;
      _linkedProductIds = widget.banner!.linkedProductIds ?? [];

      final placements = widget.banner!.screenPlacements
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      _selectedPlacements = placements.toSet();

      if (_selectedPlacements.contains('home_top_image') &&
          _selectedPlacements.length == 1) {
        _mode = _BannerMode.homeTopImage;
      } else {
        _mode = _BannerMode.normal;
      }
    } else {
      _lastAutoTitle = _buildDefaultTitle();
      _titleController.text = _lastAutoTitle!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _cleanupImages() async {
    for (final url in _uploadedUrlsInSession) {
      await AdminImageUploadService.deleteImage(url);
    }
    _uploadedUrlsInSession.clear();
  }

  Future<void> _onCancel() async {
    if (_isClosing) return;
    if (_isSaved) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isClosing = true);

    if (_uploadedUrlsInSession.isNotEmpty) {
      await _cleanupImages();
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _onCancel();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AdminThemeTokens.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AdminAppTheme.getBorderColor(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Banner' : 'Add Banner',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AdminTextStyles.sectionTitle(context),
                  ),
                  IconButton(onPressed: _onCancel, icon: Icon(Icons.close)),
                ],
              ),
            ),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: AdminResponsive.cardPadding(context),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SegmentedButton<_BannerMode>(
                        showSelectedIcon: !AdminResponsive.isSmallPhone(
                          context,
                        ),
                        segments: const [
                          ButtonSegment(
                            value: _BannerMode.normal,
                            label: Text('Standard'),
                            icon: Icon(Icons.image),
                          ),
                          ButtonSegment(
                            value: _BannerMode.homeTopImage,
                            label: Text('Home Top Image'),
                            icon: Icon(Icons.image_outlined),
                          ),
                        ],
                        selected: {_mode},
                        onSelectionChanged: (newSelection) {
                          setState(() {
                            _mode = newSelection.first;
                            if (_mode == _BannerMode.homeTopImage) {
                              _selectedPlacements = {'home_top_image'};
                            } else if (_selectedPlacements.contains(
                                  'home_top_image',
                                ) &&
                                _selectedPlacements.length == 1) {
                              _selectedPlacements = {'home_top'};
                            }
                            _applyAutoTitleIfEmpty();
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Banner Title',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Enter title' : null,
                      ),
                      SizedBox(height: 16.h),
                      _buildImagePicker(),
                      if (_mode == _BannerMode.normal) ...[
                        SizedBox(height: 16.h),
                        DropdownButtonFormField<String>(
                          initialValue: _type,
                          decoration: InputDecoration(
                            labelText: 'Banner Type',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.category_outlined),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'offer',
                              child: Text('Offer'),
                            ),
                            DropdownMenuItem(
                              value: 'category',
                              child: Text('Category'),
                            ),
                            DropdownMenuItem(
                              value: 'product',
                              child: Text('Product'),
                            ),
                            DropdownMenuItem(
                              value: 'combo',
                              child: Text('Combo'),
                            ),
                            DropdownMenuItem(
                              value: 'coupon',
                              child: Text('Coupon'),
                            ),
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
                        SizedBox(height: 16.h),
                        _buildTargetField(),
                      ],
                      if (_mode == _BannerMode.homeTopImage) ...[
                        SizedBox(height: 16.h),
                        _buildLinkedProductsSection(),
                        SizedBox(height: 16.h),
                        SwitchListTile(
                          title: Text('Is Base Image'),
                          subtitle: Text(
                            'Always visible if no festive banner is active',
                          ),
                          value: _isBaseImage,
                          onChanged: (v) => setState(() {
                            _isBaseImage = v;
                            if (_isBaseImage) _active = true;
                          }),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                      if (!_isBaseImage) ...[
                        SizedBox(height: 16.h),
                        Text(
                          'Scheduling & Status:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.h),
                        SwitchListTile(
                          title: const Text('Set Expiry Dates'),
                          subtitle: Text(
                            _hasExpiry && _startDate != null && _endDate != null
                                ? 'Banner runs from ${_formatDate(_startDate!)} to ${_formatDate(_endDate!)}'
                                : 'Banner never expires until manually deactivated',
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
                          contentPadding: EdgeInsets.zero,
                        ),
                        if (_hasExpiry) ...[
                          SizedBox(height: 6.h),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final startDate = InkWell(
                                onTap: () => _selectDate(true),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Start Date',
                                  ),
                                  child: Text(
                                    _formatDate(_startDate),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                              final endDate = InkWell(
                                onTap: () => _selectDate(false),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'End Date',
                                  ),
                                  child: Text(
                                    _formatDate(_endDate),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                              if (constraints.maxWidth < 420) {
                                return Column(
                                  children: [
                                    startDate,
                                    SizedBox(height: 12.h),
                                    endDate,
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Expanded(child: startDate),
                                  SizedBox(width: 16.w),
                                  Expanded(child: endDate),
                                ],
                              );
                            },
                          ),
                        ],
                        SizedBox(height: 16.h),
                        SwitchListTile(
                          title: Text('Active'),
                          value: _active,
                          onChanged: (v) => setState(() => _active = v),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                      if (_mode == _BannerMode.normal) ...[
                        SizedBox(height: 16.h),
                        Text(
                          'Screen Placements:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildPlacementChip(
                              'home_top',
                              'Home Top (Scroll)',
                            ),
                            _buildPlacementChip('home_middle', 'Home Middle'),
                            _buildPlacementChip('category_page', 'Category'),
                            _buildPlacementChip('product_page', 'Product'),
                            _buildPlacementChip('cart_page', 'Cart'),
                            _buildPlacementChip('checkout_page', 'Checkout'),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        DropdownButtonFormField<int>(
                          initialValue: _priority,
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(),
                          ),
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
                      ],
                      SizedBox(height: 28.h),
                      SizedBox(
                        width: double.infinity,
                        height: 50.h.clamp(46.0, 56.0),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AdminAppTheme.getSuccessColor(
                              context,
                            ),
                            foregroundColor: AdminThemeTokens.white,
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
                                    color: AdminThemeTokens.white,
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
        Text('Linked Products', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _linkedProductIds.map((id) {
            final product = productController.products.firstWhereOrNull(
              (p) => p.productId == id,
            );
            return Chip(
              avatar: product != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(product.imageUrl),
                    )
                  : null,
              label: Text(
                product?.productName ?? id,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onDeleted: () => setState(() => _linkedProductIds.remove(id)),
            );
          }).toList(),
        ),
        TextButton.icon(
          onPressed: () async {
            final results =
                await ProductSelectionDialog.showMultiSelectBottomSheet(
                  context: context,
                  title: 'Select Featured Products',
                  initialSelections: _linkedProductIds.map((id) {
                    final p = productController.products.firstWhereOrNull(
                      (p) => p.productId == id,
                    );
                    return ProductSelectionResult(
                      product:
                          p ??
                          Product(
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
              setState(
                () => _linkedProductIds = results
                    .map((r) => r.productId)
                    .toList(),
              );
            }
          },
          icon: Icon(Icons.add),
          label: Text('Add Products'),
        ),
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
          decoration: InputDecoration(labelText: 'External URL'),
          onChanged: (v) => _externalUrl = v,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildImagePicker() {
    final hasImage =
        _imageUrlController.text.trim().isNotEmpty || _imageUrl != null;
    final displayUrl = _imageUrlController.text.trim().isNotEmpty
        ? _imageUrlController.text.trim()
        : _imageUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Banner Image', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _imageUrlController,
          decoration: InputDecoration(
            labelText: 'Image URL',
            hintText: 'Paste image link here',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.link),
          ),
          onChanged: (value) {
            setState(() {
              if (value.trim().isNotEmpty) {
                _imageUrl = value.trim();
              } else {
                _imageUrl = null;
              }
            });
          },
          validator: (v) {
            final url = _imageUrlController.text.trim();
            if (url.isEmpty && _imageUrl == null) {
              return 'Please provide an image URL or upload an image';
            }
            return null;
          },
        ),
        SizedBox(height: 12.h),
        Center(
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AdminAppTheme.getNeutralColor(context),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        InkWell(
          onTap: _isUploading ? null : _uploadImage,
          child: Container(
            width: double.infinity,
            height: AdminResponsive.isLandscape(context) ? 140.h : 180.h,
            decoration: BoxDecoration(
              color: AdminAppTheme.getSubtleSurfaceColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminAppTheme.getBorderColor(context)),
            ),
            child: _isUploading
                ? const Center(child: CircularProgressIndicator())
                : hasImage
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          displayUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 40.sp.clamp(30.0, 44.0),
                                  color: AdminAppTheme.getMutedIconColor(
                                    context,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Invalid image URL',
                                  style: TextStyle(
                                    color: AdminAppTheme.getTextSecondaryColor(
                                      context,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AdminThemeTokens.white.withValues(
                              alpha: 0.9,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: AdminAppTheme.getErrorColor(context),
                              size: 20.sp,
                            ),
                            onPressed: () {
                              setState(() {
                                _imageUrlController.clear();
                                _imageUrl = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: 40.sp.clamp(30.0, 44.0),
                        color: AdminAppTheme.getMutedIconColor(context),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Tap to upload image',
                        style: TextStyle(
                          color: AdminAppTheme.getTextSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final categoryController = AdminCategoryController.instance;
    return Obx(() {
      final categories = categoryController.categories;
      return DropdownButtonFormField<String>(
        initialValue: _categoryId,
        decoration: InputDecoration(labelText: 'Category'),
        items: categories
            .map(
              (c) => DropdownMenuItem(
                value: c.categoryName,
                child: Text(c.categoryName),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _categoryId = v),
      );
    });
  }

  Widget _buildProductPicker() {
    final product = productController.products.firstWhereOrNull(
      (p) => p.productId == _productId,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Target Product', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),
        if (product != null)
          Chip(
            avatar: CircleAvatar(
              backgroundImage: NetworkImage(product.imageUrl),
            ),
            label: Text(
              product.productName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
          icon: Icon(Icons.add),
          label: Text(product == null ? 'Select Product' : 'Change Product'),
        ),
      ],
    );
  }

  Widget _buildCouponPicker() {
    final couponController = AdminCouponController.instance;
    return Obx(() {
      final coupons = couponController.coupons;
      final selectedCoupon = coupons.firstWhereOrNull(
        (c) => c.code == _couponCode,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Coupon', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          DropdownButtonFormField<String>(
            initialValue: _couponCode,
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.local_offer_outlined),
            ),
            items: coupons
                .map(
                  (c) => DropdownMenuItem(
                    value: c.code,
                    child: Text(
                      '${c.code} (${c.description})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _couponCode = v),
          ),
          if (selectedCoupon != null)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'Min Amount: ₹${selectedCoupon.minOrderAmount} • Discount: ₹${selectedCoupon.discountValue ?? 0}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.sp.clamp(10.0, 13.0),
                  color: AdminAppTheme.getSuccessColor(context),
                  fontWeight: FontWeight.bold,
                ),
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
        initialValue: _comboId,
        isExpanded: true,
        decoration: InputDecoration(labelText: 'Combo'),
        items: combos
            .map(
              (c) => DropdownMenuItem(
                value: c.comboId,
                child: Text(c.name, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
        onChanged: (v) => setState(() => _comboId = v),
      );
    });
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

  Future<void> _uploadImage() async {
    setState(() => _isUploading = true);
    try {
      final source = await AdminImageUploadService.pickImageSource(context);
      if (source == null) return;

      final isHomeTopImage = _mode == _BannerMode.homeTopImage;
      final aspectRatio = isHomeTopImage
          ? const CropAspectRatio(ratioX: 1.2, ratioY: 1)
          : const CropAspectRatio(ratioX: 16, ratioY: 9);

      final url = await AdminImageUploadService.pickCropAndUploadImage(
        source: source,
        folder: 'banners',
        aspectRatio: aspectRatio,
      );
      if (url != null && mounted) {
        setState(() {
          _imageUrl = url;
          _imageUrlController.text = url;
          _uploadedUrlsInSession.add(url);
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No expiry';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _save() async {
    final imageUrl = _imageUrlController.text.trim();
    if (!_formKey.currentState!.validate() || imageUrl.isEmpty) return;

    if (_selectedPlacements.isEmpty) {
      AdminSnackbarService.show(context, 'Select at least one screen placement');
      return;
    }

    final banner = _AppBanner(
      bannerId: widget.banner?.bannerId,
      title: _titleController.text.trim(),
      imageUrl: imageUrl,
      type: _type,
      offerId: _offerId,
      categoryId: _categoryId,
      productId: _productId,
      comboId: _comboId,
      couponCode: _couponCode,
      externalUrl: _externalUrl,
      screenPlacements: _selectedPlacements.join(','),
      priority: _priority,
      startDate: _hasExpiry ? _startDate : null,
      endDate: _hasExpiry ? _endDate : null,
      active: _active,
      isBaseImage: _isBaseImage,
      linkedProductIds: _linkedProductIds,
      createdAt: widget.banner?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() => _isSubmitting = true);
    try {
      await widget.onSave(banner);
      if (mounted) {
        _isSaved = true;
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
