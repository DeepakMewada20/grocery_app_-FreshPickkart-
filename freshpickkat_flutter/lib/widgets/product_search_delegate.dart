import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/controller/search_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/bogo_offer_card.dart';
import 'package:freshpickkat_flutter/widgets/combo_offer_card.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:freshpickkat_flutter/utils/combo_offer_utils.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final SearchProviderController searchController =
      SearchProviderController.instance;

  ProductSearchDelegate()
    : super(
        searchFieldLabel: 'Search products...',
        searchFieldStyle: TextStyle(fontSize: 16.sp),
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            searchController.clearSearch();
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (searchController.selectedOfferFilter.value.isNotEmpty) {
      return _buildOfferResultsBody(context);
    }

    if (query.trim().isNotEmpty) {
      Future.microtask(() => searchController.searchProducts(query));
    }

    return _buildSearchResultsBody(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      searchController.loadRecentSearch();
      return _buildEmptySuggestions(context);
    }

    Future.microtask(() => searchController.fetchSuggestions(query));

    return _buildSuggestionsBody(context);
  }

  Widget _buildEmptySuggestions(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: 8.h + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        _buildOfferChips(context),
        _buildRecentSearches(context),
      ],
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final recentSearches = searchController.recentSearchesList;
      if (recentSearches.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.r, 16.r, 8.r, 4.r),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: searchController.clearAll,
                  child: const Text('Clear all'),
                ),
              ],
            ),
          ),
          ...recentSearches.map(
            (term) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(term),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => searchController.removeSearch(term),
              ),
              onTap: () {
                query = term;
                searchController.searchProducts(term);
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => showResults(context),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProductGrid({
    required BuildContext context,
    required int itemCount,
    required bool hasMore,
    required Widget Function(int index) itemBuilder,
    required VoidCallback loadMore,
  }) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        16.w,
        16.w,
        16.w,
        16.w + MediaQuery.of(context).padding.bottom,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.56,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: itemCount + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == itemCount) {
          loadMore();
          return const Center(child: CircularProgressIndicator());
        }
        return itemBuilder(index);
      },
    );
  }

  Widget _buildSearchResultsBody(BuildContext context) {
    return Obx(() {
      if (searchController.isLoadingResults.value &&
          searchController.searchResults.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (searchController.searchResults.isEmpty) {
        return _buildNoResults(context);
      }

      return _buildProductGrid(
        context: context,
        itemCount: searchController.searchResults.length,
        hasMore: searchController.hasMoreResults.value,
        loadMore: searchController.loadMoreResults,
        itemBuilder: (index) {
          final p = searchController.searchResults[index];
          return ProductCard(
            key: ValueKey('search_res_${p.productId ?? index}'),
            product: p,
            enableHero: false,
          );
        },
      );
    });
  }

  Widget _buildSuggestionsBody(BuildContext context) {
    return Obx(() {
      if (searchController.isLoadingSuggestions.value &&
          searchController.suggestions.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (searchController.suggestions.isEmpty) {
        return _buildNoResults(context);
      }

      return _buildProductGrid(
        context: context,
        itemCount: searchController.suggestions.length,
        hasMore: searchController.hasMoreSuggestions.value,
        loadMore: searchController.loadMoreSuggestions,
        itemBuilder: (index) {
          final p = searchController.suggestions[index];
          return ProductCard(
            key: ValueKey('search_sug_${p.productId ?? index}'),
            product: p,
            enableHero: false,
          );
        },
      );
    });
  }

  Widget _buildOfferResultsBody(BuildContext context) {
    return Obx(() {
      if (searchController.isLoadingResults.value &&
          searchController.offerResults.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (searchController.offerResults.isEmpty) {
        return _buildNoResults(context);
      }

      final filter = searchController.selectedOfferFilter.value;
      final isProductGrid = !['bogo', 'combo'].contains(filter);

      if (isProductGrid) {
        return Column(
          children: [
            _buildOfferChips(context),
            Expanded(
              child: _buildProductGrid(
                context: context,
                itemCount: searchController.offerResults.length,
                hasMore: searchController.hasMoreOfferResults.value,
                loadMore: searchController.loadMoreOfferResults,
                itemBuilder: (index) {
                  final item = searchController.offerResults[index];
                  final product = item.product;
                  if (product == null) return const SizedBox.shrink();
                  return ProductCard(
                    key: ValueKey('offer_prod_${product.productId ?? index}'),
                    product: product,
                    enableHero: false,
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
        );
      }

      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildOfferChips(context)),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              16.w,
              0,
              16.w,
              16.w + MediaQuery.paddingOf(context).bottom,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= searchController.offerResults.length) {
                    if (searchController.hasMoreOfferResults.value) {
                      searchController.loadMoreOfferResults();
                      return Container(
                        height: 80.h,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      );
                    }
                    return null;
                  }

                  final item = searchController.offerResults[index];
                  return Padding(
                    key: ValueKey('offer_item_${index}_${item.hashCode}'),
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _buildOfferItem(item),
                  );
                },
                childCount:
                    searchController.offerResults.length +
                    (searchController.hasMoreOfferResults.value ? 1 : 0),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNoResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.r, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            'No results found',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }

  Widget _buildOfferChips(BuildContext context) {
    final offers = [
      (label: 'BOGO', value: 'bogo'),
      (label: 'Combo', value: 'combo'),
      (label: 'Free Delivery', value: 'free_delivery'),
      (label: 'Free Gift', value: 'free_gift'),
      (label: 'Up to 40% OFF', value: 'discount_40'),
      (label: 'Trending', value: 'trending'),
      (label: 'Best Seller', value: 'best_seller'),
      (label: 'New Arrival', value: 'new_arrival'),
    ];

    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: offers.map((filter) {
            final isSelected =
                searchController.selectedOfferFilter.value == filter.value;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: Text(filter.label),
                selected: isSelected,
                onSelected: (_) {
                  searchController.selectOfferFilter(
                    filter.value,
                    query: query,
                  );
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => showResults(context),
                  );
                },
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildOfferItem(OfferSearchItem item) {
    final type = item.offerType.toLowerCase();
    switch (type) {
      case 'combo':
        final combo = item.comboOffer;
        if (combo == null) return const SizedBox.shrink();
        return Obx(() {
          final isExpanded =
              searchController.expandedComboId.value == combo.comboId;
          return ComboOfferCard(
            combo: combo,
            isExpanded: isExpanded,
            isHighlighted: false,
            onTap: () {
              if (combo.comboId != null) {
                searchController.toggleComboExpansion(combo.comboId!);
              }
            },
            products: resolveComboProducts(
              combo,
              item.relatedProducts ?? const <Product>[],
            ),
          );
        });
      case 'bogo':
        final product = item.product;
        final offer = item.bogoOffer;
        if (product == null || offer == null) return const SizedBox.shrink();
        return BogoOfferCard(product: product, offer: offer);
      default:
        final product = item.product;
        if (product == null) return const SizedBox.shrink();
        return ProductCard(
          key: ValueKey('${product.productId}_offer_item'),
          product: product,
          enableHero: false,
        );
    }
  }
}
