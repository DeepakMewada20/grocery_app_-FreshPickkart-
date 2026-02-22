import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/search_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:get/get.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final searchController = SearchProviderController.instance;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ThemeData(
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
    // Trigger search when query is submitted
    searchController.searchProducts(query);

    final cs = Theme.of(context).colorScheme;
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
              style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5)),
            ),
          );
        }

        return SingleChildScrollView(
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
                    color: cs.onSurface,
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
                  itemCount: searchController.searchResults.length,
                  itemBuilder: (context, index) {
                    final p = searchController.searchResults[index];
                    return ProductCard(
                      product: p,
                      onAddPressed: () {
                        // Logic handled within ProductCard usually
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
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

    // Fetch suggestions as user types
    searchController.fetchSuggestions(query);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Obx(() {
        if (searchController.isLoadingSuggestions.value &&
            searchController.suggestions.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1B8A4C)),
          );
        }

        return SingleChildScrollView(
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
                    color: cs.onSurface,
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
                  itemCount: searchController.suggestions.length,
                  itemBuilder: (context, index) {
                    final p = searchController.suggestions[index];
                    return ProductCard(
                      product: p,
                      onAddPressed: () {
                        // Logic handled within ProductCard usually
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
