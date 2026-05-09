BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "customer_order" ADD COLUMN "analyticsProcessedAt" timestamp without time zone;
CREATE INDEX "customer_order_payment_ordered_idx" ON "customer_order" USING btree ("paymentStatus", "orderedAt", "id");
CREATE INDEX "customer_order_user_payment_ordered_idx" ON "customer_order" USING btree ("userId", "paymentStatus", "orderedAt", "id");
--
-- ACTION ALTER TABLE
--
CREATE INDEX "order_item_product_idx" ON "order_item" USING btree ("productId");
CREATE INDEX "order_item_product_order_idx" ON "order_item" USING btree ("productId", "orderId");
--
-- ACTION ALTER TABLE
--
ALTER TABLE "product" ADD COLUMN "last7DaysSold" bigint NOT NULL DEFAULT 0;
ALTER TABLE "product" ADD COLUMN "last7DaysViews" bigint NOT NULL DEFAULT 0;
ALTER TABLE "product" ADD COLUMN "reorderCount" bigint NOT NULL DEFAULT 0;
ALTER TABLE "product" ADD COLUMN "trendingScore" double precision NOT NULL DEFAULT 0;
CREATE INDEX "product_trending_score_idx" ON "product" USING btree ("trendingScore", "id");
CREATE INDEX "product_most_purchase_count_idx" ON "product" USING btree ("mostPurchaseCount", "id");
CREATE INDEX "product_most_search_count_idx" ON "product" USING btree ("mostSearchCount", "id");
CREATE INDEX "product_reorder_count_idx" ON "product" USING btree ("reorderCount", "id");

--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260509084817628', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260509084817628', "timestamp" = now();

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
