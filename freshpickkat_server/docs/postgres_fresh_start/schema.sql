CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE app_user (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    firebase_uid text UNIQUE,
    phone_number text NOT NULL,
    name text,
    email text,
    role text NOT NULL DEFAULT 'customer',
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE user_address (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    label text,
    recipient_name text,
    phone_number text,
    street_line_1 text NOT NULL,
    street_line_2 text,
    landmark text,
    city text NOT NULL,
    state text NOT NULL,
    postal_code text NOT NULL,
    country text NOT NULL,
    latitude double precision,
    longitude double precision,
    is_default boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE category (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    slug text NOT NULL UNIQUE,
    image_url text,
    display_order integer NOT NULL DEFAULT 0,
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE sub_category (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id uuid NOT NULL REFERENCES category(id) ON DELETE RESTRICT,
    name text NOT NULL,
    slug text NOT NULL,
    image_url text,
    display_order integer NOT NULL DEFAULT 0,
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT sub_category_category_slug_unique UNIQUE (category_id, slug)
);

CREATE TABLE product (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id uuid NOT NULL REFERENCES category(id) ON DELETE RESTRICT,
    name text NOT NULL,
    slug text NOT NULL UNIQUE,
    short_description text,
    description text,
    primary_image_url text,
    country_of_origin text,
    base_unit text,
    base_quantity numeric(12,3),
    quantity_description text,
    most_search_count integer NOT NULL DEFAULT 0,
    most_purchase_count integer NOT NULL DEFAULT 0,
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE product_variant (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id uuid NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    label text NOT NULL,
    sku text UNIQUE,
    quantity_value numeric(12,3) NOT NULL,
    quantity_unit text NOT NULL,
    quantity_description text,
    sale_price numeric(12,2) NOT NULL,
    list_price numeric(12,2) NOT NULL,
    is_available boolean NOT NULL DEFAULT true,
    is_default boolean NOT NULL DEFAULT false,
    sort_order integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE product_sub_category (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id uuid NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    sub_category_id uuid NOT NULL REFERENCES sub_category(id) ON DELETE RESTRICT,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT product_sub_category_unique UNIQUE (product_id, sub_category_id)
);

CREATE TABLE banner (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title text NOT NULL,
    image_url text NOT NULL,
    action_type text NOT NULL,
    external_url text,
    linked_product_id uuid REFERENCES product(id) ON DELETE RESTRICT,
    linked_category_id uuid REFERENCES category(id) ON DELETE RESTRICT,
    linked_sub_category_id uuid REFERENCES sub_category(id) ON DELETE RESTRICT,
    priority integer NOT NULL DEFAULT 0,
    starts_at timestamptz NOT NULL,
    ends_at timestamptz NOT NULL,
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (ends_at > starts_at)
);

CREATE TABLE banner_placement (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    banner_id uuid NOT NULL REFERENCES banner(id) ON DELETE CASCADE,
    placement_key text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT banner_placement_unique UNIQUE (banner_id, placement_key)
);

CREATE TABLE coupon (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    code text NOT NULL UNIQUE,
    description text,
    coupon_type text NOT NULL,
    discount_value numeric(12,2),
    min_order_amount numeric(12,2) NOT NULL DEFAULT 0,
    max_discount_amount numeric(12,2),
    max_usage_total integer,
    max_usage_per_user integer,
    used_count integer NOT NULL DEFAULT 0,
    starts_at timestamptz NOT NULL,
    ends_at timestamptz NOT NULL,
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (ends_at > starts_at)
);

CREATE TABLE coupon_product_scope (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    coupon_id uuid NOT NULL REFERENCES coupon(id) ON DELETE CASCADE,
    product_id uuid NOT NULL REFERENCES product(id) ON DELETE RESTRICT,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT coupon_product_scope_unique UNIQUE (coupon_id, product_id)
);

CREATE TABLE category_offer (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id uuid NOT NULL REFERENCES category(id) ON DELETE RESTRICT,
    name text NOT NULL,
    description text,
    discount_type text NOT NULL,
    discount_value numeric(12,2) NOT NULL,
    max_discount_amount numeric(12,2),
    min_order_amount numeric(12,2),
    priority integer NOT NULL DEFAULT 0,
    starts_at timestamptz NOT NULL,
    ends_at timestamptz NOT NULL,
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (ends_at > starts_at)
);

CREATE TABLE category_offer_product_scope (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    category_offer_id uuid NOT NULL REFERENCES category_offer(id) ON DELETE CASCADE,
    product_id uuid NOT NULL REFERENCES product(id) ON DELETE RESTRICT,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT category_offer_scope_unique UNIQUE (category_offer_id, product_id)
);

CREATE TABLE category_offer_product_exclusion (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    category_offer_id uuid NOT NULL REFERENCES category_offer(id) ON DELETE CASCADE,
    product_id uuid NOT NULL REFERENCES product(id) ON DELETE RESTRICT,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT category_offer_exclusion_unique UNIQUE (category_offer_id, product_id)
);

CREATE TABLE combo_offer (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    description text,
    discount_type text NOT NULL,
    discount_value numeric(12,2) NOT NULL,
    min_quantity_per_product integer NOT NULL DEFAULT 1,
    max_usage_per_user integer,
    max_usage_total integer,
    used_count integer NOT NULL DEFAULT 0,
    priority integer NOT NULL DEFAULT 0,
    starts_at timestamptz NOT NULL,
    ends_at timestamptz NOT NULL,
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (ends_at > starts_at)
);

CREATE TABLE combo_offer_item (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    combo_offer_id uuid NOT NULL REFERENCES combo_offer(id) ON DELETE CASCADE,
    product_id uuid NOT NULL REFERENCES product(id) ON DELETE RESTRICT,
    product_variant_id uuid REFERENCES product_variant(id) ON DELETE RESTRICT,
    quantity integer NOT NULL,
    sort_order integer NOT NULL DEFAULT 0,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT combo_offer_item_unique UNIQUE (combo_offer_id, product_id, product_variant_id)
);

CREATE TABLE bogo_offer (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    trigger_product_id uuid NOT NULL REFERENCES product(id) ON DELETE RESTRICT,
    trigger_variant_id uuid REFERENCES product_variant(id) ON DELETE RESTRICT,
    min_trigger_quantity integer NOT NULL DEFAULT 1,
    trigger_base_quantity numeric(12,3),
    trigger_base_unit text,
    title text NOT NULL,
    starts_at timestamptz NOT NULL,
    ends_at timestamptz NOT NULL,
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (ends_at > starts_at)
);

CREATE TABLE bogo_offer_reward (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    bogo_offer_id uuid NOT NULL REFERENCES bogo_offer(id) ON DELETE CASCADE,
    reward_product_id uuid NOT NULL REFERENCES product(id) ON DELETE RESTRICT,
    reward_variant_id uuid REFERENCES product_variant(id) ON DELETE RESTRICT,
    quantity integer NOT NULL DEFAULT 1,
    created_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT bogo_offer_reward_unique UNIQUE (bogo_offer_id, reward_product_id, reward_variant_id)
);

CREATE TABLE delivery_rule (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    description text,
    rule_type text NOT NULL,
    delivery_fee numeric(12,2) NOT NULL,
    priority integer NOT NULL DEFAULT 0,
    target_user_type text,
    target_order_count integer,
    starts_at timestamptz NOT NULL,
    ends_at timestamptz NOT NULL,
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (ends_at > starts_at)
);

CREATE TABLE free_delivery_rule (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    description text,
    rule_type text NOT NULL,
    min_order_amount numeric(12,2),
    min_items_count integer,
    coupon_id uuid REFERENCES coupon(id) ON DELETE RESTRICT,
    user_id uuid REFERENCES app_user(id) ON DELETE RESTRICT,
    waived_amount numeric(12,2) NOT NULL DEFAULT 0,
    starts_at timestamptz NOT NULL,
    ends_at timestamptz NOT NULL,
    status text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    deactivated_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CHECK (ends_at > starts_at)
);

CREATE TABLE customer_order (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    order_number text NOT NULL UNIQUE,
    order_status text NOT NULL CHECK (order_status IN ('placed', 'confirmed', 'packed', 'out_for_delivery', 'delivered', 'cancelled')),
    payment_status text NOT NULL CHECK (payment_status IN ('pending', 'success', 'failed', 'refunded')),
    refund_status text NOT NULL CHECK (refund_status IN ('none', 'partial', 'refunded')),
    coupon_id uuid REFERENCES coupon(id) ON DELETE RESTRICT,
    item_count integer NOT NULL,
    total_amount numeric(12,2) NOT NULL,
    discount_amount numeric(12,2) NOT NULL DEFAULT 0,
    delivery_fee numeric(12,2) NOT NULL DEFAULT 0,
    final_amount numeric(12,2) NOT NULL,
    placed_at timestamptz,
    confirmed_at timestamptz,
    packed_at timestamptz,
    out_for_delivery_at timestamptz,
    delivered_at timestamptz,
    cancelled_at timestamptz,
    cancellation_reason text,
    delivery_otp text,
    ordered_at timestamptz NOT NULL DEFAULT now(),
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE order_address (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id uuid NOT NULL UNIQUE REFERENCES customer_order(id) ON DELETE CASCADE,
    recipient_name text,
    phone_number text,
    street_line_1 text NOT NULL,
    street_line_2 text,
    landmark text,
    city text NOT NULL,
    state text NOT NULL,
    postal_code text NOT NULL,
    country text NOT NULL,
    latitude double precision,
    longitude double precision,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE order_item (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id uuid NOT NULL REFERENCES customer_order(id) ON DELETE CASCADE,
    product_id uuid NOT NULL REFERENCES product(id) ON DELETE RESTRICT,
    product_variant_id uuid REFERENCES product_variant(id) ON DELETE RESTRICT,
    combo_offer_id uuid REFERENCES combo_offer(id) ON DELETE RESTRICT,
    bogo_offer_id uuid REFERENCES bogo_offer(id) ON DELETE RESTRICT,
    product_name_snapshot text NOT NULL,
    product_image_url_snapshot text,
    variant_label_snapshot text,
    quantity integer NOT NULL,
    unit_price numeric(12,2) NOT NULL,
    total_price numeric(12,2) NOT NULL,
    is_free_item boolean NOT NULL DEFAULT false,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE payment_transaction (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id uuid NOT NULL REFERENCES customer_order(id) ON DELETE RESTRICT,
    user_id uuid NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    idempotency_key text NOT NULL,
    gateway_name text NOT NULL,
    gateway_order_id text UNIQUE,
    gateway_payment_id text UNIQUE,
    amount numeric(12,2) NOT NULL,
    currency_code text NOT NULL DEFAULT 'INR',
    payment_status text NOT NULL CHECK (payment_status IN ('pending', 'success', 'failed', 'refunded')),
    gateway_status text,
    failure_reason text,
    paid_at timestamptz,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT payment_transaction_idempotency_unique UNIQUE (idempotency_key)
);

CREATE TABLE idempotency_record (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    scope text NOT NULL,
    idempotency_key text NOT NULL,
    user_id uuid REFERENCES app_user(id) ON DELETE RESTRICT,
    order_id uuid REFERENCES customer_order(id) ON DELETE RESTRICT,
    payment_transaction_id uuid REFERENCES payment_transaction(id) ON DELETE RESTRICT,
    request_hash text,
    response_reference text,
    created_at timestamptz NOT NULL DEFAULT now(),
    expires_at timestamptz,
    CONSTRAINT idempotency_scope_key_unique UNIQUE (scope, idempotency_key)
);

CREATE TABLE refund_record (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id uuid NOT NULL REFERENCES customer_order(id) ON DELETE RESTRICT,
    payment_transaction_id uuid NOT NULL REFERENCES payment_transaction(id) ON DELETE RESTRICT,
    user_id uuid NOT NULL REFERENCES app_user(id) ON DELETE RESTRICT,
    gateway_refund_id text UNIQUE,
    amount numeric(12,2) NOT NULL,
    refund_status text NOT NULL CHECK (refund_status IN ('pending', 'success', 'failed')),
    failure_reason text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE admin_audit_log (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    actor_user_id uuid REFERENCES app_user(id) ON DELETE RESTRICT,
    action text NOT NULL,
    entity_type text NOT NULL,
    entity_id uuid,
    metadata jsonb,
    created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE product_search_document (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id uuid NOT NULL UNIQUE REFERENCES product(id) ON DELETE CASCADE,
    search_text text NOT NULL,
    built_at timestamptz NOT NULL DEFAULT now(),
    source_created_at timestamptz NOT NULL,
    source_updated_at timestamptz NOT NULL
);

CREATE TABLE product_search_rebuild_job (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id uuid NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    reason text NOT NULL,
    job_status text NOT NULL DEFAULT 'pending' CHECK (job_status IN ('pending', 'running', 'succeeded', 'failed')),
    attempt_count integer NOT NULL DEFAULT 0,
    scheduled_at timestamptz NOT NULL DEFAULT now(),
    started_at timestamptz,
    finished_at timestamptz,
    last_error text,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_user_address_user_id ON user_address (user_id);

CREATE INDEX idx_sub_category_category_status_created
    ON sub_category (category_id, status, created_at DESC, id DESC);

CREATE INDEX idx_product_category_status_created
    ON product (category_id, status, created_at DESC, id DESC)
    INCLUDE (name, primary_image_url);

CREATE INDEX idx_product_status_created
    ON product (status, created_at DESC, id DESC)
    INCLUDE (category_id, name, primary_image_url);

CREATE INDEX idx_product_variant_product_sort
    ON product_variant (product_id, sort_order, id);

CREATE INDEX idx_product_sub_category_product_sub
    ON product_sub_category (product_id, sub_category_id);

CREATE INDEX idx_product_sub_category_sub_product
    ON product_sub_category (sub_category_id, product_id);

CREATE INDEX idx_banner_status_window_priority
    ON banner (status, starts_at, ends_at, priority DESC, id DESC);

CREATE INDEX idx_banner_placement_key_banner
    ON banner_placement (placement_key, banner_id);

CREATE INDEX idx_coupon_status_window_code
    ON coupon (status, starts_at, ends_at, code);

CREATE INDEX idx_coupon_product_scope_coupon
    ON coupon_product_scope (coupon_id, product_id);

CREATE INDEX idx_category_offer_status_window_priority
    ON category_offer (status, starts_at, ends_at, priority DESC, id DESC);

CREATE INDEX idx_combo_offer_status_window_priority
    ON combo_offer (status, starts_at, ends_at, priority DESC, id DESC);

CREATE INDEX idx_bogo_offer_status_window_trigger
    ON bogo_offer (status, starts_at, ends_at, trigger_product_id, id DESC);

CREATE INDEX idx_delivery_rule_status_window_priority
    ON delivery_rule (status, starts_at, ends_at, priority DESC, id DESC);

CREATE INDEX idx_free_delivery_rule_status_window
    ON free_delivery_rule (status, starts_at, ends_at, id DESC);

CREATE INDEX idx_customer_order_user_ordered
    ON customer_order (user_id, ordered_at DESC, id DESC)
    INCLUDE (order_status, payment_status, final_amount);

CREATE INDEX idx_customer_order_status_ordered
    ON customer_order (order_status, ordered_at DESC, id DESC);

CREATE INDEX idx_payment_transaction_order_id
    ON payment_transaction (order_id);

CREATE INDEX idx_payment_transaction_user_created
    ON payment_transaction (user_id, created_at DESC, id DESC);

CREATE INDEX idx_refund_record_order_id
    ON refund_record (order_id);

CREATE INDEX idx_order_item_order_id
    ON order_item (order_id);

CREATE INDEX idx_product_search_document_trgm
    ON product_search_document
    USING gin (search_text gin_trgm_ops);

CREATE INDEX idx_product_search_document_source_created
    ON product_search_document (source_created_at DESC, product_id DESC);

CREATE INDEX idx_product_search_rebuild_job_status_scheduled
    ON product_search_rebuild_job (job_status, scheduled_at, id);

CREATE UNIQUE INDEX idx_product_search_rebuild_job_active
    ON product_search_rebuild_job (product_id)
    WHERE job_status IN ('pending', 'running');
