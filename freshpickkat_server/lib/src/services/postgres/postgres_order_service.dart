import 'dart:convert';
import 'dart:math';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../analytics/redis_analytics_service.dart';
import '../background/order_outbox_service.dart';
import '../pricing/pricing_engine.dart';
import 'postgres_fresh_points_service.dart';
import 'postgres_payment_link_service.dart';
import 'postgres_refund_service.dart';
import 'postgres_support.dart';
import '../orders/snapshot_builder.dart';

class PostgresOrderService {
  static const int _defaultLimit = 20;
  static const int _maxLimit = 50;
  static const String _idempotencyScope = 'order_create';
  static final Random _random = Random();
  final RedisAnalyticsService _analytics = RedisAnalyticsService.instance;
  final PostgresRefundService _refundService = PostgresRefundService();

  Future<String> createPendingOrder(
    Session session, {
    required Order order,
    required String idempotencyKey,
    String gatewayName = 'razorpay',
    int freshPointsToRedeem = 0,
  }) async {
    final normalizedKey = idempotencyKey.trim();
    if (normalizedKey.isEmpty) {
      throw Exception('idempotencyKey is required.');
    }
    if (order.items.isEmpty) {
      throw Exception('Order must contain at least one item.');
    }

    // --- PHASE 5: Server-side pricing calculation ---
    final cartItemInputs = _buildCartItemInputs(order);

    final coupon = await _resolveCoupon(
      session,
      couponReference: order.couponApplied,
    );

    final pricing = await PricingEngine.calculateCartPricing(
      session: session,
      items: cartItemInputs,
      userId: order.userId,
      appliedCouponCode: coupon?.code,
      autoApplyCoupons: false,
      freshPointsToRedeem: freshPointsToRedeem,
    );

    final bogoOfferIdsByFreeItem = <String, String>{};
    for (final freeItem in pricing.freeItems) {
      if (freeItem.bogoOfferId != null && freeItem.triggerProductId != null) {
        final key =
            '${freeItem.productId}_${freeItem.variantId ?? ''}_${freeItem.triggerProductId}';
        bogoOfferIdsByFreeItem[key] = freeItem.bogoOfferId!;
      }
    }

    // ── Phase A1: Server-authoritative SMGM item reconciliation ──
    // Remove any client-supplied SMGM items; rebuild from server pricing.freeItems
    final nonSmgmClientItems = order.items
        .where(
          (item) =>
              !(item.isFreeItem && item.rewardSource == 'SHOP_MORE_GET_MORE'),
        )
        .toList();

    final serverSmgmItems = await Future.wait(
      pricing.freeItems
          .where((fi) => fi.rewardSource == 'SHOP_MORE_GET_MORE')
          .map((fi) async {
        var imageUrl = fi.imageUrl ?? '';
        if (imageUrl.isEmpty) {
          try {
            final parsedPid = tryParseUuid(fi.productId);
            if (parsedPid != null) {
              final pRow = await ProductRow.db.findById(session, parsedPid);
              imageUrl = pRow?.primaryImageUrl ?? '';
            }
          } catch (_) {}
        }
        return OrderItem(
          productId: fi.productId,
          variantId: fi.variantId,
          variantLabel: fi.variantLabel,
          productName: fi.productName,
          productImage: imageUrl,
          quantity: fi.quantity,
          unitPrice: 0,
          totalPrice: 0,
          isFreeItem: true,
          isRewardProduct: true,
          quantityEditable: false,
          priceEditable: false,
          originalUnitPrice: fi.originalUnitPrice ?? fi.rewardValue,
          rewardValue: fi.rewardValue,
          rewardOfferId: fi.rewardOfferId,
          rewardOfferName: fi.rewardOfferName,
          rewardThreshold: fi.rewardThreshold,
          rewardSource: fi.rewardSource,
        );
      }),
    );

    final reconciledItems = [...nonSmgmClientItems, ...serverSmgmItems];

    if (serverSmgmItems.isNotEmpty) {
      final smgmInfo = serverSmgmItems.map(
        (i) => '${i.productName} x${i.quantity} (offer=${i.rewardOfferName})',
      );
      session.log(
        'SMGM reconciliation: replaced ${order.items.length - nonSmgmClientItems.length} '
        'client items with ${serverSmgmItems.length} server items [$smgmInfo]',
        level: LogLevel.info,
      );
    }

    final itemSnapshots = await SnapshotBuilder.instance.buildFromOrderItems(
      session,
      items: reconciledItems,
      bogoOfferIdsByFreeItem: bogoOfferIdsByFreeItem,
    );

    final itemPrices = await _calculateItemPrices(session, reconciledItems);
    final serverMrpTotal = _calculateServerMrpTotal(itemPrices, order.items);
    // --- END PHASE 5 ---

    try {
      return await session.db.transaction<String>((transaction) async {
        final appUser = await _resolveOrCreateUser(
          session,
          userReference: order.userId,
          phoneNumber: order.userPhone,
          userName: order.userName,
          transaction: transaction,
          createIfMissing: true,
        );
        if (appUser == null || appUser.id == null) {
          throw Exception('Unable to resolve the order user.');
        }
        final userId = appUser.id!;

        final existing = await IdempotencyRecordRow.db.findFirstRow(
          session,
          where: (t) =>
              t.scope.equals(_idempotencyScope) &
              t.idempotencyKey.equals(normalizedKey),
          transaction: transaction,
          lockMode: LockMode.forUpdate,
        );

        if (existing != null) {
          if (existing.responseReference != null &&
              existing.responseReference!.trim().isNotEmpty) {
            return existing.responseReference!;
          }

          if (existing.orderId != null) {
            final existingOrder = await CustomerOrderRow.db.findById(
              session,
              existing.orderId!,
              transaction: transaction,
            );
            if (existingOrder != null) {
              return existingOrder.orderNumber;
            }
          }

          throw Exception('Order is already being processed for this key.');
        }

        final now = DateTime.now().toUtc();
        final orderNumber = _generateOrderNumber();
        final requestHash = jsonEncode(order.toJsonForProtocol());

        final pricingSnapshotJson = _buildPricingSnapshot(
          pricing,
          couponCode: coupon?.code,
          paymentMethod: order.paymentMode,
        );
        final deliverySnapshotJson = _buildDeliverySnapshot(pricing);
        final couponSnapshotJson = SnapshotBuilder.instance.buildCouponSnapshot(
          coupon,
          pricing.couponDiscount,
        );
        final addressSnapshotJson = SnapshotBuilder.instance
            .buildAddressSnapshot(
              recipientName: cleanNullableString(order.userName),
              phoneNumber: cleanNullableString(order.userPhone),
              streetLine1: order.deliveryAddress.street.trim(),
              city: order.deliveryAddress.city.trim(),
              state: order.deliveryAddress.state.trim(),
              postalCode: order.deliveryAddress.zipCode.trim(),
              country: order.deliveryAddress.country.trim(),
              latitude: order.deliveryAddress.latitude,
              longitude: order.deliveryAddress.longitude,
            );

        final createdOrder = await CustomerOrderRow.db.insertRow(
          session,
          CustomerOrderRow(
            userId: userId,
            orderNumber: orderNumber,
            orderStatus: 'placed',
            paymentStatus: 'pending',
            refundStatus: 'none',
            couponId: coupon?.id,
            itemCount: order.itemCount,
            // --- SERVER-CALCULATED PRICING ---
            totalAmount: pricing.subtotal,
            discountAmount: pricing.couponDiscount,
            mrpTotal: serverMrpTotal,
            productDiscountAmount: pricing.itemDiscounts,
            comboDiscountAmount: pricing.comboDiscount,
            bogoDiscountAmount: pricing.bogoDiscount,
            categoryOfferDiscountAmount: pricing.categoryOfferDiscount,
            deliveryFee: pricing.deliveryFee,
            originalDeliveryFee: pricing.originalDeliveryFee,
            deliveryDiscountAmount:
                pricing.originalDeliveryFee - pricing.deliveryFee,
            freeDeliveryApplied: pricing.freeDeliveryApplied,
            freeDeliveryReason: pricing.freeDeliveryApplied
                ? (pricing.deliveryPricing?.appliedRuleName ?? 'Free Delivery')
                : null,
            freshPointsUsed: pricing.freshPointsRedeemed,
            freshPointsValue: pricing.freshPointsDiscount,
            actualPaymentAmount: pricing.totalAmount,
            // --- END SERVER-CALCULATED ---
            couponSnapshot: couponSnapshotJson,
            pricingSnapshot: pricingSnapshotJson,
            deliverySnapshot: deliverySnapshotJson,
            addressSnapshot: addressSnapshotJson,
            finalAmount: pricing.totalAmount,
            orderType: order.orderType,
            sourceOrderNumber: cleanNullableString(order.sourceOrderNumber),
            complaintId: cleanNullableString(order.complaintId),
            placedAt: now,
            orderedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
        if (createdOrder.id == null) {
          throw Exception('Failed to allocate order id.');
        }
        final createdOrderId = createdOrder.id!;

        await OrderAddressRow.db.insertRow(
          session,
          OrderAddressRow(
            orderId: createdOrderId,
            recipientName: cleanNullableString(order.userName),
            phoneNumber: cleanNullableString(order.userPhone),
            streetLine1: order.deliveryAddress.street.trim(),
            city: order.deliveryAddress.city.trim(),
            state: order.deliveryAddress.state.trim(),
            postalCode: order.deliveryAddress.zipCode.trim(),
            country: order.deliveryAddress.country.trim(),
            latitude: order.deliveryAddress.latitude,
            longitude: order.deliveryAddress.longitude,
            createdAt: now,
          ),
          transaction: transaction,
        );

        final orderItemRows = reconciledItems.map((item) {
          final productId = parseUuid(item.productId, fieldName: 'productId');
          final bogoOfferId = item.isFreeItem
              ? tryParseUuid(bogoOfferIdsByFreeItem[_orderFreeItemKey(item)])
              : null;

          final priceData = itemPrices[_itemPriceKey(item)];
          final serverUnitPrice = priceData?.unitPrice ?? 0;
          final serverTotalPrice = serverUnitPrice * item.quantity;

          return OrderItemRow(
            orderId: createdOrderId,
            productId: productId,
            productVariantId: tryParseUuid(item.variantId),
            comboOfferId: tryParseUuid(item.comboId),
            bogoOfferId: bogoOfferId,
            triggerProductId: tryParseUuid(item.triggerProductId),
            productNameSnapshot: item.productName.trim(),
            productImageUrlSnapshot: cleanNullableString(item.productImage),
            variantLabelSnapshot: cleanNullableString(item.variantLabel),
            mrpSnapshot: itemSnapshots[item.productId]?.mrp,
            skuSnapshot: itemSnapshots[item.productId]?.sku,
            productSlugSnapshot: itemSnapshots[item.productId]?.slug,
            categoryNameSnapshot: itemSnapshots[item.productId]?.categoryName,
            productStatusSnapshot: itemSnapshots[item.productId]?.productStatus,
            appliedOfferSnapshot:
                itemSnapshots[item.productId]?.appliedOfferJson,
            quantity: item.quantity,
            unitPrice: serverUnitPrice,
            totalPrice: serverTotalPrice,
            isFreeItem: item.isFreeItem,
            isFreeDelivery: item.isFreeDelivery,
            isRewardProduct: item.isRewardProduct,
            quantityEditable: item.quantityEditable,
            priceEditable: item.priceEditable,
            originalUnitPrice: item.isFreeItem
                ? item.originalUnitPrice
                : (item.originalUnitPrice ?? serverUnitPrice),
            rewardValue: item.rewardValue,
            rewardOfferId: item.rewardOfferId,
            rewardOfferName: item.rewardOfferName,
            rewardThreshold: item.rewardThreshold,
            rewardSource: item.rewardSource,
            createdAt: now,
          );
        }).toList();

        await OrderItemRow.db.insert(
          session,
          orderItemRows,
          transaction: transaction,
        );

        final paymentTransaction = await PaymentTransactionRow.db.insertRow(
          session,
          PaymentTransactionRow(
            orderId: createdOrderId,
            userId: userId,
            idempotencyKey: normalizedKey,
            gatewayName: gatewayName.trim().isEmpty
                ? 'razorpay'
                : gatewayName.trim(),
            amount: pricing.totalAmount,
            currencyCode: 'INR',
            paymentStatus: 'pending',
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
        if (paymentTransaction.id == null) {
          throw Exception('Failed to allocate payment transaction id.');
        }
        final paymentTransactionId = paymentTransaction.id!;

        // ── FreshPoints: atomically redeem points if used ──
        if (pricing.freshPointsRedeemed > 0) {
          final fpService = PostgresFreshPointsService();
          await fpService.redeemPoints(
            session,
            userId,
            pricing.freshPointsRedeemed,
            referenceType: 'order',
            referenceId: createdOrderId,
            description: 'Redeemed ${pricing.freshPointsRedeemed} points for order $orderNumber',
            transaction: transaction,
          );
        }

        await IdempotencyRecordRow.db.insertRow(
          session,
          IdempotencyRecordRow(
            scope: _idempotencyScope,
            idempotencyKey: normalizedKey,
            userId: userId,
            orderId: createdOrderId,
            paymentTransactionId: paymentTransactionId,
            requestHash: requestHash,
            responseReference: orderNumber,
            createdAt: now,
          ),
          transaction: transaction,
        );

        return orderNumber;
      });
    } catch (error) {
      final existingOrderNumber = await _findExistingOrderNumberForKey(
        session,
        normalizedKey,
      );
      if (existingOrderNumber != null) {
        return existingOrderNumber;
      }
      rethrow;
    }
  }

  Future<String> createCodOrder(
    Session session, {
    required Order order,
    required String idempotencyKey,
    int freshPointsToRedeem = 0,
  }) async {
    final normalizedKey = idempotencyKey.trim();
    if (normalizedKey.isEmpty) {
      throw Exception('idempotencyKey is required.');
    }
    if (order.items.isEmpty) {
      throw Exception('Order must contain at least one item.');
    }

    // ── FreshPoints guard ──
    if (freshPointsToRedeem > 0) {
      final fpService = PostgresFreshPointsService();
      final fpSettings = await fpService.getSettings(session);
      if (fpSettings?.allowRedemptionOnCOD == false) {
        throw Exception('FreshPoints cannot be redeemed on COD orders.');
      }
    }

    // ── Server-side pricing ──
    final cartItemInputs = _buildCartItemInputs(order);
    final coupon = await _resolveCoupon(
      session,
      couponReference: order.couponApplied,
    );

    final pricing = await PricingEngine.calculateCartPricing(
      session: session,
      items: cartItemInputs,
      userId: order.userId,
      appliedCouponCode: coupon?.code,
      autoApplyCoupons: false,
      freshPointsToRedeem: freshPointsToRedeem,
    );

    final bogoOfferIdsByFreeItem = <String, String>{};
    for (final freeItem in pricing.freeItems) {
      if (freeItem.bogoOfferId != null && freeItem.triggerProductId != null) {
        final key =
            '${freeItem.productId}_${freeItem.variantId ?? ''}_${freeItem.triggerProductId}';
        bogoOfferIdsByFreeItem[key] = freeItem.bogoOfferId!;
      }
    }

    // ── SMGM reconciliation (same as createPendingOrder) ──
    final nonSmgmClientItems = order.items
        .where(
          (item) =>
              !(item.isFreeItem && item.rewardSource == 'SHOP_MORE_GET_MORE'),
        )
        .toList();

    final serverSmgmItems = await Future.wait(
      pricing.freeItems
          .where((fi) => fi.rewardSource == 'SHOP_MORE_GET_MORE')
          .map((fi) async {
        var imageUrl = fi.imageUrl ?? '';
        if (imageUrl.isEmpty) {
          try {
            final parsedPid = tryParseUuid(fi.productId);
            if (parsedPid != null) {
              final pRow = await ProductRow.db.findById(session, parsedPid);
              imageUrl = pRow?.primaryImageUrl ?? '';
            }
          } catch (_) {}
        }
        return OrderItem(
          productId: fi.productId,
          variantId: fi.variantId,
          variantLabel: fi.variantLabel,
          productName: fi.productName,
          productImage: imageUrl,
          quantity: fi.quantity,
          unitPrice: 0,
          totalPrice: 0,
          isFreeItem: true,
          isRewardProduct: true,
          quantityEditable: false,
          priceEditable: false,
          originalUnitPrice: fi.originalUnitPrice ?? fi.rewardValue,
          rewardValue: fi.rewardValue,
          rewardOfferId: fi.rewardOfferId,
          rewardOfferName: fi.rewardOfferName,
          rewardThreshold: fi.rewardThreshold,
          rewardSource: fi.rewardSource,
        );
      }),
    );

    final reconciledItems = [...nonSmgmClientItems, ...serverSmgmItems];

    final itemSnapshots = await SnapshotBuilder.instance.buildFromOrderItems(
      session,
      items: reconciledItems,
      bogoOfferIdsByFreeItem: bogoOfferIdsByFreeItem,
    );

    final itemPrices = await _calculateItemPrices(session, reconciledItems);
    final serverMrpTotal = _calculateServerMrpTotal(itemPrices, order.items);

    try {
      return await session.db.transaction<String>((transaction) async {
        final appUser = await _resolveOrCreateUser(
          session,
          userReference: order.userId,
          phoneNumber: order.userPhone,
          userName: order.userName,
          transaction: transaction,
          createIfMissing: true,
        );
        if (appUser == null || appUser.id == null) {
          throw Exception('Unable to resolve the order user.');
        }
        final userId = appUser.id!;

        final existing = await IdempotencyRecordRow.db.findFirstRow(
          session,
          where: (t) =>
              t.scope.equals(_idempotencyScope) &
              t.idempotencyKey.equals(normalizedKey),
          transaction: transaction,
          lockMode: LockMode.forUpdate,
        );

        if (existing != null) {
          if (existing.responseReference != null &&
              existing.responseReference!.trim().isNotEmpty) {
            return existing.responseReference!;
          }
          if (existing.orderId != null) {
            final existingOrder = await CustomerOrderRow.db.findById(
              session,
              existing.orderId!,
              transaction: transaction,
            );
            if (existingOrder != null) {
              return existingOrder.orderNumber;
            }
          }
          throw Exception('Order is already being processed for this key.');
        }

        final now = DateTime.now().toUtc();
        final orderNumber = _generateOrderNumber();
        final requestHash = jsonEncode(order.toJsonForProtocol());

        final pricingSnapshotJson = _buildPricingSnapshot(
          pricing,
          couponCode: coupon?.code,
          paymentMethod: 'cod',
        );
        final deliverySnapshotJson = _buildDeliverySnapshot(pricing);
        final couponSnapshotJson = SnapshotBuilder.instance.buildCouponSnapshot(
          coupon,
          pricing.couponDiscount,
        );
        final addressSnapshotJson = SnapshotBuilder.instance
            .buildAddressSnapshot(
              recipientName: cleanNullableString(order.userName),
              phoneNumber: cleanNullableString(order.userPhone),
              streetLine1: order.deliveryAddress.street.trim(),
              city: order.deliveryAddress.city.trim(),
              state: order.deliveryAddress.state.trim(),
              postalCode: order.deliveryAddress.zipCode.trim(),
              country: order.deliveryAddress.country.trim(),
              latitude: order.deliveryAddress.latitude,
              longitude: order.deliveryAddress.longitude,
            );

        final createdOrder = await CustomerOrderRow.db.insertRow(
          session,
          CustomerOrderRow(
            userId: userId,
            orderNumber: orderNumber,
            orderStatus: 'confirmed',
            paymentStatus: 'pending',
            paymentMode: 'cod',
            refundStatus: 'none',
            couponId: coupon?.id,
            itemCount: order.itemCount,
            totalAmount: pricing.subtotal,
            discountAmount: pricing.couponDiscount,
            mrpTotal: serverMrpTotal,
            productDiscountAmount: pricing.itemDiscounts,
            comboDiscountAmount: pricing.comboDiscount,
            bogoDiscountAmount: pricing.bogoDiscount,
            categoryOfferDiscountAmount: pricing.categoryOfferDiscount,
            deliveryFee: pricing.deliveryFee,
            originalDeliveryFee: pricing.originalDeliveryFee,
            deliveryDiscountAmount:
                pricing.originalDeliveryFee - pricing.deliveryFee,
            freeDeliveryApplied: pricing.freeDeliveryApplied,
            freeDeliveryReason: pricing.freeDeliveryApplied
                ? (pricing.deliveryPricing?.appliedRuleName ?? 'Free Delivery')
                : null,
            freshPointsUsed: pricing.freshPointsRedeemed,
            freshPointsValue: pricing.freshPointsDiscount,
            actualPaymentAmount: pricing.totalAmount,
            couponSnapshot: couponSnapshotJson,
            pricingSnapshot: pricingSnapshotJson,
            deliverySnapshot: deliverySnapshotJson,
            addressSnapshot: addressSnapshotJson,
            finalAmount: pricing.totalAmount,
            orderType: order.orderType,
            sourceOrderNumber: cleanNullableString(order.sourceOrderNumber),
            complaintId: cleanNullableString(order.complaintId),
            placedAt: now,
            confirmedAt: now,
            orderedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
        if (createdOrder.id == null) {
          throw Exception('Failed to allocate order id.');
        }
        final createdOrderId = createdOrder.id!;

        await _incrementCodPlacedCounter(session, userId, transaction);

        await OrderAddressRow.db.insertRow(
          session,
          OrderAddressRow(
            orderId: createdOrderId,
            recipientName: cleanNullableString(order.userName),
            phoneNumber: cleanNullableString(order.userPhone),
            streetLine1: order.deliveryAddress.street.trim(),
            city: order.deliveryAddress.city.trim(),
            state: order.deliveryAddress.state.trim(),
            postalCode: order.deliveryAddress.zipCode.trim(),
            country: order.deliveryAddress.country.trim(),
            latitude: order.deliveryAddress.latitude,
            longitude: order.deliveryAddress.longitude,
            createdAt: now,
          ),
          transaction: transaction,
        );

        final orderItemRows = reconciledItems.map((item) {
          final productId = parseUuid(item.productId, fieldName: 'productId');
          final bogoOfferId = item.isFreeItem
              ? tryParseUuid(bogoOfferIdsByFreeItem[_orderFreeItemKey(item)])
              : null;

          final priceData = itemPrices[_itemPriceKey(item)];
          final serverUnitPrice = priceData?.unitPrice ?? 0;
          final serverTotalPrice = serverUnitPrice * item.quantity;

          return OrderItemRow(
            orderId: createdOrderId,
            productId: productId,
            productVariantId: tryParseUuid(item.variantId),
            comboOfferId: tryParseUuid(item.comboId),
            bogoOfferId: bogoOfferId,
            triggerProductId: tryParseUuid(item.triggerProductId),
            productNameSnapshot: item.productName.trim(),
            productImageUrlSnapshot: cleanNullableString(item.productImage),
            variantLabelSnapshot: cleanNullableString(item.variantLabel),
            mrpSnapshot: itemSnapshots[item.productId]?.mrp,
            skuSnapshot: itemSnapshots[item.productId]?.sku,
            productSlugSnapshot: itemSnapshots[item.productId]?.slug,
            categoryNameSnapshot: itemSnapshots[item.productId]?.categoryName,
            productStatusSnapshot: itemSnapshots[item.productId]?.productStatus,
            appliedOfferSnapshot:
                itemSnapshots[item.productId]?.appliedOfferJson,
            quantity: item.quantity,
            unitPrice: serverUnitPrice,
            totalPrice: serverTotalPrice,
            isFreeItem: item.isFreeItem,
            isFreeDelivery: item.isFreeDelivery,
            isRewardProduct: item.isRewardProduct,
            quantityEditable: item.quantityEditable,
            priceEditable: item.priceEditable,
            originalUnitPrice: item.isFreeItem
                ? item.originalUnitPrice
                : (item.originalUnitPrice ?? serverUnitPrice),
            rewardValue: item.rewardValue,
            rewardOfferId: item.rewardOfferId,
            rewardOfferName: item.rewardOfferName,
            rewardThreshold: item.rewardThreshold,
            rewardSource: item.rewardSource,
            createdAt: now,
          );
        }).toList();

        await OrderItemRow.db.insert(
          session,
          orderItemRows,
          transaction: transaction,
        );

        final paymentTransaction = await PaymentTransactionRow.db.insertRow(
          session,
          PaymentTransactionRow(
            orderId: createdOrderId,
            userId: userId,
            idempotencyKey: normalizedKey,
            gatewayName: 'cod',
            amount: pricing.totalAmount,
            currencyCode: 'INR',
            paymentStatus: 'pending',
            gatewayStatus: 'cod_pending',
            createdAt: now,
            updatedAt: now,
          ),
          transaction: transaction,
        );
        if (paymentTransaction.id == null) {
          throw Exception('Failed to allocate payment transaction id.');
        }
        final paymentTransactionId = paymentTransaction.id!;

        // ── FreshPoints: atomically redeem points if used ──
        if (pricing.freshPointsRedeemed > 0) {
          final fpService = PostgresFreshPointsService();
          await fpService.redeemPoints(
            session,
            userId,
            pricing.freshPointsRedeemed,
            referenceType: 'order',
            referenceId: createdOrderId,
            description:
                'Redeemed ${pricing.freshPointsRedeemed} points for COD order $orderNumber',
            transaction: transaction,
          );
        }

        // ── Side effects: clear cart, deduct stock, increment coupon ──
        await UserCartItemRow.db.deleteWhere(
          session,
          where: (t) => t.userId.equals(userId),
          transaction: transaction,
        );

        await _deductStockInternal(
          session,
          createdOrderId,
          transaction: transaction,
        );

        if (coupon != null && coupon.id != null) {
          await CouponRow.db.updateRow(
            session,
            coupon.copyWith(
              usedCount: coupon.usedCount + 1,
              updatedAt: now,
            ),
            transaction: transaction,
          );
        }

        await IdempotencyRecordRow.db.insertRow(
          session,
          IdempotencyRecordRow(
            scope: _idempotencyScope,
            idempotencyKey: normalizedKey,
            userId: userId,
            orderId: createdOrderId,
            paymentTransactionId: paymentTransactionId,
            requestHash: requestHash,
            responseReference: orderNumber,
            createdAt: now,
          ),
          transaction: transaction,
        );

        return orderNumber;
      });
    } catch (error) {
      final existingOrderNumber = await _findExistingOrderNumberForKey(
        session,
        normalizedKey,
      );
      if (existingOrderNumber != null) {
        return existingOrderNumber;
      }
      rethrow;
    }
  }

  Future<void> collectCodPayment(
    Session session, {
    required String orderId,
    required String collectionMode,
    required String adminFirebaseUid,
  }) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderId),
    );
    if (row == null) {
      throw ArgumentError('Order not found: $orderId');
    }
    if (row.paymentMode != 'cod') {
      throw StateError(
        'Order $orderId is not a COD order (paymentMode: ${row.paymentMode})',
      );
    }
    if (row.paymentStatus == 'paid') {
      throw StateError('COD payment has already been collected for order $orderId');
    }
    if (row.paymentCollectedAt != null) {
      throw StateError('COD payment already collected for order $orderId');
    }
    if (row.orderStatus == 'delivered' || row.orderStatus == 'cancelled') {
      throw StateError(
        'Cannot collect COD payment for order in status: ${row.orderStatus}',
      );
    }

    if (collectionMode != 'cash' && collectionMode != 'upi_qr') {
      throw ArgumentError('collectionMode must be "cash" or "upi_qr"');
    }

    final now = DateTime.now().toUtc();
    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        paymentStatus: 'paid',
        paymentCollectedAt: now,
        paymentCollectedBy: adminFirebaseUid,
        paymentCollectionMode: collectionMode,
        updatedAt: now,
      ),
    );
  }

  Future<CodPaymentReceipt> getCodPaymentReceipt(
    Session session, {
    required String orderId,
  }) async {
    final order = await getOrderById(session, orderId);
    if (order == null) throw Exception('Order not found');
    if (order.paymentMode != 'cod') throw Exception('Not a COD order');
    if (order.paymentStatus != 'paid') throw Exception('COD payment not yet collected');

    String? collectedByName;
    if (order.paymentCollectedBy != null) {
      try {
        final adminUser = await AppUserRow.db.findFirstRow(
          session,
          where: (t) => t.firebaseUid.equals(order.paymentCollectedBy!),
        );
        collectedByName = adminUser?.name ?? adminUser?.phoneNumber;
      } catch (_) {}
    }

    String? gatewayRef;
    final parsedOrderId = parseUuid(orderId, fieldName: 'orderId');
    final txn = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(parsedOrderId),
    );
    gatewayRef = txn?.gatewayPaymentId;

    return CodPaymentReceipt(
      orderNumber: order.orderId,
      paymentMethod: 'Cash on Delivery',
      collectionMethod: order.paymentCollectionMode ?? 'cash',
      amountCollected: order.finalAmount,
      collectionTime: order.paymentCollectedAt,
      collectedBy: collectedByName ?? order.paymentCollectedBy,
      paymentStatus: order.paymentStatus,
      gatewayTransactionReference: gatewayRef,
    );
  }

