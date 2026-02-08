import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:freshpickkat_flutter/widgets/item_selection_girdviwe.dart'; // Add to pubspec.yaml

class CategoryItemsScreen extends StatefulWidget {
  final String categoryName; // e.g., "Fruits"
  final String subCategoryName; // e.g., "Apple & Pear"

  const CategoryItemsScreen({
    super.key,
    required this.categoryName,
    required this.subCategoryName,
  });

  @override
  State<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  final ScrollController _subCategoryScrollController = ScrollController();
  final ScrollController _itemsScrollController = ScrollController();

  int _selectedSubCategoryIndex = 0;
  String _selectedFilter = 'All'; // 'All', 'Apple', 'Pear', etc.
  bool _showStickyHeader = false;

  // Sample sub-categories data
  final List<SubCategory> subCategories = [
    SubCategory(
      name: 'All',
      imageUrl: 'lib/assets/images/Wellness+&+Health_1729062880.png',
    ),
    SubCategory(
      name: 'Apple & Pear',
      imageUrl: 'lib/assets/images/Wellness+&+Health_1729062880.png',
    ),
    SubCategory(
      name: 'Banana, Papaya & Pineapple',
      imageUrl: 'lib/assets/images/Wellness+&+Health_1729062880.png',
    ),
    SubCategory(
      name: 'Coconut & Dates',
      imageUrl: 'lib/assets/images/Wellness+&+Health_1729062880.png',
    ),
    SubCategory(
      name: 'Citrus & Pomegranate',
      imageUrl: 'lib/assets/images/Wellness+&+Health_1729062880.png',
    ),
    SubCategory(
      name: 'Kiwi & Avocado',
      imageUrl: 'lib/assets/images/Wellness+&+Health_1729062880.png',
    ),
    SubCategory(
      name: 'Berries, Guava & Sapota',
      imageUrl: 'lib/assets/images/Wellness+&+Health_1729062880.png',
    ),
  ];

  // Sample banner data
  final List<String> bannerImages = [
    'lib/assets/images/discount.jpg',
    'lib/assets/images/discount.jpg',
    'lib/assets/images/discount.jpg',
    'lib/assets/images/discount.jpg',
  ];

  // Sample filter buttons (for Apple & Pear category)
  final List<String> filterOptions = ['All', 'Apple', 'Pear'];

  @override
  void initState() {
    super.initState();
    _itemsScrollController.addListener(_onItemsScroll);
  }

  void _onItemsScroll() {
    // Check if banner has scrolled past the app bar
    final offset = _itemsScrollController.offset;
    final shouldShowSticky = offset > 200; // Adjust based on banner height

    if (shouldShowSticky != _showStickyHeader) {
      setState(() {
        _showStickyHeader = shouldShowSticky;
      });
    }
  }

  void _onSubCategoryTap(int index) {
    setState(() {
      _selectedSubCategoryIndex = index;
      _selectedFilter = 'All'; // Reset filter when changing sub-category
    });

    // Scroll to top of items
    _itemsScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onFilterTap(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
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
      body: Stack(
        children: [
          Row(
            children: [
              // Left side - Sub-categories list
              _buildSubCategoriesList(),

              // Right side - Banner + Items
              Expanded(
                child: Stack(
                  children: [
                    _buildItemsSection(),

                    // Sticky filter header (appears when scrolling)
                    if (_showStickyHeader) _buildStickyFilterHeader(),
                  ],
                ),
              ),
            ],
          ),

          // AppBar overlay
          _buildAppBar(),

          // Blur effect below AppBar
          // _buildBlurEffect(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBlurEffect() {
    return Positioned(
      top: kToolbarHeight + MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoriesList() {
    return Container(
      width: 90,
      color: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          SizedBox(height: kToolbarHeight + MediaQuery.of(context).padding.top),
          Expanded(
            child: ListView.builder(
              controller: _subCategoryScrollController,
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedSubCategoryIndex == index;
                final subCategory = subCategories[index];

                return GestureDetector(
                  onTap: () => _onSubCategoryTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0A0A0A)
                          : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                        left: BorderSide(
                          color: isSelected
                              ? const Color(0xFF2196F3)
                              : Colors.transparent,
                          width: 6,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              subCategory.imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.white54,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Text(
                          subCategory.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      color: const Color(0xFF0A0A0A),
      child: ListView(
        controller: _itemsScrollController,
        padding: EdgeInsets.only(
          top: kToolbarHeight + MediaQuery.of(context).padding.top + 40,
        ),
        children: [
          // Animated banner carousel
          _buildBannerCarousel(),

          const SizedBox(height: 16),

          // Filter chips/buttons
          _buildFilterSection(),

          const SizedBox(height: 16),

          // Items grid
          _buildItemsGrid(),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: bannerImages.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nutrient Rich\nBananas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Order Now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subCategories[_selectedSubCategoryIndex].name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filterOptions.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) _onFilterTap(filter);
                    },
                    backgroundColor: const Color(0xFF1A1A1A),
                    selectedColor: const Color(0xFF2196F3),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF2196F3)
                          : Colors.white.withOpacity(0.2),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyFilterHeader() {
    return Positioned(
      top: kToolbarHeight + MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Container(
        color: const Color(0xFF0A0A0A),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                subCategories[_selectedSubCategoryIndex].name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            ...filterOptions.map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) _onFilterTap(filter);
                  },
                  backgroundColor: const Color(0xFF1A1A1A),
                  selectedColor: const Color(0xFF2196F3),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 12,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF2196F3)
                        : Colors.white.withOpacity(0.2),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 10, // Number of products
        itemBuilder: (context, index) {
          return ItemSelectionGirdviwe(titalWord: "");
        },
      ),
    );
  }

  Widget _buildProductCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with discount badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.image,
                      color: Colors.white54,
                      size: 50,
                    ),
                  ),
                ),
              ),
              if (index % 3 == 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '30%\nOFF',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Product details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Apple Kashmir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '4 pc (600gm - 750 gm approx.)',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Text(
                        '₹135',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '₹200',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text(
                            'Subscribe now',
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.shopping_cart_outlined),
                          color: Colors.white,
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data Models
class SubCategory {
  final String name;
  final String imageUrl;

  SubCategory({required this.name, required this.imageUrl});
}
