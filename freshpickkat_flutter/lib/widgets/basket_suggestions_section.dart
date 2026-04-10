import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart' as client;
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/utils/banner_navigation_helper.dart';
import 'package:freshpickkat_flutter/utils/price_extensions.dart';
import 'package:freshpickkat_flutter/widgets/basket_loading_animation.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Per-type config — ONE accent colour per type, everything else is neutral
// ─────────────────────────────────────────────────────────────────────────────
class _TypeConfig {
  final IconData icon;
  final Color accent;
  final String label;

  const _TypeConfig({
    required this.icon,
    required this.accent,
    required this.label,
  });
}

const _typeConfigs = <String, _TypeConfig>{
  'free_delivery': _TypeConfig(
    icon: Icons.local_shipping_rounded,
    accent: Color(0xFF1B8A4C), // green
    label: 'Free Delivery',
  ),
  'coupon': _TypeConfig(
    icon: Icons.confirmation_number_rounded,
    accent: Color(0xFFE6A23C), // amber
    label: 'Coupon',
  ),
  'bogo': _TypeConfig(
    icon: Icons.card_giftcard_rounded,
    accent: Color(0xFFE91E63), // pink
    label: 'Buy 1 Get 1',
  ),
  'combo': _TypeConfig(
    icon: Icons.layers_rounded,
    accent: Color(0xFF7B2FBE), // purple
    label: 'Combo Deal',
  ),
  'variant': _TypeConfig(
    icon: Icons.trending_up_rounded,
    accent: Color(0xFF1565C0), // blue
    label: 'Better Value',
  ),
};

_TypeConfig _cfgFor(String type) =>
    _typeConfigs[type] ??
    const _TypeConfig(
      icon: Icons.lightbulb_rounded,
      accent: Color(0xFF607D8B),
      label: 'Tip',
    );