  Future<CodPaymentReceipt> getUserCodPaymentReceipt(
    Session session, {
    required String orderId,
    String? userId,
  }) async {
    final order = await getOrderById(session, orderId);
    if (order == null) throw Exception('Order not found');
    if (order.paymentMode != 'cod') throw Exception('Not a COD order');
    if (order.paymentStatus != 'paid') throw Exception('COD payment not yet collected');
    if (userId != null && order.userId != userId) {
      throw Exception('Order does not belong to this user');
    }

    String? collectedByName;
    if (order.paymentCollectedBy != null) {
      try {
        final adminUser = await AppUserRow.db.findFirstRow(
          session,
          where: (t) => t.firebaseUid.equals(order.paymentCollectedBy!),
        );
        collectedByName = adminUser?.name ?? adminUser?.phoneNumber;
      } catch (_) {}
    }

    return CodPaymentReceipt(
      orderNumber: order.orderId,
      paymentMethod: 'Cash on Delivery',
      collectionMethod: order.paymentCollectionMode ?? 'cash',
      amountCollected: order.finalAmount,
      collectionTime: order.paymentCollectedAt,
      collectedBy: collectedByName ?? order.paymentCollectedBy,
      paymentStatus: order.paymentStatus,
      gatewayTransactionReference: null,
    );
  }

