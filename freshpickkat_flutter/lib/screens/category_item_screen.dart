import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/offer_banner.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:freshpickkat_flutter/widgets/initial_loading_screen.dart';
import 'package:get/get.dart';

class CategoryItemsScreen extends StatefulWidget {
  final String categoryName; // e.g., "Vegetables"
  final String subCategoryGroupName; // e.g., "Onion, Potato & Tomato"

  const CategoryItemsScreen({
    super.key,
    required this.categoryName,
    required this.subCategoryGroupName,
  });

  @override
  State<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  final productController = ProductProviderController.instance;
  final categoryController = CategoryProviderController.instance;

  final ScrollController _subCategoryScrollController = ScrollController();
  final ScrollController _itemsScrollController = ScrollController();

  String _selectedSubGroupName = '';
  String _selectedFilterSub = 'All';

  @override
  void initState() {
    super.initState();
    _selectedSubGroupName = widget.subCategoryGroupName;

    // Set initial filters and fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyGroupFilter(_selectedSubGroupName);
      _scrollToSelectedSubGroup();
    });

    _itemsScrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_itemsScrollController.position.pixels >=
            _itemsScrollController.position.maxScrollExtent - 200 &&
        !productController.isLoading.value &&
        productController.isMoreDataAvailable.value) {
      productController.loadMore();
    }
  }

  void _scrollToSelectedSubGroup() {
    // Basic auto-scroll logic for sidebar
    final subGroups = categoryController.subCategories
        .where(
          (sc) =>
              sc.categoryId.trim().toLowerCase() ==
              widget.categoryName.trim().toLowerCase(),
        )
        .toList();

    // If 'All' is selected, no need to auto-scroll to a specific subgroup
    if (_selectedSubGroupName.toLowerCase() == 'all') return;

    final index = subGroups.indexWhere(
      (sub) =>
          sub.subCategoriesName.join(', ').trim().toLowerCase() ==
          _selectedSubGroupName.trim().toLowerCase(),
    );

    if (index != -1) {
      final itemHeight = 100.0; // Approx height of sidebar item
      // +1 because 'All' is at index 0
      _subCategoryScrollController.animateTo(
        (index + 1) * itemHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _applyGroupFilter(String groupName) {
    setState(() {
      _selectedSubGroupName = groupName;
      _selectedFilterSub = 'All';
    });

    if (groupName.toLowerCase() == 'all') {
      productController.setFilters(
        category: widget.categoryName.trim(),
        subcategories: null,
      );
    } else {
      // Parse individual subcategories for the group
      final subList = groupName
          .split(RegExp(r'[,&]'))
          .map((e) => e.trim())
          .toList();

      productController.setFilters(
        category: widget.categoryName.trim(),
        subcategories: subList,
      );
    }
  }

  void _applySubFilter(String sub) {
    setState(() {
      _selectedFilterSub = sub;
    });

    if (_selectedSubGroupName.toLowerCase() == 'all') {
      productController.setFilters(
        category: widget.categoryName.trim(),
        subcategories: null,
      );
    } else {
      productController.setFilters(
        category: widget.categoryName.trim(),
        subcategories: sub.toLowerCase() == 'all'
            ? _selectedSubGroupName
                  .split(RegExp(r'[,&]'))
                  .map((e) => e.trim())
                  .toList()
            : [sub.trim()],
      );
    }
  }

  @override
  void dispose() {
    _subCategoryScrollController.dispose();
    _itemsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Offer Banner
                _buildOfferBanner(),

                // Filter Chips
                _buildFilterSection(),

                // Product Grid
                Expanded(child: _buildProductGrid()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final subGroups = categoryController.subCategories
        .where(
          (sc) =>
              sc.categoryId.trim().toLowerCase() ==
              widget.categoryName.trim().toLowerCase(),
        )
        .toList();

    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: const Border(right: BorderSide(color: Colors.white10)),
      ),
      child: ListView.builder(
        controller: _subCategoryScrollController,
        itemCount: subGroups.length + 1, // +1 for "All"
        itemBuilder: (context, index) {
          if (index == 0) {
            // "All" Sidebar Item
            final isSelected = _selectedSubGroupName.toLowerCase() == 'all';
            return _buildSidebarItem(
              title: "All",
              icon: Icons.grid_view_rounded,
              isSelected: isSelected,
              onTap: () => _applyGroupFilter("All"),
            );
          }

          final subGroup = subGroups[index - 1];
          final groupTitle = subGroup.subCategoriesName.join(', ');
          final isSelected =
              groupTitle.trim().toLowerCase() ==
              _selectedSubGroupName.trim().toLowerCase();

          return _buildSidebarItem(
            title: groupTitle,
            imageUrl: subGroup.subCategoriesUrl,
            isSelected: isSelected,
            onTap: () => _applyGroupFilter(groupTitle),
          );
        },
      ),
    );
  }

  Widget _buildSidebarItem({
    required String title,
    String? imageUrl,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? Color(0xFF1B8A4C) : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image, color: Colors.white24),
                    )
                  : Container(
                      height: 50,
                      width: 50,
                      color: Color(0xFF1B8A4C).withOpacity(0.1),
                      child: Icon(icon, color: Color(0xFF1B8A4C), size: 28),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferBanner() {
    return SizedBox(
      width: double.infinity,
      child: OfferBanner(
        height: 140, // Slightly taller for better visibility
        banners: [
          OfferBannerItem(
            imagePath: 'lib/assets/images/discount.jpg',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    if (_selectedSubGroupName.toLowerCase() == 'all') {
      return const SizedBox.shrink(); // No chips if "All" is selected in sidebar
    }

    // Parse individual subcategories from the group name
    final filters = [
      'All',
      ..._selectedSubGroupName.split(RegExp(r'[,&]')).map((e) => e.trim()),
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected =
              filter.trim().toLowerCase() ==
              _selectedFilterSub.trim().toLowerCase();

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (val) {
                if (val) _applySubFilter(filter);
              },
              backgroundColor: const Color(0xFF1A1A1A),
              selectedColor: Color(0xFF1B8A4C),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 12,
              ),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return Obx(() {
      final networkController = NetworkController.instance;
      final isConnected = networkController.isConnected.value;
      final isLoading = productController.isLoading.value;
      final hasData = productController.hasData;

      if (!isConnected || (isLoading && !hasData)) {
        if (!isConnected) {
          return NetworkErrorWidget(
            message: 'No internet connection',
            onRetry: () async {
              final connected = await networkController.checkConnection();
              if (connected) {
                productController.fetchProducts();
              }
            },
          );
        }
        return ProductGridShimmer(
          itemCount: 6,
          padding: const EdgeInsets.all(12),
        );
      }

      if (productController.allProducts.isEmpty) {
        return const Center(
          child: Text(
            'No products found',
            style: TextStyle(color: Colors.white70),
          ),
        );
      }

      return GridView.builder(
        controller: _itemsScrollController,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio:
              0.46, // Adjusted for 1:1 image + vertical stack details
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount:
            productController.allProducts.length +
            (productController.isMoreDataAvailable.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == productController.allProducts.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 180,
                  child: ProductGridShimmer(itemCount: 2),
                ),
              ),
            );
          }

          final p = productController.allProducts[index];
          return ProductCard(
            product: p,
            onAddPressed: () {},
          );
        },
      );
    });
  }
}
