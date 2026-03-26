import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller.dart';
import 'package:freshpickkat_admin/controller/admin_category_controller.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class CategoryOffersScreen extends StatefulWidget {
  const CategoryOffersScreen({super.key});

  @override
  State<CategoryOffersScreen> createState() => _CategoryOffersScreenState();
}

class _CategoryOffersScreenState extends State<CategoryOffersScreen> {
  final AdminOfferController _controller = AdminOfferController.instance;
  final AdminCategoryController _categoryController =
      AdminCategoryController.instance;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadCategoryOffers();
      _categoryController.loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Offers'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.loadCategoryOffers(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddOfferDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Category Offer'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search category offers...',
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
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final offers = _controller.categoryOffers
                  .where((o) => o.name.toLowerCase().contains(_searchQuery))
                  .toList();

              if (offers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No category offers found',
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
                  return _CategoryOfferCard(
                    offer: offer,
                    onToggle: (isActive) => _controller.toggleCategoryOffer(
                      offer.offerId ?? '',
                      isActive,
                    ),
                    onEdit: () => _showEditOfferDialog(offer),
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

  void _showAddOfferDialog() {
    showDialog(
      context: context,
      builder: (context) => _CategoryOfferDialog(
        onSave: (offer) async {
          await _controller.createCategoryOffer(offer);
        },
      ),
    );
  }

  void _showEditOfferDialog(CategoryOffer offer) {
    showDialog(
      context: context,
      builder: (context) => _CategoryOfferDialog(
        offer: offer,
        onSave: (updated) async {
          await _controller.updateCategoryOffer(updated);
        },
      ),
    );
  }

  void _showDeleteConfirmation(CategoryOffer offer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category Offer'),
        content: Text('Are you sure you want to delete "${offer.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _controller.deleteCategoryOffer(offer.offerId ?? '');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _CategoryOfferCard extends StatelessWidget {
  final CategoryOffer offer;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryOfferCard({
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
              ? Colors.purple[100]
              : Colors.grey[300],
          child: Icon(
            Icons.category,
            color: offer.isActive ? Colors.purple : Colors.grey,
          ),
        ),
        title: Text(
          offer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${offer.categoryName ?? offer.categoryId}'),
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
                if (offer.maxDiscount != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    'Max ₹${offer.maxDiscount!.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
                if (isValid) ...[
                  const SizedBox(width: 8),
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

class _CategoryOfferDialog extends StatefulWidget {
  final CategoryOffer? offer;
  final Function(CategoryOffer) onSave;

  const _CategoryOfferDialog({this.offer, required this.onSave});

  @override
  State<_CategoryOfferDialog> createState() => _CategoryOfferDialogState();
}

class _CategoryOfferDialogState extends State<_CategoryOfferDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountValueController = TextEditingController();
  final _maxDiscountController = TextEditingController();
  final _minOrderController = TextEditingController();

  String _discountType = 'percentage';
  String? _selectedCategoryId;
  int _priority = 0;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  bool get isEditing => widget.offer != null;

  @override
  void initState() {
    super.initState();
    if (widget.offer != null) {
      _nameController.text = widget.offer!.name;
      _descriptionController.text = widget.offer!.description ?? '';
      _discountValueController.text = widget.offer!.discountValue.toString();
      _discountType = widget.offer!.discountType;
      _selectedCategoryId = widget.offer!.categoryId;
      _priority = widget.offer!.priority;
      _startDate = widget.offer!.startDate;
      _endDate = widget.offer!.endDate;
      if (widget.offer!.maxDiscount != null) {
        _maxDiscountController.text = widget.offer!.maxDiscount.toString();
      }
      if (widget.offer!.minOrderAmount != null) {
        _minOrderController.text = widget.offer!.minOrderAmount.toString();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _maxDiscountController.dispose();
    _minOrderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = AdminCategoryController.instance.categories;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Category Offer' : 'Add Category Offer'),
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
                    hintText: 'e.g., Fruits Festival',
                  ),
                  validator: (v) =>
                      v?.trim().isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.categoryName,
                          child: Text(c.categoryName),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCategoryId = v),
                  validator: (v) => v == null ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _discountValueController,
                        decoration: InputDecoration(
                          labelText: _discountType == 'percentage'
                              ? 'Discount %'
                              : 'Discount (₹)',
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
                            value: 'percentage',
                            child: Text('Percentage (%)'),
                          ),
                          DropdownMenuItem(
                            value: 'flat',
                            child: Text('Flat (₹)'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _discountType = v ?? 'percentage'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _maxDiscountController,
                        decoration: const InputDecoration(
                          labelText: 'Max Discount (₹)',
                          hintText: 'Optional',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _minOrderController,
                        decoration: const InputDecoration(
                          labelText: 'Min Order (₹)',
                          hintText: 'Optional',
                        ),
                        keyboardType: TextInputType.number,
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

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a category')));
      return;
    }

    final offer = CategoryOffer(
      offerId: widget.offer?.offerId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      categoryId: _selectedCategoryId!,
      categoryName: _selectedCategoryId,
      discountType: _discountType,
      discountValue: double.parse(_discountValueController.text),
      maxDiscount: _maxDiscountController.text.isNotEmpty
          ? double.parse(_maxDiscountController.text)
          : null,
      minOrderAmount: _minOrderController.text.isNotEmpty
          ? double.parse(_minOrderController.text)
          : null,
      startDate: _startDate,
      endDate: _endDate,
      isActive: widget.offer?.isActive ?? true,
      priority: _priority,
      createdAt: widget.offer?.createdAt ?? DateTime.now(),
    );

    await widget.onSave(offer);
    if (mounted) Navigator.pop(context);
  }
}
