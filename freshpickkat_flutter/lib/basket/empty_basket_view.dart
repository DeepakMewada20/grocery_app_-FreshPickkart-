import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card.dart';
import 'package:freshpickkat_flutter/controller/product_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/tab_navigation_controller.dart';
import 'package:freshpickkat_flutter/screens/category_item_screen.dart' deferred as categoryItemScreen;
import 'package:freshpickkat_flutter/utils/deferred_navigation.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/utils/product_variant_utils.dart';
import 'package:freshpickkat_flutter/utils/responsive.dart';
import 'package:freshpickkat_flutter/utils/suggestion_navigation_helper.dart';
import 'package:freshpickkat_flutter/widgets/product_offer_badge.dart';
import 'package:freshpickkat_flutter/widgets/safe_network_image.dart';
import 'package:get/get.dart';

class EmptyBasketView extends StatelessWidget {
  const EmptyBasketView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;
    final categories = CategoryProviderController.instance.categories;
    final cs = Theme.of(context).colorScheme;

    return Obx(() {
      final best = cart.bestBasketSuggestion.value;
      final suggestions =
          cart.isBasketSuggestionsLoading.value &&
              cart.oldBasketSuggestions.isNotEmpty
          ? cart.oldBasketSuggestions.toList()
          : cart.basketSuggestions.toList();
      final products = ProductProviderController.instance.allProducts;
      final productMap = {
        for (final product in products)
          if (product.productId != null) product.productId!: product,
      };
      final allSuggestions = best == null
          ? <client.BasketSuggestion>[...suggestions]
          : <client.BasketSuggestion>[best, ...suggestions];
      final reorderSuggestions = _bestSuggestions(
        allSuggestions.where((suggestion) => suggestion.type == 'reorder'),
        limit: 5,
      );
      final reorderIds = reorderSuggestions
          .map((suggestion) => suggestion.id)
          .whereType<String>()
          .toSet();
      final topPickSuggestions = _bestSuggestions(
        allSuggestions
            .where((s) => s.type != 'reorder')
            .where((s) => !reorderIds.contains(s.id))
            .toList(),
        limit: 4,
      );
      final highlightedTopPicks = topPickSuggestions.isEmpty
          ? topPickSuggestions
          : topPickSuggestions
                .asMap()
                .entries
                .map((entry) {
                  if (entry.key != 0) return entry.value;
                  return entry.value.copyWith(isBest: true);
                })
                .toList(growable: false);
      final offerSuggestion = _firstMatching(
        allSuggestions,
        (s) =>
            s.type == 'delivery' ||
            s.type == 'coupon' ||
            s.type == 'combined' ||
            s.type == 'combo' ||
            s.type == 'bogo',
      );

      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeroSection(colorScheme: cs),
            const SizedBox(height: 16),
            if (reorderSuggestions.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SectionHeader(
                title: 'Buy again',
                subtitle: 'One tap to restock what you already like',
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 196,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: reorderSuggestions.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 184,
                      child: _BuyAgainCard(
                        suggestion: reorderSuggestions[index],
                        productMap: productMap,
                      ),
                    );
                  },
                ),
              ),
            ],
            if (topPickSuggestions.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SectionHeader(
                title: 'Top picks',
                subtitle: 'Selected from live offers and popular products',
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: highlightedTopPicks.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return SuggestionCard(
                      suggestion: highlightedTopPicks[index],
                      index: index,
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
            _SectionHeader(
              title: 'Browse categories',
              subtitle: 'Jump straight into a fresh aisle',
            ),
            const SizedBox(height: 10),
            _CategoryChips(categories: categories),
            if (offerSuggestion != null) ...[
              const SizedBox(height: 20),
              _SectionHeader(
                title: 'Live offer',
                subtitle: 'A server-driven offer worth checking',
              ),
              const SizedBox(height: 10),
              _OfferBanner(
                suggestion: offerSuggestion,
                colorScheme: cs,
              ),
            ],
            const SizedBox(height: 18),
            _TrustLine(colorScheme: cs),
          ],
        ),
      );
    });
  }

  client.BasketSuggestion? _firstMatching(
    List<client.BasketSuggestion> suggestions,
    bool Function(client.BasketSuggestion suggestion) predicate,
  ) {
    for (final suggestion in suggestions) {
      if (predicate(suggestion)) return suggestion;
    }
    return null;
  }

  List<client.BasketSuggestion> _bestSuggestions(
    Iterable<client.BasketSuggestion> suggestions, {
    required int limit,
  }) {
    final list = suggestions.toList(growable: false);
    if (list.isEmpty) return const <client.BasketSuggestion>[];
    list.sort((a, b) {
      final rankA = a.rank ?? 1 << 20;
      final rankB = b.rank ?? 1 << 20;
      final rankCompare = rankA.compareTo(rankB);
      if (rankCompare != 0) return rankCompare;
      final scoreA = a.score ?? 0;
      final scoreB = b.score ?? 0;
      final scoreCompare = scoreB.compareTo(scoreA);
      if (scoreCompare != 0) return scoreCompare;
      return (a.title ?? a.message).compareTo(b.title ?? b.message);
    });
    if (list.length <= limit) return list;
    return list.take(limit).toList(growable: false);
  }
}

