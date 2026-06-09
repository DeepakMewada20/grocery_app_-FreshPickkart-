import 'package:serverpod/serverpod.dart';

/// One-time backfill for old orders without snapshots.
/// Run once at server startup — remove after all old orders are migrated.
///
/// TODO(snapshot-backfill): Remove this entire file after production deployment
/// confirms all old orders have snapshots.
class BackfillService {
  static Future<void> backfillOrderSnapshots(Session session) async {
    // 1. OrderItemRow — product/variant snapshot columns
    // Uses correlated subqueries (not FROM/JOIN) to avoid PostgreSQL
    // "cannot reference target table in FROM clause" error.
    await session.db.unsafeQuery('''
      UPDATE order_item oi
      SET
        "productNameSnapshot" = COALESCE(
          NULLIF(oi."productNameSnapshot", ''),
          (SELECT p.name FROM product p WHERE p.id = oi."productId")
        ),
        "productImageUrlSnapshot" = COALESCE(
          oi."productImageUrlSnapshot",
          (SELECT p."primaryImageUrl" FROM product p WHERE p.id = oi."productId")
        ),
        "variantLabelSnapshot" = COALESCE(
          oi."variantLabelSnapshot",
          (SELECT pv.label FROM product_variant pv WHERE pv.id = oi."productVariantId")
        ),
        "mrpSnapshot" = COALESCE(
          oi."mrpSnapshot",
          (SELECT pv."listPrice" FROM product_variant pv WHERE pv.id = oi."productVariantId")
        ),
        "skuSnapshot" = COALESCE(
          oi."skuSnapshot",
          (SELECT pv.sku FROM product_variant pv WHERE pv.id = oi."productVariantId")
        ),
        "productSlugSnapshot" = COALESCE(
          oi."productSlugSnapshot",
          (SELECT p.slug FROM product p WHERE p.id = oi."productId")
        ),
        "categoryNameSnapshot" = COALESCE(
          oi."categoryNameSnapshot",
          (SELECT c.name FROM product p
           LEFT JOIN category c ON c.id = p."categoryId"
           WHERE p.id = oi."productId")
        ),
        "productStatusSnapshot" = COALESCE(
          oi."productStatusSnapshot",
          (SELECT p.status FROM product p WHERE p.id = oi."productId")
        )
      WHERE oi."productNameSnapshot" IS NULL OR oi."productNameSnapshot" = ''
    ''');

    // 2. CustomerOrderRow — pricingSnapshot from existing numeric columns
    await session.db.unsafeQuery('''
      UPDATE customer_order
      SET "pricingSnapshot" = jsonb_build_object(
        'subtotal', "totalAmount",
        'offerDiscount', "productDiscountAmount" + "comboDiscountAmount" + "bogoDiscountAmount",
        'couponDiscount', "discountAmount",
        'deliveryCharge', "deliveryFee",
        'grandTotal', "finalAmount"
      )::text
      WHERE "pricingSnapshot" IS NULL OR "pricingSnapshot" = ''
    ''');

    // 3. CustomerOrderRow — deliverySnapshot
    await session.db.unsafeQuery('''
      UPDATE customer_order
      SET "deliverySnapshot" = jsonb_build_object(
        'deliveryCharge', "deliveryFee",
        'originalDeliveryFee', "originalDeliveryFee",
        'deliveryDiscountAmount', "deliveryDiscountAmount",
        'freeDeliveryApplied', "freeDeliveryApplied",
        'freeDeliveryReason', "freeDeliveryReason"
      )::text
      WHERE "deliverySnapshot" IS NULL OR "deliverySnapshot" = ''
    ''');

    // 4. CustomerOrderRow — couponSnapshot from coupon table
    await session.db.unsafeQuery('''
      UPDATE customer_order co
      SET "couponSnapshot" = (
        SELECT jsonb_build_object(
          'couponId', c.id::text,
          'couponCode', c.code,
          'discountType', c."couponType",
          'discountValue', c."discountValue",
          'appliedDiscount', co."discountAmount"
        )::text
        FROM coupon c
        WHERE c.id = co."couponId"
      )
      WHERE co."couponId" IS NOT NULL
        AND (co."couponSnapshot" IS NULL OR co."couponSnapshot" = '')
    ''');

    // 5. CustomerOrderRow — addressSnapshot from order_address table
    await session.db.unsafeQuery('''
      UPDATE customer_order co
      SET "addressSnapshot" = (
        SELECT jsonb_build_object(
          'recipientName', oa."recipientName",
          'phoneNumber', oa."phoneNumber",
          'streetLine1', oa."streetLine1",
          'streetLine2', oa."streetLine2",
          'landmark', oa."landmark",
          'city', oa."city",
          'state', oa."state",
          'postalCode', oa."postalCode",
          'country', oa."country",
          'latitude', oa."latitude",
          'longitude', oa."longitude"
        )::text
        FROM order_address oa
        WHERE oa."orderId" = co.id
        LIMIT 1
      )
      WHERE (co."addressSnapshot" IS NULL OR co."addressSnapshot" = '')
    ''');

    // 6. CustomerOrderRow — paymentSnapshot from payment_transaction table
    await session.db.unsafeQuery('''
      UPDATE customer_order co
      SET "paymentSnapshot" = (
        SELECT jsonb_build_object(
          'gatewayName', COALESCE(pt."gatewayName", 'Razorpay'),
          'gatewayOrderId', pt."gatewayOrderId",
          'gatewayPaymentId', pt."gatewayPaymentId",
          'paymentStatus', pt."paymentStatus",
          'amount', pt."amount",
          'paidAt', pt."paidAt"::text
        )::text
        FROM payment_transaction pt
        WHERE pt."orderId" = co.id
        ORDER BY pt."createdAt" DESC
        LIMIT 1
      )
      WHERE (co."paymentSnapshot" IS NULL OR co."paymentSnapshot" = '')
    ''');
  }
}
