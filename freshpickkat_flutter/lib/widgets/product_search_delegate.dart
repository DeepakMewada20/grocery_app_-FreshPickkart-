import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/search_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:get/get.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  SearchProviderController get searchController {
    return SearchProviderController.instance;
  }

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
    searchController.searchProducts(query);
    return _buildSearchResultsList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (query.length < 2) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Text(
            'Type at least 2 characters to search',
            style: TextStyle(color: cs.onSurface.withValues(alpha: 0.4)),
          ),
        ),
      );
    }

    searchController.fetchSuggestions(query);
    return _buildSuggestionsList(context);
  }

  Widget _buildSearchResultsList(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Obx(() {
        if (searchController.isLoadingResults.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1B8A4C)),
          );
        }

        if (searchController.searchResults.isEmpty) {
          return Center(
            child: Text(
              'No products found.',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search Results',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: searchController.searchResults.length + (searchController.hasMoreResults.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= searchController.searchResults.length) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xFF1B8A4C)),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggestions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: searchController.suggestions.length + (searchController.hasMoreSuggestions.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= searchController.suggestions.length) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xFF1B8A4C)),
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
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}