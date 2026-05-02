-- 1. Product browse by category with stable keyset pagination.
SELECT
    p.id,
    p.name,
    p.primary_image_url,
    p.created_at
FROM product p
JOIN category c ON c.id = p.category_id
WHERE p.category_id = :category_id
  AND p.status = 'active'
  AND c.status = 'active'
  AND (
        :cursor_created_at IS NULL
        OR (p.created_at, p.id) < (:cursor_created_at, :cursor_id)
      )
ORDER BY p.created_at DESC, p.id DESC
LIMIT :limit;

-- 2. Product browse by subcategory through the join table.
SELECT
    p.id,
    p.name,
    p.primary_image_url,
    p.created_at
FROM product_sub_category psc
JOIN product p ON p.id = psc.product_id
JOIN sub_category sc ON sc.id = psc.sub_category_id
JOIN category c ON c.id = p.category_id
WHERE psc.sub_category_id = :sub_category_id
  AND p.status = 'active'
  AND sc.status = 'active'
  AND c.status = 'active'
  AND (
        :cursor_created_at IS NULL
        OR (p.created_at, p.id) < (:cursor_created_at, :cursor_id)
      )
ORDER BY p.created_at DESC, p.id DESC
LIMIT :limit;

-- 3. User order history.
SELECT
    o.id,
    o.order_number,
    o.order_status,
    o.payment_status,
    o.final_amount,
    o.ordered_at
FROM customer_order o
WHERE o.user_id = :user_id
  AND (
        :cursor_ordered_at IS NULL
        OR (o.ordered_at, o.id) < (:cursor_ordered_at, :cursor_id)
      )
ORDER BY o.ordered_at DESC, o.id DESC
LIMIT :limit;

-- 4. Trigram search guardrail.
-- Application must short-circuit when char_length(trim(:query)) < 2.

-- 5. Ranked product search with threshold and stable pagination.
WITH ranked_products AS (
    SELECT
        psd.product_id,
        p.name,
        p.primary_image_url,
        p.created_at,
        similarity(psd.search_text, :query) AS search_rank
    FROM product_search_document psd
    JOIN product p ON p.id = psd.product_id
    JOIN category c ON c.id = p.category_id
    WHERE p.status = 'active'
      AND c.status = 'active'
      AND psd.search_text ILIKE '%' || :query || '%'
      AND similarity(psd.search_text, :query) > :similarity_threshold
)
SELECT
    product_id,
    name,
    primary_image_url,
    created_at,
    search_rank
FROM ranked_products
WHERE (
        :cursor_rank IS NULL
        OR search_rank < :cursor_rank
        OR (search_rank = :cursor_rank AND created_at < :cursor_created_at)
        OR (search_rank = :cursor_rank AND created_at = :cursor_created_at AND product_id < :cursor_product_id)
      )
ORDER BY search_rank DESC, created_at DESC, product_id DESC
LIMIT :limit;

-- 6. Product create: search document may be created synchronously.
BEGIN;

INSERT INTO product (
    id,
    category_id,
    name,
    slug,
    short_description,
    description,
    primary_image_url,
    status
) VALUES (
    gen_random_uuid(),
    :category_id,
    :name,
    :slug,
    :short_description,
    :description,
    :primary_image_url,
    'active'
)
RETURNING id, created_at, updated_at;

-- Build search_text from product + category + mapped subcategories in application code.
INSERT INTO product_search_document (
    id,
    product_id,
    search_text,
    source_created_at,
    source_updated_at
) VALUES (
    gen_random_uuid(),
    :product_id,
    :search_text,
    :created_at,
    :updated_at
);

COMMIT;

-- 7. Product update / category update / subcategory remap:
-- do not rebuild search document in the main write transaction.
BEGIN;

UPDATE product
SET
    name = :name,
    description = :description,
    updated_at = now()
WHERE id = :product_id;

INSERT INTO product_search_rebuild_job (
    id,
    product_id,
    reason,
    job_status,
    scheduled_at
) VALUES (
    gen_random_uuid(),
    :product_id,
    :reason,
    'pending',
    now()
)
ON CONFLICT DO NOTHING;

COMMIT;

-- 8. Atomic order + payment + idempotency transaction.
BEGIN;

INSERT INTO customer_order (
    id,
    user_id,
    order_number,
    order_status,
    payment_status,
    refund_status,
    item_count,
    total_amount,
    discount_amount,
    delivery_fee,
    final_amount,
    ordered_at
) VALUES (
    gen_random_uuid(),
    :user_id,
    :order_number,
    'placed',
    'pending',
    'none',
    :item_count,
    :total_amount,
    :discount_amount,
    :delivery_fee,
    :final_amount,
    now()
)
RETURNING id;

INSERT INTO order_address (
    id,
    order_id,
    recipient_name,
    phone_number,
    street_line_1,
    city,
    state,
    postal_code,
    country
) VALUES (
    gen_random_uuid(),
    :order_id,
    :recipient_name,
    :phone_number,
    :street_line_1,
    :city,
    :state,
    :postal_code,
    :country
);

-- Repeat for each order item.
INSERT INTO order_item (
    id,
    order_id,
    product_id,
    product_variant_id,
    product_name_snapshot,
    product_image_url_snapshot,
    variant_label_snapshot,
    quantity,
    unit_price,
    total_price,
    is_free_item
) VALUES (
    gen_random_uuid(),
    :order_id,
    :product_id,
    :product_variant_id,
    :product_name_snapshot,
    :product_image_url_snapshot,
    :variant_label_snapshot,
    :quantity,
    :unit_price,
    :total_price,
    :is_free_item
);

INSERT INTO payment_transaction (
    id,
    order_id,
    user_id,
    idempotency_key,
    gateway_name,
    gateway_order_id,
    amount,
    payment_status
) VALUES (
    gen_random_uuid(),
    :order_id,
    :user_id,
    :idempotency_key,
    :gateway_name,
    :gateway_order_id,
    :amount,
    'pending'
);

INSERT INTO idempotency_record (
    id,
    scope,
    idempotency_key,
    user_id,
    order_id,
    payment_transaction_id,
    request_hash
) VALUES (
    gen_random_uuid(),
    'order_create',
    :idempotency_key,
    :user_id,
    :order_id,
    :payment_transaction_id,
    :request_hash
);

-- Future-ready inventory writes belong in this same transaction boundary.

COMMIT;
