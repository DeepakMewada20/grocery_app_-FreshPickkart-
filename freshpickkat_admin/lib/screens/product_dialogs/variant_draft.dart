import 'package:flutter/material.dart';
import 'package:freshpickkat_client/freshpickkat_client.dart';

class VariantDraft {
  final String variantId;
  final TextEditingController quantityValueCtrl;
  final TextEditingController quantityDescriptionCtrl;
  String quantityUnit;
  final TextEditingController priceCtrl;
  final TextEditingController mrpCtrl;
  bool isAvailable;

  double baseRealPrice;
  double basePrice;
  double baseQuantity;
  String baseUnit;

  VariantDraft({
    String? variantId,
    double quantityValue = 1,
    this.quantityUnit = 'gm',
    String quantityDescription = '',
    String price = '',
    String mrp = '',
    this.isAvailable = true,
    this.baseRealPrice = 0,
    this.basePrice = 0,
    this.baseQuantity = 1,
    this.baseUnit = 'gm',
  }) : variantId =
           variantId ?? 'variant_${DateTime.now().millisecondsSinceEpoch}',
       quantityValueCtrl = TextEditingController(
         text: quantityValue.toString(),
       ),
       quantityDescriptionCtrl = TextEditingController(
         text: quantityDescription,
       ),
       priceCtrl = TextEditingController(text: price),
       mrpCtrl = TextEditingController(text: mrp);

  factory VariantDraft.fromVariant(
    ProductVariant variant, {
    double? baseRealPrice,
    double? basePrice,
    double? baseQuantity,
    String? baseUnit,
  }) {
    return VariantDraft(
      variantId: variant.variantId,
      quantityValue: variant.quantityValue,
      quantityUnit: variant.quantityUnit,
      quantityDescription: variant.quantityDescription ?? '',
      price: variant.price.toString(),
      mrp: variant.realPrice.toString(),
      isAvailable: variant.isAvailable,
      baseRealPrice: baseRealPrice ?? variant.realPrice,
      basePrice: basePrice ?? variant.price,
      baseQuantity: baseQuantity ?? variant.quantityValue,
      baseUnit: baseUnit ?? variant.quantityUnit,
    );
  }

  void dispose() {
    quantityValueCtrl.dispose();
    quantityDescriptionCtrl.dispose();
    priceCtrl.dispose();
    mrpCtrl.dispose();
  }

  String get quantityString => '${quantityValueCtrl.text} $quantityUnit';
}