class _HeroSection extends StatelessWidget {
  final ColorScheme colorScheme;

  const _HeroSection({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.surfaceContainerHighest,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Image.asset(
            'lib/assets/images/delivery_scooter.png',
            height: 140,
          ),
          const SizedBox(height: 16),
          Text(
            'Your basket is empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add essentials, fresh produce, and a few smart deals to get fast delivery.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () {
              TabNavigationController.instance.navigateToCategories();
            },
            child: const Text('Explore Products'),
          ),
        ],
      ),
    );
  }
}

class _OfferBanner extends StatelessWidget {
  final client.BasketSuggestion suggestion;
  final ColorScheme colorScheme;

  const _OfferBanner({
    required this.suggestion,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final title = suggestion.title ?? suggestion.message;
    final subtitle = suggestion.subtitle ?? suggestion.message;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF0F6B42).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _iconForType(suggestion.type),
              color: const Color(0xFF0F6B42),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.72),
                    fontSize: 12.5,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'coupon':
        return Icons.confirmation_number_rounded;
      case 'delivery':
        return Icons.local_shipping_rounded;
      case 'combo':
        return Icons.layers_rounded;
      case 'bogo':
        return Icons.card_giftcard_rounded;
      case 'category':
        return Icons.category_rounded;
      default:
        return Icons.local_offer_rounded;
    }
  }
}

class _CategoryChips extends StatelessWidget {
  final List<client.Category> categories;

  const _CategoryChips({required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Text(
        'Categories will appear here once they are loaded.',
        style: TextStyle(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.55),
          fontSize: 12.5,
        ),
      );
    }

    final items = categories.take(6).toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: AppResponsive.categoryGridDelegate(
            context,
            constraints.maxWidth,
          ),
          itemBuilder: (context, index) {
            return _CategoryTile(category: items[index]);
          },
        );
      },
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final client.Category category;

  const _CategoryTile({required this.category});

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  Future<void> _handleTapUp(TapUpDetails details) async {
    _controller.reverse();
    await navigateDeferred(
      loadLibrary: categoryItemScreen.loadLibrary,
      pageBuilder: () => categoryItemScreen.CategoryItemsScreen(
        categoryName: widget.category.categoryName,
        subCategoryGroupName: 'All',
      ),
    );
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SafeNetworkImage(
                      url: widget.category.categoryImageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              widget.category.categoryName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuyAgainCard extends StatelessWidget {
  final client.BasketSuggestion suggestion;
  final Map<String, client.Product> productMap;

  const _BuyAgainCard({
    required this.suggestion,
    required this.productMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayProduct = _resolveDisplayProduct();
    final imageUrl = displayProduct?.imageUrl ?? suggestion.thumbnailUrl;
    final title =
        displayProduct?.productName ?? suggestion.title ?? suggestion.message;
    final quantityLabel = displayProduct != null
        ? productFullQuantityLabel(displayProduct)
        : (suggestion.subtitle?.trim().isNotEmpty == true
              ? suggestion.subtitle!
              : 'Previously ordered');
    final hasOffer = displayProduct != null && hasProductOffer(displayProduct);
    final showMrp =
        displayProduct != null &&
        displayProduct.realPrice > displayProduct.price;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => SuggestionNavigationHelper.handleTap(suggestion),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.72,
                ),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.9),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 82,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: imageUrl == null || imageUrl.isEmpty
                          ? Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 30,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          : SafeNetworkImage(
                              url: imageUrl,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  if (hasOffer)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: ProductOfferBadge(
                        product: displayProduct,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        fontSize: 9,
                        borderRadius: 10,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 12.8,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                quantityLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
                  fontSize: 10.5,
                ),
              ),
              const Spacer(),
              if (displayProduct != null) ...[
                Row(
                  children: [
                    Text(
                      '₹${displayProduct.price.formatPrice}',
                      style: TextStyle(
                        color: const Color(0xFF0F6B42),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (showMrp) ...[
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '₹${displayProduct.realPrice.formatPrice}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                            fontSize: 10.2,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: theme.colorScheme.onSurface
                                .withValues(
                                  alpha: 0.35,
                                ),
                          ),
                        ),
                      ),
                    ] else
                      const Spacer(),
                  ],
                ),
              ] else
                Text(
                  'Previously ordered',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                    fontSize: 10.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  client.Product? _resolveDisplayProduct() {
    final productId = suggestion.productId?.trim();
    if (productId == null || productId.isEmpty) return null;
    final product = productMap[productId];
    if (product == null) return null;
    return applyVariantToProduct(product, variantId: suggestion.variantId);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: cs.onSurface,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.6),
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}

class _TrustLine extends StatelessWidget {
  final ColorScheme colorScheme;

  const _TrustLine({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 18,
            color: colorScheme.onSurface.withValues(alpha: 0.65),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Fast delivery in 30 mins',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w700,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
