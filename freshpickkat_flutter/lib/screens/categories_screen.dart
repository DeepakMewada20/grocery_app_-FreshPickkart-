import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/widgets/category_item_card.dart';
// import 'category_item_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ScrollController _itemsScrollController = ScrollController();
  final ScrollController _categoryScrollController = ScrollController();
  int _selectedCategoryIndex = 0;
  bool _isAutoScrolling = false;

  // Sample categories and items data
  final List<CategoryData> categories = [
    CategoryData(
      name: 'Fruits',
      items: [
        CategoryItem('Apple & Pear', 'assets/fruits/apple.png'),
        CategoryItem('Banana, Papaya & Pineapple', 'assets/fruits/banana.png'),
        CategoryItem('Coconut & Dates', 'assets/fruits/coconut.png'),
        CategoryItem('Citrus & Pomegranate', 'assets/fruits/citrus.png'),
        CategoryItem('Kiwi & Avocado', 'assets/fruits/kiwi.png'),
        CategoryItem('Berries, Guava & Sapota', 'assets/fruits/berries.png'),
      ],
    ),
    CategoryData(
      name: 'Vegetables',
      items: [
        CategoryItem('Leafy Vegetables', 'assets/vegetables/leafy.png'),
        CategoryItem('Root Vegetables', 'assets/vegetables/root.png'),
        CategoryItem('Tomatoes & Peppers', 'assets/vegetables/tomato.png'),
        CategoryItem('Onions & Garlic', 'assets/vegetables/onion.png'),
      ],
    ),
    CategoryData(
      name: 'Milk',
      items: [
        CategoryItem('Fresh Milk', 'assets/milk/fresh.png'),
        CategoryItem('Flavored Milk', 'assets/milk/flavored.png'),
        CategoryItem('Milk Powder', 'assets/milk/powder.png'),
      ],
    ),
    CategoryData(
      name: 'Bread, Eggs & More',
      items: [
        CategoryItem('Bread & Buns', 'assets/bread/bread.png'),
        CategoryItem('Fresh Eggs', 'assets/bread/eggs.png'),
        CategoryItem('Bakery Items', 'assets/bread/bakery.png'),
      ],
    ),
    CategoryData(
      name: 'Paneer, Butter & Cheese',
      items: [
        CategoryItem('Paneer', 'assets/dairy/paneer.png'),
        CategoryItem('Butter & Margarine', 'assets/dairy/butter.png'),
        CategoryItem('Cheese', 'assets/dairy/cheese.png'),
      ],
    ),
    CategoryData(
      name: 'Yogurt & Drinks',
      items: [
        CategoryItem('Fresh Yogurt', 'assets/yogurt/yogurt.png'),
        CategoryItem('Flavored Yogurt', 'assets/yogurt/flavored.png'),
        CategoryItem('Drinks & Lassi', 'assets/yogurt/drinks.png'),
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

  // Map to store the position of each category in the items scroll view
  final Map<int, double> _categoryPositions = {};
  final Map<int, GlobalKey> _categoryKeys = {};

  @override
  void initState() {
    super.initState();
    _itemsScrollController.addListener(_onItemsScroll);
    
    // Initialize category keys
    for (int i = 0; i < categories.length; i++) {
      _categoryKeys[i] = GlobalKey();
    }
    
    // Calculate positions after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateCategoryPositions();
    });
  }

  void _calculateCategoryPositions() {
    double currentPosition = 0;
    for (int i = 0; i < categories.length; i++) {
      _categoryPositions[i] = currentPosition;
      
      // Calculate height for this category section
      // Header height (60) + Grid height
      final itemCount = categories[i].items.length;
      final rows = (itemCount / 2).ceil();
      final gridHeight = rows * 180.0; // Approximate card height with spacing
      
      currentPosition += 60 + gridHeight + 16; // header + grid + spacing
    }
  }

  void _onItemsScroll() {
    if (_isAutoScrolling) return;

    final offset = _itemsScrollController.offset;
    
    // Find which category is currently visible
    for (int i = categories.length - 1; i >= 0; i--) {
      if (offset >= (_categoryPositions[i] ?? 0) - 50) {
        if (_selectedCategoryIndex != i) {
          setState(() {
            _selectedCategoryIndex = i;
          });
          _scrollCategoryIntoView(i);
        }
        break;
      }
    }
  }

  void _scrollCategoryIntoView(int index) {
    // Scroll the category list to show the selected category
    final categoryHeight = 60.0;
    final targetPosition = index * categoryHeight;
    final viewportHeight = _categoryScrollController.position.viewportDimension;
    
    if (targetPosition < _categoryScrollController.offset ||
        targetPosition > _categoryScrollController.offset + viewportHeight - categoryHeight) {
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
        title: _buildSearchBar(),
        titleSpacing: 0,
      ),
      body: Row(
        children: [
          // Left Column - Categories List
          _buildCategoriesList(),
          
          // Right Column - Items Grid
          Expanded(
            child: _buildItemsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Search for "Egg"',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Container(
      width: 100,
      color: const Color(0xFF1A1A1A),
      child: ListView.builder(
        controller: _categoryScrollController,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => _onCategoryTap(index),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2A2A2A) : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  left: BorderSide(
                    color: isSelected ? const Color(0xFF2196F3) : Colors.transparent,
                    width: 4,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Center(
                child: Text(
                  categories[index].name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemsGrid() {
    return Container(
      color: const Color(0xFF0A0A0A),
      child: ListView.builder(
        controller: _itemsScrollController,
        padding: const EdgeInsets.all(16),
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
                  childAspectRatio: 0.85,
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

  CategoryData({
    required this.name,
    required this.items,
  });
}

class CategoryItem {
  final String name;
  final String imagePath;

  CategoryItem(this.name, this.imagePath);
}