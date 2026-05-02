CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS idx_product_category_status_created
    ON product ("categoryId", status, "createdAt" DESC, id DESC)
    INCLUDE (name, "primaryImageUrl");

CREATE INDEX IF NOT EXISTS idx_product_status_created
    ON product (status, "createdAt" DESC, id DESC)
    INCLUDE ("categoryId", name, "primaryImageUrl");

CREATE INDEX IF NOT EXISTS idx_product_sub_category_sub_product
    ON product_sub_category ("subCategoryId", "productId");

CREATE INDEX IF NOT EXISTS idx_banner_status_window_priority
    ON banner (status, "startsAt", "endsAt", priority DESC, id DESC);

CREATE INDEX IF NOT EXISTS idx_coupon_status_window_code
    ON coupon (status, "startsAt", "endsAt", code);

CREATE INDEX IF NOT EXISTS idx_category_offer_status_window_priority
    ON category_offer (status, "startsAt", "endsAt", priority DESC, id DESC);

CREATE INDEX IF NOT EXISTS idx_combo_offer_status_window_priority
    ON combo_offer (status, "startsAt", "endsAt", priority DESC, id DESC);

CREATE INDEX IF NOT EXISTS idx_bogo_offer_status_window_trigger
    ON bogo_offer (status, "startsAt", "endsAt", "triggerProductId", id DESC);

CREATE INDEX IF NOT EXISTS idx_delivery_rule_status_window_priority
    ON delivery_rule (status, "startsAt", "endsAt", priority DESC, id DESC);

CREATE INDEX IF NOT EXISTS idx_free_delivery_rule_status_window
    ON free_delivery_rule (status, "startsAt", "endsAt", id DESC);

CREATE INDEX IF NOT EXISTS idx_customer_order_user_ordered_cover
    ON customer_order ("userId", "orderedAt" DESC, id DESC)
    INCLUDE ("orderStatus", "paymentStatus", "finalAmount");

CREATE INDEX IF NOT EXISTS idx_payment_transaction_user_created
    ON payment_transaction ("userId", "createdAt" DESC, id DESC);

CREATE INDEX IF NOT EXISTS idx_product_search_document_trgm
    ON product_search_document
    USING gin ("searchText" gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_product_search_document_source_created
    ON product_search_document ("sourceCreatedAt" DESC, "productId" DESC);

CREATE UNIQUE INDEX IF NOT EXISTS idx_product_search_rebuild_job_active
    ON product_search_rebuild_job ("productId")
    WHERE "jobStatus" IN ('pending', 'running');
