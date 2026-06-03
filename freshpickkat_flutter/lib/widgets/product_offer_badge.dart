import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';
import 'package:freshpickkat_flutter/utils/app_theme.dart';

bool isBogoProduct(Product product) {
  return product.discountType?.toLowerCase().trim() == 'bogo' &&
      (product.bogoFreeProductIds?.isNotEmpty ?? false);
}

bool hasProductOffer(Product product) {
  if (isBogoProduct(product)) return true;
  if (product.isFreeDelivery) return true;
  return _resolveOfferValue(product) > 0;
}

String buildProductOfferLabel(Product product) {
  if (isBogoProduct(product)) {
    return 'BUY 1 GET 1';
  }
  if (product.isFreeDelivery) {
    return 'FREE DELIVERY';
  }

  final percentValue = _resolveOfferValue(product);
  final flatValue = _resolveFlatOfferValue(product);

  if (product.discountType == 'flat') {
    return '₹${flatValue.toStringAsFixed(0)} OFF';
  }

  final formattedPercent = percentValue % 1 == 0
      ? percentValue.toStringAsFixed(0)
      : percentValue.toStringAsFixed(1);

  if (flatValue > 0) {
    return '$formattedPercent% OFF (₹${flatValue.toStringAsFixed(0)})';
  }
  return '$formattedPercent% OFF';
}

String buildProductOfferLabelCard(Product product) {
  if (isBogoProduct(product)) {
    return 'BUY 1 GET 1';
  }
  if (product.isFreeDelivery) {
    return 'FREE DELIVERY';
  }

  final percentValue = _resolveOfferValue(product);

  if (product.discountType == 'flat') {
    final flatValue = _resolveFlatOfferValue(product);
    return '₹${flatValue.toStringAsFixed(0)} OFF';
  }

  final formattedPercent = percentValue % 1 == 0
      ? percentValue.toStringAsFixed(0)
      : percentValue.toStringAsFixed(1);

  return '$formattedPercent% OFF';
}

Color productOfferColor(BuildContext context) {
  return Theme.of(context).extension<AppOfferTheme>()?.badge ??
      AppOfferTheme.fallback(Theme.of(context).brightness).badge;
}

double _resolveOfferValue(Product product) {
  if (product.realPrice > 0 &&
      product.price > 0 &&
      product.price < product.realPrice) {
    return ((product.realPrice - product.price) / product.realPrice) * 100;
  }

  final discountValue = product.discountValue ?? 0;
  if (discountValue > 0) return discountValue;
  return product.discount;
}

double _resolveFlatOfferValue(Product product) {
  if (product.realPrice > 0 &&
      product.price > 0 &&
      product.price < product.realPrice) {
    return product.realPrice - product.price;
  }

  final discountValue = product.discountValue ?? 0;
  if (discountValue > 0) return discountValue;
  return product.discount;
}

class ProductOfferBadge extends StatelessWidget {
  final Product product;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double borderRadius;
  final bool showFullLabel;

  const ProductOfferBadge({
    super.key,
    required this.product,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.fontSize = 10,
    this.borderRadius = 8,
    this.showFullLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final offerTheme =
        Theme.of(context).extension<AppOfferTheme>() ??
        AppOfferTheme.fallback(Theme.of(context).brightness);

    final label = showFullLabel
        ? buildProductOfferLabel(product)
        : buildProductOfferLabelCard(product);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: offerTheme.badge,
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
          ),
        ],
      ),
      child: AutoSizeText(
        label,
        style: TextStyle(
          color: offerTheme.onBadge,
          fontSize: fontSize.sp,
          fontWeight: FontWeight.w700,
        ),
        minFontSize: 7,
        maxLines: 1,
      ),
    );
  }
}
