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
import 'package:freshpickkat_flutter/core/design_system/app_text.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_flutter/core/design_system/screen_scale.dart';

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
  List<double> _categoryOffsets = [];

  @override
  void initState() {
    super.initState();
    categoryController.fetchCategoriesIfEmpty();
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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _computeCategoryOffsets();
            _calibrateCategoryOffsets();
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _computeCategoryOffsets();
        _calibrateCategoryOffsets();
      });
    }
  }

  void _computeCategoryOffsets() {
    if (!mounted || !context.mounted) return;
    final width = AppResponsive.layoutWidth(context);
    final sidebarWidth = AppResponsive.railWidth(context);
    final availableWidth = width - sidebarWidth - ScreenScale.w(9) - ScreenScale.w(20);
    final columns = AppResponsive.categoryGridColumnsForWidth(availableWidth);
    final cellWidth = availableWidth / columns;
    final aspectRatio =
        MediaQuery.of(context).orientation == Orientation.landscape
        ? 0.86
        : 0.78;
    final cellHeight = cellWidth / aspectRatio;
    const spacing = 12.0;
    const categoryNameHeight = 40.0;
    const dividerHeight = 16.0;

    _categoryOffsets = [0.0];
    for (int i = 0; i < categoryController.categories.length; i++) {
      final prevOffset = _categoryOffsets[i];
      final categoryName = categoryController.categories[i].categoryName;
      final subCount = categoryController.subCategories
          .where(
            (sc) =>
                sc.categoryId.trim().toLowerCase() ==
                categoryName.trim().toLowerCase(),
          )
          .length;
      final rows = subCount > 0 ? (subCount / columns).ceil() : 1;
      final gridHeight = subCount > 0
          ? rows * cellHeight + (rows - 1) * spacing
          : 50.0;
      _categoryOffsets.add(
        prevOffset + categoryNameHeight + gridHeight + dividerHeight,
      );
    }
  }

  void _calibrateCategoryOffsets() {
    if (_categoryOffsets.length <= categoryController.categories.length) return;
    for (int i = 0; i < categoryController.categories.length; i++) {
      final renderBox =
          _categoryKeys[i]?.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize) {
        final offset = renderBox.localToGlobal(Offset.zero);
        final scrollCurrent = _itemsScrollController.hasClients
            ? _itemsScrollController.offset
            : 0.0;
        final viewportTop =
            (context.findRenderObject() as RenderBox?)
                ?.localToGlobal(Offset.zero)
                .dy ??
            0;
        final docOffset = scrollCurrent + offset.dy - viewportTop;
        _categoryOffsets[i] = docOffset;
      }
    }
  }

  Future<void> _onRefresh() async {
    await categoryController.forceFetchCategories();
  }

  void _onItemsScroll() {
    if (_isAutoScrolling || categoryController.categories.isEmpty) return;
    _syncScrollState();
  }

  void _syncScrollState() {
    if (!mounted || categoryController.categories.isEmpty) return;
    if (_categoryOffsets.length <= categoryController.categories.length) return;

    final offset = _itemsScrollController.hasClients
        ? _itemsScrollController.offset
        : 0.0;

    int newIndex = 0;
    for (int i = 0; i < _categoryOffsets.length; i++) {
      if (offset >= _categoryOffsets[i] - 50) {
        newIndex = i;
      }
    }
    if (newIndex >= categoryController.categories.length) {
      newIndex = categoryController.categories.length;
    }

    if (_selectedCategoryIndex != newIndex) {
      setState(() {
        _selectedCategoryIndex = newIndex;
        _currentStickyHeader = newIndex < categoryController.categories.length
            ? categoryController.categories[newIndex].categoryName
            : 'All Items';
      });
      _scrollCategoryIntoView(newIndex);
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
      if (index < categoryController.categories.length) {
        _currentStickyHeader =
            categoryController.categories[index].categoryName;
      } else {
        _currentStickyHeader = 'All Items';
      }
    });

    _scrollCategoryIntoView(index);

    if (!_itemsScrollController.hasClients) {
      _isAutoScrolling = false;
      return;
    }

    _scrollToCategory(index).then((_) {
      _isAutoScrolling = false;
    });
  }

  Future<void> _scrollToCategory(int index) async {
    if (!_itemsScrollController.hasClients) return;

    // "All Items" — scroll to bottom using the dedicated key
    if (index >= categoryController.categories.length) {
      final allCtx = _allItemsKey.currentContext;
      if (allCtx != null && allCtx.findRenderObject() != null) {
        await Scrollable.ensureVisible(
          allCtx,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.0,
        );
      } else {
        await _itemsScrollController.animateTo(
          _itemsScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
      return;
    }

    // All widgets are kept alive via cacheExtent → context is always valid.
    final ctx = _categoryKeys[index]?.currentContext;
    if (ctx != null && ctx.findRenderObject() != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
      if (mounted) _calibrateCategoryOffsets();
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
        final hasData = categoryController.categories.isNotEmpty;

        // If no data -> show shimmer (top banner handles offline feedback)
        if (!hasData) {
          return Row(
            children: [
              Container(
                width: AppResponsive.railWidth(context),
                color: cs.surfaceContainerHighest,
                child: ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.all(ScreenScale.w(8)),
                    child: Column(
                      children: [
                        Container(
                          width: ScreenScale.r(56),
                          height: ScreenScale.r(56),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: ScreenScale.h(4)),
                        Container(
                          width: ScreenScale.w(50),
                          height: ScreenScale.h(8),
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
                  padding: EdgeInsets.all(ScreenScale.w(10)),
                  child: const CategoryItemGridShimmer(itemCount: 9),
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
                width: ScreenScale.w(9),
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
      width: AppResponsive.railWidth(context),
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
                padding: EdgeInsets.symmetric(horizontal: ScreenScale.w(8), vertical: ScreenScale.h(8)),
                child: Center(
                  child: Column(
                    children: isAllItems
                        ? [
                            Padding(
                              padding: EdgeInsets.all(ScreenScale.w(8)),
                              child: AnimatedScale(
                                scale: isTapped ? 1.3 : 1.0,
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  Icons.grid_view_rounded,
                                  size: ScreenScale.r(46),
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
                                fontSize: ScreenScale.sp(12),
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
                                padding: EdgeInsets.all(ScreenScale.w(8)),
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
                                          size: ScreenScale.r(46),
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
                                fontSize: ScreenScale.sp(12),
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
        padding: EdgeInsets.fromLTRB(ScreenScale.w(10), ScreenScale.h(10), ScreenScale.w(16), ScreenScale.h(10)),
        child: Text(
          _currentStickyHeader,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.sectionTitle(context),
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
          cacheExtent: 10000,
          padding: EdgeInsets.only(left: ScreenScale.w(10), right: ScreenScale.w(10)),
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
                    padding: EdgeInsets.symmetric(vertical: ScreenScale.h(10)),
                    child: Text(
                      categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sectionTitle(context),
                    ),
                  ),
                  if (subCategoriesList.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: ScreenScale.h(20)),
                      child: Text(
                        'No subcategories for $categoryName',
                        style: TextStyle(
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: AppResponsive.categoryGridDelegate(
                            context,
                            constraints.maxWidth,
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
                                    settings: const RouteSettings(name: '/CategoryItemsScreen'),
                                    builder: (context) => CategoryItemsScreen(
                                      categoryName: categoryName,
                                      subCategoryGroupName: itemName,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  SizedBox(height: ScreenScale.h(16)),
                ],
              );
            }),

            ItemSelectionGirdviwe(
              key: _allItemsKey,
              titalWord: "All Items",
            ),

            if (productController.isLoading.value && productController.hasData)
              ProductGridShimmer(
                itemCount: 4,
                padding: EdgeInsets.symmetric(horizontal: ScreenScale.w(12)),
              ),

            if (!productController.isMoreDataAvailable.value &&
                productController.hasData)
              Padding(
                padding: EdgeInsets.all(ScreenScale.w(20)),
                child: Center(
                  child: Text(
                    'All products loaded',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.4),
                      fontSize: ScreenScale.sp(14),
                    ),
                  ),
                ),
              ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
