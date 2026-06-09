BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "banner" DROP CONSTRAINT "banner_fk_0";
ALTER TABLE "banner" DROP CONSTRAINT "banner_fk_1";
ALTER TABLE "banner" DROP CONSTRAINT "banner_fk_2";
ALTER TABLE "banner" DROP CONSTRAINT "banner_fk_3";
ALTER TABLE "banner" DROP CONSTRAINT "banner_fk_4";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "banner_linked_product" DROP CONSTRAINT "banner_linked_product_fk_1";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "bogo_offer" DROP CONSTRAINT "bogo_offer_fk_0";
ALTER TABLE "bogo_offer" DROP CONSTRAINT "bogo_offer_fk_1";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "bogo_offer_reward" DROP CONSTRAINT "bogo_offer_reward_fk_1";
ALTER TABLE "bogo_offer_reward" DROP CONSTRAINT "bogo_offer_reward_fk_2";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "category_offer" DROP CONSTRAINT "category_offer_fk_0";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "category_offer_product_exclusion" DROP CONSTRAINT "category_offer_product_exclusion_fk_1";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "category_offer_product_scope" DROP CONSTRAINT "category_offer_product_scope_fk_1";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "combo_offer_item" DROP CONSTRAINT "combo_offer_item_fk_1";
ALTER TABLE "combo_offer_item" DROP CONSTRAINT "combo_offer_item_fk_2";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "complaint" DROP CONSTRAINT "complaint_fk_2";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "coupon_product_scope" DROP CONSTRAINT "coupon_product_scope_fk_1";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "customer_order" DROP CONSTRAINT "customer_order_fk_1";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "free_delivery_rule" DROP CONSTRAINT "free_delivery_rule_fk_0";
ALTER TABLE "free_delivery_rule" DROP CONSTRAINT "free_delivery_rule_fk_1";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "idempotency_record" DROP CONSTRAINT "idempotency_record_fk_0";
ALTER TABLE "idempotency_record" DROP CONSTRAINT "idempotency_record_fk_1";
ALTER TABLE "idempotency_record" DROP CONSTRAINT "idempotency_record_fk_2";
--
-- ACTION ALTER TABLE
--
ALTER TABLE "refund_record" DROP CONSTRAINT "refund_record_fk_3";

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260609043014099', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260609043014099', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