  Future<OrderPage> getOrdersForUser(
    Session session, {
    required String userReference,
    int limit = _defaultLimit,
    String? pageToken,
  }) async {
    final appUser = await _resolveOrCreateUser(
      session,
      userReference: userReference,
      createIfMissing: false,
    );

    if (appUser == null) {
      return OrderPage(orders: const [], nextPageToken: null, totalCount: 0);
    }

    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultLimit,
      maxLimit: _maxLimit,
    );
    final cursor = _decodeOrderCursor(pageToken);

    final totalCountResult = await session.db.unsafeQuery(
      '''
      SELECT COUNT(*) AS "totalCount"
      FROM customer_order
      WHERE "userId" = @userId::uuid
      ''',
      parameters: QueryParameters.named({'userId': appUser.id.toString()}),
    );
    final totalCount = totalCountResult.isEmpty
        ? 0
        : asInt(totalCountResult.first.toColumnMap()['totalCount']);

    var whereClause = 'WHERE "userId" = @userId::uuid';
    final params = <String, dynamic>{
      'userId': appUser.id.toString(),
      'limit': pageSize + 1,
    };

    if (cursor != null) {
      whereClause += '''
        AND (
          "orderedAt" < @cursorOrderedAt::timestamp
          OR (
            "orderedAt" = @cursorOrderedAt::timestamp
            AND id::text < @cursorOrderId::text
          )
        )''';
      params['cursorOrderedAt'] = cursor.orderedAt.toIso8601String();
      params['cursorOrderId'] = cursor.orderId;
    }

    final orderPageResult = await session.db.unsafeQuery(
      '''
      SELECT
        id::text AS "orderId",
        "orderedAt" AS "orderedAt"
      FROM customer_order
      $whereClause
      ORDER BY "orderedAt" DESC, id DESC
      LIMIT @limit
      ''',
      parameters: QueryParameters.named(params),
    );

    final orderedIds = <String>[];
    final cursors = <_OrderCursor>[];
    for (final row in orderPageResult) {
      final map = row.toColumnMap();
      final orderId = map['orderId']?.toString();
      if (orderId == null || orderId.isEmpty) continue;

      final orderedAt = asDateTime(map['orderedAt']);
      orderedIds.add(orderId);
      cursors.add(_OrderCursor(orderId: orderId, orderedAt: orderedAt));
    }

