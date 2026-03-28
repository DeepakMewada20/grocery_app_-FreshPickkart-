import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_combo_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import '../widgets/network_error_widget.dart';

class ComboOffersScreen extends StatefulWidget {
  const ComboOffersScreen({super.key});

  @override
  State<ComboOffersScreen> createState() => _ComboOffersScreenState();
}

class _ComboOffersScreenState extends State<ComboOffersScreen>
    with AutomaticKeepAliveClientMixin {
  final AdminComboOfferController _controller =
      AdminComboOfferController.instance;
  final AdminProductController _productController =
      AdminProductController.instance;
  final AdminCategoryController _categoryController =
      AdminCategoryController.instance;
  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_productController.products.isEmpty) {
        _productController.loadInitial();
      }
      if (_categoryController.categories.isEmpty) {
        _categoryController.loadCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Combo Offers'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.loadComboOffers(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddComboDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Combo'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search combo offers...',
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

              if (_controller.isLoading.value && _controller.comboOffers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final offers = _controller.comboOffers
                  .where((o) => o.name.toLowerCase().contains(_searchQuery))
                  .toList();

              if (offers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No combo offers found',
                        style: TextStyle(color: Colors.grey[600], fontSize: 18),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final offer = offers[index];
                  return _ComboOfferCard(
                    offer: offer,
                    onToggle: (isActive) => _controller.toggleComboOffer(
                      offer.comboId ?? '',
                      isActive,
                    ),
                    onEdit: () => _showEditComboDialog(offer),
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

  void _showAddComboDialog() {
    showDialog(
      context: context,
      builder: (context) => _ComboOfferDialog(
        onSave: (offer) async {
          await _controller.createComboOffer(offer);
        },
      ),
    );
  }

  void _showEditComboDialog(ComboOffer offer) {
    showDialog(
      context: context,
      builder: (context) => _ComboOfferDialog(
        offer: offer,
        onSave: (updated) async {
          await _controller.updateComboOffer(updated);
        },
      ),
    );
  }

  void _showDeleteConfirmation(ComboOffer offer) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        var isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Delete Combo Offer'),
            content: Text('Are you sure you want to delete "${offer.name}"?'),
            actions: [
              TextButton(
                onPressed: isDeleting ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: isDeleting
                    ? null
                    : () async {
                        setDialogState(() => isDeleting = true);
                        await _controller.deleteComboOffer(offer.comboId ?? '');
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Combo offer deleted')),
                        );
                      },
                child: isDeleting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ComboOfferCard extends StatelessWidget {
  final ComboOffer offer;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ComboOfferCard({
    required this.offer,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isValid = offer.startDate.isBefore(now) && offer.endDate.isAfter(now);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: offer.isActive
              ? Colors.green[100]
              : Colors.grey[300],
          child: Icon(
            Icons.local_offer,
            color: offer.isActive ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(
          offer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer.comboProducts
                  .map((p) => p.productName ?? p.productId)
                  .join(' + '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: offer.discountType == 'percentage'
                        ? Colors.blue[100]
                        : Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    offer.discountType == 'percentage'
                        ? '${offer.discountValue.toStringAsFixed(0)}% OFF'
                        : '₹${offer.discountValue.toStringAsFixed(0)} OFF',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: offer.discountType == 'percentage'
                          ? Colors.blue[700]
                          : Colors.orange[700],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (isValid)
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

class _ComboOfferDialog extends StatefulWidget {
  final ComboOffer? offer;
  final Function(ComboOffer) onSave;

  const _ComboOfferDialog({this.offer, required this.onSave});

  @override
  State<_ComboOfferDialog> createState() => _ComboOfferDialogState();
}

class _ComboOfferDialogState extends State<_ComboOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountValueController = TextEditingController();

  String _discountType = 'flat';
  int _priority = 0;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  final List<_SelectedProduct> _products = [];
  bool _isSubmitting = false;

  bool get isEditing => widget.offer != null;

  @override
  void initState() {
    super.initState();
    if (widget.offer != null) {
      _nameController.text = widget.offer!.name;
      _descriptionController.text = widget.offer!.description ?? '';
      _discountValueController.text = widget.offer!.discountValue.toString();
      _discountType = widget.offer!.discountType;
      _priority = widget.offer!.priority;
      _startDate = widget.offer!.startDate;
      _endDate = widget.offer!.endDate;
      _products.addAll(
        widget.offer!.comboProducts.map(
          (p) => _SelectedProduct(
            productId: p.productId,
            productName: p.productName,
            quantity: p.quantity,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Edit Combo Offer' : 'Add Combo Offer'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Offer Name',
                    hintText: 'e.g., Milk + Bread Combo',
                  ),
                  validator: (v) =>
                      v?.trim().isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Products in Combo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  return Card(
                    child: ListTile(
                      title: Text(product.productName ?? product.productId),
                      subtitle: Text('Qty: ${product.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() => _products.removeAt(index));
                        },
                      ),
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: _addProduct,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _discountValueController,
                        decoration: const InputDecoration(
                          labelText: 'Discount Value',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v?.trim().isEmpty == true) return 'Required';
                          if (double.tryParse(v!) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _discountType,
                        decoration: const InputDecoration(labelText: 'Type'),
                        items: const [
                          DropdownMenuItem(
                            value: 'flat',
                            child: Text('Flat (₹)'),
                          ),
                          DropdownMenuItem(
                            value: 'percentage',
                            child: Text('Percentage (%)'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _discountType = v ?? 'flat'),
                      ),
                    ),
                  ],
                ),
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
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _save,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  void _addProduct() async {
    final productController = AdminProductController.instance;
    if (productController.products.isEmpty) {
      await productController.loadInitial();
    }

    if (!mounted) return;

    final selected = await showDialog<_SelectedProduct>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Product'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              final product = productController.products[index];
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
                onTap: () => Navigator.pop(
                  context,
                  _SelectedProduct(
                    productId: product.productId ?? '',
                    productName: product.productName,
                    quantity: 1,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        _products.add(selected);
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_products.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least 2 products are required for a combo offer'),
        ),
      );
      return;
    }

    final offer = ComboOffer(
      comboId: widget.offer?.comboId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      comboProducts: _products
          .map(
            (p) => ComboProductItem(
              productId: p.productId,
              productName: p.productName,
              quantity: p.quantity,
            ),
          )
          .toList(),
      discountType: _discountType,
      discountValue: double.parse(_discountValueController.text),
      minQuantityPerProduct: 1,
      startDate: _startDate,
      endDate: _endDate,
      isActive: widget.offer?.isActive ?? true,
      priority: _priority,
      maxUsagePerUser: 0,
      usageCount: 0,
      createdAt: widget.offer?.createdAt ?? DateTime.now(),
    );

    setState(() => _isSubmitting = true);
    try {
      await widget.onSave(offer);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _SelectedProduct {
  final String productId;
  final String? productName;
  int quantity;

  _SelectedProduct({
    required this.productId,
    this.productName,
    this.quantity = 1,
  });
}
