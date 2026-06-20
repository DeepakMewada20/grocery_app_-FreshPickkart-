import 'dart:convert';

import 'package:serverpod/serverpod.dart' hide Order;

import '../generated/protocol.dart';
import 'postgres/postgres_support.dart';

class OrderItemSnapshot {
  final double? mrp;
  final String? sku;
  final String? slug;
  final String? categoryName;
  final String? productStatus;
  final String? appliedOfferJson;

  const OrderItemSnapshot({
    this.mrp,
    this.sku,
    this.slug,
    this.categoryName,
    this.productStatus,
    this.appliedOfferJson,
  });
}

class SnapshotBuilder {
  static final SnapshotBuilder instance = SnapshotBuilder._();

  SnapshotBuilder._();

  Future<Map<String, OrderItemSnapshot>> buildFromOrderItems(
    Session session, {
    required List<OrderItem> items,
    Map<String, String>? bogoOfferIdsByFreeItem,
  }) async {
    final productIds = items
        .map((i) => tryParseUuid(i.productId))
        .whereType<UuidValue>()
        .toSet();
    final variantIds = items
        .map((i) => i.variantId == null ? null : tryParseUuid(i.variantId!))
        .whereType<UuidValue>()
        .toSet();
    final comboIds = items
        .map((i) => i.comboId == null ? null : tryParseUuid(i.comboId!))
        .whereType<UuidValue>()
        .toSet();

    final bogoOfferIds =
        bogoOfferIdsByFreeItem?.values
            .map((id) => tryParseUuid(id))
            .whereType<UuidValue>()
            .toSet() ??
        <UuidValue>{};

    final products = productIds.isEmpty
        ? <ProductRow>[]
        : await ProductRow.db.find(
            session,
            where: (t) => t.id.inSet(productIds),
          );
    final productById = {for (final p in products) p.id!: p};

    final variants = variantIds.isEmpty
        ? <ProductVariantRow>[]
        : await ProductVariantRow.db.find(
            session,
            where: (t) => t.id.inSet(variantIds),
          );
    final variantById = {for (final v in variants) v.id!: v};

    final categoryIds = products
        .map((p) => p.categoryId)
        .whereType<UuidValue>()
        .toSet();
    final categories = categoryIds.isEmpty
        ? <CategoryRow>[]
        : await CategoryRow.db.find(
            session,
            where: (t) => t.id.inSet(categoryIds),
          );
    final categoryById = {for (final c in categories) c.id!: c};

    final combos = comboIds.isEmpty
        ? <ComboOfferRow>[]
        : await ComboOfferRow.db.find(
            session,
            where: (t) => t.id.inSet(comboIds),
          );
    final comboById = {for (final c in combos) c.id!: c};

    final bogos = bogoOfferIds.isEmpty
        ? <BogoOfferRow>[]
        : await BogoOfferRow.db.find(
            session,
            where: (t) => t.id.inSet(bogoOfferIds),
          );
    final bogoById = {for (final b in bogos) b.id!: b};

    final result = <String, OrderItemSnapshot>{};
    for (final item in items) {
      final parsedPid = tryParseUuid(item.productId);
      final product = parsedPid == null ? null : productById[parsedPid];
      final parsedVid = item.variantId == null
          ? null
          : tryParseUuid(item.variantId!);
      final variant = parsedVid == null ? null : variantById[parsedVid];
      final category = product == null
          ? null
          : categoryById[product.categoryId];
      final parsedComboId = item.comboId == null
          ? null
          : tryParseUuid(item.comboId!);
      final combo = parsedComboId == null ? null : comboById[parsedComboId];

      String? offerJson;
      if (item.isFreeItem && bogoOfferIdsByFreeItem != null) {
        final bogoIdStr = bogoOfferIdsByFreeItem[_freeItemKey(item)];
        if (bogoIdStr != null) {
          final parsedBogoId = tryParseUuid(bogoIdStr);
          final bogo = parsedBogoId == null ? null : bogoById[parsedBogoId];
          if (bogo != null) {
            offerJson = jsonEncode({
              'offerType': 'BOGO',
              'offerId': bogo.id.toString(),
              'offerName': bogo.title,
              'triggerProductId': bogo.triggerProductId.toString(),
              'minTriggerQuantity': bogo.minTriggerQuantity,
            });
          }
        }
      } else if (combo != null) {
        offerJson = jsonEncode({
          'offerType': 'COMBO',
          'offerId': combo.id.toString(),
          'offerName': combo.name,
          'discountType': combo.discountType,
          'discountValue': combo.discountValue,
        });
      }

      result[item.productId] = OrderItemSnapshot(
        mrp: variant?.listPrice,
        sku: variant?.sku,
        slug: product?.slug,
        categoryName: category?.name,
        productStatus: product?.status,
        appliedOfferJson: offerJson,
      );
    }
    return result;
  }

  String _freeItemKey(OrderItem item) {
    return '${item.productId}_${item.variantId ?? ''}_${item.triggerProductId ?? ''}';
  }

  String? buildCouponSnapshot(CouponRow? coupon, double discountAmount) {
    if (coupon == null) return null;
    return jsonEncode({
      'couponId': coupon.id.toString(),
      'couponCode': coupon.code,
      'discountType': coupon.couponType,
      'discountValue': coupon.discountValue,
      'appliedDiscount': discountAmount,
    });
  }

  String buildPaymentSnapshot({
    required String gatewayName,
    String? gatewayOrderId,
    String? gatewayPaymentId,
    required String paymentStatus,
    required double amount,
    DateTime? paidAt,
  }) {
    return jsonEncode({
      'gatewayName': gatewayName,
      'gatewayOrderId': ?gatewayOrderId,
      'gatewayPaymentId': ?gatewayPaymentId,
      'paymentStatus': paymentStatus,
      'amount': amount,
      'paidAt': ?paidAt?.toUtc().toIso8601String(),
    });
  }

  String buildAddressSnapshot({
    String? recipientName,
    String? phoneNumber,
    required String streetLine1,
    String? streetLine2,
    String? landmark,
    required String city,
    required String state,
    required String postalCode,
    required String country,
    double? latitude,
    double? longitude,
  }) {
    return jsonEncode({
      'recipientName': ?recipientName,
      'phoneNumber': ?phoneNumber,
      'streetLine1': streetLine1,
      'streetLine2': ?streetLine2,
      'landmark': ?landmark,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'latitude': ?latitude,
      'longitude': ?longitude,
    });
  }

  String buildPricingSnapshot(Order order) {
    return jsonEncode({
      'subtotal': order.totalAmount,
      'offerDiscount':
          order.productDiscountAmount +
          order.comboDiscountAmount +
          order.bogoDiscountAmount,
      'couponDiscount': order.discountAmount,
      'deliveryCharge': order.deliveryFee,
      'grandTotal': order.finalAmount,
    });
  }

  String buildDeliverySnapshot(Order order) {
    return jsonEncode({
      'deliveryCharge': order.deliveryFee,
      'originalDeliveryFee': order.originalDeliveryFee,
      'deliveryDiscountAmount': order.deliveryDiscountAmount,
      'freeDeliveryApplied': order.freeDeliveryApplied,
      if (order.freeDeliveryReason != null)
        'freeDeliveryReason': order.freeDeliveryReason,
    });
  }
}
