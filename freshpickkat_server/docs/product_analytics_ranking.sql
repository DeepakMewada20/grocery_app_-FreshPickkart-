-- Product analytics and ranking SQL reference.
-- The generated migration creates equivalent columns and indexes.

-- Ranking indexes.
CREATE INDEX IF NOT EXISTS product_trending_score_idx
    ON product ("trendingScore", id);

CREATE INDEX IF NOT EXISTS product_most_purchase_count_idx
    ON product ("mostPurchaseCount", id);

CREATE INDEX IF NOT EXISTS product_most_search_count_idx
    ON product ("mostSearchCount", id);

CREATE INDEX IF NOT EXISTS product_reorder_count_idx
    ON product ("reorderCount", id);

-- Paid order analytics indexes.
CREATE INDEX IF NOT EXISTS customer_order_payment_ordered_idx
    ON customer_order ("paymentStatus", "orderedAt", id);

CREATE INDEX IF NOT EXISTS customer_order_user_payment_ordered_idx
    ON customer_order ("userId", "paymentStatus", "orderedAt", id);

CREATE INDEX IF NOT EXISTS order_item_product_idx
    ON order_item ("productId");

CREATE INDEX IF NOT EXISTS order_item_product_order_idx
    ON order_item ("productId", "orderId");

-- Top 10 trending products.
SELECT p.*
FROM product p
WHERE p.status = 'active'
ORDER BY p."trendingScore" DESC, p.id DESC
LIMIT 10;

-- Top 10 most selling products.
SELECT p.*
FROM product p
WHERE p.status = 'active'
ORDER BY p."mostPurchaseCount" DESC, p.id DESC
LIMIT 10;

-- Top 10 most viewed products.
SELECT p.*
FROM product p
WHERE p.status = 'active'
ORDER BY p."mostSearchCount" DESC, p.id DESC
LIMIT 10;

-- Top 10 frequently reordered products.
SELECT p.*
FROM product p
WHERE p.status = 'active'
ORDER BY p."reorderCount" DESC, p.id DESC
LIMIT 10;
