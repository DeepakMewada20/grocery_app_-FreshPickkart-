import 'dart:convert';

import 'package:serverpod/serverpod.dart' as _i1 hide Order;
import 'package:test/test.dart';
import 'package:freshpickkat_server/src/services/orders/snapshot_builder.dart';
import 'package:freshpickkat_server/src/generated/protocol.dart';

void main() {
  group('SnapshotBuilder.buildPricingSnapshot', () {
    test('includes categoryOfferDiscountAmount in offerDiscount sum', () {
      final order = Order(
        orderId: '1',
        userId: 'u1',
        userPhone: '9999999999',
        items: [],
        itemCount: 0,
        totalAmount: 500,
        discountAmount: 50,
        productDiscountAmount: 30,
        comboDiscountAmount: 20,
        bogoDiscountAmount: 10,
        categoryOfferDiscountAmount: 40,
        deliveryFee: 40,
        originalDeliveryFee: 60,
        deliveryDiscountAmount: 20,
        freeDeliveryApplied: false,
        freshPointsUsed: 0,
        freshPointsValue: 0,
        actualPaymentAmount: 440,
        finalAmount: 440,
        status: 'placed',
        paymentStatus: 'pending',
        refundStatus: 'none',
        deliveryAddress: Address(
          street: 'Test St',
          city: 'Delhi',
          state: 'DL',
          zipCode: '110001',
          country: 'India',
        ),
        orderedAt: DateTime.now(),
        orderType: 'regular',
      );

      final jsonStr = SnapshotBuilder.instance.buildPricingSnapshot(order);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(json['subtotal'], equals(500));
      // 30 + 20 + 10 + 40 = 100
      expect(json['offerDiscount'], equals(100));
      expect(json['couponDiscount'], equals(50));
      expect(json['deliveryCharge'], equals(40));
      expect(json['grandTotal'], equals(440));
    });

    test('categoryOfferDiscountAmount defaults to 0 when absent', () {
      final order = Order(
        orderId: '2',
        userId: 'u2',
        userPhone: '9999999998',
        items: [],
        itemCount: 1,
        totalAmount: 200,
        discountAmount: 0,
        productDiscountAmount: 10,
        comboDiscountAmount: 5,
        bogoDiscountAmount: 5,
        deliveryFee: 30,
        originalDeliveryFee: 30,
        deliveryDiscountAmount: 0,
        freeDeliveryApplied: false,
        freshPointsUsed: 0,
        freshPointsValue: 0,
        actualPaymentAmount: 180,
        finalAmount: 180,
        status: 'placed',
        paymentStatus: 'pending',
        refundStatus: 'none',
        deliveryAddress: Address(
          street: 'Test St',
          city: 'Mumbai',
          state: 'MH',
          zipCode: '400001',
          country: 'India',
        ),
        orderedAt: DateTime.now(),
        orderType: 'regular',
      );

      final jsonStr = SnapshotBuilder.instance.buildPricingSnapshot(order);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(json['offerDiscount'], equals(20)); // 10 + 5 + 5 + 0
    });
  });

  group('SnapshotBuilder.buildPaymentSnapshot', () {
    test('includes all required fields', () {
      final jsonStr = SnapshotBuilder.instance.buildPaymentSnapshot(
        gatewayName: 'razorpay',
        gatewayOrderId: 'order_123',
        gatewayPaymentId: 'pay_456',
        paymentStatus: 'captured',
        amount: 500,
        paidAt: DateTime.utc(2026, 6, 29, 10, 30),
      );
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(json['gatewayName'], equals('razorpay'));
      expect(json['gatewayOrderId'], equals('order_123'));
      expect(json['gatewayPaymentId'], equals('pay_456'));
      expect(json['paymentStatus'], equals('captured'));
      expect(json['amount'], equals(500));
      expect(json['paidAt'], equals('2026-06-29T10:30:00.000Z'));
    });

    test('handles null gatewayOrderId and gatewayPaymentId', () {
      final jsonStr = SnapshotBuilder.instance.buildPaymentSnapshot(
        gatewayName: 'cod',
        paymentStatus: 'pending',
        amount: 0,
      );
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(json['gatewayOrderId'], isNull);
      expect(json['gatewayPaymentId'], isNull);
      expect(json['paidAt'], isNull);
    });
  });

  group('SnapshotBuilder.buildAddressSnapshot', () {
    test('includes required and optional fields', () {
      final jsonStr = SnapshotBuilder.instance.buildAddressSnapshot(
        recipientName: 'Rahul',
        phoneNumber: '9999999999',
        streetLine1: '123 Main St',
        streetLine2: 'Apt 4',
        landmark: 'Near Park',
        city: 'Delhi',
        state: 'DL',
        postalCode: '110001',
        country: 'India',
        latitude: 28.61,
        longitude: 77.23,
      );
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(json['recipientName'], equals('Rahul'));
      expect(json['phoneNumber'], equals('9999999999'));
      expect(json['streetLine1'], equals('123 Main St'));
      expect(json['streetLine2'], equals('Apt 4'));
      expect(json['landmark'], equals('Near Park'));
      expect(json['city'], equals('Delhi'));
      expect(json['state'], equals('DL'));
      expect(json['postalCode'], equals('110001'));
      expect(json['country'], equals('India'));
      expect(json['latitude'], equals(28.61));
      expect(json['longitude'], equals(77.23));
    });

    test('handles null optional fields', () {
      final jsonStr = SnapshotBuilder.instance.buildAddressSnapshot(
        streetLine1: '456 Oak Rd',
        city: 'Noida',
        state: 'UP',
        postalCode: '201301',
        country: 'India',
      );
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(json['recipientName'], isNull);
      expect(json['phoneNumber'], isNull);
      expect(json['streetLine2'], isNull);
      expect(json['landmark'], isNull);
      expect(json['latitude'], isNull);
      expect(json['longitude'], isNull);
    });
  });

  group('SnapshotBuilder.buildDeliverySnapshot', () {
    test('includes all fields without freeDeliveryReason', () {
      final order = Order(
        orderId: '1',
        userId: 'u1',
        userPhone: '9999999999',
        items: [],
        itemCount: 0,
        totalAmount: 500,
        discountAmount: 0,
        deliveryFee: 40,
        originalDeliveryFee: 60,
        deliveryDiscountAmount: 20,
        freeDeliveryApplied: true,
        freshPointsUsed: 0,
        freshPointsValue: 0,
        actualPaymentAmount: 440,
        finalAmount: 440,
        status: 'placed',
        paymentStatus: 'pending',
        refundStatus: 'none',
        deliveryAddress: Address(
          street: 'Test St',
          city: 'Delhi',
          state: 'DL',
          zipCode: '110001',
          country: 'India',
        ),
        orderedAt: DateTime.now(),
        orderType: 'regular',
      );

      final jsonStr = SnapshotBuilder.instance.buildDeliverySnapshot(order);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(json['deliveryCharge'], equals(40));
      expect(json['originalDeliveryFee'], equals(60));
      expect(json['deliveryDiscountAmount'], equals(20));
      expect(json['freeDeliveryApplied'], isTrue);
      expect(json.containsKey('freeDeliveryReason'), isFalse);
    });

    test('includes freeDeliveryReason when present', () {
      final order = Order(
        orderId: '2',
        userId: 'u2',
        userPhone: '9999999998',
        items: [],
        itemCount: 0,
        totalAmount: 500,
        discountAmount: 0,
        deliveryFee: 0,
        originalDeliveryFee: 40,
        deliveryDiscountAmount: 40,
        freeDeliveryApplied: true,
        freeDeliveryReason: 'Free Delivery on orders above ₹500',
        freshPointsUsed: 0,
        freshPointsValue: 0,
        actualPaymentAmount: 460,
        finalAmount: 460,
        status: 'placed',
        paymentStatus: 'pending',
        refundStatus: 'none',
        deliveryAddress: Address(
          street: 'Test St',
          city: 'Delhi',
          state: 'DL',
          zipCode: '110001',
          country: 'India',
        ),
        orderedAt: DateTime.now(),
        orderType: 'regular',
      );

      final jsonStr = SnapshotBuilder.instance.buildDeliverySnapshot(order);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(json['freeDeliveryReason'],
          equals('Free Delivery on orders above ₹500'));
    });
  });

  group('SnapshotBuilder.buildCouponSnapshot', () {
    test('returns null when coupon is null', () {
      final result = SnapshotBuilder.instance.buildCouponSnapshot(null, 0);
      expect(result, isNull);
    });

    test('serializes coupon fields correctly', () {
      final now = DateTime.now();
      final coupon = CouponRow(
        id: _i1.UuidValue('550e8400-e29b-41d4-a716-446655440000'),
        code: 'SAVE50',
        couponType: 'flat',
        discountValue: 50,
        minOrderAmount: 200,
        maxDiscountAmount: 50,
        maxUsageTotal: 100,
        usedCount: 0,
        startsAt: now,
        endsAt: now.add(const Duration(days: 30)),
        status: 'active',
        createdAt: now,
        updatedAt: now,
      );

      final jsonStr =
          SnapshotBuilder.instance.buildCouponSnapshot(coupon, 50);
      final json = jsonDecode(jsonStr!) as Map<String, dynamic>;

      expect(json['couponId'], equals('550e8400-e29b-41d4-a716-446655440000'));
      expect(json['couponCode'], equals('SAVE50'));
      expect(json['discountType'], equals('flat'));
      expect(json['discountValue'], equals(50));
      expect(json['appliedDiscount'], equals(50));
    });
  });

  group('OrderItemSnapshot', () {
    test('stores appliedOfferJson when provided', () {
      const offerJson = '{"offerType":"FREE_DELIVERY"}';
      final snapshot = const OrderItemSnapshot(
        mrp: 100.0,
        sku: 'SKU001',
        slug: 'test-product',
        categoryName: 'Groceries',
        productStatus: 'active',
        appliedOfferJson: offerJson,
      );

      expect(snapshot.mrp, equals(100.0));
      expect(snapshot.sku, equals('SKU001'));
      expect(snapshot.slug, equals('test-product'));
      expect(snapshot.categoryName, equals('Groceries'));
      expect(snapshot.productStatus, equals('active'));

      final decoded = jsonDecode(snapshot.appliedOfferJson!);
      expect(decoded['offerType'], equals('FREE_DELIVERY'));
    });

    test('appliedOfferJson is null when no offer', () {
      const snapshot = OrderItemSnapshot();
      expect(snapshot.appliedOfferJson, isNull);
    });
  });
}
