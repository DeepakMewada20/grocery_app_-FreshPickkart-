import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/search_provider_controller.dart';
import 'package:freshpickkat_flutter/utils/app_text_styles.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/widgets/bogo_offer_card.dart';
import 'package:freshpickkat_flutter/widgets/combo_offer_card.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  SearchProviderController get searchController {
    return SearchProviderController.instance;
  }

  static const _offerFilters = <_OfferFilter>[
    _OfferFilter('BOGO', 'bogo'),
    _OfferFilter('Combo', 'combo'),
    _OfferFilter('Discount', 'discount'),
    _OfferFilter('Best Seller', 'best_seller'),
    _OfferFilter('New Arrival', 'new_arrival'),
    _OfferFilter('Free Delivery', 'free_delivery'),
  ];

  @override
  ThemeData appBarTheme(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      colorScheme: Theme.of(context).colorScheme,
      scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: cs.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.5)),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: cs.onSurface),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF1B8A4C),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchController.clearSearch();
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (searchController.selectedOfferFilter.value.isNotEmpty) {
      searchController.searchProductsWithOfferFilter(query);
    } else {
      searchController.searchProducts(query);
    }
    return _buildSearchResultsList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (searchController.selectedOfferFilter.value.isEmpty &&
        query.length < 2) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOfferChips(context),
              SizedBox(height: 18.h),
              Text(
                'Trending Searches',
                style: AppTextStyles.sectionTitle(context),
              ),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: ['Milk', 'Atta', 'Apple', 'Paneer', 'Vegetables']
                    .map(
                      (term) => ActionChip(
                        avatar: const Icon(Icons.trending_up, size: 16),
                        label: Text(term),
                        onPressed: () {
                          query = term;
                          searchController.searchProducts(term);
                          showResults(context);
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      );
    }

    if (searchController.selectedOfferFilter.value.isNotEmpty) {
      searchController.searchProductsWithOfferFilter(query);
    } else {
      searchController.fetchSuggestions(query);
    }
    return _buildSuggestionsList(context);
  }

  Widget _buildSearchResultsList(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Obx(() {
        if (searchController.selectedOfferFilter.value.isNotEmpty) {
          return _buildOfferResultsList(context);
        }
        if (searchController.isLoadingResults.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1B8A4C)),
          );
        }

        if (searchController.searchResults.isEmpty) {
          return Center(
            child: Text(
              'No products found.',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              final metrics = notification.metrics;
              if (metrics.pixels >= metrics.maxScrollExtent - 200) {
                searchController.loadMoreResults();
              }
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOfferChips(context),
                  SizedBox(height: 16.h),
                  Text(
                    'Search Results',
                    style: AppTextStyles.sectionTitle(context),
                  ),
                  SizedBox(height: 12.h),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: AppResponsive.productGridDelegate(
                          context,
                          constraints.maxWidth,
                        ),
                        itemCount:
                            searchController.searchResults.length +
                            (searchController.hasMoreResults.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= searchController.searchResults.length) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1B8A4C),
                              ),
                            );
                          }
                          final p = searchController.searchResults[index];
                          final uniqueKey = '${p.productId}_search_$index';
                          return KeyedSubtree(
                            key: ValueKey(uniqueKey),
                            child: ProductCard(
                              product: p,
                              enableHero: false,
                              heroTagSuffix: '_search_$index',
                              onAddPressed: () {},
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSuggestionsList(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Obx(() {
        if (searchController.selectedOfferFilter.value.isNotEmpty) {
          return _buildOfferResultsList(context);
        }
        if (searchController.isLoadingSuggestions.value &&
            searchController.suggestions.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1B8A4C)),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification) {
              final metrics = notification.metrics;
              if (metrics.pixels >= metrics.maxScrollExtent - 200) {
                searchController.loadMoreSuggestions();
              }
            }
            return false;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOfferChips(context),
                  SizedBox(height: 16.h),
                  Text(
                    'Suggestions',
                    style: AppTextStyles.sectionTitle(context),
                  ),
                  SizedBox(height: 12.h),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: AppResponsive.productGridDelegate(
                          context,
                          constraints.maxWidth,
                        ),
                        itemCount:
                            searchController.suggestions.length +
                            (searchController.hasMoreSuggestions.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= searchController.suggestions.length) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1B8A4C),
                              ),
                            );
                          }
                          final p = searchController.suggestions[index];
                          final uniqueKey = '${p.productId}_suggestion_$index';
                          return KeyedSubtree(
                            key: ValueKey(uniqueKey),
                            child: ProductCard(
                              product: p,
                              enableHero: false,
                              heroTagSuffix: '_suggestion_$index',
                              onAddPressed: () {},
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOfferChips(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _offerFilters.map((filter) {
            final selected =
                searchController.selectedOfferFilter.value == filter.value;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                selected: selected,
                label: Text(filter.label),
                onSelected: (_) {
                  searchController.selectOfferFilter(
                    filter.value,
                    query: query,
                  );
                  showResults(context);
                },
                selectedColor: const Color(0xFF1B8A4C),
                backgroundColor: cs.surfaceContainerHighest,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : cs.onSurface,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                  side: BorderSide(
                    color: selected
                        ? const Color(0xFF1B8A4C)
                        : cs.outlineVariant,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildOfferResultsList(BuildContext context) {
    if (searchController.isLoadingResults.value &&
        searchController.offerResults.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1B8A4C)),
      );
    }
    if (searchController.offerResults.isEmpty) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOfferChips(context),
            SizedBox(height: 48.h),
            Center(
              child: Text(
                'No offers found.',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent - 200) {
            searchController.loadMoreOfferResults();
          }
        }
        return false;
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOfferChips(context),
            SizedBox(height: 16.h),
            Text('Offer Sections', style: AppTextStyles.sectionTitle(context)),
            SizedBox(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  searchController.offerResults.length +
                  (searchController.hasMoreOfferResults.value ? 1 : 0),
              separatorBuilder: (_, _) => SizedBox(height: 14.h),
              itemBuilder: (context, index) {
                if (index >= searchController.offerResults.length) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1B8A4C),
                    ),
                  );
                }
                return _buildOfferItem(searchController.offerResults[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferItem(OfferSearchItem item) {
    switch (item.offerType) {
      case 'combo':
        final combo = item.comboOffer;
        if (combo == null) return const SizedBox.shrink();
        return ComboOfferCard(
          combo: combo,
          products: resolveComboProducts(
            combo,
            item.relatedProducts ?? const <Product>[],
          ),
          isExpanded: true,
          isHighlighted: false,
          onTap: () {},
        );
      case 'bogo':
        final product = item.product;
        final offer = item.bogoOffer;
        if (product == null || offer == null) return const SizedBox.shrink();
        return BogoOfferCard(product: product, offer: offer);
      default:
        final product = item.product;
        if (product == null) return const SizedBox.shrink();
        return ProductCard(
          product: product,
          enableHero: false,
          onAddPressed: () {},
        );
    }
  }
}

class _OfferFilter {
  const _OfferFilter(this.label, this.value);

  final String label;
  final String value;
}
