import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/search_provider_controller.dart';
import 'package:freshpickkat_flutter/widgets/product_card.dart';
import 'package:get/get.dart';

class ProductSearchDelegate extends SearchDelegate<String> {
  final searchController = SearchProviderController.instance;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.blue,
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

    return Container(
      color: Colors.black,
      child: Obx(() {
        if (searchController.isLoadingResults.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }

        if (searchController.searchResults.isEmpty) {
          return const Center(
            child: Text(
              'No products found.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
    if (query.length < 2) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'Type at least 2 characters to search',
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    // Fetch suggestions as user types
    searchController.fetchSuggestions(query);

    return Container(
      color: Colors.black,
      child: Obx(() {
        if (searchController.isLoadingSuggestions.value &&
            searchController.suggestions.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Suggestions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
