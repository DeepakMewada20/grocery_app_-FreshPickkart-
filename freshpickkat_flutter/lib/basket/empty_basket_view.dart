import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/basket/cart_controller.dart';
import 'package:freshpickkat_flutter/basket/suggestions/suggestion_card.dart';
import 'package:freshpickkat_flutter/controller/category_provider_controller.dart';
import 'package:freshpickkat_flutter/controller/tab_navigation_controller.dart';
import 'package:freshpickkat_flutter/screens/category_item_screen.dart';
import 'package:freshpickkat_flutter/utils/suggestion_navigation_helper.dart';
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
      final suggestions = cart.basketSuggestions.toList();
      final allSuggestions = <client.BasketSuggestion>[...suggestions];
      if (best != null) {
        allSuggestions.insert(0, best);
      }
      final reorderSuggestions = allSuggestions
          .where((suggestion) => suggestion.type == 'reorder')
          .take(5)
          .toList();
      final carouselSuggestions = allSuggestions
          .where((suggestion) => suggestion.type != 'reorder')
          .take(4)
          .toList();
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
            _PrimaryCta(
              colorScheme: cs,
              onTap: TabNavigationController.instance.navigateToCategories,
            ),
            if (reorderSuggestions.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SectionHeader(
                title: 'Buy again',
                subtitle: 'One tap to restock what you already like',
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 206,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: reorderSuggestions.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 220,
                      child: _BuyAgainCard(
                        suggestion: reorderSuggestions[index],
                      ),
                    );
                  },
                ),
              ),
            ],
            if (best != null) ...[
              const SizedBox(height: 20),
              _SectionHeader(
                title: 'Best suggestion',
                subtitle: 'The strongest next move for this basket',
              ),
              const SizedBox(height: 10),
              _BestSuggestionBanner(
                suggestion: best,
                colorScheme: cs,
              ),
            ],
            if (carouselSuggestions.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SectionHeader(
                title: 'Top picks',
                subtitle: 'Selected from live offers and popular products',
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 196,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: carouselSuggestions.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return SuggestionCard(
                      suggestion: carouselSuggestions[index],
                      index: index,
                      width: 230,
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 20),
            _SectionHeader(
              title: 'Quick categories',
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
}

class _HeroSection extends StatelessWidget {
  final ColorScheme colorScheme;

  const _HeroSection({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F6B42), Color(0xFF12A06B), Color(0xFFB5E48C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F6B42).withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -18,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.shopping_basket_outlined,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your basket is empty 😅',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Start from smart picks, live offers, and your usual buys.',
                      style: TextStyle(
                        color: colorScheme.onPrimary.withValues(alpha: 0.9),
                        fontSize: 14,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const _PrimaryCta({
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F6B42).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  color: Color(0xFF0F6B42),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore Products',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Browse categories, search products, or jump into offers.',
                      style: TextStyle(fontSize: 12.5, height: 1.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.55),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BestSuggestionBanner extends StatelessWidget {
  final client.BasketSuggestion suggestion;
  final ColorScheme colorScheme;

  const _BestSuggestionBanner({
    required this.suggestion,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final title = suggestion.title ?? suggestion.message;
    final subtitle = suggestion.subtitle ?? suggestion.message;
    final actionLabel = suggestion.action?.ctaLabel ??
        (suggestion.actions?.isNotEmpty == true
            ? suggestion.actions!.first.ctaLabel
            : 'Open');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => SuggestionNavigationHelper.handleTap(suggestion),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E8E59),
                const Color(0xFF2BB673).withValues(alpha: 0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E8E59).withValues(alpha: 0.22),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  _iconForType(suggestion.type),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: colorScheme.onPrimary.withValues(alpha: 0.9),
                        fontSize: 13,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _BannerActionPill(label: actionLabel.toUpperCase()),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      case 'reorder':
        return Icons.replay_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
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
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
          fontSize: 12.5,
        ),
      );
    }

    final items = categories.take(6).toList();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((category) {
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Get.to(
              () => CategoryItemsScreen(
                categoryName: category.categoryName,
                subCategoryGroupName: 'All',
              ),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 260),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.62),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F6B42).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.category_rounded,
                    size: 16,
                    color: Color(0xFF0F6B42),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  category.categoryName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _BuyAgainCard extends StatelessWidget {
  final client.BasketSuggestion suggestion;

  const _BuyAgainCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final imageUrl = suggestion.thumbnailUrl;
    final action = suggestion.action ??
        (suggestion.actions?.isNotEmpty == true
            ? suggestion.actions!.first
            : null);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => SuggestionNavigationHelper.handleTap(suggestion),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: imageUrl == null || imageUrl.isEmpty
                          ? const Icon(Icons.shopping_bag_outlined)
                          : Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  const Icon(Icons.shopping_bag_outlined),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestion.title ?? suggestion.message,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          suggestion.subtitle ?? 'Frequently bought',
                          style: TextStyle(
                            color: colorScheme.onSurface.withValues(alpha: 0.68),
                            fontSize: 11.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  if (action != null)
                    Expanded(
                      child: Text(
                        action.ctaLabel.toUpperCase(),
                        style: TextStyle(
                          color: const Color(0xFF0F6B42),
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: const Color(0xFF0F6B42).withValues(alpha: 0.9),
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerActionPill extends StatelessWidget {
  final String label;

  const _BannerActionPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 11,
          letterSpacing: 0.3,
        ),
      ),
    );
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
