-- ============================================================
-- Database User Permissions Setup
-- ============================================================
-- Run this as a superuser (e.g. postgres) to create a dedicated
-- app user with restricted DELETE privileges.
--
-- Usage:
--   psql -U postgres -d freshpickkat_db -f setup_db_permissions.sql
-- ============================================================

-- 1. Create app user (if not exists)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'freshpick_app') THEN
    CREATE ROLE freshpick_app LOGIN PASSWORD 'change_this_to_a_secure_password';
  END IF;
END
$$;

-- 2. Grant schema usage
GRANT USAGE ON SCHEMA public TO freshpick_app;

-- 3. Grant SELECT, INSERT, UPDATE on ALL tables
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO freshpick_app;

-- 4. Grant DELETE only on safe junction tables (hard-delete is intentional here)
GRANT DELETE ON TABLE combo_offer_item TO freshpick_app;
GRANT DELETE ON TABLE banner_placement TO freshpick_app;
GRANT DELETE ON TABLE banner_linked_product TO freshpick_app;
GRANT DELETE ON TABLE bogo_offer_reward TO freshpick_app;
GRANT DELETE ON TABLE category_offer_product_scope TO freshpick_app;
GRANT DELETE ON TABLE category_offer_product_exclusion TO freshpick_app;
GRANT DELETE ON TABLE coupon_product_scope TO freshpick_app;
GRANT DELETE ON TABLE delivery_slab TO freshpick_app;
GRANT DELETE ON TABLE product_sub_category TO freshpick_app;
GRANT DELETE ON TABLE product_search_document TO freshpick_app;
GRANT DELETE ON TABLE product_search_rebuild_job TO freshpick_app;
GRANT DELETE ON TABLE notification_outbox TO freshpick_app;

-- 5. Revoke DELETE from core tables where only soft-delete is allowed
REVOKE DELETE ON TABLE product FROM freshpick_app;
REVOKE DELETE ON TABLE product_variant FROM freshpick_app;
REVOKE DELETE ON TABLE category FROM freshpick_app;
REVOKE DELETE ON TABLE sub_category FROM freshpick_app;
REVOKE DELETE ON TABLE customer_order FROM freshpick_app;
REVOKE DELETE ON TABLE order_item FROM freshpick_app;
REVOKE DELETE ON TABLE app_user FROM freshpick_app;
REVOKE DELETE ON TABLE coupon FROM freshpick_app;
REVOKE DELETE ON TABLE combo_offer FROM freshpick_app;
REVOKE DELETE ON TABLE bogo_offer FROM freshpick_app;
REVOKE DELETE ON TABLE category_offer FROM freshpick_app;
REVOKE DELETE ON TABLE banner FROM freshpick_app;
REVOKE DELETE ON TABLE delivery_rule FROM freshpick_app;
REVOKE DELETE ON TABLE delivery_config FROM freshpick_app;
REVOKE DELETE ON TABLE complaint FROM freshpick_app;
REVOKE DELETE ON TABLE refund_record FROM freshpick_app;
REVOKE DELETE ON TABLE payment_transaction FROM freshpick_app;
REVOKE DELETE ON TABLE user_address FROM freshpick_app;
REVOKE DELETE ON TABLE user_cart_item FROM freshpick_app;
REVOKE DELETE ON TABLE support_issue FROM freshpick_app;
REVOKE DELETE ON TABLE idempotency_record FROM freshpick_app;

-- 6. Default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE ON TABLES TO freshpick_app;

-- 7. Update production.yaml to use freshpick_app user instead of postgres
-- database:
--   user: freshpick_app
--   password: change_this_to_a_secure_password
-- ============================================================