    final hasMore = orderedIds.length > pageSize;
    if (hasMore) {
      orderedIds.removeLast();
      cursors.removeLast();
    }

    final orders = await _hydrateOrders(
      session,
      orderedIds: orderedIds,
    );

    final nextPageToken = hasMore && cursors.isNotEmpty
        ? encodeCursor({
            'orderId': cursors.last.orderId,
            'orderedAt': cursors.last.orderedAt.toUtc().toIso8601String(),
          })
        : null;

    return OrderPage(
      orders: orders,
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  Future<AppUserRow?> _resolveOrCreateUser(
    Session session, {
    required String userReference,
    String? phoneNumber,
    String? userName,
    Transaction? transaction,
    bool createIfMissing = false,
  }) async {
    final trimmedReference = userReference.trim();
    final parsedUserId = tryParseUuid(trimmedReference);

    if (parsedUserId != null) {
      final byId = await AppUserRow.db.findById(
        session,
        parsedUserId,
        transaction: transaction,
      );
      if (byId != null && byId.status == 'active') {
        return byId;
      }
    }

    if (trimmedReference.isNotEmpty) {
      final byFirebaseUid = await AppUserRow.db.findFirstRow(
        session,
        where: (t) =>
            t.firebaseUid.equals(trimmedReference) & t.status.equals('active'),
        transaction: transaction,
      );
      if (byFirebaseUid != null) {
        return byFirebaseUid;
      }
    }

    if (!createIfMissing) {
      return null;
    }

    final normalizedPhone = cleanNullableString(phoneNumber);
    if (normalizedPhone == null) {
      throw Exception('phoneNumber is required to create a user.');
    }

    return AppUserRow.db.insertRow(
      session,
      AppUserRow(
        firebaseUid: trimmedReference.isEmpty ? null : trimmedReference,
        phoneNumber: normalizedPhone,
        name: cleanNullableString(userName),
      ),
      transaction: transaction,
    );
  }

  Future<CouponRow?> _resolveCoupon(
    Session session, {
    required String? couponReference,
    Transaction? transaction,
  }) async {
    final normalized = cleanNullableString(couponReference);
    if (normalized == null) return null;

    final couponId = tryParseUuid(normalized);
    if (couponId != null) {
      final byId = await CouponRow.db.findById(
        session,
        couponId,
        transaction: transaction,
      );
      if (byId != null && byId.status == 'active') {
        return byId;
      }
    }

    return CouponRow.db.findFirstRow(
      session,
      where: (t) => t.code.equals(normalized) & t.status.equals('active'),
      transaction: transaction,
    );
  }

  Future<String?> _findExistingOrderNumberForKey(
    Session session,
    String idempotencyKey,
  ) async {
    final existing = await IdempotencyRecordRow.db.findFirstRow(
      session,
      where: (t) =>
          t.scope.equals(_idempotencyScope) &
          t.idempotencyKey.equals(idempotencyKey),
    );
    if (existing == null) return null;

    if (existing.responseReference != null &&
        existing.responseReference!.trim().isNotEmpty) {
      return existing.responseReference!;
    }

    if (existing.orderId == null) return null;
    final order = await CustomerOrderRow.db.findById(
      session,
      existing.orderId!,
    );
    return order?.orderNumber;
  }

  Future<List<Order>> _hydrateOrders(
    Session session, {
    required List<String> orderedIds,
  }) async {
    if (orderedIds.isEmpty) return const [];

    final orderIds = orderedIds
        .map((id) => parseUuid(id, fieldName: 'orderId'))
        .toSet();

    final orders = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.id.inSet(orderIds),
    );
    if (orders.isEmpty) return const [];

    final orderById = {for (final order in orders) order.id!.toString(): order};
    final userIds = orders.map((order) => order.userId).toSet();
    final users = await AppUserRow.db.find(
      session,
      where: (t) => t.id.inSet(userIds),
    );
    final userById = {for (final user in users) user.id!.toString(): user};

    final items = await OrderItemRow.db.find(
      session,
      where: (t) => t.orderId.inSet(orderIds),
    );
    final itemsByOrder = <String, List<OrderItemRow>>{};
    for (final item in items) {
      itemsByOrder.putIfAbsent(item.orderId.toString(), () => []).add(item);
    }

    final comboOfferIds = items
        .map((item) => item.comboOfferId)
        .whereType<UuidValue>()
        .toSet();
    final comboOffers = comboOfferIds.isEmpty
        ? const <ComboOfferRow>[]
        : await ComboOfferRow.db.find(
            session,
            where: (t) => t.id.inSet(comboOfferIds),
          );
    final comboById = {for (final combo in comboOffers) combo.id!: combo};

    final comboOfferItems = comboOfferIds.isEmpty
        ? const <ComboOfferItemRow>[]
        : await ComboOfferItemRow.db.find(
            session,
            where: (t) => t.comboOfferId.inSet(comboOfferIds),
          );
    final comboItemQuantityByKey = <String, int>{};
    for (final item in comboOfferItems) {
      comboItemQuantityByKey[_comboItemKey(
            item.comboOfferId,
            item.productId,
            item.productVariantId,
          )] =
          item.quantity;
    }

    final addresses = await OrderAddressRow.db.find(
      session,
      where: (t) => t.orderId.inSet(orderIds),
    );
    final addressByOrder = {
      for (final address in addresses) address.orderId.toString(): address,
    };

    final payments = await PaymentTransactionRow.db.find(
      session,
      where: (t) => t.orderId.inSet(orderIds),
    );
    final paymentByOrder = <String, PaymentTransactionRow>{};
    for (final payment in payments) {
      final key = payment.orderId.toString();
      final existing = paymentByOrder[key];
      if (existing == null || payment.createdAt.isAfter(existing.createdAt)) {
        paymentByOrder[key] = payment;
      }
    }

    final couponIds = orders
        .map((order) => order.couponId)
        .whereType<UuidValue>()
        .toSet();
    final coupons = couponIds.isEmpty
        ? const <CouponRow>[]
        : await CouponRow.db.find(
            session,
            where: (t) => t.id.inSet(couponIds),
          );
    final couponById = {for (final coupon in coupons) coupon.id!: coupon};

    final hydrated = <Order>[];
    for (final orderId in orderedIds) {
      final order = orderById[orderId];
      if (order == null) continue;

      final address = addressByOrder[orderId];
      if (address == null) continue;

      final mappedItems = (itemsByOrder[orderId] ?? const <OrderItemRow>[]).map(
        (item) {
          final comboOfferId = item.comboOfferId;
          final combo = comboOfferId == null ? null : comboById[comboOfferId];
          final comboItemQuantity = comboOfferId == null
              ? null
              : comboItemQuantityByKey[_comboItemKey(
                  comboOfferId,
                  item.productId,
                  item.productVariantId,
                )];

          return OrderItem(
            orderItemId: item.id?.toString(),
            productId: item.productId.toString(),
            variantId: item.productVariantId?.toString(),
            variantLabel: item.variantLabelSnapshot,
            productName: item.productNameSnapshot,
            productImage: item.productImageUrlSnapshot ?? '',
            mrp: item.mrpSnapshot,
            sku: item.skuSnapshot,
            productSlug: item.productSlugSnapshot,
            categoryName: item.categoryNameSnapshot,
            productStatus: item.productStatusSnapshot,
            appliedOfferSnapshot: item.appliedOfferSnapshot,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            totalPrice: item.totalPrice,
            isFreeItem: item.isFreeItem,
            isFreeDelivery: item.isFreeDelivery,
            rewardOfferId: item.rewardOfferId,
            rewardOfferName: item.rewardOfferName,
            rewardThreshold: item.rewardThreshold,
            rewardSource: item.rewardSource,
            triggerProductId: item.triggerProductId?.toString(),
            comboId: comboOfferId?.toString(),
            comboName: combo?.name,
            comboDiscountType: combo?.discountType,
            comboDiscountValue: combo?.discountValue,
            comboItemQuantity: comboItemQuantity,
          );
        },
      ).toList();

      final payment = paymentByOrder[orderId];
      final appUser = userById[order.userId.toString()];

      hydrated.add(
        Order(
          orderId: order.orderNumber,
          userId: appUser?.firebaseUid ?? order.userId.toString(),
          userName: address.recipientName ?? appUser?.name,
          userPhone: address.phoneNumber ?? appUser?.phoneNumber ?? '',
          items: mappedItems,
          itemCount: order.itemCount,
          totalAmount: order.totalAmount,
          discountAmount: order.discountAmount,
          mrpTotal: order.mrpTotal,
          productDiscountAmount: order.productDiscountAmount,
          comboDiscountAmount: order.comboDiscountAmount,
          bogoDiscountAmount: order.bogoDiscountAmount,
          categoryOfferDiscountAmount: order.categoryOfferDiscountAmount,
          deliveryFee: order.deliveryFee,
          originalDeliveryFee: order.originalDeliveryFee,
          deliveryDiscountAmount: order.deliveryDiscountAmount,
          freeDeliveryApplied: order.freeDeliveryApplied,
          freeDeliveryReason: order.freeDeliveryReason,
          couponSnapshot: order.couponSnapshot,
          paymentSnapshot: order.paymentSnapshot,
          addressSnapshot: order.addressSnapshot,
          pricingSnapshot: order.pricingSnapshot,
          deliverySnapshot: order.deliverySnapshot,
          freshPointsUsed: order.freshPointsUsed,
          freshPointsValue: order.freshPointsValue,
          actualPaymentAmount: order.actualPaymentAmount,
          finalAmount: order.finalAmount,
          status: order.orderStatus,
          paymentStatus: order.paymentStatus,
          refundStatus: order.refundStatus,
          razorpayOrderId: payment?.gatewayOrderId,
          razorpayPaymentId: payment?.gatewayPaymentId,
          deliveryAddress: Address(
            street: address.streetLine1,
            city: address.city,
            state: address.state,
            zipCode: address.postalCode,
            country: address.country,
            latitude: address.latitude,
            longitude: address.longitude,
          ),
          orderedAt: order.orderedAt,
          confirmedAt: order.confirmedAt,
          outForDeliveryAt: order.outForDeliveryAt,
          deliveredAt: order.deliveredAt,
          cancelledAt: order.cancelledAt,
          cancellationReason: order.cancellationReason,
          deliveryPersonName: order.deliveryPersonName,
          deliveryPersonPhone: order.deliveryPersonPhone,
          deliveryOtp: order.deliveryOtp,
          deliveryOtpExpiresAt: order.deliveryOtpExpiresAt,
          deliveryVerificationMethod: order.deliveryVerificationMethod,
          deliveryProofImageUrl: order.deliveryProofImageUrl,
          deliveryProofLatitude: order.deliveryProofLatitude,
          deliveryProofLongitude: order.deliveryProofLongitude,
          deliveryProofTimestamp: order.deliveryProofTimestamp,
          deliveryProofDistanceMeters: order.deliveryProofDistanceMeters,
          deliveryProofGpsAccuracy: order.deliveryProofGpsAccuracy,
          deliveredByUserId: order.deliveredByUserId,
          deliveredByName: order.deliveredByName,
          deliveredByRole: order.deliveredByRole,
          deliveryCompletedAt: order.deliveryCompletedAt,
          deliveryOtpVerifiedAt: order.deliveryOtpVerifiedAt,
          orderType: order.orderType,
          sourceOrderNumber: order.sourceOrderNumber,
          complaintId: order.complaintId,
          couponApplied: order.couponId == null
              ? null
              : couponById[order.couponId!]?.code ?? order.couponId.toString(),
          paymentMode: order.paymentMode,
          paymentCollectedAt: order.paymentCollectedAt,
          paymentCollectedBy: order.paymentCollectedBy,
          paymentCollectionMode: order.paymentCollectionMode,
          codFailureReason: order.codFailureReason,
        ),
      );
    }

    return hydrated;
  }