// ─────────────────────────────────────────────────────────────────────────────
// Section
// ─────────────────────────────────────────────────────────────────────────────
class BasketSuggestionsSection extends StatelessWidget {
  const BasketSuggestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;
    return Obx(() {
      final suggestions = cart.basketSuggestions;
      final isLoading = cart.isBasketSuggestionsLoading.value;

      if (isLoading && suggestions.isEmpty) {
        return const SuggestionSkeletonSection();
      }
      if (suggestions.isEmpty) return const SizedBox.shrink();

      return SizedBox(
        // variant card is taller (has image + price rows)
        height: suggestions.any((s) => s.type == 'variant') ? 178 : 162,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: suggestions.length,
          itemBuilder: (context, i) =>
              _SuggestionCard(suggestion: suggestions[i], index: i),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated wrapper card — neutral white bg, coloured LEFT border stripe
// ─────────────────────────────────────────────────────────────────────────────
class _SuggestionCard extends StatefulWidget {
  const _SuggestionCard({required this.suggestion, required this.index});
  final client.BasketSuggestion suggestion;
  final int index;

  @override
  State<_SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<_SuggestionCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0.10, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.index * 70), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.suggestion;
    final cfg = _cfgFor(s.type);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Neutral card background — NO coloured tint
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final cardBorder = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: () => _onTap(s),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.80,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cardBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Coloured left accent stripe ─────────────────────────
                  Container(width: 4, color: cfg.accent),

                  // ── Card body ───────────────────────────────────────────
                  Expanded(
                    child: _bodyFor(s, cfg, isDark),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyFor(
    client.BasketSuggestion s,
    _TypeConfig cfg,
    bool isDark,
  ) {
    switch (s.type) {
      case 'combo':
        return _ComboBody(s: s, cfg: cfg, isDark: isDark);
      case 'variant':
        return _VariantBody(s: s, cfg: cfg, isDark: isDark);
      default:
        return _GenericBody(s: s, cfg: cfg, isDark: isDark);
    }
  }

  void _onTap(client.BasketSuggestion s) {
    HapticFeedback.lightImpact();
    if (s.type == 'combo' && s.comboId != null) {
      BannerNavigationHelper.navigate(
        client.Banner(
          bannerId: 'suggestion',
          type: 'combo',
          comboId: s.comboId,
          imageUrl: '',
          title: 'Combo Suggestion',
          screenPlacements: '',
          priority: 0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 1)),
          active: true,
          createdAt: DateTime.now(),
        ),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Generic body — free_delivery / coupon / bogo
// Layout: [TypeChip  SaveBadge]
//         [Message — max 2 lines]
//         [Spacer]
//         [ProgressBar + labels]   ← pinned to bottom
//         [Thumb  CTA]
// ─────────────────────────────────────────────────────────────────────────────
class _GenericBody extends StatelessWidget {
  const _GenericBody({
    required this.s,
    required this.cfg,
    required this.isDark,
  });
  final client.BasketSuggestion s;
  final _TypeConfig cfg;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;
    final textPrimary =
        isDark ? Colors.white.withValues(alpha: 0.92) : const Color(0xFF1C1C1E);
    final textSub =
        isDark ? Colors.white.withValues(alpha: 0.50) : const Color(0xFF6B6B6B);

    final progress = (s.progressTarget != null && s.progressTarget! > 0)
        ? (s.progressCurrent! / s.progressTarget!).clamp(0.0, 1.0)
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: type chip + save badge ───────────────────────────────
          Row(
            children: [
              _TypeChip(cfg: cfg, isDark: isDark),
              const Spacer(),
              if (s.savingAmount != null && s.savingAmount! > 0)
                _SaveBadge(amount: s.savingAmount!, accent: cfg.accent),
            ],
          ),

          const SizedBox(height: 8),

          // ── Row 2: message — always exactly 2-line slot ─────────────────
          Text(
            s.message,
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              height: 1.38,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // ── Row 3: progress — PINNED to bottom ──────────────────────────
          if (progress != null) ...[
            _ProgressBar(progress: progress, accent: cfg.accent, isDark: isDark),
            const SizedBox(height: 3),
            Row(
              children: [
                Text(
                  '₹${(s.progressCurrent ?? 0).formatPrice}',
                  style: TextStyle(
                    color: cfg.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ' / ₹${(s.progressTarget ?? 0).formatPrice}',
                  style:
                      TextStyle(color: textSub, fontSize: 10),
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: textSub,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
          ],

          // ── Row 4: thumbnail + CTA ───────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (s.thumbnailUrl != null && s.thumbnailUrl!.isNotEmpty)
                _ThumbSquare(url: s.thumbnailUrl!),
              const Spacer(),
              if (_showCTA(s.type))
                _CTAButton(
                  label: s.ctaLabel ?? 'Add',
                  accent: cfg.accent,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    cart.applyBasketSuggestion(s);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _showCTA(String t) => t == 'bogo' || t == 'combo' || t == 'variant';
}

// ─────────────────────────────────────────────────────────────────────────────
// Combo body
// Layout: [TypeChip  SaveBadge]
//         [ALL product names — 1 big bold title line]
//         [Spacer]
//         [Overlapping images  CTA]
// ─────────────────────────────────────────────────────────────────────────────
class _ComboBody extends StatelessWidget {
  const _ComboBody({required this.s, required this.cfg, required this.isDark});
  final client.BasketSuggestion s;
  final _TypeConfig cfg;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;
    final textPrimary =
        isDark ? Colors.white.withValues(alpha: 0.92) : const Color(0xFF1C1C1E);
    final textSub =
        isDark ? Colors.white.withValues(alpha: 0.50) : const Color(0xFF6B6B6B);

    // Build a single title from all product names stored in metadata
    final productNames = (s.metadata?['comboProductIds'] ?? '')
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .length;
    // The server already encodes names in the message — we build a short
    // all-product title from comboName + savings line
    final allNames = _buildTitle();

    final imageUrls = (s.metadata?['comboImageUrls'] ?? '')
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .toList();
    final allImages = imageUrls.isNotEmpty
        ? imageUrls
        : (s.thumbnailUrl != null && s.thumbnailUrl!.isNotEmpty
            ? [s.thumbnailUrl!]
            : <String>[]);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              _TypeChip(cfg: cfg, isDark: isDark),
              const Spacer(),
              if (s.savingAmount != null && s.savingAmount! > 0)
                _SaveBadge(amount: s.savingAmount!, accent: cfg.accent),
            ],
          ),

          const SizedBox(height: 8),

          // ── Single bold title with all product names ─────────────────────
          Text(
            allNames,
            style: TextStyle(
              color: textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 14,
              height: 1.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // ── Subtitle: savings line ───────────────────────────────────────
          if (s.savingAmount != null && s.savingAmount! > 0)
            Text(
              'Bundle & save ₹${s.savingAmount!.formatPrice} on this combo',
              style: TextStyle(
                color: textSub,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

          const Spacer(),

          // ── Images + CTA ─────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (allImages.isNotEmpty)
                _OverlappingImages(
                  urls: allImages,
                  accent: cfg.accent,
                  totalCount: productNames > 0 ? productNames : allImages.length,
                ),
              const Spacer(),
              _CTAButton(
                label: s.ctaLabel ?? 'Add Bundle',
                accent: cfg.accent,
                onTap: () {
                  HapticFeedback.mediumImpact();
                  cart.applyBasketSuggestion(s);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build a single merged title from message text (extract product names)
  // e.g message: "Bundle Milk + Bread & save ₹30"  → "Milk + Bread"
  // Fallback to comboName from metadata
  String _buildTitle() {
    final msg = s.message;
    // Try to extract the part before " & save"
    final saveIdx = msg.indexOf(' & save');
    if (saveIdx > 0) {
      var title = msg.substring(0, saveIdx);
      // Remove leading "Bundle " prefix if present
      if (title.startsWith('Bundle ')) title = title.substring('Bundle '.length);
      return title;
    }
    return s.metadata?['comboName'] ?? 'Combo Offer';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Variant body
// Layout: [TypeChip  SaveBadge]
//         [Product image | Pack A ₹xx  →  Pack B ₹yy  (show more?)]
//         [Spacer]
//         [CTA]
// ─────────────────────────────────────────────────────────────────────────────
class _VariantBody extends StatelessWidget {
  const _VariantBody({required this.s, required this.cfg, required this.isDark});
  final client.BasketSuggestion s;
  final _TypeConfig cfg;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;
    final textPrimary =
        isDark ? Colors.white.withValues(alpha: 0.92) : const Color(0xFF1C1C1E);
    final textSub =
        isDark ? Colors.white.withValues(alpha: 0.50) : const Color(0xFF6B6B6B);

    final curLabel = s.metadata?['currentVariantLabel'] ?? '';
    final curPrice = s.metadata?['currentVariantPrice'] ?? '';
    final tgtLabel = s.metadata?['targetVariantLabel'] ?? '';
    final tgtPrice = s.metadata?['targetVariantPrice'] ?? '';
    final totalCount = int.tryParse(s.metadata?['totalVariantCount'] ?? '2') ?? 2;
    final hasMore = totalCount > 2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            children: [
              _TypeChip(cfg: cfg, isDark: isDark),
              const Spacer(),
              if (s.savingAmount != null && s.savingAmount! > 0)
                _SaveBadge(amount: s.savingAmount!, accent: cfg.accent),
            ],
          ),

          const SizedBox(height: 8),

          // ── Image + Price comparison row ─────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product image
              if (s.thumbnailUrl != null && s.thumbnailUrl!.isNotEmpty) ...[
                _ThumbSquare(url: s.thumbnailUrl!, size: 44),
                const SizedBox(width: 10),
              ],

              // Pack A
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      curLabel,
                      style: TextStyle(
                        color: textSub,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '₹$curPrice',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: cfg.accent,
                  size: 18,
                ),
              ),

              // Pack B (upgrade)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tgtLabel,
                      style: TextStyle(
                        color: cfg.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '₹$tgtPrice',
                      style: TextStyle(
                        color: cfg.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ── "Show more packs" if there are more than 2 variants ──────────
          if (hasMore)
            Text(
              'Show more packs (${totalCount - 2} more)',
              style: TextStyle(
                color: cfg.accent,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: cfg.accent,
              ),
            ),

          const Spacer(),

          // ── CTA ──────────────────────────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: _CTAButton(
              label: s.ctaLabel ?? 'Upgrade',
              accent: cfg.accent,
              onTap: () {
                HapticFeedback.mediumImpact();
                cart.applyBasketSuggestion(s);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Type chip — flat, minimal color
// ─────────────────────────────────────────────────────────────────────────────
class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.cfg, required this.isDark});
  final _TypeConfig cfg;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: cfg.accent.withValues(alpha: isDark ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(cfg.icon, color: cfg.accent, size: 11),
          const SizedBox(width: 4),
          Text(
            cfg.label,
            style: TextStyle(
              color: cfg.accent,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Save badge — BIGGER and prominent
// ─────────────────────────────────────────────────────────────────────────────
class _SaveBadge extends StatelessWidget {
  const _SaveBadge({required this.amount, required this.accent});
  final double amount;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Save ₹${amount.formatPrice}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,        // ← bigger
          fontWeight: FontWeight.w800,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated progress bar
// ─────────────────────────────────────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.progress,
    required this.accent,
    required this.isDark,
  });
  final double progress;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final trackColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.07);
    final fillColor =
        progress >= 0.85 ? const Color(0xFFFF6D00) : accent;

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: progress),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) {
          return Stack(
            children: [
              Container(height: 6, color: trackColor),
              LayoutBuilder(
                builder: (context, c) => Container(
                  height: 6,
                  width: c.maxWidth * value,
                  color: fillColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Square thumbnail (generic)
// ─────────────────────────────────────────────────────────────────────────────
class _ThumbSquare extends StatelessWidget {
  const _ThumbSquare({required this.url, this.size = 36});
  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: const Color(0xFFF0F0F0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, _) =>
              const Icon(Icons.image_not_supported_rounded, size: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Overlapping circle images (combo)
// ─────────────────────────────────────────────────────────────────────────────
class _OverlappingImages extends StatelessWidget {
  const _OverlappingImages({
    required this.urls,
    required this.accent,
    required this.totalCount,
  });
  final List<String> urls;
  final Color accent;
  final int totalCount;

  static const double _sz = 34.0;
  static const double _overlap = 10.0;
  static const int _maxVis = 4;

  @override
  Widget build(BuildContext context) {
    final vis = urls.take(_maxVis).toList();
    final extra = totalCount - vis.length;
    final w = _sz + (_sz - _overlap) * (vis.length - 1) + (extra > 0 ? _sz - _overlap : 0);

    return SizedBox(
      width: w,
      height: _sz,
      child: Stack(
        children: [
          ...List.generate(vis.length, (i) => Positioned(
            left: i * (_sz - _overlap),
            child: _CircleImg(url: vis[i], accent: accent, size: _sz),
          )),
          if (extra > 0)
            Positioned(
              left: vis.length * (_sz - _overlap),
              child: Container(
                width: _sz,
                height: _sz,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.12),
                  border: Border.all(
                      color: accent.withValues(alpha: 0.35), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: TextStyle(
                        color: accent, fontSize: 10, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleImg extends StatelessWidget {
  const _CircleImg({required this.url, required this.accent, required this.size});
  final String url;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 4,
              offset: const Offset(0, 1)),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, _) =>
              Icon(Icons.inventory_2_rounded, color: accent, size: size * 0.45),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CTA button — flat accent colour, no gradient
// ─────────────────────────────────────────────────────────────────────────────
class _CTAButton extends StatelessWidget {
  const _CTAButton({
    required this.label,
    required this.accent,
    required this.onTap,
  });
  final String label;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 13),
          ],
        ),
      ),
    );
  }
}
