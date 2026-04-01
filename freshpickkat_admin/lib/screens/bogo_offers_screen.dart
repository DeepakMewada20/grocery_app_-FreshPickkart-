import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_admin/controller/admin_offer_controller/admin_bogo_controller.dart';
import 'package:freshpickkat_admin/controller/admin_product_controller.dart';
import 'package:freshpickkat_admin/screens/bogo_product_picker_screen.dart';
import 'package:freshpickkat_admin/services/admin_session_service.dart';
import 'package:freshpickkat_admin/services/serverpod_client.dart';
import 'package:freshpickkat_admin/widgets/catalog_widgets/catalog_shared_widgets.dart';
import '../widgets/network_error_widget.dart';

class BogoOffersScreen extends StatefulWidget {
  const BogoOffersScreen({super.key});

  @override
  State<BogoOffersScreen> createState() => _BogoOffersScreenState();
}

class _BogoOffersScreenState extends State<BogoOffersScreen>
    with AutomaticKeepAliveClientMixin {
  final AdminBogoController _controller = AdminBogoController.instance;
  final AdminProductController _productController =
      AdminProductController.instance;
  final Map<String, Product> _resolvedTriggerProductsById = {};
  String _searchQuery = '';
  bool _isResolvingTriggerProducts = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_productController.products.isEmpty) {
        _productController.loadInitial();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        onPressed: _showAddBogoScreen,
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

              _scheduleTriggerProductResolution(_controller.bogoOffers);

              final bogoOffers = _controller.bogoOffers
                  .where(
                    (o) =>
                        o.offerTitle.toLowerCase().contains(_searchQuery) ||
                        o.triggerProductId.toLowerCase().contains(_searchQuery),
                  )
                  .toList();
              final activeCount = bogoOffers.where((offer) => offer.isActive).length;
              final inactiveCount = bogoOffers.length - activeCount;
              final liveCount = bogoOffers.where((offer) {
                final now = DateTime.now();
                return offer.isActive &&
                    !offer.startDate.isAfter(now) &&
                    !offer.endDate.isBefore(now);
              }).length;

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

              return ListView(
                padding: const EdgeInsets.only(bottom: 88),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                    child: SizedBox(
                      height: 96,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          CatalogStatCard(
                            title: 'All BOGO',
                            value: '${bogoOffers.length}',
                            icon: Icons.card_giftcard,
                            color: const Color(0xFFB45309),
                            breakdown: [
                              CatalogStatBreakdown(
                                label: 'Active',
                                value: '$activeCount',
                                color: Colors.green.shade700,
                              ),
                              CatalogStatBreakdown(
                                label: 'Inactive',
                                value: '$inactiveCount',
                                color: Colors.redAccent.shade200,
                              ),
                            ],
                            compact: true,
                          ),
                          const SizedBox(width: 10),
                          CatalogStatCard(
                            title: 'Live Now',
                            value: '$liveCount',
                            icon: Icons.bolt_rounded,
                            color: const Color(0xFF0F766E),
                            compact: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...bogoOffers.map((offer) {
                    return _BogoOfferCard(
                      offer: offer,
                      resolvedTriggerProduct:
                          _resolvedTriggerProductsById[offer.triggerProductId],
                      onToggle: (isActive) => _toggleBogoOffer(offer, isActive),
                      onEdit: () => _showEditBogoScreen(offer),
                      onDelete: () => _showDeleteConfirmation(offer),
                    );
                  }),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _scheduleTriggerProductResolution(List<BogoOffer> offers) {
    if (_isResolvingTriggerProducts || offers.isEmpty) return;

    final knownIds = {
      for (final product in _productController.products)
        if (product.productId != null) product.productId!,
      ..._resolvedTriggerProductsById.keys,
    };
    final missingIds = offers
        .map((offer) => offer.triggerProductId.trim())
        .where((id) => id.isNotEmpty && !knownIds.contains(id))
        .toSet();

    if (missingIds.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _resolveMissingTriggerProducts(missingIds);
    });
  }

  Future<void> _resolveMissingTriggerProducts(Set<String> missingIds) async {
    if (_isResolvingTriggerProducts || missingIds.isEmpty) return;

    _isResolvingTriggerProducts = true;
    try {
      final uid = AdminSessionService.requireUid();
      final idToken = await AdminSessionService.requireIdToken(
        forceRefresh: true,
      );

      final resolved = <String, Product>{};
      String? pageToken;

      do {
        final page = await ServerpodAdminClient().client.product.getProductsPage(
          firebaseUid: uid,
          idToken: idToken,
          sortBy: 'name',
          limit: 100,
          pageToken: pageToken,
        );

        for (final product in page.products) {
          final productId = product.productId;
          if (productId != null && missingIds.contains(productId)) {
            resolved[productId] = product;
          }
        }

        if (resolved.length == missingIds.length) break;
        pageToken = page.nextPageToken;
      } while (pageToken != null);

      if (!mounted || resolved.isEmpty) return;
      setState(() {
        _resolvedTriggerProductsById.addAll(resolved);
      });
    } catch (_) {
      // Keep the fallback ID display when product resolution fails.
    } finally {
      _isResolvingTriggerProducts = false;
    }
  }

  Future<void> _toggleBogoOffer(BogoOffer offer, bool isActive) async {
    final updatedOffer = offer.copyWith(isActive: isActive);
    final success = await _controller.upsertOffer(updatedOffer);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'BOGO offer ${isActive ? 'activated' : 'deactivated'}',
          ),
        ),
      );
    } else if (!success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error toggling BOGO offer')));
    }
  }

  Future<void> _showAddBogoScreen() async {
    final saved = await BogoOfferEditorScreen.show(
      context: context,
      onSave: (offer) => _controller.upsertOffer(offer),
    );
    if (saved != true || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('BOGO offer created successfully')),
    );
  }

  Future<void> _showEditBogoScreen(BogoOffer offer) async {
    final saved = await BogoOfferEditorScreen.show(
      context: context,
      offer: offer,
      onSave: (updated) => _controller.upsertOffer(updated),
    );
    if (saved != true || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('BOGO offer updated successfully')),
    );
  }

  void _showDeleteConfirmation(BogoOffer offer) {
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (context) {
        var isDeleting = false;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Delete BOGO Offer'),
            content: Text(
              'Are you sure you want to delete this BOGO offer?',
            ),
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
                        final success = await _controller.deleteOffer(
                          offer.triggerProductId,
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        if (success && mounted) {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('BOGO offer deleted')),
                          );
                        } else if (!success && mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Error deleting BOGO offer'),
                            ),
                          );
                        }
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

class _BogoOfferCard extends StatelessWidget {
  final BogoOffer offer;
  final Product? resolvedTriggerProduct;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BogoOfferCard({
    required this.offer,
    this.resolvedTriggerProduct,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isValid = offer.startDate.isBefore(now) && offer.endDate.isAfter(now);

    Product? triggerProduct = resolvedTriggerProduct;
    try {
      triggerProduct ??= AdminProductController.instance.products.firstWhere(
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
          'Buy 1 Get 1 Free',
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
