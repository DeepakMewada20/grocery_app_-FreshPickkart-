import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import '../widgets/network_error_widget.dart';

class BogoOffersScreen extends StatefulWidget {
  const BogoOffersScreen({super.key});

  @override
  State<BogoOffersScreen> createState() => _BogoOffersScreenState();
}

class _BogoOffersScreenState extends State<BogoOffersScreen> {
  final AdminOfferController _controller = AdminOfferController.instance;
  final AdminProductController _productController =
      AdminProductController.instance;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadBogoOffers();
      _productController.loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BOGO Offers'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.loadBogoOffers(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddBogoDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add BOGO Offer'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search BOGO offers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_controller.networkController.hasError.value) {
                return NetworkErrorWidget(
                  onRetry: () => _controller.networkController.retryLastRequest(),
                );
              }

              if (_controller.isLoading.value && _controller.bogoOffers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final bogoOffers = _controller.bogoOffers
                  .where(
                    (o) =>
                        o.offerTitle.toLowerCase().contains(_searchQuery) ||
                        o.triggerProductId.toLowerCase().contains(_searchQuery),
                  )
                  .toList();

              if (bogoOffers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.card_giftcard,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No BOGO offers found',
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create a new BOGO offer',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: bogoOffers.length,
                itemBuilder: (context, index) {
                  final offer = bogoOffers[index];
                  return _BogoOfferCard(
                    offer: offer,
                    onToggle: (isActive) => _toggleBogoOffer(offer, isActive),
                    onEdit: () => _showEditBogoDialog(offer),
                    onDelete: () => _showDeleteConfirmation(offer),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleBogoOffer(BogoOffer offer, bool isActive) async {
    final updatedOffer = offer.copyWith(isActive: isActive);
    try {
      await _controller.client.bogo.upsertOffer(updatedOffer);
      await _controller.loadBogoOffers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'BOGO offer ${isActive ? 'activated' : 'deactivated'}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _showAddBogoDialog() {
    showDialog(
      context: context,
      builder: (context) => _BogoOfferDialog(
        onSave: (offer) async {
          try {
            await _controller.client.bogo.upsertOffer(offer);
            await _controller.loadBogoOffers();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('BOGO offer created successfully'),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          }
        },
      ),
    );
  }

  void _showEditBogoDialog(BogoOffer offer) {
    showDialog(
      context: context,
      builder: (context) => _BogoOfferDialog(
        offer: offer,
        onSave: (updated) async {
          try {
            await _controller.client.bogo.upsertOffer(updated);
            await _controller.loadBogoOffers();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('BOGO offer updated successfully'),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(BogoOffer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete BOGO Offer'),
        content: Text('Are you sure you want to delete "${offer.offerTitle}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _controller.client.bogo.deleteOffer(
                  offer.triggerProductId,
                );
                await _controller.loadBogoOffers();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('BOGO offer deleted')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _BogoOfferCard extends StatelessWidget {
  final BogoOffer offer;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BogoOfferCard({
    required this.offer,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isValid = offer.startDate.isBefore(now) && offer.endDate.isAfter(now);

    Product? triggerProduct;
    try {
      triggerProduct = AdminProductController.instance.products.firstWhere(
        (p) => p.productId == offer.triggerProductId,
      );
    } catch (_) {}

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: offer.isActive ? Colors.red[100] : Colors.grey[300],
          child: Icon(
            Icons.card_giftcard,
            color: offer.isActive ? Colors.red : Colors.grey,
          ),
        ),
        title: Text(
          offer.offerTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (triggerProduct != null)
              Text(
                'Trigger: ${triggerProduct.productName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            else
              Text(
                'Trigger Product ID: ${offer.triggerProductId}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Buy 1 Get ${offer.freeProductIds.length} Free',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                ),
                if (isValid && offer.isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'toggle',
              child: Row(
                children: [
                  Icon(Icons.toggle_on),
                  SizedBox(width: 8),
                  Text('Toggle Active'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'toggle':
                onToggle(!offer.isActive);
                break;
              case 'edit':
                onEdit();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
        ),
        onTap: onEdit,
      ),
    );
  }
}

class _BogoOfferDialog extends StatefulWidget {
  final BogoOffer? offer;
  final Function(BogoOffer) onSave;

  const _BogoOfferDialog({this.offer, required this.onSave});

  @override
  State<_BogoOfferDialog> createState() => _BogoOfferDialogState();
}

class _BogoOfferDialogState extends State<_BogoOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  Product? _selectedTriggerProduct;
  final List<_FreeProductSelection> _freeProducts = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));

  bool get isEditing => widget.offer != null;

  @override
  void initState() {
    super.initState();
    if (widget.offer != null) {
      _titleController.text = widget.offer!.offerTitle;
      _startDate = widget.offer!.startDate;
      _endDate = widget.offer!.endDate;

      try {
        _selectedTriggerProduct = AdminProductController.instance.products
            .firstWhere((p) => p.productId == widget.offer!.triggerProductId);
      } catch (_) {}

      for (final freeProductId in widget.offer!.freeProductIds) {
        try {
          final product = AdminProductController.instance.products.firstWhere(
            (p) => p.productId == freeProductId,
          );
          _freeProducts.add(
            _FreeProductSelection(
              product: product,
              quantity:
                  widget.offer!.freeProducts
                      ?.firstWhere(
                        (fp) => fp.productId == freeProductId,
                        orElse: () => BogoFreeProduct(productId: freeProductId),
                      )
                      .quantity ??
                  '1',
            ),
          );
        } catch (_) {
          _freeProducts.add(
            _FreeProductSelection(
              product: Product(
                productId: freeProductId,
                productName: 'Unknown Product',
                category: '',
                imageUrl: '',
                price: 0,
                realPrice: 0,
                discount: 0,
                isAvailable: true,
                addedAt: DateTime.now(),
                subcategory: [],
                quantity: '',
                mostSearch: 0,
                mostPurchases: 0,
              ),
              quantity: '1',
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = AdminProductController.instance.products;

    return AlertDialog(
      title: Text(isEditing ? 'Edit BOGO Offer' : 'Add BOGO Offer'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Offer Title',
                    hintText: 'e.g., Buy 1 Get 1 Free',
                  ),
                  validator: (v) =>
                      v?.trim().isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Trigger Product (Buy this to get free item)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<Product>(
                  initialValue: _selectedTriggerProduct,
                  decoration: const InputDecoration(
                    labelText: 'Select Trigger Product',
                  ),
                  items: products
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text(
                            p.productName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedTriggerProduct = v),
                  validator: (v) => v == null ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      'Free Products',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _addFreeProduct,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Free Product'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_freeProducts.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'No free products added yet.\nTap "Add Free Product" to add.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ..._freeProducts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final product = entry.value;
                    return Card(
                      child: ListTile(
                        leading: product.product.imageUrl.isNotEmpty
                            ? Image.network(
                                product.product.imageUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const CircleAvatar(
                                      child: Icon(Icons.shopping_basket),
                                    ),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.shopping_basket),
                              ),
                        title: Text(
                          product.product.productName,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('Qty: ${product.quantity}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => _freeProducts.removeAt(index));
                          },
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectDate(true),
                        icon: const Icon(Icons.calendar_today),
                        label: Text('Start: ${_formatDate(_startDate)}'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _selectDate(false),
                        icon: const Icon(Icons.calendar_today),
                        label: Text('End: ${_formatDate(_endDate)}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  void _addFreeProduct() async {
    final products = AdminProductController.instance.products;

    if (!mounted) return;

    final selected = await showDialog<Product>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Free Product'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              if (_selectedTriggerProduct?.productId == product.productId) {
                return const SizedBox.shrink();
              }
              return ListTile(
                leading: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      )
                    : const CircleAvatar(child: Icon(Icons.shopping_basket)),
                title: Text(product.productName),
                subtitle: Text('₹${product.price}'),
                onTap: () => Navigator.pop(context, product),
              );
            },
          ),
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        _freeProducts.add(
          _FreeProductSelection(product: selected, quantity: '1'),
        );
      });
    }
  }

  Future<void> _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTriggerProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a trigger product')),
      );
      return;
    }

    if (_freeProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one free product')),
      );
      return;
    }

    final freeProducts = _freeProducts
        .map(
          (fp) => BogoFreeProduct(
            productId: fp.product.productId ?? '',
            quantity: fp.quantity,
          ),
        )
        .toList();

    final offer = BogoOffer(
      offerId: widget.offer?.offerId,
      triggerProductId: _selectedTriggerProduct!.productId ?? '',
      freeProductIds: _freeProducts
          .map((fp) => fp.product.productId ?? '')
          .toList(),
      freeProducts: freeProducts,
      offerTitle: _titleController.text.trim(),
      isActive: widget.offer?.isActive ?? true,
      startDate: _startDate,
      endDate: _endDate,
      createdAt: widget.offer?.createdAt ?? DateTime.now(),
    );

    await widget.onSave(offer);
    if (mounted) Navigator.pop(context);
  }
}

class _FreeProductSelection {
  final Product product;
  final String quantity;

  _FreeProductSelection({required this.product, required this.quantity});
}
