import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class VariantDraft {
  final String variantId;
  final TextEditingController quantityValueCtrl;
  String quantityUnit;
  final TextEditingController priceCtrl;
  final TextEditingController mrpCtrl;
  bool isAvailable;

  final double baseRealPrice;
  final double baseQuantity;
  final String baseUnit;

  VariantDraft({
    String? variantId,
    double quantityValue = 1,
    String quantityUnit = 'gm',
    String price = '',
    String mrp = '',
    this.isAvailable = true,
    this.baseRealPrice = 0,
    this.baseQuantity = 1,
    this.baseUnit = 'gm',
  }) : variantId =
           variantId ?? 'variant_${DateTime.now().millisecondsSinceEpoch}',
       quantityValueCtrl = TextEditingController(
         text: quantityValue.toString(),
       ),
       quantityUnit = quantityUnit,
       priceCtrl = TextEditingController(text: price),
       mrpCtrl = TextEditingController(text: mrp);

  factory VariantDraft.fromVariant(
    ProductVariant variant, {
    double? baseRealPrice,
    double? baseQuantity,
    String? baseUnit,
  }) {
    return VariantDraft(
      variantId: variant.variantId,
      quantityValue: variant.quantityValue,
      quantityUnit: variant.quantityUnit,
      price: variant.price.toString(),
      mrp: variant.realPrice.toString(),
      isAvailable: variant.isAvailable,
      baseRealPrice: baseRealPrice ?? variant.realPrice,
      baseQuantity: baseQuantity ?? variant.quantityValue,
      baseUnit: baseUnit ?? variant.quantityUnit,
    );
  }

  void dispose() {
    quantityValueCtrl.dispose();
    priceCtrl.dispose();
    mrpCtrl.dispose();
  }

  String get quantityString => '${quantityValueCtrl.text} $quantityUnit';
}
