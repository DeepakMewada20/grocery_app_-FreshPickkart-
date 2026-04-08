import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/network_controller.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/banner_controller.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
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
  final networkController = NetworkController.instance;

  int _selectedCategoryIndex = 0;
  bool _isAutoScrolling = false;
  String _currentStickyHeader = '';

  final Map<int, GlobalKey> _categoryKeys = {};
  final GlobalKey _allItemsKey = GlobalKey();
  int? _tappedCategoryIndex;

  @override
  void initState() {
    super.initState();
    _itemsScrollController.addListener(_onItemsScroll);
    BannerController.instance.loadBannersForScreen('category_page');

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

    ever(networkController.connectionRestoredTrigger, (_) {
      if (!mounted) return;
      if (networkController.isConnected.value) {
        final currentRoute = Get.currentRoute;
        if (currentRoute.contains('categories') ||
            currentRoute.contains('category')) {
          categoryController.fetchCategoriesIfEmpty();
        }
      }
    });

    if (categoryController.categories.isNotEmpty) {
      _currentStickyHeader = categoryController.categories[0].categoryName;
      for (int i = 0; i < categoryController.categories.length; i++) {
        _categoryKeys[i] = GlobalKey();
      }
    }
  }

  Future<void> _onRefresh() async {
    await categoryController.forceFetchCategories();
  }

  void _onItemsScroll() {
    if (_isAutoScrolling || categoryController.categories.isEmpty) return;

    const stickyHeaderHeight = 120.0;
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

    final maxScroll = _itemsScrollController.position.maxScrollExtent;
    if (_itemsScrollController.offset >= maxScroll - 100) {
      final allItemsIndex = categoryController.categories.length;
      if (_selectedCategoryIndex != allItemsIndex) {
        setState(() {
          _selectedCategoryIndex = allItemsIndex;
          _currentStickyHeader = 'All Items';
        });
        _scrollCategoryIntoView(allItemsIndex);
      }
      return;
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
    const categoryHeight = 60.0;
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
      _isAutoScrolling = true;
    });

    if (index < categoryController.categories.length) {
      _currentStickyHeader = categoryController.categories[index].categoryName;
      final context = _categoryKeys[index]?.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.0,
        ).then((_) {
          _isAutoScrolling = false;
        });
      } else {
        _isAutoScrolling = false;
      }
    } else {
      _currentStickyHeader = 'All Items';
      final context = _allItemsKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.0,
        ).then((_) {
          _isAutoScrolling = false;
        });
      } else {
        _isAutoScrolling = false;
      }
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
    final cs = Theme.of(context).colorScheme;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchBarWidget(),
        ),
        titleSpacing: 0,
      ),
      body: Obx(() {
        final isConnected = networkController.isConnected.value;
        final isLoading = categoryController.isLoading.value;
        final hasData = categoryController.categories.isNotEmpty;

        // If no data and no connection -> show full screen error
        if (!hasData && !isConnected) {
          return InitialLoadingScreen(
            hasError: true,
            errorMessage: 'No internet connection',
            onRetry: () async {
              final connected = await networkController.checkConnection();
              if (connected) {
                categoryController.refreshData();
              }
            },
          );
        }

        // If no data but loading -> show shimmer
        if (!hasData && isLoading) {
          return Row(
            children: [
              Container(
                width: 90,
                color: cs.surfaceContainerHighest,
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
                            color: cs.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 50,
                          height: 8,
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHigh,
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

        // Has data -> show content (bottom banner handled globally)
        if (categoryController.categories.isEmpty) {
          return Center(
            child: Text(
              'No categories found',
              style: TextStyle(color: cs.onSurface),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: Row(
            children: [
              _buildCategoriesList(cs),
              Container(
                height: height,
                width: 9,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.surfaceContainerHighest,
                      cs.surfaceContainerHighest.withValues(alpha: 0.0),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    _buildItemsGrid(cs),
                    _buildStickyHeader(cs),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoriesList(ColorScheme cs) {
    final totalItems = categoryController.categories.length + 1;

    return Container(
      width: 90,
      color: cs.surfaceContainerHighest,
      child: ListView.builder(
        controller: _categoryScrollController,
        itemCount: totalItems,
        itemBuilder: (context, index) {
          final isAllItems = index == categoryController.categories.length;
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
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                bottomStart: Radius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: cs.outlineVariant,
                      width: 1,
                    ),
                    left: BorderSide(
                      color: isSelected
                          ? AppTheme.primaryGreen
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
                    children: isAllItems
                        ? [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedScale(
                                scale: isTapped ? 1.3 : 1.0,
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  Icons.grid_view_rounded,
                                  size: 50,
                                  color: isSelected
                                      ? AppTheme.primaryGreen
                                      : cs.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                            Text(
                              'All Items',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isSelected
                                    ? cs.onSurface
                                    : cs.onSurface.withValues(alpha: 0.6),
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ]
                        : [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedScale(
                                  scale: isTapped ? 1.3 : 1.0,
                                  duration: const Duration(milliseconds: 250),
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
                                color: isSelected
                                    ? cs.onSurface
                                    : cs.onSurface.withValues(alpha: 0.6),
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

  Widget _buildStickyHeader(ColorScheme cs) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
        child: Text(
          _currentStickyHeader,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildItemsGrid(ColorScheme cs) {
    final productController = ProductProviderController.instance;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200 &&
              !productController.isLoading.value &&
              productController.isMoreDataAvailable.value) {
            productController.loadMore();
          }
          return false;
        },
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
              final remoteCategory =
                  categoryController.categories[categoryIndex];
              final categoryName = remoteCategory.categoryName;

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
                      style: TextStyle(
                        color: cs.onSurface,
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
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
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
                        final itemName = subCategory.subCategoriesName.join(
                          ', ',
                        );
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
              key: _allItemsKey,
              crossAxisCount: 2,
              childAspectRatio: 0.471,
              titalWord: "All Items",
            ),

            if (productController.isLoading.value && productController.hasData)
              ProductGridShimmer(
                itemCount: 4,
                crossAxisCount: 2,
                childAspectRatio: 0.471,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),

            if (!productController.isMoreDataAvailable.value &&
                productController.hasData)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'All products loaded',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.4),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
