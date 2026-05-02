BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "banner" DROP CONSTRAINT "banner_fk_1";
ALTER TABLE "banner" DROP CONSTRAINT "banner_fk_2";
ALTER TABLE "banner" ADD COLUMN "offerId" text;
ALTER TABLE "banner" ADD COLUMN "comboOfferId" uuid;
ALTER TABLE "banner" ADD COLUMN "couponId" uuid;
ALTER TABLE "banner" ADD COLUMN "isBaseImage" boolean NOT NULL DEFAULT false;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "banner_linked_product" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "bannerId" uuid NOT NULL,
    "productId" uuid NOT NULL,
    "sortOrder" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "banner_linked_product_unique_idx" ON "banner_linked_product" USING btree ("bannerId", "productId");
CREATE INDEX "banner_linked_product_banner_sort_idx" ON "banner_linked_product" USING btree ("bannerId", "sortOrder", "id");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "coupon" ADD COLUMN "couponCategory" text NOT NULL DEFAULT 'All'::text;
ALTER TABLE "coupon" ADD COLUMN "loyaltyRequiredOrders" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "delivery_config" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "configKey" text NOT NULL,
    "baseDeliveryFee" double precision NOT NULL,
    "freeDeliveryThreshold" double precision,
    "isActive" boolean NOT NULL DEFAULT true,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE UNIQUE INDEX "delivery_config_key_idx" ON "delivery_config" USING btree ("configKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "delivery_slab" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "configId" uuid NOT NULL,
    "minOrderAmount" double precision NOT NULL,
    "maxOrderAmount" double precision NOT NULL,
    "fee" double precision NOT NULL,
    "sortOrder" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX "delivery_slab_config_sort_idx" ON "delivery_slab" USING btree ("configId", "sortOrder", "id");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_3"
    FOREIGN KEY("linkedCategoryId")
    REFERENCES "category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_4"
    FOREIGN KEY("linkedSubCategoryId")
    REFERENCES "sub_category"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_1"
    FOREIGN KEY("comboOfferId")
    REFERENCES "combo_offer"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner"
    ADD CONSTRAINT "banner_fk_2"
    FOREIGN KEY("couponId")
    REFERENCES "coupon"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "banner_linked_product"
    ADD CONSTRAINT "banner_linked_product_fk_0"
    FOREIGN KEY("bannerId")
    REFERENCES "banner"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "banner_linked_product"
    ADD CONSTRAINT "banner_linked_product_fk_1"
    FOREIGN KEY("productId")
    REFERENCES "product"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "delivery_slab"
    ADD CONSTRAINT "delivery_slab_fk_0"
    FOREIGN KEY("configId")
    REFERENCES "delivery_config"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR freshpickkat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('freshpickkat', '20260429132531408', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260429132531408', "timestamp" = now();

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
