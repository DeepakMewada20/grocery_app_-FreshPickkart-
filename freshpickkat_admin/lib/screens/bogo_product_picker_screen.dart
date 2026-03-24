import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class BogoProductPickerScreen extends StatefulWidget {
  final String? initialCategory;
  final List<Product> initiallySelectedProducts;

  const BogoProductPickerScreen({
    super.key,
    required this.initiallySelectedProducts,
    this.initialCategory,
  });

  @override
  State<BogoProductPickerScreen> createState() =>
      _BogoProductPickerScreenState();
}

class _BogoProductPickerScreenState extends State<BogoProductPickerScreen> {
  final _client = ServerpodAdminClient().client;
  final _searchCtrl = TextEditingController();
  final _selectedProductsById = <String, Product>{};

  List<Product> _categoryProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    for (final product in widget.initiallySelectedProducts) {
      final id = product.productId;
      if (id != null) {
        _selectedProductsById[id] = product;
      }
    }
    _selectedCategory = widget.initialCategory;
    if (_selectedCategory != null && _selectedCategory!.trim().isNotEmpty) {
      _loadProductsForCategory(_selectedCategory!);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProductsForCategory(String category) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedCategory = category;
    });

    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );

      final products = <Product>[];
      String? pageToken;

      do {
        final page = await _client.product.getProductsPage(
          firebaseUid: uid,
          idToken: idToken,
          category: category,
          sortBy: 'name',
          limit: 100,
          pageToken: pageToken,
        );
        products.addAll(page.products);
        pageToken = page.nextPageToken;
      } while (pageToken != null);

      if (!mounted) return;
      setState(() {
        _categoryProducts = products;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleSelection(Product product) {
    final id = product.productId;
    if (id == null) return;

    setState(() {
      if (_selectedProductsById.containsKey(id)) {
        _selectedProductsById.remove(id);
      } else {
        _selectedProductsById[id] = product;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        AdminCategoryController.instance.categories
            .map((category) => category.categoryName)
            .toList()
          ..sort();

    final query = _searchCtrl.text.toLowerCase().trim();
    final filteredProducts = _categoryProducts.where((product) {
      if (query.isEmpty) return true;
      return product.productName.toLowerCase().contains(query) ||
          product.quantity.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 680;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Select BOGO Free Products'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      _selectedProductsById.values.toList(),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: Text('Use (${_selectedProductsById.length})'),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNarrow)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCategoryDropdown(categories),
                      const SizedBox(height: 12),
                      FilledButton.tonalIcon(
                        onPressed: _selectedCategory == null
                            ? null
                            : () =>
                                  _loadProductsForCategory(_selectedCategory!),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(child: _buildCategoryDropdown(categories)),
                      const SizedBox(width: 12),
                      FilledButton.tonalIcon(
                        onPressed: _selectedCategory == null
                            ? null
                            : () =>
                                  _loadProductsForCategory(_selectedCategory!),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search within selected category...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchCtrl.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close),
                          ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                _SelectedProductsSummary(
                  selectedProducts: _selectedProductsById.values.toList(),
                  onRemove: (id) {
                    setState(() {
                      _selectedProductsById.remove(id);
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedCategory == null
                      ? 'Select a category to load products'
                      : 'Products in $_selectedCategory (${filteredProducts.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(child: _buildContent(filteredProducts, isNarrow)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryDropdown(List<String> categories) {
    return DropdownButtonFormField<String>(
      initialValue: categories.contains(_selectedCategory)
          ? _selectedCategory
          : null,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: categories
          .map(
            (category) => DropdownMenuItem<String>(
              value: category,
              child: Text(category, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == null) return;
        _loadProductsForCategory(value);
      },
    );
  }

  Widget _buildContent(List<Product> filteredProducts, bool isNarrow) {
    if (_selectedCategory == null || _selectedCategory!.trim().isEmpty) {
      return const Center(
        child: Text('Select category first to browse products.'),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed to load products.\n$_errorMessage',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _loadProductsForCategory(_selectedCategory!),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (filteredProducts.isEmpty) {
      return const Center(
        child: Text('No products found for this category/search.'),
      );
    }

    if (isNarrow) {
      return ListView.separated(
        itemCount: filteredProducts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return _ProductSelectionTile(
            product: product,
            isSelected:
                product.productId != null &&
                _selectedProductsById.containsKey(product.productId),
            onTap: () => _toggleSelection(product),
          );
        },
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisExtent: 136,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _ProductSelectionTile(
          product: product,
          isSelected:
              product.productId != null &&
              _selectedProductsById.containsKey(product.productId),
          onTap: () => _toggleSelection(product),
        );
      },
    );
  }
}

class _ProductSelectionTile extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProductSelectionTile({
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? Colors.green.shade50 : Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 64,
                height: 64,
                color: Colors.grey.shade100,
                child: product.imageUrl.isEmpty
                    ? const Icon(Icons.image_not_supported_outlined)
                    : Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image_outlined);
                        },
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.quantity,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(value: isSelected, onChanged: (_) => onTap()),
          ],
        ),
      ),
    );
  }
}

class _SelectedProductsSummary extends StatelessWidget {
  final List<Product> selectedProducts;
  final ValueChanged<String> onRemove;

  const _SelectedProductsSummary({
    required this.selectedProducts,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedProducts.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text(
          'No free products selected yet.',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Products (${selectedProducts.length})',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 116,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: selectedProducts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final product = selectedProducts[index];
              final productId = product.productId;

              return Container(
                width: 250,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey.shade100,
                        child: product.imageUrl.isEmpty
                            ? const Icon(Icons.image_outlined)
                            : Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.broken_image_outlined,
                                  );
                                },
                              ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.quantity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: productId == null
                          ? null
                          : () => onRemove(productId),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
