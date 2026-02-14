import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/screens/category_item_screen.dart';
import 'package:freshpickkat_flutter/widgets/category_item_card.dart';
import 'package:freshpickkat_flutter/widgets/item_selection_girdviwe.dart';
import 'package:freshpickkat_flutter/widgets/search_bar.dart';
import 'package:get/get.dart';
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
  final categoryController = CategoryProviderController.instance;

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

  final Map<int, GlobalKey> _categoryKeys = {};
  int? _tappedCategoryIndex;

  @override
  void initState() {
    super.initState();
    _currentStickyHeader = categories[0].name;
    _itemsScrollController.addListener(_onItemsScroll);

    for (int i = 0; i < categories.length; i++) {
      _categoryKeys[i] = GlobalKey();
    }
  }

  void _onItemsScroll() {
    if (_isAutoScrolling) return;

    final stickyHeaderHeight =
        120.0; // Adjust based on your sticky header actual height

    int newSelectedIndex = 0;

    for (int i = 0; i < categories.length; i++) {
      final RenderBox? renderBox =
          _categoryKeys[i]?.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);

        // Agar category header sticky header ke upar ya uske barabar hai
        if (position.dy <= stickyHeaderHeight) {
          newSelectedIndex = i;
        }
      }
    }

    if (_selectedCategoryIndex != newSelectedIndex) {
      setState(() {
        _selectedCategoryIndex = newSelectedIndex;
        _currentStickyHeader = categories[newSelectedIndex].name;
      });
      _scrollCategoryIntoView(newSelectedIndex);
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

    // GlobalKey se actual position nikalo
    final RenderBox? renderBox =
        _categoryKeys[index]?.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final scrollOffset =
          _itemsScrollController.offset +
          position.dy -
          40.0; // 40 = sticky header height

      _itemsScrollController
          .animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          )
          .then((_) {
            _isAutoScrolling = false;
          });
    } else {
      _isAutoScrolling = false;
    }
  }

  @override
  void dispose() {
    _itemsScrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B8A4C),
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: SearchBarWidget(),
        ),
        titleSpacing: 0,
      ),
      body: Row(
        children: [
          _buildCategoriesList(),
          Container(
            height: hight,
            width: 9,
            decoration: BoxDecoration(
              // color: Colors.amber,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1A1A1A).withOpacity(1.0),
                  const Color(0xFF1A1A1A).withOpacity(0.0),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                // stops: [0.4, 0.5],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                _buildItemsGrid(),
                // Sticky Header
                _buildStickyHeader(),
              ],
            ),
          ),
          // ItemSelectionGirdviwe(titalWord: "All Items"),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return Container(
      width: 90,
      color: const Color(0xFF1A1A1A),
      child: Obx(
        () => ListView.builder(
          controller: _categoryScrollController,
          itemCount: categoryController.categories.length,
          itemBuilder: (context, index) {
            final isSelected = _selectedCategoryIndex == index;
            final isTapped = _tappedCategoryIndex == index;

            return GestureDetector(
              onTapDown: (_) {
                setState(() => _tappedCategoryIndex = index);
              },
              onTapUp: (_) {
                setState(() => _tappedCategoryIndex = null);
                _onCategoryTap(index);
              },
              onTapCancel: () {
                setState(() => _tappedCategoryIndex = null);
              },
              child: ClipRRect(
                // ... baaki code same
                borderRadius: BorderRadiusGeometry.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: Container(
                  // height: 60,
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
                  child: Center(
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedScale(
                              scale: isTapped ? 1.3 : 1.0,
                              duration: Duration(milliseconds: 250),
                              child: Image.network(
                                categoryController
                                    .categories[index]
                                    .categoryImageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Text(
                          categoryController.categories[index].categoryName,
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
        padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
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
      color: const Color(0xFF0A0A0A),
      child: Obx(
        () => ListView(
          controller: _itemsScrollController,
          padding: const EdgeInsets.only(
            top: 0,
            left: 10,
            right: 10,
            bottom: 0,
          ),
          children: [
            // Pehle saari categories
            ...List.generate(categoryController.categories.length, (
              categoryIndex,
            ) {
              final remoteCategory =
                  categoryController.categories[categoryIndex];
              final categoryName = remoteCategory.categoryName;
              final subCategories = remoteCategory.subCategory.entries.toList();
              return Column(
                key: _categoryKeys[categoryIndex],
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      categoryName,
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.74,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: subCategories.length,
                    itemBuilder: (context, itemIndex) {
                      final entry = subCategories[itemIndex];
                      // subCategory map: key = subcategoryName, value = subcategoryImageUrl
                      final itemName = entry.key;
                      final imageUrl = entry.value;
                      return CategoryItemCard(
                        itemName: itemName,
                        imagePath: imageUrl,
                        onTap: () {
                          // Category item card se navigate karo
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryItemsScreen(
                                categoryName: categoryName,
                                subCategoryName: itemName,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),

            // Sabse neeche - All Items section
            ItemSelectionGirdviwe(
              crossAxisCount: 2,
              childAspectRatio: 0.471,
              titalWord: "All Items",
            ),
          ],
        ),
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
