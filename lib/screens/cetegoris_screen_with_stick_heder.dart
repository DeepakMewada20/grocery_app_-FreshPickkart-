import 'package:flutter/material.dart';
import 'package:freshpickkat/widgets/category_item_card.dart';
import 'package:freshpickkat/widgets/search_bar.dart';
// import 'category_item_card.dart';

class CategoriesScreenWithStickyHeader extends StatefulWidget {
  const CategoriesScreenWithStickyHeader({super.key});

  @override
  State<CategoriesScreenWithStickyHeader> createState() =>
      _CategoriesScreenWithStickyHeaderState();
}

class _CategoriesScreenWithStickyHeaderState
    extends State<CategoriesScreenWithStickyHeader> {
  final ScrollController _itemsScrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();
  int _selectedCategoryIndex = 0;
  bool _isAutoScrolling = false;
  String _currentStickyHeader = '';

  // Sample categories and items data
  final List<CategoryData> categories = [
    CategoryData(
      name: 'Fruits',
      items: [
        CategoryItem('Apple & Pear', 'lib/assets/images/Fruits_.png'),
        CategoryItem(
          'Banana, Papaya & Pineapple',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Coconut & Dates',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Citrus & Pomegranate',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Kiwi & Avocado',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Berries, Guava & Sapota',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
      ],
    ),
    CategoryData(
      name: 'Vegetables',
      items: [
        CategoryItem(
          'Leafy Vegetables',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Root Vegetables',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Tomatoes & Peppers',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Onions & Garlic',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
      ],
    ),
    CategoryData(
      name: 'Milk',
      items: [
        CategoryItem(
          'Fresh Milk',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Flavored Milk',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Milk Powder',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
      ],
    ),
    CategoryData(
      name: 'Bread, Eggs & More',
      items: [
        CategoryItem(
          'Bread & Buns',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Fresh Eggs',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Bakery Items',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
      ],
    ),
    CategoryData(
      name: 'Paneer, Butter & Cheese',
      items: [
        CategoryItem(
          'Paneer',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Butter & Margarine',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Cheese',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
      ],
    ),
    CategoryData(
      name: 'Yogurt & Drinks',
      items: [
        CategoryItem(
          'Fresh Yogurt',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Flavored Yogurt',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
        CategoryItem(
          'Drinks & Lassi',
          'lib/assets/images/Wellness+&+Health_1729062880.png',
        ),
      ],
    ),
    CategoryData(
      name: 'Pooja Needs',
      items: [
        CategoryItem('Incense & Camphor', 'assets/pooja/incense.png'),
        CategoryItem('Pooja Items', 'assets/pooja/items.png'),
        CategoryItem('Flowers', 'assets/pooja/flowers.png'),
      ],
    ),
    CategoryData(
      name: 'Oil & Ghee',
      items: [
        CategoryItem('Cooking Oil', 'assets/oil/oil.png'),
        CategoryItem('Ghee', 'assets/oil/ghee.png'),
        CategoryItem('Specialty Oils', 'assets/oil/specialty.png'),
      ],
    ),
  ];

  final Map<int, double> _categoryPositions = {};
  final Map<int, GlobalKey> _categoryKeys = {};

  @override
  void initState() {
    super.initState();
    _currentStickyHeader = categories[0].name;
    _itemsScrollController.addListener(_onItemsScroll);

    for (int i = 0; i < categories.length; i++) {
      _categoryKeys[i] = GlobalKey();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateCategoryPositions();
    });
  }

  void _calculateCategoryPositions() {
    double currentPosition = 0;
    for (int i = 0; i < categories.length; i++) {
      _categoryPositions[i] = currentPosition;

      final itemCount = categories[i].items.length;
      final rows = (itemCount / 2).ceil();
      final gridHeight = rows * 180.0;

      currentPosition += 60 + gridHeight + 16;
    }
  }

  void _onItemsScroll() {
    if (_isAutoScrolling) return;

    final offset = _itemsScrollController.offset;

    for (int i = categories.length - 1; i >= 0; i--) {
      if (offset >= (_categoryPositions[i] ?? 0) - 50) {
        if (_selectedCategoryIndex != i) {
          setState(() {
            _selectedCategoryIndex = i;
            _currentStickyHeader = categories[i].name;
          });
          _scrollCategoryIntoView(i);
        }
        break;
      }
    }
  }

  void _scrollCategoryIntoView(int index) {
    final categoryHeight = 60.0;
    final targetPosition = index * categoryHeight;
    final viewportHeight = _categoryScrollController.position.viewportDimension;

    if (targetPosition < _categoryScrollController.offset ||
        targetPosition >
            _categoryScrollController.offset +
                viewportHeight -
                categoryHeight) {
      _categoryScrollController.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onCategoryTap(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      _currentStickyHeader = categories[index].name;
      _isAutoScrolling = true;
    });

    final targetPosition = _categoryPositions[index] ?? 0;

    _itemsScrollController
        .animateTo(
          targetPosition,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        )
        .then((_) {
          _isAutoScrolling = false;
        });
  }

  @override
  void dispose() {
    _itemsScrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3498DB),
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: SearchBarWidget(),
        ),
        titleSpacing: 0,
      ),
      body: Row(
        children: [
          _buildCategoriesList(),
          Expanded(
            child: Stack(
              children: [
                _buildItemsGrid(),
                // Sticky Header
                _buildStickyHeader(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSearchBar() {
  //   return Container(
  //     height: 48,
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     decoration: BoxDecoration(
  //       color: Colors.black,
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: const Row(
  //       children: [
  //         Icon(Icons.search, color: Colors.white),
  //         SizedBox(width: 8),
  //         Text(
  //           'Search for "Egg"',
  //           style: TextStyle(color: Colors.white70, fontSize: 14),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCategoriesList() {
    return Container(
      width: 90,
      color: const Color(0xFF1A1A1A),
      child: ListView.builder(
        controller: _categoryScrollController,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => _onCategoryTap(index),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Container(
                // height: 60,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2A2A2A)
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
                      width: 4,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Center(
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'lib/assets/images/Wellness+&+Health_1729062880.png',
                          ),
                        ),
                      ),
                      Text(
                        categories[index].name,
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
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: const Color(0xFF0A0A0A),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Text(
          _currentStickyHeader,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildItemsGrid() {
    return Container(
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(color: Colors.white, blurRadius: 67, spreadRadius: 3),
      //   ],
      // ),
      color: const Color(0xFF0A0A0A),
      child: ListView.builder(
        controller: _itemsScrollController,
        padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 0),
        itemCount: categories.length,
        itemBuilder: (context, categoryIndex) {
          final category = categories[categoryIndex];

          return Column(
            key: _categoryKeys[categoryIndex],
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Items Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.74,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: category.items.length,
                itemBuilder: (context, itemIndex) {
                  final item = category.items[itemIndex];
                  return CategoryItemCard(
                    itemName: item.name,
                    imagePath: item.imagePath,
                    onTap: () {
                      print('Tapped: ${item.name}');
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

// Data Models
class CategoryData {
  final String name;
  final List<CategoryItem> items;

  CategoryData({required this.name, required this.items});
}

class CategoryItem {
  final String name;
  final String imagePath;

  CategoryItem(this.name, this.imagePath);
}
