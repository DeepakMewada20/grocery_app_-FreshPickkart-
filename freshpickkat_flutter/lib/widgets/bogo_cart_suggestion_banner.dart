import 'package:flutter/material.dart';
import 'package:freshpickkat_flutter/controller/bogo_controller.dart';
import 'package:freshpickkat_flutter/controller/cart_controller.dart';
import 'package:freshpickkat_flutter/screens/product_detail_screen.dart';
import 'package:freshpickkat_flutter/controller/theme_controller.dart';
import 'package:get/get.dart';

class BogoCartSuggestionBanner extends StatelessWidget {
  const BogoCartSuggestionBanner({super.key});

  bool _isMainShellVisible() {
    // This banner is mounted from GetMaterialApp.builder, whose context may
    // sit above the Navigator. Read navigator state from Get instead of
    // calling Navigator.of(context), which asserts in that setup.
    final navigatorState = Get.key.currentState;
    if (navigatorState == null) return false;
    return !navigatorState.canPop();
  }

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final bogoController = BogoController.instance;

    return Obx(() {
      final suggestion = cartController.bogoSuggestion.value;
      if (suggestion == null) {
        return const SizedBox.shrink();
      }
      final freeQuantityLabel = bogoController.freeProductQuantityLabel(
        suggestion.offer.triggerProductId,
        suggestion.freeProduct.productId ?? '',
        fallback: suggestion.freeProduct.quantity,
      );

      final offerTheme =
          Theme.of(context).extension<AppOfferTheme>() ??
          AppOfferTheme.fallback(Theme.of(context).brightness);
      final mediaQuery = MediaQuery.of(context);
      final isHomeShell = _isMainShellVisible();
      final bottomSpacing = isHomeShell ? 10.0 : 12.0;
      final bottomOffset =
          mediaQuery.viewPadding.bottom +
          mediaQuery.viewInsets.bottom +
          (isHomeShell ? kBottomNavigationBarHeight + bottomSpacing : bottomSpacing);

      return Positioned(
        left: 16,
        right: 16,
        bottom: bottomOffset,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Get.to(
                () => ProductDetailScreen(
                  product: suggestion.triggerProduct,
                ),
              );
            },
            child: Ink(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: offerTheme.badgeSoft,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: offerTheme.badgeBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: offerTheme.badge,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.card_giftcard_rounded,
                      color: offerTheme.onBadge,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Buy ${suggestion.triggerProduct.productName} to get ${suggestion.freeProduct.productName} ($freeQuantityLabel) free',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap to open the offer product.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.72),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: offerTheme.badge,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
