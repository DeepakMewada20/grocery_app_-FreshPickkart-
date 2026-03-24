import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';

bool isBogoProduct(Product product) {
  return product.discountType?.toLowerCase().trim() == 'bogo' &&
      (product.bogoFreeProductIds?.isNotEmpty ?? false);
}

bool hasProductOffer(Product product) {
  if (isBogoProduct(product)) return true;
  return _resolveOfferValue(product) > 0;
}

String buildProductOfferLabel(Product product) {
  if (isBogoProduct(product)) {
    return 'BUY 1 GET 1';
  }

  if (product.discountType == 'flat') {
    return '₹${_resolveFlatOfferValue(product).toStringAsFixed(0)} OFF';
  }

  final discountValue = _resolveOfferValue(product);
  final formattedDiscount = discountValue % 1 == 0
      ? discountValue.toStringAsFixed(0)
      : discountValue.toStringAsFixed(1);
  return '$formattedDiscount% OFF';
}

Color productOfferColor(BuildContext context) {
  return Theme.of(context).extension<AppOfferTheme>()?.badge ??
      AppOfferTheme.fallback(Theme.of(context).brightness).badge;
}

double _resolveOfferValue(Product product) {
  if (product.discountType == 'flat') {
    return _resolveFlatOfferValue(product);
  }

  final discountValue = product.discountValue ?? 0;
  if (discountValue > 0) return discountValue;
  return product.discount;
}

double _resolveFlatOfferValue(Product product) {
  final discountValue = product.discountValue ?? 0;
  if (discountValue > 0) return discountValue;

  final priceDifference = product.realPrice - product.price;
  if (priceDifference > 0) return priceDifference;
  return product.discount;
}

class ProductOfferBadge extends StatelessWidget {
  final Product product;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double borderRadius;

  const ProductOfferBadge({
    super.key,
    required this.product,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.fontSize = 10,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final offerTheme =
        Theme.of(context).extension<AppOfferTheme>() ??
        AppOfferTheme.fallback(Theme.of(context).brightness);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: offerTheme.badge,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Text(
        buildProductOfferLabel(product),
        style: TextStyle(
          color: offerTheme.onBadge,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