  _OrderCursor? _decodeOrderCursor(String? token) {
    final data = decodeCursor(token);
    if (data == null) return null;

    final orderId = data['orderId']?.toString();
    final orderedAtRaw = data['orderedAt'];
    if (orderId == null || orderedAtRaw == null) {
      throw Exception('Invalid page token.');
    }

    return _OrderCursor(
      orderId: orderId,
      orderedAt: DateTime.parse(orderedAtRaw.toString()),
    );
  }

  String _generateOrderNumber() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    final suffix = (_random.nextInt(900) + 100).toString();
    return 'ORD$millis$suffix';
  }

  Future<String> createOrder(
    Session session,
    Order order,
  ) {
    return createPendingOrder(
      session,
      order: order,
      idempotencyKey:
          'direct-${DateTime.now().millisecondsSinceEpoch}-${order.userId}',
    );
  }

  String _comboItemKey(
    UuidValue comboOfferId,
    UuidValue productId,
    UuidValue? productVariantId,
  ) {
    return [
      comboOfferId.toString(),
      productId.toString(),
      productVariantId?.toString() ?? '',
    ].join('|');
  }

  String _orderFreeItemKey(OrderItem item) {
    return [
      item.productId,
      item.variantId ?? '',
      item.triggerProductId ?? '',
      item.quantity.toString(),
    ].join('|');
  }

  Future<List<Order>> getUserOrders(
    Session session,
    String userReference,
  ) async {
    final page = await getOrdersForUser(
      session,
      userReference: userReference,
      limit: 200,
    );
    return page.orders;
  }

  Future<Order?> getOrderById(
    Session session,
    String orderNumber,
  ) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row?.id == null) return null;

    final orders = await _hydrateOrders(
      session,
      orderedIds: [row!.id!.toString()],
    );
    return orders.isEmpty ? null : orders.first;
  }

  Future<List<Order>> getOrders(
    Session session, {
    int limit = 20,
    String? status,
  }) async {
    final page = await getOrdersPage(
      session,
      limit: limit,
      status: status,
    );
    return page.orders;
  }

  Future<OrderPage> getOrdersPage(
    Session session, {
    int limit = 20,
    String? pageToken,
    String? status,
    String? paymentMode,
    String? paymentStatus,
    String? paymentCollectionMode,
  }) async {
    final pageSize = clampPageLimit(
      limit,
      defaultLimit: _defaultLimit,
      maxLimit: _maxLimit,
    );
    final cursor = _decodeOrderCursor(pageToken);
    final totalCount = await getOrdersCount(
      session,
      status: status,
      paymentMode: paymentMode,
      paymentStatus: paymentStatus,
      paymentCollectionMode: paymentCollectionMode,
    );

    final rows = await CustomerOrderRow.db.find(
      session,
      where: _buildOrderWhereClause(
        status: status,
        paymentMode: paymentMode,
        paymentStatus: paymentStatus,
        paymentCollectionMode: paymentCollectionMode,
      ),
      limit: pageSize + 1,
      orderBy: (t) => t.orderedAt,
      orderDescending: true,
    );

    final filtered = cursor == null
        ? rows
        : rows.where((row) {
            final rowId = row.id?.toString();
            if (rowId == null) return false;
            return row.orderedAt.isBefore(cursor.orderedAt) ||
                (row.orderedAt.isAtSameMomentAs(cursor.orderedAt) &&
                    rowId.compareTo(cursor.orderId) < 0);
          }).toList();

    final hasMore = filtered.length > pageSize;
    final pageRows = hasMore ? filtered.take(pageSize).toList() : filtered;
    final orders = await _hydrateOrders(
      session,
      orderedIds: pageRows.map((row) => row.id!.toString()).toList(),
    );

    final nextPageToken = hasMore && pageRows.isNotEmpty
        ? encodeCursor({
            'orderId': pageRows.last.id!.toString(),
            'orderedAt': pageRows.last.orderedAt.toUtc().toIso8601String(),
          })
        : null;

    return OrderPage(
      orders: orders,
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  Future<int> getOrdersCount(
    Session session, {
    String? status,
    String? paymentMode,
    String? paymentStatus,
    String? paymentCollectionMode,
  }) {
    return CustomerOrderRow.db.count(
      session,
      where: _buildOrderWhereClause(
        status: status,
        paymentMode: paymentMode,
        paymentStatus: paymentStatus,
        paymentCollectionMode: paymentCollectionMode,
      ),
    );
  }

  Future<List<Order>> getTodayOrders(Session session) async {
    final now = DateTime.now().toUtc();
    final start = DateTime.utc(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final rows = await CustomerOrderRow.db.find(
      session,
      where: (t) => t.orderedAt.between(start, end),
      orderBy: (t) => t.orderedAt,
      orderDescending: true,
    );
    return _hydrateOrders(
      session,
      orderedIds: rows.map((row) => row.id!.toString()).toList(),
    );
  }

  Future<bool> updateOrderStatus(
    Session session,
    String orderNumber,
    String newStatus, {
    String? cancellationReason,
  }) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) return false;

    final now = DateTime.now().toUtc();
    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        orderStatus: newStatus,
        confirmedAt: newStatus == 'confirmed' ? now : row.confirmedAt,
        packedAt: newStatus == 'packed' ? now : row.packedAt,
        outForDeliveryAt:
            (newStatus == 'out_for_delivery' ||
                newStatus == 'delivery_otp_pending')
            ? now
            : row.outForDeliveryAt,
        deliveredAt: newStatus == 'delivered' ? now : row.deliveredAt,
        cancelledAt: newStatus == 'cancelled' ? now : row.cancelledAt,
        cancellationReason: newStatus == 'cancelled'
            ? cancellationReason
            : row.cancellationReason,
        updatedAt: now,
      ),
    );

    final needsStockRestore = row.paymentStatus == 'paid' ||
        row.paymentMode == 'cod';
    if (newStatus == 'cancelled' && needsStockRestore) {
      await session.db.transaction((transaction) async {
        await _restoreStockForCancelledOrder(
          session,
          row.id!,
          transaction: transaction,
        );
        await _decrementCouponForCancelledOrder(
          session,
          row,
          transaction: transaction,
        );
      });
    }

    if (newStatus == 'delivered') {
      // Increment COD delivered counter
      await _incrementCodDeliveredCounter(session, row);
      // Auto-unblock user if prepaid order restores COD access
      await _autoUnblockCodIfEligible(session, row);
      // Resolve pending redelivery complaints for this order
      await _resolvePendingRedeliveryComplaints(session, row);
    }

    return true;
  }

  Future<Order?> updateDeliveryAddress(
    Session session, {
    required String orderNumber,
    required Address deliveryAddress,
    String? deliveryNote,
    bool allowOutForDelivery = false,
    Transaction? transaction,
  }) async {
    if (transaction != null) {
      await _updateDeliveryAddress(
        session,
        orderNumber: orderNumber,
        deliveryAddress: deliveryAddress,
        deliveryNote: deliveryNote,
        allowOutForDelivery: allowOutForDelivery,
        transaction: transaction,
      );
      return getOrderById(session, orderNumber);
    }

    await session.db.transaction<void>((tx) async {
      await _updateDeliveryAddress(
        session,
        orderNumber: orderNumber,
        deliveryAddress: deliveryAddress,
        deliveryNote: deliveryNote,
        allowOutForDelivery: allowOutForDelivery,
        transaction: tx,
      );
    });
    return getOrderById(session, orderNumber);
  }

  Future<void> _updateDeliveryAddress(
    Session session, {
    required String orderNumber,
    required Address deliveryAddress,
    String? deliveryNote,
    required bool allowOutForDelivery,
    required Transaction transaction,
  }) async {
    final order = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber.trim()),
      transaction: transaction,
      lockMode: LockMode.forUpdate,
    );
    if (order == null) {
      throw Exception('Order not found.');
    }
    if (order.orderStatus == 'delivered' || order.orderStatus == 'cancelled') {
      throw Exception('Completed orders cannot be updated.');
    }
    if (!allowOutForDelivery && order.orderStatus == 'out_for_delivery') {
      throw Exception(
        'Delivery address changes are not allowed after the order is out for delivery.',
      );
    }

    final address = await OrderAddressRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(order.id!),
      transaction: transaction,
      lockMode: LockMode.forUpdate,
    );
    if (address == null) {
      throw Exception('Order address not found.');
    }

    final now = DateTime.now().toUtc();
    await OrderAddressRow.db.updateById(
      session,
      address.id!,
      columnValues: (t) => [
        t.streetLine1(deliveryAddress.street.trim()),
        t.city(deliveryAddress.city.trim()),
        t.state(deliveryAddress.state.trim()),
        t.postalCode(deliveryAddress.zipCode.trim()),
        t.country(deliveryAddress.country.trim()),
        t.latitude(deliveryAddress.latitude),
        t.longitude(deliveryAddress.longitude),
        t.landmark(cleanNullableString(deliveryNote) ?? address.landmark),
      ],
      transaction: transaction,
    );

    final tracking = await OrderTrackingRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(order.id!),
      transaction: transaction,
      lockMode: LockMode.forUpdate,
    );
    final formattedAddress = _formatAddress(deliveryAddress);
    if (tracking == null) {
      await OrderTrackingRow.db.insertRow(
        session,
        OrderTrackingRow(
          orderId: order.id!,
          trackingEnabled: order.orderStatus == 'out_for_delivery',
          userLatitude: deliveryAddress.latitude,
          userLongitude: deliveryAddress.longitude,
          userAddress: formattedAddress,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    } else {
      await OrderTrackingRow.db.updateById(
        session,
        tracking.id!,
        columnValues: (t) => [
          t.userLatitude(deliveryAddress.latitude),
          t.userLongitude(deliveryAddress.longitude),
          t.userAddress(formattedAddress),
          t.updatedAt(now),
        ],
        transaction: transaction,
      );
    }

    await CustomerOrderRow.db.updateById(
      session,
      order.id!,
      columnValues: (t) => [
        t.updatedAt(now),
      ],
      transaction: transaction,
    );
  }

  Future<bool> updatePaymentStatus(
    Session session,
    String orderNumber,
    String paymentStatus, {
    String? gatewayPaymentId,
  }) async {
    final orderRow = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (orderRow == null) return false;

    final paymentRow = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(orderRow.id!),
    );

    final now = DateTime.now().toUtc();
    await CustomerOrderRow.db.updateRow(
      session,
      orderRow.copyWith(
        paymentStatus: paymentStatus,
        updatedAt: now,
      ),
    );
    if (paymentRow != null) {
      await PaymentTransactionRow.db.updateRow(
        session,
        paymentRow.copyWith(
          paymentStatus: paymentStatus,
          gatewayPaymentId: gatewayPaymentId ?? paymentRow.gatewayPaymentId,
          paidAt: paymentStatus == 'paid' ? now : paymentRow.paidAt,
          updatedAt: now,
        ),
      );
    }
    if (paymentStatus == 'paid') {
      try {
        await _analytics.processPaidOrder(session, orderRow.orderNumber);
      } catch (error, stackTrace) {
        session.log(
          'Product analytics processing failed for order ${orderRow.orderNumber}: $error',
          level: LogLevel.warning,
          exception: error,
          stackTrace: stackTrace,
        );
      }
    }
    return true;
  }

  Future<bool> confirmOrder(
    Session session,
    String orderNumber,
  ) {
    return updateOrderStatus(
      session,
      orderNumber,
      'confirmed',
    );
  }

  Future<bool> cancelOrder(
    Session session,
    String orderNumber,
    String userReference, {
    String reason = 'user_cancelled',
  }) async {
    final order = await getOrderById(session, orderNumber);
    if (order == null) return false;
    if (order.userId != userReference) {
      final appUser = await _resolveOrCreateUser(
        session,
        userReference: userReference,
        createIfMissing: false,
      );
      if (appUser == null || appUser.id?.toString() != order.userId) {
        throw Exception('Order does not belong to user.');
      }
    }
    return updateOrderStatus(
      session,
      orderNumber,
      'cancelled',
      cancellationReason: reason,
    );
  }

  Future<void> _restoreStockForCancelledOrder(
    Session session,
    UuidValue orderId, {
    Transaction? transaction,
  }) async {
    try {
      final orderItems = await OrderItemRow.db.find(
        session,
        where: (t) => t.orderId.equals(orderId),
      );
      if (orderItems.isEmpty) return;

      const unitConversions = <String, double>{
        'gm': 1.0,
        'kg': 1000.0,
        'litre': 1000.0,
        'ml': 1.0,
        'pc': 1.0,
        'pack': 1.0,
      };

      for (final item in orderItems) {
        final product = await ProductRow.db.findById(
          session,
          item.productId,
          transaction: transaction,
        );
        if (product == null || product.stock == null) continue;

        double restoreAmount = 0;
        if (item.productVariantId != null) {
          final variant = await ProductVariantRow.db.findById(
            session,
            item.productVariantId!,
            transaction: transaction,
          );
          if (variant != null) {
            final vUnit = variant.quantityUnit.toLowerCase();
            final pUnit = (product.stockUnit ?? product.baseUnit ?? 'unit')
                .toLowerCase();
            final inGrams =
                variant.quantityValue * (unitConversions[vUnit] ?? 1.0);
            final inBase = inGrams / (unitConversions[pUnit] ?? 1.0);
            restoreAmount = inBase * item.quantity;
          } else {
            restoreAmount = item.quantity.toDouble();
          }
        } else {
          restoreAmount = item.quantity.toDouble();
        }

        final newStock = product.stock! + restoreAmount;

        await ProductRow.db.updateRow(
          session,
          product.copyWith(
            stock: newStock,
            status: newStock > 0 ? 'active' : product.status,
            updatedAt: DateTime.now().toUtc(),
          ),
          transaction: transaction,
        );
      }
    } catch (e) {
      session.log(
        'Stock restore for cancelled order failed: $e',
        level: LogLevel.error,
      );
    }
  }

  Future<void> _decrementCouponForCancelledOrder(
    Session session,
    CustomerOrderRow order, {
    Transaction? transaction,
  }) async {
    if (order.couponId == null) return;
    try {
      final coupon = await CouponRow.db.findById(
        session,
        order.couponId!,
        transaction: transaction,
      );
      if (coupon == null || coupon.usedCount <= 0) return;

      await CouponRow.db.updateRow(
        session,
        coupon.copyWith(
          usedCount: coupon.usedCount - 1,
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
    } catch (e) {
      session.log(
        'Coupon usage decrement for cancelled order failed: $e',
        level: LogLevel.error,
      );
    }
  }

  /// List orders with cancellation_requested status (admin).
  Future<OrderPage> listCancellationRequests(
    Session session, {
    int limit = 20,
    String? pageToken,
  }) async {
    final limitVal = limit.clamp(1, 100);
    final offsetVal = _decodePageToken(pageToken);

    final countResult = await session.db.unsafeQuery(
      '''
      SELECT COUNT(*) AS cnt FROM customer_order
      WHERE "orderStatus" = 'cancellation_requested'
      ''',
    );
    final totalCount = countResult.isNotEmpty
        ? asInt(countResult.first.toColumnMap()['cnt'])
        : 0;

    final rows = await session.db.unsafeQuery(
      '''
      SELECT co.*
      FROM customer_order co
      WHERE co."orderStatus" = 'cancellation_requested'
      ORDER BY co."updatedAt" DESC
      LIMIT @limitVal OFFSET @offsetVal
      ''',
      parameters: QueryParameters.named({
        'limitVal': limitVal + 1,
        'offsetVal': offsetVal,
      }),
    );

    final orderRows = rows
        .map((r) => CustomerOrderRow.fromJson(r.toColumnMap()))
        .take(limitVal)
        .toList();

    String? nextPageToken;
    if (rows.length > limitVal) {
      nextPageToken = _encodePageToken(offsetVal + limitVal);
    }

    final orderIds = orderRows.map((r) => r.id!.toString()).toList();
    final orders = await _hydrateOrders(session, orderedIds: orderIds);
    return OrderPage(
      orders: orders,
      nextPageToken: nextPageToken,
      totalCount: totalCount,
    );
  }

  /// User requests cancellation — sets status to cancellation_requested.
  /// Stores original status + reason in cancellationReason as JSON.
  Future<bool> requestCancellation(
    Session session,
    String orderNumber,
    String userReference, {
    String reason = 'User requested cancellation',
  }) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) return false;

    final originalStatus = row.orderStatus;
    final now = DateTime.now().toUtc();
    final reasonJson = jsonEncode({
      'reason': reason,
      'originalStatus': originalStatus,
    });

    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        orderStatus: 'cancellation_requested',
        cancellationReason: reasonJson,
        updatedAt: now,
      ),
    );

    await OrderOutboxService.instance.enqueueOrderStatusChanged(
      session: session,
      orderId: orderNumber,
      userId: row.userId.toString(),
      status: 'cancellation_requested',
    );

    return true;
  }

  /// Admin approves cancellation request — calculates refund and processes it.
  Future<RefundRecord> approveCancellationRequest(
    Session session,
    String orderNumber, {
    double? fixedRefundAmount,
    String adminNote = '',
  }) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) throw Exception('Order not found');

    final now = DateTime.now().toUtc();
    final reasonData = _parseCancellationReason(row.cancellationReason);
    final originalStatus =
        reasonData['originalStatus'] as String? ?? 'confirmed';

    double refundAmount;
    if (fixedRefundAmount != null) {
      refundAmount = fixedRefundAmount;
    } else if (originalStatus == 'out_for_delivery') {
      refundAmount = row.finalAmount - row.deliveryFee;
      if (refundAmount < 0) refundAmount = 0;
    } else {
      refundAmount = row.finalAmount;
    }

    await session.db.transaction((transaction) async {
      await CustomerOrderRow.db.updateRow(
        session,
        row.copyWith(
          orderStatus: 'cancelled',
          paymentStatus: row.paymentStatus == 'paid'
              ? 'refunded'
              : row.paymentStatus,
          refundStatus: 'refund_initiated',
          cancelledAt: now,
          cancellationReason: adminNote.isNotEmpty
              ? 'Approved: $adminNote'
              : 'Cancellation approved',
          updatedAt: now,
        ),
        transaction: transaction,
      );

      final needsStockRestore = row.paymentStatus == 'paid' ||
          row.paymentMode == 'cod';
      if (needsStockRestore) {
        await _restoreStockForCancelledOrder(
          session,
          row.id!,
          transaction: transaction,
        );
        await _decrementCouponForCancelledOrder(
          session,
          row,
          transaction: transaction,
        );
      }
    });

    await OrderOutboxService.instance.enqueueOrderStatusChanged(
      session: session,
      orderId: orderNumber,
      userId: row.userId.toString(),
      status: 'cancelled',
    );

    if (row.paymentStatus == 'paid' && refundAmount > 0) {
      final refundRecord = await _refundService.refund(
        session,
        orderNumber: orderNumber,
        amount: refundAmount,
        source: 'cancellation',
        reason: 'Cancellation refund: $adminNote',
      );
      return refundRecord;
    }

    return _createLocalRefundRecord(session, row, refundAmount);
  }

  /// Admin rejects cancellation request — restores original status.
  Future<bool> rejectCancellationRequest(
    Session session,
    String orderNumber, {
    String adminNote = '',
  }) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) return false;

    final reasonData = _parseCancellationReason(row.cancellationReason);
    final originalStatus =
        reasonData['originalStatus'] as String? ?? 'confirmed';
    final now = DateTime.now().toUtc();

    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        orderStatus: originalStatus,
        cancellationReason: 'Rejected: $adminNote',
        updatedAt: now,
      ),
    );

    await OrderOutboxService.instance.enqueueOrderStatusChanged(
      session: session,
      orderId: orderNumber,
      userId: row.userId.toString(),
      status: originalStatus,
    );

    return true;
  }

  Map<String, dynamic> _parseCancellationReason(String? rawReason) {
    if (rawReason == null || rawReason.trim().isEmpty) {
      return {'reason': '', 'originalStatus': 'confirmed'};
    }
    try {
      final parsed = jsonDecode(rawReason);
      if (parsed is Map<String, dynamic>) return parsed;
    } catch (_) {}
    return {'reason': rawReason, 'originalStatus': 'confirmed'};
  }

  Future<RefundRecord> _createLocalRefundRecord(
    Session session,
    CustomerOrderRow order,
    double amount,
  ) async {
    final now = DateTime.now().toUtc();
    final payment = await PaymentTransactionRow.db.findFirstRow(
      session,
      where: (t) => t.orderId.equals(order.id!),
    );
    final row = await RefundRecordRow.db.insertRow(
      session,
      RefundRecordRow(
        orderId: order.id!,
        paymentTransactionId: payment?.id ?? order.id!,
        userId: order.userId,
        amount: amount,
        refundStatus: 'processed',
        source: 'cancellation',
        reason: 'Cancellation refund',
        createdAt: now,
        updatedAt: now,
      ),
    );
    return RefundRecord(
      refundId: row.id!.toString(),
      orderId: order.orderNumber,
      paymentId: row.paymentTransactionId.toString(),
      userId: row.userId.toString(),
      amount: amount,
      status: 'processed',
      source: 'cancellation',
      reason: 'Cancellation refund',
      createdAt: now,
      updatedAt: now,
    );
  }

  int _decodePageToken(String? token) {
    if (token == null || token.isEmpty) return 0;
    return int.tryParse(token) ?? 0;
  }

  String _encodePageToken(int offset) => offset.toString();

  String _formatAddress(Address address) {
    final parts = [
      address.street,
      address.city,
      address.state,
      address.zipCode,
      address.country,
    ].where((part) => part.trim().isNotEmpty).toList(growable: false);
    return parts.join(', ');
  }

  Future<void> setDeliveryVerificationMethod(
    Session session,
    String orderNumber,
    String method,
  ) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) return;
    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        deliveryVerificationMethod: method,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<bool> assignDeliveryPerson(
    Session session,
    String orderNumber,
    String deliveryPersonName,
    String deliveryPersonPhone,
  ) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) return false;

    final now = DateTime.now().toUtc();
    await CustomerOrderRow.db.updateRow(
      session,
      row.copyWith(
        deliveryPersonName: deliveryPersonName.trim(),
        deliveryPersonPhone: deliveryPersonPhone.trim(),
        updatedAt: now,
      ),
    );
    return true;
  }

  // --- PHASE 5: Server-side pricing helpers ---

  List<CartItemInput> _buildCartItemInputs(Order order) {
    final bogoTriggerMap = <String, String>{};
    for (final item in order.items) {
      if (item.isFreeItem && item.triggerProductId != null) {
        bogoTriggerMap[item.triggerProductId!] = item.productId;
      }
    }

    final result = <CartItemInput>[];
    for (final item in order.items) {
      if (item.isFreeItem) continue;
      result.add(
        CartItemInput(
          productId: item.productId,
          variantId: item.variantId,
          quantity: item.quantity,
          comboId: item.comboId,
          bogoFreeProductId: bogoTriggerMap[item.productId],
        ),
      );
    }
    return result;
  }

  String _itemPriceKey(OrderItem item) {
    return '${item.productId}|${item.variantId ?? ''}';
  }

  Future<Map<String, ({double unitPrice, double? mrp})>> _calculateItemPrices(
    Session session,
    List<OrderItem> items,
  ) async {
    final variantIds = <UuidValue>{};
    final productIdsForVariantless = <UuidValue>{};
    for (final item in items) {
      if (item.isFreeItem) continue;
      final vid = item.variantId == null ? null : tryParseUuid(item.variantId!);
      if (vid != null) {
        variantIds.add(vid);
      } else {
        final pid = tryParseUuid(item.productId);
        if (pid != null) productIdsForVariantless.add(pid);
      }
    }

    final variantRows = variantIds.isEmpty
        ? <ProductVariantRow>[]
        : await ProductVariantRow.db.find(
            session,
            where: (t) => t.id.inSet(variantIds),
          );
    final variantByKey = {
      for (final v in variantRows) v.id!.toString(): v,
    };

    Map<String, ProductVariantRow> defaultVariantByProduct = {};
    if (productIdsForVariantless.isNotEmpty) {
      final variantlessVariants = await ProductVariantRow.db.find(
        session,
        where: (t) => t.productId.inSet(productIdsForVariantless),
        orderBy: (t) => t.sortOrder,
      );
      for (final v in variantlessVariants) {
        final pid = v.productId.toString();
        defaultVariantByProduct.putIfAbsent(pid, () => v);
      }
    }

    final result = <String, ({double unitPrice, double? mrp})>{};
    for (final item in items) {
      if (item.isFreeItem) continue;
      final key = _itemPriceKey(item);

      double unitPrice;
      double? mrp;
      if (item.variantId != null) {
        final variant = variantByKey[item.variantId!];
        if (variant != null) {
          unitPrice = variant.salePrice;
          mrp = variant.listPrice;
        } else {
          unitPrice = 0;
          mrp = null;
        }
      } else {
        final defaultVariant = defaultVariantByProduct[item.productId];
        if (defaultVariant != null) {
          unitPrice = defaultVariant.salePrice;
          mrp = defaultVariant.listPrice;
        } else {
          unitPrice = 0;
          mrp = null;
        }
      }
      result[key] = (unitPrice: unitPrice, mrp: mrp);
    }
    return result;
  }

  double _calculateServerMrpTotal(
    Map<String, ({double unitPrice, double? mrp})> itemPrices,
    List<OrderItem> items,
  ) {
    double total = 0;
    for (final item in items) {
      if (item.isFreeItem) continue;
      final key = _itemPriceKey(item);
      final priceData = itemPrices[key];
      if (priceData == null) continue;
      total += (priceData.mrp ?? priceData.unitPrice) * item.quantity;
    }
    return total;
  }

  String _buildPricingSnapshot(
    CartPricingResult pricing, {
    String? couponCode,
    String? paymentMethod,
  }) {
    if (pricing.freshPointsRedeemed > 0) {
      return jsonEncode({
        'snapshotVersion': 2,
        'subtotal': pricing.subtotal,
        'deliveryCharge': pricing.deliveryFee,
        'couponCode': couponCode,
        'couponDiscount': pricing.couponDiscount,
        'freshPointsUsed': pricing.freshPointsRedeemed,
        'freshPointsValue': pricing.freshPointsDiscount,
        'actualPaymentAmount': pricing.totalAmount,
        'paymentMethod': paymentMethod,
        'redemptionLimitPercent': 50,
        'finalPayableAmount': pricing.totalAmount,
        'grandTotal': pricing.totalAmount,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      });
    }
    return jsonEncode({
      'subtotal': pricing.subtotal,
      'offerDiscount':
          pricing.itemDiscounts + pricing.comboDiscount + pricing.bogoDiscount,
      'couponDiscount': pricing.couponDiscount,
      'deliveryCharge': pricing.deliveryFee,
      'grandTotal': pricing.totalAmount,
    });
  }

  String _buildDeliverySnapshot(CartPricingResult pricing) {
    return jsonEncode({
      'deliveryCharge': pricing.deliveryFee,
      'originalDeliveryFee': pricing.originalDeliveryFee,
      'deliveryDiscountAmount':
          pricing.originalDeliveryFee - pricing.deliveryFee,
      'freeDeliveryApplied': pricing.freeDeliveryApplied,
      if (pricing.freeDeliveryApplied && pricing.deliveryPricing != null)
        'freeDeliveryReason': pricing.deliveryPricing!.appliedRuleName,
    });
  }

  Future<double> getOrderFinalAmount(
    Session session,
    String orderNumber,
  ) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) {
      throw Exception('Order not found: $orderNumber');
    }
    return row.finalAmount;
  }

  Future<double> getOrderActualPaymentAmount(
    Session session,
    String orderNumber,
  ) async {
    final row = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (row == null) {
      throw Exception('Order not found: $orderNumber');
    }
    return row.actualPaymentAmount > 0 ? row.actualPaymentAmount : row.finalAmount;
  }

  /// Find an active pending order for this user.
  /// Returns the order if:
  ///   paymentStatus == 'pending'
  ///   AND orderStatus NOT IN terminal/finished states.
  /// Otherwise returns null.
  Future<CustomerOrderRow?> findActivePendingOrder(
    Session session,
    String userReference,
  ) async {
    final appUser = await _resolveOrCreateUser(
      session,
      userReference: userReference,
      createIfMissing: false,
    );
    if (appUser == null || appUser.id == null) return null;

    return CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(appUser.id!) &
          t.paymentStatus.equals('pending') &
          t.orderStatus.notEquals('confirmed') &
          t.orderStatus.notEquals('cancelled') &
          t.orderStatus.notEquals('cancelled_by_user') &
          t.orderStatus.notEquals('payment_expired') &
          t.orderStatus.notEquals('delivered') &
          t.orderStatus.notEquals('refunded'),
    );
  }

  /// Cancel a pending order with FOR UPDATE row lock.
  /// Race-safe: acquires lock then re-verifies paymentStatus is still 'pending'.
  /// Returns false if the order is already paid / already cancelled.
  Future<bool> cancelPendingOrder(
    Session session,
    String orderNumber,
    String userReference, {
    String reason = 'Cancelled by user during checkout',
  }) async {
    final appUser = await _resolveOrCreateUser(
      session,
      userReference: userReference,
      createIfMissing: false,
    );
    if (appUser == null || appUser.id == null) return false;

    try {
      return await session.db.transaction<bool>((transaction) async {
        // Acquire FOR UPDATE lock on the order row
        final orderRow = await CustomerOrderRow.db.findFirstRow(
          session,
          where: (t) => t.orderNumber.equals(orderNumber),
          transaction: transaction,
          lockMode: LockMode.forUpdate,
        );

        if (orderRow == null) return false;

        // Verify the order belongs to this user
        if (orderRow.userId != appUser.id!) return false;

        // Re-check status after acquiring lock
        if (orderRow.paymentStatus == 'paid') return false;
        if (orderRow.orderStatus == 'cancelled' ||
            orderRow.orderStatus == 'cancelled_by_user' ||
            orderRow.orderStatus == 'payment_expired') {
          return false;
        }

        final now = DateTime.now().toUtc();

        await CustomerOrderRow.db.updateRow(
          session,
          orderRow.copyWith(
            orderStatus: 'cancelled_by_user',
            paymentStatus: 'cancelled',
            linkStatus: 'DISABLED',
            cancelledAt: now,
            cancellationReason: reason,
            updatedAt: now,
          ),
          transaction: transaction,
        );

        // Also cancel the payment transaction
        final paymentRow = await PaymentTransactionRow.db.findFirstRow(
          session,
          where: (t) => t.orderId.equals(orderRow.id!),
          transaction: transaction,
        );
        if (paymentRow != null) {
          await PaymentTransactionRow.db.updateRow(
            session,
            paymentRow.copyWith(
              paymentStatus: 'cancelled',
              gatewayStatus: 'cancelled',
              updatedAt: now,
            ),
            transaction: transaction,
          );
        }

        // Disable any active payment link
        await PostgresPaymentLinkService().disablePaymentLink(
          session,
          orderRow.orderNumber,
          transaction: transaction,
        );

        return true;
      });
    } catch (e) {
      session.log(
        'cancelPendingOrder failed for $orderNumber: $e',
        level: LogLevel.error,
      );
      return false;
    }
  }

  Future<void> _deductStockInternal(
    Session session,
    UuidValue orderId, {
    Transaction? transaction,
  }) async {
    try {
      final orderItems = await OrderItemRow.db.find(
        session,
        where: (t) => t.orderId.equals(orderId),
        transaction: transaction,
      );

      const unitConversions = <String, double>{
        'gm': 1.0,
        'kg': 1000.0,
        'litre': 1000.0,
        'ml': 1.0,
        'pc': 1.0,
        'pack': 1.0,
      };

      for (final item in orderItems.where(
        (i) => i.rewardSource == 'SHOP_MORE_GET_MORE',
      )) {
        final rp = await ProductRow.db.findById(
          session,
          item.productId,
          transaction: transaction,
        );
        if (rp != null && rp.stock != null && rp.stock! < (item.quantity ?? 1)) {
          session.log(
            'SMGM reward stock insufficient at COD confirmation: '
            'product="${rp.name}" stock=${rp.stock} '
            'required=${item.quantity} orderId=$orderId '
            'rewardOfferId=${item.rewardOfferId}',
            level: LogLevel.error,
          );
        }
      }

      for (final item in orderItems) {
        final product = await ProductRow.db.findById(
          session,
          item.productId,
          transaction: transaction,
        );
        if (product == null || product.stock == null) continue;

        double deduction = 0;
        if (item.productVariantId != null) {
          final variant = await ProductVariantRow.db.findById(
            session,
            item.productVariantId!,
            transaction: transaction,
          );
          if (variant != null) {
            final vUnit = variant.quantityUnit.toLowerCase();
            final pUnit = (product.stockUnit ?? product.baseUnit ?? 'unit')
                .toLowerCase();
            final inGrams =
                variant.quantityValue * (unitConversions[vUnit] ?? 1.0);
            final inBase = inGrams / (unitConversions[pUnit] ?? 1.0);
            deduction = inBase * item.quantity;
          } else {
            deduction = item.quantity.toDouble();
          }
        } else {
          deduction = item.quantity.toDouble();
        }

        final newStock = product.stock! - deduction;
        await ProductRow.db.updateRow(
          session,
          product.copyWith(
            stock: newStock,
            status: newStock <= 0 ? 'inactive' : product.status,
            updatedAt: DateTime.now().toUtc(),
          ),
          transaction: transaction,
        );
      }
    } catch (e) {
      session.log(
        'Stock deduction for COD order failed: $e',
        level: LogLevel.error,
      );
    }
  }

  // --- COD Abuse Prevention helpers ---

  Future<void> _incrementCodPlacedCounter(
    Session session,
    UuidValue userId,
    Transaction transaction,
  ) async {
    final user = await AppUserRow.db.findById(
      session,
      userId,
      transaction: transaction,
      lockMode: LockMode.forUpdate,
    );
    if (user == null) return;
    await AppUserRow.db.updateRow(
      session,
      user.copyWith(
        codOrdersPlaced: (user.codOrdersPlaced ?? 0) + 1,
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
  }

  Future<void> _incrementCodDeliveredCounter(
    Session session,
    CustomerOrderRow order,
  ) async {
    if (order.paymentMode != 'cod') return;
    final user = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.id.equals(order.userId),
    );
    if (user == null) return;
    await AppUserRow.db.updateRow(
      session,
      user.copyWith(
        codOrdersDelivered: (user.codOrdersDelivered ?? 0) + 1,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<void> _autoUnblockCodIfEligible(
    Session session,
    CustomerOrderRow order,
  ) async {
    if (order.paymentMode == 'cod') return;
    if (order.paymentStatus != 'paid') return;
    final user = await AppUserRow.db.findFirstRow(
      session,
      where: (t) => t.id.equals(order.userId),
    );
    if (user == null || user.isCodBlocked != true) return;
    await AppUserRow.db.updateRow(
      session,
      user.copyWith(
        isCodBlocked: false,
        codBlockedReason: null,
        codBlockedAt: null,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    session.log(
      'Auto-unblocked COD for user ${order.userId} after successful '
      '${order.paymentMode} order ${order.orderNumber}',
      level: LogLevel.info,
    );
  }

  Future<void> _incrementCodRejectedCounter(
    Session session,
    UuidValue userId,
    Transaction transaction,
  ) async {
    final user = await AppUserRow.db.findById(
      session,
      userId,
      transaction: transaction,
      lockMode: LockMode.forUpdate,
    );
    if (user == null) return;
    await AppUserRow.db.updateRow(
      session,
      user.copyWith(
        codOrdersRejected: (user.codOrdersRejected ?? 0) + 1,
        updatedAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
  }

  Future<bool> _checkAutoBlockCod(
    Session session,
    UuidValue userId,
    Transaction transaction,
  ) async {
    final settings = await CodSettingsRow.db.findFirstRow(session);
    if (settings == null || !settings.enableAutoBlocking) return false;
    final user = await AppUserRow.db.findById(
      session,
      userId,
      transaction: transaction,
      lockMode: LockMode.forUpdate,
    );
    if (user == null) return false;
    final limit = settings.maximumAllowedCodFailures;
    final rejected = user.codOrdersRejected ?? 0;
    if (rejected >= limit) {
      await AppUserRow.db.updateRow(
        session,
        user.copyWith(
          isCodBlocked: true,
          codBlockedReason: 'REPEATED_DELIVERY_REFUSAL',
          codBlockedAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
      return true;
    }
    return false;
  }

  /// Records a COD delivery failure for an out_for_delivery COD order.
  /// Cancels the order, inserts a CodFailureRecord, increments user rejection
  /// counter, and auto-blocks the user if threshold exceeded.
  Future<Map<String, dynamic>> markCodDeliveryFailed(
    Session session,
    String orderNumber, {
    required String reason,
    String? failureNote,
    String? recordedBy,
    String? adminName,
  }) async {
    final order = await CustomerOrderRow.db.findFirstRow(
      session,
      where: (t) => t.orderNumber.equals(orderNumber),
    );
    if (order == null) {
      throw ArgumentError('Order not found: $orderNumber');
    }
    if (order.codFailureReason != null) {
      throw StateError('COD failure already recorded for this order.');
    }
    if (order.orderStatus != 'out_for_delivery') {
      throw StateError(
        'Order status must be "out_for_delivery" to record COD failure. '
        'Current status: ${order.orderStatus}',
      );
    }
    if (order.paymentMode != 'cod') {
      throw StateError('Cannot record COD failure for non-COD order.');
    }

    final now = DateTime.now().toUtc();
    await session.db.transaction((transaction) async {
      // Update order status
      await CustomerOrderRow.db.updateRow(
        session,
        order.copyWith(
          orderStatus: 'cancelled',
          cancelledAt: now,
          cancellationReason: 'COD_DELIVERY_FAILURE: $reason',
          codFailureReason: reason,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      // Insert failure record
      await CodFailureRecord.db.insertRow(
        session,
        CodFailureRecord(
          orderId: order.id!,
          userId: order.userId,
          reason: reason,
          failureNote: failureNote,
          recordedBy: recordedBy,
          recordedAt: now,
        ),
        transaction: transaction,
      );

      // Increment rejection counter
      await _incrementCodRejectedCounter(
        session,
        order.userId,
        transaction,
      );

      // Check auto-block threshold
      await _checkAutoBlockCod(session, order.userId, transaction);

      // Restore stock for COD order
      await _restoreStockForCancelledOrder(
        session,
        order.id!,
        transaction: transaction,
      );
      await _decrementCouponForCancelledOrder(
        session,
        order,
        transaction: transaction,
      );
    });

    return {
      'success': true,
      'orderNumber': orderNumber,
      'status': 'cancelled',
      'codFailureReason': reason,
    };
  }

  Future<void> _resolvePendingRedeliveryComplaints(
    Session session,
    CustomerOrderRow deliveredOrder,
  ) async {
    // Find complaints with pendingRedeliveryStatus linked to this order
    // Two cases:
    // 1. retry_delivery: complaint.orderId == deliveredOrder.id
    // 2. replacement: complaint.complaintId delivered order's complaintId

    // Case 1: retry_delivery complaints for this order
    final directComplaints = await ComplaintRow.db.find(
      session,
      where: (t) =>
          t.orderId.equals(deliveredOrder.id!) &
          t.status.equals('Pending Redelivery') &
          t.resolutionType.equals('retry_delivery'),
    );
    for (final complaint in directComplaints) {
      if (complaint.id == null) continue;
      try {
        await ComplaintRow.db.updateById(
          session,
          complaint.id!,
          columnValues: (t) => [
            t.status('Resolved'),
            t.updatedAt(DateTime.now().toUtc()),
          ],
        );
      } catch (_) {}
    }

    // Case 2: replacement complaints (delivered order has complaintId)
    final sourceComplaintIdStr = cleanNullableString(
      deliveredOrder.complaintId,
    );
    if (sourceComplaintIdStr != null &&
        deliveredOrder.orderType == 'replacement') {
      final sourceComplaintUuid = tryParseUuid(sourceComplaintIdStr);
      if (sourceComplaintUuid != null) {
        final replacementComplaint = await ComplaintRow.db.findFirstRow(
          session,
          where: (t) =>
              t.id.equals(sourceComplaintUuid) &
              t.status.equals('Pending Redelivery') &
              t.resolutionType.equals('replacement'),
        );
        if (replacementComplaint?.id != null) {
          try {
            await ComplaintRow.db.updateById(
              session,
              replacementComplaint!.id!,
              columnValues: (t) => [
                t.status('Resolved'),
                t.updatedAt(DateTime.now().toUtc()),
              ],
            );
          } catch (_) {}
        }
      }
    }
  }

  // --- END COD Abuse Prevention helpers ---

  /// Builds a combined WHERE expression for order queries with optional
  /// filters on status, paymentMode, paymentStatus, and paymentCollectionMode.
  /// Returns null if no filters are provided.
  WhereExpressionBuilder<CustomerOrderRowTable>? _buildOrderWhereClause({
    String? status,
    String? paymentMode,
    String? paymentStatus,
    String? paymentCollectionMode,
  }) {
    final hasStatus = status != null && status.trim().isNotEmpty;
    final hasPaymentMode = paymentMode != null && paymentMode.trim().isNotEmpty;
    final hasPaymentStatus =
        paymentStatus != null && paymentStatus.trim().isNotEmpty;
    final hasPaymentCollectionMode =
        paymentCollectionMode != null && paymentCollectionMode.trim().isNotEmpty;

    if (!hasStatus &&
        !hasPaymentMode &&
        !hasPaymentStatus &&
        !hasPaymentCollectionMode) {
      return null;
    }

    return (t) {
      Expression<dynamic>? expr;
      if (hasStatus) {
        expr = t.orderStatus.equals(status.trim());
      }
      if (hasPaymentMode) {
        final modeExpr = t.paymentMode.equals(paymentMode.trim());
        expr = expr == null ? modeExpr : expr & modeExpr;
      }
      if (hasPaymentStatus) {
        final psExpr = t.paymentStatus.equals(paymentStatus.trim());
        expr = expr == null ? psExpr : expr & psExpr;
      }
      if (hasPaymentCollectionMode) {
        final pcmExpr =
            t.paymentCollectionMode.equals(paymentCollectionMode.trim());
        expr = expr == null ? pcmExpr : expr & pcmExpr;
      }
      return expr!;
    };
  }
}

class _OrderCursor {
  _OrderCursor({
    required this.orderId,
    required this.orderedAt,
  });

  final String orderId;
  final DateTime orderedAt;
}
