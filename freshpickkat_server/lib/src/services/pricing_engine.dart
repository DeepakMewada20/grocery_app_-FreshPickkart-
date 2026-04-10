import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/firebase_service.dart';
import '../services/coupon_service.dart';
import '../services/delivery/delivery_engine.dart';
import 'package:googleapis/firestore/v1.dart' as firestore_api;

class PricingEngine {
  static const String _projectId = 'freshpickkart-a6824';

  static T? _firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
    for (final item in list) {
      if (test(item)) return item;
    }
    return null;
  }

  static Future<CartPricingResult> calculateCartPricing({
    required Session session,
    required List<CartItemInput> items,
    String? appliedCouponCode,
    bool autoApplyCoupons = true,
  }) async {
    final result = CartPricingResult(
      subtotal: 0,
      itemDiscounts: 0,
      productOfferDiscount: 0,
      categoryOfferDiscount: 0,
      bogoDiscount: 0,
      comboDiscount: 0,
      couponDiscount: 0,
      deliveryFee: 0,
      originalDeliveryFee: 0,
      freeDeliveryApplied: false,
      deliveryPricing: null,
      totalSavings: 0,
      totalAmount: 0,
      appliedOffers: [],
      freeItems: [],
      pricingBreakdown: [],
    );

    if (items.isEmpty) {
      result.pricingBreakdown = [
        PricingLineItem(label: 'Subtotal', amount: 0, type: 'subtotal'),
        PricingLineItem(
          label: 'Delivery Fee',
          amount: 0,
          type: 'delivery',
        ),
        PricingLineItem(
          label: 'Total',
          amount: 0,
          type: 'total',
        ),
      ];
      result.totalAmount = 0;
      return result;
    }

    double subtotal = 0;
    double itemDiscounts = 0;
    final appliedOffersList = <AppliedOfferInfo>[];
    final freeItemsList = <FreeItemInfo>[];
    final productIds = items.map((i) => i.productId).toSet().toList();
    final productMap = await _fetchProducts(productIds);

    for (final item in items) {
      final product = productMap[item.productId];
      if (product == null) continue;

      double itemPrice = product.price;
      if (item.variantId != null && product.variants != null) {
        final variant = _firstWhereOrNull(
          product.variants!,
          (v) => v.variantId == item.variantId,
        );
        if (variant != null) {
          itemPrice = variant.price;
        }
      }

      final itemTotal = itemPrice * item.quantity;
      subtotal += itemTotal;

      final discount = (product.realPrice) - itemPrice;
      if (discount > 0) {
        itemDiscounts += discount * item.quantity;
        appliedOffersList.add(
          AppliedOfferInfo(
            offerId: product.productId ?? '',
            offerName: '${product.productName} Offer',
            offerType: 'product_discount',
            discountAmount: discount * item.quantity,
          ),
        );
      }
    }

    result.subtotal = subtotal;
    result.itemDiscounts = itemDiscounts;
    result.totalSavings += itemDiscounts;

    final bogoOffers = await _fetchActiveBogoOffers();
    final categoryOffers = await _fetchActiveCategoryOffers();
    final comboOffers = await _fetchActiveComboOffers();
    double effectiveSubtotal = subtotal;

    for (final offer in bogoOffers) {
      if (!offer.isActive) continue;
      final now = DateTime.now();
      if (offer.startDate.isAfter(now) || offer.endDate.isBefore(now)) continue;

      final triggerItem = _firstWhereOrNull(
        items,
        (i) =>
            i.productId == offer.triggerProductId &&
            (offer.triggerVariantId == null ||
                offer.triggerVariantId!.trim().isEmpty ||
                i.variantId == offer.triggerVariantId),
      );
      if (triggerItem == null) continue;

      final product = productMap[offer.triggerProductId];
      if (product == null) continue;
      ProductVariant? triggerVariant;
      if (offer.triggerVariantId != null &&
          offer.triggerVariantId!.trim().isNotEmpty) {
        try {
          triggerVariant = (product.variants ?? const <ProductVariant>[])
              .firstWhere(
                (variant) => variant.variantId == offer.triggerVariantId,
              );
        } catch (_) {}
      }

      final minimumTriggerQuantity = offer.minTriggerQuantity ?? 1;
      if (minimumTriggerQuantity <= 0 ||
          triggerItem.quantity < minimumTriggerQuantity) {
        continue;
      }

      final price = triggerVariant?.price ?? product.price;
      final freeQty = triggerItem.quantity ~/ minimumTriggerQuantity;
      if (freeQty > 0) {
        final discount = price * freeQty;
        result.bogoDiscount += discount;
        result.totalSavings += discount;
        effectiveSubtotal -= discount;

        appliedOffersList.add(
          AppliedOfferInfo(
            offerId: offer.offerId ?? offer.triggerProductId,
            offerName: offer.offerTitle,
            offerType: 'bogo',
            discountAmount: discount,
          ),
        );

        for (final freeProductId in offer.freeProductIds) {
          final freeProduct = productMap[freeProductId];
          if (freeProduct != null) {
            freeItemsList.add(
              FreeItemInfo(
                productId: freeProductId,
                productName: freeProduct.productName,
                variantId: null,
                quantity: freeQty,
                triggerProductId: offer.triggerProductId,
              ),
            );
          }
        }
      }
    }

    for (final offer in categoryOffers) {
      if (!offer.isActive) continue;
      final now = DateTime.now();
      if (offer.startDate.isAfter(now) || offer.endDate.isBefore(now)) continue;
      if (offer.minOrderAmount != null &&
          effectiveSubtotal < offer.minOrderAmount!) {
        continue;
      }

      final categoryItems = items.where((i) {
        final product = productMap[i.productId];
        if (product == null) return false;
        return product.category == offer.categoryId ||
            (product.subcategory.isNotEmpty &&
                product.subcategory.contains(offer.categoryId));
      }).toList();

      if (categoryItems.isEmpty) continue;

      double categoryTotal = 0;
      for (final item in categoryItems) {
        final product = productMap[item.productId];
        if (product == null) continue;
        categoryTotal += product.price * item.quantity;
      }

      double discount = 0;
      if (offer.discountType == 'percentage') {
        discount = categoryTotal * (offer.discountValue / 100);
        if (offer.maxDiscount != null && discount > offer.maxDiscount!) {
          discount = offer.maxDiscount!;
        }
      } else {
        discount = offer.discountValue;
      }

      if (discount > 0) {
        result.categoryOfferDiscount += discount;
        result.totalSavings += discount;
        effectiveSubtotal -= discount;

        appliedOffersList.add(
          AppliedOfferInfo(
            offerId: offer.offerId ?? offer.categoryId,
            offerName: offer.name,
            offerType: 'category',
            discountAmount: discount,
          ),
        );
      }
    }

    for (final combo in comboOffers) {
      if (!combo.isActive) continue;
      final now = DateTime.now();
      if (combo.startDate.isAfter(now) || combo.endDate.isBefore(now)) continue;

      final comboId = combo.comboId?.trim();
      if (comboId == null || comboId.isEmpty) {
        continue;
      }

      bool allProductsPresent = true;

      for (final comboProduct in combo.comboProducts) {
        final cartItem = _firstWhereOrNull(
          items,
          (i) =>
              i.productId == comboProduct.productId &&
              i.comboId == comboId &&
              i.quantity >= comboProduct.quantity,
        );
        if (cartItem == null) {
          allProductsPresent = false;
          break;
        }
      }

      if (allProductsPresent) {
        double discount = 0;
        if (combo.discountType == 'percentage') {
          double comboTotal = 0;
          for (final comboProduct in combo.comboProducts) {
            final product = productMap[comboProduct.productId];
            if (product != null) {
              comboTotal += product.price * comboProduct.quantity;
            }
          }
          discount = comboTotal * (combo.discountValue / 100);
        } else {
          discount = combo.discountValue;
        }

        if (discount > 0) {
          result.comboDiscount += discount;
          result.totalSavings += discount;
          effectiveSubtotal -= discount;

          appliedOffersList.add(
            AppliedOfferInfo(
              offerId: combo.comboId ?? '',
              offerName: combo.name,
              offerType: 'combo',
              discountAmount: discount,
            ),
          );
        }
      }
    }

    if (appliedCouponCode != null && appliedCouponCode.isNotEmpty) {
      final manualCoupon = await CouponService.applyCoupon(
        userId: '',
        couponCode: appliedCouponCode,
        cartSubtotal: effectiveSubtotal,
        cartItems: items,
      );
      if (manualCoupon.isValid && manualCoupon.discountAmount > 0) {
        result.couponDiscount = manualCoupon.discountAmount;
        effectiveSubtotal -= manualCoupon.discountAmount;
        result.totalSavings += manualCoupon.discountAmount;

        result.appliedCoupon = AppliedCouponInfo(
          couponId: manualCoupon.couponId ?? manualCoupon.couponCode ?? '',
          couponCode: manualCoupon.couponCode ?? appliedCouponCode,
          discountAmount: manualCoupon.discountAmount,
          isAutoApplied: false,
        );
      }
    } else if (autoApplyCoupons) {
      final bestCoupon = await CouponService.getBestCoupon(
        userId: '',
        cartSubtotal: effectiveSubtotal,
        cartItems: items,
      );
      if (bestCoupon.bestCouponCode != null && bestCoupon.discountAmount > 0) {
        result.couponDiscount = bestCoupon.discountAmount;
        effectiveSubtotal -= bestCoupon.discountAmount;
        result.totalSavings += bestCoupon.discountAmount;

        result.appliedCoupon = AppliedCouponInfo(
          couponId: bestCoupon.bestCouponCode!,
          couponCode: bestCoupon.bestCouponCode!,
          discountAmount: bestCoupon.discountAmount,
          isAutoApplied: true,
        );
      }
    }

    final deliveryPricing = await DeliveryEngine.calculate(
      session: session,
      cartTotal: effectiveSubtotal,
      userId: '',
    );
    result.deliveryPricing = deliveryPricing;
    result.deliveryFee = deliveryPricing.deliveryFee;
    result.originalDeliveryFee = deliveryPricing.baseDeliveryFee;
    result.freeDeliveryApplied = deliveryPricing.isFree;
    if (deliveryPricing.isFree && deliveryPricing.baseDeliveryFee > 0) {
      appliedOffersList.add(
        AppliedOfferInfo(
          offerId: deliveryPricing.appliedRuleType ?? 'delivery',
          offerName: deliveryPricing.appliedRuleName ?? 'Free Delivery',
          offerType: 'free_delivery',
          discountAmount: deliveryPricing.baseDeliveryFee,
        ),
      );
    }

    double totalAmount = effectiveSubtotal + result.deliveryFee;
    if (totalAmount < 0) totalAmount = 0;

    result.totalAmount = totalAmount;
    result.appliedOffers = appliedOffersList;
    result.freeItems = freeItemsList;

    result.pricingBreakdown = [
      PricingLineItem(label: 'Subtotal', amount: subtotal, type: 'subtotal'),
    ];

    if (itemDiscounts > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'Product Discounts',
          amount: -itemDiscounts,
          type: 'discount',
        ),
      );
    }
    if (result.bogoDiscount > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'BOGO Savings',
          amount: -result.bogoDiscount,
          type: 'discount',
        ),
      );
    }
    if (result.categoryOfferDiscount > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'Category Offer',
          amount: -result.categoryOfferDiscount,
          type: 'discount',
        ),
      );
    }
    if (result.comboDiscount > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'Combo Discount',
          amount: -result.comboDiscount,
          type: 'discount',
        ),
      );
    }
    if (result.couponDiscount > 0) {
      result.pricingBreakdown.add(
        PricingLineItem(
          label: 'Coupon (${result.appliedCoupon?.couponCode ?? ""})',
          amount: -result.couponDiscount,
          type: 'coupon',
        ),
      );
    }

    result.pricingBreakdown.add(
      PricingLineItem(
        label: 'Delivery Fee',
        amount: result.deliveryFee,
        type: 'delivery',
      ),
    );

    result.pricingBreakdown.add(
      PricingLineItem(label: 'Total', amount: totalAmount, type: 'total'),
    );

    return result;
  }

  static Future<Map<String, Product>> _fetchProducts(
    List<String> productIds,
  ) async {
    final Map<String, Product> productMap = {};
    if (productIds.isEmpty) return productMap;

    try {
      final firestore = await FirebaseService.getFirestoreClient();
      final database = 'projects/$_projectId/databases/(default)/documents';

      for (final productId in productIds) {
        try {
          final docPath = '$database/Products/$productId';
          final doc = await firestore.projects.databases.documents.get(docPath);
          if (doc.fields != null) {
            final product = _productFromFirestore(doc.fields!);
            productMap[productId] = product;
          }
        } catch (_) {}
      }
    } catch (_) {}

    return productMap;
  }

  static Product _productFromFirestore(
    Map<String, firestore_api.Value> fields,
  ) {
    final variants = <ProductVariant>[];
    final variantsData = fields['variants']?.arrayValue?.values;
    if (variantsData != null) {
      for (final variantData in variantsData) {
        final vFields = variantData.mapValue?.fields;
        if (vFields != null) {
          variants.add(
            ProductVariant(
              variantId: vFields['variantId']?.stringValue ?? '',
              quantityValue:
                  double.tryParse(
                    vFields['quantityValue']?.doubleValue?.toString() ??
                        vFields['quantityValue']?.integerValue ??
                        '0',
                  ) ??
                  0,
              quantityUnit: vFields['quantityUnit']?.stringValue ?? '',
              price:
                  double.tryParse(
                    vFields['price']?.doubleValue?.toString() ??
                        vFields['price']?.integerValue ??
                        '0',
                  ) ??
                  0,
              realPrice:
                  double.tryParse(
                    vFields['realPrice']?.doubleValue?.toString() ??
                        vFields['realPrice']?.integerValue ??
                        '',
                  ) ??
                  0,
              isAvailable: vFields['isAvailable']?.booleanValue ?? true,
              sortOrder: int.tryParse(
                vFields['sortOrder']?.integerValue ?? '0',
              ),
            ),
          );
        }
      }
    }

    final subcategories =
        fields['subcategory']?.arrayValue?.values
            ?.map((v) => v.stringValue ?? '')
            .toList() ??
        [];

    return Product(
      productId: fields['productId']?.stringValue,
      productName: fields['productName']?.stringValue ?? '',
      category: fields['category']?.stringValue ?? '',
      imageUrl: fields['imageUrl']?.stringValue ?? '',
      price:
          double.tryParse(
            fields['price']?.doubleValue?.toString() ??
                fields['price']?.integerValue ??
                '0',
          ) ??
          0,
      realPrice:
          double.tryParse(
            fields['realPrice']?.doubleValue?.toString() ??
                fields['realPrice']?.integerValue ??
                '0',
          ) ??
          0,
      discount:
          double.tryParse(
            fields['discount']?.doubleValue?.toString() ??
                fields['discount']?.integerValue ??
                '0',
          ) ??
          0,
      discountType: fields['discountType']?.stringValue,
      discountValue: double.tryParse(
        fields['discountValue']?.doubleValue?.toString() ??
            fields['discountValue']?.integerValue ??
            '',
      ),
      isAvailable: fields['isAvailable']?.booleanValue ?? true,
      addedAt:
          DateTime.tryParse(fields['addedAt']?.timestampValue ?? '') ??
          DateTime.now(),
      subcategory: subcategories,
      quantity: fields['quantity']?.stringValue ?? '1',
      baseUnit: fields['baseUnit']?.stringValue,
      baseQuantity: double.tryParse(
        fields['baseQuantity']?.doubleValue?.toString() ??
            fields['baseQuantity']?.integerValue ??
            '',
      ),
      countryOfOrigin: fields['countryOfOrigin']?.stringValue,
      searchKeywords: fields['searchKeywords']?.arrayValue?.values
          ?.map((v) => v.stringValue ?? '')
          .toList(),
      mostSearch: int.tryParse(fields['mostSearch']?.integerValue ?? '0') ?? 0,
      mostPurchases:
          int.tryParse(fields['mostPurchases']?.integerValue ?? '0') ?? 0,
      bogoFreeProductIds: fields['bogoFreeProductIds']?.arrayValue?.values
          ?.map((v) => v.stringValue ?? '')
          .toList(),
      variants: variants.isNotEmpty ? variants : null,
    );
  }

  static Future<List<BogoOffer>> _fetchActiveBogoOffers() async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      final database = 'projects/$_projectId/databases/(default)/documents';

      final query = firestore_api.StructuredQuery(
        from: [firestore_api.CollectionSelector(collectionId: 'bogo_offers')],
        where: firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'isActive'),
            op: 'EQUAL',
            value: firestore_api.Value(booleanValue: true),
          ),
        ),
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      final offers = <BogoOffer>[];
      for (final res in response) {
        if (res.document?.fields != null) {
          final fields = res.document!.fields!;
          final freeProductIds =
              fields['freeProductIds']?.arrayValue?.values
                  ?.map((v) => v.stringValue ?? '')
                  .where((s) => s.isNotEmpty)
                  .toList() ??
              [];
          final freeProducts =
              fields['freeProducts']?.arrayValue?.values
                  ?.map((v) => v.mapValue?.fields ?? const {})
                  .map(
                    (itemFields) => BogoFreeProduct(
                      productId: itemFields['productId']?.stringValue ?? '',
                      quantity: itemFields['quantity']?.stringValue,
                    ),
                  )
                  .where((fp) => fp.productId.trim().isNotEmpty)
                  .toList() ??
              [];

          offers.add(
            BogoOffer(
              offerId: fields['offerId']?.stringValue,
              triggerProductId:
                  fields['triggerProductId']?.stringValue ??
                  res.document!.name!.split('/').last,
              triggerVariantId: fields['triggerVariantId']?.stringValue,
              minTriggerQuantity: int.tryParse(
                fields['minTriggerQuantity']?.integerValue?.toString() ?? '1',
              ),
              triggerBaseQuantity: double.tryParse(
                fields['triggerBaseQuantity']?.doubleValue?.toString() ??
                    fields['triggerBaseQuantity']?.integerValue?.toString() ??
                    '',
              ),
              triggerBaseUnit: fields['triggerBaseUnit']?.stringValue,
              freeProductIds: freeProductIds,
              freeProducts: freeProducts.isNotEmpty ? freeProducts : null,
              offerTitle: fields['offerTitle']?.stringValue ?? 'Buy 1 Get 1',
              isActive: fields['isActive']?.booleanValue ?? true,
              startDate:
                  DateTime.tryParse(
                    fields['startDate']?.timestampValue ?? '',
                  ) ??
                  DateTime.now(),
              endDate:
                  DateTime.tryParse(fields['endDate']?.timestampValue ?? '') ??
                  DateTime.now().add(Duration(days: 365)),
              createdAt:
                  DateTime.tryParse(
                    fields['createdAt']?.timestampValue ?? '',
                  ) ??
                  DateTime.now(),
            ),
          );
        }
      }
      return offers;
    } catch (_) {
      return [];
    }
  }

  static Future<List<CategoryOffer>> _fetchActiveCategoryOffers() async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      final database = 'projects/$_projectId/databases/(default)/documents';

      final query = firestore_api.StructuredQuery(
        from: [
          firestore_api.CollectionSelector(collectionId: 'category_offers'),
        ],
        where: firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'isActive'),
            op: 'EQUAL',
            value: firestore_api.Value(booleanValue: true),
          ),
        ),
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      final offers = <CategoryOffer>[];
      for (final res in response) {
        if (res.document?.fields != null) {
          final fields = res.document!.fields!;
          offers.add(
            CategoryOffer(
              offerId: fields['offerId']?.stringValue,
              name: fields['name']?.stringValue ?? '',
              description: fields['description']?.stringValue,
              categoryId: fields['categoryId']?.stringValue ?? '',
              categoryName: fields['categoryName']?.stringValue,
              discountType: fields['discountType']?.stringValue ?? 'flat',
              discountValue:
                  double.tryParse(
                    fields['discountValue']?.doubleValue?.toString() ??
                        fields['discountValue']?.integerValue ??
                        '0',
                  ) ??
                  0,
              maxDiscount: double.tryParse(
                fields['maxDiscount']?.doubleValue?.toString() ??
                    fields['maxDiscount']?.integerValue ??
                    '',
              ),
              minOrderAmount: double.tryParse(
                fields['minOrderAmount']?.doubleValue?.toString() ??
                    fields['minOrderAmount']?.integerValue ??
                    '',
              ),
              productIds: fields['productIds']?.arrayValue?.values
                  ?.map((v) => v.stringValue ?? '')
                  .where((s) => s.isNotEmpty)
                  .toList(),
              excludeProductIds: fields['excludeProductIds']?.arrayValue?.values
                  ?.map((v) => v.stringValue ?? '')
                  .where((s) => s.isNotEmpty)
                  .toList(),
              startDate:
                  DateTime.tryParse(
                    fields['startDate']?.timestampValue ?? '',
                  ) ??
                  DateTime.now(),
              endDate:
                  DateTime.tryParse(fields['endDate']?.timestampValue ?? '') ??
                  DateTime.now().add(Duration(days: 30)),
              isActive: fields['isActive']?.booleanValue ?? true,
              priority:
                  int.tryParse(fields['priority']?.integerValue ?? '0') ?? 0,
              createdAt:
                  DateTime.tryParse(
                    fields['createdAt']?.timestampValue ?? '',
                  ) ??
                  DateTime.now(),
            ),
          );
        }
      }
      return offers;
    } catch (_) {
      return [];
    }
  }

  static Future<List<ComboOffer>> _fetchActiveComboOffers() async {
    try {
      final firestore = await FirebaseService.getFirestoreClient();
      final database = 'projects/$_projectId/databases/(default)/documents';

      final query = firestore_api.StructuredQuery(
        from: [firestore_api.CollectionSelector(collectionId: 'combo_offers')],
        where: firestore_api.Filter(
          fieldFilter: firestore_api.FieldFilter(
            field: firestore_api.FieldReference(fieldPath: 'isActive'),
            op: 'EQUAL',
            value: firestore_api.Value(booleanValue: true),
          ),
        ),
      );

      final response = await firestore.projects.databases.documents.runQuery(
        firestore_api.RunQueryRequest(structuredQuery: query),
        database,
      );

      final offers = <ComboOffer>[];
      for (final res in response) {
        if (res.document?.fields != null) {
          final fields = res.document!.fields!;
          final comboProducts =
              fields['comboProducts']?.arrayValue?.values
                  ?.map((v) => v.mapValue?.fields ?? const {})
                  .map(
                    (itemFields) => ComboProductItem(
                      productId: itemFields['productId']?.stringValue ?? '',
                      productName: itemFields['productName']?.stringValue,
                      quantity:
                          int.tryParse(
                            itemFields['quantity']?.integerValue ??
                                itemFields['quantity']?.stringValue ??
                                '1',
                          ) ??
                          1,
                      variantId: itemFields['variantId']?.stringValue,
                    ),
                  )
                  .where((cp) => cp.productId.isNotEmpty)
                  .toList() ??
              [];

          offers.add(
            ComboOffer(
              comboId:
                  fields['comboId']?.stringValue ??
                  res.document!.name!.split('/').last,
              name: fields['name']?.stringValue ?? '',
              description: fields['description']?.stringValue,
              comboProducts: comboProducts,
              discountType: fields['discountType']?.stringValue ?? 'flat',
              discountValue:
                  double.tryParse(
                    fields['discountValue']?.doubleValue?.toString() ??
                        fields['discountValue']?.integerValue ??
                        '0',
                  ) ??
                  0,
              minQuantityPerProduct:
                  int.tryParse(
                    fields['minQuantityPerProduct']?.integerValue ?? '1',
                  ) ??
                  1,
              startDate:
                  DateTime.tryParse(
                    fields['startDate']?.timestampValue ?? '',
                  ) ??
                  DateTime.now(),
              endDate:
                  DateTime.tryParse(fields['endDate']?.timestampValue ?? '') ??
                  DateTime.now().add(Duration(days: 30)),
              isActive: fields['isActive']?.booleanValue ?? true,
              priority:
                  int.tryParse(fields['priority']?.integerValue ?? '0') ?? 0,
              maxUsagePerUser:
                  int.tryParse(
                    fields['maxUsagePerUser']?.integerValue ?? '0',
                  ) ??
                  0,
              usageCount:
                  int.tryParse(fields['usageCount']?.integerValue ?? '0') ?? 0,
              maxTotalUsage: int.tryParse(
                fields['maxTotalUsage']?.integerValue ?? '',
              ),
              createdAt:
                  DateTime.tryParse(
                    fields['createdAt']?.timestampValue ?? '',
                  ) ??
                  DateTime.now(),
            ),
          );
        }
      }
      return offers;
    } catch (_) {
      return [];
    }
  }

}
