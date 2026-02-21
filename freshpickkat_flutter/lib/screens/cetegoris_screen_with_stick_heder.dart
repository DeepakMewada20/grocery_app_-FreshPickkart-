import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/screens/category_item_screen.dart';
import 'package:freshpickkat_flutter/widgets/category_item_card.dart';
import 'package:freshpickkat_flutter/widgets/item_selection_girdviwe.dart';
import 'package:freshpickkat_flutter/widgets/search_bar.dart';
import 'package:freshpickkat_flutter/widgets/shimmer_loading.dart';
import 'package:freshpickkat_flutter/widgets/initial_loading_screen.dart';
import 'package:get/get.dart';

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

  final Map<int, GlobalKey> _categoryKeys = {};
  int? _tappedCategoryIndex;

  @override
  void initState() {
    super.initState();
    _itemsScrollController.addListener(_onItemsScroll);

    // Listen to category updates to initialize keys and sticky header
    ever(categoryController.categories, (categories) {
      if (categories.isNotEmpty) {
        if (mounted) {
          setState(() {
            _currentStickyHeader = categories[0].categoryName;
            for (int i = 0; i < categories.length; i++) {
              _categoryKeys[i] = GlobalKey();
            }
          });
        }
      }
    });

    // Initial setup if data already exists
    if (categoryController.categories.isNotEmpty) {
      _currentStickyHeader = categoryController.categories[0].categoryName;
      for (int i = 0; i < categoryController.categories.length; i++) {
        _categoryKeys[i] = GlobalKey();
      }
    }
  }

  void _onItemsScroll() {
    if (_isAutoScrolling || categoryController.categories.isEmpty) return;

    final stickyHeaderHeight =
        120.0; // Adjust based on your sticky header actual height

    int newSelectedIndex = 0;

    for (int i = 0; i < categoryController.categories.length; i++) {
      final RenderBox? renderBox =
          _categoryKeys[i]?.currentContext?.findRenderObject() as RenderBox?;

      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);

        if (position.dy <= stickyHeaderHeight) {
          newSelectedIndex = i;
        }
      }
    }

    if (_selectedCategoryIndex != newSelectedIndex) {
      setState(() {
        _selectedCategoryIndex = newSelectedIndex;
        _currentStickyHeader =
            categoryController.categories[newSelectedIndex].categoryName;
      });
      _scrollCategoryIntoView(newSelectedIndex);
    }
  }

  void _scrollCategoryIntoView(int index) {
    if (!_categoryScrollController.hasClients) return;
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
      _currentStickyHeader = categoryController.categories[index].categoryName;
      _isAutoScrolling = true;
    });

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
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchBarWidget(),
        ),
        titleSpacing: 0,
      ),
      body: Obx(() {
        final networkController = NetworkController.instance;
        final isConnected = networkController.isConnected.value;
        final isLoading = categoryController.isLoading.value;
        final hasData = categoryController.categories.isNotEmpty;

        if (!isConnected || (isLoading && !hasData)) {
          if (!isConnected) {
            return NetworkErrorWidget(
              message: 'No internet connection',
              onRetry: () async {
                final connected = await networkController.checkConnection();
                if (connected) {
                  categoryController.refreshData();
                }
              },
            );
          }
          return Row(
            children: [
              Container(
                width: 90,
                color: const Color(0xFF1A1A1A),
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) => Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 50,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CategoryItemGridShimmer(
                    crossAxisCount: 3,
                    childAspectRatio: 0.74,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    itemCount: 9,
                  ),
                ),
              ),
            ],
          );
        }
        if (categoryController.categories.isEmpty) {
          return const Center(
            child: Text(
              'No categories found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return Row(
          children: [
            _buildCategoriesList(),
            Container(
              height: hight,
              width: 9,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1A1A1A).withOpacity(1.0),
                    const Color(0xFF1A1A1A).withOpacity(0.0),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  _buildItemsGrid(),
                  _buildStickyHeader(),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCategoriesList() {
    return Container(
      width: 90,
      color: const Color(0xFF1A1A1A),
      child: ListView.builder(
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
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF252525)
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: isSelected
                          ? Color(0xFF1B8A4C)
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
    );
  }

  Widget _buildStickyHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: const Color(0xFF0F0F0F),
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
      color: const Color(0xFF0F0F0F),
      child: ListView(
        controller: _itemsScrollController,
        padding: const EdgeInsets.only(
          top: 0,
          left: 10,
          right: 10,
          bottom: 0,
        ),
        children: [
          ...List.generate(categoryController.categories.length, (
            categoryIndex,
          ) {
            final remoteCategory = categoryController.categories[categoryIndex];
            final categoryName = remoteCategory.categoryName;

            // Filter subcategories by categoryId (matching categoryName)
            // Handling case-insensitive and trimmed match for robust sorting
            final subCategoriesList = categoryController.subCategories
                .where(
                  (sc) =>
                      sc.categoryId.trim().toLowerCase() ==
                      categoryName.trim().toLowerCase(),
                )
                .toList();

            return Column(
              key: _categoryKeys[categoryIndex],
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                if (subCategoriesList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No subcategories for $categoryName',
                      style: TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  )
                else
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
                    itemCount: subCategoriesList.length,
                    itemBuilder: (context, itemIndex) {
                      final subCategory = subCategoriesList[itemIndex];

                      // Joining names if there are multiple in subCategoriesName array
                      final itemName = subCategory.subCategoriesName.join(', ');
                      final imageUrl = subCategory.subCategoriesUrl;

                      return CategoryItemCard(
                        itemName: itemName,
                        imagePath: imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryItemsScreen(
                                categoryName: categoryName,
                                subCategoryGroupName: itemName,
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

          ItemSelectionGirdviwe(
            crossAxisCount: 2,
            childAspectRatio: 0.471,
            titalWord: "All Items",
          ),
        ],
      ),
    );
  }
}
